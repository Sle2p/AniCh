import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/utils/log.dart';
import 'package:xs/src/utils/utils.dart';

class DanmakuShieldStorage {
  static String storageKey = 'DanmakuShieldList';
  static GetStorage box = GetStorage();
  static RxSet<String> shieldList = <String>{}.obs;
  static TextEditingController textEditingController = TextEditingController();

  static void init() {
    final list = box.read(storageKey);
    if (list != null) {
      shieldList.addAll(list.cast<String>());
    }
  }

  static void add() {
    if (textEditingController.text.isEmpty) {
      SmartDialog.showToast('请输入关键词');
      return;
    }

    addShieldList(textEditingController.text.trim());
    textEditingController.text = '';
  }

  static void remove(String item) {
    removeShieldList(item);
  }

  static void addShieldList(String e) {
    shieldList.add(e);
    box.write(storageKey, shieldList.toList());
  }

  static void removeShieldList(String e) {
    shieldList.remove(e);
    box.write(storageKey, shieldList.toList());
  }

  // 关键词屏蔽检查 屏蔽返回false 正常返回true
  static bool shieldCheck(str) {
    for (var keyword in shieldList) {
      Pattern? pattern;
      if (Utils.isRegexFormat(keyword)) {
        String removedSlash = Utils.removeRegexFormat(keyword);
        try {
          pattern = RegExp(removedSlash);
        } catch (e) {
          // should avoid this during add keyword
          Log.d('关键词：$keyword 正则格式错误');
        }
      } else {
        pattern = keyword;
      }
      if (pattern != null && str.contains(pattern)) {
        Log.d('关键词：$keyword\n已屏蔽消息内容：$str');
        return false;
      }
    }
    return true;
  }

  static List defaultShieldCheck(data) {
    List list = [];
    for (final item in data) {
      final content = item.content;
      bool isTrue = true;
      for (var keyword in defaultList) {
        String removedSlash = Utils.removeRegexFormat(keyword);
        RegExp pattern = RegExp(removedSlash);
        if (pattern.hasMatch(content)) {
          isTrue = false;
          break;
        }
      }
      if (isTrue) {
        list.add(item);
      }
    }
    return list;
  }

  static List<String> defaultList = [];
}
