import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/pages/profile/controller.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/color.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_persistent_header_delegate.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/settings/settings_action.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

const String assetName = 'assets/images/no_image.svg';
final Widget noImage = SvgPicture.asset(assetName);

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    RxDouble maxShrinkOpacity = 1.0.obs;
    return GetBuilder(
        init: ProfilePageController(),
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
                  child: const ProfileView(),
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
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text('个人中心',
                                                  style:
                                                      TextStyle(fontSize: 16)),
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
                          onTap: () => Get.back())
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!PlatformInfo.isWebOS) {
      Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
      // 设置状态栏图标的亮度
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: currentBrightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ));
    }
    final box = GetStorage();
    final user = box.read('user');
    return Stack(
      children: [
        CustomScrollView(
          key: const PageStorageKey('profile'),
          shrinkWrap: true,
          slivers: [
            SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: ColorUtil.fromHex(user['color']),
                                  child: user['avatar'] != null
                                      ? Image.network(
                                          user['avatar'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return noImage;
                                          },
                                        )
                                      : Center(
                                          child: Text(
                                            user['name'].substring(0, 1),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${user['name']}',
                                      style: const TextStyle(fontSize: 16)),
                                  Row(
                                    children: [
                                      Text('UID: ${user['id']}',
                                          style: const TextStyle(fontSize: 12)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('浓度: ${user['exp']}',
                                          style: const TextStyle(fontSize: 12)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text('硬币: ${user['coin']}',
                                          style: const TextStyle(fontSize: 12))
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SettingsCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SettingsAction(
                            autofocus: PlatformInfo.isWebOS,
                            title: '观看记录',
                            onTap: () {
                              Get.toNamed('/play_history');
                            },
                          ),
                          AppStyle.divider,
                          // SettingsAction(
                          //   title: '离线缓存',
                          //   onTap: () {
                          //     Get.toNamed('/download');
                          //   },
                          // ),
                          // AppStyle.divider,
                          SettingsAction(
                            title: '追番列表',
                            onTap: () {
                              Get.toNamed('/bangumi_collection');
                            },
                          ),
                          AppStyle.divider,
                          SettingsAction(
                            title: '图片收藏',
                            onTap: () {
                              Get.toNamed('/thread_collection');
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SettingsCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SettingsAction(
                            title: '账号管理',
                            onTap: () {
                              Get.toNamed('/account_settings');
                            },
                          ),
                          AppStyle.divider,
                          SettingsAction(
                            title: '外观设置',
                            onTap: () {
                              Get.toNamed('/theme_settings');
                            },
                          ),
                          AppStyle.divider,
                          SettingsAction(
                            title: '播放设置',
                            onTap: () {
                              Get.toNamed('/playback_settings');
                            },
                          ),
                          AppStyle.divider,
                          SettingsAction(
                            title: '弹幕设置',
                            onTap: () {
                              Get.toNamed('/danmaku_settings');
                            },
                          ),
                          AppStyle.divider,
                          SettingsAction(
                            title: '版本信息',
                            onTap: () {
                              Get.toNamed('/info');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
