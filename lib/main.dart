import 'dart:io';
import 'dart:ui';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:media_kit/media_kit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xs/src/apis/account.dart';
import 'package:xs/src/config.dart';
import 'package:xs/src/pages/settings/storage/play_history_storage.dart';
import 'package:xs/src/pages/settings/storage/theme_storage.dart';
import 'package:xs/src/widgets/danmaku_settings/storage.dart';
import 'package:xs/src/widgets/danmaku_shield/storage.dart';
import 'package:xs/src/router.dart';
import 'package:xs/src/utils/listen_fourth_button.dart';
import 'package:xs/src/utils/log.dart';
import 'package:xs/src/utils/utils.dart';
import 'package:xs/src/widgets/app_loadding_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await GetStorage.init();
  await GetStorage.init('playHistory');
  await initWindow();
  Utils.packageInfo = await PackageInfo.fromPlatform();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // 状态栏透明
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  // 图片缓存
  PaintingBinding.instance.imageCache.maximumSize = 1000000;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 300 << 20;
  // 配置初始化
  AppConfig.init();
  // 主题初始化
  ThemeSettingsStorage.init();
  // 历史记录初始化
  PlayHistoryStorage.init();
  // 弹幕设置初始化
  DanmakuSettingsStorage.init();
  // 初始化弹幕屏蔽词
  DanmakuShieldStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // 检测更新
    Utils.checkUpdate();
    // 获取用户信息
    final box = GetStorage();
    final token = box.read('token');
    if (token != null) {
      AccountApi.init();
    }
    bool isDynamicColor = ThemeSettingsStorage.isDynamic.value;
    Color styleColor = Color(ThemeSettingsStorage.styleColor.value);
    // const defaultDarkColorScheme = ColorScheme.dark();
    return DynamicColorBuilder(
        builder: (lightDynamicColorScheme, darkDynamicColorScheme) {
      ColorScheme? lightColorScheme;
      ColorScheme? darkColorScheme;
      if (lightDynamicColorScheme != null &&
          darkDynamicColorScheme != null &&
          isDynamicColor) {
        lightColorScheme = lightDynamicColorScheme;
        darkColorScheme = darkDynamicColorScheme;
      } else {
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: styleColor,
          brightness: Brightness.light,
        );
        darkColorScheme = ColorScheme.fromSeed(
            seedColor: styleColor, brightness: Brightness.dark);
      }
      return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.values[ThemeSettingsStorage.themeMode.value],
          theme: ThemeData(
              fontFamily: 'Ubuntu',
              brightness: Brightness.light,
              colorScheme: lightColorScheme,
              // splashColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              useMaterial3: true),
          darkTheme: ThemeData(
              fontFamily: 'Ubuntu',
              brightness: Brightness.dark,
              colorScheme: darkColorScheme,
              // splashColor: Colors.black,
              scaffoldBackgroundColor: Colors.black,
              useMaterial3: true),
          initialRoute: '/',
          getPages: AppRoute.pages,
          defaultTransition: Transition.noTransition,
          scrollBehavior: AppScrollBehavior(),
          logWriterCallback: (text, {bool? isError}) {
            Log.addDebugLog(
                text, (isError ?? false) ? Colors.red : Colors.grey);
            Log.writeLog(text, (isError ?? false) ? Level.error : Level.info);
          },
          navigatorObservers: [FlutterSmartDialog.observer],
          builder: FlutterSmartDialog.init(
            loadingBuilder: ((msg) => const AppLoaddingWidget()),
            //字体大小不跟随系统变化
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: Stack(
                children: [
                  //侧键返回
                  RawGestureDetector(
                    excludeFromSemantics: true,
                    gestures: <Type, GestureRecognizerFactory>{
                      FourthButtonTapGestureRecognizer:
                          GestureRecognizerFactoryWithHandlers<
                              FourthButtonTapGestureRecognizer>(
                        () => FourthButtonTapGestureRecognizer(),
                        (FourthButtonTapGestureRecognizer instance) {
                          instance.onTapDown = (TapDownDetails details) async {
                            //如果处于全屏状态，退出全屏
                            if (!Platform.isAndroid && !Platform.isIOS) {
                              if (await windowManager.isFullScreen()) {
                                await windowManager.setFullScreen(false);
                                return;
                              }
                            }
                            Get.back();
                          };
                        },
                      ),
                    },
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (KeyEvent event) async {
                        if (event is KeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.escape) {
                          // ESC退出全屏
                          // 如果处于全屏状态，退出全屏
                          if (!Platform.isAndroid && !Platform.isIOS) {
                            if (await windowManager.isFullScreen()) {
                              await windowManager.setFullScreen(false);
                              return;
                            }
                          }
                        }
                      },
                      child: child!,
                    ),
                  ),
                ],
              ),
            ),
          ));
    });
  }
}

// 鼠标、触控板滑动
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        // 桌面端允许鼠标拖动列表滚动
        ...super.dragDevices,
        PointerDeviceKind.mouse,
      };
}

Future initWindow() async {
  if (!(Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    return;
  }
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
      size: Size(600, 800),
      title: '像宿',
      titleBarStyle: TitleBarStyle.hidden,
      skipTaskbar: false,
      windowButtonVisibility: false);
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
