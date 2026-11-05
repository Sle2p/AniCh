import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'src/messages.g.dart';
import 'src/hole.dart';

/////////////////////////////////////////////////////////////////////
////                        Widget                               ////
/////////////////////////////////////////////////////////////////////
enum TimerStage { init, clearRect, setRect }

class _VideoWidget extends StatefulWidget {
  final int textureId;
  final VideoPlayerWebOs player;
  _VideoWidget({required this.textureId, required this.player});

  @override
  State<_VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<_VideoWidget> {
  final GlobalKey _videoBoxKey = GlobalKey();

  void reExport() {
    if (!mounted) return;
    _resetRect(true);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.player.addWidgetState(widget.textureId, this);
    WidgetsBinding.instance.addPostFrameCallback(_afterFrameLayout);
  }

  @override
  Widget build(BuildContext context) {
    bool ready = widget.player.isReady(widget.textureId);
    if (!ready) {
      _resetRect(true);
      _exported = false;
    }
    return Container(
      key: _videoBoxKey,
      color: const Color(0xff000000),
      child: ready && _exported && !_moving ? const Hole() : Container(),
    );
  }

  void _afterFrameLayout(_) {
    if (!mounted) return;
    bool ready = widget.player.isReady(widget.textureId);
    final box = _videoBoxKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      if (ready) {
        final pos = box.localToGlobal(Offset.zero);
        // LG's exported-window channel expects physical destination pixels.
        // Convert before caching so a DPR change also re-exports the rectangle.
        // The source video size and Flutter's Hole remain in their own spaces.
        final pixelRatio = View.of(context).devicePixelRatio;
        double x = pos.dx * pixelRatio;
        double y = pos.dy * pixelRatio;
        double w = box.size.width * pixelRatio;
        double h = box.size.height * pixelRatio;
        if (!x.isNaN && !y.isNaN) {
          _rectChanged(x, y, w, h);
        }
      } else {
        _resetRect(true);
        _exported = false;
        setState(() {});
      }
    }
    WidgetsBinding.instance.addPostFrameCallback(_afterFrameLayout);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.player.removeWidgetState(widget.textureId, this);
    super.dispose();
  }

  final int kMovingTimerMiliseconds = 100;
  TimerStage _timerStage = TimerStage.init;
  bool _moving = false;
  double _x = 0;
  double _y = 0;
  double _w = 0;
  double _h = 0;
  Timer? _timer;
  bool _dirty = false;
  bool _exported = false;

  void _resetRect(bool deep) {
    _timerStage = TimerStage.init;
    _moving = false;
    if (deep) {
      _x = 0;
      _y = 0;
      _w = 0;
      _h = 0;
    }
    _timer?.cancel();
    _timer = null;
    _dirty = false;
  }

  void _rectChanged(double x, double y, double w, double h) {
    if (x == _x && y == _y && w == _w && h == _h) {
      return;
    }

    _x = x;
    _y = y;
    _w = w;
    _h = h;
    if (_timer != null) {
      _dirty = true;
      return;
    }

    // start moving
    _resetRect(false);
    _moving = true;
    if (!_exported) {
      _timerStage = TimerStage.setRect;
      _exported = true;
      widget.player.viewRect(widget.textureId, _x, _y, _w, _h);
    }
    setState(() {});

    _timer = Timer.periodic(Duration(milliseconds: kMovingTimerMiliseconds), (
      _,
    ) {
      if (!mounted) {
        _timer?.cancel();
        return;
      }
      if (_dirty) {
        _dirty = false;
        _timerStage = TimerStage.clearRect;
      } else {
        if (_timerStage != TimerStage.setRect) {
          // set exported region
          _timerStage = TimerStage.setRect;
          _exported = true;
          widget.player.viewRect(widget.textureId, _x, _y, _w, _h);
        } else {
          // stop moving
          _resetRect(false);
          setState(() {});
        }
      }
    });
  }
} // end of class

