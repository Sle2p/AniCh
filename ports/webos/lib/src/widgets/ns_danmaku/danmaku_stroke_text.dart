import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Measure and draw with identical font fallback, scaling and line metrics.
/// The outer padding contains the stroke instead of clipping the first row.
class DanmakuStrokeText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final Color color;
  final double fontSize;
  final double strokeWidth;
  final FontWeight fontWeight;
  final double fontHeight;
  final bool self;
  final bool border;
  const DanmakuStrokeText(this.text,
      {super.key,
      this.textAlign = TextAlign.left,
      this.color = Colors.white,
      this.fontSize = 16,
      this.strokeWidth = 2.0,
      this.fontWeight = FontWeight.normal,
      this.fontHeight = 1.0,
      this.self = false,
      this.border = true});

  static String singleLine(String text) =>
      text.replaceAll(RegExp(r'[\r\n]+'), ' ');

  static const textHeightBehavior = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  static double paintInset(double strokeWidth, bool border, bool self) =>
      (border ? math.max(0, strokeWidth) / 2 : 0) + 1 + (self ? 1 : 0);

  static TextStyle textStyle(BuildContext context, double fontSize,
          FontWeight fontWeight, double fontHeight) =>
      DefaultTextStyle.of(context).style.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            height: math.max(1, fontHeight),
          );

  static Size measure(BuildContext context, String text,
      {required double fontSize,
      required FontWeight fontWeight,
      required double fontHeight,
      required double strokeWidth,
      required bool border,
      bool self = false}) {
    final painter = TextPainter(
      text: TextSpan(
          text: singleLine(text),
          style: textStyle(context, fontSize, fontWeight, fontHeight)),
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.textScalerOf(context),
      locale: Localizations.maybeLocaleOf(context),
      textHeightBehavior: textHeightBehavior,
      maxLines: 1,
    )..layout();
    final inset = paintInset(strokeWidth, border, self);
    final size = Size(painter.width + inset * 2, painter.height + inset * 2);
    painter.dispose();
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final style = textStyle(context, fontSize, fontWeight, fontHeight);
    Widget layer(TextStyle layerStyle) => Text(
          singleLine(text),
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.clip,
          textDirection: TextDirection.ltr,
          textAlign: textAlign,
          textHeightBehavior: textHeightBehavior,
          style: layerStyle,
        );
    return DecoratedBox(
      decoration: BoxDecoration(
          border: self ? Border.all(color: color, width: 1) : null),
      child: Padding(
        padding: EdgeInsets.all(paintInset(strokeWidth, border, self)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (border)
              layer(style.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = strokeWidth
                  ..strokeCap = StrokeCap.round
                  ..strokeJoin = StrokeJoin.round
                  ..color = getBorderColor(color),
              )),
            layer(style.copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  Color getBorderColor(Color color) {
    final brightness =
        ((color.red * 299) + (color.green * 587) + (color.blue * 114)) / 1000;
    return brightness > 70 ? Colors.black : Colors.white;
  }
}
