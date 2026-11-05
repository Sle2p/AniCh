import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/apis/bangumi.dart';
import 'package:xs/src/pages/character/models/character_bangumi_model.dart';
import 'package:xs/src/pages/character/models/character_model.dart';

class CharacterController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  RxInt id = 0.obs;
  Character result = Character();

  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('出演'),
      ),
    ),
  ];

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  late final AnimationController animationController;

  @override
  void onInit() {
    id(Get.arguments['id']);
    getInfo();
    super.onInit();

    tabController =
        TabController(vsync: this, length: tabs.length, initialIndex: 0);
    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  // 获取数据
  void getInfo() async {
    try {
      debugPrint('CharacterController-getInfo');
      change(null, status: RxStatus.loading());
      final response = await BangumiApi.getCharacter(id: id.value);
      final data = Character.fromJson(response.data);
      result = data;
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }
}

class CharacterIndexController extends GetxController
    with StateMixin<List<Data>>, GetSingleTickerProviderStateMixin {
  RxInt id = 0.obs;
  List<Data> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    id(Get.arguments['id']);
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('CharacterIndexController-get');
      change(null, status: RxStatus.loading());
      final response = await BangumiApi.getCharacterBangumi(id: id.value);
      final data = CharacterBangumi.fromJson(response.data);
      result.addAll(data.data as Iterable<Data>);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }

  // 加载更多
  void more() async {
    try {
      debugPrint('CharacterIndexController-more');
      isLoading(true);
      final response = await BangumiApi.getCharacterBangumi(
          id: id.value, skip: result.length);
      final data = CharacterBangumi.fromJson(response.data);
      result.addAll(data.data as Iterable<Data>);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    isLoading(false);
  }

  // 刷新
  Future<bool> reload() async {
    try {
      debugPrint('CharacterIndexController-reload');
      final response = await BangumiApi.getCharacterBangumi(id: id.value);
      final data = CharacterBangumi.fromJson(response.data);
      result.clear();
      result.addAll(data.data as Iterable<Data>);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}