/////////////////////////////////////////////////////////////////////
//                        VideoPlayer                              //
/////////////////////////////////////////////////////////////////////
class VideoPlayerWebOs extends VideoPlayerPlatform {
  final WebOsVideoPlayerApi _api = WebOsVideoPlayerApi();
  final _lifeCycleObserver = _LifeCycleObserver();

  final _windowChannel = const MethodChannel('webos/exported_windows');
  final _auxChannel = const MethodChannel('videoplayer_webos');
  Map _windowIds = {}; // <texture_id, window_id>
  Map _widgetStates = {}; // <texture_id, _VideoWidgetState>
  Map _srcSizes = {}; // <texture_id, Size>
  bool _hidden = false;

  /// Registers this class as the default platform instance.
  static void registerWith() {
    VideoPlayerPlatform.instance = VideoPlayerWebOs();
  }

  @override
  Future<void> init() {
    _windowIds.clear();
    _widgetStates.clear();
    _srcSizes.clear();

    _lifeCycleObserver.initialize(this);
    return _api.initialize();
  }

  @override
  Future<void> dispose(int textureId) {
    _dispose(textureId);
    return _api.dispose(TextureMessage(textureId: textureId));
  }

  void _dispose(int textureId) async {
    _widgetStates.remove(textureId);

    if (_windowIds.containsKey(textureId)) {
      var winId = _windowIds[textureId];
      _windowIds.remove(textureId);
      _srcSizes.remove(textureId);

      // exported window dispose
      if (winId != null) {
        _windowChannel.invokeMethod<void>('dispose', {'windowId': winId});
      }
      print('video_player_webos($textureId) $winId disposed');
    }
  }

  @override
  Future<int?> create(DataSource dataSource) async {
    String? asset;
    String? packageName;
    String? uri;
    String? formatHint;
    Map<String, String> httpHeaders = <String, String>{};
    switch (dataSource.sourceType) {
      case DataSourceType.asset:
        asset = dataSource.asset;
        packageName = dataSource.package;
        break;
      case DataSourceType.network:
        uri = dataSource.uri;
        formatHint = _videoFormatStringMap[dataSource.formatHint];
        httpHeaders = dataSource.httpHeaders;
        break;
      case DataSourceType.file:
        uri = dataSource.uri;
        httpHeaders = dataSource.httpHeaders;
        break;
      case DataSourceType.contentUri:
        uri = dataSource.uri;
        break;
    }

    String? windowId = await _windowChannel.invokeMethod<String>('create', {});
    final CreateMessage message = CreateMessage(
      windowId: windowId ?? 'invalid',
      asset: asset,
      packageName: packageName,
      uri: uri,
      httpHeaders: httpHeaders,
      formatHint: formatHint,
    );

    final TextureMessage response = await _api.create(message);
    var texId = response.textureId;

    // exported window create
    _windowIds[texId] = windowId;
    _srcSizes[texId] = Size(0, 0);
    print('video_player_webos($texId) $windowId created');

    if (_hidden) {
      _windowIds[texId] = null;
      if (windowId != null) {
        _auxChannel.invokeMethod<void>('unload', {'textureId': texId});

        _windowChannel.invokeMethod<void>('dispose', {'windowId': windowId});
      }
      print('video_player_webos($texId) $windowId disposed by hidden');
    }
    return texId;
  }

  @override
  Future<void> setLooping(int textureId, bool looping) {
    return _api.setLooping(
      LoopingMessage(textureId: textureId, isLooping: looping),
    );
  }

  @override
  Future<void> play(int textureId) {
    return _api.play(TextureMessage(textureId: textureId));
  }

  @override
  Future<void> pause(int textureId) {
    return _api.pause(TextureMessage(textureId: textureId));
  }

  @override
  Future<void> setVolume(int textureId, double volume) async {
    // video_player applies its default volume during initialize(). The webOS
    // media service has no per-player volume; leave the TV's volume unchanged.
    if (volume == 1.0) return;
    throw PlatformException(
      code: 'unsupported',
      message:
          'Per-player volume is not supported on webOS. Use the TV remote.',
    );
  }

