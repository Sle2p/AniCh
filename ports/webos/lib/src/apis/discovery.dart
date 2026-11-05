import 'dart:io';

import 'package:dio/dio.dart';
import 'package:xs/src/config.dart';
import 'package:xs/src/pages/bangumi/models/discovery_models.dart';

/// Public discovery endpoints used by the current AniCh client.
class DiscoveryApi {
  static final Dio _api = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 12),
    receiveTimeout: const Duration(seconds: 20),
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua.value},
    responseType: ResponseType.json,
  ));

  static Future<BangumiRecommendations> recommendations() async {
    final response = await _api.get('/bangumi/recommend');
    return BangumiRecommendations.fromJson(response.data);
  }

  static Future<List<BangumiCalendarDay>> calendar() async {
    final response = await _api.get('/bangumi/calendar');
    final json = discoveryObject(response.data);
    return discoveryList(json['data'])
        .map(BangumiCalendarDay.fromJson)
        .toList();
  }

  static Future<List<SearchTrend>> searchTrends() async {
    final response = await _api.get('/bangumi/search_trends');
    final json = discoveryObject(response.data);
    return discoveryList(json['data'])
        .map(SearchTrend.fromJson)
        .where((trend) => trend.value.trim().isNotEmpty)
        .toList();
  }
}
