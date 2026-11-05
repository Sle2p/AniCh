import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/src/apis/bangumi.dart' as bangumi_api;
import 'package:xs/src/pages/bangumi_detail/models/bangumi_detail_model.dart';
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/pages/bangumi_vod/view.dart';
import 'package:xs/src/widgets/player/webos_player.dart';

/// Keep the production page, GetObserver, player controls and panel routes. Only
/// network loading/timers and the native media backend are absent from this test.
class _LocalVodController extends BangumiVodPageController {
  _LocalVodController() : super(pId: 42, pEpisode: 1) {
    fullScreenState.value = true;
    showControlsState.value = true;
    data = BangumiDetailModel(id: 42, title: 'Route-owned title');
    episodes = [bangumi_episodes_data_(sort: 1, title: 'First episode')];
    playUrls.assignAll([
      vod_item_(url: 'https://example.org/video', caption: 'Test source'),
    ]);
    currentLineIndex = 0;
    // Danmaku rasterization is unrelated to route argument ownership.
    danmakuView = const SizedBox.shrink();
  }

  int initializedPages = 0;
  int dataBindings = 0;
  @override
  void onInit() {
    initializedPages++;
    super.onInit();
  }

  @override
  void get() {
    change(data, status: RxStatus.success());
  }

  @override
  void setBangumiData(dynamic value) {
    dataBindings++;
    data = value as BangumiDetailModel;
    get();
  }

  @override
  void getBangumiData() =>
      throw StateError('Unexpected network metadata fetch');
  @override
  void getBangumiEpisodes() =>
      throw StateError('Unexpected network episode fetch');
  @override
  void listen() {}
  @override
  void initStream() {}
  @override
  void initSystem() {}
  @override
  void showControls() => showControlsState.value = true;
}

Future<void> _color(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(
    key,
    platform: 'web',
    physicalKey: PhysicalKeyboardKey.f8,
  );
  await tester.pumpAndSettle();
}

void main() {
  late _LocalVodController controller;
  late dio.Interceptor localResponses;
  setUp(() {
    Get.testMode = true;
    controller = _LocalVodController();
    localResponses = dio.InterceptorsWrapper(
      onRequest: (options, handler) {
        expect(
          options.path,
          '/comment',
          reason: 'No unexpected live API calls',
        );
        handler.resolve(
          dio.Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'body': {'data': <Object>[]},
            },
          ),
        );
      },
    );
    bangumi_api.api.interceptors.add(localResponses);
  });
  tearDown(() {
    bangumi_api.api.interceptors.remove(localResponses);
    Get.reset();
  });

  Future<void> openPlayer(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        defaultTransition: Transition.noTransition,
        getPages: [
          GetPage(
            name: '/',
            page: () => const Scaffold(body: Text('Home')),
          ),
          GetPage(name: '/vod/:id', page: () => const BangumiVodPage()),
        ],
      ),
    );
    await tester.pumpAndSettle();
    Get.put<BangumiVodPageController>(controller, permanent: true);
    Get.toNamed(
      '/vod/42',
      arguments: {
        'id': 42,
        'episode': 1,
        'data': controller.data,
        'episodes': controller.episodes,
      },
    );
    await tester.pumpAndSettle();
    expect(find.byType(BangumiVodPage), findsOneWidget);
    expect(find.byType(Video), findsOneWidget);
    expect(tester.takeException(), isNull);
  }

  Future<void> cleanup(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await Get.delete<BangumiVodPageController>(force: true);
    await tester.pump();
    await tester.runAsync(() => controller.player.dispose());
  }

  testWidgets(
    'actual Get player retains its arguments while selection routes are current',
    (tester) async {
      await openPlayer(tester);
      for (final key in [
        LogicalKeyboardKey.colorF1Green,
        LogicalKeyboardKey.colorF2Yellow,
        LogicalKeyboardKey.colorF1Green,
      ]) {
        await _color(tester, key);
        // This is the exact state that broke 1.0.10: GetObserver has replaced
        // global arguments with the argument-less popup route's null value.
        expect(Get.arguments, isNull);
        expect(tester.takeException(), isNull);
        expect(find.byType(BangumiVodPage), findsOneWidget);
        expect(find.byType(Video), findsOneWidget);
        expect(controller.id, 42);
        expect(controller.episode, 1);
        expect(controller.data.title, 'Route-owned title');
      }
      await _color(tester, LogicalKeyboardKey.colorF1Green);
      expect(find.text('切换线路'), findsNothing);
      expect(controller.initializedPages, 1);
      expect(controller.dataBindings, 1);
      await cleanup(tester);
    },
  );

  testWidgets(
    'blue works first and after closing a panel without replacing the player',
    (tester) async {
      await openPlayer(tester);
      await _color(tester, LogicalKeyboardKey.colorF3Blue);
      expect(controller.fullScreenState.value, isFalse);
      expect(find.byType(NestedScrollView), findsOneWidget);
      expect(find.byType(Video), findsOneWidget);
      expect(tester.getSize(find.byType(Video)).height, lessThan(1080));
      expect(tester.takeException(), isNull);
      await _color(tester, LogicalKeyboardKey.colorF3Blue);
      expect(controller.fullScreenState.value, isTrue);
      expect(find.byType(Video), findsOneWidget);
      expect(tester.getSize(find.byType(Video)), const Size(1920, 1080));
      await _color(tester, LogicalKeyboardKey.colorF2Yellow);
      expect(Get.arguments, isNull);
      await _color(tester, LogicalKeyboardKey.colorF3Blue);
      expect(find.widgetWithText(ListTile, '选集'), findsNothing);
      expect(
        ModalRoute.of(tester.element(find.byType(BangumiVodPage)))!.isCurrent,
        isTrue,
      );
      expect(controller.fullScreenState.value, isFalse);
      expect(find.byType(NestedScrollView), findsOneWidget);
      expect(find.byType(Video), findsOneWidget);
      expect(tester.getSize(find.byType(Video)).height, lessThan(1080));
      expect(tester.takeException(), isNull);
      expect(controller.initializedPages, 1);
      expect(controller.dataBindings, 1);
      await cleanup(tester);
    },
  );
}
