import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/widgets/danmaku_settings/storage.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_controller.dart';
import 'package:xs/src/widgets/player/webos_player.dart';

class _PlayingStreams extends PlayerStreams {
  final events = StreamController<bool>.broadcast(sync: true);
  @override
  Stream<bool> get playing => events.stream;
  @override
  Future<void> close() async {
    await events.close();
    await super.close();
  }
}

class _PlaybackPlayer extends Player {
  @override
  final _PlayingStreams stream = _PlayingStreams();
  @override
  Future<void> play() async {
    state.playing = true;
    stream.events.add(true);
  }

  @override
  Future<void> pause() async {
    state.playing = false;
    stream.events.add(false);
  }
}

class _PlaybackController extends BangumiVodPageController {
  _PlaybackController() : super(pId: 42, pEpisode: 1);
  final testPlayer = _PlaybackPlayer();
  @override
  _PlaybackPlayer get player => testPlayer;

  // These tests exercise listen() directly, without starting page/network work.
  Future<void> closeTest() async {
    await testPlayer.stream.close();
    testPlayer.changes.dispose();
    textEditingController.dispose();
    danmakuTextFieldFocusNode.dispose();
    playListScrollController.dispose();
    playListScrollController2.dispose();
  }
}

List<bool> toggles(_PlaybackController controller) => [
      controller.showDanmakuState.value,
      controller.bilibiliDanmakuState.value,
      controller.bilibiliHmtDanmakuState.value,
      controller.qqDanmakuState.value,
    ];

void setDefaults(bool enabled) {
  DanmakuSettingsStorage.danmakuEnable.value = enabled;
  DanmakuSettingsStorage.bilibiliDanmakuEnable.value = enabled;
  DanmakuSettingsStorage.bilibiliHmtDanmakuEnable.value = enabled;
  DanmakuSettingsStorage.qqDanmakuEnable.value = enabled;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<bool> defaults;
  setUp(() {
    defaults = [
      DanmakuSettingsStorage.danmakuEnable.value,
      DanmakuSettingsStorage.bilibiliDanmakuEnable.value,
      DanmakuSettingsStorage.bilibiliHmtDanmakuEnable.value,
      DanmakuSettingsStorage.qqDanmakuEnable.value,
    ];
  });
  tearDown(() {
    DanmakuSettingsStorage.danmakuEnable.value = defaults[0];
    DanmakuSettingsStorage.bilibiliDanmakuEnable.value = defaults[1];
    DanmakuSettingsStorage.bilibiliHmtDanmakuEnable.value = defaults[2];
    DanmakuSettingsStorage.qqDanmakuEnable.value = defaults[3];
  });

  for (final defaultEnabled in [true, false]) {
    test(
        'pause/play preserves manual danmaku toggles when default is $defaultEnabled',
        () async {
      setDefaults(defaultEnabled);
      final controller = _PlaybackController();
      var animationRunning = true;
      var pauses = 0;
      var resumes = 0;
      controller.danmakuController = DanmakuController(
        onAddItems: (_) {},
        onUpdateOption: (_) {},
        onClear: () {},
        onPause: () {
          animationRunning = false;
          pauses++;
        },
        onResume: () {
          animationRunning = true;
          resumes++;
        },
      );
      try {
        controller.listen();
        expect(toggles(controller), List.filled(4, defaultEnabled));

        // Match the quick controls' session-only toggle behavior.
        controller.showDanmakuState.value = !defaultEnabled;
        controller.bilibiliDanmakuState.value = !defaultEnabled;
        controller.bilibiliHmtDanmakuState.value = !defaultEnabled;
        controller.qqDanmakuState.value = !defaultEnabled;
        controller
            .listen(); // Rebuilding/re-registering does not reset choices.
        for (var repeat = 0; repeat < 3; repeat++) {
          await controller.player.pause();
          expect(controller.playing.value, isFalse);
          expect(toggles(controller), List.filled(4, !defaultEnabled));
          expect(pauses, repeat + 1);
          expect(animationRunning, isFalse);
          if (defaultEnabled) {
            // Hidden -> pause -> visible must reveal a paused animation.
            controller.showDanmakuState.value = true;
            expect(animationRunning, isFalse);
            controller.showDanmakuState.value = false;
          }
          await controller.player.play();
          expect(controller.playing.value, isTrue);
          expect(toggles(controller), List.filled(4, !defaultEnabled));
          expect(resumes, repeat + 1);
          expect(animationRunning, isTrue);
        }
        expect(DanmakuSettingsStorage.danmakuEnable.value, defaultEnabled);
      } finally {
        await controller.closeTest();
      }
    });
  }
}
