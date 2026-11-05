import 'dart:async';
import 'dart:math';
import 'package:xs/src/widgets/player/webos_player.dart';
import 'package:xs/src/pages/settings/storage/playback_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/custom_throttle.dart';
import 'package:xs/src/utils/log.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/danmaku_settings/storage.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_controller.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_item.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_option.dart';

mixin PlayerMixin {
  GlobalKey<VideoState> globalPlayerKey = GlobalKey<VideoState>();
  GlobalKey globalDanmuKey = GlobalKey();

  // 播放器实例
  late final player = Player();

  // 视频控制器
  late final videoController = VideoController(player);
}

mixin PlayerStateMixin on PlayerMixin {
  // 音量控制条计时器
  Timer? hidevolumeTimer;

  // 是否进入桌面端小窗
  RxBool smallWindowState = false.obs;

  // 是否显示弹幕
  RxBool showDanmakuState = true.obs;

  // 是否显示弹幕发送框
  RxBool showDanmakuTextField = false.obs;

  // 是否显示控制器
  RxBool showControlsState = false.obs;

  // 是否显示设置窗口
  RxBool showSettingState = false.obs;

  // 是否显示弹幕设置窗口
  RxBool showDanmakuSettingState = false.obs;

  // 是否处于锁定控制器状态
  RxBool lockControlsState = false.obs;

  // 是否处于全屏状态
  RxBool fullScreenState = false.obs;

  // 显示手势Tip
  RxBool showGestureTip = false.obs;

  // 手势Tip文本
  RxString gestureTipText = ''.obs;

  // 显示提示底部Tip
  RxBool showBottomTip = false.obs;

  // 提示底部Tip文本
  RxString bottomTipText = ''.obs;

  // 自动隐藏控制器计时器
  Timer? hideControlsTimer;

  // 自动隐藏提示计时器
  Timer? hideSeekTipTimer;

  // 是否为竖屏直播间
  var isVertical = false.obs;

  // 画面尺寸
  RxInt scaleMode = 0.obs;
  BoxFit boxFit = BoxFit.contain;
  double? aspectRatio;

  // 播放倍速
  RxDouble playerSpeed = 1.0.obs;
  final List<double> speedsList = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  Widget? danmakuView;

  var showQualites = false.obs;
  var showLines = false.obs;

  // 是否显示哔哩哔哩弹幕
  RxBool bilibiliDanmakuState = true.obs;
  RxBool bilibiliHmtDanmakuState = true.obs;

  // 是否显示腾讯视频弹幕
  RxBool qqDanmakuState = true.obs;

  // 设置倍速
  Future setPlaybackSpeed(double rate) async {
    try {
      await player.setRate(rate);
      playerSpeed(rate);
    } catch (e) {
      SmartDialog.showToast('电视暂不支持该播放速度');
    }
  }

  // 获取视频分辨率文本
  String getRatioText() {
    if (player.state.width != null) {
      return ' (${player.state.width}x${player.state.height})';
    } else {
      return '';
    }
  }

  VoidCallback? beforeHideControls;

  // Return focus to the visible video surface before moving controls away.
  void hideControls() {
    beforeHideControls?.call();
    showControlsState.value = false;
    hideControlsTimer?.cancel();
  }

  void setLockState() {
    lockControlsState.value = !lockControlsState.value;
    if (lockControlsState.value) {
      showControlsState.value = false;
    } else {
      showControlsState.value = true;
    }
  }

  // 显示控制器
  void showControls() {
    showControlsState.value = true;
    resetHideControlsTimer();
  }

  // 开始隐藏控制器计时
  // - 当点击控制器上时功能时需要重新计时
  void resetHideControlsTimer() {
    hideControlsTimer?.cancel();

    hideControlsTimer = Timer(const Duration(seconds: 5), hideControls);
  }

  void updateScaleMode(int value) {
    scaleMode(value);
    if ((player.state.width ?? 0) > 0 && (player.state.height ?? 0) > 0) {
      aspectRatio = player.state.width! / player.state.height!;
    }

    if (scaleMode.value == 0) {
      boxFit = BoxFit.contain;
    } else if (scaleMode.value == 1) {
      boxFit = BoxFit.fill;
    } else if (scaleMode.value == 2) {
      boxFit = BoxFit.cover;
    } else if (scaleMode.value == 3) {
      boxFit = BoxFit.contain;
      aspectRatio = 16 / 9;
    } else if (scaleMode.value == 4) {
      boxFit = BoxFit.contain;
      aspectRatio = 4 / 3;
    }

    globalPlayerKey.currentState?.update(aspectRatio: aspectRatio, fit: boxFit);
  }
}

