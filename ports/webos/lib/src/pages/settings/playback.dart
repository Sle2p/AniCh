import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/settings/storage/playback_storage.dart';
import 'package:xs/src/widgets/settings/settings_action.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';
import 'package:xs/src/widgets/settings/settings_switch.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class PlaybackSettingsPage extends StatelessWidget {
  const PlaybackSettingsPage({super.key});

  Future<void> _save(Future<void> operation) async {
    try {
      await operation;
    } catch (_) {
      SmartDialog.showToast('播放设置未能保存，请稍后重试');
    }
  }

  Future<void> _choose<T>(
    BuildContext context, {
    required String title,
    required Map<T, String> options,
    required T current,
    required Future<void> Function(T) onSelected,
  }) async {
    final selected = await showDialog<T>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.entries.map((entry) {
                void select() => Navigator.of(dialogContext).pop(entry.key);
                return TvFocusableAction(
                  autofocus: entry.key == current,
                  label: entry.value,
                  onTap: select,
                  child: ListTile(
                    title: Text(entry.value),
                    trailing:
                        entry.key == current ? const Icon(Icons.check) : null,
                    onTap: select,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    if (selected != null) await _save(onSelected(selected));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('播放设置')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 16),
                  child: Text('设置保存在这台电视。默认倍速和画面尺寸在下次打开播放页时应用。'),
                ),
                SettingsCard(
                  child: Obx(() => Column(children: [
                        SettingsAction(
                          autofocus: true,
                          title: '默认倍速',
                          value:
                              '${PlaybackSettingsStorage.defaultSpeed.value} 倍',
                          onTap: () => _choose<double>(
                            context,
                            title: '默认倍速',
                            options: {
                              for (final speed
                                  in PlaybackSettingsStorage.speedOptions)
                                speed: '$speed 倍',
                            },
                            current: PlaybackSettingsStorage.defaultSpeed.value,
                            onSelected: PlaybackSettingsStorage.setDefaultSpeed,
                          ),
                        ),
                        SettingsAction(
                          title: '默认画面尺寸',
                          value: PlaybackSettingsStorage.scaleOptions[
                              PlaybackSettingsStorage.defaultScaleMode.value],
                          onTap: () => _choose<int>(
                            context,
                            title: '默认画面尺寸',
                            options: PlaybackSettingsStorage.scaleOptions,
                            current:
                                PlaybackSettingsStorage.defaultScaleMode.value,
                            onSelected:
                                PlaybackSettingsStorage.setDefaultScaleMode,
                          ),
                        ),
                        SettingsAction(
                          title: '向左快退',
                          value:
                              '${PlaybackSettingsStorage.seekBackwardSeconds.value} 秒',
                          onTap: () => _choose<int>(
                            context,
                            title: '向左快退',
                            options: {
                              for (final seconds
                                  in PlaybackSettingsStorage.seekOptions)
                                seconds: '$seconds 秒',
                            },
                            current: PlaybackSettingsStorage
                                .seekBackwardSeconds.value,
                            onSelected:
                                PlaybackSettingsStorage.setSeekBackwardSeconds,
                          ),
                        ),
                        SettingsAction(
                          title: '向右快进',
                          value:
                              '${PlaybackSettingsStorage.seekForwardSeconds.value} 秒',
                          onTap: () => _choose<int>(
                            context,
                            title: '向右快进',
                            options: {
                              for (final seconds
                                  in PlaybackSettingsStorage.seekOptions)
                                seconds: '$seconds 秒',
                            },
                            current: PlaybackSettingsStorage
                                .seekForwardSeconds.value,
                            onSelected:
                                PlaybackSettingsStorage.setSeekForwardSeconds,
                          ),
                        ),
                      ])),
                ),
                const SizedBox(height: 20),
                SettingsCard(
                  child: Obx(() => Column(children: [
                        SettingsSwitch(
                          title: '自动连播',
                          subtitle: '本集播完后播放下一集；最后一集停留在当前页面',
                          value: PlaybackSettingsStorage.autoNext.value,
                          onChanged: (value) =>
                              _save(PlaybackSettingsStorage.setAutoNext(value)),
                        ),
                        SettingsSwitch(
                          title: '自动换线',
                          subtitle: '播放失败时尝试其他线路，每次最多自动切换 4 次',
                          value: PlaybackSettingsStorage.autoSwitchLine.value,
                          onChanged: (value) => _save(
                              PlaybackSettingsStorage.setAutoSwitchLine(value)),
                        ),
                        SettingsSwitch(
                          title: '自动全屏',
                          subtitle: '打开播放页并开始播放后自动进入全屏',
                          value: PlaybackSettingsStorage.autoFullScreen.value,
                          onChanged: (value) => _save(
                              PlaybackSettingsStorage.setAutoFullScreen(value)),
                        ),
                        SettingsSwitch(
                          title: '线路记忆',
                          subtitle: '按番剧记住成功播放的来源，切集和再次观看时优先使用',
                          value: PlaybackSettingsStorage.rememberLine.value,
                          onChanged: (value) => _save(
                              PlaybackSettingsStorage.setRememberLine(value)),
                        ),
                      ])),
                ),
              ],
            ),
          ),
        ),
      );
}
