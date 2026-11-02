import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xs/src/widgets/player/webos_player.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/protobuf/danmaku.pb.dart';
import 'package:xs/src/apis/bangumi.dart';
import 'package:xs/src/pages/bangumi_detail/models/bangumi_detail_model.dart';
import 'package:xs/src/pages/bangumi_vod/models/qq_video_model.dart';
import 'package:xs/src/pages/bangumi_vod/danmaku_merge.dart';
import 'package:xs/src/pages/settings/storage/play_history_storage.dart';
import 'package:xs/src/pages/settings/storage/playback_storage.dart';
import 'package:xs/src/utils/time.dart';
import 'package:xs/src/widgets/danmaku_settings/storage.dart';
import 'package:xs/src/widgets/danmaku_shield/storage.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/color.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/danmaku_settings/view.dart';
import 'package:xs/src/widgets/danmaku_shield/view.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_controller.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_item.dart';
import 'package:xs/src/widgets/ns_danmaku/utils.dart';
import 'package:xs/src/widgets/player/controller.dart';
import 'package:xs/src/widgets/player/tv_player_shortcuts.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';
import 'package:xs/src/widgets/settings/settings_switch.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

const String assetName = 'assets/images/no_image.svg';
final Widget noImage = SvgPicture.asset(assetName);

