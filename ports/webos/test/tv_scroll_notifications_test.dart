import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/src/pages/bangumi/controller.dart';
import 'package:xs/src/pages/bangumi/views/index.dart';

/// Keep the production filter panel, grid and notification listener; only the
/// network-backed controller methods are replaced with local page data.
class _IndexController extends BangumiIndexController {
  int moreCalls = 0;

  @override
  void get() {
    result = List.generate(
      30,
      (index) => bangumi_list_item_(
        id: index + 1,
        title: 'Local anime ${index + 1}',
        image: '',
        status: 'finale',
        episodesTotal: 12,
      ),
    );
    change(result, status: RxStatus.success());
  }

  @override
  void more() => moreCalls++;
}

void main() {
  late _IndexController controller;
  final observedAxes = <Axis>[];

  setUp(() {
    Get.testMode = true;
    controller = _IndexController();
    observedAxes.clear();
  });
  tearDown(Get.reset);

  Future<void> mount(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    Get.put<BangumiIndexController>(controller, permanent: true);
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              observedAxes.add(notification.metrics.axis);
              return false;
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                  sliver: const SliverAppBar(
                    title: Text('Actual anime index'),
                    pinned: true,
                  ),
                ),
              ],
              body: const BangumiIndexView(active: true),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BangumiIndexView), findsOneWidget);
    expect(tester.takeException(), isNull);
    controller.moreCalls = 0;
    observedAxes.clear();
  }

  Future<void> cleanup(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await Get.delete<BangumiIndexController>(force: true);
  }

  testWidgets(
    'the real horizontal year filter cannot request another anime page',
    (tester) async {
      await mount(tester);
      await tester.tap(find.text('类型 · 语言 · 年份'));
      await tester.pumpAndSettle();
      final horizontalScrollables = find.descendant(
        of: find.byType(BangumiIndexView),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is Scrollable &&
              axisDirectionToAxis(widget.axisDirection) == Axis.horizontal,
        ),
      );
      expect(horizontalScrollables, findsNWidgets(3));
      // The year row is the final filter row and contains 35 years, so its right
      // edge reproduces the real atEdge && pixels != 0 pagination trigger.
      final years = tester.state<ScrollableState>(horizontalScrollables.last);
      expect(years.position.maxScrollExtent, greaterThan(0));
      // ListView estimates the widths of unbuilt years. Recheck its extent
      // after layout until the actual final child has been reached.
      for (var attempt = 0; attempt < 10; attempt++) {
        years.position.jumpTo(years.position.maxScrollExtent);
        await tester.pumpAndSettle();
        if (years.position.atEdge && years.position.pixels > 0) break;
      }
      expect(years.position.atEdge, isTrue);
      expect(years.position.pixels, greaterThan(0));
      expect(
        observedAxes,
        contains(Axis.horizontal),
        reason: 'The real ScrollEndNotification must still bubble outward',
      );
      expect(controller.moreCalls, 0);
      years.position.jumpTo(0);
      await tester.pumpAndSettle();
      expect(controller.moreCalls, 0);
      expect(tester.takeException(), isNull);
      await cleanup(tester);
    },
  );

  testWidgets('the actual vertical grid still paginates at its bottom only', (
    tester,
  ) async {
    await mount(tester);
    final gridScrollable = find.descendant(
      of: find.byKey(const PageStorageKey('bangumi-index')),
      matching: find.byType(Scrollable),
    );
    expect(gridScrollable, findsOneWidget);
    final grid = tester.state<ScrollableState>(gridScrollable);
    expect(grid.position.axis, Axis.vertical);
    expect(grid.position.maxScrollExtent, greaterThan(0));
    grid.position.jumpTo(grid.position.maxScrollExtent / 2);
    await tester.pumpAndSettle();
    expect(controller.moreCalls, 0);
    grid.position.jumpTo(grid.position.maxScrollExtent);
    await tester.pumpAndSettle();
    expect(observedAxes, contains(Axis.vertical));
    expect(controller.moreCalls, 1);
    grid.position.jumpTo(0);
    await tester.pumpAndSettle();
    expect(controller.moreCalls, 1);
    expect(tester.takeException(), isNull);
    await cleanup(tester);
  });
}
