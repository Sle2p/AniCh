import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

Widget _card(String id, {bool autofocus = false}) => TvFocusableAction(
  key: ValueKey(id),
  autofocus: autofocus,
  onTap: () {},
  child: SizedBox(width: 140, height: 80, child: Text(id)),
);

FocusNode _focus(WidgetTester tester, String id) => tester
    .widget<Focus>(
      find
          .descendant(
            of: find.byKey(ValueKey(id)),
            matching: find.byType(Focus),
          )
          .first,
    )
    .focusNode!;

Future<void> _arrow(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

Widget _app(Widget child) => MaterialApp(
  home: Scaffold(
    body: Align(alignment: Alignment.topLeft, child: child),
  ),
);

void main() {
  testWidgets('left and right on a visible row preserve vertical offset', (
    tester,
  ) async {
    final scroll = ScrollController();
    await tester.pumpWidget(
      _app(
        SizedBox(
          height: 300,
          width: 500,
          child: SingleChildScrollView(
            controller: scroll,
            child: Column(
              children: [
                const SizedBox(height: 400),
                Row(children: [_card('left', autofocus: true), _card('right')]),
                const SizedBox(height: 800),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    scroll.jumpTo(350);
    await tester.pumpAndSettle();
    for (var repeat = 0; repeat < 3; repeat++) {
      await _arrow(tester, LogicalKeyboardKey.arrowRight);
      expect(_focus(tester, 'right').hasPrimaryFocus, isTrue);
      expect(scroll.offset, closeTo(350, .01));
      await _arrow(tester, LogicalKeyboardKey.arrowLeft);
      expect(_focus(tester, 'left').hasPrimaryFocus, isTrue);
      expect(scroll.offset, closeTo(350, .01));
    }
    await tester.pumpWidget(const SizedBox.shrink());
    scroll.dispose();
  });

  testWidgets(
    'horizontal list reveals cards without moving its vertical parent',
    (tester) async {
      final vertical = ScrollController();
      final horizontal = ScrollController();
      await tester.pumpWidget(
        _app(
          SizedBox(
            height: 300,
            width: 300,
            child: SingleChildScrollView(
              controller: vertical,
              child: Column(
                children: [
                  const SizedBox(height: 400),
                  SizedBox(
                    height: 80,
                    child: SingleChildScrollView(
                      controller: horizontal,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          8,
                          (index) =>
                              _card('horizontal$index', autofocus: index == 0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 800),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      vertical.jumpTo(350);
      horizontal.jumpTo(0);
      await tester.pumpAndSettle();
      for (var index = 1; index <= 4; index++) {
        await _arrow(tester, LogicalKeyboardKey.arrowRight);
        expect(_focus(tester, 'horizontal$index').hasPrimaryFocus, isTrue);
        expect(vertical.offset, closeTo(350, .01));
      }
      expect(horizontal.offset, greaterThan(0));
      for (var index = 3; index >= 0; index--) {
        await _arrow(tester, LogicalKeyboardKey.arrowLeft);
        expect(_focus(tester, 'horizontal$index').hasPrimaryFocus, isTrue);
        expect(vertical.offset, closeTo(350, .01));
      }
      await tester.pumpWidget(const SizedBox.shrink());
      vertical.dispose();
      horizontal.dispose();
    },
  );

  testWidgets(
    'NestedScrollView keeps both vertical positions on same-row arrows',
    (tester) async {
      final outer = ScrollController();
      late ScrollController inner;
      await tester.pumpWidget(
        _app(
          SizedBox(
            height: 300,
            width: 500,
            child: NestedScrollView(
              controller: outer,
              headerSliverBuilder: (_, __) => [
                const SliverToBoxAdapter(child: SizedBox(height: 200)),
              ],
              body: Builder(
                builder: (context) {
                  inner = PrimaryScrollController.of(context);
                  return SingleChildScrollView(
                    primary: true,
                    child: Column(
                      children: List.generate(
                        12,
                        (index) => SizedBox(
                          height: 100,
                          child: Row(
                            children: [
                              _card(
                                'nested${index}left',
                                autofocus: index == 4,
                              ),
                              _card('nested${index}right'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      inner.jumpTo(350);
      await tester.pumpAndSettle();
      final outerBefore = outer.offset;
      final innerBefore = inner.offset;
      expect(outerBefore, greaterThan(0));
      expect(innerBefore, greaterThan(0));
      for (var repeat = 0; repeat < 3; repeat++) {
        await _arrow(tester, LogicalKeyboardKey.arrowRight);
        expect(_focus(tester, 'nested4right').hasPrimaryFocus, isTrue);
        expect(outer.offset, closeTo(outerBefore, .01));
        expect(inner.offset, closeTo(innerBefore, .01));
        await _arrow(tester, LogicalKeyboardKey.arrowLeft);
        expect(_focus(tester, 'nested4left').hasPrimaryFocus, isTrue);
        expect(outer.offset, closeTo(outerBefore, .01));
        expect(inner.offset, closeTo(innerBefore, .01));
      }
      await tester.pumpWidget(const SizedBox.shrink());
      outer.dispose();
    },
  );

  testWidgets('up and down still reveal an item outside the viewport', (
    tester,
  ) async {
    final scroll = ScrollController();
    await tester.pumpWidget(
      _app(
        SizedBox(
          height: 240,
          width: 300,
          child: SingleChildScrollView(
            controller: scroll,
            child: Column(
              children: List.generate(
                10,
                (index) => _card('vertical$index', autofocus: index == 0),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (var index = 1; index <= 6; index++) {
      await _arrow(tester, LogicalKeyboardKey.arrowDown);
      expect(_focus(tester, 'vertical$index').hasPrimaryFocus, isTrue);
      final rect = tester.getRect(find.byKey(ValueKey('vertical$index')));
      expect(rect.top, greaterThanOrEqualTo(-.01));
      expect(rect.bottom, lessThanOrEqualTo(240.01));
    }
    expect(scroll.offset, greaterThan(0));
    for (var index = 5; index >= 0; index--) {
      await _arrow(tester, LogicalKeyboardKey.arrowUp);
    }
    expect(_focus(tester, 'vertical0').hasPrimaryFocus, isTrue);
    expect(scroll.offset, closeTo(0, .01));
    await tester.pumpWidget(const SizedBox.shrink());
    scroll.dispose();
  });

  testWidgets(
    'deep autofocus remains visible without moving visible neighbors',
    (tester) async {
      final scroll = ScrollController();
      await tester.pumpWidget(
        _app(
          SizedBox(
            height: 240,
            width: 300,
            child: SingleChildScrollView(
              controller: scroll,
              child: Column(
                children: List.generate(
                  10,
                  (index) => _card('initial$index', autofocus: index == 6),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(_focus(tester, 'initial6').hasPrimaryFocus, isTrue);
      final rect = tester.getRect(find.byKey(const ValueKey('initial6')));
      expect(rect.top, greaterThanOrEqualTo(-.01));
      expect(rect.bottom, lessThanOrEqualTo(240.01));
      expect(scroll.offset, greaterThan(0));
      await tester.pumpWidget(const SizedBox.shrink());
      scroll.dispose();
    },
  );
}
