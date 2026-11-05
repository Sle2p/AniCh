import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    super.key,
    this.expandText = '展开',
    this.collapseText = '收起',
    this.expanded = false,
    this.linkColor,
    this.style,
    this.textDirection,
    this.textAlign,
    this.maxLines = 2,
    this.semanticsLabel,
  });

  final String text;
  final String expandText;
  final String collapseText;
  final bool expanded;
  final Color? linkColor;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final int maxLines;
  final String? semanticsLabel;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;
  late TapGestureRecognizer _tapGestureRecognizer;

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _toggleExpanded;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;

    final textDirection = widget.textDirection ?? Directionality.of(context);

    final locale = Localizations.maybeLocaleOf(context);

    final linkText = _expanded ? ' ${widget.collapseText}' : widget.expandText;

    final linkColor = widget.linkColor ?? Theme.of(context).colorScheme.primary;

    final link = TextSpan(
      text: _expanded ? '' : '\u2026 ',
      style: effectiveTextStyle,
      children: <TextSpan>[
        TextSpan(
          text: linkText,
          style: effectiveTextStyle?.copyWith(
            color: linkColor,
          ),
          recognizer: _tapGestureRecognizer,
        )
      ],
    );

    final text = TextSpan(
      text: widget.text,
      style: effectiveTextStyle,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          maxLines: widget.maxLines,
          locale: locale,
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkWidth = textPainter.width;
        // print(
        //     ' textPainter-min${textPainter.width} textPainter-max${textPainter.maxIntrinsicWidth}');
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // print(
        //     'linkSize-width:${linkSize.width} linkSize-height:${linkSize.height} textSize-width:${textSize.width} textSize-height:${textSize.height} linkWidth${linkWidth}');
        final position = textPainter.getPositionForOffset(Offset(
          textSize.width - linkWidth,
          textSize.height,
        ));
        final endOffset = textPainter.getOffsetBefore(position.offset);

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            style: effectiveTextStyle,
            text: _expanded ? widget.text : widget.text.substring(0, endOffset),
            children: <TextSpan>[
              link,
            ],
          );
        } else {
          textSpan = text;
        }

        return RichText(
          text: textSpan,
          softWrap: true,
          textDirection: textDirection,
          textAlign: textAlign,
          overflow: TextOverflow.clip,
        );
      },
    );

    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }

    return result;
  }
}