mixin PlayerDanmakuMixin on PlayerStateMixin {
  // 弹幕控制器
  DanmakuController? danmakuController;

  // 弹幕输入框控制器
  FocusNode danmakuTextFieldFocusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  RxDouble danmakuStrokeWidth = 1.0.obs;
  RxInt danmakuFontWeight = FontWeight.bold.index.obs;
  RxBool strokeText = true.obs;

  RxBool textFormatStatus = true.obs;
  RxString danmakuText = ''.obs;
  RxString danmakuColor = '#ffffff'.obs;
  RxInt danmakuTypeIndex = 1.obs;

  void initDanmakuController(DanmakuController e) {
    danmakuController = e;
    danmakuController?.updateOption(
      DanmakuOption(
        fontSize: DanmakuSettingsStorage.danmakuSize.value,
        area: DanmakuSettingsStorage.danmakuArea.value,
        duration: DanmakuSettingsStorage.danmakuSpeed.value,
        opacity: DanmakuSettingsStorage.danmakuOpacity.value,
        strokeWidth: danmakuStrokeWidth.value,
        fontWeight: FontWeight.values[danmakuFontWeight.value],
        strokeText: strokeText.value,
      ),
    );
  }

  void updateDanmuOption(DanmakuOption? option) {
    if (danmakuController == null || option == null) return;
    danmakuController!.updateOption(option);
  }

  void disposeDanmakuController() {
    danmakuController?.clear();
  }

  void addDanmaku(List<DanmakuItem> items) {
    if (!showDanmakuState.value) {
      return;
    }
    danmakuController?.addItems(items);
  }
}

mixin PlayerSystemMixin on PlayerMixin, PlayerStateMixin, PlayerDanmakuMixin {
  void initSystem() => resetHideControlsTimer();

  Future<void> resetSystem() async {
    hideControlsTimer?.cancel();
    hideSeekTipTimer?.cancel();
    hidevolumeTimer?.cancel();
  }

  Future<void> enterFullScreen() async {
    fullScreenState.value = true;
    danmakuController?.clear();
    showControls();
  }

  Future<void> exitFull() async {
    fullScreenState.value = false;
    danmakuController?.clear();
    showControls();
  }

  void enterSmallWindow() => SmartDialog.showToast('电视版暂不支持画中画');
  void exitSmallWindow() => smallWindowState.value = false;
  Future<void> enablePIP() async => SmartDialog.showToast('电视版暂不支持画中画');
  Future<void> saveScreenshot() async => SmartDialog.showToast('电视版暂不支持视频截图');
}

mixin PlayerGestureControlMixin
    on PlayerStateMixin, PlayerMixin, PlayerSystemMixin {
  // 单击显示/隐藏控制器
  void onTap() {
    if (showControlsState.value) {
      hideControls();
    } else {
      showControls();
    }
  }

  //桌面端操控
  void onEnter(PointerEnterEvent event) {
    if (!showControlsState.value) {
      showControls();
    }
  }

  void onExit(PointerExitEvent event) {
    if (showControlsState.value) {
      hideControls();
    }
  }

  void onHover(PointerHoverEvent event, BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final targetPosition = screenHeight * 0.25; // 计算屏幕顶部25%的位置
    // if (event.position.dy <= targetPosition ||
    //     event.position.dy >= targetPosition * 3) {
    //   if (!showControlsState.value) {
    //     showControls();
    //   }
    // }
    if (!showControlsState.value) {
      showControls();
    }
  }

  // 双击全屏/退出全屏
  void onDoubleTap(TapDownDetails details) {
    if (lockControlsState.value || smallWindowState.value) {
      return;
    }
    if (fullScreenState.value) {
      exitFull();
    } else {
      enterFullScreen();
    }
  }

  DelayedThrottle? throttle;

  // Volume and brightness are controlled by the TV remote/system settings.
  void onVerticalDragStart(DragStartDetails details) {}
  void onVerticalDragUpdate(DragUpdateDetails details) {}
  void onVerticalDragEnd(DragEndDetails details) {}

  bool horizontalDragging = false;
  bool horizontalDrag = false;
  var horizontalStartPosition = 0.0;
  Duration _currentDuration = Duration.zero;
  double _currentPosition = 0.0;

  // 横向手势开始
  void onHorizontalDragStart(DragStartDetails details) async {
    if (lockControlsState.value && fullScreenState.value) {
      return;
    }

    final dx = details.globalPosition.dx;
    // if (dx < Get.width || dx > Get.width) {
    //   return;
    // }

    horizontalStartPosition = dx;
    horizontalDrag = details.globalPosition.dx < Get.width / 2;

    throttle = DelayedThrottle(200);

    horizontalDragging = true;
    showGestureTip.value = true;
    _currentDuration = player.state.duration;
    // print(
    //     'Horizontal drag start at: ${details.globalPosition} $_currentDuration');
  }

  // 横向手势更新
  void onHorizontalDragUpdate(DragUpdateDetails e) async {
    if (lockControlsState.value && fullScreenState.value) {
      return;
    }
    if (horizontalDragging == false) return;
    //String text = '';
    double value = 0.0;
    value =
        ((e.globalPosition.dx - horizontalStartPosition) / (Get.width * 0.5));
    _currentPosition = max(
      0,
      min(
        player.state.position.inSeconds +
            _currentDuration.inSeconds * (value * 0.5),
        _currentDuration.inSeconds.toDouble(),
      ),
    );
    // Log.logPrint('$horizontalStartPosition/${e.globalPosition.dx}');
    // Log.logPrint('$_currentPosition/$value');
    gestureTipText.value =
        '${Duration(seconds: _currentPosition.toInt()).toString().split('.').first}/${_currentDuration.toString().split('.').first}';
  }

  // 横向手势完成
  void onHorizontalDragEnd(DragEndDetails details) async {
    if (lockControlsState.value && fullScreenState.value) {
      return;
    }
    throttle = null;
    horizontalDragging = false;
    horizontalDrag = false;
    showGestureTip.value = false;
    seekTo();
  }

  void seekTo() {
    player.seek(Duration(seconds: _currentPosition.toInt()));
  }
}

