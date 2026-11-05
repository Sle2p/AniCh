import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/protobuf/list.pb.dart';
import 'package:xs/src/apis/search.dart';
import 'package:xs/src/pages/search/models/search_type.dart';

class SearchPageController extends GetxController
    with StateMixin, WidgetsBindingObserver, GetTickerProviderStateMixin {
  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('图片'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('番剧'),
      ),
    ),
  ];

  late TabController tabController;
  RxInt tabIndex = 1.obs;

  late final AnimationController animationController;

  late SearchType searchType;
  RxString keyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    searchType = Get.arguments['type'];
    keyword(Get.arguments['keyword']);

    tabController = TabController(
        vsync: this, length: tabs.length, initialIndex: searchType.index);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class SearchBangumiController extends GetxController
    with StateMixin<List<bangumi_list_item_>> {
  SearchBangumiController(this.keyword);
  List<bangumi_list_item_> result = [];
  RxBool isLoading = false.obs;
  String keyword;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('SearchBangumiController-get');
      change(result, status: RxStatus.loading());
      final response = await SearchApi.searchBangumi(keyword: keyword);
      final data = bangumi_list_.fromBuffer(response.data);
      result.addAll(data.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null,
          status: RxStatus.error(
              e is SearchAuthorizationException ? e.message : '搜索失败，请稍后重试'));
    }
  }

  // 加载更多
  void more() async {
    try {
      debugPrint('SearchBangumiController-more');
      isLoading(true);
      final response =
          await SearchApi.searchBangumi(keyword: keyword, skip: result.last.id);
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
      debugPrint('SearchBangumiController-reload');
      final response = await SearchApi.searchBangumi(keyword: keyword);
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

class SearchPictureController extends GetxController
    with
        StateMixin<List<thread_list_data_>>,
        GetSingleTickerProviderStateMixin {
  SearchPictureController(this.keyword);
  List<thread_list_data_> result = [];
  RxBool isLoading = false.obs;
  String keyword;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('SearchPictureController-get');
      change(result, status: RxStatus.loading());
      final response = await SearchApi.searchPicture(keyword: keyword);
      final data = thread_list_.fromBuffer(response.data);
      result.addAll(data.body.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }

  // 加载更多
  void more() async {
    try {
      debugPrint('SearchPictureController-more');
      isLoading(true);
      final response =
          await SearchApi.searchPicture(keyword: keyword, skip: result.last.id);
      final data = thread_list_.fromBuffer(response.data);
      result.addAll(data.body.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading(false);
  }

  // 刷新
  Future<bool> reload() async {
    try {
      debugPrint('SearchPictureController-reload');
      final response = await SearchApi.searchPicture(keyword: keyword);
      final data = thread_list_.fromBuffer(response.data);
      result.clear();
      result.addAll(data.body.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}
