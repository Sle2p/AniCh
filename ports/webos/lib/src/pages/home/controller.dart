import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/protobuf/list.pb.dart';
import 'package:xs/src/apis/home.dart';

class HomeController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('标签'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('最新'),
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
  RxInt tabIndex = 1.obs;

  late final AnimationController animationController;

  @override
  void onInit() {
    super.onInit();

    tabController =
        TabController(vsync: this, length: tabs.length, initialIndex: 1);
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

class HomeAllController extends GetxController
    with
        StateMixin<List<thread_list_data_>>,
        GetSingleTickerProviderStateMixin {
  List<thread_list_data_> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('HomeAllController-get');
      change(result, status: RxStatus.loading());
      final response = await HomeApi.getThreadList();
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
      debugPrint('HomeAllController-more');
      isLoading(true);
      final response = await HomeApi.getThreadList(skip: result.last.id);
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
      debugPrint('HomeAllController-reload');
      final response = await HomeApi.getThreadList();
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

class HomeArtworkController extends GetxController
    with
        StateMixin<List<thread_list_data_>>,
        GetSingleTickerProviderStateMixin {
  List<thread_list_data_> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('HomeArtworkController-get');
      change(result, status: RxStatus.loading());
      final response = await HomeApi.getThreadList(type: 'artwork');
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
      debugPrint('HomeArtworkController-more');
      isLoading(true);
      final response =
          await HomeApi.getThreadList(type: 'artwork', skip: result.last.id);
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
      debugPrint('HomeArtworkController-reload');
      final response = await HomeApi.getThreadList(type: 'artwork');
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

class HomeCosplayController extends GetxController
    with
        StateMixin<List<thread_list_data_>>,
        GetSingleTickerProviderStateMixin {
  List<thread_list_data_> result = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    get();
    super.onInit();
  }

  // 获取数据
  void get() async {
    try {
      debugPrint('HomeCosplayController-get');
      change(result, status: RxStatus.loading());
      final response = await HomeApi.getThreadList(type: 'cosplay');
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
      debugPrint('HomeCosplayController-more');
      isLoading(true);
      final response =
          await HomeApi.getThreadList(type: 'cosplay', skip: result.last.id);
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
      debugPrint('HomeCosplayController-reload');
      final response = await HomeApi.getThreadList(type: 'cosplay');
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

class HomeTagsController extends GetxController
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
      debugPrint('HomeTagsController-get');
      change(result, status: RxStatus.loading());
      final response = await HomeApi.getTags();
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
      debugPrint('HomeTagsController-more');
      isLoading(true);
      final response = await HomeApi.getTags(skip: result.length);
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
      debugPrint('HomeTagsController-reload');
      final response = await HomeApi.getTags();
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
/*
{
  "name": "少女",
  "translate": "young girl",
  "count": 10933,
  "color": "#cebfd6",
  "image": "https://wework.qpic.cn/wwpic/195707_TozejoaOSIG2Xhy_1694591349"
}
*/

  String? name;
  String? translate;
  int? count;
  String? color;
  String? image;

  Tag({
    this.name,
    this.translate,
    this.count,
    this.color,
    this.image,
  });
  Tag.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    translate = json['translate']?.toString();
    count = json['count']?.toInt();
    color = json['color']?.toString();
    image = json['image']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['translate'] = translate;
    data['count'] = count;
    data['color'] = color;
    data['image'] = image;
    return data;
  }
}
