import 'dart:convert';

import 'package:xs/protobuf/danmaku.pb.dart';

/// AniCh can return a Gamer import and a second copy without its source tag.
/// Pair only those exact mirrors; different people repeating a phrase in the
/// same source, or comments from another source, must remain separate.
List<data_> mergeImportedDanmaku(Iterable<data_> items) {
  final list = items.toList();
  final imported = <String, int>{};
  final gamerSource = RegExp(r'^gamer_\d+$');
  String signature(data_ item) =>
      jsonEncode([item.time, item.text, item.type, item.color]);

  for (final item in list) {
    if (!gamerSource.hasMatch(item.from)) continue;
    final key = signature(item);
    imported.update(key, (count) => count + 1, ifAbsent: () => 1);
  }
  return list.where((item) {
    if (item.from.isNotEmpty) return true;
    final key = signature(item);
    final remaining = imported[key] ?? 0;
    if (remaining == 0) return true;
    imported[key] = remaining - 1;
    return false;
  }).toList();
}
