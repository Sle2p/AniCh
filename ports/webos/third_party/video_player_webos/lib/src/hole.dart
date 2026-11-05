import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A widget that creates a transparent hole in the Flutter UI.
class Hole extends LeafRenderObjectWidget {
  /// Creates a [Hole].
  const Hole({Key? key}) : super(key: key);

  @override
  RenderBox createRenderObject(BuildContext context) => _HoleBox();
}

/// A render object of the [Hole] widget.
class _HoleBox extends RenderBox {
  @override
  bool get sizedByParent => true;

  @override
  bool get alwaysNeedsCompositing => true;

  @override
  bool get isRepaintBoundary => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.addLayer(_HoleLayer(rect: offset & size));
  }
}

/// A composite layer that draws a rect with blend mode.
class _HoleLayer extends Layer {
  _HoleLayer({required this.rect});

  final Rect rect;

  @override
  void addToScene(SceneBuilder builder, [Offset layerOffset = Offset.zero]) {
    builder.addPicture(layerOffset, _createHolePicture(rect));
  }

  Picture _createHolePicture(Rect holeRect) {
    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint();
    paint.color = Colors.transparent;
    paint.blendMode = BlendMode.src;
    canvas.drawRect(rect, paint);
    return recorder.endRecording();
  }
}
