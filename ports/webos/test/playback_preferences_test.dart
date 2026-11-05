import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/src/apis/bangumi.dart' as bangumi_api;
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/pages/settings/playback.dart';
import 'package:xs/src/pages/settings/storage/play_history_storage.dart';
import 'package:xs/src/pages/settings/storage/playback_storage.dart';
import 'package:xs/src/widgets/player/webos_player.dart';

class _FakePlayer extends Player {
  final opened = <String>[];
  final failingHosts = <String>{};
  Completer<void>? pendingOpen;

  @override
  Future<void> open(Media media) async {
    opened.add(media.uri);
    state.completed = false;
    if (pendingOpen != null) await pendingOpen!.future;
    if (failingHosts.contains(Uri.parse(media.uri).host)) {
      throw StateError('unavailable source');
    }
    state.playing = true;
  }

  @override
  Future<void> stop() async {
    state.playing = false;
    state.completed = false;
  }
}

class _VodController extends BangumiVodPageController {
  _VodController() : super(pId: 42, pEpisode: 1);

  final _testPlayer = _FakePlayer();
  @override
  _FakePlayer get player => _testPlayer;
  int requestedEpisodes = 0;
  int fullscreenEntries = 0;

  @override
  void get() => requestedEpisodes++;

  @override
  void showControls() => showControlsState.value = true;

  @override
  Future<void> enterFullScreen() async {
    fullscreenEntries++;
    fullScreenState.value = true;
  }
}

