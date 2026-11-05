import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:video_player_webos/video_player_webos.dart';
import 'package:xs/src/widgets/player/webos_player.dart' as anich;

// Keep LG's real setVolume implementation while replacing the hardware channel.
// This exercises the default volume applied by VideoPlayerController.initialize,
// which previously caused an uncaught unsupported error before first playback.
class _InitializedTvPlayer extends VideoPlayerWebOs {
  Duration position = Duration.zero;
  double speed = 1;
  bool disposed = false;
  bool playing = false;
  @override
  Future<void> init() async {}
  @override
  Future<int?> create(DataSource source) async => 1;
  @override
  Stream<VideoEvent> videoEventsFor(int textureId) => Stream.value(
        VideoEvent(
          eventType: VideoEventType.initialized,
          duration: const Duration(minutes: 24),
          size: const Size(1920, 1080),
        ),
      );
  @override
  Future<void> setLooping(int textureId, bool looping) async {}
  @override
  Future<void> pause(int textureId) async {
    playing = false;
  }

  @override
  Future<void> play(int textureId) async {
    playing = true;
  }

  @override
  Future<void> seekTo(int textureId, Duration value) async {
    position = value;
  }

  @override
  Future<Duration> getPosition(int textureId) async => position;
  @override
  Future<void> setPlaybackSpeed(int textureId, double value) async {
    speed = value;
  }

  @override
  Future<void> dispose(int textureId) async {
    disposed = true;
  }
}

class _UnitRateTvPlayer extends _InitializedTvPlayer {
  @override
  Future<void> setPlaybackSpeed(int textureId, double value) async {
    if (value != 1) throw UnsupportedError('Playback speed is not supported');
    speed = value;
  }
}

class _NeverCreatesTvPlayer extends _InitializedTvPlayer {
  final pendingCreate = Completer<int?>();
  @override
  Future<int?> create(DataSource source) => pendingCreate.future;
}

void main() {
  testWidgets(
    'standard video_player initialization keeps TV volume unchanged',
    (tester) async {
      final previous = VideoPlayerPlatform.instance;
      final platform = _InitializedTvPlayer();
      VideoPlayerPlatform.instance = platform;
      final controller = VideoPlayerController.networkUrl(
        Uri.parse('https://example.com/video.m3u8'),
      );
      await tester.runAsync(() async {
        try {
          await controller.initialize();
          expect(controller.value.isInitialized, isTrue);
          expect(controller.value.hasError, isFalse);
          expect(tester.takeException(), isNull);
        } finally {
          await controller.dispose();
          VideoPlayerPlatform.instance = previous;
        }
      });
    },
  );

  testWidgets(
    'AniCh forwards playback, bounded seeking, speed and disposal to TV',
    (tester) async {
      final previous = VideoPlayerPlatform.instance;
      final platform = _InitializedTvPlayer();
      VideoPlayerPlatform.instance = platform;
      final player = anich.Player();
      await tester.runAsync(() async {
        try {
          await player.open(const anich.Media('https://example.com/video.mp4'));
          expect(platform.playing, isTrue);
          expect(player.state.width, 1920);
          expect(player.state.duration, const Duration(minutes: 24));
          await player.seek(const Duration(seconds: -10));
          expect(platform.position, Duration.zero);
          await player.seek(const Duration(hours: 1));
          expect(platform.position, const Duration(minutes: 24));
          await player.setRate(1.5);
          expect(platform.speed, 1.5);
          await player.pause();
          expect(platform.playing, isFalse);
        } finally {
          await player.dispose();
          VideoPlayerPlatform.instance = previous;
        }
        expect(platform.disposed, isTrue);
      });
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a native create hang cannot permanently block source switching',
    (tester) async {
      final previous = VideoPlayerPlatform.instance;
      VideoPlayerPlatform.instance = _NeverCreatesTvPlayer();
      final player = anich.Player();
      try {
        final failure = expectLater(
          player.open(const anich.Media('https://example.com/hung.mp4')),
          throwsA(isA<TimeoutException>()),
        );
        await tester.pump();
        await tester.pump(const Duration(seconds: 45));
        await tester.pump(const Duration(seconds: 3));
        await failure;
        final working = _InitializedTvPlayer();
        VideoPlayerPlatform.instance = working;
        await tester.runAsync(() =>
            player.open(const anich.Media('https://example.com/working.mp4')));
        expect(working.playing, isTrue);
        expect(player.state.width, 1920);
      } finally {
        await tester.runAsync(player.dispose);
        VideoPlayerPlatform.instance = previous;
      }
    },
  );

  testWidgets(
      'unsupported stored speed falls back and rejected later changes restore normal playback',
      (tester) async {
    await tester.runAsync(() async {
      final previous = VideoPlayerPlatform.instance;
      final platform = _UnitRateTvPlayer();
      VideoPlayerPlatform.instance = platform;
      final player = anich.Player();
      try {
        await player.setRate(1.5);
        await player.open(const anich.Media('https://example.com/video.mp4'));
        expect(platform.playing, isTrue);
        expect(player.rate, 1);
        expect(player.controller!.value.playbackSpeed, 1);
        await expectLater(
            player.setRate(1.5), throwsA(isA<UnsupportedError>()));
        expect(player.rate, 1);
        expect(player.controller!.value.playbackSpeed, 1);
        await player.pause();
        await player.play();
        expect(platform.playing, isTrue);
      } finally {
        await player.dispose();
        VideoPlayerPlatform.instance = previous;
      }
    });
  });

  test('changing per-player volume remains unsupported on TV', () async {
    final platform = _InitializedTvPlayer();
    await expectLater(
      platform.setVolume(1, 0.5),
      throwsA(
        isA<PlatformException>().having(
          (error) => error.code,
          'code',
          'unsupported',
        ),
      ),
    );
    await expectLater(
      platform.setVolume(1, 0),
      throwsA(isA<PlatformException>()),
    );
  });
}
