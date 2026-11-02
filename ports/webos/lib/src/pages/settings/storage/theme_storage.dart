import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/utils/tv_typography.dart';

class ThemeSettingsStorage {
  static GetStorage box = GetStorage();
  static TextEditingController textEditingController = TextEditingController();

  static void init({GetStorage? storage}) {
    if (storage != null) box = storage;
    themeMode(box.read('themeMode') ?? 0);
    isDynamic(box.read('isDynamic') ?? true);
    styleColor(box.read('styleColor') ?? 0xff3498db);
    tvFont(box.read(tvFontKey) == 'noto' ? 'noto' : 'system');
  }

  static const tvFontKey = 'tvFont';
  static final RxString tvFont = 'system'.obs;
  static String get tvSystemFontFamily => TvTypography.systemFamily;
  static String get tvFontFamily =>
      tvFont.value == 'noto' ? 'NotoSansSC' : tvSystemFontFamily;
  static List<String> get tvFontFallback => tvFont.value == 'noto'
      ? [tvSystemFontFamily, 'LG Display-Regular']
      : const ['LG Display-Regular', 'NotoSansSC'];

  static Future<void> setTvFont(String value) {
    tvFont(value == 'noto' ? 'noto' : 'system');
    return box.write(tvFontKey, tvFont.value);
  }

  // 主题模式
  static RxInt themeMode = 0.obs;
  static void setThemeMode(int e) {
    themeMode.value = e;
    box.write('themeMode', e);
    final mode = ThemeMode.values[e];
    Get.changeThemeMode(mode);
  }

  // 动态取色
  static RxBool isDynamic = true.obs;
  static void setIsDynamic(bool e) {
    isDynamic.value = e;
    box.write('isDynamic', e);
  }

  // 主题颜色
  static RxInt styleColor = 0xff3498db.obs;
  static void setStyleColor(int e) {
    styleColor.value = e;
    box.write('styleColor', e);
  }
}