class PlayerController extends GetxController
    with
        PlayerMixin,
        PlayerStateMixin,
        PlayerDanmakuMixin,
        PlayerSystemMixin,
        PlayerGestureControlMixin {
  @override
  void onInit() {
    initSystem();
    initStream();
    setPlaybackSpeed(PlaybackSettingsStorage.defaultSpeed.value);
    updateScaleMode(PlaybackSettingsStorage.defaultScaleMode.value);
    //设置音量
    // player.setVolume(AppSettingsController.instance.playerVolume.value);
    super.onInit();
  }

  StreamSubscription<String>? _errorSubscription;
  StreamSubscription? _completedSubscription;
  StreamSubscription? _widthSubscription;
  StreamSubscription? _heightSubscription;
  StreamSubscription? _logSubscription;

  void initStream() {
    _errorSubscription = player.stream.error.listen((event) {
      Log.d('播放器错误：$event');
      // 跳过无音频输出的错误
      // Could not open/initialize audio device -> no sound.
      if (event.contains('no sound.')) {
        return;
      }
      //SmartDialog.showToast(event);
      mediaError(event);
    });

    _completedSubscription = player.stream.completed.listen((event) {
      if (event) {
        mediaEnd();
      }
    });
    _logSubscription = player.stream.log.listen((event) {
      Log.d('播放器日志：$event');
    });
    _widthSubscription = player.stream.width.listen((event) {
      Log.d(
        'width:$event  W:${(player.state.width)}  H:${(player.state.height)}',
      );
      isVertical.value =
          (player.state.height ?? 9) > (player.state.width ?? 16);
    });
    _heightSubscription = player.stream.height.listen((event) {
      Log.d(
        'height:$event  W:${(player.state.width)}  H:${(player.state.height)}',
      );
      isVertical.value =
          (player.state.height ?? 9) > (player.state.width ?? 16);
      if ((player.state.width ?? 0) > 0 && (player.state.height ?? 0) > 0) {
        updateScaleMode(scaleMode.value);
      }
    });
  }

  void disposeStream() {
    _errorSubscription?.cancel();
    _completedSubscription?.cancel();
    _widthSubscription?.cancel();
    _heightSubscription?.cancel();
    _logSubscription?.cancel();
  }

  void mediaEnd() {}

  void mediaError(String error) {}

  void showDebugInfo() {
    Utils.showBottomSheet(
      title: '播放信息',
      child: ListView(
        children: [
          const ListTile(title: Text('播放器'), subtitle: Text('webOS 电视硬件播放器')),
          ListTile(
            title: const Text('分辨率'),
            subtitle: Text(
              '${player.state.width ?? 0} × ${player.state.height ?? 0}',
            ),
          ),
          ListTile(
            title: const Text('时长'),
            subtitle: Text(player.state.duration.toString().split('.').first),
          ),
          ListTile(
            title: const Text('播放速度'),
            subtitle: Text('${playerSpeed.value} 倍'),
          ),
          const ListTile(
            title: Text('电视功能'),
            subtitle: Text('音量和亮度请用电视设置调节。暂不支持画中画、视频截图和应用内超分。'),
          ),
        ],
      ),
    );
  }

  @override
  void onClose() async {
    Log.w('播放器关闭');
    beforeHideControls = null;
    if (smallWindowState.value) {
      exitSmallWindow();
    }
    textEditingController.dispose();
    danmakuTextFieldFocusNode.dispose();
    disposeStream();
    disposeDanmakuController();
    await resetSystem();
    await player.dispose();
    super.onClose();
  }
}