  @override
  Future<void> setPlaybackSpeed(int textureId, double speed) {
    assert(speed > 0);

    return _api.setPlaybackSpeed(
      PlaybackSpeedMessage(textureId: textureId, speed: speed),
    );
  }

  @override
  Future<void> seekTo(int textureId, Duration position) {
    return _api.seekTo(
      PositionMessage(textureId: textureId, position: position.inMilliseconds),
    );
  }

  @override
  Future<Duration> getPosition(int textureId) async {
    final PositionMessage response = await _api.position(
      TextureMessage(textureId: textureId),
    );
    return Duration(milliseconds: response.position);
  }

  @override
  Stream<VideoEvent> videoEventsFor(int textureId) {
    return _eventChannelFor(textureId).receiveBroadcastStream().map((
      dynamic event,
    ) {
      final Map<dynamic, dynamic> map = event as Map<dynamic, dynamic>;
      switch (map['event']) {
        case 'initialized':
          Size size = Size(
            (map['width'] as num?)?.toDouble() ?? 0.0,
            (map['height'] as num?)?.toDouble() ?? 0.0,
          );
          // exported window set Size
          _srcSizes[textureId] = size;
          _widgetStates[textureId]?.reExport();
          return VideoEvent(
            eventType: VideoEventType.initialized,
            duration: Duration(milliseconds: map['duration'] as int),
            size: size,
            rotationCorrection: map['rotationCorrection'] as int? ?? 0,
          );
        case 'completed':
          return VideoEvent(eventType: VideoEventType.completed);
        case 'bufferingUpdate':
          final List<dynamic> values = map['values'] as List<dynamic>;

          return VideoEvent(
            buffered: values.map<DurationRange>(_toDurationRange).toList(),
            eventType: VideoEventType.bufferingUpdate,
          );
        case 'bufferingStart':
          return VideoEvent(eventType: VideoEventType.bufferingStart);
        case 'bufferingEnd':
          return VideoEvent(eventType: VideoEventType.bufferingEnd);
        case 'isPlayingStateUpdate':
          return VideoEvent(
            eventType: VideoEventType.isPlayingStateUpdate,
            isPlaying: map['isPlaying'] as bool,
          );

        // webOS Custom Events
        case 'onError':
          _dispose(textureId);
          return VideoEvent(eventType: VideoEventType.unknown);

        default:
          return VideoEvent(eventType: VideoEventType.unknown);
      }
    });
  }

