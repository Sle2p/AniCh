import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class SettingsAction extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function()? onTap;
  final String? value;
  final Widget? leading;
  final Widget? trailing;
  final bool rightIcon;
  final Color? color;
  final bool autofocus;

  const SettingsAction({
    required this.title,
    this.value,
    this.onTap,
    this.subtitle,
    this.leading,
    this.trailing,
    this.rightIcon = true,
    this.color,
    this.autofocus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tile = ListTile(
      // visualDensity: VisualDensity.compact,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(color: color ?? color),
        // style: Theme.of(context).textTheme.bodyLarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppStyle.radius8,
      ),
      contentPadding: AppStyle.edgeInsetsL16.copyWith(right: 8),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
            ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) trailing!,
          if (value != null)
            Text(
              value!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.grey),
            ),
          AppStyle.hGap4,
          if (rightIcon)
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
        ],
      ),
      onTap: onTap,
    );
    if (!TvFocusableAction.isTV || onTap == null) return tile;
    return TvFocusableAction(
      autofocus: autofocus,
      label: title,
      onTap: onTap!,
      child: tile,
    );
  }
}
