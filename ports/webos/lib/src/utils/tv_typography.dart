import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

/// Uses the TV's installed font locally; no LG font is bundled or exported.
class TvTypography {
  static const systemFamilyName = 'LG Smart UI SC';
  static const systemFontPath = '/usr/share/fonts/LG_Smart_UI_SC.ttf';
  static const loadedFamilyName = 'AniChWebOSChinese';
  static bool _loaded = false;

  static String get systemFamily =>
      _loaded ? loadedFamilyName : systemFamilyName;

  static Future<void> loadSystemFont() async {
    String? failure;
    try {
      final bytes = await File(systemFontPath).readAsBytes();
      final loader = FontLoader(loadedFamilyName)
        ..addFont(Future.value(ByteData.sublistView(bytes)));
      await loader.load();
      _loaded = true;
    } catch (error) {
      _loaded = false;
      failure = error.runtimeType.toString();
      debugPrint('TV system font load failed: $failure');
    }
    try {
      await GetStorage('displayInfo').write('typography', {
        'systemFontLoaded': _loaded,
        'family': systemFamily,
        'sourcePath': systemFontPath,
        'error': failure,
        'recordedAt': DateTime.now().toUtc().toIso8601String(),
      });
    } catch (error) {
      debugPrint('Unable to record TV font status: ${error.runtimeType}');
    }
  }
}
