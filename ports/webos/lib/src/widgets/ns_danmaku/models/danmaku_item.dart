import 'package:flutter/material.dart';

enum DanmakuItemType {
  scroll,
  top,
  bottom,
}

class DanmakuItem {
  final String text;
  final Color color;
  final num time;
  final DanmakuItemType type;
  final bool self;
  DanmakuItem(this.text,
      {this.color = Colors.white,
      this.time = 0,
      this.type = DanmakuItemType.scroll,
      this.self = false});
}
