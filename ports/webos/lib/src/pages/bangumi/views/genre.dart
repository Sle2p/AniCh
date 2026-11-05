import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:xs/src/pages/bangumi/controller.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class BangumiGenreView extends StatelessWidget {
  const BangumiGenreView({super.key, this.active = false});
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
        init: BangumiGenreController(),
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
                child: controller.obx(
                  (state) {
                    return NotificationListener<ScrollEndNotification>(
                      onNotification: (notification) {
                        final metrics = notification.metrics;
                        if (metrics.atEdge) {
                          bool isTop = metrics.pixels == 0;
                          if (isTop) {
                          } else {
                            if (controller.isLoading.isFalse) {
                              controller.more();
                            }
                          }
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        displacement: 0,
                        edgeOffset: 40,
                        onRefresh: () async {
                          await controller.reload();
                        },
                        child: CustomScrollView(
                          key: const PageStorageKey('bangumi-genre'),
                          controller:
                              active ? scrollController : ScrollController(),
                          shrinkWrap: true,
                          slivers: [
                            SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context)),
                            SliverPadding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10, bottom: 10),
                              sliver: SliverGrid.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              TvFocusableAction.isTV
                                                  ? 280
                                                  : 250,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 1.8),
                                  itemCount: state!.length,
                                  itemBuilder: (context, index) {
                                    return TvFocusableAction(
                                      focusEnabled: active,
                                      onTap: () {
                                        Get.toNamed('/bangumi_genre_list',
                                            arguments: {
                                              'name': state[index].name
                                            });
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
                                                          BorderRadius.circular(
                                                              7),
                                                      color: Colors.grey
                                                          .withOpacity(0.1)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                    child: Stack(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .bottomCenter,
                                                      children: [
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7),
                                                          ),
                                                          child: Image.network(
                                                            state[index]
                                                                    .image ??
                                                                '',
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
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
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 0,
                                                                  bottom: 8,
                                                                  left: 10,
                                                                  right: 10),
                                                          decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .bottomCenter,
                                                                  end: Alignment.topCenter,
                                                                  stops: const [
                                                                0,
                                                                1
                                                              ],
                                                                  colors: [
                                                                Colors.black
                                                                    .withAlpha(
                                                                        150),
                                                                Colors
                                                                    .transparent
                                                              ])),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                '${(state[index].name ?? '未知')}(${state[index].count})',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 17,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: InkWell(
                                                            onTap: () {
                                                              Get.toNamed(
                                                                  '/bangumi_genre_list',
                                                                  arguments: {
                                                                    'name': state[
                                                                            index]
                                                                        .name
                                                                  });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            SliverToBoxAdapter(child: Obx(() {
                              return SizedBox(
                                  height: 5,
                                  child: Visibility(
                                    visible: controller.isLoading.isTrue,
                                    maintainSize: false,
                                    maintainSemantics: false,
                                    maintainAnimation: false,
                                    child: LinearProgressIndicator(
                                        backgroundColor: Colors.grey,
                                        valueColor: AlwaysStoppedAnimation(
                                            Theme.of(context)
                                                .colorScheme
                                                .primary)),
                                  ));
                            }))
                          ],
                        ),
                      ),
                    );
                  },
                  onError: (error) {
                    return const Text('加载失败');
                  },
                ),
              );
            }),
          );
        });
  }
}
