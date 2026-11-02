import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/bangumi_vod_comment/comment_item.dart';
import 'package:xs/src/widgets/bangumi_vod_comment/controller.dart';
import 'package:xs/src/widgets/bangumi_vod_comment/reply_item.dart';
import 'package:xs/src/widgets/sticker.dart';

class RepliesPreview extends StatelessWidget {
  final Map comment;
  final CommentController controller;
  final Function()? replyFn;
  final Function(String id)? likeFn;
  final Function(String id)? cancelLikeFn;
  const RepliesPreview(this.comment,
      {super.key,
      this.replyFn,
      this.likeFn,
      this.cancelLikeFn,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    final replies = comment['replies'];
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Material(
          child: Container(
            color: Theme.of(context).highlightColor.withAlpha(50),
            child: Column(
              children: [
                ...replies
                    .map(
                      (e) {
                        e['contents'].last['content'] = e['contents']
                            .last['content']
                            .replaceAll(RegExp('\n\$'), '');
                        return InkWell(
                          onTap: () {
                            showRepliesList(context, controller);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16, height: 0),
                                    children: [
                                      TextSpan(
                                          text: e['user']['name'],
                                          style: TextStyle(
                                              height: 0,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                      const TextSpan(
                                          text: ': ',
                                          style: TextStyle(height: 0)),
                                      ...e['contents']
                                          .map(
                                            (e) {
                                              if (e['type'] == 'sticker') {
                                                final sticker_ = sticker['list']
                                                    .firstWhere((i) =>
                                                        i['text'] ==
                                                        e['content']);
                                                final String src =
                                                    '${sticker['path']}${sticker_['src']}';
                                                return WidgetSpan(
                                                  style: const TextStyle(
                                                      height: 0),
                                                  child: Image.asset(
                                                    src,
                                                    height: 40,
                                                  ),
                                                );
                                              } else {
                                                return TextSpan(
                                                  text: e['content'],
                                                  style: const TextStyle(
                                                      height: 0),
                                                );
                                              }
                                            },
                                          )
                                          .toList()
                                          .cast<InlineSpan>()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    .toList()
                    .cast<Widget>(),
                if (comment['replies_count'] != null &&
                    comment['replies_count'] > 5)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showRepliesList(context, controller);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          '共${comment['replies_count']}条回复',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showRepliesList(
      BuildContext context, CommentController controller) async {
    controller.getCommentReplies(comment['id']);
    Utils.showBottomSheet(
      title: '评论详情',
      scrollControlDisabledMaxHeightRatio: 0.6,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Obx(() {
              return Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CommentItem(
                      comment,
                      controller: controller,
                      repliesPreview: false,
                      replyFn: () {
                        replyFn?.call();
                      },
                      likeFn: likeFn,
                      cancelLikeFn: cancelLikeFn,
                    ),
                    Container(
                      height: 5,
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Text('相关回复共${comment['replies_count']}条'),
                    ),
                    AppStyle.divider,
                    ...controller.commentReplies.map(
                      (reply) {
                        return ReplyItem(
                          reply,
                          comment: comment,
                          controller: controller,
                        );
                      },
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
