import 'dart:ui';

class DanmakuOption {
  /// 默认的字体大小
  final double fontSize;

  /// 显示区域，0.1-1.0
  final double area;

  /// 滚动弹幕运行时间，秒
  final double duration;

  /// 不透明度，0.1-1.0
  final double opacity;

  /// 隐藏顶部弹幕
  final bool hideTop;

  /// 隐藏底部弹幕
  final bool hideBottom;

  /// 隐藏滚动弹幕
  final bool hideScroll;

  /// 文本描边宽度
  final double strokeWidth;

  /// 文本是否有边框
  final bool strokeText;

  /// 字重
  final FontWeight fontWeight;

  /// 弹幕行高
  /// - 1.0表示字体大小的1倍，数字越大弹幕上下间距越大
  /// - 默认值`1.2`
  final double lineHeight;

  final bool self;

  DanmakuOption({
    this.fontSize = 16,
    this.area = 1.0,
    this.duration = 10,
    this.opacity = 1.0,
    this.hideBottom = false,
    this.hideScroll = false,
    this.hideTop = false,
    this.strokeText = true,
    this.strokeWidth = 2.0,
    this.fontWeight = FontWeight.normal,
    this.lineHeight = 1.0,
    this.self = false,
  });

  DanmakuOption copyWith(
      {double? fontSize,
      double? area,
      double? duration,
      double? opacity,
      bool? hideTop,
      bool? hideBottom,
      bool? hideScroll,
      bool? strokeText,
      double? strokeWidth,
      FontWeight? fontWeight,
      double? lineHeight,
      bool? self}) {
    return DanmakuOption(
        area: area ?? this.area,
        fontSize: fontSize ?? this.fontSize,
        duration: duration ?? this.duration,
        opacity: opacity ?? this.opacity,
        hideTop: hideTop ?? this.hideTop,
        hideBottom: hideBottom ?? this.hideBottom,
        hideScroll: hideScroll ?? this.hideScroll,
        strokeText: strokeText ?? this.strokeText,
        strokeWidth: strokeWidth ?? this.strokeWidth,
        fontWeight: fontWeight ?? this.fontWeight,
        lineHeight: lineHeight ?? this.lineHeight,
        self: self ?? this.self);
  }
}
