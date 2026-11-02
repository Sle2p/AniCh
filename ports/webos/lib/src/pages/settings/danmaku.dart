import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/settings/controller.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/widgets/danmaku_settings/storage.dart';
import 'package:xs/src/widgets/danmaku_shield/view.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_persistent_header_delegate.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_controller.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_option.dart';
import 'package:xs/src/widgets/player/controller.dart';
import 'package:xs/src/widgets/settings/settings_action.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';
import 'package:xs/src/widgets/settings/settings_number.dart';
import 'package:xs/src/widgets/settings/settings_switch.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class DanmakuSettingsPage extends StatelessWidget {
  final Function()? onTapDanmakuShield;
  final PlayerController? playerController;
  final DanmakuController? danmakuController;
  const DanmakuSettingsPage({
    super.key,
    this.onTapDanmakuShield,
    this.danmakuController,
    this.playerController,
  });

  @override
  Widget build(BuildContext context) {
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    RxDouble maxShrinkOpacity = 1.0.obs;
    return GetBuilder(
        init: DanmakuSettingsPageController(),
        builder: (controller) {
          return Scaffold(
            extendBody: !TvFocusableAction.isTV,
            backgroundColor: Theme.of(context).dialogBackgroundColor,
            body: SafeArea(
              top: true,
              bottom: false,
              maintainBottomViewPadding: false,
              child: NestedScrollView(
                floatHeaderSlivers: true,
                body: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    final pixels = notification.metrics.pixels.toInt();
                    if ((pixels - scrollHeight.value).abs() >= 50) {
                      final lastScrollStatus = scrollStatus.value;
                      if (pixels > scrollHeight.value) {
                        if (notification.depth > 0 &&
                            lastScrollStatus != false) {
                          scrollStatus(false);
                          controller.animationController.forward();
                          debugPrint('向下');
                        }
                      } else if (pixels < scrollHeight.value) {
                        if (lastScrollStatus != true) {
                          scrollStatus(true);
                          controller.animationController.reverse();
                          debugPrint('向上');
                        }
                      }
                      scrollHeight(pixels);
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: AppStyle.edgeInsetsA12,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    AppStyle.edgeInsetsA12.copyWith(top: 50),
                                child: Text(
                                  '弹幕屏蔽',
                                  style: Get.textTheme.titleSmall,
                                ),
                              ),
                              SettingsCard(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SettingsAction(
                                      autofocus: TvFocusableAction.isTV,
                                      title: '关键词屏蔽',
                                      onTap: onTapDanmakuShield ??
                                          () {
                                            DanmakuShieldView
                                                .showDanmakuShieldBottomSheet();
                                          },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    AppStyle.edgeInsetsA12.copyWith(top: 12),
                                child: Text(
                                  '弹幕设置',
                                  style: Get.textTheme.titleSmall,
                                ),
                              ),
                              SettingsCard(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(
                                      () => SettingsSwitch(
                                        title: '默认开关',
                                        value: DanmakuSettingsStorage
                                            .danmakuEnable.value,
                                        onChanged: (e) {
                                          playerController
                                              ?.showDanmakuState.value = e;
                                          DanmakuSettingsStorage
                                              .setDanmakuEnable(e);
                                        },
                                      ),
                                    ),
                                    AppStyle.divider,
                                    Obx(
                                      () => SettingsNumber(
                                        title: '显示区域',
                                        value: (DanmakuSettingsStorage
                                                    .danmakuArea.value *
                                                100)
                                            .toInt(),
                                        min: 10,
                                        max: 100,
                                        step: 10,
                                        unit: '%',
                                        onChanged: (e) {
                                          DanmakuSettingsStorage.setDanmakuArea(
                                              e / 100.0);
                                          updateDanmakuOption(
                                            danmakuController?.option
                                                .copyWith(area: e / 100.0),
                                          );
                                        },
                                      ),
                                    ),
                                    AppStyle.divider,
                                    Obx(
                                      () => SettingsNumber(
                                        title: '不透明度',
                                        value: (DanmakuSettingsStorage
                                                    .danmakuOpacity.value *
                                                100)
                                            .toInt(),
                                        min: 10,
                                        max: 100,
                                        step: 10,
                                        unit: '%',
                                        onChanged: (e) {
                                          DanmakuSettingsStorage
                                              .setDanmakuOpacity(e / 100.0);
                                          updateDanmakuOption(
                                            danmakuController?.option
                                                .copyWith(opacity: e / 100.0),
                                          );
                                        },
                                      ),
                                    ),
                                    AppStyle.divider,
                                    Obx(
                                      () => SettingsNumber(
                                        title: '字体大小',
                                        value: DanmakuSettingsStorage
                                            .danmakuSize
                                            .toInt(),
                                        min: 8,
                                        max: 48,
                                        onChanged: (e) {
                                          DanmakuSettingsStorage.setDanmakuSize(
                                              e.toDouble());
                                          updateDanmakuOption(
                                            danmakuController?.option.copyWith(
                                                fontSize: e.toDouble()),
                                          );
                                        },
                                      ),
                                    ),
                                    AppStyle.divider,
                                    Obx(
                                      () => SettingsNumber(
                                        title: '滚动速度',
                                        subtitle: '弹幕持续时间(秒)，越小速度越快',
                                        value: DanmakuSettingsStorage
                                            .danmakuSpeed
                                            .toInt(),
                                        min: 4,
                                        max: 20,
                                        onChanged: (e) {
                                          DanmakuSettingsStorage
                                              .setDanmakuSpeed(e.toDouble());
                                          updateDanmakuOption(
                                            danmakuController?.option.copyWith(
                                                duration: e.toDouble()),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    AppStyle.edgeInsetsA12.copyWith(top: 12),
                                child: Text(
                                  '外部弹幕',
                                  style: Get.textTheme.titleSmall,
                                ),
                              ),
                              SettingsCard(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(
                                      () => SettingsSwitch(
                                        title: '哔哩哔哩弹幕',
                                        value: DanmakuSettingsStorage
                                            .bilibiliDanmakuEnable.value,
                                        onChanged: (e) {
                                          playerController
                                              ?.bilibiliDanmakuState.value = e;
                                          DanmakuSettingsStorage
                                              .setBilibiliDanmakuEnable(e);
                                        },
                                      ),
                                    ),
                                    AppStyle.divider,
                                    Obx(
                                      () => SettingsSwitch(
                                        title: '哔哩哔哩(港澳台)弹幕',
                                        value: DanmakuSettingsStorage
                                            .bilibiliHmtDanmakuEnable.value,
                                        onChanged: (e) {
                                          playerController
                                              ?.bilibiliHmtDanmakuState
                                              .value = e;
                                          DanmakuSettingsStorage
                                              .setBilibiliHmtDanmakuEnable(e);
                                        },
                                      ),
                                    ),
                                    AppStyle.divider,
                                    Obx(
                                      () => SettingsSwitch(
                                        title: '腾讯视频弹幕',
                                        value: DanmakuSettingsStorage
                                            .qqDanmakuEnable.value,
                                        onChanged: (e) {
                                          playerController
                                              ?.qqDanmakuState.value = e;
                                          DanmakuSettingsStorage
                                              .setQQDanmakuEnable(e);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverPersistentHeader(
                          pinned: true,
                          delegate: CustomSliverPersistentHeaderDelegate(
                            onMaxOffset: (offset) {
                              maxShrinkOpacity(1 - offset);
                            },
                            child: Material(
                              color: Theme.of(context).dialogBackgroundColor,
                              child: CustomDragToMoveArea(
                                child: Obx(
                                  () {
                                    return Opacity(
                                      opacity: maxShrinkOpacity.value,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        constraints:
                                            const BoxConstraints(minHeight: 50),
                                        color: Theme.of(context)
                                            .dialogBackgroundColor,
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                '弹幕设置',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            closeWindowButton(
                                                positioned: false,
                                                padding: const EdgeInsets.only(
                                                    left: 10)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )),
                    ),
                  ];
                },
              ),
            ),
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SlideTransition(
                  position: TvFocusableAction.isTV
                      ? const AlwaysStoppedAnimation(Offset.zero)
                      : Tween(begin: Offset.zero, end: const Offset(0, 1.0))
                          .animate(controller.animationController),
                  child: NavBar(
                    children: [
                      NavItem(
                          icon: Icons.arrow_back,
                          title: '返回',
                          onTap: () => Get.back()),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void updateDanmakuOption(DanmakuOption? option) {
    if (danmakuController == null || option == null) return;
    danmakuController!.updateOption(option);
  }
}
