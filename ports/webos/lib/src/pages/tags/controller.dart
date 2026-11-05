import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/list.pb.dart';
import 'package:xs/src/apis/tags.dart';

class TagsController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  RxString tag = ''.obs;
  tag_info_body_ result = tag_info_body_();

  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('综合'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('插画'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('COSPLAY'),
      ),
    ),
  ];

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  late final AnimationController animationController;

  @override
  void onInit() {
    tag(Get.arguments['tag']);
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
      debugPrint('TagsController-getInfo');
      change(result, status: RxStatus.loading());
      final response =
          await TagsApi.getInfo(tag: Uri.encodeComponent(tag.value));
      final data = tag_info_.fromBuffer(response.data);
      result = data.body;
      change(result, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }
}

class TagsAllController extends GetxController
    with
        StateMixin<List<thread_list_data_>>,
        GetSingleTickerProviderStateMixin {
  RxString tag = ''.obs;
  List<thread_list_data_> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    tag(Get.arguments['tag']);
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('TagsAllController-get');
      change(result, status: RxStatus.loading());
      final response =
          await TagsApi.getList(tag: tag.value, type: 'all', sort: -1);
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
      debugPrint('TagsAllController-more');
      isLoading(true);
      final response = await TagsApi.getList(
          tag: tag.value, type: 'all', sort: -1, skip: result.last.id);
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
      debugPrint('TagsAllController-reload');
      final response =
          await TagsApi.getList(tag: tag.value, type: 'all', sort: -1);
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

class TagsArtworkController extends GetxController
    with
        StateMixin<List<thread_list_data_>>,
        GetSingleTickerProviderStateMixin {
  RxString tag = ''.obs;
  List<thread_list_data_> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    tag(Get.arguments['tag']);
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('TagsArtworkController-get');
      change(result, status: RxStatus.loading());
      final response =
          await TagsApi.getList(tag: tag.value, type: 'artwork', sort: -1);
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
      debugPrint('TagsArtworkController-more');
      isLoading(true);
      final response = await TagsApi.getList(
          tag: tag.value, type: 'artwork', sort: -1, skip: result.last.id);
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
      debugPrint('TagsArtworkController-reload');
      final response =
          await TagsApi.getList(tag: tag.value, type: 'artwork', sort: -1);
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

class TagsCosplayController extends GetxController
    with
        StateMixin<List<thread_list_data_>>,
        GetSingleTickerProviderStateMixin {
  RxString tag = ''.obs;
  List<thread_list_data_> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    tag(Get.arguments['tag']);
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('TagsCosplayController-get');
      change(result, status: RxStatus.loading());
      final response =
          await TagsApi.getList(tag: tag.value, type: 'cosplay', sort: -1);
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
      debugPrint('TagsCosplayController-more');
      isLoading(true);
      final response = await TagsApi.getList(
          tag: tag.value, type: 'cosplay', sort: -1, skip: result.last.id);
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
      debugPrint('TagsCosplayController-reload');
      final response =
          await TagsApi.getList(tag: tag.value, type: 'cosplay', sort: -1);
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
