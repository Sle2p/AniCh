import 'package:flutter/material.dart';

class ColorUtil {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.isEmpty) hexString = '#ffffff';
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color decimalToColor(int decimalColor) {
    // 16777215 表示白色
    int red = (decimalColor >> 16) & 0xFF;
    int green = (decimalColor >> 8) & 0xFF;
    int blue = decimalColor & 0xFF;
    return Color.fromARGB(255, red, green, blue);
  }
}
