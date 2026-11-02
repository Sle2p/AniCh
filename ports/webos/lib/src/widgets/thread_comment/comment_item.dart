import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/color.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/widgets/sticker.dart';
import 'package:xs/src/widgets/thread_comment/controller.dart';
import 'package:xs/src/widgets/thread_comment/replies_preview.dart';

class CommentItem extends StatelessWidget {
  final Map comment;
  final bool repliesPreview;
  final CommentController controller;
  final Function()? replyFn;
  final Function(String id)? likeFn;
  final Function(String id)? cancelLikeFn;
  const CommentItem(this.comment,
      {super.key,
      this.repliesPreview = true,
      this.replyFn,
      this.likeFn,
      this.cancelLikeFn,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final contents = comment['contents'];
    contents.last['content'] =
        contents.last['content'].replaceAll(RegExp('\n\$'), '');
    RxInt likeCount = 0.obs;
    RxBool like = false.obs;
    if (comment['like'] != null) {
      like(comment['like']);
    }
    if (comment['likes_count'] != null) {
      likeCount(comment['likes_count']);
    }
    return Obx(() {
      return Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding:
                const EdgeInsets.only(top: 5, bottom: 0, left: 10, right: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: ColorUtil.fromHex(comment['user']['color']),
                        child: comment['user']?['avatar'] != null
                            ? Image.network(comment['user']['avatar'])
                            : Center(
                                child: Text(
                                  comment['user']['name'].substring(0, 1),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comment['user']['name'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: Text(
                              Time.dateFormat(DateTime.parse(comment['created'])
                                  .millisecondsSinceEpoch),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(fontSize: 16),
                              children: contents
                                  .map((e) {
                                    if (e['type'] == 'sticker') {
                                      final sticker_ = sticker['list']
                                          .firstWhere(
                                              (i) => i['text'] == e['content']);
                                      final String src =
                                          '${sticker['path']}${sticker_['src']}';
                                      return WidgetSpan(
                                        child: Image.asset(
                                          src,
                                          height: 40,
                                        ),
                                      );
                                    } else {
                                      return TextSpan(
                                        text: e['content'],
                                      );
                                    }
                                  })
                                  .toList()
                                  .cast<InlineSpan>(),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      if (likeFn == null) return;
                                      if (!like.value) {
                                        bool iSlike =
                                            await likeFn!.call(comment['id']);
                                        if (iSlike) {
                                          comment['like'] = true;
                                          like(comment['like']);
                                          if (comment['likes_count'] == null) {
                                            comment['likes_count'] = 1;
                                          } else {
                                            comment['likes_count'] =
                                                comment['likes_count'] + 1;
                                          }
                                          likeCount(comment['likes_count']);
                                        } else {
                                          comment['like'] = false;
                                          like(comment['like']);
                                        }
                                        controller.update();
                                      } else {
                                        if (cancelLikeFn == null) return;
                                        bool iSlike = await cancelLikeFn!
                                            .call(comment['id']);
                                        if (iSlike) {
                                          comment['like'] = false;
                                          like(comment['like']);
                                          if (comment['likes_count'] == null) {
                                            comment['likes_count'] = 0;
                                          } else {
                                            comment['likes_count'] =
                                                comment['likes_count'] - 1;
                                          }
                                          likeCount(comment['likes_count']);
                                        } else {
                                          comment['like'] = true;
                                          like(comment['like']);
                                        }
                                        controller.update();
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.thumb_up,
                                            size: 14,
                                            color: like.value
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : null,
                                          ),
                                          Text(
                                            likeCount.value > 0
                                                ? '$likeCount'
                                                : '点赞',
                                            style: TextStyle(
                                              color: like.value
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : null,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      if (replyFn == null) return;
                                      replyFn!.call();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.reply,
                                            size: 14,
                                          ),
                                          Text('回复')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          if (repliesPreview) ...[
                            const SizedBox(height: 5),
                            RepliesPreview(comment,
                                controller: controller,
                                replyFn: replyFn,
                                likeFn: likeFn,
                                cancelLikeFn: cancelLikeFn),
                          ],
                          const SizedBox(height: 5),
                        ],
                      ),
                    )
                  ],
                ),
                AppStyle.divider
              ],
            ),
          ),
        ),
      );
    });
  }
}
