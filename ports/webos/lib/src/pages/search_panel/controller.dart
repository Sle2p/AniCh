import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/search/models/search_type.dart';
import 'package:xs/src/pages/search_panel/history_storage.dart';

class SearchPanelController extends GetxController
    with StateMixin, WidgetsBindingObserver, GetTickerProviderStateMixin {
  final FocusNode searchFocusNode = FocusNode();
  Rx<TextEditingController> controller = TextEditingController().obs;
  RxString searchKeyWord = ''.obs;
  String hintText = '搜索';
  final historyStorage = SearchHistoryStorage();
  final RxList<String> historyList = <String>[].obs;
  SearchType searchType = SearchType.picture;

  @override
  void onInit() {
    super.onInit();
    searchType = Get.arguments['type']!;
    historyList.assignAll(historyStorage.load(searchType));
    // 其他页面跳转过来
    if (Get.parameters.keys.isNotEmpty) {
      if (Get.parameters['keyword'] != null) {
        onClickKeyword(Get.parameters['keyword']!);
      }
      if (Get.parameters['hintText'] != null) {
        hintText = Get.parameters['hintText']!;
        searchKeyWord.value = hintText;
      }
    }
  }

  // 搜索
  Future<void> submit() async {
    final keyword = searchKeyWord.value.trim();
    if (keyword.isEmpty) {
      return;
    }
    searchKeyWord.value = keyword;
    historyList.assignAll(await historyStorage.remember(searchType, keyword));
    searchFocusNode.unfocus();
    Get.offAndToNamed(
      '/search',
      arguments: {'type': searchType, 'keyword': searchKeyWord.value},
      // parameters: {'type': 'bangumi', 'keyword': searchKeyWord.value}
    );
  }

  Future<void> clearHistory() async {
    await historyStorage.clear(searchType);
    historyList.clear();
  }

  // 点击热搜关键词
  void onClickKeyword(String keyword) {
    searchKeyWord.value = keyword;
    controller.value.text = keyword;
    // 移动光标
    controller.value.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.value.text.length),
    );
    submit();
  }

  void onChange(value) {
    searchKeyWord.value = value;
    if (value == '') {
      // searchSuggestList.value = [];
      return;
    }
    // _debouncer.call(() => querySearchSuggest(value));
  }

  void onClear() {
    if (searchKeyWord.value.isNotEmpty && controller.value.text != '') {
      controller.value.clear();
      searchKeyWord.value = '';
      // searchSuggestList.value = [];
    } else {
      Get.back();
    }
  }
}
