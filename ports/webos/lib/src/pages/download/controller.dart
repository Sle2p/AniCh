import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadPageController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('正在下载'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('下载完成'),
      ),
    )
  ];

  late TabController tabController;
  RxInt tabIndex = 0.obs;

  late final AnimationController animationController;

  @override
  void onInit() {
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

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
