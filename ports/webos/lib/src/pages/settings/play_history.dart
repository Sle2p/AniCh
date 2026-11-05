import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/settings/controller.dart';
import 'package:xs/src/pages/settings/storage/play_history_storage.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/multi_sliver_compat/sliver_persistent_header_delegate.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class PlayHistoryPage extends StatelessWidget {
  const PlayHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    PlayHistoryStorage.init();
    try {
      PlayHistoryStorage.history.sort((a, b) => int.parse(b['date'].toString())
          .compareTo(int.parse(a['date'].toString())));
    } catch (e) {
      debugPrint(e.toString());
    }
    if (TvFocusableAction.isTV) return _buildTvPage(context);
    RxInt scrollHeight = 0.obs;
    RxBool scrollStatus = true.obs;
    RxDouble maxShrinkOpacity = 1.0.obs;
    return GetBuilder(
        init: PlayHistorySettingsPageController(),
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            body: SafeArea(
              top: true,
              bottom: false,
              maintainBottomViewPadding: false,
              child: NestedScrollView(
                floatHeaderSlivers: true,
                body: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    final pixels = notification.metrics.pixels.toInt();
                    if ((pixels - scrollHeight.value).abs() >= 50) {
                      final lastScrollStatus = scrollStatus.value;
                      if (pixels > scrollHeight.value) {
                        if (notification.depth > 0 &&
                            lastScrollStatus != false) {
                          scrollStatus(false);
                          controller.animationController.forward();
                          debugPrint('向下');
                        }
                      } else if (pixels < scrollHeight.value) {
                        if (lastScrollStatus != true) {
                          scrollStatus(true);
                          controller.animationController.reverse();
                          debugPrint('向上');
                        }
                      }
                      scrollHeight(pixels);
                    }
                    return false;
                  },
                  child: CustomScrollView(
                    shrinkWrap: true,
                    controller: ScrollController(),
                    slivers: [
                      SliverPadding(
                          padding: AppStyle.edgeInsetsA12.copyWith(top: 50)),
                      SliverToBoxAdapter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: PlayHistoryStorage.history.length,
                          itemBuilder: (_, i) {
                            final item = PlayHistoryStorage.history[i];
                            try {
                              item['episodes'].sort((a, b) =>
                                  int.parse(b['date'].toString()).compareTo(
                                      int.parse(a['date'].toString())));
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                            return Dismissible(
                              key: ValueKey(item['id']),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                padding: AppStyle.edgeInsetsA12,
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                return await Utils.showAlertDialog('确定要删除此记录吗?',
                                    title: '删除记录');
                              },
                              onDismissed: (_) {
                                PlayHistoryStorage.remove(item['id']);
                              },
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed('/vod/${item['id']}', arguments: {
                                    'id': item['id'],
                                    'episode': item['episodes'].first['episode']
                                  });
                                },
                                onLongPress: () async {
                                  var result = await Utils.showAlertDialog(
                                      '确定要删除此记录吗?',
                                      title: '删除记录');
                                  if (!result) {
                                    return;
                                  }
                                  PlayHistoryStorage.remove(item['id']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(7),
                                        child: Container(
                                          color: Colors.grey,
                                          width: 120 / 1.5,
                                          height: 160 / 1.5,
                                          child: Image.network(
                                            item['image'],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'],
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            item['episodes'].first['title'],
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            '观看进度: ${Duration(seconds: item['episodes'].first['position']).toString().split('.').first}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            Time.dateTimeFormat(item['date']),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverPersistentHeader(
                          pinned: true,
                          delegate: CustomSliverPersistentHeaderDelegate(
                            onMaxOffset: (offset) {
                              maxShrinkOpacity(1 - offset);
                            },
                            child: Material(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: CustomDragToMoveArea(
                                child: Obx(
                                  () {
                                    return Opacity(
                                      opacity: maxShrinkOpacity.value,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        constraints:
                                            const BoxConstraints(minHeight: 50),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: Row(
                                          children: [
                                            const Expanded(
                                              child: Text(
                                                '观看记录',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed:
                                                  PlayHistoryStorage.clean,
                                              icon: const Icon(
                                                  Icons.delete_outline),
                                              label: const Text('清空'),
                                            ),
                                            closeWindowButton(
                                                positioned: false,
                                                padding: const EdgeInsets.only(
                                                    left: 10)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )),
                    ),
                  ];
                },
              ),
            ),
            bottomNavigationBar: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SlideTransition(
                  position: Tween(begin: Offset.zero, end: const Offset(0, 1.0))
                      .animate(controller.animationController),
                  child: NavBar(
                    children: [
                      NavItem(
                          icon: Icons.arrow_back,
                          title: '返回',
                          onTap: () => Get.back()),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget _buildTvPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('观看记录'),
        leading: IconButton(
          tooltip: '返回',
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton.icon(
            onPressed: PlayHistoryStorage.clean,
            icon: const Icon(Icons.delete_outline),
            label: const Text('清空记录'),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Obx(() {
        final history = PlayHistoryStorage.history;
        if (history.isEmpty) {
          return const Center(child: Text('还没有观看记录'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: history.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = history[index];
            final episodes = List<dynamic>.from(item['episodes'] ?? []);
            episodes.sort((a, b) => (int.tryParse('${b['date']}') ?? 0)
                .compareTo(int.tryParse('${a['date']}') ?? 0));
            final latest = episodes.isEmpty ? null : episodes.first;
            final title = '${item['title'] ?? '未知番剧'}';
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TvFocusableAction(
                    key: ValueKey('history-play-${item['id']}'),
                    autofocus: index == 0,
                    focusEnabled: latest != null,
                    label: '继续播放 $title',
                    onTap: () {
                      if (latest == null) return;
                      Get.toNamed('/vod/${item['id']}', arguments: {
                        'id': item['id'],
                        'episode': latest['episode'],
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                '${item['image'] ?? ''}',
                                width: 90,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const SizedBox(
                                  width: 90,
                                  height: 120,
                                  child: Icon(Icons.movie_outlined, size: 40),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                  const SizedBox(height: 8),
                                  Text(latest == null
                                      ? '没有可继续播放的剧集'
                                      : '${latest['title'] ?? ''}'),
                                  if (latest != null)
                                    Text(
                                        '观看进度：${Duration(seconds: int.tryParse('${latest['position']}') ?? 0).toString().split('.').first}'),
                                ],
                              ),
                            ),
                            const Icon(Icons.play_arrow, size: 36),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                TvFocusableAction(
                  key: ValueKey('history-delete-${item['id']}'),
                  label: '删除 $title 的观看记录',
                  onTap: () async {
                    final confirmed = await Utils.showAlertDialog(
                      '确定要删除此记录吗?',
                      title: '删除记录',
                    );
                    if (confirmed) PlayHistoryStorage.remove(item['id']);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(height: 6),
                        Text('删除'),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
