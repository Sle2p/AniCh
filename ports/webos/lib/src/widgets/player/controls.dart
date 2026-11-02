import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/widgets/player/webos_player.dart';
import 'package:xs/src/apis/bangumi.dart';
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/color.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/danmaku_settings/view.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_view.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_item.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_option.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

final Widget danmakuOffIcon = SvgPicture.asset(
  'assets/icons/danmaku_off.svg',
  width: 24,
  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
);
final Widget danmakuOnIcon = SvgPicture.asset(
  'assets/icons/danmaku_on.svg',
  width: 24,
  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
);
final Widget danmakuSettingIcon = SvgPicture.asset(
  'assets/icons/danmaku_setting.svg',
  width: 24,
  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
);

class _PlayerControlsPositioned extends AnimatedPositioned {
  _PlayerControlsPositioned({
    required bool enabled,
    required Widget child,
    super.left,
    super.right,
    super.top,
    super.bottom,
    required super.duration,
  }) : super(
          child: ExcludeFocus(excluding: !enabled, child: child),
        );
}

Widget diyControlsTheme(Widget child) => child;

Widget buildPlayerPositionWithShortcuts() => LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          const Expanded(
            child: MaterialPositionIndicator(
              style: TextStyle(color: Colors.white),
            ),
          ),
          if (TvFocusableAction.isTV && constraints.maxWidth >= 700)
            for (final hint in const [
              (Colors.redAccent, '红键', '弹幕'),
              (Colors.greenAccent, '绿键', '线路'),
              (Colors.yellowAccent, '黄键', '选集'),
              (Colors.lightBlueAccent, '蓝键', '全屏'),
            ])
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Semantics(
                  label: '${hint.$2}：${hint.$3}',
                  excludeSemantics: true,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: hint.$1,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(hint.$3,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );

// Offstage keeps state alive but normally leaves hidden controls focusable.
class _PlayerOffstage extends StatelessWidget {
  const _PlayerOffstage({required this.offstage, required this.child});
  final bool offstage;
  final Widget child;

  @override
  Widget build(BuildContext context) => ExcludeFocus(
        excluding: offstage,
        child: Offstage(offstage: offstage, child: child),
      );
}

Widget playerControls(
  VideoState videoState,
  BangumiVodPageController controller,
) {
  return Obx(() {
    if (controller.fullScreenState.value) {
      return buildFullControls(videoState, controller);
    }
    return buildControls(
      videoState.context.orientation == Orientation.portrait,
      videoState,
      controller,
    );
  });
}

Widget buildFullControls(
  VideoState videoState,
  BangumiVodPageController controller,
) {
  final padding = MediaQuery.of(videoState.context).padding;
  final width = MediaQuery.of(videoState.context).size.width;
  GlobalKey volumeButtonkey = GlobalKey();
  return CustomDragToMoveArea(
    drag: controller.smallWindowState.isTrue ? true : false,
    child: Stack(
      children: [
        Container(),
        // 中间
        Center(
          child: StreamBuilder(
            stream: videoState.widget.controller.player.stream.buffering,
            initialData: videoState.widget.controller.player.state.buffering,
            builder: (_, s) => Visibility(
              visible: s.data ?? false,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: controller.onTap,
            onDoubleTapDown: controller.onDoubleTap,
            onLongPress: () {
              if (controller.lockControlsState.value) {
                return;
              }
              // showFollowUser(controller);
            },
            onVerticalDragStart: controller.onVerticalDragStart,
            onVerticalDragUpdate: controller.onVerticalDragUpdate,
            onVerticalDragEnd: controller.onVerticalDragEnd,
            onHorizontalDragStart: controller.onHorizontalDragStart,
            onHorizontalDragUpdate: controller.onHorizontalDragUpdate,
            onHorizontalDragEnd: controller.onHorizontalDragEnd,
            child: MouseRegion(
              onHover: (PointerHoverEvent event) {
                controller.onHover(event, videoState.context);
              },
              // onHover: (e) => controller.onHover(e, videoState.context),
              cursor: controller.showControlsState.value
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.none,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        buildDanmuView(videoState, controller),
        // 顶部
        Obx(
          () => _PlayerControlsPositioned(
            enabled: controller.showControlsState.value &&
                !controller.lockControlsState.value,
            left: 0,
            right: 0,
            top: (controller.showControlsState.value &&
                    !controller.lockControlsState.value)
                ? 0
                : -(48 + padding.top),
            duration: const Duration(milliseconds: 200),
            child: Container(
              height: 48 + padding.top,
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                // left: padding.left + 12,
                // right: padding.right + 12,
                top: padding.top,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (controller.smallWindowState.value) {
                        controller.exitSmallWindow();
                      } else {
                        controller.exitFull();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  AppStyle.hGap12,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.data.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 0,
                          ),
                        ),
                        if (controller.episodes.isNotEmpty)
                          Text(
                            '第${controller.getEpisodeData().sort}集 ${controller.getEpisodeData().title}${controller.getRatioText()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AppStyle.hGap12,
                  IconButton(
                    onPressed: () {
                      controller.reload();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                  ),
                  Visibility(
                    visible: false,
                    child: IconButton(
                      onPressed: () {
                        controller.enablePIP();
                      },
                      icon: const Icon(
                        Icons.picture_in_picture,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showPlayerSettings(controller);
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 底部
        Obx(
          () => _PlayerControlsPositioned(
            enabled: controller.showControlsState.value &&
                !controller.lockControlsState.value,
            left: 0,
            right: 0,
            bottom: (controller.showControlsState.value &&
                    !controller.lockControlsState.value)
                ? 0
                : -(80 + padding.bottom),
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              padding: EdgeInsets.only(
                top: 20,
                left: 12,
                right: 12,
                // left: padding.left + 12,
                // right: padding.right + 12,
                bottom: padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: buildPlayerPositionWithShortcuts(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 10,
                    child: diyControlsTheme(const MaterialSeekBar()),
                  ),
                  Row(
                    children: [
                      const MaterialPlayOrPauseButton(),
                      IconButton(
                        onPressed: () {
                          controller.playNextEpisode();
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      _PlayerOffstage(
                        offstage: controller.showDanmakuState.value,
                        child: IconButton(
                          onPressed: () => controller.showDanmakuState.value =
                              !controller.showDanmakuState.value,
                          icon: danmakuOffIcon,
                        ),
                      ),
                      _PlayerOffstage(
                        offstage: !controller.showDanmakuState.value,
                        child: IconButton(
                          onPressed: () => controller.showDanmakuState.value =
                              !controller.showDanmakuState.value,
                          icon: danmakuOnIcon,
                        ),
                      ),
                      _PlayerOffstage(
                        offstage: controller.smallWindowState.value,
                        child: IconButton(
                          onPressed: () {
                            showDanmakuSettings(controller);
                          },
                          icon: danmakuSettingIcon,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            children: [
                              Visibility(
                                visible: width > 300,
                                child: buildSendDanmakuButton(
                                  videoState,
                                  controller,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !controller.smallWindowState.value && false,
                        child: IconButton(
                          key: volumeButtonkey,
                          onPressed: () {
                            controller.showVolumeSlider(
                              volumeButtonkey.currentContext!,
                            );
                          },
                          icon: const Icon(
                            Icons.volume_down,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: width > 400,
                        child: TextButton(
                          onPressed: () {
                            controller.showEpisodesSheet();
                          },
                          child: const Text(
                            '选集',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: width > 400,
                        child: TextButton(
                          onPressed: () {
                            showLinesInfo(controller);
                          },
                          child: Text(
                            controller.currentLineInfo.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (controller.smallWindowState.value) {
                            controller.exitSmallWindow();
                          } else {
                            controller.exitFull();
                          }
                        },
                        icon: const Icon(
                          Icons.fullscreen_exit,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // 右侧锁定
        Obx(
          () => _PlayerControlsPositioned(
            enabled: controller.showControlsState.value &&
                !controller.lockControlsState.value,
            top: 0,
            bottom: 0,
            right:
                controller.showControlsState.value ? 12 : -(64 + padding.right),
            // right: controller.showControlsState.value
            //     ? padding.right + 12
            //     : -(64 + padding.right),
            duration: const Duration(milliseconds: 200),
            child: buildLockButton(controller),
          ),
        ),
        // 左侧锁定
        Obx(
          () => _PlayerControlsPositioned(
            enabled: controller.showControlsState.value &&
                !controller.lockControlsState.value,
            top: 0,
            bottom: 0,
            left:
                controller.showControlsState.value ? 12 : -(64 + padding.left),
            // left: controller.showControlsState.value
            //     ? padding.left + 12
            //     : -(64 + padding.right),
            duration: const Duration(milliseconds: 200),
            child: buildLockButton(controller),
          ),
        ),
        Obx(
          () => _PlayerOffstage(
            offstage: !controller.showGestureTip.value,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.gestureTipText.value,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        // 弹幕发送框
        Obx(
          () => AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: 0,
            duration: const Duration(milliseconds: 200),
            child: _PlayerOffstage(
              offstage: !controller.showDanmakuTextField.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.danmakuTextFieldFocusNode.unfocus();
                      controller.showDanmakuTextField(false);
                      controller.player.play();
                    },
                    child: Container(
                      color: Colors.black.withAlpha(50),
                      width: MediaQuery.of(videoState.context).size.width,
                      height: MediaQuery.of(videoState.context).size.height,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      color: Colors.black,
                      child: buildSendDanmakuTextField(controller),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildLockButton(BangumiVodPageController controller) {
  if (TvFocusableAction.isTV) return const SizedBox.shrink();
  return Center(
    child: InkWell(
      onTap: () {
        controller.setLockState();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: AppStyle.radius8,
        ),
        width: 40,
        height: 40,
        child: Center(
          child: Icon(
            controller.lockControlsState.value
                ? Icons.lock_outline_rounded
                : Icons.lock_open_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    ),
  );
}

Widget buildControls(
  bool isPortrait,
  VideoState videoState,
  BangumiVodPageController controller,
) {
  final padding = MediaQuery.of(videoState.context).padding;
  final width = MediaQuery.of(videoState.context).size.width;
  GlobalKey volumeButtonkey = GlobalKey();
  return CustomDragToMoveArea(
    child: Stack(
      children: [
        Container(),
        // 中间
        Center(
          child: StreamBuilder(
            stream: videoState.widget.controller.player.stream.buffering,
            initialData: videoState.widget.controller.player.state.buffering,
            builder: (_, s) => Visibility(
              visible: s.data ?? false,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onTap: controller.onTap,
            onDoubleTapDown: controller.onDoubleTap,
            onVerticalDragStart: controller.onVerticalDragStart,
            onVerticalDragUpdate: controller.onVerticalDragUpdate,
            onVerticalDragEnd: controller.onVerticalDragEnd,
            onHorizontalDragStart: controller.onHorizontalDragStart,
            onHorizontalDragUpdate: controller.onHorizontalDragUpdate,
            onHorizontalDragEnd: controller.onHorizontalDragEnd,
            onLongPress: controller.showDebugInfo,
            child: MouseRegion(
              onEnter: controller.onEnter,
              onHover: (PointerHoverEvent event) {
                controller.onHover(event, videoState.context);
              },
              cursor: controller.showControlsState.value
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.none,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
        buildDanmuView(videoState, controller),
        // 顶部
        Obx(
          () => _PlayerControlsPositioned(
            enabled: controller.showControlsState.value &&
                !controller.lockControlsState.value,
            left: 0,
            right: 0,
            top: (controller.showControlsState.value &&
                    !controller.lockControlsState.value)
                ? 0
                : -(48 + padding.top),
            duration: const Duration(milliseconds: 200),
            child: Container(
              height: 48 + padding.top,
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
                top: padding.top,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Row(
                children: [
                  AppStyle.hGap12,
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.data.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            height: 0,
                          ),
                        ),
                        if (controller.episodes.isNotEmpty)
                          Text(
                            '第${controller.getEpisodeData().sort}集 ${controller.getEpisodeData().title}${controller.getRatioText()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AppStyle.hGap12,
                  IconButton(
                    onPressed: () {
                      controller.reload();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                  ),
                  Visibility(
                    visible: false,
                    child: IconButton(
                      onPressed: () {
                        controller.enterSmallWindow();
                      },
                      icon: const Icon(
                        Icons.picture_in_picture,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: IconButton(
                      onPressed: () {
                        controller.enablePIP();
                      },
                      icon: const Icon(
                        Icons.picture_in_picture,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.showPlayerSettingsSheet();
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 底部
        Obx(
          () => _PlayerControlsPositioned(
            enabled: controller.showControlsState.value &&
                !controller.lockControlsState.value,
            left: 0,
            right: 0,
            bottom: controller.showControlsState.value ? 0 : -75,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: buildPlayerPositionWithShortcuts(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 5,
                    child: diyControlsTheme(const MaterialSeekBar()),
                  ),
                  Row(
                    children: [
                      const MaterialPlayOrPauseButton(),
                      IconButton(
                        onPressed: () {
                          controller.playNextEpisode();
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                      _PlayerOffstage(
                        offstage: controller.showDanmakuState.value,
                        child: IconButton(
                          onPressed: () => controller.showDanmakuState.value =
                              !controller.showDanmakuState.value,
                          icon: danmakuOffIcon,
                        ),
                      ),
                      _PlayerOffstage(
                        offstage: !controller.showDanmakuState.value,
                        child: IconButton(
                          onPressed: () => controller.showDanmakuState.value =
                              !controller.showDanmakuState.value,
                          icon: danmakuOnIcon,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.showDanmakuSettingsSheet();
                        },
                        icon: danmakuSettingIcon,
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            children: [
                              buildSendDanmakuButton(videoState, controller),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: false,
                        child: IconButton(
                          key: volumeButtonkey,
                          onPressed: () {
                            controller.showVolumeSlider(
                              volumeButtonkey.currentContext!,
                            );
                          },
                          icon: const Icon(
                            Icons.volume_down,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _PlayerOffstage(
                        offstage: width < 350, //isPortrait,
                        child: TextButton(
                          onPressed: () {
                            controller.showPlayUrlsSheet();
                          },
                          child: Text(
                            controller.currentLineInfo.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.enterFullScreen();
                        },
                        icon: const Icon(Icons.fullscreen, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => _PlayerOffstage(
            offstage: !controller.showGestureTip.value,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.gestureTipText.value,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        // 弹幕发送框
        Obx(
          () => AnimatedPositioned(
            left: 0,
            right: 0,
            bottom: 0,
            duration: const Duration(milliseconds: 200),
            child: _PlayerOffstage(
              offstage: !controller.showDanmakuTextField.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.danmakuTextFieldFocusNode.unfocus();
                      controller.showDanmakuTextField(false);
                      controller.player.play();
                    },
                    child: Container(
                      color: Colors.black.withAlpha(50),
                      width: MediaQuery.of(videoState.context).size.width,
                      height: MediaQuery.of(videoState.context).size.height,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      color: Colors.black,
                      child: buildSendDanmakuTextField(controller),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildDanmuView(
  VideoState videoState,
  BangumiVodPageController controller,
) {
  controller.danmakuView ??= DanmakuView(
    key: controller.globalDanmuKey,
    createdController: controller.initDanmakuController,
    option: DanmakuOption(),
  );
  return Positioned.fill(
    child: ValueListenableBuilder<int>(
      valueListenable: controller.player.changes,
      child: Obx(() => _PlayerOffstage(
            offstage: !controller.showDanmakuState.value,
            child: IgnorePointer(child: controller.danmakuView!),
          )),
      builder: (context, _, child) => LayoutBuilder(
        builder: (context, constraints) => Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fromRect(
              rect: videoState.videoRectFor(constraints.biggest),
              child: ClipRect(clipBehavior: Clip.hardEdge, child: child!),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildSendDanmakuButton(
  VideoState videoState,
  BangumiVodPageController controller,
) {
  return Expanded(
    child: Container(
      // width: 250,
      height: 35,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
      child: Material(
        color: Colors.white.withAlpha(50),
        child: InkWell(
          onTap: () {
            FocusScope.of(
              videoState.context,
            ).requestFocus(controller.danmakuTextFieldFocusNode);
            if (controller.player.state.playing) {
              controller.player.pause();
            }
            controller.showControlsState(false);
            controller.showDanmakuTextField(true);
          },
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.send, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '发送弹幕',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.white.withAlpha(150)),
                ),
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildSendDanmakuTextField(BangumiVodPageController controller) {
  Map<int, String> typeList = {1: '滚动', 2: '置顶', 3: '置底'};
  List colors = [
    '#ffffff', // 白色
    '#ff0000', // 红色
    '#ed143d', // crimson
    '#a52a2a', // brown
    '#ff7f50', // coral
    '#ff7204', // 橘色
    '#ffaa02', // 金色
    '#ffd302', // 深黄
    '#ffff00', // 黄色
    '#a0ee00', // 浅绿
    '#008000', // 绿色
    '#4caf50', // 绿色2
    '#019899', // 青色
    '#00ffff', // aqua
    '#89d5ff', // 浅蓝
    '#00bfff', // deepskyblue
    '#1e90ff', // dodgerblue
    '#0000ff', // 蓝色
    '#4266be', // 暗蓝
    '#673ab7', // 紫色3
    '#8a2be2', // blueviolet
    '#9c27b0', // 紫色2
    '#800080', // 紫色
    '#cc0273', // 暗粉
    '#ff69b4', // 深粉
    '#ff1493', // deeppink
    '#ff00ff', // magenta
    '#ffc0cb', // 粉色
  ];
  void postDanmaku() async {
    if (controller.danmakuText.value.isEmpty) {
      SmartDialog.showToast('请输入弹幕');
      return;
    }
    final id = controller.id;
    final episode = controller.episode;
    final text = controller.danmakuText.value;
    final type = controller.danmakuTypeIndex.value;
    final time = controller.player.state.position.inMilliseconds / 1000;
    final color = controller.danmakuColor.value;
    controller.addDanmaku([
      DanmakuItem(
        controller.danmakuText.value,
        self: true,
        color: ColorUtil.fromHex(controller.danmakuColor.value),
        time: time,
        type: DanmakuItemType.values[controller.danmakuTypeIndex.value - 1],
      ),
    ]);
    controller.danmakuText('');
    controller.textEditingController.clear();
    controller.showDanmakuTextField(false);
    controller.player.play();
    try {
      await BangumiApi.postDanmaku(
        id: id,
        episode: episode,
        text: text,
        type: type,
        time: time,
        color: color,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  return Obx(() {
    return Column(
      children: [
        _PlayerOffstage(
          offstage: !controller.textFormatStatus.value,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  '弹幕位置',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: typeList.entries.map((e) {
                    return GestureDetector(
                      onTap: () {
                        controller.danmakuTypeIndex(e.key);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: controller.danmakuTypeIndex.value == e.key
                              ? Border.all(color: Colors.white, width: 1)
                              : null,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          e.value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 5),
                Text(
                  '弹幕颜色',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 11,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: colors
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              controller.danmakuColor(e);
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: ColorUtil.fromHex(e),
                                borderRadius: AppStyle.radius4,
                                border: Border.all(
                                  color: Colors.grey.withOpacity(.2),
                                  width: 1,
                                ),
                              ),
                              child: Obx(
                                () => Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 12,
                                    color: controller.danmakuColor.value == e
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            controller.textFormatStatus.value
                ? IconButton(
                    onPressed: () {
                      controller.textFormatStatus(false);
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      size: 26,
                      color: Colors.white,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      controller.textFormatStatus(true);
                    },
                    icon: const Icon(
                      Icons.arrow_drop_up,
                      size: 26,
                      color: Colors.white,
                    ),
                  ),
            const SizedBox(width: 5),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    color: Colors.white.withAlpha(50),
                    child: TextField(
                      // autofocus: true,
                      focusNode: controller.danmakuTextFieldFocusNode,
                      controller: controller.textEditingController,
                      // textAlignVertical: TextAlignVertical.top,
                      textAlignVertical: TextAlignVertical.center,
                      textInputAction: TextInputAction.send,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                      onChanged: (value) {
                        controller.danmakuText(value);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: '发送弹幕',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                        border: InputBorder.none,
                        // contentPadding: const EdgeInsets.only(top: 2),
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.send,
                            size: 17,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            postDanmaku();
                          },
                        ),
                      ),
                      onSubmitted: (String value) {
                        postDanmaku();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  });
}

void showLinesInfo(BangumiVodPageController controller) {
  if (TvFocusableAction.isTV || controller.isVertical.value) {
    controller.showPlayUrlsSheet();
    return;
  }
  Utils.showRightDialog(
    title: '切换线路',
    useSystem: true,
    child: ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: controller.playUrls.length,
      itemBuilder: (_, i) => Material(
        child: RadioListTile<int>(
          value: i,
          groupValue: controller.currentLineIndex,
          title: Text('线路${i + 1}'),
          subtitle: Text(controller.urlDecode(controller.playUrls[i].url)),
          secondary: Text(controller.playUrls[i].caption),
          onChanged: (_) {
            Utils.hideRightDialog();
            controller.changePlayLine(i);
          },
        ),
      ),
    ),
  );
}

void showDanmakuSettings(BangumiVodPageController controller) {
  if (controller.isVertical.value) {
    controller.showDanmakuSettingsSheet();
    return;
  }
  Utils.showRightDialog(
    title: '弹幕设置',
    width: 400,
    useSystem: true,
    child: ListView(
      padding: AppStyle.edgeInsetsA12,
      children: [
        DanmakuSettingsView(
          playerController: controller,
          danmakuController: controller.danmakuController,
        ),
      ],
    ),
  );
}

void showPlayerSettings(BangumiVodPageController controller) {
  controller.showPlayerSettingsSheet();
}
