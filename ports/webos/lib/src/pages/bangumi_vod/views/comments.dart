import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/widgets/bangumi_vod_comment/comment_item.dart';
import 'package:xs/src/widgets/bangumi_vod_comment/controller.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/reply.dart';
import 'package:xs/src/widgets/subordinate_scroll_controller.dart';

class BangumiVodCommentsView extends StatelessWidget {
  final BangumiVodPageController bangumiVodPageController;
  const BangumiVodCommentsView(
      {super.key, required this.bangumiVodPageController});

  @override
  Widget build(BuildContext context) {
    final parentController = PrimaryScrollController.of(context);
    final scrollController = SubordinateScrollController(parentController);
    return KeepAliveWrapper(
      child: Obx(() {
        final id =
            '${bangumiVodPageController.id}|${bangumiVodPageController.episode}';
        return GetBuilder(
          id: id,
          global: false,
          init: CommentController(),
          builder: (controller) {
            controller.id(id);
            controller.getComments(id);
            return controller.obx((state) {
              return SafeArea(
                top: true,
                bottom: true,
                maintainBottomViewPadding: true,
                minimum:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                child: Stack(
                  children: [
                    NotificationListener<ScrollEndNotification>(
                      onNotification: (notification) {
                        final metrics = notification.metrics;
                        if (metrics.atEdge) {
                          bool isTop = metrics.pixels == 0;
                          if (isTop) {
                          } else {
                            if (controller.commentsLoading.isFalse) {
                              controller.getMoreComments(id);
                            }
                          }
                        }
                        return false;
                      },
                      child: RefreshIndicator(
                        displacement: 20,
                        edgeOffset: 80,
                        onRefresh: () async {
                          controller.getComments(id);
                        },
                        child: CustomScrollView(
                          controller:
                              bangumiVodPageController.tabIndex.value == 1
                                  ? scrollController
                                  : ScrollController(),
                          slivers: [
                            SliverOverlapInjector(
                                handle: NestedScrollView
                                    .sliverOverlapAbsorberHandleFor(context)),
                            SliverToBoxAdapter(
                              child: Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      child: Obx(() {
                                        return Text(
                                          '第${bangumiVodPageController.episode}集 评论区 (${controller.comments.length})',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Obx(() {
                                return ListView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  itemBuilder: (itemBuilder, index) {
                                    Map comment = controller.comments[index];
                                    return CommentItem(
                                      comment,
                                      controller: controller,
                                      replyFn: () {
                                        Get.bottomSheet(ReplyNewDialog(
                                          id: id,
                                          sendFn: (json) async {
                                            Get.back();
                                            final data =
                                                await controller.replyComment(
                                                    json: json,
                                                    parent: comment['id'],
                                                    reply: null);
                                            if (data.isNotEmpty) {
                                              comment['replies'].add(data);
                                              controller.update();
                                            }
                                          },
                                        ));
                                      },
                                      likeFn: (id) {
                                        return controller.likeComment(id);
                                      },
                                      cancelLikeFn: (id) {
                                        return controller.cancelLikeComment(id);
                                      },
                                    );
                                  },
                                  itemCount: controller.comments.length,
                                );
                              }),
                            ),
                            const SliverPadding(
                              padding: EdgeInsets.only(bottom: 50),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        height: 50,
                        child: Column(
                          children: [
                            AppStyle.divider,
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Material(
                                    child: InkWell(
                                      onTap: () {
                                        Get.bottomSheet(ReplyNewDialog(
                                          id: id,
                                          sendFn: (json) {
                                            Get.back();
                                            controller.sendComment(json);
                                          },
                                        ));
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        width: double.infinity,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withAlpha(20),
                                        child: const Opacity(
                                          opacity: 0.7,
                                          child: Text(
                                            '发送评论',
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
          },
        );
      }),
    );
  }
}
