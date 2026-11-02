import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

/// A small native-readable setting. Changes apply on the next app launch.
class TvRenderSettings {
  static const fileName = 'anich-render-scale.txt';
  static final selectedScale = 2.obs;
  static final isSaving = false.obs;
  static Directory? _directory;
  static int _temporarySequence = 0;

  static Future<void> init({Directory? directory}) async {
    selectedScale.value = 2;
    _directory = null;
    try {
      _directory = directory ?? await getApplicationSupportDirectory();
      final file = File('${_directory!.path}/$fileName');
      if (await file.length() > 3) return;
      final contents = await file.readAsString();
      // Exactly the native parser's six canonical values are accepted.
      if (contents == '1' || contents == '1\n' || contents == '1\r\n') {
        selectedScale.value = 1;
      }
      // '2', '2\n', '2\r\n' and all invalid values use the default 2.
    } on FileSystemException {
      // Missing/unreadable settings preserve the current high-sampling default.
    } catch (_) {
      // A malformed encoding or unavailable support directory also uses 2.
    }
  }

  static Future<void> setScale(int value) async {
    if (value != 1 && value != 2) {
      throw ArgumentError.value(value, 'value', 'Expected 1 or 2');
    }
    if (isSaving.value) return;
    isSaving.value = true;
    File? temporary;
    try {
      final directory = _directory ?? await getApplicationSupportDirectory();
      await directory.create(recursive: true);
      final destination = File('${directory.path}/$fileName');
      temporary = File('${destination.path}.tmp-$pid-${_temporarySequence++}');
      await temporary.writeAsString('$value\n', flush: true);
      await temporary.rename(destination.path);
      _directory = directory;
      // Keep the previous selection if any write or rename operation fails.
      selectedScale.value = value;
    } finally {
      if (temporary != null) {
        try {
          if (await temporary.exists()) await temporary.delete();
        } on FileSystemException {
          // A leftover temporary file is never interpreted as the setting.
        }
      }
      isSaving.value = false;
    }
  }
}
