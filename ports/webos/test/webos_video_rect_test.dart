import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:video_player_webos/src/messages.g.dart';
import 'package:video_player_webos/src/hole.dart';
import 'package:video_player_webos/video_player_webos.dart';

void main() {
  testWidgets(
      'exported video rect follows real view DPR, keeping source pixels and Hole logical',
      (tester) async {
    const windowChannel = MethodChannel('webos/exported_windows');
    const eventChannel = MethodChannel('flutter.io/videoPlayer/videoEvents7');
    const createChannel = BasicMessageChannel<Object?>(
      'dev.flutter.pigeon.WebOsVideoPlayerApi.create',
      WebOsVideoPlayerApi.pigeonChannelCodec,
    );
    final messenger = tester.binding.defaultBinaryMessenger;
    final rectangles = <Map<Object?, Object?>>[];
    messenger.setMockMethodCallHandler(windowChannel, (call) async {
      if (call.method == 'create') return 'test-video-window';
      if (call.method == 'resize') {
        rectangles.add(Map<Object?, Object?>.from(call.arguments as Map));
      }
      return null;
    });
    messenger.setMockMethodCallHandler(eventChannel, (_) async => null);
    messenger.setMockDecodedMessageHandler<Object?>(
        createChannel, (_) async => <Object?>[TextureMessage(textureId: 7)]);
    addTearDown(() {
      messenger.setMockMethodCallHandler(windowChannel, null);
      messenger.setMockMethodCallHandler(eventChannel, null);
      messenger.setMockDecodedMessageHandler<Object?>(createChannel, null);
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final platform = VideoPlayerWebOs();
    final texture = (await platform.create(DataSource(
      sourceType: DataSourceType.network,
      uri: 'https://example.com/test.mp4',
    )))!;
    final subscription = platform.videoEventsFor(texture).listen((_) {});
    await tester.pump();
    tester.binding.channelBuffers.push(
      eventChannel.name,
      const StandardMethodCodec().encodeSuccessEnvelope({
        'event': 'initialized',
        'width': 1920,
        'height': 1080,
        'duration': 60000,
      }),
      (_) {},
    );
    await tester.pump();

    Widget videoAt(Rect rect) => Directionality(
          textDirection: TextDirection.ltr,
          // Deliberately different: native coordinates must use View's actual DPR.
          child: MediaQuery(
            data: const MediaQueryData(devicePixelRatio: 3),
            child: Stack(children: [
              Positioned.fromRect(
                  rect: rect, child: platform.buildView(texture)),
            ]),
          ),
        );

    Future<void> settleExport() async {
      // The plugin waits for its 100ms movement timer before showing the hole.
      for (var tick = 0; tick < 4; tick++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    const smallRect = Rect.fromLTWH(100, 60, 640, 360);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1920, 1080);
    await tester.pumpWidget(videoAt(smallRect));
    await settleExport();
    expect(rectangles.last['windowId'], 'test-video-window');
    expect(rectangles.last['srcRect'], [0, 0, 1920, 1080]);
    expect(rectangles.last['dstRect'], [100, 60, 640, 360]);
    expect(tester.getSize(find.byType(Hole)), smallRect.size);

    final previousCount = rectangles.length;
    // Keep the identical logical widget and layout; only view metrics change.
    tester.view.devicePixelRatio = 2;
    tester.view.physicalSize = const Size(3840, 2160);
    await settleExport();
    expect(rectangles.length, greaterThan(previousCount));
    expect(rectangles.last['srcRect'], [0, 0, 1920, 1080]);
    expect(rectangles.last['dstRect'], [200, 120, 1280, 720]);
    expect(tester.getSize(find.byType(Hole)), smallRect.size);

    await tester.pumpWidget(videoAt(const Rect.fromLTWH(0, 0, 1920, 1080)));
    await settleExport();
    expect(rectangles.last['srcRect'], [0, 0, 1920, 1080]);
    expect(rectangles.last['dstRect'], [0, 0, 3840, 2160]);
    expect(tester.getSize(find.byType(Hole)), const Size(1920, 1080));
    // Returning to the standard render mode must keep full-screen video full.
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1920, 1080);
    await settleExport();
    expect(rectangles.last['srcRect'], [0, 0, 1920, 1080]);
    expect(rectangles.last['dstRect'], [0, 0, 1920, 1080]);
    expect(tester.getSize(find.byType(Hole)), const Size(1920, 1080));
    await tester.pumpWidget(const SizedBox.shrink());
    // EventChannel cancellation waits for a platform-channel reply; let that
    // reply complete outside the widget test's fake clock.
    await tester.runAsync(() => subscription.cancel());
  });
}
