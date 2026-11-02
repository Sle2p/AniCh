import 'package:flutter_test/flutter_test.dart';
import 'package:xs/protobuf/danmaku.pb.dart';
import 'package:xs/src/pages/bangumi_vod/danmaku_merge.dart';

data_ comment(
  String id, {
  String from = '',
  double time = 12.5,
  String text = '这一幕很好看',
  int type = 1,
  String color = '#ffffff',
}) =>
    data_(
      id: id,
      from: from,
      time: time,
      text: text,
      type: type,
      color: color,
    );

void main() {
  test('a mirrored pair keeps the original gamer record in either input order',
      () {
    final imported = comment('gamer-original', from: 'gamer_123');
    final mirror = comment('anonymous-mirror');

    for (final input in [
      [imported, mirror],
      [mirror, imported],
    ]) {
      final result = mergeImportedDanmaku(input);
      expect(result, hasLength(1));
      expect(identical(result.single, imported), isTrue);
      expect(mirror.from, isEmpty,
          reason: 'Merging must not mutate the input.');
    }
  });

  test('same-source comments with distinct IDs remain separate', () {
    final imported = [
      comment('gamer-a', from: 'gamer_123'),
      comment('gamer-b', from: 'gamer_123'),
    ];
    final anonymous = [comment('anonymous-a'), comment('anonymous-b')];

    expect(mergeImportedDanmaku(imported), unorderedEquals(imported));
    expect(mergeImportedDanmaku(anonymous), unorderedEquals(anonymous));
  });

  test('two gamer comments pair with one mirror without losing either original',
      () {
    final first = comment('gamer-a', from: 'gamer_123');
    final second = comment('gamer-b', from: 'gamer_456');
    final mirror = comment('anonymous-mirror');

    final result = mergeImportedDanmaku([mirror, first, second]);
    expect(result, unorderedEquals([first, second]));
  });

  test('one gamer comment removes only one of two anonymous copies', () {
    final imported = comment('gamer-a', from: 'gamer_123');
    final firstMirror = comment('anonymous-a');
    final secondMirror = comment('anonymous-b');

    final result = mergeImportedDanmaku([firstMirror, imported, secondMirror]);
    expect(result, hasLength(2));
    expect(result.any((item) => identical(item, imported)), isTrue);
    final remaining = result.where((item) => item.from.isEmpty).toList();
    expect(remaining, hasLength(1));
    expect(
      identical(remaining.single, firstMirror) ||
          identical(remaining.single, secondMirror),
      isTrue,
    );
  });

  test('other sources and nonnumeric gamer names are never absorbed', () {
    final imported = comment('gamer-original', from: 'gamer_123');
    final mirror = comment('anonymous-mirror');
    final unrelated = [
      comment('bilibili', from: 'bilibili_123'),
      comment('qq', from: 'qq_123'),
      comment('invalid-gamer', from: 'gamer_xyz'),
      comment('gamer-suffix', from: 'gamer_123_extra'),
    ];

    expect(
      mergeImportedDanmaku([imported, mirror, ...unrelated]),
      unorderedEquals([imported, ...unrelated]),
    );
  });

  test('time, type, color and text must all match exactly', () {
    final imported = comment('gamer-original', from: 'gamer_123');
    final distinctComments = [
      comment('different-time', time: 12.5001),
      comment('different-type', type: 5),
      comment('different-color', color: '#FFFFFF'),
      comment('different-text', text: '这一幕很好看 '),
    ];

    for (final different in distinctComments) {
      expect(
        mergeImportedDanmaku([imported, different]),
        unorderedEquals([imported, different]),
        reason: '${different.id} is not an exact mirror.',
      );
    }
  });

  test(
      'matching mirrors arriving in later batches merge across accumulated data',
      () {
    final imported = comment('gamer-a', from: 'gamer_123');
    final secondImported = comment('gamer-b', from: 'gamer_123');
    final firstMirror = comment('anonymous-a');
    final secondMirror = comment('anonymous-b');
    final accumulated = <data_>[firstMirror];

    expect(mergeImportedDanmaku(accumulated), [firstMirror]);
    accumulated.add(imported);
    expect(mergeImportedDanmaku(accumulated), [imported]);
    accumulated.addAll([secondImported, secondMirror]);
    final result = mergeImportedDanmaku(accumulated);
    expect(result, unorderedEquals([imported, secondImported]));
    expect(mergeImportedDanmaku(result), unorderedEquals(result));
    expect(accumulated, hasLength(4),
        reason: 'The accumulated input remains available for later batches.');
  });
}
