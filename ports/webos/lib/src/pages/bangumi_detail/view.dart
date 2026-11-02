import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/bangumi_detail/controller.dart';
import 'package:xs/src/pages/bangumi_detail/views/characters.dart';
import 'package:xs/src/pages/bangumi_detail/views/index.dart';
import 'package:xs/src/pages/bangumi_detail/views/episodes.dart';
import 'package:xs/src/pages/bangumi_detail/views/persons.dart';
import 'package:xs/src/pages/bangumi_detail/views/related.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class BangumiDetailPage extends StatelessWidget {
  const BangumiDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/no_image.svg';
    final Widget noImage = SvgPicture.asset(assetName);
    RxDouble appBarHeight = 1.0.obs;
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    return GetBuilder(
        id: Get.currentRoute,
        global: false,
        init: BangumiDetailController(),
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            body: controller.obx((state) {
              final data = state;
              return Obx(() {
                return DefaultTabController(
                  length: controller.tabs.length,
                  child: NestedScrollView(
                    floatHeaderSlivers: false,
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
                          BangumiDetailIndexView(
                            active: controller.tabIndex.value == 0,
                            data: data,
                          ),
                          BangumiDetailEpisodesView(
                            active: controller.tabIndex.value == 1,
                            data: data,
                          ),
                          BangumiDetailCharactersView(
                              active: controller.tabIndex.value == 2),
                          BangumiDetailPersonsView(
                              active: controller.tabIndex.value == 3),
                          BangumiDetailRelatedView(
                              active: controller.tabIndex.value == 4),
                        ],
                      ),
                    ),
                    headerSliverBuilder: (context, innerBoxIsScrolled) {
                      return [
                        SliverOverlapAbsorber(
                          sliver: SliverAppBar(
                            title: Obx(() {
                              return CustomDragToMoveArea(
                                  child: Opacity(
                                opacity: min(appBarHeight.value.abs(), 1.0),
                                child: Text('${data?.title}'),
                              ));
                            }),
                            actions: [closeWindowButton(positioned: false)],
                            pinned: true,
                            automaticallyImplyLeading: false,
                            floating: true,
                            snap: false,
                            expandedHeight: 270,
                            collapsedHeight: 50,
                            toolbarHeight: 50,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            surfaceTintColor:
                                Theme.of(context).colorScheme.inverseSurface,
                            flexibleSpace: LayoutBuilder(
                              builder: (context, constraints) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  appBarHeight(1.5 -
                                      (constraints.biggest.height -
                                              MediaQuery.of(context)
                                                  .padding
                                                  .top) /
                                          180);
                                });
                                return Obx(() {
                                  return Opacity(
                                    opacity: max(
                                        (appBarHeight.value - 1).abs(), 0.0),
                                    child: CustomDragToMoveArea(
                                      child: FlexibleSpaceBar(
                                        background: Stack(
                                          children: [
                                            ShaderMask(
                                              shaderCallback: (rect) {
                                                return LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [
                                                      Colors.black
                                                          .withAlpha(100),
                                                      Colors.transparent
                                                    ]).createShader(
                                                    Rect.fromLTRB(
                                                        0,
                                                        0,
                                                        rect.width,
                                                        rect.height));
                                              },
                                              blendMode: BlendMode.dstIn,
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  data!.image != null
                                                      ? Image.network(
                                                          '${data.image}',
                                                          fit: BoxFit.cover,
                                                        )
                                                      : noImage,
                                                  BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 10, sigmaY: 10),
                                                    child: Container(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .padding
                                                          .top +
                                                      10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 150,
                                                    child: AspectRatio(
                                                      aspectRatio: 3 / 4,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            data.image != null
                                                                ? Image.network(
                                                                    '${data.image}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : noImage,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          child: Text(
                                                            '${data.title}',
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        Text(
                                                          '时间: ${Time.dateTimeFormat(data.airdate ?? 0)}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '状态: ${data.status == null ? '敬请期待' : data.status == 'released' ? '全1集' : data.status == 'finale' ? '全${data.episodesTotal}集' : '更新至第${data.episode}集'}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          '评分: ${data.rating!.where((i) {
                                                            return i!.score!
                                                                    .toInt() >
                                                                0;
                                                          }).isNotEmpty ? data.rating?.where((i) {
                                                                return i!.score!
                                                                        .toInt() >
                                                                    0;
                                                              }).map((i) {
                                                                return '${i?.site}(${i!.score})';
                                                              }).toSet().join('  ') : '暂无'}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        // centerTitle: true,
                                        collapseMode: CollapseMode.pin,
                                      ),
                                    ),
                                  );
                                });
                              },
                            ),
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(50),
                              child: Material(
                                color: Colors.transparent,
                                // color: Theme.of(context).scaffoldBackgroundColor,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: TvTabBar(
                                          autofocus: true,
                                          labelPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          controller: controller.tabController,
                                          tabAlignment: TabAlignment.start,
                                          isScrollable: true,
                                          indicatorSize:
                                              TabBarIndicatorSize.label,
                                          dividerColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          tabs: controller.tabs,
                                        ),
                                      ),
                                    ),
                                    Obx(() {
                                      if (controller
                                          .collectStatusLoading.isFalse) {
                                        return !controller.collectStatus.value
                                            ? SizedBox(
                                                height: 30,
                                                child: FilledButton(
                                                  style: ButtonStyle(
                                                      shape: WidgetStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)))),
                                                  onPressed: () {
                                                    controller
                                                        .showCollectSheet();
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.favorite,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text('收藏')
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 30,
                                                child: FilledButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all(Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary
                                                                  .withAlpha(
                                                                      200)),
                                                      shape: WidgetStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)))),
                                                  onPressed: () {
                                                    controller.showMarkSheet();
                                                  },
                                                  child: const Row(
                                                    children: [
                                                      Icon(
                                                        Icons.more_vert,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                      Text('标记为...')
                                                    ],
                                                  ),
                                                ),
                                              );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                      ];
                    },
                  ),
                );
              });
            }),
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
