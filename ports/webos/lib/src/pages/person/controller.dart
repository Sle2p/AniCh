import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/apis/bangumi.dart';
import 'package:xs/src/pages/person/models/person_bangumi_model.dart';
import 'package:xs/src/pages/person/models/person_model.dart';

class PersonController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  RxInt id = 0.obs;
  Person result = Person();

  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('参与'),
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
      debugPrint('PersonController-getInfo');
      change(null, status: RxStatus.loading());
      final response = await BangumiApi.getPerson(id: id.value);
      final data = Person.fromJson(response.data);
      result = data;
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }
}

class PersonIndexController extends GetxController
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
      debugPrint('PersonIndexController-get');
      change(null, status: RxStatus.loading());
      final response = await BangumiApi.getPersonsBangumi(id: id.value);
      final data = PersonBangumi.fromJson(response.data);
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
      debugPrint('PersonIndexController-more');
      isLoading(true);
      final response =
          await BangumiApi.getPersonsBangumi(id: id.value, skip: result.length);
      final data = PersonBangumi.fromJson(response.data);
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
      debugPrint('PersonIndexController-reload');
      final response = await BangumiApi.getPersonsBangumi(id: id.value);
      final data = PersonBangumi.fromJson(response.data);
      result.clear();
      result.addAll(data.data as Iterable<Data>);
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
    return true;
  }
}
