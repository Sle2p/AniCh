import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:xs/protobuf/account.pb.dart';
import 'package:xs/src/apis/account.dart' as account_api;
import 'package:xs/src/middlewares/auth.dart';
import 'package:xs/src/pages/account/controller.dart';

class _LoginAdapter implements HttpClientAdapter {
  late Future<ResponseBody> Function(RequestOptions options) respond;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return respond(options);
  }

  @override
  void close({bool force = false}) {}

  void reply(login_ response) {
    respond = (_) async => ResponseBody.fromBytes(
          response.writeToBuffer(),
          200,
          headers: {
            Headers.contentTypeHeader: ['application/octet-stream'],
          },
        );
  }
}

login_body_ _validBody({String token = 'fixture-token'}) => login_body_(
      token: token,
      user: login_user_(id: 42, name: '测试用户', email: 'fixture@example.invalid'),
    );

const _loadingKey = ValueKey('login-test-loading');

Future<void> _mountHost(WidgetTester tester) async {
  await tester.pumpWidget(GetMaterialApp(
    navigatorObservers: [FlutterSmartDialog.observer],
    builder: FlutterSmartDialog.init(
      loadingBuilder: (_) => const Material(
        child: Text('正在登录', key: _loadingKey),
      ),
    ),
    home: const Scaffold(body: Text('登录测试')),
  ));
  await tester.pumpAndSettle();
}

Future<login_?> _login(WidgetTester tester, LoginController controller) async {
  late Future<login_?> pending;
  await tester.runAsync(() async {
    pending = controller.login();
  });
  return _finishLogin(tester, pending);
}

