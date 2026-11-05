import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeSettingsStorage {
  static GetStorage box = GetStorage();
  static TextEditingController textEditingController = TextEditingController();

  static void init() {
    final user = box.read('user');
    avatar(user['avatar'] ?? '');
    isDynamic(box.read('isDynamic') ?? true);
    styleColor(box.read('styleColor') ?? 0xff3498db);
  }

  // 主题模式
  static RxString avatar = ''.obs;

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
