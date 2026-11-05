import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/search/models/search_type.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar(
      {super.key, this.placeholder = '搜索', required this.searchType});

  final String placeholder;
  final SearchType searchType;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    void openSearch() =>
        Get.toNamed('/search_panel', arguments: {'type': searchType});
    final content = Row(
      children: [
        const SizedBox(width: 14),
        Icon(Icons.search_outlined, color: colorScheme.onSecondaryContainer),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            placeholder,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: DefaultTextStyle.of(context).style.color),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
    return Expanded(
      child: Container(
        // width: 250,
        height: 35,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Material(
          color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(
              max(
                  (DefaultTextStyle.of(context).style.color?.opacity ?? 1.0) -
                      0.9,
                  0.0)),
          child: TvFocusableAction.isTV
              ? TvFocusableAction(
                  autofocus: true,
                  label: placeholder,
                  borderRadius: BorderRadius.circular(25),
                  onTap: openSearch,
                  child: content,
                )
              : InkWell(
                  splashColor: colorScheme.primaryContainer.withOpacity(0.3),
                  onTap: openSearch,
                  child: content,
                ),
        ),
      ),
    );
  }
}
