import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/pages/settings/storage/theme_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late GetStorage storage;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('anich-tv-font-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => directory.path,
    );
    await GetStorage('GetStorage', directory.path).initStorage;
    storage = GetStorage('ThemeFont', directory.path);
    await storage.initStorage;
  });

  test('TV font defaults to system and persists the Noto comparison choice',
      () async {
    ThemeSettingsStorage.init(storage: storage);
    expect(ThemeSettingsStorage.tvFont.value, 'system');
    expect(ThemeSettingsStorage.tvFontFamily,
        ThemeSettingsStorage.tvSystemFontFamily);
    expect(ThemeSettingsStorage.tvFontFallback,
        ['LG Display-Regular', 'NotoSansSC']);

    await ThemeSettingsStorage.setTvFont('noto');
    expect(ThemeSettingsStorage.tvFontFamily, 'NotoSansSC');
    await storage.queue.add(() async {});
    await File('${directory.path}/ThemeFont.gs')
        .copy('${directory.path}/RestartedThemeFont.gs');
    final restarted = GetStorage('RestartedThemeFont', directory.path);
    await restarted.initStorage;
    ThemeSettingsStorage.init(storage: restarted);
    expect(ThemeSettingsStorage.tvFont.value, 'noto');
    expect(ThemeSettingsStorage.tvFontFamily, 'NotoSansSC');

    await ThemeSettingsStorage.setTvFont('system');
    expect(restarted.read(ThemeSettingsStorage.tvFontKey), 'system');
    expect(ThemeSettingsStorage.tvFontFamily,
        ThemeSettingsStorage.tvSystemFontFamily);
    await restarted.write(ThemeSettingsStorage.tvFontKey, 'unknown-font');
    ThemeSettingsStorage.init(storage: restarted);
    expect(ThemeSettingsStorage.tvFont.value, 'system');
  });
}
