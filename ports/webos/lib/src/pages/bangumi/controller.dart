import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/src/apis/bangumi.dart';
import 'package:xs/src/utils/platform_info.dart';

class BangumiController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('最近更新'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('推荐'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('索引'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('分类'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('标签'),
      ),
    ),
  ];

  late TabController tabController;
  RxInt tabIndex = (PlatformInfo.isWebOS ? 0 : 2).obs;

  late final AnimationController animationController;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
        vsync: this, length: tabs.length, initialIndex: tabIndex.value);
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

class BangumiIndexController extends GetxController
    with StateMixin<List<bangumi_list_item_>> {
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

  @override
  void onInit() {
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
      debugPrint('BangumiIndexController-get');
      change(result, status: RxStatus.loading());
      final response = await BangumiApi.getBangumiList();
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
      debugPrint('BangumiIndexController-filter');
      result.clear();
      change(null, status: RxStatus.loading());
      final response = await BangumiApi.getBangumiList(
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
      debugPrint('BangumiIndexController-more');
      isLoading(true);
      final response = await BangumiApi.getBangumiList(
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
      debugPrint('BangumiIndexController-reload');
      final response = await BangumiApi.getBangumiList(
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

class BangumiGenreController extends GetxController
    with StateMixin<List<Tag>>, GetSingleTickerProviderStateMixin {
  List<Tag> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('BangumiGenreController-get');
      change(result, status: RxStatus.loading());
      final response = await BangumiApi.getTags(type: 'genre');
      List<Tag> tagsList =
          List<Tag>.from(response.data.map((e) => Tag.fromJson(e)));
      result.addAll(tagsList);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }

  // 加载更多
  void more() async {
    try {
      debugPrint('BangumiGenreController-more');
      isLoading(true);
      final response =
          await BangumiApi.getTags(type: 'genre', skip: result.length);
      List<Tag> tagsList =
          List<Tag>.from(response.data.map((e) => Tag.fromJson(e)));
      result.addAll(tagsList);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading(false);
  }

  // 刷新
  Future<bool> reload() async {
    try {
      debugPrint('BangumiGenreController-reload');
      final response = await BangumiApi.getTags(type: 'genre');
      List<Tag> tagsList =
          List<Tag>.from(response.data.map((e) => Tag.fromJson(e)));
      result.clear();
      result.addAll(tagsList);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}

class BangumiMarkController extends GetxController
    with StateMixin<List<Tag>>, GetSingleTickerProviderStateMixin {
  List<Tag> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('BangumiMarkController-get');
      change(result, status: RxStatus.loading());
      final response = await BangumiApi.getTags(type: 'mark');
      List<Tag> tagsList =
          List<Tag>.from(response.data.map((e) => Tag.fromJson(e)));
      result.addAll(tagsList);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }

  // 加载更多
  void more() async {
    try {
      debugPrint('BangumiMarkController-more');
      isLoading(true);
      final response =
          await BangumiApi.getTags(type: 'mark', skip: result.length);
      List<Tag> tagsList =
          List<Tag>.from(response.data.map((e) => Tag.fromJson(e)));
      result.addAll(tagsList);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading(false);
  }

  // 刷新
  Future<bool> reload() async {
    try {
      debugPrint('BangumiMarkController-reload');
      final response = await BangumiApi.getTags(type: 'mark');
      List<Tag> tagsList =
          List<Tag>.from(response.data.map((e) => Tag.fromJson(e)));
      result.clear();
      result.addAll(tagsList);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}

class Tag {
  String? name;
  int? count;
  String? image;

  Tag({
    this.name,
    this.count,
    this.image,
  });
  Tag.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    count = json['count']?.toInt();
    image = json['image']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['count'] = count;
    data['image'] = image;
    return data;
  }
}

class BangumiLatestController extends GetxController
    with StateMixin<List<bangumi_latest_item_>> {
  List<bangumi_latest_item_> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('BangumiLatestController-get');
      change(result, status: RxStatus.loading());
      final response = await BangumiApi.getBangumiLatest();
      final data = bangumi_latest_.fromBuffer(response.data);
      result.addAll(data.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }

  // 刷新
  Future<bool> reload() async {
    try {
      debugPrint('BangumiLatestController-reload');
      final response = await BangumiApi.getBangumiLatest();
      final data = bangumi_latest_.fromBuffer(response.data);
      result.clear();
      result.addAll(data.data);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}
