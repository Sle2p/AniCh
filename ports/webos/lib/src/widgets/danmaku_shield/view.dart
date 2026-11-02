import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/widgets/danmaku_shield/storage.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/utils/utils.dart';

class DanmakuShieldView {
  static Widget builddanmakuShieldView() {
    return ListView(
      padding: AppStyle.edgeInsetsA12,
      children: [
        TextField(
          controller: DanmakuShieldStorage.textEditingController,
          decoration: InputDecoration(
            contentPadding: AppStyle.edgeInsetsH12,
            border: const OutlineInputBorder(),
            hintText: '请输入关键词或正则表达式',
            suffixIcon: TextButton.icon(
              onPressed: DanmakuShieldStorage.add,
              icon: const Icon(Icons.add),
              label: const Text('添加'),
            ),
          ),
          onSubmitted: (e) {
            DanmakuShieldStorage.add();
          },
        ),
        AppStyle.vGap4,
        Text(
          '以"/"开头和结尾将视作正则表达式, 如"/\\d+/"表示屏蔽所有数字',
          style: Get.textTheme.bodySmall,
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
                      DanmakuShieldStorage.remove(item);
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
                      child: Text(
                        item,
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  static void showDanmakuShieldBottomSheet() {
    Utils.showBottomSheet(
      title: '关键词屏蔽',
      child: builddanmakuShieldView(),
    );
  }

  static void showDanmakuShieldRightDialog() {
    Utils.showRightDialog(
      title: '关键词屏蔽',
      width: 400,
      useSystem: true,
      child: builddanmakuShieldView(),
    );
  }
}
