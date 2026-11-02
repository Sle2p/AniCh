import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/player/tv_player_shortcuts.dart';

class _PanelController extends BangumiVodPageController {
  _PanelController() : super(pId: 42, pEpisode: 1) {
    currentLineIndex = 0;
    playUrls.assignAll([
      vod_item_(url: 'https://example.org/one', caption: 'Source one'),
      vod_item_(url: 'https://example.org/two', caption: 'Source two'),
    ]);
    episodes = [bangumi_episodes_data_(sort: 1, title: 'Episode one')];
  }

  int lineSelections = 0;
  @override
  void changePlayLine(int index) {
    currentLineIndex = index;
    lineSelections++;
  }

  // Deliberately never call onInit: these are the real selection widgets, but
  // neither networking nor native video is needed to exercise their routes.
  void disposeTest() {
    textEditingController.dispose();
    danmakuTextFieldFocusNode.dispose();
    playListScrollController.dispose();
    playListScrollController2.dispose();
  }
}

class _Player extends StatefulWidget {
  const _Player({super.key, required this.controller});
  final _PanelController controller;
  @override
  State<_Player> createState() => _PlayerState();
}

class _PlayerState extends State<_Player> {
  TvPlayerPanelCoordinator? panels;
  final routes = <RawDialogRoute<void>>[];
  final effects = <String>[];
  bool overlapped = false;
  late ModalRoute<dynamic> pageRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageRoute = ModalRoute.of(context)!;
    panels ??= TvPlayerPanelCoordinator(
      context: context,
      canOpen: (_) => true,
      onDanmaku: () => _recordEffect('red'),
      onFullscreen: () => _recordEffect('blue'),
      buildRoute: (panel, close, wrap) {
        // The outgoing route must have removed its overlay before the new
        // route is created; popping it alone is insufficient.
        overlapped |= routes.any((route) => route.overlayEntries.isNotEmpty);
        final route = Utils.rightDialogRoute(
          title: panel == TvPlayerPanel.lines ? '切换线路' : '选集',
          onBack: close,
          wrap: wrap,
          width: panel == TvPlayerPanel.lines ? 480 : 400,
          child: panel == TvPlayerPanel.lines
              ? widget.controller.buildPlayUrlsPanel(close)
              : widget.controller.buildEpisodesPanel(close),
        );
        routes.add(route);
        return route;
      },
    );
    widget.controller.tvPanelCoordinator = panels;
  }

  void _recordEffect(String value) {
    expect(routes.every((route) => route.overlayEntries.isEmpty), isTrue,
        reason: '$value must run after the panel and its animation are gone');
    effects.add(value);
  }

  @override
  Widget build(BuildContext context) => panels!.wrap(Scaffold(
        body: Column(children: [
          TextButton(
            autofocus: true,
            onPressed: widget.controller.showPlayUrlsSheet,
            child: const Text('Pointer lines'),
          ),
          TextButton(
            onPressed: widget.controller.showEpisodesSheet,
            child: const Text('Pointer episodes'),
          ),
        ]),
      ));

  @override
  void dispose() {
    panels?.dispose();
    widget.controller.tvPanelCoordinator = null;
    super.dispose();
  }
}

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

Future<void> _press(WidgetTester tester, int color) async {
  await tester.sendKeyEvent(
    _colors[color],
    platform: 'web',
    physicalKey: _physical[color],
  );
}

