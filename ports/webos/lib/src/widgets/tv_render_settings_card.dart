import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/tv_render_settings.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class TvRenderSettingsCard extends StatefulWidget {
  const TvRenderSettingsCard({super.key});

  @override
  State<TvRenderSettingsCard> createState() => _TvRenderSettingsCardState();
}

class _TvRenderSettingsCardState extends State<TvRenderSettingsCard>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (mounted) setState(() {});
  }

  Future<void> _save(int value) async {
    if (TvRenderSettings.isSaving.value) return;
    String message;
    try {
      await TvRenderSettings.setScale(value);
      message = '已保存，请完全关闭应用后重新打开';
    } catch (_) {
      message = '保存失败，请重试';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final size = view.physicalSize;
    final width = size.width.round();
    final height = size.height.round();
    final currentMode = width == 3840 && height == 2160
        ? '高采样绘制（4K）'
        : width == 1920 && height == 1080
            ? '标准绘制（1080p）'
            : '其他绘制尺寸';
    final previewStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w400,
        );
    return SettingsCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('界面清晰度对比',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('当前绘制：$currentMode'),
                  Text(
                      'Flutter 绘制尺寸：$width × $height 像素 · DPR ${view.devicePixelRatio}'),
                  const Text('需完全关闭应用后重新打开；返回首页或切换到电视主页不会立即生效。'),
                ],
              ),
            ),
            Obx(() => Column(children: [
                  for (final entry in const {
                    1: '标准绘制（1080p）',
                    2: '高采样绘制（4K）',
                  }.entries)
                    TvFocusableAction(
                      label: entry.value,
                      onTap: () => _save(entry.key),
                      child: RadioListTile<int>(
                        value: entry.key,
                        groupValue: TvRenderSettings.selectedScale.value,
                        title: Text(entry.value),
                        subtitle: Text('番剧搜索 播放设置 AniCh 0123456789',
                            style: previewStyle),
                        onChanged: TvRenderSettings.isSaving.value
                            ? null
                            : (value) {
                                if (value != null) _save(value);
                              },
                      ),
                    ),
                  if (TvRenderSettings.isSaving.value)
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('正在保存…'),
                    ),
                ])),
          ],
        ),
      ),
    );
  }
}
