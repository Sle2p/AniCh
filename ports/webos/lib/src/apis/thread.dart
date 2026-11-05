import 'dart:io';

import 'package:dio/dio.dart';
import 'package:xs/src/config.dart';
import 'package:xs/src/utils/account.dart';

final api = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua}));

class ThreadApi {
  static Future<Response> getData({int id = 1}) async {
    final url = '/r/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 收藏列表
  static Future<Response> getCollect(
      {required int page, String type = ''}) async {
    final url = '/action/collects/$type';
    final response = await api.get(url,
        queryParameters: {'page': page},
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 收藏状态
  static Future<Response> collectStatus({required int id}) async {
    final url = '/r/$id/collect/status';
    final response = await api.get(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 收藏
  static Future<Response> collect({required int id}) async {
    final url = '/r/$id/collect';
    final response = await api.get(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 取消收藏
  static Future<Response> cancelCollect({required int id}) async {
    final url = '/r/$id/collect/cancel';
    final response = await api.delete(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 喜欢状态
  static Future<Response> likeStatus({required int id}) async {
    final url = '/r/$id/like/status';
    final response = await api.get(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 喜欢
  static Future<Response> like({required int id}) async {
    final url = '/r/$id/like';
    final response = await api.get(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 取消喜欢
  static Future<Response> cancelLike({required int id}) async {
    final url = '/r/$id/like/cancel';
    final response = await api.delete(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 评论列表
  static Future<Response> getComments({required String id, skip}) async {
    const url = '/comment';
    final response = await api.get(url,
        queryParameters: {'type': 'thread', 'id': id, 'skip': skip},
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 发送评论列表
  static Future<Response> postComment(
      {required String id,
      String? parent,
      String? reply,
      required List contents}) async {
    const url = '/comment';
    final response = await api.post(url,
        data: {
          'type': 'thread',
          'id': id,
          'parent': parent,
          'reply': reply,
          'contents': contents
        },
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 评论回复列表
  static Future<Response> getCommentReplies({required String id, skip}) async {
    final url = '/comment/$id/replies';
    final response = await api.get(url,
        queryParameters: {'skip': skip},
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 评论点赞
  static Future<Response> likeComment({
    required String id,
  }) async {
    const url = '/comment/like';
    final response = await api.get(url,
        queryParameters: {'id': id},
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 评论取消点赞
  static Future<Response> cancelLikeComment({
    required String id,
  }) async {
    const url = '/comment/like';
    final response = await api.delete(url,
        queryParameters: {'id': id},
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }
}
