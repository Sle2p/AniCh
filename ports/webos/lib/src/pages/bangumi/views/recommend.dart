import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/apis/discovery.dart';
import 'package:xs/src/pages/bangumi/models/discovery_models.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class BangumiRecommendView extends StatefulWidget {
  const BangumiRecommendView({super.key, this.active = false});

  final bool active;

  @override
  State<BangumiRecommendView> createState() => _BangumiRecommendViewState();
}

class _BangumiRecommendViewState extends State<BangumiRecommendView>
    with AutomaticKeepAliveClientMixin {
  late Future<BangumiRecommendations> _recommendations;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _recommendations = DiscoveryApi.recommendations();
  }

  Future<void> _reload() async {
    final request = DiscoveryApi.recommendations();
    setState(() => _recommendations = request);
    try {
      await request;
    } catch (_) {
      // FutureBuilder presents the error and keeps the retry action available.
    }
  }

  void _open(DiscoveryBangumi item) {
    Get.toNamed('/bangumi/${item.id}', arguments: item.toListItem());
  }

  Widget _image(DiscoveryBangumi item) => item.image.isEmpty
      ? const Center(child: Icon(Icons.image_not_supported_outlined))
      : Image.network(
          item.image,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          cacheWidth: 480,
          errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.image_not_supported_outlined)),
          loadingBuilder: (_, child, progress) => progress == null
              ? child
              : const Center(child: CircularProgressIndicator()),
        );

  Widget _retry(String message) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(message),
          const SizedBox(height: 16),
          TvFocusableAction(
            focusEnabled: widget.active,
            label: '重新加载推荐',
            onTap: _reload,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('重新加载'),
            ),
          ),
        ]),
      );

  Widget _poster(DiscoveryBangumi item) => TvFocusableAction(
        focusEnabled: widget.active,
        label: item.title,
        onTap: () => _open(item),
        child: Card(
          margin: const EdgeInsets.all(3),
          clipBehavior: Clip.antiAlias,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _image(item)),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: TvFocusableAction.isTV ? 18 : 15)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Text(
                item.episode > 0
                    ? '${item.status == 'finale' ? '全' : '更新至'} ${item.episode} 集'
                    : item.tagline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ]),
        ),
      );

  Widget _featured(DiscoveryBangumi item) => SizedBox(
        width: TvFocusableAction.isTV ? 560 : 360,
        child: TvFocusableAction(
          focusEnabled: widget.active,
          label: item.title,
          onTap: () => _open(item),
          child: Card(
            margin: const EdgeInsets.all(4),
            clipBehavior: Clip.antiAlias,
            child: Row(children: [
              SizedBox(width: 150, child: _image(item)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text(item.overview,
                          maxLines: 4, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<BangumiRecommendations>(
      future: _recommendations,
      builder: (context, snapshot) => RefreshIndicator(
        onRefresh: _reload,
        child: CustomScrollView(
          key: const PageStorageKey('bangumi-recommend'),
          primary: widget.active,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            if (snapshot.connectionState != ConnectionState.done)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (snapshot.hasError)
              SliverFillRemaining(
                  hasScrollBody: false, child: _retry('推荐加载失败，请重试'))
            else if (!snapshot.hasData || snapshot.data!.isEmpty)
              SliverFillRemaining(hasScrollBody: false, child: _retry('暂无推荐内容'))
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(children: [
                    Expanded(
                        child: Text('发现番剧',
                            style: Theme.of(context).textTheme.titleLarge)),
                    TvFocusableAction(
                      focusEnabled: widget.active,
                      label: '刷新推荐',
                      onTap: _reload,
                      child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.refresh)),
                    ),
                  ]),
                ),
              ),
              if (snapshot.data!.carousel.isNotEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 240,
                    child: ListView.separated(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: snapshot.data!.carousel.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, index) =>
                          _featured(snapshot.data!.carousel[index]),
                    ),
                  ),
                ),
              for (final section in snapshot.data!.sections)
                if (section.items.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Text(section.title,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: TvFocusableAction.isTV ? 240 : 180,
                        childAspectRatio: 0.62,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: section.items.length,
                      itemBuilder: (_, index) => _poster(section.items[index]),
                    ),
                  ),
                ],
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ],
        ),
      ),
    );
  }
}
