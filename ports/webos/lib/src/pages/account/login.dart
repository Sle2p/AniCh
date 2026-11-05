import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xs/src/pages/account/controller.dart';
import 'package:xs/src/widgets/navbar.dart';
import 'package:xs/src/widgets/tv_focusable_action.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userKey = GlobalKey<FormState>();
    final passwordKey = GlobalKey<FormState>();
    return GetBuilder(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            extendBody: true,
            key: const PageStorageKey<String>('login'),
            appBar: AppBar(
                title: const Text('登录'),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                automaticallyImplyLeading: false),
            body: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Form(
                      key: userKey,
                      child: Focus(
                        skipTraversal: true,
                        onFocusChange: (value) {
                          if (!value) {
                            userKey.currentState?.validate();
                          }
                        },
                        child: TextFormField(
                          autofocus: TvFocusableAction.isTV,
                          textInputAction: TextInputAction.next,
                          initialValue: controller.user.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入邮箱地址或用户ID';
                            }
                            if (!value.isEmail && int.tryParse(value) == null) {
                              return '邮箱地址或用户ID格式错误';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.user(value);
                          },
                          decoration: const InputDecoration(
                              labelText: '邮箱地址/ID',
                              hintText: '请输入邮箱地址或用户ID',
                              isCollapsed: false,
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: passwordKey,
                      child: Focus(
                        skipTraversal: true,
                        onFocusChange: (value) {
                          if (!value) {
                            passwordKey.currentState?.validate();
                          }
                        },
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          initialValue: controller.password.value,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入密码';
                            }
                            if (value.length < 6) {
                              return '密码格式错误';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.password(value);
                          },
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: '密码',
                              hintText: '请输入密码',
                              isCollapsed: false,
                              contentPadding: EdgeInsets.only(
                                  top: 0, bottom: 0, left: 0, right: 0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 30,
                      child: FilledButton(
                          onPressed: () async {
                            if (!userKey.currentState!.validate() ||
                                !passwordKey.currentState!.validate()) {
                              return;
                            }
                            final data = await controller.login();
                            if (data?.error == false) {
                              Get.back();
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 100, right: 100),
                                content: Text('账号或密码错误，请重试'),
                              ));
                            }
                          },
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          child: const Text('登录')),
                    ),
                    SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.offAndToNamed('/change_password');
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.all(0)),
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: const Text('修改密码')),
                            TextButton(
                                onPressed: () {
                                  Get.offAndToNamed('/register');
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.all(0)),
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: const Text('注册'))
                          ],
                        ))
                  ],
                ),
              ),
            ),
            bottomNavigationBar: NavBar(
              children: [
                NavItem(
                    icon: Icons.arrow_back,
                    title: '返回',
                    onTap: () => Get.back()),
              ],
            ),
          );
        });
  }
}