void main() {
  late _PanelController controller;
  late GlobalKey<_PlayerState> player;
  late GlobalKey<NavigatorState> navigator;
  setUp(() {
    Get.testMode = true;
    controller = _PanelController();
    player = GlobalKey<_PlayerState>();
    navigator = GlobalKey<NavigatorState>();
  });
  tearDown(() {
    controller.disposeTest();
    Get.reset();
  });

  Future<void> mount(WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      navigatorKey: navigator,
      home: _Player(key: player, controller: controller),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('green/green and yellow/yellow toggle their real player panels',
      (tester) async {
    await mount(tester);
    for (final color in [1, 2]) {
      final title = color == 1 ? '切换线路' : '选集';
      await _press(tester, color);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
      await _press(tester, color);
      await tester.pumpAndSettle();
      expect(find.text(title), findsNothing);
      expect(player.currentState!.pageRoute.isCurrent, isTrue);
    }
    // A second press during the opening transition must also close it.
    await _press(tester, 1);
    await tester.pump(const Duration(milliseconds: 20));
    await _press(tester, 1);
    await tester.pumpAndSettle();
    expect(find.text('切换线路'), findsNothing);
  });

  testWidgets(
      'rapid alternating colors wait for removal and never stack panels',
      (tester) async {
    await mount(tester);
    await _press(tester, 1);
    await tester.pumpAndSettle();
    // No settle between commands: yellow closes green, then green must remain
    // actionable even while the old route is reversing its animation.
    await _press(tester, 2);
    await tester.pump(const Duration(milliseconds: 40));
    await _press(tester, 1);
    await _press(tester, 2);
    await tester.pumpAndSettle();
    expect(find.text('选集'), findsOneWidget);
    expect(find.text('切换线路'), findsNothing);
    expect(player.currentState!.overlapped, isFalse);
    await _press(tester, 1);
    await tester.pumpAndSettle();
    expect(find.text('切换线路'), findsOneWidget);
    expect(find.text('选集'), findsNothing);
    expect(player.currentState!.overlapped, isFalse);
  });

  testWidgets('red and blue close either panel before running once',
      (tester) async {
    await mount(tester);
    for (final panel in [1, 2]) {
      for (final action in [0, 3]) {
        await _press(tester, panel);
        await tester.pumpAndSettle();
        await tester.sendKeyDownEvent(_colors[action],
            platform: 'web', physicalKey: _physical[action]);
        await tester.sendKeyRepeatEvent(_colors[action],
            platform: 'web', physicalKey: _physical[action]);
        await tester.sendKeyUpEvent(_colors[action],
            platform: 'web', physicalKey: _physical[action]);
        await tester.pumpAndSettle();
        expect(find.text('切换线路'), findsNothing);
        expect(find.text('选集'), findsNothing);
      }
    }
    expect(player.currentState!.effects, ['red', 'blue', 'red', 'blue']);
  });

  testWidgets('Back, header close and selecting an item reset panel ownership',
      (tester) async {
    await mount(tester);
    await _press(tester, 1);
    await tester.pumpAndSettle();
    await navigator.currentState!.maybePop();
    await tester.pumpAndSettle();
    await _press(tester, 1);
    await tester.pumpAndSettle();
    expect(find.text('切换线路'), findsOneWidget);
    // The current source has autofocus; OK selects and closes the real tile.
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(controller.lineSelections, 1);
    expect(find.text('切换线路'), findsNothing);
    await _press(tester, 2);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('选集'), findsNothing);
    await _press(tester, 2);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await _press(tester, 2);
    await tester.pumpAndSettle();
    expect(find.text('选集'), findsOneWidget);
  });

  testWidgets(
      'pointer entry uses the same coordinator and other dialogs block it',
      (tester) async {
    await mount(tester);
    await tester.tap(find.text('Pointer lines'));
    await tester.pumpAndSettle();
    await _press(tester, 1);
    await tester.pumpAndSettle();
    expect(find.text('切换线路'), findsNothing);
    await tester.tap(find.text('Pointer episodes'));
    await tester.pumpAndSettle();
    final unrelated = showDialog<void>(
      context: player.currentContext!,
      builder: (_) => const AlertDialog(
        title: Text('Unrelated dialog'),
        content:
            TextButton(autofocus: true, onPressed: null, child: Text('Wait')),
      ),
    );
    await tester.pumpAndSettle();
    for (var color = 0; color < 4; color++) {
      await _press(tester, color);
    }
    await tester.pumpAndSettle();
    expect(find.text('Unrelated dialog'), findsOneWidget);
    expect(player.currentState!.effects, isEmpty);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await unrelated;
    expect(find.text('选集'), findsOneWidget);
    await _press(tester, 2);
    await tester.pumpAndSettle();
    expect(find.text('选集'), findsNothing);
  });

  testWidgets(
      'leaving the player cancels queued actions and preserves other routes',
      (tester) async {
    await mount(tester);
    final state = player.currentState!;
    await _press(tester, 1);
    await tester.pumpAndSettle();
    await _press(tester, 2);
    await tester.pump(const Duration(milliseconds: 20));
    navigator.currentState!.push<void>(MaterialPageRoute(
      builder: (_) => const Scaffold(body: Text('Other page')),
    ));
    navigator.currentState!.removeRoute(state.pageRoute);
    await tester.pumpAndSettle();
    expect(find.text('Other page'), findsOneWidget);
    expect(find.text('选集'), findsNothing);
    expect(find.text('切换线路'), findsNothing);
    expect(state.effects, isEmpty);
    expect(state.routes.every((route) => route.overlayEntries.isEmpty), isTrue);
    for (var color = 0; color < 4; color++) {
      await _press(tester, color);
    }
    expect(state.effects, isEmpty);
  });
}
