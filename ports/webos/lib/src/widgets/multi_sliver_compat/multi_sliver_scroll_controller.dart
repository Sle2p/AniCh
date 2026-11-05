import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_compat.dart';

class MultiSliverCompatScrollController extends ScrollController {
  Key? debugKey;
  SliverCompat sliverCompat;
  late bool isMajorScrollController;

  MultiSliverCompatScrollController.major(this.debugKey, this.sliverCompat) {
    isMajorScrollController = true;
  }

  MultiSliverCompatScrollController.minor(this.debugKey, this.sliverCompat) {
    isMajorScrollController = false;
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    if (isMajorScrollController) {
      return MajorScrollPosition(sliverCompat,
          physics: const ScrollPhysics(), context: context, debugKey: debugKey);
    } else {
      return MinorScrollPosition(sliverCompat,
          physics: const ScrollPhysics(), context: context, debugKey: debugKey);
    }
  }
}

class MultiSliverCompatScrollPosition extends ScrollPositionWithSingleContext {
  SliverCompat sliverCompat;
  Key? debugKey;

  MultiSliverCompatScrollPosition(this.sliverCompat,
      {required super.physics, required super.context, this.debugKey});

  /// 所有的偏移量统一交给SliverCompat去处理；
  @override
  void applyUserOffset(double delta) {
    debugPrint('$debugKey notifyScroll');
    sliverCompat.submitUserOffset(this, delta);
  }

  /// 食用滚动量，然后返回未吃完的滚动量
  double applyClampedDragUpdate(double delta) {
    assert(delta != 0.0);
    final double minValue =
        delta < 0.0 ? -double.infinity : min(minScrollExtent, pixels);
    final double maxValue = delta > 0.0
        ? double.infinity
        : pixels < 0.0
            ? 0.0
            : max(maxScrollExtent, pixels);
    final double oldPixels = pixels;
    final double newPixels = clampDouble(pixels - delta, minValue, maxValue);
    final double clampedDelta = newPixels - pixels;
    if (clampedDelta == 0.0) {
      return delta;
    }
    final double overscroll = physics.applyBoundaryConditions(this, newPixels);
    final double actualNewPixels = newPixels - overscroll;
    final double offset = actualNewPixels - oldPixels;
    if (offset != 0.0) {
      forcePixels(actualNewPixels);
      didUpdateScrollPositionBy(offset);
    }
    return delta + offset;
  }
}

class MajorScrollPosition extends MultiSliverCompatScrollPosition {
  MajorScrollPosition(super.sliverCompat,
      {required super.physics, required super.context, super.debugKey});
}

class MinorScrollPosition extends MultiSliverCompatScrollPosition {
  MinorScrollPosition(super.sliverCompat,
      {required super.physics, required super.context, super.debugKey});
}
