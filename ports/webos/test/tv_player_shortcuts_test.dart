import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/widgets/player/tv_player_shortcuts.dart';

const _colors = [
  LogicalKeyboardKey.colorF0Red,
  LogicalKeyboardKey.colorF1Green,
  LogicalKeyboardKey.colorF2Yellow,
  LogicalKeyboardKey.colorF3Blue,
];
const _physical = [
  PhysicalKeyboardKey.f1,
  PhysicalKeyboardKey.f2,
  PhysicalKeyboardKey.f3,
  PhysicalKeyboardKey.f4,
];

class _Calls {
  final values = List.filled(4, 0);
  Widget wrap(Widget child) => TvPlayerShortcuts(
        onDanmaku: () => values[0]++,
        onLines: () => values[1]++,
        onEpisodes: () => values[2]++,
        onFullscreen: () => values[3]++,
        child: child,
      );
}

Future<void> _pressColors(WidgetTester tester) async {
  for (var index = 0; index < _colors.length; index++) {
    // Web's standard logical key names allow remote keys with no desktop
    // physical equivalent to pass through Flutter's real key-event pipeline.
    await tester.sendKeyEvent(_colors[index],
        platform: 'web', physicalKey: _physical[index]);
  }
}

Widget _button({VoidCallback? onPressed}) => TextButton(
      autofocus: true,
      onPressed: onPressed ?? () {},
      child: const Text('Focused player control'),
    );

void main() {
  testWidgets('all four keys act once while a child button retains focus',
      (tester) async {
    final calls = _Calls();
    var buttonPresses = 0;
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: calls.wrap(_button(onPressed: () => buttonPresses++)),
    )));
    await tester.pumpAndSettle();
    final focus = FocusManager.instance.primaryFocus;
    await _pressColors(tester);
    expect(calls.values, [1, 1, 1, 1]);
    expect(FocusManager.instance.primaryFocus, same(focus));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(buttonPresses, 1);
    expect(calls.values, [1, 1, 1, 1]);
  });

  testWidgets(
      'long presses consume repeats and releases without repeating actions',
      (tester) async {
    final calls = _Calls();
    final escaped = <LogicalKeyboardKey>[];
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Focus(
        onKeyEvent: (_, event) {
          escaped.add(event.logicalKey);
          return KeyEventResult.handled;
        },
        child: calls.wrap(_button()),
      ),
    )));
    await tester.pumpAndSettle();
    for (var index = 0; index < _colors.length; index++) {
      expect(
          await tester.sendKeyDownEvent(_colors[index],
              platform: 'web', physicalKey: _physical[index]),
          isTrue);
      for (var repeat = 0; repeat < 3; repeat++) {
        expect(
            await tester.sendKeyRepeatEvent(_colors[index],
                platform: 'web', physicalKey: _physical[index]),
            isTrue);
      }
      expect(
          await tester.sendKeyUpEvent(_colors[index],
              platform: 'web', physicalKey: _physical[index]),
          isTrue);
    }
    expect(calls.values, [1, 1, 1, 1]);
    expect(escaped, isEmpty);
  });

  testWidgets('synthesized focus-recovery events do not invoke shortcuts',
      (tester) async {
    final calls = _Calls();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: calls.wrap(_button()),
    )));
    await tester.pumpAndSettle();
    for (var index = 0; index < _colors.length; index++) {
      for (final type in [ui.KeyEventType.down, ui.KeyEventType.up]) {
        tester.binding.platformDispatcher.onKeyData!(ui.KeyData(
          type: type,
          physical: _physical[index].usbHidUsage,
          logical: _colors[index].keyId,
          character: null,
          timeStamp: Duration.zero,
          synthesized: true,
        ));
      }
    }
    expect(calls.values, [0, 0, 0, 0]);
    await _pressColors(tester);
    expect(calls.values, [1, 1, 1, 1]);
  });

  testWidgets(
      'OK, media playback and direction keys remain with existing handlers',
      (tester) async {
    final calls = _Calls();
    final forwarded = <LogicalKeyboardKey>[];
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: Focus(
        onKeyEvent: (_, event) {
          if (event is KeyDownEvent) forwarded.add(event.logicalKey);
          return KeyEventResult.handled;
        },
        child: calls.wrap(const Focus(
          autofocus: true,
          child: SizedBox(width: 100, height: 100),
        )),
      ),
    )));
    await tester.pumpAndSettle();
    final keys = [
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.mediaPlayPause,
      LogicalKeyboardKey.arrowLeft
    ];
    for (final key in keys) {
      await tester.sendKeyEvent(key,
          platform: 'web', physicalKey: PhysicalKeyboardKey.f8);
    }
    expect(forwarded, keys);
    expect(calls.values, [0, 0, 0, 0]);
  });

  for (final requestFocus in [true, false]) {
    testWidgets(
        'a dialog blocks the player even with requestFocus=$requestFocus',
        (tester) async {
      final calls = _Calls();
      final navigator = GlobalKey<NavigatorState>();
      late BuildContext pageContext;
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigator,
        home: Builder(builder: (context) {
          pageContext = context;
          return Scaffold(body: calls.wrap(_button()));
        }),
      ));
      await tester.pumpAndSettle();
      final playerFocus = FocusManager.instance.primaryFocus;
      final dialog = showDialog<void>(
        context: pageContext,
        requestFocus: requestFocus,
        builder: (_) => const AlertDialog(title: Text('Player selection')),
      );
      await tester.pumpAndSettle();
      if (!requestFocus) {
        expect(FocusManager.instance.primaryFocus, same(playerFocus));
      }
      await _pressColors(tester);
      expect(calls.values, [0, 0, 0, 0]);
      navigator.currentState!.pop();
      await tester.pumpAndSettle();
      await dialog;
      await _pressColors(tester);
      expect(calls.values, [1, 1, 1, 1]);
    });
  }

  testWidgets('another page and disposing the player leave no active shortcuts',
      (tester) async {
    final calls = _Calls();
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: navigator,
      home: Scaffold(body: calls.wrap(_button())),
    ));
    await tester.pumpAndSettle();
    final nextPage = navigator.currentState!.push<void>(MaterialPageRoute(
      builder: (_) => Scaffold(body: _button()),
    ));
    await tester.pumpAndSettle();
    await _pressColors(tester);
    expect(calls.values, [0, 0, 0, 0]);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await nextPage;
    await _pressColors(tester);
    expect(calls.values, [1, 1, 1, 1]);
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: _button())));
    await tester.pumpAndSettle();
    await _pressColors(tester);
    expect(calls.values, [1, 1, 1, 1]);
  });
}
