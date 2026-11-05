import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:xs/src/pages/tags/controller.dart';
import 'package:xs/src/utils/color.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';

class TagsCosplayView extends StatelessWidget {
  const TagsCosplayView({super.key, this.active = false});
  final bool active;

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
    Size size = MediaQuery.of(context).size;
    final defaultItemWidth = size.width / 300;
    final column = max(defaultItemWidth.ceil(), 2);
    final itemWidth = size.width / column;
    return GetBuilder(
        init: TagsCosplayController(),
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
                      if (controller.isLoading.isFalse) {
                        controller.more();
                      }
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
                  child: controller.obx(
                    (state) {
                      return CustomScrollView(
                        key: const PageStorageKey('tags-cosplay'),
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
                            sliver: SliverMasonryGrid.count(
                              crossAxisCount: column,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childCount: state!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: itemWidth,
                                  height: state[index].height /
                                      (state[index].width / itemWidth),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: ColorUtil.fromHex(
                                          state[index].color)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      // fit: StackFit.expand,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          child: Image.network(
                                            state[index].image,
                                            width: itemWidth,
                                            height: state[index].height /
                                                (state[index].width /
                                                    itemWidth),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Container(
                                          constraints: const BoxConstraints(
                                              minWidth: double.infinity),
                                          padding: const EdgeInsets.only(
                                              top: 50,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  stops: const [
                                                0,
                                                1
                                              ],
                                                  colors: [
                                                Colors.black.withAlpha(150),
                                                Colors.transparent
                                              ])),
                                          child: Text(
                                            state[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 0,
                                          child: Row(
                                            children: [
                                              Visibility(
                                                visible: state[index].ai,
                                                maintainSize: false,
                                                maintainSemantics: false,
                                                maintainAnimation: false,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 2),
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.black
                                                          .withAlpha(120)),
                                                  child: Text(
                                                    state[index].ai ? 'AI' : '',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                visible: state[index].count > 1,
                                                maintainSize: false,
                                                maintainSemantics: false,
                                                maintainAnimation: false,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 2),
                                                  margin: const EdgeInsets.only(
                                                      right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.black
                                                          .withAlpha(120)),
                                                  child: Text(
                                                      '${state[index].count}P',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              Get.toNamed(
                                                  '/thread/${state[index].id}',
                                                  arguments: state[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
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