List<vod_item_> _sources(int count) => List.generate(
      count,
      (index) => vod_item_(
        url: 'https://source$index.example/episode1.mp4',
        caption: '来源$index',
        type: 'mp4',
      ),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late GetStorage storage;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('anich-playback-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => directory.path,
    );
    storage = GetStorage('GetStorage', directory.path);
    await storage.initStorage;
    await GetStorage('playHistory', directory.path).initStorage;
  });

  setUp(() async {
    await storage.erase();
    PlaybackSettingsStorage.init(storage: storage);
  });

  test('all preferences survive reloading the persisted JSON container',
      () async {
    await PlaybackSettingsStorage.setDefaultSpeed(1.5);
    await PlaybackSettingsStorage.setDefaultScaleMode(4);
    await PlaybackSettingsStorage.setSeekBackwardSeconds(5);
    await PlaybackSettingsStorage.setSeekForwardSeconds(30);
    await PlaybackSettingsStorage.setAutoNext(false);
    await PlaybackSettingsStorage.setAutoSwitchLine(false);
    await PlaybackSettingsStorage.setAutoFullScreen(false);
    await PlaybackSettingsStorage.setRememberLine(false);
    await storage.queue.add(() async {});
    final file = File('${directory.path}/GetStorage.gs');
    await file.copy('${directory.path}/RestartedPlayback.gs');
    final restarted = GetStorage('RestartedPlayback', directory.path);
    await restarted.initStorage;
    PlaybackSettingsStorage.init(storage: restarted);
    expect(PlaybackSettingsStorage.defaultSpeed.value, 1.5);
    expect(PlaybackSettingsStorage.defaultScaleMode.value, 4);
    expect(PlaybackSettingsStorage.seekBackwardSeconds.value, 5);
    expect(PlaybackSettingsStorage.seekForwardSeconds.value, 30);
    expect(PlaybackSettingsStorage.autoNext.value, isFalse);
    expect(PlaybackSettingsStorage.autoSwitchLine.value, isFalse);
    expect(PlaybackSettingsStorage.autoFullScreen.value, isFalse);
    expect(PlaybackSettingsStorage.rememberLine.value, isFalse);
  });

  test('invalid saved values fall back to usable television defaults',
      () async {
    await storage.write(PlaybackSettingsStorage.settingsKey, {
      'defaultSpeed': -10,
      'defaultScaleMode': 1.0,
      'seekBackwardSeconds': '30',
      'seekForwardSeconds': -60,
      'autoNext': 'false',
    });
    PlaybackSettingsStorage.init(storage: storage);
    expect(PlaybackSettingsStorage.defaultSpeed.value, 1);
    expect(PlaybackSettingsStorage.defaultScaleMode.value, 0);
    expect(PlaybackSettingsStorage.seekBackwardSeconds.value, 10);
    expect(PlaybackSettingsStorage.seekForwardSeconds.value, 10);
    expect(PlaybackSettingsStorage.autoNext.value, isTrue);
  });

  test(
      'line memory follows the source after reordering and respects its switch',
      () async {
    await PlaybackSettingsStorage.rememberSuccessfulLine(42, ['a', 'b'], 1);
    expect(PlaybackSettingsStorage.preferredLineIndex(42, ['b', 'a']), 0);
    expect(PlaybackSettingsStorage.preferredLineIndex(42, ['c', 'b', 'a']), 1);
    expect(PlaybackSettingsStorage.preferredLineIndex(42, ['c', 'a']), 0);
    expect(PlaybackSettingsStorage.preferredLineIndex(43, ['a', 'b']), 0);
    await PlaybackSettingsStorage.setRememberLine(false);
    expect(PlaybackSettingsStorage.preferredLineIndex(42, ['a', 'b']), 0);
    await PlaybackSettingsStorage.rememberSuccessfulLine(42, ['a', 'b'], 0);
    await PlaybackSettingsStorage.setRememberLine(true);
    expect(PlaybackSettingsStorage.preferredLineIndex(42, ['a', 'b']), 1);
  });

  test('episode progress survives switching episodes and reopening storage',
      () async {
    final original = PlayHistoryStorage.box;
    Future<void> saveEpisode(int episode, int seconds) =>
        PlayHistoryStorage.upsertProgress(
          id: 39419,
          title: '历史记录回归',
          image: 'cover.jpg',
          episode: episode,
          episodeTitle: '第$episode集',
          episodeImage: 'episode$episode.jpg',
          position: seconds,
        );
    try {
      await original.erase();
      await saveEpisode(1, 90);
      await saveEpisode(5, 300);
      expect(PlayHistoryStorage.getLastPosition(39419, 1), 90);
      expect(PlayHistoryStorage.getLastPosition(39419, 5), 300);
      await original.queue.add(() async {});
      await File('${directory.path}/playHistory.gs')
          .copy('${directory.path}/RestartedHistory.gs');
      final restarted = GetStorage('RestartedHistory', directory.path);
      await restarted.initStorage;
      PlayHistoryStorage.box = restarted;
      PlayHistoryStorage.init();
      await saveEpisode(5, 305);
      expect(PlayHistoryStorage.getLastPosition(39419, 1), 90);
      expect(PlayHistoryStorage.getLastPosition(39419, 5), 305);
      await saveEpisode(1, 120);
      expect(PlayHistoryStorage.getLastPosition(39419, 1), 120);
      expect(PlayHistoryStorage.getLastPosition(39419, 5), 305);
      final episodes = restarted.read<Map>('39419')?['episodes'] as List;
      expect(episodes, hasLength(2));
      expect(episodes.first['title'], '第1集');
      expect(episodes.last['image'], 'episode5.jpg');
    } finally {
      PlayHistoryStorage.box = original;
    }
  });

  test('auto-next requires actual completion and only advances once', () async {
    final controller = _VodController();
    controller.episodes = [
      bangumi_episodes_data_(sort: 3),
      bangumi_episodes_data_(sort: 1),
      bangumi_episodes_data_(sort: 2),
    ];
    controller.mediaEnd();
    expect(controller.episode, 1);
    controller.player.state.completed = true;
    await PlaybackSettingsStorage.setAutoNext(false);
    controller.mediaEnd();
    expect(controller.episode, 1);
    await PlaybackSettingsStorage.setAutoNext(true);
    controller.mediaEnd();
    controller.mediaEnd();
    expect(controller.episode, 2);
    expect(controller.requestedEpisodes, 1);
    controller.leave.value = true;
    controller.mediaEnd();
    expect(controller.episode, 2);
    await controller.player.dispose();
  });

  testWidgets('disabled automatic switching keeps a failed line selected',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      builder: FlutterSmartDialog.init(),
      home: const Scaffold(),
    ));
    final controller = _VodController();
    controller.playUrls.assignAll(_sources(3));
    controller.currentLineIndex = 0;
    controller.player.failingHosts.add('source0.example');
    await tester.runAsync(() async {
      await PlaybackSettingsStorage.setAutoSwitchLine(false);
      await controller.setPlayer();
    });
    expect(controller.player.opened, hasLength(1));
    expect(controller.currentLineIndex, 0);
    expect(controller.loadError.value, isTrue);
    unawaited(SmartDialog.dismiss(status: SmartStatus.allToast));
    await tester.runAsync(controller.player.dispose);
    await tester.pumpAndSettle();
  });

  testWidgets('automatic switching wraps and stops after four alternatives',
      (tester) async {
    await tester.pumpWidget(GetMaterialApp(
      builder: FlutterSmartDialog.init(),
      home: const Scaffold(),
    ));
    final controller = _VodController();
    controller.playUrls.assignAll(_sources(7));
    controller.currentLineIndex = 6;
    controller.player.failingHosts
        .addAll(List.generate(7, (index) => 'source$index.example'));
    await tester.runAsync(controller.setPlayer);
    expect(
      controller.player.opened.map((url) => Uri.parse(url).host),
      [
        'source6.example',
        'source0.example',
        'source1.example',
        'source2.example',
        'source3.example'
      ],
    );
    expect(controller.loadError.value, isTrue);
    unawaited(SmartDialog.dismiss(status: SmartStatus.allToast));
    await tester.runAsync(controller.player.dispose);
    await tester.pumpAndSettle();
  });

  test(
      'successful source is restored for the next episode without forcing fullscreen again',
      () async {
    final controller = _VodController();
    controller.playUrls.assignAll(_sources(3));
    controller.currentLineIndex = 2;
    await controller.setPlayer();
    expect(controller.fullscreenEntries, 1);
    final interceptor = InterceptorsWrapper(onRequest: (options, handler) {
      final sources = _sources(3);
      for (final source in sources) {
        source.url = source.url.replaceFirst('episode1', 'episode2');
      }
      handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: vod_(data: sources).writeToBuffer(),
      ));
    });
    bangumi_api.api.interceptors.add(interceptor);
    try {
      controller.rxEpisode.value = 2;
      await controller.getPlayUrl();
      expect(controller.currentLineIndex, 2);
      expect(controller.player.opened.last,
          'https://source2.example/episode2.mp4');
      expect(controller.fullscreenEntries, 1);
    } finally {
      bangumi_api.api.interceptors.remove(interceptor);
      await controller.player.dispose();
    }
  });

  test(
      'exiting during open does not remember a stale source or enter fullscreen',
      () async {
    final controller = _VodController();
    controller.playUrls.assignAll(_sources(1));
    controller.currentLineIndex = 0;
    final pending = controller.player.pendingOpen = Completer<void>();
    final opening = controller.setPlayer();
    controller.leave.value = true;
    pending.complete();
    await opening;
    expect(controller.fullscreenEntries, 0);
    expect(storage.read(PlaybackSettingsStorage.lineMemoryKey), isNull);
    await controller.player.dispose();
  });

  testWidgets('remote can choose and save a default speed', (tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: PlaybackSettingsPage()));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('1.25 倍'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(PlaybackSettingsStorage.defaultSpeed.value, 1.25);
    final saved = storage.read<Map>(PlaybackSettingsStorage.settingsKey);
    expect(saved?['defaultSpeed'], 1.25);
  });
}
