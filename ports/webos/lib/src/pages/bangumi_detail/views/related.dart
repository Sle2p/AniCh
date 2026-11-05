import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:xs/src/pages/bangumi_detail/controller.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';

class BangumiDetailRelatedView extends StatelessWidget {
  const BangumiDetailRelatedView({super.key, this.active = false});
  final bool active;

  @override
  Widget build(BuildContext context) {
    const String assetName = 'assets/images/no_image.svg';
    final Widget noImage = SvgPicture.asset(assetName);
    if (!PlatformInfo.isWebOS) {
      Brightness currentBrightness = MediaQuery.of(context).platformBrightness;
      // 设置状态栏图标的亮度
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: currentBrightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
      ));
    }
    return GetBuilder(
        id: Get.currentRoute,
        global: false,
        init: BangumiDetailRelatedController(),
        builder: (controller) {
          return SafeArea(
            top: false,
            bottom: false,
            maintainBottomViewPadding: true,
            child: Builder(builder: (context) {
              final parentController = PrimaryScrollController.of(context);
              final scrollController =
                  SubordinateScrollController(parentController);
              return KeepAliveWrapper(
                  child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  final metrics = notification.metrics;
                  if (metrics.atEdge) {
                    bool isTop = metrics.pixels == 0;
                    if (isTop) {
                    } else {
                      // if (controller.isLoading.isFalse) {
                      //   controller.more();
                      // }
                    }
                  }
                  return false;
                },
                child: RefreshIndicator(
                  displacement: 60,
                  edgeOffset: 80,
                  onRefresh: () async {
                    await controller.reload();
                  },
                  child: controller.obx((state) {
                    return CustomScrollView(
                      key: const PageStorageKey('bangumi-detail-related'),
                      controller:
                          active ? scrollController : ScrollController(),
                      shrinkWrap: true,
                      slivers: [
                        SliverOverlapInjector(
                            handle:
                                NestedScrollView.sliverOverlapAbsorberHandleFor(
                                    context)),
                        SliverPadding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 10, right: 10, bottom: 10),
                          sliver: SliverGrid.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 150,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 0.6),
                              itemCount: state!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (state[index].id == Get.arguments.id) {
                                      return;
                                    }
                                    Get.toNamed('/bangumi/${state[index].id}',
                                        arguments: state[index]);
                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    //   behavior: SnackBarBehavior.floating,
                                    //   margin: const EdgeInsets.only(
                                    //       bottom: 10, left: 100, right: 100),
                                    //   content: Text(state[index].title),
                                    // ));
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: Colors.grey
                                                      .withOpacity(0.1)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                child: Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomCenter,
                                                  // fit: StackFit.expand,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7),
                                                      ),
                                                      child: state[index]
                                                              .image
                                                              .isEmpty
                                                          ? noImage
                                                          : Image.network(
                                                              state[index]
                                                                  .image,
                                                              width: double
                                                                  .infinity,
                                                              height: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return noImage;
                                                              },
                                                            ),
                                                    ),
                                                    Container(
                                                      constraints:
                                                          const BoxConstraints(
                                                              minWidth: double
                                                                  .infinity),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 50,
                                                              bottom: 5,
                                                              left: 10,
                                                              right: 10),
                                                      decoration: BoxDecoration(
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .bottomCenter,
                                                              end: Alignment
                                                                  .topCenter,
                                                              stops: const [
                                                            0,
                                                            1
                                                          ],
                                                              colors: [
                                                            Colors.black
                                                                .withAlpha(150),
                                                            Colors.transparent
                                                          ])),
                                                      child: Text(
                                                        state[index]
                                                                .status
                                                                .isEmpty
                                                            ? '敬请期待'
                                                            : state[index]
                                                                        .status ==
                                                                    'released'
                                                                ? '全1集'
                                                                : state[index]
                                                                            .status ==
                                                                        'finale'
                                                                    ? '全${state[index].episodesTotal}集'
                                                                    : '更新至第${state[index].episode}集',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.right,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      left: 5,
                                                      child: Row(
                                                        children: [
                                                          Visibility(
                                                            visible: true,
                                                            maintainSize: false,
                                                            maintainSemantics:
                                                                false,
                                                            maintainAnimation:
                                                                false,
                                                            child: Container(
                                                              constraints:
                                                                  const BoxConstraints(
                                                                      maxWidth:
                                                                          90),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              7),
                                                                  color: Colors
                                                                      .black
                                                                      .withAlpha(
                                                                          120)),
                                                              child: Text(
                                                                (controller.id.value ==
                                                                            state[index]
                                                                                .id
                                                                        ? '当前'
                                                                        : state[index]
                                                                            .type) +
                                                                    (state[index]
                                                                            .name
                                                                            .isNotEmpty
                                                                        ? ' · ${state[index].name}'
                                                                        : ''),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          Get.toNamed(
                                                              '/bangumi/${state[index].id}',
                                                              arguments:
                                                                  state[index]);
                                                          // ScaffoldMessenger.of(context)
                                                          //     .showSnackBar(SnackBar(
                                                          //   behavior:
                                                          //       SnackBarBehavior.floating,
                                                          //   margin: const EdgeInsets.only(
                                                          //       bottom: 10,
                                                          //       left: 100,
                                                          //       right: 100),
                                                          //   content:
                                                          //       Text(state[index].title),
                                                          // ));
                                                          // Get.toNamed('/thread/${state[index].id}',
                                                          //     arguments: state[index]);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            state[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: controller.id.value ==
                                                        state[index].id
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : null),
                                          ),
                                          Opacity(
                                            opacity: 0.7,
                                            child: Text(
                                              state[index].tagline,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    );
                  }),
                ),
              ));
            }),
          );
        });
  }
}
