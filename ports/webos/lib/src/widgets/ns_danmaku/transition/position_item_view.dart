import 'package:flutter/material.dart';
import '../danmaku_stroke_text.dart';

class PositionItemView extends StatefulWidget {
  final String text;
  final Color color;
  final double fontSize;
  final double y;
  final Size size;
  final bool strokeText;
  final bool isTop;
  final double strokeWidth;
  final Function(String)? onComplete;
  final Function(AnimationController)? onCreated;
  final FontWeight fontWeight;
  final double fontHeight;
  final bool self;
  final bool playing;
  const PositionItemView({
    required this.text,
    required this.size,
    this.fontSize = 16,
    this.color = Colors.white,
    this.y = 0,
    this.strokeText = true,
    this.isTop = true,
    this.strokeWidth = 2.0,
    this.onComplete,
    this.onCreated,
    this.fontWeight = FontWeight.normal,
    this.fontHeight = 1.0,
    this.self = false,
    this.playing = true,
    required UniqueKey key,
  }) : super(key: key);

  @override
  State<PositionItemView> createState() => _PositionItemViewState();
}

class _PositionItemViewState extends State<PositionItemView>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    controller.addStatusListener(statusUpdate);
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
  Widget build(BuildContext context) => Positioned(
        left: 0,
        right: 0,
        top: widget.isTop ? widget.y : null,
        bottom: widget.isTop ? null : widget.y,
        height: widget.size.height,
        child: Center(
          child: SizedBox(
            width: widget.size.width,
            height: widget.size.height,
            child: DanmakuStrokeText(
              widget.text,
              color: widget.color,
              fontSize: widget.fontSize,
              strokeWidth: widget.strokeWidth,
              fontWeight: widget.fontWeight,
              fontHeight: widget.fontHeight,
              self: widget.self,
              border: widget.strokeText,
            ),
          ),
        ),
      );
}
