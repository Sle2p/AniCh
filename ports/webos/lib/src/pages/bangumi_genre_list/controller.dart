import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/src/apis/bangumi.dart';

class BangumiGenreListController extends GetxController
    with StateMixin<List<bangumi_list_item_>>, GetTickerProviderStateMixin {
  RxString genre = ''.obs;
  List<bangumi_list_item_> result = [];
  RxBool isLoading = false.obs;

  Map<String, String> typeList = {
    '': '类型',
    'tv': '正篇',
    'movie': '剧场版',
    'ova': '特别篇'
  };

  Map<String, String> langList = {
    '': '语言',
    'ja': '日语',
    'zh': '国语',
    'en': '英语',
    'ko': '韩语',
    'other': '其他'
  };

  Map<String, String> yearList = {
    '': '年份',
  };

  RxString typeSelect = ''.obs;
  RxString langSelect = ''.obs;
  RxString yearSelect = ''.obs;
  RxString typeSelected = ''.obs;
  RxString langSelected = ''.obs;
  RxString yearSelected = ''.obs;

  late final AnimationController animationController;

  @override
  void onInit() {
    genre(Get.arguments['name']);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // 创建年份
    int currentYear = DateTime.now().year;
    List<String>.generate(35, (i) {
      String year = (currentYear - i).toString();
      yearList[year] = '$year年';
      return year;
    });

    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('BangumiGenreListController-get');
      change(result, status: RxStatus.loading());
      final response = await BangumiApi.getBangumiList(genre: genre);
      final data = bangumi_list_.fromBuffer(response.data);
      result.addAll(data.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }

  // 筛选
  void filter() async {
    try {
      typeSelected(typeSelect.value);
      langSelected(langSelect.value);
      yearSelected(yearSelect.value);
      debugPrint('BangumiGenreListController-filter');
      result.clear();
      change(null, status: RxStatus.loading());
      final response = await BangumiApi.getBangumiList(
          genre: genre,
          type: typeSelected.value,
          lang: langSelected.value,
          year: yearSelected.value);
      final data = bangumi_list_.fromBuffer(response.data);
      result.addAll(data.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
    isLoading(false);
  }

  // 加载更多
  void more() async {
    try {
      debugPrint('BangumiGenreListController-more');
      isLoading(true);
      final response = await BangumiApi.getBangumiList(
          genre: genre,
          type: typeSelected.value,
          lang: langSelected.value,
          year: yearSelected.value,
          skip: result.last.id);
      final data = bangumi_list_.fromBuffer(response.data);
      result.addAll(data.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading(false);
  }

  // 刷新
  Future<bool> reload() async {
    try {
      debugPrint('BangumiGenreListController-reload');
      final response = await BangumiApi.getBangumiList(
          genre: genre,
          type: typeSelected.value,
          lang: langSelected.value,
          year: yearSelected.value);
      final data = bangumi_list_.fromBuffer(response.data);
      result.clear();
      result.addAll(data.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}
