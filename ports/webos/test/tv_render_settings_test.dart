import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/utils/tv_render_settings.dart';
import 'package:xs/src/widgets/tv_render_settings_card.dart';

class _GatedDirectory implements Directory {
  _GatedDirectory(this.delegate, this.ready);
  final Directory delegate;
  final Completer<void> ready;

  @override
  String get path => delegate.path;

  @override
  Future<Directory> create({bool recursive = false}) async {
    await ready.future;
    return delegate.create(recursive: recursive);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late Directory directory;
  late File setting;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('anich-render-test-');
    setting = File('${directory.path}/${TvRenderSettings.fileName}');
    await TvRenderSettings.init(directory: directory);
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  testWidgets('saving a mode does not claim that the running view has changed',
      (tester) async {
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(3840, 2160);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(body: TvRenderSettingsCard()),
    ));
    await tester.runAsync(() => TvRenderSettings.setScale(1));
    await tester.pump();
    expect(find.text('当前绘制：高采样绘制（4K）'), findsOneWidget);
    expect(
        tester
            .widgetList<RadioListTile<int>>(find.byType(RadioListTile<int>))
            .every((tile) => tile.groupValue == 1),
        isTrue);

    // Only changed engine metrics may change the reported current mode.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1920, 1080);
    await tester.pump();
    expect(find.text('当前绘制：标准绘制（1080p）'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test(
      'missing, malformed and extra whitespace settings use the existing scale 2 default',
      () async {
    expect(TvRenderSettings.selectedScale.value, 2);
    for (final contents in [
      '',
      '1.5',
      '12',
      '1 2',
      '1\u0000',
      '\u00a01',
      '\u30001',
      '0',
      '-1',
      ' 1',
      '1 ',
      '\t1',
      '1\n\n',
      '1\r',
      '1\r\n\n'
    ]) {
      await setting.writeAsString(contents);
      await TvRenderSettings.init(directory: directory);
      expect(TvRenderSettings.selectedScale.value, 2, reason: contents);
    }
    await setting.writeAsBytes([0xff, 0xfe]);
    await TvRenderSettings.init(directory: directory);
    expect(TvRenderSettings.selectedScale.value, 2);
  });

  test('native-compatible parsing accepts only the six canonical values',
      () async {
    for (final value in [1, 2]) {
      for (final contents in ['$value', '$value\n', '$value\r\n']) {
        await setting.writeAsString(contents);
        await TvRenderSettings.init(directory: directory);
        expect(TvRenderSettings.selectedScale.value, value, reason: contents);
      }
    }
  });

  test(
      'saved bytes are exact, replace the old file and survive reinitialization',
      () async {
    for (final value in [1, 2]) {
      await TvRenderSettings.setScale(value);
      expect(await setting.readAsBytes(), [value == 1 ? 49 : 50, 10]);
      expect(TvRenderSettings.selectedScale.value, value);
      await TvRenderSettings.init(directory: Directory(directory.path));
      expect(TvRenderSettings.selectedScale.value, value);
      expect(await directory.list().map((entry) => entry.path).toList(),
          [setting.path]);
    }
  });

  test(
      'failed atomic replacement retains the selection and cleans its temporary file',
      () async {
    await TvRenderSettings.setScale(1);
    await setting.delete();
    final blockedTarget = await Directory(setting.path).create();
    await File('${blockedTarget.path}/keep').writeAsString('keep');
    await expectLater(
        TvRenderSettings.setScale(2), throwsA(isA<FileSystemException>()));
    expect(TvRenderSettings.selectedScale.value, 1);
    expect(TvRenderSettings.isSaving.value, isFalse);
    expect(await directory.list().map((entry) => entry.path).toList(),
        [setting.path]);
    expect(await File('${blockedTarget.path}/keep').readAsString(), 'keep');
  });

  test('a second click cannot race an in-flight save', () async {
    final gate = Completer<void>();
    await TvRenderSettings.init(directory: _GatedDirectory(directory, gate));
    final firstSave = TvRenderSettings.setScale(1);
    expect(TvRenderSettings.isSaving.value, isTrue);
    await TvRenderSettings.setScale(2);
    expect(await setting.exists(), isFalse);
    gate.complete();
    await firstSave;
    expect(TvRenderSettings.selectedScale.value, 1);
    expect(await setting.readAsString(), '1\n');
    expect(TvRenderSettings.isSaving.value, isFalse);
  });
}
