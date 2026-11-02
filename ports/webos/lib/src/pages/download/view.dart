import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/download/controller.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_persistent_header_delegate.dart';
import 'package:xs/src/widgets/navbar.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    RxDouble maxShrinkOpacity = 1.0.obs;
    return GetBuilder(
        init: DownloadPageController(),
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            body: SafeArea(
              top: true,
              bottom: false,
              maintainBottomViewPadding: false,
              child: DefaultTabController(
                length: controller.tabs.length,
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
                    child: TabBarView(
                      controller: controller.tabController,
                      children: const [
                        Text('download'),
                        Text('complete'),
                      ],
                    ),
                  ),
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverPersistentHeader(
                          floating: true,
                          delegate: CustomSliverPersistentHeaderDelegate(
                            onMaxOffset: (offset) {
                              maxShrinkOpacity(1 - offset);
                            },
                            child: Material(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                                            .scaffoldBackgroundColor,
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                '离线缓存',
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
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: CustomSliverPersistentHeaderDelegate(
                              maxExtent: 40,
                              minExtent: 40,
                              child: PreferredSize(
                                preferredSize: const Size.fromHeight(40),
                                child: Material(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CustomDragToMoveArea(
                                    child: TabBar(
                                      controller: controller.tabController,
                                      tabAlignment: TabAlignment.start,
                                      isScrollable: true,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      dividerColor: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                      tabs: controller.tabs,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ];
                  },
                ),
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