class BangumiVodPageController extends PlayerController
    with StateMixin, WidgetsBindingObserver, GetTickerProviderStateMixin {
  final int pId;
  final int pEpisode;
  BangumiVodPageController({required this.pId, required this.pEpisode}) {
    rxId = pId.obs;
    rxEpisode = pEpisode.obs;
  }

  late RxInt rxId;
  int get id => rxId.value;
  late RxInt rxEpisode;
  int get episode => rxEpisode.value;

  // 音量
  RxDouble playerVolume = 100.0.obs;

  // 线路数据
  RxList<vod_item_> playUrls = RxList<vod_item_>();

  TvPlayerPanelCoordinator? tvPanelCoordinator;

  // 当前线路
  var currentLineIndex = -1;
  var currentLineInfo = ''.obs;

  // 加载失败
  var loadError = false.obs;
  Error? error;

  // 退出
  RxBool leave = false.obs;

  // 导航栏
  final List<Tab> tabs = <Tab>[
    const Tab(
      child: Align(alignment: Alignment.center, child: Text('简介')),
    ),
    const Tab(
      child: Align(alignment: Alignment.center, child: Text('评论')),
    ),
  ];

  late TabController tabController;
  late final AnimationController animationController;
  RxInt tabIndex = 0.obs;

  late BangumiDetailModel data;
  bool _hasBangumiData = false;
  bangumi_episodes_data_ get episodeDetail => getEpisodeData();
  List<bangumi_episodes_data_> episodes = [];
  List<data_> danmakuList = [];
  List<bilibili_danmaku_item_> bilibiliDanmakuList = [];
  List<bilibili_danmaku_item_> bilibiliHmtDanmakuList = [];
  List<BarrageList> qqDanmakuList = [];
  int _danmakuRequest = 0;
  int _danmakuPosition = 0;
  String _bilibiliCid = '';
  String _bilibiliHmtCid = '';
  final Map<String, Set<String>> _loadedDanmakuIds = {};
  final Set<(String, String)> _emittedDanmakuIds = {};

  bool _isCurrentDanmakuRequest(int request, int requestEpisode) =>
      !leave.value && request == _danmakuRequest && requestEpisode == episode;

  String _nativeDanmakuKey(data_ item) =>
      item.id.isNotEmpty ? item.id : base64Encode(item.writeToBuffer());

  String _bilibiliDanmakuKey(bilibili_danmaku_item_ item) =>
      item.idStr.isNotEmpty
          ? item.idStr
          // The old protobuf declares numeric id as uint32. It can truncate
          // real Bilibili IDs; retain all fields when the full ID is absent.
          : base64Encode(item.writeToBuffer());

  String _qqDanmakuKey(BarrageList item) =>
      item.id?.isNotEmpty == true ? item.id! : jsonEncode(item.toJson());

  void _appendUniqueDanmaku<T>(String source, List<T> target, Iterable<T> items,
      String Function(T) keyOf) {
    final ids = _loadedDanmakuIds.putIfAbsent(source, () => <String>{});
    target.addAll(items.where((item) => ids.add(keyOf(item))));
  }

  ScrollController playListScrollController = ScrollController();
  ScrollController playListScrollController2 = ScrollController();

  RxInt lastPosition = 0.obs;

  RxBool playing = true.obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);

    get();

    tabController = TabController(
      vsync: this,
      length: tabs.length,
      initialIndex: 0,
    );
    tabController.addListener(() {
      tabIndex(tabController.index);
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    super.onInit();
  }

  final List<StreamSubscription> _playbackSubscriptions = [];
  bool _listening = false;

  void listen() {
    if (_listening) return;
    _listening = true;
    // Defaults apply once on entry. Playback-state changes must preserve the
    // viewer's current toggle choices; settings controls update them explicitly.
    showDanmakuState.value = DanmakuSettingsStorage.danmakuEnable.value;
    bilibiliDanmakuState.value =
        DanmakuSettingsStorage.bilibiliDanmakuEnable.value;
    bilibiliHmtDanmakuState.value =
        DanmakuSettingsStorage.bilibiliHmtDanmakuEnable.value;
    qqDanmakuState.value = DanmakuSettingsStorage.qqDanmakuEnable.value;
    int inSeconds = 0;

    _playbackSubscriptions.add(
      player.stream.error.listen((event) {
        if (_openingSource || _loadingSources || leave.value) return;
        _recoverPlayback(event);
      }),
    );

    _playbackSubscriptions.add(
      player.stream.completed.listen((event) {
        if (event) {
          showControls();
        }
      }),
    );

    _playbackSubscriptions.add(
      player.stream.playing.listen((event) {
        playing(player.state.playing);
        if (danmakuController is DanmakuController) {
          if (event) {
            danmakuController!.resume();
          } else {
            danmakuController!.pause();
          }
        }
      }),
    );

    _playbackSubscriptions.add(
      player.stream.position.listen((event) async {
        int currentinSeconds = event.inSeconds;
        if (currentinSeconds > 0 && lastPosition.value > 0) {
          final thisLastPosition = Duration(seconds: lastPosition.value);
          lastPosition(0);
          await player.seek(thisLastPosition);
          debugPrint('跳转到$thisLastPosition');
          // The seek emits its own position event. This pre-seek sample must
          // not overwrite the restored progress or enqueue stale danmaku.
          return;
        }
        // stop/open emit zero while changing episodes; do not replace the new
        // episode's saved resume position with those temporary reset events.
        if (_hasBangumiData &&
            !leave.value &&
            !_loadingSources &&
            !_openingSource &&
            currentinSeconds > 0 &&
            (inSeconds - currentinSeconds).abs() >= 5) {
          inSeconds = currentinSeconds;
          unawaited(PlayHistoryStorage.upsertProgress(
            id: id,
            title: data.title,
            image: data.image,
            episode: episode,
            episodeTitle: '第$episode集 ${episodeDetail.title}',
            episodeImage: episodeDetail.image,
            position: currentinSeconds,
          ).catchError((Object error) {
            debugPrint('保存观看进度失败：$error');
          }));
        }
        if (leave.value || _loadingSources || _openingSource) return;
        if (showDanmakuState.value && danmakuController is DanmakuController) {
          int currentPosition = event.inMilliseconds ~/ 100;
          if (_danmakuPosition != currentPosition) {
            // video_player samples progress every 500 ms. Include the interval
            // since the last sample, but never flood old comments after a seek.
            final previousPosition = currentPosition > _danmakuPosition &&
                    currentPosition - _danmakuPosition <= 20
                ? _danmakuPosition
                : currentPosition - 1;
            if (currentPosition < _danmakuPosition ||
                currentPosition - _danmakuPosition > 20) {
              danmakuController?.clear();
              // Seeking starts a fresh pass, so genuine replay remains visible.
              _emittedDanmakuIds.clear();
            }
            _danmakuPosition = currentPosition;
            final queued = <DanmakuItem>[];
            bool inCurrentInterval(double seconds) =>
                seconds * 10 > previousPosition &&
                seconds * 10 <= currentPosition;
            // 默认弹幕
            if (danmakuList.isNotEmpty) {
              final currentDanmakuList = mergeImportedDanmaku(
                      danmakuList.where((e) => inCurrentInterval(e.time)))
                  .where((e) {
                return inCurrentInterval(e.time) &&
                    DanmakuShieldStorage.shieldCheck(e.text) &&
                    _emittedDanmakuIds.add(('anich', _nativeDanmakuKey(e)));
              });
              final currentDanmakuListQueue = currentDanmakuList.map((e) {
                return DanmakuItem(
                  e.text,
                  color: ColorUtil.fromHex(e.color),
                  // time: currentPosition,
                  time: e.time,
                  type: DanmakuUtils.getPosition(e.type),
                );
              }).toList();
              queued.addAll(currentDanmakuListQueue);
            }
            // 哔哩哔哩弹幕
            if (bilibiliDanmakuList.isNotEmpty && bilibiliDanmakuState.value) {
              final currentDanmakuList = bilibiliDanmakuList.where((e) {
                // return (e.progress / 1000).floor() == currentPosition;
                return inCurrentInterval(e.progress / 1000) &&
                    DanmakuShieldStorage.shieldCheck(e.content) &&
                    _emittedDanmakuIds.add(
                        ('bilibili:$_bilibiliCid', _bilibiliDanmakuKey(e)));
              });
              final currentDanmakuListQueue = currentDanmakuList.map((e) {
                return DanmakuItem(
                  e.content,
                  color: ColorUtil.decimalToColor(e.color),
                  // time: currentPosition,
                  time: e.progress / 1000,
                  type: DanmakuUtils.getBilibiliPosition(e.mode),
                );
              }).toList();
              queued.addAll(currentDanmakuListQueue);
            }
            // 哔哩哔哩(港澳台)弹幕
            if (bilibiliHmtDanmakuList.isNotEmpty &&
                bilibiliHmtDanmakuState.value) {
              final currentDanmakuList = bilibiliHmtDanmakuList.where((e) {
                // return (e.progress / 1000).floor() == currentPosition;
                return inCurrentInterval(e.progress / 1000) &&
                    DanmakuShieldStorage.shieldCheck(e.content) &&
                    // Mainland/HMT switches can point at the very same CID.
                    _emittedDanmakuIds.add(
                        ('bilibili:$_bilibiliHmtCid', _bilibiliDanmakuKey(e)));
              });
              final currentDanmakuListQueue = currentDanmakuList.map((e) {
                return DanmakuItem(
                  e.content,
                  color: ColorUtil.decimalToColor(e.color),
                  // time: currentPosition,
                  time: e.progress / 1000,
                  type: DanmakuUtils.getBilibiliPosition(e.mode),
                );
              }).toList();
              queued.addAll(currentDanmakuListQueue);
            }
            // 腾讯视频弹幕
            if (qqDanmakuList.isNotEmpty && qqDanmakuState.value) {
              final currentDanmakuList = qqDanmakuList.where((e) {
                // return (int.parse(e.timeOffset ?? '0') / 1000).floor() ==
                //     currentPosition;
                return inCurrentInterval(
                      int.parse(e.timeOffset ?? '0') / 1000,
                    ) &&
                    DanmakuShieldStorage.shieldCheck(e.content) &&
                    _emittedDanmakuIds.add(('qq', _qqDanmakuKey(e)));
              });
              final currentDanmakuListQueue = currentDanmakuList.map((e) {
                return DanmakuItem(
                  e.content ?? '一条弹幕',
                  color: Colors.white,
                  // time: currentPosition,
                  time: int.parse(e.timeOffset ?? '0') / 1000,
                  type: DanmakuUtils.getQQPosition(e.rickType ?? 1),
                );
              }).toList();
              queued.addAll(currentDanmakuListQueue);
            }
            if (queued.isNotEmpty) {
              try {
                danmakuController!.addItems(queued);
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          }
        }
      }),
    );
  }

  // 番剧数据
  void setBangumiData(data) async {
    try {
      debugPrint('BangumiVodController-setBangumiData');
      this.data = data;
      _hasBangumiData = true;
      change(data, status: RxStatus.success());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 获取番剧数据
  void getBangumiData() async {
    try {
      debugPrint('BangumiVodController-getBangumiData');
      change(null, status: RxStatus.loading());
      final response = await BangumiApi.getBangumiDetail(id: id);
      if (response.statusCode == 200) {
        final data = BangumiDetailModel.fromJson(response.data);
        this.data = data;
        _hasBangumiData = true;
        change(data, status: RxStatus.success());
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
      change(null, status: RxStatus.error('error'));
    }
  }

  // 番剧剧集
  void setBangumiEpisodes(episodes) async {
    try {
      debugPrint('BangumiVodController-setBangumiEpisodes');
      this.episodes = episodes;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 获取番剧剧集
  void getBangumiEpisodes() async {
    try {
      debugPrint('BangumiVodController-getBangumiEpisodes');
      final response = await BangumiApi.getBangumiEpisodes(id: id);
      if (response.statusCode == 200) {
        final data = bangumi_episodes_.fromBuffer(response.data);
        episodes.addAll(data.data);
        update();
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // 获取弹幕
  Future<void> getDanmaku() async {
    final request = _danmakuRequest;
    final thisEpisode = episode;
    int skip = 0;
    bool completed = false;
    while (!completed && _isCurrentDanmakuRequest(request, thisEpisode)) {
      try {
        debugPrint('BangumiVodController-getDanmaku-$skip');
        final response = await BangumiApi.getDanmaku(
          id: id,
          episode: thisEpisode,
          skip: skip,
        );
        if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
        if (response.statusCode == 200) {
          final data = danmaku_.fromBuffer(response.data);
          if (data.data.isNotEmpty) {
            _appendUniqueDanmaku(
                'anich', danmakuList, data.data, _nativeDanmakuKey);
            // The server can return 2999 records with next skip = 3000.
            // Follow its cursor, and reject a stationary/backward cursor.
            if (data.hasSkip()) {
              if (data.skip > skip) {
                skip = data.skip;
              } else {
                completed = true;
              }
            } else if (data.data.length == 3000) {
              skip += 3000;
            } else {
              completed = true;
            }
          } else {
            completed = true;
          }
        } else {
          throw Error();
        }
      } catch (e) {
        completed = true;
        debugPrint(e.toString());
      }
    }
    debugPrint('BangumiVodController-getDanmaku-complete');
  }

  // 获取哔哩哔哩弹幕
  Future<void> getBilibiliDanmaku() async {
    final request = _danmakuRequest;
    final thisEpisode = episode;
    int index = 1;
    bool completed = false;
    while (!completed && _isCurrentDanmakuRequest(request, thisEpisode)) {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
      if (episodes.isNotEmpty) {
        final currentEpisode = getEpisodeData();
        if (currentEpisode.sites.isNotEmpty) {
          bangumi_episodes_sites_ site = currentEpisode.sites.firstWhere(
            (e) => e.site == 'bili_cid',
            orElse: () => bangumi_episodes_sites_(),
          );
          if (site.id.isEmpty) {
            completed = true;
            return;
          } else {
            _bilibiliCid = site.id;
            try {
              debugPrint('BangumiVodController-getBilibiliDanmaku-$index');
              final response = await BangumiApi.getBilibiliDanmaku(
                type: 1,
                oid: int.parse(site.id),
                segmentIndex: index,
              );
              if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
              if (response.statusCode == 200) {
                final data = bilibili_danmaku_.fromBuffer(response.data);
                if (data.list.isNotEmpty) {
                  final list = Utils.splitList(data.list, 500);
                  for (final item in list) {
                    final list_ = (await compute(
                      DanmakuShieldStorage.defaultShieldCheck,
                      item,
                    ))
                        .cast<bilibili_danmaku_item_>();
                    if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
                    _appendUniqueDanmaku('bilibili', bilibiliDanmakuList, list_,
                        _bilibiliDanmakuKey);
                  }
                  index += 1;
                } else {
                  completed = true;
                }
              } else {
                completed = true;
                throw Error();
              }
            } catch (e) {
              completed = true;
              debugPrint(e.toString());
            }
          }
        }
      }
    }
    debugPrint('BangumiVodController-getBilibiliDanmaku-complete');
  }

  // 获取哔哩哔哩(港澳台)弹幕
  Future<void> getBilibiliHmtDanmaku() async {
    final request = _danmakuRequest;
    final thisEpisode = episode;
    int index = 1;
    bool completed = false;
    while (!completed && _isCurrentDanmakuRequest(request, thisEpisode)) {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
      if (episodes.isNotEmpty) {
        final currentEpisode = getEpisodeData();
        if (currentEpisode.sites.isNotEmpty) {
          bangumi_episodes_sites_ site = currentEpisode.sites.firstWhere(
            (e) => e.site == 'bili_hmt_cid',
            orElse: () => bangumi_episodes_sites_(),
          );
          if (site.id.isEmpty) {
            completed = true;
            return;
          } else {
            _bilibiliHmtCid = site.id;
            try {
              debugPrint('BangumiVodController-getBilibiliHmtDanmaku-$index');
              final response = await BangumiApi.getBilibiliDanmaku(
                type: 1,
                oid: int.parse(site.id),
                segmentIndex: index,
              );
              if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
              if (response.statusCode == 200) {
                final data = bilibili_danmaku_.fromBuffer(response.data);
                if (data.list.isNotEmpty) {
                  final list = Utils.splitList(data.list, 500);
                  for (final item in list) {
                    final list_ = (await compute(
                      DanmakuShieldStorage.defaultShieldCheck,
                      item,
                    ))
                        .cast<bilibili_danmaku_item_>();
                    if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
                    _appendUniqueDanmaku('bilibili_hmt', bilibiliHmtDanmakuList,
                        list_, _bilibiliDanmakuKey);
                  }
                  index += 1;
                } else {
                  completed = true;
                }
              } else {
                completed = true;
                throw Error();
              }
            } catch (e) {
              completed = true;
              debugPrint(e.toString());
            }
          }
        }
      }
    }
    debugPrint('BangumiVodController-getBilibiliHmtDanmaku-complete');
  }

  // 获取腾讯视频弹幕
  Future<void> getQQDanmaku() async {
    final request = _danmakuRequest;
    final thisEpisode = episode;
    int index = 1;
    bool completed = false;
    while (!completed && _isCurrentDanmakuRequest(request, thisEpisode)) {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
      if (episodes.isNotEmpty) {
        final currentEpisode = getEpisodeData();
        if (currentEpisode.sites.isNotEmpty) {
          bangumi_episodes_sites_ site = currentEpisode.sites.firstWhere(
            (e) => e.site == 'qq',
            orElse: () => bangumi_episodes_sites_(),
          );
          if (site.id.isEmpty) {
            completed = true;
            return;
          } else {
            try {
              debugPrint('BangumiVodController-getQQDanmaku-$index');
              final response = await BangumiApi.getQQDanmaku(
                id: site.id,
                page: index,
              );
              if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
              if (response.statusCode == 200) {
                final data = QqVideoModel.fromJson(response.data).barrageList;
                if (data!.isNotEmpty) {
                  final list = Utils.splitList(data, 500);
                  for (final item in list) {
                    final list_ = (await compute(
                      DanmakuShieldStorage.defaultShieldCheck,
                      item,
                    ))
                        .cast<BarrageList>();
                    if (!_isCurrentDanmakuRequest(request, thisEpisode)) return;
                    _appendUniqueDanmaku(
                        'qq', qqDanmakuList, list_, _qqDanmakuKey);
                  }
                  index += 1;
                } else {
                  completed = true;
                }
              } else {
                completed = true;
                throw Error();
              }
            } catch (e) {
              completed = true;
              debugPrint(e.toString());
            }
          }
        }
      }
    }
    debugPrint('BangumiVodController-getQQDanmaku-complete');
  }

  // Source API URLs contain an extra fourth Base64 character.
  String urlDecode(String str) {
    if (str.startsWith('https://') || str.startsWith('http://')) return str;
    try {
      return utf8.decode(
        base64.decode(base64.normalize(str.substring(0, 3) + str.substring(4))),
      );
    } catch (_) {
      return '';
    }
  }

  int _vodRequest = 0;
  int _playRequest = 0;
  int _remainingAutomaticLines = 4;
  final Set<int> _triedLines = {};
  bool _openingSource = false;
  bool _loadingSources = false;
  bool _hasStartedPlayback = false;
  int? _autoAdvancedRequest;

  List<String> get _lineKeys => playUrls.map((source) {
        // The host and source metadata survive signed URL / episode changes.
        final host = Uri.tryParse(urlDecode(source.url))?.host ?? '';
        return jsonEncode([source.type, source.caption, host]);
      }).toList();

  bool _advanceFailedLine() {
    if (!PlaybackSettingsStorage.autoSwitchLine.value ||
        _remainingAutomaticLines <= 0 ||
        playUrls.isEmpty) {
      return false;
    }
    // A remembered source may be the final item. Wrap once, without retrying
    // any failed source, so earlier alternatives remain reachable.
    for (var offset = 1; offset < playUrls.length; offset++) {
      final candidate = (currentLineIndex + offset) % playUrls.length;
      if (_triedLines.contains(candidate)) continue;
      _remainingAutomaticLines--;
      currentLineIndex = candidate;
      currentLineInfo.value = '正在切换到线路${currentLineIndex + 1}...';
      return true;
    }
    return false;
  }

  void _recoverPlayback(String error) {
    if (_advanceFailedLine()) {
      unawaited(setPlayer(resetRetryBudget: false));
    } else {
      loadError(true);
      showControls();
      SmartDialog.showToast('当前线路播放失败，请手动选择其他线路：$error');
    }
  }

  // Fetch real source lines using AniCh's existing protobuf response.
  Future<void> getPlayUrl() async {
    final request = ++_vodRequest;
    _playRequest++;
    _loadingSources = true;
    playUrls.clear();
    currentLineInfo.value = '获取中...';
    currentLineIndex = -1;
    loadError(false);
    try {
      await player.stop();
      if (leave.value || request != _vodRequest) return;
      final response = await BangumiApi.getBangumiEpisodeVod(
        id: id,
        episode: episode,
      );
      if (leave.value || request != _vodRequest) return;
      if (response.statusCode != 200 || response.data is! List) {
        throw const FormatException('无法读取播放地址');
      }
      final sources = vod_.fromBuffer(List<int>.from(response.data)).data;
      playUrls.assignAll(
        sources.where((source) => urlDecode(source.url).isNotEmpty),
      );
      if (playUrls.isEmpty) {
        _loadingSources = false;
        currentLineInfo.value = '暂无资源';
        SmartDialog.showToast('该集暂无可用播放线路');
        return;
      }
      currentLineIndex =
          PlaybackSettingsStorage.preferredLineIndex(id, _lineKeys);
      _loadingSources = false;
      await setPlayer();
    } catch (error) {
      if (leave.value || request != _vodRequest) return;
      _loadingSources = false;
      currentLineInfo.value = '获取失败';
      loadError(true);
      SmartDialog.showToast('无法读取播放地址：$error');
    }
  }

  Future<void> setPlayer({bool resetRetryBudget = true}) async {
    if (leave.value ||
        currentLineIndex < 0 ||
        currentLineIndex >= playUrls.length) {
      return;
    }
    final request = ++_playRequest;
    if (resetRetryBudget) {
      _remainingAutomaticLines = 4;
      _triedLines.clear();
    }
    lastPosition(PlayHistoryStorage.getLastPosition(id, episode));
    loadError(false);
    while (!leave.value && request == _playRequest) {
      final selectedLine = currentLineIndex;
      _triedLines.add(selectedLine);
      _openingSource = true;
      currentLineInfo.value = '正在加载线路${selectedLine + 1}...';
      try {
        await player.open(Media(urlDecode(playUrls[selectedLine].url)));
        if (leave.value || request != _playRequest) return;
        playerSpeed(player.rate);
        _openingSource = false;
        currentLineInfo.value = '线路${selectedLine + 1}';
        unawaited(PlaybackSettingsStorage.rememberSuccessfulLine(
          id,
          _lineKeys,
          selectedLine,
        ).catchError((Object error) {
          debugPrint('保存播放线路失败：$error');
        }));
        if (!_hasStartedPlayback) {
          _hasStartedPlayback = true;
          if (TvFocusableAction.isTV &&
              PlaybackSettingsStorage.autoFullScreen.value) {
            await enterFullScreen();
          }
        }
        return;
      } catch (error) {
        if (leave.value || request != _playRequest) return;
        _openingSource = false;
        if (_advanceFailedLine()) continue;
        loadError(true);
        currentLineInfo.value = '线路${selectedLine + 1}播放失败';
        showControls();
        SmartDialog.showToast('播放失败，请手动选择其他线路：$error');
        return;
      }
    }
  }

  @override
  void mediaEnd() {
    if (leave.value ||
        _openingSource ||
        _loadingSources ||
        !player.state.completed ||
        !PlaybackSettingsStorage.autoNext.value ||
        _autoAdvancedRequest == _playRequest) {
      return;
    }
    _autoAdvancedRequest = _playRequest;
    playNextEpisode(automatic: true);
  }

  void playNextEpisode({bool automatic = false}) {
    if (leave.value) return;
    final next = episodes.where((item) => item.sort > episode).toList()
      ..sort((a, b) => a.sort.compareTo(b.sort));
    if (next.isEmpty) {
      showControls();
      if (!automatic) SmartDialog.showToast('已到最后一集');
      return;
    }
    rxEpisode(next.first.sort);
    danmakuController?.clear();
    get();
  }

  // 获取集数据
  bangumi_episodes_data_ getEpisodeData() {
    return episodes.firstWhere(
      (e) => e.sort == episode,
      orElse: () => bangumi_episodes_data_(),
    );
  }

  // 切换线路
  void changePlayLine(int index) {
    if (leave.value || index < 0 || index >= playUrls.length) return;
    currentLineIndex = index;
    unawaited(setPlayer());
  }

  // 刷新
  void reload() async {
    getPlayUrl();
  }

  // 获取数据
  void get() async {
    // Invalidate even A -> B -> A requests; comparing only episode numbers
    // lets the first A response contaminate the newly loaded episode.
    _danmakuRequest++;
    _danmakuPosition = 0;
    _loadedDanmakuIds.clear();
    _emittedDanmakuIds.clear();
    _bilibiliCid = '';
    _bilibiliHmtCid = '';
    danmakuController?.clear();
    getPlayUrl();
    danmakuList.clear();
    bilibiliDanmakuList.clear();
    bilibiliHmtDanmakuList.clear();
    qqDanmakuList.clear();
    getDanmaku();
    getBilibiliDanmaku();
    getBilibiliHmtDanmaku();
    getQQDanmaku();
  }

  // 跳转到指定集数位置
  void scrollToIndex() {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      try {
        final index = episodes.indexWhere((e) => e.sort == episode);
        if (playListScrollController.position.hasPixels) {
          playListScrollController.animateTo(
            index * 150,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeIn,
          );
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  /// 底部打开播放器设置
  void showDanmakuSettingsSheet() {
    Utils.showBottomSheet(
      title: '弹幕设置',
      child: ListView(
        padding: AppStyle.edgeInsetsA12,
        children: [
          DanmakuSettingsView(
            playerController: this,
            danmakuController: danmakuController,
            onTapDanmakuShield: () {
              Get.back();
              DanmakuShieldView.showDanmakuShieldBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  void showDanmakuShield() {
    TextEditingController keywordController = TextEditingController();

    void addKeyword() {
      if (keywordController.text.isEmpty) {
        SmartDialog.showToast('请输入关键词');
        return;
      }

      DanmakuShieldStorage.addShieldList(keywordController.text.trim());
      keywordController.text = '';
    }

    Utils.showBottomSheet(
      title: '关键词屏蔽',
      child: ListView(
        padding: AppStyle.edgeInsetsA12,
        children: [
          TextField(
            controller: keywordController,
            decoration: InputDecoration(
              contentPadding: AppStyle.edgeInsetsH12,
              border: const OutlineInputBorder(),
              hintText: '请输入关键词',
              suffixIcon: TextButton.icon(
                onPressed: addKeyword,
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ),
            onSubmitted: (e) {
              addKeyword();
            },
          ),
          AppStyle.vGap12,
          Obx(
            () => Text(
              '已添加${DanmakuShieldStorage.shieldList.length}个关键词（点击移除）',
              style: Get.textTheme.titleSmall,
            ),
          ),
          AppStyle.vGap12,
          Obx(
            () => Wrap(
              runSpacing: 12,
              spacing: 12,
              children: DanmakuShieldStorage.shieldList
                  .map(
                    (item) => InkWell(
                      borderRadius: AppStyle.radius24,
                      onTap: () {
                        DanmakuShieldStorage.removeShieldList(item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: AppStyle.radius24,
                        ),
                        padding: AppStyle.edgeInsetsH12.copyWith(
                          top: 4,
                          bottom: 4,
                        ),
                        child: Text(item, style: Get.textTheme.bodyMedium),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void showPlayerSettingsSheet() {
    Utils.showBottomSheet(
      scrollControlDisabledMaxHeightRatio: 0.7,
      title: '播放设置',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          padding: AppStyle.edgeInsetsV12,
          children: [
            const ListTile(
              title: Text('电视播放'),
              subtitle: Text('音量和亮度请使用电视遥控器调节。暂不支持画中画、截图和应用内超分。'),
            ),
            Padding(
              padding: AppStyle.edgeInsetsA12.copyWith(top: 0),
              child: Text('画面尺寸', style: Get.textTheme.titleSmall),
            ),
            SettingsCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => SettingsSwitch(
                      title: '适应',
                      value: scaleMode.value == 0,
                      onChanged: (e) {
                        updateScaleMode(0);
                      },
                    ),
                  ),
                  AppStyle.divider,
                  Obx(
                    () => SettingsSwitch(
                      title: '拉伸',
                      value: scaleMode.value == 1,
                      onChanged: (e) {
                        updateScaleMode(1);
                      },
                    ),
                  ),
                  AppStyle.divider,
                  Obx(
                    () => SettingsSwitch(
                      title: '16:9',
                      value: scaleMode.value == 3,
                      onChanged: (e) {
                        updateScaleMode(3);
                      },
                    ),
                  ),
                  AppStyle.divider,
                  Obx(
                    () => SettingsSwitch(
                      title: '4:3',
                      value: scaleMode.value == 4,
                      onChanged: (e) {
                        updateScaleMode(4);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: AppStyle.edgeInsetsA12.copyWith(top: 12),
              child: Text('播放速度', style: Get.textTheme.titleSmall),
            ),
            SettingsCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: speedsList.map((rate) {
                  return Obx(
                    () => SizedBox(
                      child: Column(
                        children: [
                          SettingsSwitch(
                            title: '${rate}X',
                            value: playerSpeed.value == rate,
                            onChanged: (e) {
                              setPlaybackSpeed(rate);
                            },
                          ),
                          AppStyle.divider,
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEpisodesSheet() {
    if (TvFocusableAction.isTV && tvPanelCoordinator != null) {
      tvPanelCoordinator!.togglePanel(TvPlayerPanel.episodes);
      return;
    }
    Utils.showRightDialog(
      title: '选集',
      width: 400,
      useSystem: true,
      child: buildEpisodesPanel(Utils.hideRightDialog),
    );
  }

  Widget buildEpisodesPanel(VoidCallback dismiss) {
    final selectedIndex = episodes.indexWhere((item) => item.sort == episode);
    return Builder(
      builder: (builder) {
        WidgetsBinding.instance.addPostFrameCallback((callback) {
          if (playListScrollController2.hasClients &&
              playListScrollController2.position.hasPixels) {
            playListScrollController2.animateTo(
              (selectedIndex < 0 ? 0.0 : selectedIndex * 100.0)
                  .clamp(
                    0.0,
                    playListScrollController2.position.maxScrollExtent,
                  )
                  .toDouble(),
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeIn,
            );
          }
        });
        return ListView(
          controller: playListScrollController2,
          children: episodes.map((item) {
            return Material(
              child: TvFocusableAction(
                autofocus: item.sort == episode ||
                    (selectedIndex < 0 && item == episodes.first),
                label: '第${item.sort}集 ${item.title}',
                onTap: () {
                  if (episode == item.sort) {
                    dismiss();
                    return;
                  }
                  rxEpisode(item.sort);
                  debugPrint('切换到第$episode集');
                  player.stop();
                  danmakuController?.clear();
                  get();
                  dismiss();
                },
                child: Obx(() {
                  return Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: episode == item.sort
                          ? Colors.grey.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 150),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomCenter,
                              // fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: item.image.isNotEmpty
                                      ? Image.network(
                                          item.image,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return noImage;
                                          },
                                        )
                                      : noImage,
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible: true,
                                        maintainSize: false,
                                        maintainSemantics: false,
                                        maintainAnimation: false,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 1,
                                            left: 5,
                                            right: 5,
                                            bottom: 3,
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.black.withAlpha(
                                              120,
                                            ),
                                          ),
                                          child: Text(
                                            item.status ? '有资源' : '无资源',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: item.duration > 0,
                                        maintainSize: false,
                                        maintainSemantics: false,
                                        maintainAnimation: false,
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                            top: 1,
                                            left: 5,
                                            right: 5,
                                            bottom: 3,
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.black.withAlpha(
                                              120,
                                            ),
                                          ),
                                          child: Text(
                                            Duration(
                                              seconds: item.duration,
                                            ).toString().split('.').first,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '第${item.sort}集 ${item.title}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 15),
                              ),
                              Opacity(
                                opacity: 0.7,
                                child: Text(
                                  Time.dateTimeFormat(item.airdate.toInt()),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                              Opacity(
                                opacity: 0.7,
                                child: Text(
                                  item.overview,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void showPlayUrlsSheet() {
    if (TvFocusableAction.isTV && tvPanelCoordinator != null) {
      tvPanelCoordinator!.togglePanel(TvPlayerPanel.lines);
      return;
    }
    final lines = buildPlayUrlsPanel(() {
      if (TvFocusableAction.isTV) {
        Utils.hideRightDialog();
      } else {
        Get.back();
      }
    });
    if (TvFocusableAction.isTV) {
      Utils.showRightDialog(
        title: '切换线路',
        width: 480,
        useSystem: true,
        child: lines,
      );
    } else {
      Utils.showBottomSheet(title: '切换线路', child: lines);
    }
  }

  Widget buildPlayUrlsPanel(VoidCallback dismiss) {
    void selectLine(int index) {
      dismiss();
      changePlayLine(index);
    }

    return SingleChildScrollView(
      child: Column(
        children: List.generate(playUrls.length, (i) {
          final tile = RadioListTile<int>(
            value: i,
            groupValue: currentLineIndex,
            title: Text('线路${i + 1}'),
            subtitle: Text(urlDecode(playUrls[i].url)),
            secondary: Text(playUrls[i].caption),
            onChanged: (_) => selectLine(i),
          );
          if (!TvFocusableAction.isTV) return tile;
          return Material(
            child: TvFocusableAction(
              autofocus:
                  i == currentLineIndex || (currentLineIndex < 0 && i == 0),
              label: '线路${i + 1} ${playUrls[i].caption}',
              onTap: () => selectLine(i),
              child: tile,
            ),
          );
        }),
      ),
    );
  }

  void showVolumeSlider(BuildContext targetContext) {
    SmartDialog.showToast('请使用电视遥控器调节音量');
  }

  @override
  void onClose() {
    tvPanelCoordinator?.dispose();
    tvPanelCoordinator = null;
    WidgetsBinding.instance.removeObserver(this);
    leave(true);
    _vodRequest++;
    _playRequest++;
    _danmakuRequest++;
    for (final subscription in _playbackSubscriptions) {
      unawaited(subscription.cancel());
    }
    _playbackSubscriptions.clear();
    tabController.dispose();
    animationController.dispose();
    playListScrollController.dispose();
    playListScrollController2.dispose();
    super.onClose();
  }
}
