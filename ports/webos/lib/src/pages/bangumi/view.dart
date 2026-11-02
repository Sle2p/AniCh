import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/bangumi/controller.dart';
import 'package:xs/src/pages/bangumi/views/index.dart';
import 'package:xs/src/pages/bangumi/views/genre.dart';
import 'package:xs/src/pages/bangumi/views/latest.dart';
import 'package:xs/src/pages/bangumi/views/mark.dart';
import 'package:xs/src/pages/bangumi/views/recommend.dart';
import 'package:xs/src/pages/search/models/search_type.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_persistent_header_delegate.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/search_bar.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';
import 'package:xs/src/widgets/tv_app_navigation.dart';

class BangumiPage extends StatelessWidget {
  const BangumiPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    RxDouble maxShrinkOpacity = 1.0.obs;
    return GetBuilder(
        init: BangumiController(),
        builder: (controller) {
          return Scaffold(
            extendBody: !TvFocusableAction.isTV,
            body: SafeArea(
              top: true,
              bottom: false,
              maintainBottomViewPadding: false,
              child: Obx(() {
                return DefaultTabController(
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
                        children: [
                          BangumiLatestView(
                            active: controller.tabIndex.value == 0,
                          ),
                          BangumiRecommendView(
                            active: controller.tabIndex.value == 1,
                          ),
                          BangumiIndexView(
                            active: controller.tabIndex.value == 2,
                          ),
                          BangumiGenreView(
                              active: controller.tabIndex.value == 3),
                          BangumiMarkView(
                              active: controller.tabIndex.value == 4),
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CustomDragToMoveArea(
                                  child: Obx(
                                    () {
                                      return Opacity(
                                        opacity: maxShrinkOpacity.value,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          constraints: const BoxConstraints(
                                              minHeight: 50),
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: Row(
                                            children: [
                                              const CustomSearchBar(
                                                placeholder: '搜索番剧',
                                                searchType: SearchType.bangumi,
                                              ),
                                              closeWindowButton(
                                                  positioned: false,
                                                  padding:
                                                      const EdgeInsets.only(
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
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverPersistentHeader(
                              pinned: true,
                              delegate: CustomSliverPersistentHeaderDelegate(
                                maxExtent: 40,
                                minExtent: 40,
                                child: PreferredSize(
                                  preferredSize: const Size.fromHeight(40),
                                  child: Material(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    child: CustomDragToMoveArea(
                                      child: TvTabBar(
                                        controller: controller.tabController,
                                        tabAlignment: TabAlignment.start,
                                        isScrollable: true,
                                        indicatorSize:
                                            TabBarIndicatorSize.label,
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
                );
              }),
            ),
            bottomNavigationBar: TvFocusableAction.isTV
                ? const TvAppNavigation()
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SlideTransition(
                        position:
                            Tween(begin: Offset.zero, end: const Offset(0, 1.0))
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
