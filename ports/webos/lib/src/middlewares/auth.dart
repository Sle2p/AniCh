import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  final box = GetStorage();

  static bool isValidSession(Object? token, Object? user) {
    if (token is! String || token.trim().isEmpty || user is! Map) return false;
    final rawId = user['id'];
    final id = rawId is int
        ? rawId
        : rawId is String
            ? int.tryParse(rawId)
            : null;
    final name = user['name'];
    return id != null && id > 0 && name is String && name.trim().isNotEmpty;
  }

  @override
  RouteSettings? redirect(String? route) {
    if (!isValidSession(box.read('token'), box.read('user'))) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
