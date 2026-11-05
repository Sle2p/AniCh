import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart' as native;

/// AniCh's playback interface backed by the television's hardware video plane.
/// There is no bundled desktop mpv process on webOS.
class Media {
  const Media(this.uri, {this.httpHeaders = const {}});
  final String uri;
  final Map<String, String> httpHeaders;
}

class PlayerState {
  bool playing = false;
  bool buffering = false;
  bool completed = false;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  int? width;
  int? height;
}

class PlayerStreams {
  final _error = StreamController<String>.broadcast();
  final _completed = StreamController<bool>.broadcast();
  final _playing = StreamController<bool>.broadcast();
  final _buffering = StreamController<bool>.broadcast();
  final _position = StreamController<Duration>.broadcast();
  final _width = StreamController<int?>.broadcast();
  final _height = StreamController<int?>.broadcast();
  final _log = StreamController<String>.broadcast();
  Stream<String> get error => _error.stream;
  Stream<bool> get completed => _completed.stream;
  Stream<bool> get playing => _playing.stream;
  Stream<bool> get buffering => _buffering.stream;
  Stream<Duration> get position => _position.stream;
  Stream<int?> get width => _width.stream;
  Stream<int?> get height => _height.stream;
  Stream<String> get log => _log.stream;

  Future<void> close() async {
    await Future.wait([
      _error.close(),
      _completed.close(),
      _playing.close(),
      _buffering.close(),
      _position.close(),
      _width.close(),
      _height.close(),
      _log.close(),
    ]);
  }
}

class Player {
  final state = PlayerState();
  final stream = PlayerStreams();
  final changes = ValueNotifier<int>(0);
  native.VideoPlayerController? controller;
  int _generation = 0;
  bool _disposed = false;
  double _rate = 1;
  double get rate => _rate;
  String? _lastError;
  String? mediaUri;
  static const _smokeTest = int.fromEnvironment('ANICH_TV_SMOKE_ID') > 0;
  int _lastLoggedPosition = -1;
  Future<void> _closing = Future<void>.value();

  void _notify() {
    if (!_disposed) changes.value++;
  }

  void _sync() {
    final value = controller?.value;
    if (_disposed || value == null) return;
    if (value.hasError && value.errorDescription != _lastError) {
      _lastError = value.errorDescription;
      stream._error.add(_lastError ?? '电视播放器无法播放此视频');
    }
    if (state.playing != value.isPlaying) {
      state.playing = value.isPlaying;
      stream._playing.add(state.playing);
      if (_smokeTest) debugPrint('AniCh TV playback playing=${state.playing}');
    }
    if (state.buffering != value.isBuffering) {
      state.buffering = value.isBuffering;
      stream._buffering.add(state.buffering);
    }
    state.duration = value.duration;
    if (state.position != value.position) {
      state.position = value.position;
      stream._position.add(state.position);
      final progressBucket = state.position.inSeconds ~/ 5;
      if (_smokeTest && progressBucket != _lastLoggedPosition) {
        _lastLoggedPosition = progressBucket;
        debugPrint('AniCh TV playback position=${state.position.inSeconds}s');
      }
    }
    final width = value.isInitialized ? value.size.width.round() : null;
    final height = value.isInitialized ? value.size.height.round() : null;
    if (state.width != width) {
      state.width = width;
      stream._width.add(width);
    }
    if (state.height != height) {
      state.height = height;
      stream._height.add(height);
    }
    final completed = value.isInitialized &&
        value.duration > Duration.zero &&
        value.position >= value.duration &&
        !value.isPlaying;
    if (state.completed != completed) {
      state.completed = completed;
      stream._completed.add(completed);
    }
    _notify();
  }

