import 'package:flutter/material.dart';

class SubordinateScrollController extends ScrollController {
  SubordinateScrollController(
    this.parent, {
    String subordinateDebugLabel = 'subordinate',
  });
  final ScrollController parent;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) =>
      parent.createScrollPosition(physics, context, oldPosition);

  @override
  void attach(ScrollPosition position) {
    try {
      if (position.runtimeType.toString() != '_NestedScrollPosition') return;
      parent.attach(position);
      super.attach(position);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void detach(ScrollPosition position) {
    try {
      if (position.runtimeType.toString() != '_NestedScrollPosition') return;
      parent.detach(position);
      super.detach(position);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    for (final position in positions) {
      parent.detach(position);
    }

    super.dispose();
  }
}
