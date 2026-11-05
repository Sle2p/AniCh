import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/config.dart';
import 'package:xs/src/utils/account.dart';

final api = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua}));
final bilibiliApiProxy =
    Dio(BaseOptions(baseUrl: AppConfig.bilibiliApiProxyUrl));
final qqVideoApi = Dio(BaseOptions(baseUrl: AppConfig.qqVideoApiUrl));

final box = GetStorage();

class BangumiApi {
  // 索引
  static Future<Response> getBangumiList(
      {int skip = 0, type, lang, year, genre, mark}) async {
    const url = '/bangumi/list';
    final response = await api.get(url,
        queryParameters: {
          'skip': skip,
          'type': type,
          'lang': lang,
          'year': year,
          'genre': genre,
          'mark': mark
        },
        options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 标签
  static Future<Response> getTags({type = 'genre', int skip = 0}) async {
    const url = '/bangumi/tag';
    final response = await api.get(url,
        queryParameters: {'type': type, 'skip': skip},
        options: Options(responseType: ResponseType.json));
    return response;
  }

  // 最新
  static Future<Response> getBangumiLatest() async {
    const url = '/bangumi/latest';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 番剧详情
  static Future<Response> getBangumiDetail({required int id}) async {
    final url = '/bangumi/detail/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.json));
    return response;
  }

  // 剧集
  static Future<Response> getBangumiEpisodes({required int id}) async {
    final url = '/bangumi/episodes/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 相关推荐
  static Future<Response> getBangumiRelated({required int id}) async {
    final url = '/bangumi/related/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 视频
  static Future<Response> getBangumiEpisodeVod(
      {required int id, required int episode}) async {
    final url = '/vod/$id/$episode';
    final response = await api.get(url);
    return response;
  }

  // 弹幕
  static Future<Response> postDanmaku(
      {required int id,
      required int episode,
      required int type,
      required double time,
      required String text,
      required String color}) async {
    const url = '/danmaku';
    final response = await api.post(url,
        queryParameters: {'bangumi': id, 'episode': episode},
        data: {'text': text, 'type': type, 'time': time, 'color': color},
        options: Options(headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 弹幕
  static Future<Response> getDanmaku(
      {required int id, required int episode, required int skip}) async {
    const url = '/danmaku';
    final response = await api.get(url,
        queryParameters: {'bangumi': id, 'episode': episode, 'skip': skip},
        options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 哔哩哔哩弹幕
  static Future<Response> getBilibiliDanmaku(
      {required int type, required int oid, required int segmentIndex}) async {
    const url = '/';
    final response = await bilibiliApiProxy.get(url,
        queryParameters: {
          'type': type,
          'oid': oid,
          'segment_index': segmentIndex
        },
        options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 腾讯视频弹幕
  static Future<Response> getQQDanmaku(
      {required String id, required int page}) async {
    String vid = id.split('/').last;
    int num = 30000;
    final url = '/barrage/segment/$vid/t/v1/${num * (page - 1)}/${num * page}';
    final response = await qqVideoApi.get(url,
        options: Options(responseType: ResponseType.json));
    return response;
  }

  // 收藏状态
  static Future<Response> collectStatus({required int id}) async {
    final url = '/bangumi/$id/collect/status';
    final response = await api.get(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 取消收藏
  static Future<Response> cancelCollect({required int id}) async {
    final url = '/bangumi/$id/collect/cancel';
    final response = await api.delete(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 收藏
  static Future<Response> changeCollect(
      {required int id, required String type}) async {
    final url = '/bangumi/$id/collect/$type';
    final response = await api.get(url,
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 收藏列表
  static Future<Response> getCollect(
      {required int page, required String type}) async {
    final url = '/action/collect/$type';
    final response = await api.get(url,
        queryParameters: {'page': page},
        options: Options(
            responseType: ResponseType.json,
            headers: {'_': AccountUtil.token()}));
    return response;
  }

  // 评论列表
  static Future<Response> getComments({required String id, skip}) async {
    const url = '/comment';
    final response = await api.get(url,
        queryParameters: {'type': 'bangumi_episode', 'id': id, 'skip': skip},
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
          'type': 'bangumi_episode',
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

  // 获取角色列表
  static Future<Response> getCharacters({
    required id,
  }) async {
    final url = '/bangumi/characters/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 获取角色
  static Future<Response> getCharacter({
    required id,
  }) async {
    final url = '/bangumi/character/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.json));
    return response;
  }

  // 获取角色的作品
  static Future<Response> getCharacterBangumi({required id, skip}) async {
    final url = '/bangumi/character/$id/bangumi';
    final response = await api.get(url,
        queryParameters: {'skip': skip},
        options: Options(responseType: ResponseType.json));
    return response;
  }

  // 获取制作人员列表
  static Future<Response> getPersons({
    required id,
  }) async {
    final url = '/bangumi/persons/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 获取人物
  static Future<Response> getPerson({
    required id,
  }) async {
    final url = '/bangumi/person/$id';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.json));
    return response;
  }

  // 获取人物的作品
  static Future<Response> getPersonsBangumi({required id, skip}) async {
    final url = '/bangumi/person/$id/bangumi';
    final response = await api.get(url,
        queryParameters: {'skip': skip},
        options: Options(responseType: ResponseType.json));
    return response;
  }
}
