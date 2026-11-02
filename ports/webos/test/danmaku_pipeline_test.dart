import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xs/protobuf/bangumi.pb.dart';
import 'package:xs/protobuf/danmaku.pb.dart';
import 'package:xs/src/apis/bangumi.dart' as api;
import 'package:xs/src/pages/bangumi_vod/controller.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_controller.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_item.dart';
import 'package:xs/src/widgets/player/webos_player.dart';

class _Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  late Future<ResponseBody> Function(RequestOptions) respond;
  @override
  Future<ResponseBody> fetch(RequestOptions options,
      Stream<Uint8List>? requestStream, Future<void>? cancelFuture) {
    requests.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _bytes(List<int> bytes) =>
    ResponseBody.fromBytes(bytes, 200, headers: {
      Headers.contentTypeHeader: ['application/octet-stream']
    });

data_ _comment(String id, {String from = '', String text = 'same phrase'}) =>
    data_(id: id, from: from, text: text, time: 0.5, color: '#ffffff', type: 1);

class _Streams extends PlayerStreams {
  final positions = StreamController<Duration>.broadcast(sync: true);
  @override
  Stream<Duration> get position => positions.stream;
  @override
  Future<void> close() async {
    await positions.close();
    await super.close();
  }
}

class _Player extends Player {
  @override
  final _Streams stream = _Streams();
}

class _Controller extends BangumiVodPageController {
  _Controller() : super(pId: 39419, pEpisode: 1);
  @override
  final _Player player = _Player();
  final emitted = <DanmakuItem>[];
  int clears = 0;
  @override
  Future<void> getPlayUrl() async {}

  void startListening() {
    listen();
    showDanmakuState.value = true;
    bilibiliDanmakuState.value = true;
    bilibiliHmtDanmakuState.value = true;
    qqDanmakuState.value = true;
    danmakuController = DanmakuController(
      onAddItems: emitted.addAll,
      onUpdateOption: (_) {},
      onPause: () {},
      onResume: () {},
      onClear: () => clears++,
    );
  }

  void position(int milliseconds) =>
      player.stream.positions.add(Duration(milliseconds: milliseconds));

  Future<void> closeTest() async {
    leave.value = true;
    await player.stream.close();
    player.changes.dispose();
    textEditingController.dispose();
    danmakuTextFieldFocusNode.dispose();
    playListScrollController.dispose();
    playListScrollController2.dispose();
  }
}

class _NativeController extends _Controller {
  final pulls = <Future<void>>[];
  @override
  Future<void> getDanmaku() {
    final pending = super.getDanmaku();
    pulls.add(pending);
    return pending;
  }

  @override
  Future<void> getBilibiliDanmaku() async {}
  @override
  Future<void> getBilibiliHmtDanmaku() async {}
  @override
  Future<void> getQQDanmaku() async {}
}

Future<void> _waitRequests(_Adapter adapter, int count) async {
  for (var attempt = 0;
      attempt < 100 && adapter.requests.length < count;
      attempt++) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  expect(adapter.requests, hasLength(count));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late HttpClientAdapter nativeOriginal;
  late HttpClientAdapter biliOriginal;
  late _Adapter native;
  late _Adapter bili;
  final controllers = <_Controller>[];

  setUp(() {
    nativeOriginal = api.api.httpClientAdapter;
    biliOriginal = api.bilibiliApiProxy.httpClientAdapter;
    native = _Adapter();
    bili = _Adapter();
    api.api.httpClientAdapter = native;
    api.bilibiliApiProxy.httpClientAdapter = bili;
  });
  tearDown(() async {
    api.api.httpClientAdapter = nativeOriginal;
    api.bilibiliApiProxy.httpClientAdapter = biliOriginal;
    for (final controller in controllers) {
      await controller.closeTest();
    }
    controllers.clear();
  });

  test('server cursor loads a short page and merges mirrors across pages',
      () async {
    final controller = _NativeController();
    controllers.add(controller);
    final imported = _comment('import', from: 'gamer_50830741');
    final distinct = _comment('another-person', from: 'gamer_50830742');
    native.respond = (request) async => _bytes(danmaku_(
          data: request.queryParameters['skip'] == 0
              ? [imported, imported, distinct]
              : [_comment('mirror')],
          skip: request.queryParameters['skip'] == 0 ? 3000 : 0,
        ).writeToBuffer());
    await controller.getDanmaku();
    expect(native.requests.map((r) => r.queryParameters['skip']), [0, 3000]);
    expect(controller.danmakuList, hasLength(3));
    controller.startListening();
    controller.position(500);
    // One import/mirror pair disappears; another person's same text remains.
    expect(controller.emitted, hasLength(2));
    controller.position(500);
    controller.position(600);
    expect(controller.emitted, hasLength(2));
    controller.position(100);
    controller.position(500);
    expect(controller.emitted, hasLength(4), reason: 'Seeking permits replay');
    expect(controller.clears, 1);
  });

  test('the photographed 8:43 scene emits each imported mirror only once',
      () async {
    final controller = _NativeController();
    controllers.add(controller);
    // Public response shape from episode 1 of title 39419. IDs/source IDs are
    // anonymized; text, timestamp and visual fields match the photographed case.
    data_ entry(String id, String text, double time, {String from = ''}) =>
        data_(id: id, text: text, time: time, from: from, type: 1, color: '');
    native.respond = (_) async => _bytes(danmaku_(data: [
          entry('first-import', '一直装............', 519.3, from: 'gamer_101'),
          entry('first-mirror', '一直装............', 519.3),
          entry('unique', '献祭理科就行了', 520.1),
          entry('second-import', '舍弃理科脑就对了', 521.4, from: 'gamer_102'),
          entry('second-mirror', '舍弃理科脑就对了', 521.4),
        ], skip: 0)
            .writeToBuffer());
    await controller.getDanmaku();
    controller.startListening();
    for (final position in [519000, 519500, 520500, 521500, 523000]) {
      controller.position(position);
    }
    expect(controller.emitted.map((item) => item.text), [
      '一直装............',
      '献祭理科就行了',
      '舍弃理科脑就对了',
    ]);
  });

  test('a non-increasing server cursor cannot loop forever', () async {
    final controller = _NativeController();
    controllers.add(controller);
    native.respond = (request) async => _bytes(danmaku_(
          data: [_comment('id-${request.queryParameters['skip']}')],
          skip: 3000,
        ).writeToBuffer());
    await controller.getDanmaku();
    expect(native.requests, hasLength(2));
    expect(controller.danmakuList, hasLength(2));
  });

  test('A to B to A rejects both old responses after the new A is loaded',
      () async {
    final controller = _NativeController();
    controllers.add(controller);
    final replies = List.generate(3, (_) => Completer<ResponseBody>());
    var received = 0;
    native.respond = (_) => replies[received++].future;
    controller.get();
    await _waitRequests(native, 1);
    controller.rxEpisode.value = 2;
    controller.get();
    await _waitRequests(native, 2);
    controller.rxEpisode.value = 1;
    controller.get();
    await _waitRequests(native, 3);
    for (final index in [2, 0, 1]) {
      replies[index].complete(_bytes(danmaku_(
        data: [_comment('request-$index')],
        skip: 0,
      ).writeToBuffer()));
      await controller.pulls[index];
    }
    expect(controller.danmakuList.map((item) => item.id), ['request-2']);
    expect(native.requests.map((r) => r.queryParameters['episode']), [1, 2, 1]);
  });

  test('leaving before a pending response prevents appending its comments',
      () async {
    final controller = _NativeController();
    controllers.add(controller);
    final reply = Completer<ResponseBody>();
    native.respond = (_) => reply.future;
    final pending = controller.getDanmaku();
    await _waitRequests(native, 1);
    controller.leave.value = true;
    reply.complete(
        _bytes(danmaku_(data: [_comment('late')], skip: 0).writeToBuffer()));
    await pending;
    expect(controller.danmakuList, isEmpty);
  });

  test('same CID emits once across regions but preserves full distinct IDs',
      () async {
    final controller = _Controller();
    controllers.add(controller);
    controller.episodes = [
      bangumi_episodes_data_(sort: 1, sites: [
        bangumi_episodes_sites_(site: 'bili_cid', id: '501'),
        bangumi_episodes_sites_(site: 'bili_hmt_cid', id: '501'),
      ])
    ];
    bilibili_danmaku_item_ entry(String id) => bilibili_danmaku_item_(
          id: 7,
          idStr: id,
          progress: 500,
          mode: 1,
          color: 0xffffff,
          content: 'same phrase',
          midHash: 'viewer',
        );
    bili.respond = (request) async => _bytes(bilibili_danmaku_(
          list: request.queryParameters['segment_index'] == 1
              ? [entry('4294967303'), entry('4294967303'), entry('8589934599')]
              : [],
        ).writeToBuffer());
    await Future.wait([
      controller.getBilibiliDanmaku(),
      controller.getBilibiliHmtDanmaku(),
    ]);
    expect(controller.bilibiliDanmakuList, hasLength(2));
    expect(controller.bilibiliHmtDanmakuList, hasLength(2));
    controller.startListening();
    controller.position(500);
    expect(controller.emitted, hasLength(2));
    controller.position(100);
    controller.bilibiliDanmakuState.value = false;
    controller.position(500);
    expect(controller.emitted, hasLength(4),
        reason: 'HMT remains usable when the mainland source is disabled');
  });

  test('leaving during the source delay issues no request for another episode',
      () async {
    final controller = _Controller();
    controllers.add(controller);
    controller.episodes = [
      bangumi_episodes_data_(sort: 2, sites: [
        bangumi_episodes_sites_(site: 'bili_cid', id: '502'),
      ])
    ];
    final pending = controller.getBilibiliDanmaku();
    controller.rxEpisode.value = 2;
    await pending;
    expect(bili.requests, isEmpty);
  });
}
