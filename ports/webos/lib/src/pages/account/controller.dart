import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/protobuf/account.pb.dart';
import 'package:xs/src/apis/account.dart';
import 'package:xs/src/middlewares/auth.dart';

class LoginController extends GetxController with StateMixin {
  final box = GetStorage();
  final user = ''.obs;
  final password = ''.obs;
  SmartDialogController smartDialogController = SmartDialogController();

  Future<login_?> login() async {
    SmartDialog.showLoading();
    change(null, status: RxStatus.loading());
    try {
      final response =
          await AccountApi.login(user: user.value, password: password.value);
      if (response.statusCode != 200) {
        change(null, status: RxStatus.error('登录失败，请重试'));
        return null;
      }
      final data = login_.fromBuffer(response.data);
      final userData = jsonDecode(jsonEncode(data.body.user.toProto3Json()));
      if (data.error ||
          !data.hasBody() ||
          !data.body.hasUser() ||
          !AuthMiddleware.isValidSession(data.body.token, userData)) {
        change(null, status: RxStatus.error('登录失败，请检查账号和密码'));
        return null;
      }
      await box.write('user', userData);
      await box.write('token', data.body.token);
      change(data, status: RxStatus.success());
      return data;
    } catch (e) {
      change(null, status: RxStatus.error('error'));
      debugPrint('登录请求失败：${e.runtimeType}');
      return null;
    } finally {
      await SmartDialog.dismiss(status: SmartStatus.loading);
    }
  }
}

class RegisterController extends GetxController with StateMixin {
  final box = GetStorage();
  final email = ''.obs;
  final code = ''.obs;
  final name = ''.obs;
  final password = ''.obs;

  Future<bool> getCode() async {
    change(false, status: RxStatus.loading());
    try {
      final response = await AccountApi.getCode(email: email.value);
      if (response.statusCode != 200) {
        change(false, status: RxStatus.error('error'));
      } else {
        change(true, status: RxStatus.success());
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> checkEmail() async {
    change(false, status: RxStatus.loading());
    try {
      final response = await AccountApi.checkEmail(email: email.value);
      if (response.statusCode != 200) {
        change(false, status: RxStatus.error('error'));
      } else {
        final data = response.data['body']['exist'];
        change(data, status: RxStatus.success());
        return data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> checkName() async {
    change(false, status: RxStatus.loading());
    try {
      final response = await AccountApi.checkName(name: name.value);
      if (response.statusCode != 200) {
        change(false, status: RxStatus.error('error'));
      } else {
        final data = response.data['body']['exist'];
        change(data, status: RxStatus.success());
        return data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> register() async {
    SmartDialog.showLoading();
    change(false, status: RxStatus.loading());
    try {
      final response = await AccountApi.register(
          email: email.value,
          code: code.value,
          name: name.value,
          password: password.value);
      if (response.statusCode != 200) {
        change(false, status: RxStatus.error('error'));
      } else {
        final data = register_.fromBuffer(response.data);
        if (!data.error) {
          final user = data.body.user.toProto3Json();
          box.write('token', data.body.token);
          box.write('user', jsonDecode(jsonEncode(user)));
          change(true, status: RxStatus.success());
          SmartDialog.dismiss();
          return true;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    change(false, status: RxStatus.error('error'));
    SmartDialog.dismiss();
    return false;
  }
}

class ChangePasswordController extends GetxController with StateMixin {
  final box = GetStorage();
  final email = ''.obs;
  final code = ''.obs;
  final password = ''.obs;

  Future<bool> getCode() async {
    change(false, status: RxStatus.loading());
    try {
      final response = await AccountApi.getCode(email: email.value);
      if (response.statusCode != 200) {
        change(false, status: RxStatus.error('error'));
      } else {
        change(true, status: RxStatus.success());
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> changePassword() async {
    SmartDialog.dismiss();
    change(false, status: RxStatus.loading());
    try {
      final response = await AccountApi.changePassword(
          email: email.value, code: code.value, password: password.value);
      if (response.statusCode != 200) {
        change(false, status: RxStatus.error('error'));
      } else {
        final data = change_password_.fromBuffer(response.data);
        if (!data.error) {
          final user = data.body.user.toProto3Json();
          box.write('token', data.body.token);
          box.write('user', jsonDecode(jsonEncode(user)));
          change(true, status: RxStatus.success());
          SmartDialog.dismiss();
          return true;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    change(false, status: RxStatus.error('error'));
    SmartDialog.dismiss();
    return false;
  }
}
