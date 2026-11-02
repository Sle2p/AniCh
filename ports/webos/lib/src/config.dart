import 'dart:io';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xs/src/utils/platform_info.dart';

late PackageInfo packageInfo;

class AppConfig {
  static RxString version = ''.obs;
  static RxString ua = ''.obs;
  static const baseUrl = String.fromEnvironment('ANICH_API_BASE',
      defaultValue: 'https://anich.sends.eu.org');
  static const bilibiliApiProxyUrl = 'https://dm.bili.i.me.cdn.cloudflare.net';
  static const qqVideoApiUrl = 'https://dm.video.qq.com';

  static Future<void> init({PackageInfo? info}) async {
    packageInfo = info ?? await PackageInfo.fromPlatform();
    version(packageInfo.version);
    String platform = '';
    if (PlatformInfo.isWebOS) {
      platform = 'webOS';
    } else if (Platform.isAndroid) {
      platform = 'Android';
    } else if (Platform.isIOS) {
      platform = 'IOS';
    } else if (Platform.isFuchsia) {
      platform = 'Fuchsia';
    } else if (Platform.isLinux) {
      platform = 'Linux';
    } else if (Platform.isMacOS) {
      platform = 'MacOS';
    } else if (Platform.isWindows) {
      platform = 'Windows';
    }

    ua('${packageInfo.packageName} $platform ${packageInfo.version}');
  }
}
