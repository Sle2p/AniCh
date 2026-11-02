import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/color.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/widgets/sticker.dart';
import 'package:xs/src/widgets/reply.dart';
import 'package:xs/src/widgets/thread_comment/controller.dart';

class ReplyItem extends StatelessWidget {
  final Map reply;
  final Map comment;
  final CommentController controller;
  const ReplyItem(this.reply,
      {super.key, required this.controller, required this.comment});

  @override
  Widget build(BuildContext context) {
    final contents = reply['contents'];
    contents.last['content'] =
        contents.last['content'].replaceAll(RegExp('\n\$'), '');
    RxInt likeCount = 0.obs;
    RxBool like = false.obs;
    if (reply['like'] != null) {
      like(reply['like']);
    }
    if (reply['likes_count'] != null) {
      likeCount(reply['likes_count']);
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
                        color: ColorUtil.fromHex(reply['user']['color']),
                        child: reply['user']?['avatar'] != null
                            ? Image.network(reply['user']['avatar'])
                            : Center(
                                child: Text(
                                  reply['user']['name'].substring(0, 1),
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
                            reply['user']['name'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          Opacity(
                            opacity: 0.6,
                            child: Row(
                              children: [
                                Text(
                                  Time.dateFormat(
                                      DateTime.parse(reply['created'])
                                          .millisecondsSinceEpoch),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                if (reply['to'].isNotEmpty) ...[
                                  const SizedBox(width: 5),
                                  Text(
                                    '回复: @${reply['to']['name']}',
                                    style: const TextStyle(fontSize: 12),
                                  )
                                ]
                              ],
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
                                      if (!like.value) {
                                        bool iSlike = await controller
                                            .likeComment(reply['id']);
                                        if (iSlike) {
                                          like(true);
                                          likeCount(likeCount.value + 1);
                                        } else {
                                          like(false);
                                        }
                                      } else {
                                        bool iSlike = await controller
                                            .cancelLikeComment(reply['id']);
                                        if (iSlike) {
                                          like(false);
                                          likeCount(likeCount.value - 1);
                                        } else {
                                          like(true);
                                        }
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
                                                ? '${likeCount.value}'
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
                                    onTap: () async {
                                      Get.bottomSheet(ReplyNewDialog(
                                        id: controller.id,
                                        sendFn: (json) async {
                                          Get.back();
                                          final data =
                                              await controller.replyComment(
                                                  json: json,
                                                  parent: comment['id'],
                                                  reply: reply['id']);
                                          if (data.isNotEmpty) {
                                            controller.commentReplies.add(data);
                                            controller.update();
                                          }
                                        },
                                      ));
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