Future<login_?> _finishLogin(
    WidgetTester tester, Future<login_?> pending) async {
  login_? result;
  Object? failure;
  StackTrace? failureStack;
  var completed = false;
  unawaited(pending.then<void>((value) {
    result = value;
    completed = true;
  }, onError: (Object error, StackTrace stack) {
    failure = error;
    failureStack = stack;
    completed = true;
  }));
  // Dismissal awaits the loading animation. Advance frames while Dio and the
  // temporary storage run outside Flutter's fake async clock.
  for (var frame = 0; frame < 100 && !completed; frame++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 5)),
    );
  }
  expect(completed, isTrue, reason: 'Login must finish after dismissing loading');
  if (failure != null) Error.throwWithStackTrace(failure!, failureStack!);
  await tester.pumpAndSettle();
  return result;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late GetStorage storage;
  late HttpClientAdapter originalAdapter;
  late _LoginAdapter adapter;

  setUpAll(() async {
    Get.testMode = true;
    directory = await Directory.systemTemp.createTemp('anich-login-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => directory.path,
    );
    // GetStorage shares instances by container name. Seed its default instance
    // with a test-only path before constructing any controller or middleware.
    storage = GetStorage('GetStorage', directory.path);
    await storage.initStorage;
    originalAdapter = account_api.api.httpClientAdapter;
  });

  setUp(() async {
    await storage.erase();
    adapter = _LoginAdapter();
    account_api.api.httpClientAdapter = adapter;
  });

  tearDown(() {
    account_api.api.httpClientAdapter = originalAdapter;
  });

  tearDownAll(() async {
    await storage.queue.add(() async {});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    await directory.delete(recursive: true);
    Get.reset();
  });

  testWidgets(
      'rejected or incomplete login cannot create or overwrite a session',
      (tester) async {
    await _mountHost(tester);
    final rejectedReplies = <String, login_>{
      'server rejection despite a populated body':
          login_(error: true, message: '账号或密码错误', body: _validBody()),
      'success without a body': login_(error: false),
      'success with a blank token':
          login_(error: false, body: _validBody(token: '   ')),
      'success without a user':
          login_(error: false, body: login_body_(token: 'fixture-token')),
      'success with a blank name': login_(
        error: false,
        body: login_body_(
          token: 'fixture-token',
          user: login_user_(id: 42, name: '   '),
        ),
      ),
      'success with an invalid user id': login_(
        error: false,
        body: login_body_(
          token: 'fixture-token',
          user: login_user_(id: 0, name: '测试用户'),
        ),
      ),
    };
    const previousUser = {'id': 7, 'name': '已有用户'};

    for (final hasSession in [false, true]) {
      for (final fixture in rejectedReplies.entries) {
        await tester.runAsync(() async {
          await storage.erase();
          if (hasSession) {
            await storage.write('token', 'previous-fixture-token');
            await storage.write('user', previousUser);
          }
        });
        adapter.reply(fixture.value);
        final controller = LoginController();
        final reason = '${fixture.key}; existing session: $hasSession';

        expect(await _login(tester, controller), isNull, reason: reason);
        expect(controller.status.isError, isTrue, reason: reason);
        expect(
            storage.read('token'), hasSession ? 'previous-fixture-token' : null,
            reason: reason);
        expect(storage.read('user'), hasSession ? previousUser : null,
            reason: reason);
        expect(AuthMiddleware().redirect('/profile')?.name,
            hasSession ? null : '/login',
            reason: reason);
        expect(find.byKey(_loadingKey), findsNothing, reason: reason);
      }
    }
  });

  testWidgets(
      'a network exception dismisses visible loading and keeps guest state',
      (tester) async {
    await _mountHost(tester);
    final response = Completer<ResponseBody>();
    adapter.respond = (options) {
      return response.future;
    };
    final controller = LoginController();
    late Future<login_?> pendingLogin;
    await tester.runAsync(() async {
      pendingLogin = controller.login();
    });
    for (var frame = 0; frame < 20 && adapter.requests.isEmpty; frame++) {
      await tester.pump(const Duration(milliseconds: 50));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
    }
    expect(adapter.requests, hasLength(1));
    await tester.pumpAndSettle();
    expect(find.byKey(_loadingKey), findsOneWidget);
    expect(controller.status.isLoading, isTrue);

    await tester.runAsync(() async {
      response.completeError(DioException(
        requestOptions: adapter.requests.single,
        type: DioExceptionType.connectionTimeout,
        message: 'Simulated timeout',
      ));
    });
    expect(await _finishLogin(tester, pendingLogin), isNull);

    expect(find.byKey(_loadingKey), findsNothing);
    expect(controller.status.isError, isTrue);
    expect(storage.read('token'), isNull);
    expect(storage.read('user'), isNull);
    expect(AuthMiddleware().redirect('/profile')?.name, '/login');
  });

  testWidgets(
      'valid login persists its session and auth requires a complete user',
      (tester) async {
    await _mountHost(tester);
    adapter.reply(login_(error: false, body: _validBody()));
    final controller = LoginController()
      ..user.value = 'fixture@example.invalid'
      ..password.value = 'test-only-password';

    expect(await _login(tester, controller), isNotNull);
    expect(controller.status.isSuccess, isTrue);
    expect(adapter.requests.single.path, '/login');
    expect(storage.read('token'), 'fixture-token');
    final savedUser = Map<String, dynamic>.from(storage.read<Map>('user')!);
    expect(savedUser['name'], '测试用户');
    expect(savedUser['id'].toString(), '42');
    expect(AuthMiddleware().redirect('/profile'), isNull);
    expect(find.byKey(_loadingKey), findsNothing);

    await tester.runAsync(() async {
      await storage.queue.add(() async {});
      final saved = jsonDecode(
        await File('${directory.path}/GetStorage.gs').readAsString(),
      ) as Map<String, dynamic>;
      expect(saved['token'], 'fixture-token');
      expect(saved['user'], savedUser);

      // Both numeric JSON ids and protobuf-style string ids are accepted.
      await storage.write('user', {...savedUser, 'id': '42'});
      expect(AuthMiddleware().redirect('/profile'), isNull);

      for (final incomplete in <Map<String, dynamic>>[
        {...savedUser, 'id': 0},
        {...savedUser, 'id': 'not-an-id'},
        {...savedUser, 'name': '   '},
        {},
      ]) {
        await storage.write('user', incomplete);
        expect(AuthMiddleware().redirect('/profile')?.name, '/login');
      }
      await storage.write('user', savedUser);
      await storage.write('token', '   ');
      expect(AuthMiddleware().redirect('/profile')?.name, '/login');
    });
  });
}
