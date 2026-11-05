import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/utils/tv_render_settings.dart';

/// Records the engine's view metrics separately from account/app storage.
/// MediaQuery overrides cannot change this reading. It describes the Flutter
/// render target, not the video decoder or the panel's advertised resolution.
class DisplayDiagnostics with WidgetsBindingObserver {
  DisplayDiagnostics._(this.version);

  final String version;
  bool _scheduled = false;

  static Future<void> start(String version) async {
    await GetStorage.init('displayInfo');
    final observer = DisplayDiagnostics._(version);
    WidgetsBinding.instance.addObserver(observer);
    TvRenderSettings.selectedScale.listen((_) => observer._scheduleSnapshot());
    observer._scheduleSnapshot();
  }

  @override
  void didChangeMetrics() => _scheduleSnapshot();

  void _scheduleSnapshot() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      final views = WidgetsBinding.instance.platformDispatcher.views;
      if (views.isEmpty) return;
      final view = views.first;
      final size = view.physicalSize;
      final ratio = view.devicePixelRatio;
      if (size.isEmpty || ratio <= 0) return;
      unawaited(GetStorage('displayInfo').write('metrics', {
        'version': version,
        'physicalWidth': size.width,
        'physicalHeight': size.height,
        'devicePixelRatio': ratio,
        'scaleForNextLaunch': TvRenderSettings.selectedScale.value,
        'logicalWidth': size.width / ratio,
        'logicalHeight': size.height / ratio,
        'recordedAt': DateTime.now().toUtc().toIso8601String(),
      }).catchError((Object error) {
        debugPrint('Unable to record display metrics: ${error.runtimeType}');
      }));
    });
  }
}
