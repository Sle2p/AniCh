import 'package:flutter/material.dart';

import '../danmaku_stroke_text.dart';

class ScrollItemView extends StatefulWidget {
  final String text;
  final Color color;
  final double fontSize;
  final double duration;

  /// Local pixels from the top of the danmaku viewport.
  final double y;
  final double viewportWidth;
  final bool border;
  final Size size;
  final double strokeWidth;
  final FontWeight fontWeight;
  final double fontHeight;
  final Function(String)? onComplete;
  final Function(AnimationController)? onCreated;
  final bool self;
  final bool playing;
  const ScrollItemView({
    required this.text,
    this.fontSize = 16,
    this.duration = 10,
    this.color = Colors.white,
    this.y = 0,
    required this.viewportWidth,
    this.size = Size.zero,
    this.border = true,
    this.strokeWidth = 2.0,
    this.fontWeight = FontWeight.normal,
    this.fontHeight = 1.0,
    this.onComplete,
    this.onCreated,
    this.self = false,
    this.playing = true,
    required UniqueKey key,
  }) : super(key: key);

  @override
  State<ScrollItemView> createState() => _ScrollItemViewState();
}

class _ScrollItemViewState extends State<ScrollItemView>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: (widget.duration * 1000).round()),
      vsync: this,
    );
    controller.addStatusListener(statusUpdate);
    _animation = Tween<double>(
      begin: -widget.size.width,
      end: widget.viewportWidth + 1,
    ).animate(controller);
    widget.onCreated?.call(controller);
    if (widget.playing) controller.forward();
  }

  void statusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onComplete?.call(widget.key.hashCode.toString());
    }
  }

  @override
  void dispose() {
    controller.removeStatusListener(statusUpdate);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Positioned(
          top: widget.y,
          right: _animation.value,
          width: widget.size.width,
          height: widget.size.height,
          child: child!,
        ),
        child: DanmakuStrokeText(
          widget.text,
          color: widget.color,
          fontSize: widget.fontSize,
          strokeWidth: widget.strokeWidth,
          fontWeight: widget.fontWeight,
          fontHeight: widget.fontHeight,
          border: widget.border,
          self: widget.self,
        ),
      );
}
