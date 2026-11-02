import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:xs/src/widgets/player/webos_player.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/src/pages/bangumi_detail/models/bangumi_detail_model.dart';
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/pages/bangumi_vod/views/comments.dart';
import 'package:xs/src/pages/bangumi_vod/views/index.dart';
import 'package:xs/src/widgets/drag_to_move_bar.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/player/controls.dart';
import 'package:xs/src/widgets/player/tv_player_shortcuts.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';
import 'package:xs/src/pages/settings/storage/playback_storage.dart';
import 'package:xs/src/utils/utils.dart';

const String assetName = 'assets/images/no_image.svg';
final Widget noImage = SvgPicture.asset(assetName);

class BangumiVodPage extends StatefulWidget {
  const BangumiVodPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return BangumiVodPageState();
  }
}

class BangumiVodPageState extends State<BangumiVodPage> {
  bool _configured = false;
  final FocusNode _videoFocus = FocusNode(debugLabel: 'AniCh TV player');
  final ScrollController _pageScroll = ScrollController();
  TvPlayerPanelCoordinator? _tvPanels;
  bool _routeBound = false;
  late final int _id;
  late final int _episode;
  late final BangumiDetailModel? _data;
  late final List<bangumi_episodes_data_>? _episodes;
  late final String? _routeName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeBound) return;
    // Get.arguments describes the top route, which becomes the selection
    // dialog while it is open. Bind once to this player's own route instead.
    final route = ModalRoute.of(context)!;
    final arguments = route.settings.arguments as Map;
    _id = arguments['id'] as int;
    _episode = arguments['episode'] as int;
    _data = arguments['data'] as BangumiDetailModel?;
    _episodes = arguments['episodes'] as List<bangumi_episodes_data_>?;
    _routeName = route.settings.name;
    _routeBound = true;
  }

  @override
  void dispose() {
    _tvPanels?.dispose();
    _videoFocus.dispose();
    _pageScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id: _routeName,
      init: BangumiVodPageController(pId: _id, pEpisode: _episode),
      builder: (controller) {
        if (!_configured) {
          _configured = true;
          if (TvFocusableAction.isTV) {
            _tvPanels = TvPlayerPanelCoordinator(
              context: context,
              canOpen: (panel) {
                controller.showControls();
                final ready = panel == TvPlayerPanel.lines
                    ? controller.playUrls.isNotEmpty
                    : controller.episodes.isNotEmpty;
                if (!ready) {
                  SmartDialog.showToast(
                    panel == TvPlayerPanel.lines ? '播放线路尚未就绪' : '剧集列表尚未就绪',
                  );
                }
                return ready;
              },
              buildRoute: (panel, close, wrap) => Utils.rightDialogRoute(
                title: panel == TvPlayerPanel.lines ? '切换线路' : '选集',
                width: panel == TvPlayerPanel.lines ? 480 : 400,
                onBack: close,
                wrap: wrap,
                child: panel == TvPlayerPanel.lines
                    ? controller.buildPlayUrlsPanel(close)
                    : controller.buildEpisodesPanel(close),
              ),
              onDanmaku: () {
                controller.showDanmakuState.toggle();
                controller.showControls();
                SmartDialog.showToast(
                  controller.showDanmakuState.value ? '弹幕已开启' : '弹幕已关闭',
                );
              },
              onFullscreen: () {
                controller.fullScreenState.value
                    ? controller.exitFull()
                    : controller.enterFullScreen();
              },
            );
            controller.tvPanelCoordinator = _tvPanels;
          }
          controller.beforeHideControls = () {
            if (_videoFocus.hasFocus && !_videoFocus.hasPrimaryFocus) {
              _videoFocus.requestFocus();
            }
          };
          if (_data != null) {
            controller.setBangumiData(_data);
          } else {
            controller.getBangumiData();
          }
          if (_episodes != null) {
            controller.setBangumiEpisodes(_episodes);
          } else {
            controller.getBangumiEpisodes();
          }
          if (mounted) {
            controller.listen();
          }
        }
        final page = Obx(() {
          if (controller.fullScreenState.value) {
            return PopScope(
              canPop: false,
              onPopInvoked: (e) {
                controller.exitFull();
              },
              child: Scaffold(body: buildMediaPlayer(controller)),
            );
          } else {
            return buildPageUI(controller);
          }
        });
        if (!TvFocusableAction.isTV) return page;
        return _tvPanels!.wrap(page);
      },
    );
  }

  Widget buildPageUI(BangumiVodPageController controller) {
    return OrientationBuilder(
      builder: (context, orientation) {
        RxInt scrollHeight = 0.obs;
        RxBool scrollStatus = true.obs;
        return Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, 0),
            child: AppBar(backgroundColor: Colors.black),
          ),
          body: controller.obx((state) {
            return DefaultTabController(
              length: controller.tabs.length,
              child: NestedScrollView(
                controller: _pageScroll,
                body: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    final pixels = notification.metrics.pixels.toInt();
                    if ((pixels - scrollHeight.value).abs() >= 50) {
                      final lastScrollStatus = scrollStatus.value;
                      if (pixels > scrollHeight.value) {
                        if (notification.depth == 1 &&
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
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      BangumiVodIndexView(controller: controller),
                      BangumiVodCommentsView(
                        bangumiVodPageController: controller,
                      ),
                    ],
                  ),
                ),
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  double expandedHeight = min(
                    (MediaQuery.of(context).size.width * 9 / 16) + 50,
                    450,
                  );
                  return [
                    SliverOverlapAbsorber(
                      sliver: SliverAppBar(
                        pinned: true,
                        automaticallyImplyLeading: false,
                        floating: true,
                        snap: false,
                        // Keep the native video plane at fixed geometry. Opacity
                        // and FlexibleSpaceBar fading would mask its clear hole.
                        expandedHeight: expandedHeight,
                        collapsedHeight: expandedHeight,
                        toolbarHeight: 0,
                        backgroundColor: Colors.black,
                        surfaceTintColor: Colors.transparent,
                        flexibleSpace: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: buildMediaPlayer(controller),
                        ),
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(50),
                          child: Material(
                            color: Colors.transparent,
                            // color: Theme.of(context).scaffoldBackgroundColor,
                            child: CustomDragToMoveArea(
                              child: TabBar(
                                controller: controller.tabController,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.label,
                                dividerColor: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                                tabs: controller.tabs,
                              ),
                            ),
                          ),
                        ),
                      ),
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                    ),
                  ];
                },
              ),
            );
          }),
          bottomNavigationBar: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SlideTransition(
                position: Tween(
                  begin: Offset.zero,
                  end: const Offset(0, 1.0),
                ).animate(controller.animationController),
                child: NavBar(
                  children: [
                    NavItem(
                      icon: Icons.arrow_back,
                      title: '返回',
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPhoneUI(
    BuildContext context,
    BangumiVodPageController controller,
  ) {
    return Stack(
      children: [
        SizedBox(
          // constraints: const BoxConstraints(maxHeight: 220),
          width: MediaQuery.of(context).size.width,
          // height: 270,
          // child: buildMediaPlayer(controller),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: buildMediaPlayer(controller),
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget buildMediaPlayer(BangumiVodPageController controller) {
    return Focus(
      focusNode: _videoFocus,
      autofocus: true,
      onFocusChange: (focused) {
        if (focused) controller.showControls();
      },
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        controller.showControls();
        final key = event.logicalKey;
        if (key == LogicalKeyboardKey.mediaPlayPause ||
            (_videoFocus.hasPrimaryFocus &&
                (key == LogicalKeyboardKey.enter ||
                    key == LogicalKeyboardKey.select ||
                    key == LogicalKeyboardKey.space))) {
          controller.showControls();
          controller.player.state.playing
              ? controller.player.pause()
              : controller.player.play();
          return KeyEventResult.handled;
        }
        if (_videoFocus.hasPrimaryFocus &&
            (key == LogicalKeyboardKey.arrowLeft ||
                key == LogicalKeyboardKey.arrowRight)) {
          controller.showControls();
          controller.danmakuController?.clear();
          controller.player.seek(
            controller.player.state.position +
                Duration(
                  seconds: key == LogicalKeyboardKey.arrowLeft
                      ? -PlaybackSettingsStorage.seekBackwardSeconds.value
                      : PlaybackSettingsStorage.seekForwardSeconds.value,
                ),
          );
          return KeyEventResult.handled;
        }
        if (_videoFocus.hasPrimaryFocus &&
            (key == LogicalKeyboardKey.arrowDown ||
                key == LogicalKeyboardKey.arrowUp)) {
          controller.showControls();
          _videoFocus.nextFocus();
          return KeyEventResult.handled;
        }
        if (key == LogicalKeyboardKey.mediaPlay) {
          controller.player.play();
          return KeyEventResult.handled;
        }
        if (key == LogicalKeyboardKey.mediaPause) {
          controller.player.pause();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Video(
        key: controller.globalPlayerKey,
        controller: controller.videoController,
        pauseUponEnteringBackgroundMode: true,
        resumeUponEnteringForegroundMode: true,
        controls: (state) => playerControls(state, controller),
        aspectRatio: controller.aspectRatio,
        fit: controller.boxFit,
      ),
    );
  }
}