  Future<void> _detachController() {
    final current = controller;
    controller = null;
    current?.removeListener(_sync);
    final previousClosing = _closing;
    final closing = () async {
      await previousClosing;
      // Some video_player implementations wait forever in dispose when native
      // create never returns. Do not let that block every subsequent source.
      await current?.dispose().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          if (_smokeTest) debugPrint('AniCh TV playback release timed out');
        },
      );
    }();
    // Keep later source switches usable even if a hardware release fails.
    _closing = closing.catchError((Object _) {});
    return closing;
  }

  Future<void> open(Media media) async {
    final uri = Uri.tryParse(media.uri);
    if (uri == null ||
        !uri.hasAuthority ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      throw const FormatException('播放地址无效，请切换线路');
    }
    if (media.httpHeaders.isNotEmpty) {
      throw UnsupportedError('此线路需要电视播放器暂不支持的请求头');
    }
    if (_disposed) return;
    final generation = ++_generation;
    final releasing = _detachController();
    state.playing = false;
    state.completed = false;
    state.position = Duration.zero;
    state.duration = Duration.zero;
    state.buffering = true;
    stream._playing.add(false);
    stream._buffering.add(true);
    stream._position.add(Duration.zero);
    _lastError = null;
    _lastLoggedPosition = -1;
    _notify();
    await releasing;
    if (_disposed || generation != _generation) return;
    final next = native.VideoPlayerController.networkUrl(uri);
    controller = next;
    mediaUri = media.uri;
    next.addListener(_sync);
    try {
      await next.initialize().timeout(const Duration(seconds: 45));
      if (_disposed || generation != _generation) return;
      try {
        await next.setPlaybackSpeed(_rate);
        if (_disposed || generation != _generation) return;
        await next.play();
      } catch (error) {
        final unsupported = error is UnsupportedError ||
            (error is PlatformException &&
                (error.code.toLowerCase().contains('unsupported') ||
                    error.code.toLowerCase().contains('not_supported') ||
                    ((error.message ?? '').toLowerCase().contains('speed') &&
                        (error.message ?? '')
                            .toLowerCase()
                            .contains('support'))));
        if (_disposed ||
            generation != _generation ||
            _rate == 1 ||
            !unsupported) rethrow;
        _rate = 1;
        await next.setPlaybackSpeed(1);
        if (_disposed || generation != _generation) return;
        await next.play();
        stream._log.add('当前线路不支持默认倍速，已恢复正常速度');
      }
      if (_disposed || generation != _generation) return;
      if (next.value.hasError) {
        throw StateError(next.value.errorDescription ?? '电视无法播放此线路');
      }
      _sync();
      if (_smokeTest) {
        debugPrint(
          'AniCh TV playback initialized ${state.width}x${state.height} duration=${state.duration.inSeconds}s',
        );
      }
    } catch (error) {
      if (!_disposed && generation == _generation) {
        final releasing = _detachController();
        state.buffering = false;
        stream._buffering.add(false);
        _notify();
        await releasing;
        rethrow;
      }
    }
  }

  Future<void> play() async => controller?.play();
  Future<void> pause() async => controller?.pause();
  Future<void> stop() async {
    if (_disposed) return;
    _generation++;
    final releasing = _detachController();
    state.playing = false;
    state.buffering = false;
    state.completed = false;
    state.position = Duration.zero;
    state.duration = Duration.zero;
    stream._playing.add(false);
    stream._buffering.add(false);
    stream._position.add(Duration.zero);
    _notify();
    await releasing;
  }

  Future<void> seek(Duration position) async {
    final milliseconds = position.inMilliseconds.clamp(
      0,
      state.duration.inMilliseconds,
    );
    await controller?.seekTo(Duration(milliseconds: milliseconds.toInt()));
  }

  Future<void> setRate(double rate) async {
    final current = controller;
    final previous = _rate;
    try {
      await current?.setPlaybackSpeed(rate);
      _rate = rate;
    } catch (_) {
      // video_player updates its value before invoking the platform. Restore
      // that value too, so a rejected speed does not break the next play().
      if (identical(current, controller)) {
        await current?.setPlaybackSpeed(previous);
      }
      rethrow;
    }
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _generation++;
    await _detachController();
    await stream.close();
    changes.dispose();
  }
}

class VideoController {
  const VideoController(this.player);
  final Player player;
}

class Video extends StatefulWidget {
  const Video({
    super.key,
    required this.controller,
    this.controls,
    this.aspectRatio,
    this.fit = BoxFit.contain,
    this.pauseUponEnteringBackgroundMode = true,
    this.resumeUponEnteringForegroundMode = true,
  });
  final VideoController controller;
  final Widget Function(VideoState)? controls;
  final double? aspectRatio;
  final BoxFit fit;
  final bool pauseUponEnteringBackgroundMode;
  final bool resumeUponEnteringForegroundMode;
  @override
  State<Video> createState() => VideoState();
}

