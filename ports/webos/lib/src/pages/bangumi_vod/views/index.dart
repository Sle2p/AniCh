import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/widgets/expandable_text.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';

const String assetName = 'assets/images/no_image.svg';
final Widget noImage = SvgPicture.asset(assetName);

class BangumiVodIndexView extends StatelessWidget {
  const BangumiVodIndexView({super.key, required this.controller});
  final BangumiVodPageController controller;

  @override
  Widget build(BuildContext context) {
    final parentController = PrimaryScrollController.of(context);
    final scrollController = SubordinateScrollController(parentController);
    return controller.obx((state) {
      if (controller.episodes.isNotEmpty) {
        return SafeArea(
            top: true,
            bottom: true,
            maintainBottomViewPadding: true,
            minimum:
                const EdgeInsets.only(top: 5, bottom: 0, left: 10, right: 10),
            child: Obx(() {
              final ep = controller.episodes.firstWhere(
                (element) => element.sort == controller.episode,
              );
              controller.scrollToIndex();
              return CustomScrollView(
                controller: controller.tabIndex.value == 0
                    ? scrollController
                    : ScrollController(),
                // controller: ScrollController(),
                slivers: [
                  SliverOverlapInjector(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context)),
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.player.pause();
                            Get.toNamed('/bangumi/${controller.episode}',
                                arguments: controller.data);
                          },
                          child: Text(
                            '${controller.data.title}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('第${controller.episode}集 ${ep.title}',
                            style: const TextStyle(fontSize: 14)),
                        Text('放送时间: ${Time.dateTimeFormat(ep.airdate.toInt())}',
                            style: const TextStyle(fontSize: 14)),
                        ExpandableText(
                          '本集概况: ${ep.overview.isNotEmpty ? ep.overview : '暂无'}',
                          maxLines: 3,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: const Row(
                            children: [
                              Text(
                                '选集',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            controller: controller.playListScrollController,
                            itemBuilder: (itemBuilder, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (controller.episode ==
                                      controller.episodes[index].sort) {
                                    return;
                                  }
                                  controller.rxEpisode(
                                      controller.episodes[index].sort);
                                  debugPrint('切换到第${controller.episode}集');
                                  controller.player.stop();
                                  controller.danmakuController?.clear();
                                  controller.get();
                                  // controller.scrollToIndex();
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Opacity(
                                    opacity: controller.episode ==
                                            controller.episodes[index].sort
                                        ? 1
                                        : 0.6,
                                    child: Container(
                                      width: 150,
                                      margin: const EdgeInsets.only(right: 10),
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
                                                      child: controller
                                                              .episodes[index]
                                                              .image
                                                              .isNotEmpty
                                                          ? Image.network(
                                                              controller
                                                                  .episodes[
                                                                      index]
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
                                                            )
                                                          : noImage,
                                                    ),
                                                    Positioned(
                                                      bottom: 5,
                                                      right: 0,
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
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 1,
                                                                      left: 5,
                                                                      right: 5,
                                                                      bottom:
                                                                          3),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
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
                                                                controller
                                                                        .episodes[
                                                                            index]
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
                                                            visible: controller
                                                                    .episodes[
                                                                        index]
                                                                    .duration >
                                                                0,
                                                            maintainSize: false,
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
                                                                      right: 5,
                                                                      bottom:
                                                                          3),
                                                              margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 5),
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
                                                                        seconds: controller
                                                                            .episodes[index]
                                                                            .duration)
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
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (controller
                                                                  .episode ==
                                                              controller
                                                                  .episodes[
                                                                      index]
                                                                  .sort) {
                                                            return;
                                                          }
                                                          controller.rxEpisode(
                                                              controller
                                                                  .episodes[
                                                                      index]
                                                                  .sort);
                                                          debugPrint(
                                                              '切换到第${controller.episode}集');
                                                          controller.player
                                                              .stop();
                                                          controller
                                                              .danmakuController
                                                              ?.clear();
                                                          controller.get();
                                                          // controller
                                                          //     .scrollToIndex();
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
                                            '第${controller.episodes[index].sort}集 ${controller.episodes[index].title}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: controller.episode ==
                                                        controller
                                                            .episodes[index]
                                                            .sort
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : DefaultTextStyle.of(
                                                            context)
                                                        .style
                                                        .color),
                                          ),
                                          Opacity(
                                            opacity: 0.7,
                                            child: Text(
                                              Time.dateTimeFormat(controller
                                                  .episodes[index].airdate
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
                                ),
                              );
                            },
                            itemCount: controller.episodes.length,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }));
      } else {
        return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.primary)),
        );
      }
    });
  }
}
