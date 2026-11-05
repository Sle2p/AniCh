import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xs/src/config.dart';
import 'package:xs/protobuf/account.pb.dart';
import 'package:xs/src/utils/account.dart';

final api = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    headers: {HttpHeaders.userAgentHeader: AppConfig.ua}));
final box = GetStorage();

class AccountApi {
  // 登录
  static Future<Response> login(
      {required String user, required String password}) async {
    const url = '/login';
    login_request_ userData = login_request_(user: user, password: password);
    final response = await api.post(url,
        data: {'data': userData.writeToBuffer().join(',')},
        options: Options(
            responseType: ResponseType.bytes,
            contentType: 'application/x-www-form-urlencoded'));
    // final data = login_.fromBuffer(response.data);
    return response;
  }

  // 获取验证码
  static Future<Response> getCode({required String email}) async {
    const url = '/code';
    final response = await api.post(url, data: {'email': email});
    return response;
  }

  // 修改密码
  static Future<Response> changePassword(
      {required String email,
      required String code,
      required String password}) async {
    const url = '/change_password';
    change_password_request_ userData =
        change_password_request_(email: email, code: code, password: password);
    final response = await api.post(url,
        data: {'data': userData.writeToBuffer().join(',')},
        options: Options(
            responseType: ResponseType.bytes,
            contentType: 'application/x-www-form-urlencoded'));
    return response;
  }

  // 检测邮箱可用性
  static Future<Response> checkEmail({required String email}) async {
    const url = '/user/check';
    final response = await api.post(url, data: {'email': email});
    return response;
  }

  // 检测用户名可用性
  static Future<Response> checkName({required String name}) async {
    const url = '/user/check';
    final response = await api.post(url, data: {'name': name});
    return response;
  }

  // 注册
  static Future<Response> register(
      {required String email,
      required String code,
      required String name,
      required String password}) async {
    const url = '/register';
    register_request_ userData = register_request_(
        email: email, code: code, name: name, password: password);
    final response = await api.post(url,
        data: {'data': userData.writeToBuffer().join(',')},
        options: Options(
            responseType: ResponseType.bytes,
            contentType: 'application/x-www-form-urlencoded'));
    return response;
  }

  // 获取用户数据
  static void init() async {
    try {
      const url = '/init';
      final response = await api.get(url,
          options: Options(
              responseType: ResponseType.bytes,
              headers: {'_': AccountUtil.token()}));
      final user = init_.fromBuffer(response.data).body.user.toProto3Json();
      box.write('user', jsonDecode(jsonEncode(user)));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
