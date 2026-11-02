import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/search/models/search_type.dart';
import 'package:xs/src/widgets/navbar.dart';

/// Persistent entry points when the TV starts directly in the anime library.
class TvAppNavigation extends StatelessWidget {
  const TvAppNavigation({super.key});

  @override
  Widget build(BuildContext context) => NavBar(children: [
        NavItem(
          icon: Icons.search,
          title: '搜索',
          onTap: () => Get.toNamed('/search_panel',
              arguments: {'type': SearchType.bangumi}),
        ),
        NavItem(
          icon: Icons.calendar_month_outlined,
          title: '每日放送',
          onTap: () => Get.toNamed('/calendar'),
        ),
        NavItem(
          icon: Icons.favorite_outline,
          title: '追番',
          onTap: () => Get.toNamed('/bangumi_collection'),
        ),
        NavItem(
          icon: Icons.history,
          title: '观看记录',
          onTap: () => Get.toNamed('/play_history'),
        ),
        NavItem(
          icon: Icons.person_outline,
          title: '我的与设置',
          onTap: () => Get.toNamed('/tv_more'),
        ),
      ]);
}
