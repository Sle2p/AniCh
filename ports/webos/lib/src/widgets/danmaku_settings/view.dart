import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/widgets/danmaku_settings/storage.dart';
import 'package:xs/src/widgets/danmaku_shield/view.dart';
import 'package:xs/src/widgets/ns_danmaku/danmaku_controller.dart';
import 'package:xs/src/widgets/ns_danmaku/models/danmaku_option.dart';
import 'package:xs/src/widgets/player/controller.dart';
import 'package:xs/src/widgets/settings/settings_action.dart';
import 'package:xs/src/widgets/settings/settings_card.dart';
import 'package:xs/src/widgets/settings/settings_number.dart';
import 'package:xs/src/widgets/settings/settings_switch.dart';

class DanmakuSettingsPage extends StatelessWidget {
  const DanmakuSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('弹幕设置'),
      ),
      body: ListView(
        padding: AppStyle.edgeInsetsA12,
        children: const [
          DanmakuSettingsView(),
        ],
      ),
    );
  }
}

class DanmakuSettingsView extends StatelessWidget {
  final Function()? onTapDanmakuShield;
  final PlayerController? playerController;
  final DanmakuController? danmakuController;
  const DanmakuSettingsView({
    this.onTapDanmakuShield,
    this.danmakuController,
    this.playerController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: AppStyle.edgeInsetsA12.copyWith(top: 0),
          child: Text(
            '弹幕屏蔽',
            style: Get.textTheme.titleSmall,
          ),
        ),
        SettingsCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingsAction(
                title: '关键词屏蔽',
                onTap: onTapDanmakuShield ??
                    () {
                      DanmakuShieldView.showDanmakuShieldRightDialog();
                    },
              ),
            ],
          ),
        ),
        Padding(
          padding: AppStyle.edgeInsetsA12.copyWith(top: 12),
          child: Text(
            '弹幕设置',
            style: Get.textTheme.titleSmall,
          ),
        ),
        SettingsCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => SettingsSwitch(
                  title: '默认开关',
                  value: DanmakuSettingsStorage.danmakuEnable.value,
                  onChanged: (e) {
                    playerController?.showDanmakuState.value = e;
                    DanmakuSettingsStorage.setDanmakuEnable(e);
                  },
                ),
              ),
              AppStyle.divider,
              Obx(
                () => SettingsNumber(
                  title: '显示区域',
                  value:
                      (DanmakuSettingsStorage.danmakuArea.value * 100).toInt(),
                  min: 10,
                  max: 100,
                  step: 10,
                  unit: '%',
                  onChanged: (e) {
                    DanmakuSettingsStorage.setDanmakuArea(e / 100.0);
                    updateDanmakuOption(
                      danmakuController?.option.copyWith(area: e / 100.0),
                    );
                  },
                ),
              ),
              AppStyle.divider,
              Obx(
                () => SettingsNumber(
                  title: '不透明度',
                  value: (DanmakuSettingsStorage.danmakuOpacity.value * 100)
                      .toInt(),
                  min: 10,
                  max: 100,
                  step: 10,
                  unit: '%',
                  onChanged: (e) {
                    DanmakuSettingsStorage.setDanmakuOpacity(e / 100.0);
                    updateDanmakuOption(
                      danmakuController?.option.copyWith(opacity: e / 100.0),
                    );
                  },
                ),
              ),
              AppStyle.divider,
              Obx(
                () => SettingsNumber(
                  title: '字体大小',
                  value: DanmakuSettingsStorage.danmakuSize.toInt(),
                  min: 8,
                  max: 48,
                  onChanged: (e) {
                    DanmakuSettingsStorage.setDanmakuSize(e.toDouble());
                    updateDanmakuOption(
                      danmakuController?.option
                          .copyWith(fontSize: e.toDouble()),
                    );
                  },
                ),
              ),
              AppStyle.divider,
              Obx(
                () => SettingsNumber(
                  title: '滚动速度',
                  subtitle: '弹幕持续时间(秒)，越小速度越快',
                  value: DanmakuSettingsStorage.danmakuSpeed.toInt(),
                  min: 4,
                  max: 20,
                  onChanged: (e) {
                    DanmakuSettingsStorage.setDanmakuSpeed(e.toDouble());
                    updateDanmakuOption(
                      danmakuController?.option
                          .copyWith(duration: e.toDouble()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: AppStyle.edgeInsetsA12.copyWith(top: 12),
          child: Text(
            '外部弹幕',
            style: Get.textTheme.titleSmall,
          ),
        ),
        SettingsCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => SettingsSwitch(
                  title: '哔哩哔哩弹幕',
                  value: DanmakuSettingsStorage.bilibiliDanmakuEnable.value,
                  onChanged: (e) {
                    playerController?.bilibiliDanmakuState.value = e;
                    DanmakuSettingsStorage.setBilibiliDanmakuEnable(e);
                  },
                ),
              ),
              AppStyle.divider,
              Obx(
                () => SettingsSwitch(
                  title: '哔哩哔哩(港澳台)弹幕',
                  value: DanmakuSettingsStorage.bilibiliHmtDanmakuEnable.value,
                  onChanged: (e) {
                    playerController?.bilibiliHmtDanmakuState.value = e;
                    DanmakuSettingsStorage.setBilibiliHmtDanmakuEnable(e);
                  },
                ),
              ),
              AppStyle.divider,
              Obx(
                () => SettingsSwitch(
                  title: '腾讯视频弹幕',
                  value: DanmakuSettingsStorage.qqDanmakuEnable.value,
                  onChanged: (e) {
                    playerController?.qqDanmakuState.value = e;
                    DanmakuSettingsStorage.setQQDanmakuEnable(e);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void updateDanmakuOption(DanmakuOption? option) {
    if (danmakuController == null || option == null) return;
    danmakuController!.updateOption(option);
  }
}
