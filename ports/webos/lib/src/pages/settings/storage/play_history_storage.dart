import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/utils/utils.dart';

class PlayHistoryStorage {
  static GetStorage box = GetStorage('playHistory');

  static void init() {
    history(box.getValues().toList());
  }

  // 历史记录
  static dynamic history = [].obs;

  // 清空历史记录
  static void clean() async {
    var result = await Utils.showAlertDialog('确定要清空观看记录吗?', title: '清空观看记录');
    if (!result) {
      return;
    }
    box.erase();
    history(box.getValues().toList());
  }

  // 删除历史记录
  static void remove(id) async {
    box.remove(id.toString());
    history(box.getValues().toList());
  }

  /// Merge with the latest saved record, including after reopening the player.
  /// GetStorage updates memory synchronously before its async disk flush.
  static Future<void> upsertProgress({
    required int id,
    required String? title,
    required String? image,
    required int episode,
    required String episodeTitle,
    required String episodeImage,
    required int position,
  }) {
    final stored = box.read<dynamic>('$id');
    final record =
        stored is Map ? Map<String, dynamic>.from(stored) : <String, dynamic>{};
    final previousEpisodes = record['episodes'];
    final episodes = previousEpisodes is List
        ? previousEpisodes
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList()
        : <Map<String, dynamic>>[];
    final index = episodes
        .indexWhere((item) => item['episode'].toString() == episode.toString());
    final date = DateTime.now().millisecondsSinceEpoch;
    final progress = <String, dynamic>{
      if (index >= 0) ...episodes[index],
      'episode': episode,
      'title': episodeTitle,
      'position': position,
      'date': date,
      'image': episodeImage,
    };
    if (index >= 0) {
      episodes[index] = progress;
    } else {
      episodes.add(progress);
    }
    record.addAll({
      'id': id,
      'title': title,
      'image': image,
      'date': date,
      'episodes': episodes,
    });
    return box.write('$id', record);
  }

  // 获取历史记录
  static int getLastPosition(id, episode) {
    final record = box.read<dynamic>(id.toString());
    final episodes = record is Map ? record['episodes'] : null;
    if (episodes is List) {
      for (final item in episodes) {
        if (item is Map && item['episode'].toString() == episode.toString()) {
          return int.tryParse('${item['position']}') ?? 0;
        }
      }
    }
    return 0;
  }
}
