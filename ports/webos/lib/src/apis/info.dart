import 'dart:io';

import 'package:dio/dio.dart';
import 'package:xs/src/config.dart';

final api = Dio(BaseOptions(
    // baseUrl: AppConfig.baseUrl,
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua}));

class InfoApi {
  // 最新
  static Future<Response> checkUpdate() async {
    const url = 'https://api.github.com/repos/Sle2p/xs.cx/releases/latest';
    final response =
        await api.get(url, options: Options(responseType: ResponseType.json));
    return response;
  }
}
