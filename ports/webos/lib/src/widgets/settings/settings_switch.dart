import 'package:flutter/material.dart';
import 'package:xs/src/utils/app_style.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class SettingsSwitch extends StatelessWidget {
  final bool value;
  final String title;
  final String? subtitle;
  final Function(bool) onChanged;
  const SettingsSwitch({
    required this.value,
    required this.title,
    this.subtitle,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tile = SwitchListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppStyle.radius8,
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      //visualDensity: VisualDensity.compact,
      contentPadding: AppStyle.edgeInsetsL16.copyWith(right: 8),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.grey),
            )
          : null,
      value: value,
      onChanged: onChanged,
    );
    if (!TvFocusableAction.isTV) return tile;
    return TvFocusableAction(
      label: title,
      onTap: () => onChanged(!value),
      child: tile,
    );
  }
}
