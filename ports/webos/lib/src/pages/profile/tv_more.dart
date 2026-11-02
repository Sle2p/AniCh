import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/widgets/settings/settings_action.dart';

/// Local settings stay reachable even before signing in to an AniCh account.
class TvMorePage extends StatelessWidget {
  const TvMorePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('我的与设置')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                SettingsAction(
                  autofocus: true,
                  title: '我的 / 登录',
                  leading: const Icon(Icons.account_circle_outlined),
                  onTap: () => Get.toNamed('/profile'),
                ),
                SettingsAction(
                  title: '账号管理',
                  leading: const Icon(Icons.manage_accounts_outlined),
                  onTap: () => Get.toNamed('/account_settings'),
                ),
                SettingsAction(
                  title: '播放设置',
                  leading: const Icon(Icons.play_circle_outline),
                  onTap: () => Get.toNamed('/playback_settings'),
                ),
                SettingsAction(
                  title: '弹幕设置',
                  leading: const Icon(Icons.subtitles_outlined),
                  onTap: () => Get.toNamed('/danmaku_settings'),
                ),
                SettingsAction(
                  title: '外观设置',
                  leading: const Icon(Icons.palette_outlined),
                  onTap: () => Get.toNamed('/theme_settings'),
                ),
                const Divider(),
                SettingsAction(
                  title: '图库',
                  leading: const Icon(Icons.photo_library_outlined),
                  onTap: () => Get.toNamed('/'),
                ),
                SettingsAction(
                  title: '图片收藏',
                  leading: const Icon(Icons.collections_bookmark_outlined),
                  onTap: () => Get.toNamed('/thread_collection'),
                ),
                SettingsAction(
                  title: '关于 AniCh',
                  leading: const Icon(Icons.info_outline),
                  onTap: () => Get.toNamed('/info'),
                ),
              ],
            ),
          ),
        ),
      );
}
