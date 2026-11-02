import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/platform_info.dart';
import 'package:xs/src/pages/bangumi_detail/controller.dart';
import 'package:xs/src/pages/bangumi_detail/models/bangumi_detail_model.dart';
import 'package:xs/src/widgets/expandable_text.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';

class BangumiDetailIndexView extends StatelessWidget {
  const BangumiDetailIndexView({super.key, this.active = false, this.data});
  final bool active;
  final BangumiDetailModel? data;

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
    return GetBuilder(
        id: Get.currentRoute,
        global: false,
        init: BangumiDetailIndexController(),
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
                  child: CustomScrollView(
                    key: const PageStorageKey('bangumi-detail-index'),
                    controller: active ? scrollController : ScrollController(),
                    shrinkWrap: true,
                    slivers: [
                      SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context)),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ExpandableText(
                                data!.overview ?? '无简介',
                                maxLines: 3,
                              ),
                            ),
                            data!.genres!.isEmpty
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                      '分类',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            Wrap(
                              spacing: 0.0,
                              runSpacing: Platform.isWindows ? 0.0 : -10.0,
                              children:
                                  List.generate(data!.genres!.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 3),
                                  child: TextButton(
                                      onPressed: () {
                                        Get.toNamed('/bangumi_genre_list',
                                            arguments: {
                                              'name': data!.genres?[index]
                                            });
                                      },
                                      style: TextButton.styleFrom(
                                          minimumSize: const Size(50, 30),
                                          alignment: Alignment.centerLeft,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .inverseSurface,
                                          backgroundColor:
                                              Colors.grey.withAlpha(30),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50))),
                                      child: Text(
                                        '${data!.genres?[index]}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                );
                              }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            data!.marks!.isEmpty
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Text(
                                      '标签',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            Wrap(
                              spacing: 0.0,
                              runSpacing: Platform.isWindows ? 0.0 : -10.0,
                              children:
                                  List.generate(data!.marks!.length, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 3),
                                  child: TextButton(
                                    onPressed: () {
                                      Get.toNamed('/bangumi_mark_list',
                                          arguments: {
                                            'name': data!.marks![index]?.name
                                          });
                                    },
                                    style: TextButton.styleFrom(
                                        minimumSize: const Size(50, 30),
                                        alignment: Alignment.centerLeft,
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .inverseSurface,
                                        backgroundColor:
                                            Colors.grey.withAlpha(30),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.ideographic,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${data!.marks![index]?.name}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${data!.marks![index]?.count}',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              ));
            }),
          );
        });
  }
}