/// The intersection is the visible area for contain/fill/cover and custom ratios.
/// The native video and its overlays must use this same local rectangle.
Rect videoViewportRect(Size viewport, double aspectRatio, BoxFit fit) {
  if (viewport.isEmpty ||
      !viewport.width.isFinite ||
      !viewport.height.isFinite) {
    return Rect.zero;
  }
  final ratio = aspectRatio.isFinite && aspectRatio > 0 ? aspectRatio : 16 / 9;
  final destination = applyBoxFit(fit, Size(ratio, 1), viewport).destination;
  return Alignment.center
      .inscribe(destination, Offset.zero & viewport)
      .intersect(Offset.zero & viewport);
}

class VideoState extends State<Video> with WidgetsBindingObserver {
  double? _aspectRatio;
  BoxFit? _fit;
  bool _resume = false;

  void update({double? aspectRatio, BoxFit? fit}) {
    if (mounted) {
      setState(() {
        _aspectRatio = aspectRatio;
        _fit = fit;
      });
    }
  }

  Rect videoRectFor(Size viewport) {
    final ratio = _aspectRatio ??
        widget.aspectRatio ??
        widget.controller.player.controller?.value.aspectRatio ??
        16 / 9;
    return videoViewportRect(viewport, ratio, _fit ?? widget.fit);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final player = widget.controller.player;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (widget.pauseUponEnteringBackgroundMode) {
        _resume = _resume || player.state.playing;
        unawaited(player.pause());
      }
    } else if (state == AppLifecycleState.resumed && _resume) {
      _resume = false;
      if (widget.resumeUponEnteringForegroundMode) unawaited(player.play());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.controller.player;
    return _PlayerScope(
      player: player,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // The LG widget punches a transparent hole through this Flutter surface.
          // Controls and danmaku stay above the separate native video plane.
          ValueListenableBuilder<int>(
            valueListenable: player.changes,
            builder: (context, _, child) {
              final video = player.controller;
              if (video == null || !video.value.isInitialized) {
                return const ColoredBox(color: Colors.black);
              }
              return ColoredBox(
                color: Colors.black,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final size = videoRectFor(constraints.biggest).size;
                    return Center(
                      child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: native.VideoPlayer(video),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (widget.controls != null) widget.controls!(this),
        ],
      ),
    );
  }
}

class _PlayerScope extends InheritedWidget {
  const _PlayerScope({required this.player, required super.child});
  final Player player;
  static Player of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_PlayerScope>()!.player;
  @override
  bool updateShouldNotify(_PlayerScope oldWidget) => oldWidget.player != player;
}

class MaterialPositionIndicator extends StatelessWidget {
  const MaterialPositionIndicator({super.key, this.style});
  final TextStyle? style;
  String _time(Duration value) => value.toString().split('.').first;
  @override
  Widget build(BuildContext context) {
    final player = _PlayerScope.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: player.changes,
      builder: (context, _, child) => Text(
        '${_time(player.state.position)} / ${_time(player.state.duration)}',
        style: style,
      ),
    );
  }
}

class MaterialSeekBar extends StatefulWidget {
  const MaterialSeekBar({super.key});
  @override
  State<MaterialSeekBar> createState() => _MaterialSeekBarState();
}

class _MaterialSeekBarState extends State<MaterialSeekBar> {
  double? _dragPosition;
  @override
  Widget build(BuildContext context) {
    final player = _PlayerScope.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: player.changes,
      builder: (context, _, child) {
        final duration = player.state.duration.inMilliseconds.toDouble();
        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            thumbColor: Colors.white,
            overlayColor: Colors.white24,
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
          ),
          child: Slider(
            min: 0,
            max: duration > 0 ? duration : 1,
            value: (_dragPosition ??
                    player.state.position.inMilliseconds.toDouble())
                .clamp(0, duration > 0 ? duration : 1)
                .toDouble(),
            onChanged: duration <= 0
                ? null
                : (value) => setState(() => _dragPosition = value),
            onChangeEnd: (value) {
              unawaited(player.seek(Duration(milliseconds: value.round())));
              setState(() => _dragPosition = null);
            },
          ),
        );
      },
    );
  }
}

class MaterialPlayOrPauseButton extends StatelessWidget {
  const MaterialPlayOrPauseButton({super.key});
  @override
  Widget build(BuildContext context) {
    final player = _PlayerScope.of(context);
    return ValueListenableBuilder<int>(
      valueListenable: player.changes,
      builder: (context, _, child) => IconButton(
        tooltip: player.state.playing ? '暂停' : '播放',
        onPressed: () => player.state.playing ? player.pause() : player.play(),
        icon: Icon(
          player.state.playing ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
    );
  }
}
