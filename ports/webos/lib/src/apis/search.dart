import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:xs/src/config.dart';
import 'package:xs/src/utils/account.dart';

final api = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua}));

class SearchApi {
  // 搜索图片
  static Future<Response> searchPicture(
      {required String keyword, int skip = 0}) async {
    const url = '/search';
    final response = await api.get(url,
        queryParameters: {'keyword': keyword, 'skip': skip},
        options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 搜索番剧
  static Future<Response> searchBangumi(
      {required String keyword, int skip = 0}) async {
    const url = '/bangumi/search';
    final token = AccountUtil.token();
    try {
      return await api.get(url,
          queryParameters: {'keyword': keyword, 'skip': skip},
          options: Options(
              headers: token.isEmpty ? null : {'_': token},
              responseType: ResponseType.bytes));
    } on DioException catch (error) {
      final data = error.response?.data;
      final message = data is List<int>
          ? utf8.decode(data, allowMalformed: true)
          : data?.toString() ?? '';
      if (message.toLowerCase().contains('unauthorized')) {
        throw SearchAuthorizationException(token.isNotEmpty);
      }
      rethrow;
    }
  }
}

class SearchAuthorizationException implements Exception {
  const SearchAuthorizationException(this.hasLogin);
  final bool hasLogin;

  String get message =>
      hasLogin ? '搜索服务未接受当前登录状态，请重新登录后重试' : '搜索服务需要登录，请先登录 AniCh 账号后重试';

  @override
  String toString() => message;
}
