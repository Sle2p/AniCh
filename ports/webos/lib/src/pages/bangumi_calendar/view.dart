import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/apis/discovery.dart';
import 'package:xs/src/pages/bangumi/models/discovery_models.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class BangumiCalendarPage extends StatefulWidget {
  const BangumiCalendarPage({super.key});

  @override
  State<BangumiCalendarPage> createState() => _BangumiCalendarPageState();
}

class _BangumiCalendarPageState extends State<BangumiCalendarPage>
    with SingleTickerProviderStateMixin {
  static const _weekdays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];

  late final TabController _tabController;
  late Future<List<BangumiCalendarDay>> _calendar;
  late final int _today;
  late int _selectedWeekday;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now().weekday % 7;
    _selectedWeekday = _today;
    _tabController = TabController(
      length: _weekdays.length,
      initialIndex: _today,
      vsync: this,
    )..addListener(_onDayChanged);
    _calendar = DiscoveryApi.calendar();
  }

  void _onDayChanged() {
    if (_selectedWeekday == _tabController.index) return;
    setState(() => _selectedWeekday = _tabController.index);
  }

  void _reload() {
    setState(() => _calendar = DiscoveryApi.calendar());
  }

  @override
  void dispose() {
    _tabController.removeListener(_onDayChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('番剧日程'),
        leading: TvFocusableAction(
          label: '返回',
          onTap: () => Get.back(),
          child: const SizedBox(
            width: 56,
            height: 48,
            child: Icon(Icons.arrow_back),
          ),
        ),
        actions: [
          TvFocusableAction(
            label: '刷新日程',
            onTap: _reload,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Icon(Icons.refresh),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            TvTabBar(
              controller: _tabController,
              autofocus: true,
              tabs: List.generate(
                _weekdays.length,
                (day) => Tab(
                  text: '${_weekdays[day]}${day == _today ? ' · 今天' : ''}',
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: FutureBuilder<List<BangumiCalendarDay>>(
                future: _calendar,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return _status(
                      icon: Icons.cloud_off_outlined,
                      title: '日程加载失败',
                      message: '请检查网络连接后重试。',
                    );
                  }
                  final items = (snapshot.data ?? <BangumiCalendarDay>[])
                      .where((day) => day.weekday == _selectedWeekday)
                      .expand((day) => day.items)
                      .toList();
                  if (items.isEmpty) {
                    return _status(
                      icon: Icons.event_available_outlined,
                      title: '${_weekdays[_selectedWeekday]}暂无日程',
                      message: '可以切换其他日期，或稍后刷新。',
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                        child: Text(
                          '${_weekdays[_selectedWeekday]} · ${items.length} 部番剧'
                          ' · 播出时间为本地时间',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          key: PageStorageKey(
                            'anich-bangumi-calendar-$_selectedWeekday',
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                          itemCount: items.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) => Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1320),
                              child: _CalendarCard(
                                key: ValueKey(
                                  '$_selectedWeekday-${items[index].id}-$index',
                                ),
                                item: items[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _status({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            TvFocusableAction(
              label: '重新加载日程',
              onTap: _reload,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('重新加载'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({super.key, required this.item});

  final BangumiCalendarItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = item.title.trim().isEmpty ? '未提供番名' : item.title;
    final description = [item.lang, ...item.region, ...item.genres]
        .where((part) => part.trim().isNotEmpty)
        .toSet()
        .join(' · ');
    return TvFocusableAction(
      label: '$title，查看番剧详情',
      focusEnabled: item.id > 0,
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        if (item.id <= 0) return;
        Get.toNamed('/bangumi/${item.id}', arguments: item.toListItem());
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageWidth = constraints.maxWidth < 500 ? 88.0 : 128.0;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: imageWidth,
                  height: imageWidth * 1.4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: _cover(context),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                      const SizedBox(height: 14),
                      if (item.episodes.isEmpty)
                        const Text('暂未公布具体剧集')
                      else
                        for (final episode in item.episodes)
                          _EpisodeInfo(episode: episode),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cover(BuildContext context) {
    final uri = Uri.tryParse(item.image);
    Widget placeholder({bool loading = false}) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.image_not_supported_outlined, size: 32),
          ),
        );
    if (uri == null ||
        uri.host.isEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http')) {
      return placeholder();
    }
    return Image.network(
      item.image,
      fit: BoxFit.cover,
      cacheWidth: 320,
      excludeFromSemantics: true,
      errorBuilder: (_, __, ___) => placeholder(),
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : placeholder(loading: true),
    );
  }
}

class _EpisodeInfo extends StatelessWidget {
  const _EpisodeInfo({required this.episode});

  final BangumiCalendarEpisode episode;

  String get _title {
    if (episode.name.trim().isNotEmpty) return episode.name;
    final sort = episode.sort;
    final number =
        sort == sort.roundToDouble() ? sort.toInt().toString() : '$sort';
    return sort > 0 ? '第$number集' : '未提供剧集名称';
  }

  String get _airDate {
    if (episode.date <= 0) return '播出时间未公布';
    final date = DateTime.fromMillisecondsSinceEpoch(episode.date);
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${date.year}/${twoDigits(date.month)}/${twoDigits(date.day)} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_title, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Wrap(
            spacing: 10,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(_airDate, style: theme.textTheme.bodySmall),
              if (episode.future)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '待播',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
