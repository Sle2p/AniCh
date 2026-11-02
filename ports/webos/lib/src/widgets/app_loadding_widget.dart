import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/utils/app_style.dart';

class AppLoaddingWidget extends StatelessWidget {
  const AppLoaddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: AppStyle.edgeInsetsA12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).cardColor,
          boxShadow: Get.isDarkMode
              ? []
              : [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.grey.withOpacity(.2),
                  )
                ],
        ),
        child: const CupertinoActivityIndicator(
          radius: 10,
        ),
      ),
    );
  }
}
