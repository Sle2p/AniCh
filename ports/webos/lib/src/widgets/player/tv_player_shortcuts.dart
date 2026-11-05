import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TvPlayerPanel { lines, episodes }

/// Owns only this player's two selection routes. Commands are serialized across
/// reverse animations, so a late dismissal can never pop a newly opened panel.
class TvPlayerPanelCoordinator {
  TvPlayerPanelCoordinator({
    required BuildContext context,
    required this.buildRoute,
    required this.onDanmaku,
    required this.onFullscreen,
    required this.canOpen,
  })  : _navigator = Navigator.of(context),
        _pageRoute = ModalRoute.of(context);

  final RawDialogRoute<void> Function(
          TvPlayerPanel panel, VoidCallback close, Widget Function(Widget) wrap)
      buildRoute;
  final VoidCallback onDanmaku;
  final VoidCallback onFullscreen;
  final bool Function(TvPlayerPanel) canOpen;
  final NavigatorState _navigator;
  final ModalRoute<dynamic>? _pageRoute;
  RawDialogRoute<void>? _route;
  TvPlayerPanel? _panel;
  Future<void> _pending = Future<void>.value();
  bool _disposed = false;

  bool get _canHandle =>
      !_disposed &&
      (_pageRoute?.isActive ?? true) &&
      ((_pageRoute?.isCurrent ?? true) || (_route?.isCurrent ?? false));

  Widget wrap(Widget child) => TvPlayerShortcuts(
        canHandle: () => _canHandle,
        onDanmaku: () => _afterClosing(onDanmaku),
        onLines: () => togglePanel(TvPlayerPanel.lines),
        onEpisodes: () => togglePanel(TvPlayerPanel.episodes),
        onFullscreen: () => _afterClosing(onFullscreen),
        child: child,
      );

  void _enqueue(Future<void> Function() command) {
    _pending = _pending.then((_) async {
      if (_canHandle) await command();
    }).catchError((Object error, StackTrace stack) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stack,
        library: 'AniCh TV player shortcuts',
      ));
    });
  }

  void togglePanel(TvPlayerPanel panel) {
    _enqueue(() async {
      final samePanel = _panel == panel && (_route?.isActive ?? false);
      await _closePanel();
      if (samePanel || !_canHandle || !canOpen(panel)) return;
      late final RawDialogRoute<void> route;
      route = buildRoute(panel, () {
        _enqueue(() async {
          if (identical(_route, route)) await _closePanel();
        });
      }, wrap);
      _panel = panel;
      _route = route;
      unawaited(_navigator.push<void>(route));
      // completed, unlike popped, waits until the overlay/animation is gone.
      unawaited(route.completed.then((_) {
        if (identical(_route, route)) {
          _route = null;
          _panel = null;
        }
      }));
    });
  }

  void _afterClosing(VoidCallback action) {
    _enqueue(() async {
      await _closePanel();
      if (_canHandle) action();
    });
  }

  Future<void> _closePanel() async {
    final route = _route;
    if (route == null) return;
    final navigator = route.navigator;
    if (navigator != null && route.isActive) {
      if (route.isCurrent) {
        navigator.pop();
      } else {
        // Never dismiss a different route that appeared above our own panel.
        navigator.removeRoute(route);
      }
    }
    await route.completed;
    if (identical(_route, route)) {
      _route = null;
      _panel = null;
    }
  }

  void dispose() {
    _disposed = true;
    final route = _route;
    _route = null;
    _panel = null;
    // The page may be disposing during a navigator update. Wait until that
    // update finishes, then remove this exact route without touching the top.
    if (route != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (route.isActive) route.navigator?.removeRoute(route);
      });
    }
  }
}

/// Page-local remote shortcuts. The caller enables this wrapper only on TV.
/// Its Focus is an ancestor handler, not another stop in D-pad navigation.
class TvPlayerShortcuts extends StatelessWidget {
  const TvPlayerShortcuts({
    super.key,
    required this.child,
    required this.onDanmaku,
    required this.onLines,
    required this.onEpisodes,
    required this.onFullscreen,
    this.canHandle,
  });

  final Widget child;
  final VoidCallback onDanmaku;
  final VoidCallback onLines;
  final VoidCallback onEpisodes;
  final VoidCallback onFullscreen;
  final bool Function()? canHandle;

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      includeSemantics: false,
      onKeyEvent: (node, event) {
        // A system dialog may leave the underlying button focused. Its route
        // still blocks shortcuts, including during the opening transition.
        if (!(canHandle?.call() ?? (route?.isCurrent ?? true))) {
          return KeyEventResult.ignored;
        }
        final action = <LogicalKeyboardKey, VoidCallback>{
          LogicalKeyboardKey.colorF0Red: onDanmaku,
          LogicalKeyboardKey.colorF1Green: onLines,
          LogicalKeyboardKey.colorF2Yellow: onEpisodes,
          LogicalKeyboardKey.colorF3Blue: onFullscreen,
        }[event.logicalKey];
        if (action == null) return KeyEventResult.ignored;
        if (event is KeyDownEvent && !event.synthesized) action();
        // Repeats, releases and focus-recovery synthesis are consumed without
        // opening another panel or toggling the same option again.
        return KeyEventResult.handled;
      },
      child: child,
    );
  }
}
