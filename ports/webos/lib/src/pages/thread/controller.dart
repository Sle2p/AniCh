import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/thread.pb.dart';
import 'package:xs/src/apis/thread.dart';
import 'package:xs/src/utils/account.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/keepalive.dart';
import 'package:xs/src/widgets/reply.dart';
import 'package:xs/src/widgets/thread_comment/comment_item.dart';
import 'package:xs/src/widgets/thread_comment/controller.dart';

class ThreadController extends GetxController with StateMixin<thread_> {
  thread_ data = thread_();
  RxInt id = 0.obs;
  RxBool collectStatus = false.obs;
  RxBool likeStatus = false.obs;

  @override
  void onInit() {
    id(Get.arguments.id);
    get();
    getCollectStatus();
    getLikeStatus();
    super.onInit();
  }

  void get() async {
    try {
      debugPrint('ThreadController-get');
      change(null, status: RxStatus.loading());
      final response = await ThreadApi.getData(id: id.value);
      if (response.statusCode != 200) {
        change(null, status: RxStatus.error('error'));
      } else {
        data = thread_.fromBuffer(response.data);
        change(data, status: RxStatus.success());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 收藏状态
  void getCollectStatus() async {
    try {
      final token = AccountUtil.token();
      if (token.isEmpty) {
        return;
      }
      debugPrint('ThreadController-getCollectStatus');
      final response = await ThreadApi.collectStatus(id: id.value);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        collectStatus(data);
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 收藏
  void collect() async {
    try {
      final token = AccountUtil.token();
      if (token.isEmpty) {
        return;
      }
      debugPrint('ThreadController-collect');
      final response = await ThreadApi.collect(id: id.value);
      if (response.statusCode == 200) {
        collectStatus(true);
        SmartDialog.showToast('操作成功');
      } else {
        throw Error();
      }
    } catch (e) {
      SmartDialog.showToast('操作失败');
      debugPrint(e.toString());
    }
  }

  // 取消收藏
  void cancelCollect() async {
    try {
      final token = AccountUtil.token();
      if (token.isEmpty) {
        return;
      }
      debugPrint('ThreadController-cancelCollect');
      final response = await ThreadApi.cancelCollect(id: id.value);
      if (response.statusCode == 200) {
        collectStatus(false);
        SmartDialog.showToast('取消成功');
      } else {
        throw Error();
      }
    } catch (e) {
      SmartDialog.showToast('取消失败');
      debugPrint(e.toString());
    }
  }

  // 喜欢状态
  void getLikeStatus() async {
    try {
      final token = AccountUtil.token();
      if (token.isEmpty) {
        return;
      }
      debugPrint('ThreadController-getLikeStatus');
      final response = await ThreadApi.likeStatus(id: id.value);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        likeStatus(data);
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 喜欢
  void like() async {
    try {
      final token = AccountUtil.token();
      if (token.isEmpty) {
        return;
      }
      debugPrint('ThreadController-like');
      final response = await ThreadApi.like(id: id.value);
      if (response.statusCode == 200) {
        likeStatus(true);
        SmartDialog.showToast('操作成功');
      } else {
        throw Error();
      }
    } catch (e) {
      SmartDialog.showToast('操作失败');
      debugPrint(e.toString());
    }
  }

  // 取消喜欢
  void cancelLike() async {
    try {
      final token = AccountUtil.token();
      if (token.isEmpty) {
        return;
      }
      debugPrint('ThreadController-cancelLike');
      final response = await ThreadApi.cancelLike(id: id.value);
      if (response.statusCode == 200) {
        likeStatus(false);
        SmartDialog.showToast('取消成功');
      } else {
        throw Error();
      }
    } catch (e) {
      SmartDialog.showToast('取消失败');
      debugPrint(e.toString());
    }
  }

  void showDetailSheet(
      BuildContext context, ThreadController threadController) {
    Utils.showBottomSheet(
      title: '详情',
      scrollControlDisabledMaxHeightRatio: 0.9,
      child: KeepAliveWrapper(child: Obx(() {
        final id = threadController.id.value.toString();
        return GetBuilder(
          init: CommentController(id),
          builder: (controller) {
            // print(id);
            // controller.id(id);
            // controller.getComments(id);
            return controller.obx(
              (state) {
                return SizedBox(
                  width: double.infinity,
                  // color: Theme.of(context).scaffoldBackgroundColor,
                  // padding: const EdgeInsets.all(10),
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Container(
                                width: double.infinity,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.title,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      Time.dateFormat(data.date.toInt()),
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.remove_red_eye,
                                            size: 16),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${data.viewsCount}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.thumb_up, size: 14),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${data.likesCount}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(Icons.favorite, size: 15),
                                        const SizedBox(width: 2),
                                        Text(
                                          '${data.collectsCount}',
                                          style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (itemBuilder, index) {
                                  return Container(
                                    constraints:
                                        const BoxConstraints(minWidth: 100),
                                    margin: const EdgeInsets.only(
                                        top: 10, right: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: Material(
                                        // color: Colors.black.withAlpha(20),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: InkWell(
                                          onTap: () {
                                            Get.offAndToNamed('/tags',
                                                arguments: {
                                                  'tag': data.tags[index].name
                                                });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                data.tags[index].translate
                                                        .isNotEmpty
                                                    ? Text(
                                                        data.tags[index]
                                                            .translate,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    : Container(),
                                                Text(data.tags[index].name,
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: data.tags.length,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Obx(() {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: controller.comments.isNotEmpty
                                      ? Container(
                                          // height: 100,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: NotificationListener<
                                              ScrollEndNotification>(
                                            onNotification: (notification) {
                                              final metrics =
                                                  notification.metrics;
                                              if (metrics.atEdge) {
                                                bool isTop =
                                                    metrics.pixels == 0;
                                                if (isTop) {
                                                } else {
                                                  if (controller.commentsLoading
                                                      .isFalse) {
                                                    controller
                                                        .getMoreComments(id);
                                                  }
                                                }
                                              }
                                              return false;
                                            },
                                            child: RefreshIndicator(
                                              displacement: 0,
                                              edgeOffset: 20,
                                              onRefresh: () async {
                                                controller.getComments(id);
                                              },
                                              child: Obx(() {
                                                return ListView.builder(
                                                  primary: true,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (itemBuilder, index) {
                                                    Map comment = controller
                                                        .comments[index];
                                                    return CommentItem(
                                                      comment,
                                                      controller: controller,
                                                      replyFn: () {
                                                        Get.bottomSheet(
                                                            ReplyNewDialog(
                                                          id: threadController
                                                              .id.value
                                                              .toString(),
                                                          sendFn: (json) async {
                                                            Get.back();
                                                            final data = await controller
                                                                .replyComment(
                                                                    json: json,
                                                                    parent:
                                                                        comment[
                                                                            'id'],
                                                                    reply:
                                                                        null);
                                                            if (data
                                                                .isNotEmpty) {
                                                              comment['replies']
                                                                  .add(data);
                                                              controller
                                                                  .update();
                                                            }
                                                          },
                                                        ));
                                                      },
                                                      likeFn: (id) {
                                                        return controller
                                                            .likeComment(id);
                                                      },
                                                      cancelLikeFn: (id) {
                                                        return controller
                                                            .cancelLikeComment(
                                                                id);
                                                      },
                                                    );
                                                  },
                                                  itemCount: controller
                                                      .comments.length,
                                                );
                                              }),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: const Center(
                                            child: Text('暂无评论'),
                                          ),
                                        ),
                                );
                              }),
                            ),
                            const SizedBox(height: 60),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                                                id: threadController.id.value
                                                    .toString(),
                                                sendFn: (json) {
                                                  Get.back();
                                                  controller.sendComment(json);
                                                },
                                              ));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
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
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        );
      })),
    );
  }
}
