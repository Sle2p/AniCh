import 'dart:io';

import 'package:dio/dio.dart';
import 'package:xs/src/config.dart';

final api = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua}));

class HomeApi {
  // 最新
  static Future<Response> getThreadList(
      {int sort = -1, type = 'all', int skip = 0}) async {
    const url = '/latest';
    final response = await api.get(url,
        queryParameters: {'sort': sort, 'type': type, 'skip': skip},
        options: Options(responseType: ResponseType.bytes));
    return response;
  }

  // 标签
  static Future<Response> getTags({int skip = 0}) async {
    const url = '/tags';
    final response = await api.get(url,
        queryParameters: {'skip': skip},
        options: Options(responseType: ResponseType.json));
    return response;
  }
}
