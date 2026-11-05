import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/search_panel/controller.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/apis/discovery.dart';
import 'package:xs/src/pages/bangumi/models/discovery_models.dart';
import 'package:xs/src/pages/search/models/search_type.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class SearchPanelPage extends StatefulWidget {
  const SearchPanelPage({super.key});

  @override
  State<SearchPanelPage> createState() => _SearchPanelPageState();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
}

class _SearchPanelPageState extends State<SearchPanelPage> with RouteAware {
  final SearchPanelController _searchController =
      Get.put(SearchPanelController());
  Future<List<SearchTrend>>? _trends;

  @override
  void initState() {
    super.initState();
    if (_searchController.searchType == SearchType.bangumi) {
      _trends = DiscoveryApi.searchTrends();
    }
  }

  @override
  // 返回当前页面时
  void didPopNext() async {
    _searchController.searchFocusNode.requestFocus();
    super.didPopNext();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SearchPanelPage.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomDragToMoveArea(
              child: AppBar(
            shape: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.08),
                width: 1,
              ),
            ),
            titleSpacing: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 22,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _searchController.submit(),
                icon: const Icon(Icons.search, size: 22),
              ),
              const SizedBox(width: 10)
            ],
            title: Obx(
              () => TextField(
                autofocus: true,
                focusNode: _searchController.searchFocusNode,
                controller: _searchController.controller.value,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: TextInputAction.search,
                style: const TextStyle(textBaseline: TextBaseline.alphabetic),
                onChanged: (value) => _searchController.onChange(value),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: _searchController.hintText,
                  hintStyle:
                      const TextStyle(textBaseline: TextBaseline.alphabetic),
                  border: InputBorder.none,
                  // contentPadding: const EdgeInsets.only(top: 10),
                  contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 22,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    onPressed: () => _searchController.onClear(),
                  ),
                ),
                onSubmitted: (String value) => _searchController.submit(),
              ),
            ),
          ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text('搜索记录',
                              style: Theme.of(context).textTheme.titleLarge)),
                      TextButton.icon(
                        onPressed: _searchController.historyList.isEmpty
                            ? null
                            : _searchController.clearHistory,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('清空记录'),
                      ),
                    ]),
                    if (_searchController.historyList.isEmpty)
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('暂无搜索记录'))
                    else
                      Wrap(spacing: 12, runSpacing: 12, children: [
                        for (final keyword in _searchController.historyList)
                          TvFocusableAction(
                            label: keyword,
                            onTap: () =>
                                _searchController.onClickKeyword(keyword),
                            child: Chip(label: Text(keyword)),
                          ),
                      ]),
                  ],
                )),
            const SizedBox(height: 24),
            if (_trends != null)
              FutureBuilder<List<SearchTrend>>(
                future: _trends,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('热搜暂时无法加载，仍可输入关键词搜索'),
                        TextButton(
                            onPressed: () => setState(() {
                                  _trends = DiscoveryApi.searchTrends();
                                }),
                            child: const Text('重试')),
                      ],
                    ));
                  }
                  final trends = snapshot.data ?? const <SearchTrend>[];
                  if (trends.isEmpty) {
                    return const Center(child: Text('暂无热搜，请输入关键词搜索'));
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('热搜', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      for (var index = 0; index < trends.length; index++)
                        TvFocusableAction(
                          label: trends[index].value,
                          onTap: () => _searchController
                              .onClickKeyword(trends[index].value),
                          child: ListTile(
                            leading: Text('${index + 1}'),
                            title: Text(trends[index].value),
                            trailing: Text('${trends[index].count}'),
                          ),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