  @override
  Widget buildView(int textureId) {
    return _VideoWidget(textureId: textureId, player: this);
  }

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) {
    return _api.setMixWithOthers(
      MixWithOthersMessage(mixWithOthers: mixWithOthers),
    );
  }

  EventChannel _eventChannelFor(int textureId) {
    return EventChannel('flutter.io/videoPlayer/videoEvents$textureId');
  }

  static const Map<VideoFormat, String> _videoFormatStringMap =
      <VideoFormat, String>{
        VideoFormat.ss: 'ss',
        VideoFormat.hls: 'hls',
        VideoFormat.dash: 'dash',
        VideoFormat.other: 'other',
      };

  DurationRange _toDurationRange(dynamic value) {
    final List<dynamic> pair = value as List<dynamic>;
    return DurationRange(
      Duration(milliseconds: pair[0] as int),
      Duration(milliseconds: pair[1] as int),
    );
  }

  //-----------------------------------------------------------------//
  //                     from LifeCycleObserver                      //
  //-----------------------------------------------------------------//
  Future<void> onResumed() async {
    if (_hidden == true) {
      _hidden = false;

      // clone _windowIds
      Map winIds = {};
      _windowIds.forEach((texId, winId) async {
        winIds[texId] = winId;
      });

      winIds.forEach((texId, winId) async {
        if (winId == null) {
          String? windowId = await _windowChannel.invokeMethod<String>(
            'create',
            {},
          );
          _windowIds[texId] = windowId ?? 'invalid';
          print(
            'video_player_webos($texId) $windowId created by onHidden to onResumed',
          );

          _auxChannel.invokeMethod<void>('reload', {
            'textureId': texId,
            'windowId': windowId ?? 'invalid',
          });

          _widgetStates[texId]?.reExport();
        }
      });
    }
  }

  Future<void> onHidden() async {
    if (_hidden == false) {
      _hidden = true;

      // clone _windowIds
      Map winIds = {};
      _windowIds.forEach((texId, winId) async {
        winIds[texId] = winId;
      });
      for (var texId in winIds.keys) {
        _windowIds[texId] = null;
      }

      winIds.forEach((texId, winId) async {
        _auxChannel.invokeMethod<void>('unload', {'textureId': texId});
        if (winId != null) {
          _windowChannel.invokeMethod<void>('dispose', {'windowId': winId});
        }
        print('video_player_webos($texId) $winId disposed by onHidden');
      });
    }
  }

  //-----------------------------------------------------------------//
  //                     from _VideoWidgetState                      //
  //-----------------------------------------------------------------//
  void addWidgetState(int texId, _VideoWidgetState state) {
    _widgetStates[texId] = state;
  }

  void removeWidgetState(int texId, _VideoWidgetState state) {
    if (identical(_widgetStates[texId], state)) _widgetStates.remove(texId);
  }

  Future<void> viewRect(int texId, double x, double y, double w, double h) {
    var winId = _windowIds[texId] ?? 'invalid';
    var size = _srcSizes[texId] ?? Size(0, 0);
    var sw = size.width.round();
    var sh = size.height.round();
    var dx = x.round();
    var dy = y.round();
    var dw = w.round();
    var dh = h.round();
    print(
      'video_player_webos($texId) $winId resize([$sw, $sh] -> [$dx, $dy, $dw, $dh])',
    );

    return _windowChannel.invokeMethod<void>('resize', {
      'windowId': winId,
      'srcRect': [0, 0, sw, sh],
      'dstRect': [dx, dy, dw, dh],
    });
  }

  bool isReady(int texId) {
    var size = _srcSizes[texId] ?? Size(0, 0);
    if (size.width == 0 && size.height == 0) {
      return false;
    }
    return true;
  }
}

/////////////////////////////////////////////////////////////////////
//                    LifeCycleObserver                            //
/////////////////////////////////////////////////////////////////////
class _LifeCycleObserver {
  final _auxEventChannel = const EventChannel('webos/video_player/events');
  static AppLifecycleState _lifeState = AppLifecycleState.inactive;
  static StreamSubscription? _eventStreamSubscription;
  static VideoPlayerWebOs? _player;

  void initialize(VideoPlayerWebOs player) {
    _player ??= player;
    _eventStreamSubscription ??= _getEventStream().listen((_) {});
  }

  void _didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_lifeState == state) {
      return;
    }

    _lifeState = state;
    if (_lifeState == AppLifecycleState.resumed) {
      _player?.onResumed();
    } else if (_lifeState == AppLifecycleState.hidden) {
      _player?.onHidden();
    }
  }

  Stream<void> _getEventStream() {
    return _auxEventChannel.receiveBroadcastStream().map((dynamic event) {
      var map = event as Map<dynamic, dynamic>;
      var eventType = map['event'] as String;
      switch (eventType) {
        case 'appLifecycleState':
          {
            var state = map['state'] as String;
            if (state == 'AppLifecycleState.inactive' ||
                state == 'AppLifecycleState.resumed') {
              _didChangeAppLifecycleState(AppLifecycleState.resumed);
            } else if (state == 'AppLifecycleState.hidden') {
              _didChangeAppLifecycleState(AppLifecycleState.hidden);
            } else if (state == 'AppLifecycleState.paused') {
              _didChangeAppLifecycleState(AppLifecycleState.paused);
            } else if (state == 'AppLifecycleState.detached') {
              _didChangeAppLifecycleState(AppLifecycleState.detached);
            }
          }
          break;
        default:
          break;
      }
    });
  }
}
