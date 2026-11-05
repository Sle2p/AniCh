import 'package:flutter/material.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class NavItem {
  const NavItem({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final Function onTap;
  final String title;
}

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.children});
  final List<NavItem> children;

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return _navBar();
  }

  Widget _navBar() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          // width: 200,
          // height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          margin:
              const EdgeInsets.only(top: 25, right: 25, left: 25, bottom: 25),
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withAlpha(10),
                    spreadRadius: 10)
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.children.map((item) {
              // bool isSelected = Get.currentRoute == item.name;
              final content = SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(item.icon, color: Colors.grey),
                    ),
                    Text(item.title,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: TvFocusableAction.isTV ? 14 : 10)),
                  ],
                ),
              );
              return Material(
                color: Colors.transparent,
                child: TvFocusableAction.isTV
                    ? TvFocusableAction(
                        label: item.title,
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => item.onTap(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: content,
                        ),
                      )
                    : InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () => item.onTap(),
                        child: content,
                      ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
