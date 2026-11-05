import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DanmakuSettingsStorage {
  static GetStorage box = GetStorage();
  static TextEditingController textEditingController = TextEditingController();

  static void init() {
    danmakuEnable(box.read('danmakuEnable') ?? true);
    danmakuArea(box.read('danmakuArea') ?? 1.0);
    danmakuOpacity(box.read('danmakuOpacity') ?? 1.0);
    danmakuSize(box.read('danmakuSize') ?? 14.0);
    danmakuSpeed(box.read('danmakuSpeed') ?? 8.0);
    bilibiliDanmakuEnable(box.read('bilibiliDanmakuEnable') ?? true);
    bilibiliHmtDanmakuEnable(box.read('bilibiliHmtDanmakuEnable') ?? true);
    qqDanmakuEnable(box.read('qqDanmakuEnable') ?? true);
  }

  // 弹幕开关
  static RxBool danmakuEnable = true.obs;
  static void setDanmakuEnable(bool e) {
    danmakuEnable.value = e;
    box.write('danmakuEnable', e);
  }

  // 弹幕显示区域
  static RxDouble danmakuArea = 1.0.obs;
  static void setDanmakuArea(double e) {
    danmakuArea.value = e;
    box.write('danmakuArea', e);
  }

  // 弹幕透明度
  static RxDouble danmakuOpacity = 1.0.obs;
  static void setDanmakuOpacity(double e) {
    danmakuOpacity.value = e;
    box.write('danmakuOpacity', e);
  }

  // 弹幕字体大小
  static RxDouble danmakuSize = 14.0.obs;
  static void setDanmakuSize(double e) {
    danmakuSize.value = e;
    box.write('danmakuSize', e);
  }

  // 弹幕速度
  static RxDouble danmakuSpeed = 8.0.obs;
  static void setDanmakuSpeed(double e) {
    danmakuSpeed.value = e;
    box.write('danmakuSpeed', e);
  }

  // 哔哩哔哩弹幕开关
  static RxBool bilibiliDanmakuEnable = true.obs;
  static void setBilibiliDanmakuEnable(bool e) {
    bilibiliDanmakuEnable.value = e;
    box.write('bilibiliDanmakuEnable', e);
  }

  // 哔哩哔哩(港澳台)弹幕开关
  static RxBool bilibiliHmtDanmakuEnable = true.obs;
  static void setBilibiliHmtDanmakuEnable(bool e) {
    bilibiliHmtDanmakuEnable.value = e;
    box.write('bilibiliHmtDanmakuEnable', e);
  }

  // 腾讯视频弹幕开关
  static RxBool qqDanmakuEnable = true.obs;
  static void setQQDanmakuEnable(bool e) {
    qqDanmakuEnable.value = e;
    box.write('qqDanmakuEnable', e);
  }
}
