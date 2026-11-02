import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Keep text away from the physical/video edge, including TVs with overscan.
/// Coordinates are local to the actual visible video, never to the display.
Rect danmakuSafeRect(Size viewport) {
  if (!viewport.width.isFinite ||
      !viewport.height.isFinite ||
      viewport.isEmpty) {
    return Rect.zero;
  }
  final shortest = viewport.shortestSide;
  final inset = math.min(math.max(8.0, shortest * 0.02), shortest / 4);
  return Rect.fromLTWH(inset, inset, math.max(0, viewport.width - inset * 2),
      math.max(0, viewport.height - inset * 2));
}
