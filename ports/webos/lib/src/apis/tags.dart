import 'dart:io';

import 'package:dio/dio.dart';
import 'package:xs/src/config.dart';

final api = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua}));

class TagsApi {
  // 最新
  static Future<Response> getInfo({required String tag}) async {
    final url = '/t/$tag/info';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 列表
  static Future<Response> getList(
      {required String tag,
      String type = 'all',
      int sort = -1,
      int skip = 0}) async {
    final url = '/t/$tag';
    final response = await api.get(url,
        queryParameters: {'type': type, 'sort': sort, 'skip': skip},
        options: Options(responseType: ResponseType.bytes));
    return response;
  }
}
