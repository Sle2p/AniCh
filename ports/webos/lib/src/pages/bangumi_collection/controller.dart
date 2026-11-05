import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/apis/bangumi.dart';
import 'package:xs/src/pages/bangumi_collection/models/bangumi_collection_model.dart';

class BangumiCollectionController extends GetxController
    with StateMixin, GetTickerProviderStateMixin {
  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('我想看的'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('我在看的'),
      ),
    ),
    const Tab(
      child: Align(
        alignment: Alignment.center,
        child: Text('我看过的'),
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

typedef CollectionPageLoader = Future<BangumiCollection> Function(
    String type, int page);

abstract class BangumiCollectionPageController extends GetxController
    with StateMixin<List<Data>> {
  BangumiCollectionPageController(this.collectionType,
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

  static Future<BangumiCollection> _fetchPage(String type, int page) async {
    final response = await BangumiApi.getCollect(type: type, page: page);
    return BangumiCollection.fromJson(response.data);
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
        change(null, status: RxStatus.error('追番列表加载失败，请稍后重试'));
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

  void _acceptPage(BangumiCollection data,
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

class BangumiWishCollectionController extends BangumiCollectionPageController {
  BangumiWishCollectionController({super.loadPage}) : super('wish');
}

class BangumiWatchCollectionController extends BangumiCollectionPageController {
  BangumiWatchCollectionController({super.loadPage}) : super('watch');
}

class BangumiWatchedCollectionController
    extends BangumiCollectionPageController {
  BangumiWatchedCollectionController({super.loadPage}) : super('watched');
}
