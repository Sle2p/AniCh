import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xs/src/apis/info.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/log.dart';
import 'package:xs/src/utils/platform_info.dart';

class Utils {
  static late PackageInfo packageInfo;
  static DateFormat dateFormat = DateFormat('MM-dd HH:mm');
  static DateFormat dateFormatWithYear = DateFormat('yyyy-MM-dd HH:mm');
  static DateFormat timeFormat = DateFormat('HH:mm:ss');

  /// 处理时间
  static String parseTime(DateTime? dt) {
    if (dt == null) {
      return '';
    }

    var dtNow = DateTime.now();
    if (dt.year == dtNow.year &&
        dt.month == dtNow.month &&
        dt.day == dtNow.day) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }

    if (dt.year == dtNow.year) {
      return dateFormat.format(dt);
    }

    return dateFormatWithYear.format(dt);
  }

  /// 提示弹窗
  /// - `content` 内容
  /// - `title` 弹窗标题
  /// - `confirm` 确认按钮内容，留空为确定
  /// - `cancel` 取消按钮内容，留空为取消
  static Future<bool> showAlertDialog(
    String content, {
    String title = '',
    String confirm = '',
    String cancel = '',
    bool selectable = false,
    List<Widget>? actions,
  }) async {
    var result = await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(
            maxHeight: 400,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: AppStyle.edgeInsetsV12,
              child: selectable ? SelectableText(content) : Text(content),
            ),
          ),
        ),
        actions: [
          ...?actions,
          TextButton(
            onPressed: (() => Get.back(result: false)),
            child: Text(cancel.isEmpty ? '取消' : cancel),
          ),
          TextButton(
            onPressed: (() => Get.back(result: true)),
            child: Text(confirm.isEmpty ? '确定' : confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// 提示弹窗
  /// - `content` 内容
  /// - `title` 弹窗标题
  /// - `confirm` 确认按钮内容，留空为确定
  static Future<bool> showMessageDialog(String content,
      {String title = '', String confirm = '', bool selectable = false}) async {
    var result = await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Padding(
          padding: AppStyle.edgeInsetsV12,
          child: selectable ? SelectableText(content) : Text(content),
        ),
        actions: [
          TextButton(
            onPressed: (() => Get.back(result: true)),
            child: Text(confirm.isEmpty ? '确定' : confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void showRightDialog({
    required String title,
    Function()? onDismiss,
    required Widget child,
    double width = 320,
    bool useSystem = false,
  }) {
    SmartDialog.show(
      alignment: Alignment.topRight,
      animationBuilder: (controller, child, animationParam) {
        //从右到左
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(controller.view),
          child: child,
        );
      },
      useSystem: useSystem,
      maskColor: Colors.transparent,
      animationTime: const Duration(milliseconds: 200),
      builder: (context) => _rightDialogContent(
        context,
        title: title,
        child: child,
        width: width,
        onBack: () {
          SmartDialog.dismiss(status: SmartStatus.allCustom).then(
            (value) => onDismiss?.call(),
          );
        },
      ),
    );
  }

  /// A separately owned native route for TV player panels. The caller retains
  /// the route and waits for completed before opening another one.
  static RawDialogRoute<void> rightDialogRoute({
    required String title,
    required Widget child,
    required VoidCallback onBack,
    required Widget Function(Widget) wrap,
    double width = 320,
  }) =>
      RawDialogRoute<void>(
        barrierDismissible: true,
        barrierLabel: '关闭$title',
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => wrap(
          Material(
            type: MaterialType.transparency,
            child: Align(
              alignment: Alignment.topRight,
              child: _rightDialogContent(context,
                  title: title, child: child, width: width, onBack: onBack),
            ),
          ),
        ),
        transitionBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: child,
        ),
      );

  static Widget _rightDialogContent(
    BuildContext context, {
    required String title,
    required Widget child,
    required double width,
    required VoidCallback onBack,
  }) =>
      Container(
        width: width + MediaQuery.of(context).padding.right,
        padding: EdgeInsets.only(right: MediaQuery.of(context).padding.right),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: SafeArea(
          left: false,
          right: false,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
            child: Column(
              children: [
                ListTile(
                  visualDensity: VisualDensity.compact,
                  contentPadding: EdgeInsets.zero,
                  leading: IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    title,
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(.1),
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ),
      );

  static void hideRightDialog() {
    SmartDialog.dismiss(status: SmartStatus.allCustom);
  }

  static void showBottomSheet(
      {required String title,
      required Widget child,
      double maxWidth = 600,
      double maxHeight = double.infinity,
      double scrollControlDisabledMaxHeightRatio = 0.5}) {
    showModalBottomSheet(
      context: Get.context!,
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
      scrollControlDisabledMaxHeightRatio: scrollControlDisabledMaxHeightRatio,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      builder: (_) => Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(
              left: 12,
            ),
            title: Text(title),
            trailing: IconButton(
              onPressed: Get.back,
              icon: const Icon(Icons.close),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  /// 文本编辑的弹窗
  /// - `content` 编辑框默认的内容
  /// - `title` 弹窗标题
  /// - `confirm` 确认按钮内容
  /// - `cancel` 取消按钮内容
  static Future<String?> showEditTextDialog(String content,
      {String title = '',
      String? hintText,
      String confirm = '',
      String cancel = ''}) async {
    final TextEditingController textEditingController =
        TextEditingController(text: content);
    var result = await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Padding(
          padding: AppStyle.edgeInsetsT12,
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              //prefixText: title,
              contentPadding: AppStyle.edgeInsetsA12,
              hintText: hintText ?? title,
            ),
            // style: TextStyle(
            //     height: 1.0,
            //     color: Get.isDarkMode ? Colors.white : Colors.black),
            autofocus: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: textEditingController.text);
            },
            child: const Text('确定'),
          ),
        ],
      ),
      // barrierColor:
      //     Get.isDarkMode ? Colors.grey.withOpacity(.3) : Colors.black38,
    );
    return result;
  }

  static Future<T?> showOptionDialog<T>(
    List<T> contents,
    T value, {
    String title = '',
  }) async {
    var result = await Get.dialog(
      SimpleDialog(
        title: Text(title),
        children: contents
            .map(
              (e) => RadioListTile<T>(
                title: Text(e.toString()),
                value: e,
                groupValue: value,
                onChanged: (e) {
                  Get.back(result: e);
                },
              ),
            )
            .toList(),
      ),
    );
    return result;
  }

  static Future showStatement() async {
    var text = await rootBundle.loadString('assets/statement.txt');

    var result = await showAlertDialog(
      text,
      selectable: true,
      title: '免责声明',
      confirm: '已阅读并同意',
      cancel: '退出',
    );
    if (!result) {
      exit(0);
    }
  }

  static Future<T?> showMapOptionDialog<T>(
    Map<T, String> contents,
    T value, {
    String title = '',
  }) async {
    var result = await Get.dialog(
      SimpleDialog(
        title: Text(title),
        children: contents.keys
            .map(
              (e) => RadioListTile<T>(
                title: Text((contents[e] ?? '-').tr),
                value: e,
                groupValue: value,
                onChanged: (e) {
                  Get.back(result: e);
                },
              ),
            )
            .toList(),
      ),
    );
    return result;
  }

  static void checkUpdate({bool showMsg = false}) async {
    // Upstream releases target phones and desktops, not this TV build.
    if (PlatformInfo.isWebOS) {
      return;
    }
    try {
      final versionInfo = await InfoApi.checkUpdate();
      final currentVersion = packageInfo.version.split('.');
      final latestVersion = versionInfo.data['name'].split('.');
      // final latestVersion = '1.0.1'.split('.');

      final currentMajorNum = int.parse(currentVersion[0]);
      final currentMinorNum = int.parse(currentVersion[1]);
      final currentPatchNum = int.parse(currentVersion[2]);

      final latestMajorNum = int.parse(latestVersion[0]);
      final latestMinorNum = int.parse(latestVersion[1]);
      final latestPatchNum = int.parse(latestVersion[2]);

      final majorBool = latestMajorNum > currentMajorNum;
      final minorBool =
          latestMajorNum == currentMajorNum && latestMinorNum > currentMinorNum;
      final patchBool = latestMajorNum == currentMajorNum &&
          latestMinorNum == currentMinorNum &&
          latestPatchNum > currentPatchNum;
      // if (majorBool) {
      //   debugPrint('主版本强制更新');
      // }
      // if (minorBool) {
      //   debugPrint('子版本强制更新');
      // }
      // if (patchBool) {
      //   debugPrint('补丁版本不强制更新');
      // }
      if (majorBool || minorBool || patchBool) {
        Get.dialog(
          barrierDismissible: false,
          AlertDialog(
            title: Text(
              '发现新版本 ${versionInfo.data['name']}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            content: SelectableText(
              versionInfo.data['body'],
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            actionsPadding: AppStyle.edgeInsetsH12,
            actions: [
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!majorBool && !minorBool)
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text('取消'),
                        ),
                      ),
                    if (!majorBool && !minorBool) AppStyle.hGap12,
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          launchUrlString(
                            versionInfo.data['html_url'],
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: const Text('更新'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        if (showMsg) {
          SmartDialog.showToast('当前已经是最新版本了');
        }
      }
    } catch (e) {
      Log.logPrint(e);
      if (showMsg) {
        SmartDialog.showToast('检查更新失败');
      }
    }
  }

  static int parseVersion(String version) {
    var sp = version.split('.');
    var num = '';
    for (var item in sp) {
      num = num + item.padLeft(2, '0');
    }
    return int.parse(num);
  }

  static String onlineToString(int num) {
    if (num >= 10000) {
      return '${(num / 10000.0).toStringAsFixed(1)}万';
    }
    return num.toString();
  }

  /// 检查相册权限
  static Future<bool> checkPhotoPermission() async {
    try {
      if (!Platform.isIOS) {
        return true;
      }
      var status = await Permission.photos.status;
      if (status == PermissionStatus.granted) {
        return true;
      }
      status = await Permission.photos.request();
      if (status.isGranted) {
        return true;
      } else {
        SmartDialog.showToast(
          '请授予相册访问权限',
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  /// 检查文件权限
  static Future<bool> checkStorgePermission() async {
    try {
      if (!Platform.isAndroid) {
        return true;
      }
      Permission permission = Permission.storage;
      var androidIndo = await deviceInfo.androidInfo;
      if (androidIndo.version.sdkInt >= 33) {
        permission = Permission.manageExternalStorage;
      }

      var status = await permission.status;
      if (status == PermissionStatus.granted) {
        return true;
      }
      status = await permission.request();
      if (status.isGranted) {
        return true;
      } else {
        SmartDialog.showToast(
          '请授予文件访问权限',
        );
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  ///16进制颜色转换
  static Color convertHexColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 4) {
      hexColor = '00$hexColor';
    }

    if (hexColor.length == 6) {
      var R = int.parse(hexColor.substring(0, 2), radix: 16);
      var G = int.parse(hexColor.substring(2, 4), radix: 16);
      var B = int.parse(hexColor.substring(4, 6), radix: 16);
      return Color.fromARGB(255, R, G, B);
    }
    if (hexColor.length == 8) {
      var A = int.parse(hexColor.substring(0, 2), radix: 16);
      var R = int.parse(hexColor.substring(2, 4), radix: 16);
      var G = int.parse(hexColor.substring(4, 6), radix: 16);
      var B = int.parse(hexColor.substring(6, 8), radix: 16);

      return Color.fromARGB(A, R, G, B);
    }

    return Colors.white;
  }

  /// 复制内容到剪贴板
  static void copyToClipboard(String text) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      SmartDialog.showToast('已复制到剪贴板');
    } catch (e) {
      debugPrint(e.toString());
      SmartDialog.showToast('复制到剪贴板失败: $e');
    }
  }

  /// 获取剪贴板内容
  static Future<String?> getClipboard() async {
    try {
      var content = await Clipboard.getData(Clipboard.kTextPlain);
      if (content == null) {
        SmartDialog.showToast('无法读取剪贴板内容');
        return null;
      }
      return content.text;
    } catch (e) {
      debugPrint(e.toString());
      SmartDialog.showToast('读取剪切板内容失败：$e');
    }
    return null;
  }

  static bool isRegexFormat(String keyword) {
    return keyword.startsWith('/') &&
        keyword.endsWith('/') &&
        keyword.length > 2;
  }

  static String removeRegexFormat(String keyword) {
    return keyword.substring(1, keyword.length - 1);
  }

  static String parseFileSize(int size) {
    if (size < 1024) {
      return '$size B';
    }
    if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    }
    if (size < 1024 * 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(2)} MB';
    }
    return '${(size / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
  }

  // 分割数组
  static List<List<T>> splitList<T>(List<T> list, int size) {
    final splitted = <List<T>>[];
    for (int i = 0; i < list.length; i += size) {
      splitted.add(list.sublist(i, min(i + size, list.length)));
    }
    return splitted;
  }
}
