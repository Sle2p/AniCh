import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_controller.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_geometry.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_stroke_text.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_view.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_item.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_option.dart';
import 'package:xs/src/widgets/ns_danmaku/transition/scroll_item_view.dart';
import 'package:xs/src/widgets/player/webos_player.dart';

void main() {
  test('video viewport follows letterboxing, custom ratios and all fit modes',
      () {
    expect(videoViewportRect(const Size(800, 600), 16 / 9, BoxFit.contain),
        const Rect.fromLTWH(0, 75, 800, 450));
    expect(videoViewportRect(const Size(1920, 1080), 4 / 3, BoxFit.contain),
        const Rect.fromLTWH(240, 0, 1440, 1080));
    for (final fit in [BoxFit.fill, BoxFit.cover]) {
      expect(videoViewportRect(const Size(800, 600), 16 / 9, fit),
          const Rect.fromLTWH(0, 0, 800, 600));
    }
    final portrait =
        videoViewportRect(const Size(800, 600), 9 / 16, BoxFit.contain);
    expect(portrait, const Rect.fromLTWH(231.25, 0, 337.5, 600));
    expect(videoViewportRect(Size.zero, 16 / 9, BoxFit.contain), Rect.zero);
  });

  testWidgets(
      'heavy strokes, scaled text and fixed comments stay inside the video',
      (tester) async {
    DanmakuController? controller;
    final surface = GlobalKey();
    const viewport = Size(320, 180);
    await tester.pumpWidget(MaterialApp(
        home: Center(
            child: RepaintBoundary(
      key: surface,
      child: SizedBox(
          width: 600,
          height: 400,
          child: Center(
              child: SizedBox(
            width: viewport.width,
            height: viewport.height,
            child: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: DefaultTextStyle(
                  style: const TextStyle(fontFamily: 'Ahem'),
                  child: DanmakuView(
                    option: DanmakuOption(
                        fontSize: 20, strokeWidth: 10, lineHeight: 1.4),
                    createdController: (value) => controller = value,
                  )),
            ),
          ))),
    ))));
    controller!.addItems([
      DanmakuItem('Ågj中文\nsecond line', type: DanmakuItemType.top),
      DanmakuItem('bottom 描边', type: DanmakuItemType.bottom),
      DanmakuItem('self', type: DanmakuItemType.top, self: true),
    ]);
    await tester.pump();
    controller!.pause();
    await tester.pump();
    final video = tester.getRect(find.byType(DanmakuView));
    for (final element in find.byType(DanmakuStrokeText).evaluate()) {
      final rect = tester.getRect(find.byWidget(element.widget));
      expect(rect.top, greaterThanOrEqualTo(video.top + 8));
      expect(rect.bottom, lessThanOrEqualTo(video.bottom - 8));
      expect(rect.left, greaterThanOrEqualTo(video.left + 8));
      expect(rect.right, lessThanOrEqualTo(video.right - 8));
    }
    final boundary =
        surface.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await tester.runAsync(() => boundary.toImage(pixelRatio: 1));
    final bytes = await tester
        .runAsync(() => image!.toByteData(format: ui.ImageByteFormat.rawRgba));
    final pixels = bytes!.buffer.asUint8List();
    final safe = danmakuSafeRect(viewport).shift(const Offset(140, 110));
    var painted = 0;
    for (var y = 0; y < 400; y++) {
      for (var x = 0; x < 600; x++) {
        if (pixels[(y * 600 + x) * 4 + 3] == 0) continue;
        painted++;
        expect(safe.contains(Offset(x.toDouble(), y.toDouble())), isTrue,
            reason: 'Paint escaped the video safe area at $x,$y');
      }
    }
    expect(painted, greaterThan(0));
    image!.dispose();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('scroll trajectory uses the local video width, not the display',
      (tester) async {
    DanmakuController? controller;
    await tester.pumpWidget(MaterialApp(
        home: Center(
            child: SizedBox(
      width: 320,
      height: 180,
      child: DanmakuView(
          option: DanmakuOption(duration: 4, fontSize: 20),
          createdController: (value) => controller = value),
    ))));
    controller!.addItems([DanmakuItem('local width')]);
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    final video = tester.getRect(find.byType(DanmakuView));
    final text = tester.getRect(find.descendant(
        of: find.byType(ScrollItemView),
        matching: find.byType(DanmakuStrokeText)));
    expect(text.center.dx, closeTo(video.center.dx, 1));
    expect(text.top, greaterThanOrEqualTo(video.top + 8));
    expect(text.bottom, lessThanOrEqualTo(video.bottom - 8));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'resize and large fonts never force self comments outside available rows',
      (tester) async {
    DanmakuController? controller;
    final danmakuKey = GlobalKey();
    Widget host(Size size) => MaterialApp(
            home: Center(
                child: SizedBox(
          width: size.width,
          height: size.height,
          child: DanmakuView(
              key: danmakuKey,
              option: DanmakuOption(fontSize: 28, strokeWidth: 8),
              createdController: (value) => controller = value),
        )));
    await tester.pumpWidget(host(const Size(800, 450)));
    controller!.addItems([
      DanmakuItem('old dimensions'),
      DanmakuItem('top', type: DanmakuItemType.top)
    ]);
    await tester.pump();
    expect(find.byType(DanmakuStrokeText), findsNWidgets(2));
    await tester.pumpWidget(host(const Size(100, 20)));
    controller!.addItems([
      DanmakuItem('self scroll', self: true),
      DanmakuItem('self top', type: DanmakuItemType.top, self: true),
      DanmakuItem('self bottom', type: DanmakuItemType.bottom, self: true),
    ]);
    await tester.pump();
    expect(find.byType(DanmakuStrokeText), findsNothing);
    await tester.pumpWidget(host(const Size(480, 270)));
    controller!.addItems(List.generate(30,
        (i) => DanmakuItem('self $i', type: DanmakuItemType.top, self: true)));
    await tester.pump();
    final video = tester.getRect(find.byType(DanmakuView));
    for (final element in find.byType(DanmakuStrokeText).evaluate()) {
      final rect = tester.getRect(find.byWidget(element.widget));
      expect(rect.top, greaterThanOrEqualTo(video.top + 8));
      expect(rect.bottom, lessThanOrEqualTo(video.bottom - 8));
    }
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
      'pause freezes existing and newly inserted comments until resumed',
      (tester) async {
    DanmakuController? controller;
    await tester.pumpWidget(MaterialApp(
        home: Center(
            child: SizedBox(
      width: 480,
      height: 270,
      child: DanmakuView(
          option: DanmakuOption(duration: 4),
          createdController: (value) => controller = value),
    ))));
    controller!.addItems([DanmakuItem('first')]);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    controller!.pause();
    final first = tester.getRect(find.byType(DanmakuStrokeText));
    await tester.pump(const Duration(seconds: 1));
    expect(tester.getRect(find.byType(DanmakuStrokeText)), first);
    controller!.addItems([DanmakuItem('inserted while paused')]);
    await tester.pump();
    final texts = find.byType(DanmakuStrokeText);
    final inserted = tester.getRect(texts.last);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.getRect(texts.last), inserted);
    controller!.resume();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.getRect(texts.last).left, lessThan(inserted.left));
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
