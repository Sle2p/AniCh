import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Preferences share the app's initialized, writable GetStorage container.
class PlaybackSettingsStorage {
  static GetStorage box = GetStorage();
  static const settingsKey = 'tvPlaybackSettings';
  static const lineMemoryKey = 'tvPlaybackLineMemory';
  static const speedOptions = <double>[0.5, 0.75, 1, 1.25, 1.5, 1.75, 2];
  static const scaleOptions = <int, String>{
    0: '原始比例',
    1: '拉伸铺满',
    3: '16:9',
    4: '4:3',
  };
  static const seekOptions = <int>[5, 10, 15, 30, 60];

  static final defaultSpeed = 1.0.obs;
  static final defaultScaleMode = 0.obs;
  static final seekBackwardSeconds = 10.obs;
  static final seekForwardSeconds = 10.obs;
  static final autoNext = true.obs;
  static final autoSwitchLine = true.obs;
  static final autoFullScreen = true.obs;
  static final rememberLine = true.obs;

  static void init({GetStorage? storage}) {
    if (storage != null) box = storage;
    final raw = box.read<dynamic>(settingsKey);
    final values = raw is Map ? raw : const {};
    final speed = values['defaultSpeed'];
    defaultSpeed.value = speed is num && speedOptions.contains(speed.toDouble())
        ? speed.toDouble()
        : 1;
    defaultScaleMode.value = values['defaultScaleMode'] is int &&
            scaleOptions.containsKey(values['defaultScaleMode'])
        ? values['defaultScaleMode'] as int
        : 0;
    seekBackwardSeconds.value = values['seekBackwardSeconds'] is int &&
            seekOptions.contains(values['seekBackwardSeconds'])
        ? values['seekBackwardSeconds'] as int
        : 10;
    seekForwardSeconds.value = values['seekForwardSeconds'] is int &&
            seekOptions.contains(values['seekForwardSeconds'])
        ? values['seekForwardSeconds'] as int
        : 10;
    autoNext.value = values['autoNext'] is bool ? values['autoNext'] : true;
    autoSwitchLine.value =
        values['autoSwitchLine'] is bool ? values['autoSwitchLine'] : true;
    autoFullScreen.value =
        values['autoFullScreen'] is bool ? values['autoFullScreen'] : true;
    rememberLine.value =
        values['rememberLine'] is bool ? values['rememberLine'] : true;
  }

  static Future<void> _save() => box.write(settingsKey, {
        'defaultSpeed': defaultSpeed.value,
        'defaultScaleMode': defaultScaleMode.value,
        'seekBackwardSeconds': seekBackwardSeconds.value,
        'seekForwardSeconds': seekForwardSeconds.value,
        'autoNext': autoNext.value,
        'autoSwitchLine': autoSwitchLine.value,
        'autoFullScreen': autoFullScreen.value,
        'rememberLine': rememberLine.value,
      });

  static Future<void> setDefaultSpeed(double value) {
    if (!speedOptions.contains(value)) return Future.value();
    defaultSpeed.value = value;
    return _save();
  }

  static Future<void> setDefaultScaleMode(int value) {
    if (!scaleOptions.containsKey(value)) return Future.value();
    defaultScaleMode.value = value;
    return _save();
  }

  static Future<void> setSeekBackwardSeconds(int value) {
    if (!seekOptions.contains(value)) return Future.value();
    seekBackwardSeconds.value = value;
    return _save();
  }

  static Future<void> setSeekForwardSeconds(int value) {
    if (!seekOptions.contains(value)) return Future.value();
    seekForwardSeconds.value = value;
    return _save();
  }

  static Future<void> setAutoNext(bool value) {
    autoNext.value = value;
    return _save();
  }

  static Future<void> setAutoSwitchLine(bool value) {
    autoSwitchLine.value = value;
    return _save();
  }

  static Future<void> setAutoFullScreen(bool value) {
    autoFullScreen.value = value;
    return _save();
  }

  static Future<void> setRememberLine(bool value) {
    rememberLine.value = value;
    return _save();
  }

  static int preferredLineIndex(int bangumiId, List<String> lineKeys) {
    if (!rememberLine.value || lineKeys.isEmpty) return 0;
    final raw = box.read<dynamic>(lineMemoryKey);
    final saved = raw is Map ? raw['$bangumiId'] : null;
    if (saved is! Map || saved['key'] is! String) return 0;
    final index = saved['index'];
    // An index is only reusable when it still names the same source. Signed
    // episode URLs and their ordering can change between requests.
    if (index is int &&
        index >= 0 &&
        index < lineKeys.length &&
        lineKeys[index] == saved['key']) {
      return index;
    }
    final matching = lineKeys.indexOf(saved['key'] as String);
    return matching >= 0 ? matching : 0;
  }

  static Future<void> rememberSuccessfulLine(
    int bangumiId,
    List<String> lineKeys,
    int index,
  ) async {
    if (!rememberLine.value || index < 0 || index >= lineKeys.length) return;
    final raw = box.read<dynamic>(lineMemoryKey);
    final memory = <String, dynamic>{
      if (raw is Map)
        for (final entry in raw.entries)
          if (entry.key is String) entry.key as String: entry.value,
    };
    memory.remove('$bangumiId');
    memory['$bangumiId'] = {'key': lineKeys[index], 'index': index};
    while (memory.length > 100) {
      memory.remove(memory.keys.first);
    }
    await box.write(lineMemoryKey, memory);
  }
}
