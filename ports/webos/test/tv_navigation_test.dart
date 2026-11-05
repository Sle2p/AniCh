import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/profile/tv_more.dart';
import 'package:xs/src/pages/search/models/search_type.dart';
import 'package:xs/src/widgets/tv_app_navigation.dart';

Widget navigationApp({String initialRoute = '/'}) => GetMaterialApp(
      initialRoute: initialRoute,
      defaultTransition: Transition.noTransition,
      getPages: [
        GetPage(
          name: '/',
          page: () => const Scaffold(bottomNavigationBar: TvAppNavigation()),
        ),
        GetPage(name: '/tv_more', page: () => const TvMorePage()),
        for (final route in [
          '/search_panel',
          '/calendar',
          '/bangumi_collection',
          '/play_history',
          '/profile',
          '/account_settings',
          '/playback_settings',
          '/danmaku_settings',
          '/theme_settings',
          '/thread_collection',
          '/info',
        ])
          GetPage(
              name: route, page: () => Scaffold(body: Text('Opened $route'))),
      ],
    );

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  testWidgets('TV home restores the main routes with D-pad and OK',
      (tester) async {
    await tester.pumpWidget(navigationApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('搜索'));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/search_panel');
    expect(Get.arguments['type'], SearchType.bangumi);
    Get.back();
    await tester.pumpAndSettle();

    for (final route in [
      '/calendar',
      '/bangumi_collection',
      '/play_history',
      '/tv_more'
    ]) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, route);
      Get.back();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('TV settings expose login and local options without an account',
      (tester) async {
    await tester.pumpWidget(navigationApp(initialRoute: '/tv_more'));
    await tester.pumpAndSettle();
    final routes = [
      '/profile',
      '/account_settings',
      '/playback_settings',
      '/danmaku_settings',
      '/theme_settings',
    ];
    for (var index = 0; index < routes.length; index++) {
      if (index > 0) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(Get.currentRoute, routes[index]);
      Get.back();
      await tester.pumpAndSettle();
    }
    expect(find.text('图库'), findsOneWidget);
    expect(find.text('图片收藏'), findsOneWidget);
    expect(find.text('关于 AniCh'), findsOneWidget);
  });
}
