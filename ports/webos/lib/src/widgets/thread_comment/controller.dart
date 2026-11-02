import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:xs/src/apis/thread.dart';

class CommentController extends GetxController
    with StateMixin, WidgetsBindingObserver, GetTickerProviderStateMixin {
  String id = '';
  RxList comments = [].obs;
  RxBool commentsLoading = true.obs;
  RxList commentReplies = [].obs;
  RxBool commentRepliesLoading = true.obs;

  CommentController(this.id);

  @override
  void onInit() {
    // WidgetsBinding.instance.addObserver(this);
    getComments(id);
    super.onInit();
  }

  // 获取评论列表
  void getComments(id) async {
    try {
      change(null, status: RxStatus.loading());
      comments.clear();
      commentsLoading(true);
      debugPrint('CommentController-getComments');
      final response = await ThreadApi.getComments(id: id);
      if (response.statusCode == 200) {
        comments.addAll(response.data['body']['data'].toList());
        change(comments, status: RxStatus.success());
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
    commentsLoading(false);
  }

  // 评论列表加载更多
  void getMoreComments(id) async {
    try {
      commentsLoading(true);
      debugPrint('CommentController-getMoreComments');
      final response =
          await ThreadApi.getComments(id: id, skip: comments.last['id']);
      if (response.statusCode == 200) {
        comments.addAll(response.data['body']['data'].toList());
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    commentsLoading(false);
  }

  // 发送评论
  void sendComment(json) async {
    try {
      debugPrint('CommentController-sendComment');
      final response = await ThreadApi.postComment(
          id: json['id'], contents: json['contents']);
      if (response.statusCode == 200) {
        comments.insert(0, response.data['body']);
        SmartDialog.showToast('发送成功');
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
      SmartDialog.showToast('发送失败');
    }
  }

  // 回复评论
  Future<Map> replyComment({json, parent, reply}) async {
    try {
      debugPrint('CommentController-replyComment');
      final response = await ThreadApi.postComment(
          id: json['id'],
          parent: parent,
          reply: reply,
          contents: json['contents']);
      if (response.statusCode == 200) {
        // comments.insert(0, response.data['body']);
        SmartDialog.showToast('回复成功');
        return response.data['body'];
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
      SmartDialog.showToast('回复失败');
    }
    return {};
  }

  // 评论点赞
  Future<bool> likeComment(id) async {
    try {
      debugPrint('CommentController-likeComment');
      final response = await ThreadApi.likeComment(id: id);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  // 评论取消点赞
  Future<bool> cancelLikeComment(id) async {
    try {
      debugPrint('CommentController-cancelLikeComment');
      final response = await ThreadApi.cancelLikeComment(id: id);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  // 获取评论回复列表
  void getCommentReplies(id) async {
    try {
      commentReplies.clear();
      commentRepliesLoading(true);
      debugPrint('CommentController-getCommentReplies');
      final response = await ThreadApi.getCommentReplies(id: id);
      if (response.statusCode == 200) {
        commentReplies.addAll(response.data['body']['data'].toList());
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    commentRepliesLoading(false);
  }

  // 评论回复加载更多
  void getMoreCommentReplies(id) async {
    try {
      commentRepliesLoading(true);
      debugPrint('CommentController-getMoreCommentReplies');
      final response = await ThreadApi.getCommentReplies(
          id: id, skip: commentReplies.last['id']);
      if (response.statusCode == 200) {
        commentReplies.addAll(response.data['body']['data'].toList());
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    commentRepliesLoading(false);
  }
}
