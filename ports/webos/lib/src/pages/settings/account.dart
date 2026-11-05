import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/pages/settings/controller.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/color.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_persistent_header_delegate.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';
import 'package:xs/src/widgets/settings/settings_action.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';

const String assetName = 'assets/images/no_image.svg';
final Widget noImage = SvgPicture.asset(assetName);

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    GetStorage box = GetStorage();
    final user = box.read('user');
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    RxDouble maxShrinkOpacity = 1.0.obs;
    return GetBuilder(
        init: AccountSettingsPageController(),
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
                        child: ListView(
                          shrinkWrap: true,
                          padding: AppStyle.edgeInsetsA12,
                          children: [
                            Padding(
                              padding: AppStyle.edgeInsetsA12.copyWith(top: 50),
                              child: Text(
                                '修改资料',
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
                                          title: '头像',
                                          subtitle: '当前版本暂不支持修改头像',
                                          rightIcon: false,
                                          trailing: Container(
                                            padding: const EdgeInsets.all(5),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                width: 35,
                                                height: 35,
                                                color: ColorUtil.fromHex(
                                                    user['color']),
                                                child: user['avatar'] != null
                                                    ? Image.network(
                                                        user['avatar'],
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return noImage;
                                                        },
                                                      )
                                                    : Center(
                                                        child: Text(
                                                          user['name']
                                                              .substring(0, 1),
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        AppStyle.divider,
                                        SettingsAction(
                                          title: '用户名',
                                          value: user['name'],
                                          subtitle: '当前版本暂不支持修改用户名',
                                          rightIcon: false,
                                        ),
                                        AppStyle.divider,
                                        SettingsAction(
                                          autofocus: TvFocusableAction.isTV,
                                          title: '密码',
                                          value: '******',
                                          onTap: () {
                                            Get.toNamed('/change_password');
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppStyle.vGap12,
                            Padding(
                              padding: AppStyle.edgeInsetsA12,
                              child: Text(
                                '登录状态',
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
                                          title: '退出登录',
                                          color: Colors.red,
                                          onTap: () {
                                            box.remove('user');
                                            box.remove('token');
                                            Get.offAllNamed(
                                                TvFocusableAction.isTV
                                                    ? '/bangumi'
                                                    : '/');
                                            SmartDialog.showToast('已退出登录');
                                          },
                                        ),
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
}
