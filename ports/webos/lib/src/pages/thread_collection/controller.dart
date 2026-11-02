import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/apis/thread.dart';
import 'package:xs/src/pages/thread_collection/models/thread_collection_model.dart';

class ThreadCollectionController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
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

typedef CollectionPageLoader = Future<ThreadCollection> Function(
    String type, int page);

abstract class ThreadCollectionPageController extends GetxController
    with StateMixin<List<Data>> {
  ThreadCollectionPageController(this.collectionType,
      {CollectionPageLoader? loadPage})
      : _loadPage = loadPage ?? _fetchPage;

  final String collectionType;
  final CollectionPageLoader _loadPage;
  final List<Data> result = [];
  final RxBool isLoading = false.obs;
  // Last successfully loaded page; `next` in the API model is only a boolean.
  final RxInt page = 0.obs;
  final RxBool hasMore = false.obs;
  int _request = 0;

  static Future<ThreadCollection> _fetchPage(String type, int page) async {
    final response = await ThreadApi.getCollect(type: type, page: page);
    return ThreadCollection.fromJson(response.data);
  }

  @override
  void onInit() {
    super.onInit();
    get();
  }

  @override
  void onClose() {
    _request++;
    super.onClose();
  }

  Future<void> get() async {
    await _loadFirst(showLoading: true);
  }

  Future<bool> reload() => _loadFirst(showLoading: false);

  Future<bool> _loadFirst({required bool showLoading}) async {
    final request = ++_request;
    isLoading(true);
    if (showLoading) change(null, status: RxStatus.loading());
    try {
      final data = await _loadPage(collectionType, 1);
      if (request != _request) return false;
      _acceptPage(data, requestedPage: 1, replace: true);
      return true;
    } catch (error) {
      if (request != _request) return false;
      debugPrint('$collectionType collection: $error');
      if (showLoading || result.isEmpty) {
        change(null, status: RxStatus.error('图片收藏加载失败，请稍后重试'));
      }
      return false;
    } finally {
      if (request == _request) isLoading(false);
    }
  }

  Future<void> more() async {
    if (isLoading.value || !hasMore.value) return;
    final request = ++_request;
    final requestedPage = page.value + 1;
    isLoading(true);
    try {
      final data = await _loadPage(collectionType, requestedPage);
      if (request != _request) return;
      _acceptPage(data, requestedPage: requestedPage, replace: false);
    } catch (error) {
      if (request == _request) {
        // Keep the last successful page so the same next page can be retried.
        debugPrint('$collectionType collection: $error');
      }
    } finally {
      if (request == _request) isLoading(false);
    }
  }

  void _acceptPage(ThreadCollection data,
      {required int requestedPage, required bool replace}) {
    final body = data.body;
    if (data.error == true || body == null) {
      throw FormatException(data.message ?? 'Invalid collection response');
    }
    if (replace) result.clear();
    result.addAll(body.data ?? <Data>[]);
    page(body.page ?? requestedPage);
    hasMore(body.next == true);
    change(List<Data>.of(result), status: RxStatus.success());
  }
}

class ThreadAllCollectionController extends ThreadCollectionPageController {
  ThreadAllCollectionController({super.loadPage}) : super('');
}

class ThreadArtworkCollectionController extends ThreadCollectionPageController {
  ThreadArtworkCollectionController({super.loadPage}) : super('artwork');
}

class ThreadCosplayCollectionController extends ThreadCollectionPageController {
  ThreadCosplayCollectionController({super.loadPage}) : super('cosplay');
}
