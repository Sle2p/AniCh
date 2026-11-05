import 'package:get_storage/get_storage.dart';
import 'package:xs/src/pages/search/models/search_type.dart';

class SearchHistoryStorage {
  SearchHistoryStorage({
    Object? Function(String key)? read,
    Future<void> Function(String key, List<String> value)? write,
  })  : _read = read ?? ((key) => GetStorage().read(key)),
        _write = write ?? ((key, value) => GetStorage().write(key, value));

  static const limit = 20;
  final Object? Function(String key) _read;
  final Future<void> Function(String key, List<String> value) _write;

  String _key(SearchType type) => 'search_history_${type.name}';

  List<String> load(SearchType type) {
    final saved = _read(_key(type));
    if (saved is! List) return [];
    final unique = <String>{};
    for (final value in saved.whereType<String>()) {
      final keyword = value.trim();
      if (keyword.isNotEmpty) unique.add(keyword);
      if (unique.length == limit) break;
    }
    return unique.toList();
  }

  Future<List<String>> remember(SearchType type, String value) async {
    final keyword = value.trim();
    final history = load(type);
    if (keyword.isEmpty) return history;
    history.remove(keyword);
    history.insert(0, keyword);
    final bounded = history.take(limit).toList();
    await _write(_key(type), bounded);
    return bounded;
  }

  Future<void> clear(SearchType type) => _write(_key(type), []);
}
