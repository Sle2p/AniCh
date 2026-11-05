import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

void main() {
  test('remote tests use the webOS build flag', () {
    expect(TvFocusableAction.isTV, isTrue,
        reason: 'Run with --dart-define=ANICH_WEBOS=true');
  });

  testWidgets('D-pad skips controls in an inactive page', (tester) async {
    final activated = <int>[];
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Row(
          children: List.generate(
              3,
              (index) => TvFocusableAction(
                    autofocus: index == 0,
                    focusEnabled: index != 1,
                    onTap: () => activated.add(index),
                    child: SizedBox(
                        width: 100, height: 80, child: Text('Card $index')),
                  )),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(activated, [2]);
  });

  testWidgets('remote OK and a nested pointer handler activate only once',
      (tester) async {
    var remote = 0;
    var pointer = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TvFocusableAction(
          autofocus: true,
          onTap: () => remote++,
          child: InkWell(
            key: const ValueKey('pointer-handler'),
            onTap: () => pointer++,
            child:
                const SizedBox(width: 200, height: 100, child: Text('Episode')),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(remote, 1);
    expect(pointer, 0);
    await tester.tap(find.byKey(const ValueKey('pointer-handler')));
    expect(remote, 1);
    expect(pointer, 1);
  });

  testWidgets('down navigation reveals items beyond the viewport',
      (tester) async {
    final scroll = ScrollController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 250,
          height: 240,
          child: ListView(
            controller: scroll,
            children: List.generate(
                10,
                (index) => TvFocusableAction(
                      autofocus: index == 0,
                      onTap: () {},
                      child:
                          SizedBox(height: 100, child: Text('Episode $index')),
                    )),
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    for (var i = 0; i < 4; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
    }
    expect(scroll.offset, greaterThan(0));
    await tester.pumpWidget(const SizedBox.shrink());
    scroll.dispose();
  });

  testWidgets('OK changes the tab reached by the remote', (tester) async {
    final tabs = TabController(length: 2, vsync: tester);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 50,
          child: TvTabBar(
            controller: tabs,
            autofocus: true,
            tabs: const [Tab(text: 'Details'), Tab(text: 'Episodes')],
          ),
        ),
      ),
    ));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(tabs.index, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    tabs.dispose();
  });
}
