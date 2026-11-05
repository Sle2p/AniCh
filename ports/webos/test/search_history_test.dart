import 'package:flutter_test/flutter_test.dart';
import 'package:xs/src/pages/search/models/search_type.dart';
import 'package:xs/src/pages/search_panel/history_storage.dart';

void main() {
  late Map<String, Object?> saved;
  SearchHistoryStorage storage() => SearchHistoryStorage(
        read: (key) => saved[key],
        write: (key, value) async => saved[key] = List<String>.of(value),
      );
  setUp(() => saved = {});

  test('search history survives a new storage instance and promotes duplicates',
      () async {
    await storage().remember(SearchType.bangumi, '  葬送的芙莉莲  ');
    await storage().remember(SearchType.bangumi, '一拳超人');
    await storage().remember(SearchType.bangumi, '葬送的芙莉莲');
    expect(storage().load(SearchType.bangumi), ['葬送的芙莉莲', '一拳超人']);
  });

  test('blank keywords are ignored and only the newest twenty are retained',
      () async {
    await storage().remember(SearchType.bangumi, '   ');
    expect(saved, isEmpty);
    for (var index = 0; index < 25; index++) {
      await storage().remember(SearchType.bangumi, '番剧$index');
    }
    final history = storage().load(SearchType.bangumi);
    expect(history.length, SearchHistoryStorage.limit);
    expect(history.first, '番剧24');
    expect(history.last, '番剧5');
  });

  test('clearing anime history keeps picture searches and other stored data',
      () async {
    saved['token'] = 'fixture';
    await storage().remember(SearchType.bangumi, '动漫');
    await storage().remember(SearchType.picture, '插画');
    await storage().clear(SearchType.bangumi);
    expect(storage().load(SearchType.bangumi), isEmpty);
    expect(storage().load(SearchType.picture), ['插画']);
    expect(saved['token'], 'fixture');
  });
}
