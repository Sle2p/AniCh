import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:xs/src/pages/settings/controller.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_persistent_header_delegate.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/settings/settings_action.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';

class InfoSettingsPage extends StatelessWidget {
  const InfoSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    RxDouble maxShrinkOpacity = 1.0.obs;
    return GetBuilder(
        init: InfoSettingsPageController(),
        builder: (controller) {
          return Scaffold(
            extendBody: true,
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
                        child: ListView(
                          shrinkWrap: true,
                          padding: AppStyle.edgeInsetsA12,
                          children: [
                            Padding(
                              padding: AppStyle.edgeInsetsA12.copyWith(top: 50),
                              child: Text(
                                '版本信息',
                                style: Get.textTheme.titleSmall,
                              ),
                            ),
                            SettingsCard(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SettingsCard(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SettingsAction(
                                          title: '主页',
                                          value: 'https://xs.cx',
                                          onTap: () {
                                            launchUrlString(
                                              'https://xs.cx',
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                        ),
                                        AppStyle.divider,
                                        SettingsAction(
                                          title: 'GITHUB',
                                          value:
                                              'https://github.com/Sle2p/xs.cx',
                                          onTap: () {
                                            launchUrlString(
                                              'https://github.com/Sle2p/xs.cx',
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          },
                                        ),
                                        AppStyle.divider,
                                        SettingsAction(
                                          title: PlatformInfo.isWebOS
                                              ? '电视版版本'
                                              : '检测更新',
                                          subtitle: PlatformInfo.isWebOS
                                              ? null
                                              : '点击获取最新版本',
                                          value: Utils.packageInfo.version,
                                          rightIcon: !PlatformInfo.isWebOS,
                                          onTap: PlatformInfo.isWebOS
                                              ? null
                                              : () => Utils.checkUpdate(),
                                        ),
                                        if (PlatformInfo.isWebOS) ...[
                                          AppStyle.divider,
                                          SettingsAction(
                                            title: '界面绘制尺寸',
                                            subtitle: 'Flutter 渲染尺寸，视频分辨率另计',
                                            value:
                                                '${View.of(context).physicalSize.width.round()} × ${View.of(context).physicalSize.height.round()} · ${View.of(context).devicePixelRatio} 倍',
                                            rightIcon: false,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                                '账号管理',
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
                  position: Tween(begin: Offset.zero, end: const Offset(0, 1.0))
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
}
