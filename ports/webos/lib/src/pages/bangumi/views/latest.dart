import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:xs/src/pages/bangumi/controller.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class BangumiLatestView extends StatelessWidget {
  const BangumiLatestView({super.key, this.active = false});
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
        init: BangumiLatestController(),
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
                  displacement: 0,
                  edgeOffset: 40,
                  onRefresh: () async {
                    await controller.reload();
                  },
                  child: controller.obx(
                    (state) {
                      return CustomScrollView(
                        key: const PageStorageKey('bangumi-latest'),
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
                                            TvFocusableAction.isTV ? 300 : 250,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 1.2),
                                itemCount: state!.length,
                                itemBuilder: (context, index) {
                                  return TvFocusableAction(
                                    focusEnabled: active,
                                    onTap: () {
                                      if (TvFocusableAction.isTV) {
                                        Get.toNamed('/vod/${state[index].id}',
                                            arguments: {
                                              'id': state[index].id,
                                              'episode': state[index].ep,
                                            });
                                        return;
                                      }
                                      Get.toNamed(
                                          '/bangumi/${state[index].id}/${state[index].ep}',
                                          arguments: {
                                            'id': state[index].id,
                                            'ep': state[index].ep
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
                                                      BorderRadius.circular(7),
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomCenter,
                                                    // fit: StackFit.expand,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                        ),
                                                        child: Image.network(
                                                          state[index].image,
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
                                                      Positioned(
                                                        bottom: 5,
                                                        right: 0,
                                                        child: Row(
                                                          children: [
                                                            Visibility(
                                                              visible: true,
                                                              maintainSize:
                                                                  false,
                                                              maintainSemantics:
                                                                  false,
                                                              maintainAnimation:
                                                                  false,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 1,
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        bottom:
                                                                            3),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                            120)),
                                                                child: Text(
                                                                  state[index]
                                                                          .status
                                                                      ? '有资源'
                                                                      : '无资源',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: state[
                                                                          index]
                                                                      .duration >
                                                                  0,
                                                              maintainSize:
                                                                  false,
                                                              maintainSemantics:
                                                                  false,
                                                              maintainAnimation:
                                                                  false,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 1,
                                                                        left: 5,
                                                                        right:
                                                                            5,
                                                                        bottom:
                                                                            3),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: Colors
                                                                        .black
                                                                        .withAlpha(
                                                                            120)),
                                                                child: Text(
                                                                  Duration(
                                                                          seconds:
                                                                              state[index].duration)
                                                                      .toString()
                                                                      .split('.')
                                                                      .first,
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
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.toNamed(
                                                                '/vod/${state[index].id}',
                                                                arguments: {
                                                                  'id': state[
                                                                          index]
                                                                      .id,
                                                                  'episode':
                                                                      state[index]
                                                                          .ep
                                                                });
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
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            Opacity(
                                              opacity: 0.7,
                                              child: Text(
                                                state[index].name,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ),
                                            Opacity(
                                              opacity: 0.7,
                                              child: Text(
                                                Time.dateTimeFormat(state[index]
                                                    .airdate
                                                    .toInt()),
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
                      );
                    },
                    onError: (error) {
                      return const Text('加载失败');
                    },
                  ),
                ),
              ));
            }),
          );
        });
  }
}
