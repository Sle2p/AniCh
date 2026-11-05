//
//  Generated code. Do not modify.
//  source: account.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// 登录
class login_user_ extends $pb.GeneratedMessage {
  factory login_user_({
    $core.String? avatar,
    $core.String? email,
    $core.String? name,
    $core.String? role,
    $core.String? sex,
    $core.int? exp,
    $core.int? coin,
    $core.String? color,
    $core.double? created,
    $core.double? updated,
    $core.int? id,
    $core.String? address,
  }) {
    final $result = create();
    if (avatar != null) {
      $result.avatar = avatar;
    }
    if (email != null) {
      $result.email = email;
    }
    if (name != null) {
      $result.name = name;
    }
    if (role != null) {
      $result.role = role;
    }
    if (sex != null) {
      $result.sex = sex;
    }
    if (exp != null) {
      $result.exp = exp;
    }
    if (coin != null) {
      $result.coin = coin;
    }
    if (color != null) {
      $result.color = color;
    }
    if (created != null) {
      $result.created = created;
    }
    if (updated != null) {
      $result.updated = updated;
    }
    if (id != null) {
      $result.id = id;
    }
    if (address != null) {
      $result.address = address;
    }
    return $result;
  }
  login_user_._() : super();
  factory login_user_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory login_user_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_login_user', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'avatar')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'role')
    ..aOS(5, _omitFieldNames ? '' : 'sex')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'exp', $pb.PbFieldType.OU3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'coin', $pb.PbFieldType.OU3)
    ..aOS(8, _omitFieldNames ? '' : 'color')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'created', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'updated', $pb.PbFieldType.OD)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(12, _omitFieldNames ? '' : 'address')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  login_user_ clone() => login_user_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  login_user_ copyWith(void Function(login_user_) updates) => super.copyWith((message) => updates(message as login_user_)) as login_user_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static login_user_ create() => login_user_._();
  login_user_ createEmptyInstance() => create();
  static $pb.PbList<login_user_> createRepeated() => $pb.PbList<login_user_>();
  @$core.pragma('dart2js:noInline')
  static login_user_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<login_user_>(create);
  static login_user_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get avatar => $_getSZ(0);
  @$pb.TagNumber(1)
  set avatar($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAvatar() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvatar() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get role => $_getSZ(3);
  @$pb.TagNumber(4)
  set role($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sex => $_getSZ(4);
  @$pb.TagNumber(5)
  set sex($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSex() => $_has(4);
  @$pb.TagNumber(5)
  void clearSex() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get exp => $_getIZ(5);
  @$pb.TagNumber(6)
  set exp($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasExp() => $_has(5);
  @$pb.TagNumber(6)
  void clearExp() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get coin => $_getIZ(6);
  @$pb.TagNumber(7)
  set coin($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCoin() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoin() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get color => $_getSZ(7);
  @$pb.TagNumber(8)
  set color($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasColor() => $_has(7);
  @$pb.TagNumber(8)
  void clearColor() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get created => $_getN(8);
  @$pb.TagNumber(9)
  set created($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreated() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreated() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get updated => $_getN(9);
  @$pb.TagNumber(10)
  set updated($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasUpdated() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdated() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get id => $_getIZ(10);
  @$pb.TagNumber(11)
  set id($core.int v) { $_setUnsignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasId() => $_has(10);
  @$pb.TagNumber(11)
  void clearId() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get address => $_getSZ(11);
  @$pb.TagNumber(12)
  set address($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasAddress() => $_has(11);
  @$pb.TagNumber(12)
  void clearAddress() => clearField(12);
}

class login_body_ extends $pb.GeneratedMessage {
  factory login_body_({
    login_user_? user,
    $core.String? token,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  login_body_._() : super();
  factory login_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory login_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_login_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOM<login_user_>(1, _omitFieldNames ? '' : 'user', subBuilder: login_user_.create)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  login_body_ clone() => login_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  login_body_ copyWith(void Function(login_body_) updates) => super.copyWith((message) => updates(message as login_body_)) as login_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static login_body_ create() => login_body_._();
  login_body_ createEmptyInstance() => create();
  static $pb.PbList<login_body_> createRepeated() => $pb.PbList<login_body_>();
  @$core.pragma('dart2js:noInline')
  static login_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<login_body_>(create);
  static login_body_? _defaultInstance;

  @$pb.TagNumber(1)
  login_user_ get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(login_user_ v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  login_user_ ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class login_ extends $pb.GeneratedMessage {
  factory login_({
    $core.bool? error,
    $core.String? message,
    login_body_? body,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (message != null) {
      $result.message = message;
    }
    if (body != null) {
      $result.body = body;
    }
    return $result;
  }
  login_._() : super();
  factory login_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory login_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_login', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<login_body_>(3, _omitFieldNames ? '' : 'body', subBuilder: login_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  login_ clone() => login_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  login_ copyWith(void Function(login_) updates) => super.copyWith((message) => updates(message as login_)) as login_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static login_ create() => login_._();
  login_ createEmptyInstance() => create();
  static $pb.PbList<login_> createRepeated() => $pb.PbList<login_>();
  @$core.pragma('dart2js:noInline')
  static login_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<login_>(create);
  static login_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get error => $_getBF(0);
  @$pb.TagNumber(1)
  set error($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  login_body_ get body => $_getN(2);
  @$pb.TagNumber(3)
  set body(login_body_ v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);
  @$pb.TagNumber(3)
  login_body_ ensureBody() => $_ensure(2);
}

/// 登录请求
class login_request_ extends $pb.GeneratedMessage {
  factory login_request_({
    $core.String? user,
    $core.String? password,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  login_request_._() : super();
  factory login_request_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory login_request_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_login_request', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'user')
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  login_request_ clone() => login_request_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  login_request_ copyWith(void Function(login_request_) updates) => super.copyWith((message) => updates(message as login_request_)) as login_request_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static login_request_ create() => login_request_._();
  login_request_ createEmptyInstance() => create();
  static $pb.PbList<login_request_> createRepeated() => $pb.PbList<login_request_>();
  @$core.pragma('dart2js:noInline')
  static login_request_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<login_request_>(create);
  static login_request_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get user => $_getSZ(0);
  @$pb.TagNumber(1)
  set user($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

/// 注册
class register_user_ extends $pb.GeneratedMessage {
  factory register_user_({
    $core.String? email,
    $core.String? name,
    $core.String? role,
    $core.String? sex,
    $core.int? exp,
    $core.int? coin,
    $core.String? color,
    $core.double? created,
    $core.double? updated,
    $core.int? id,
    $core.String? address,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (name != null) {
      $result.name = name;
    }
    if (role != null) {
      $result.role = role;
    }
    if (sex != null) {
      $result.sex = sex;
    }
    if (exp != null) {
      $result.exp = exp;
    }
    if (coin != null) {
      $result.coin = coin;
    }
    if (color != null) {
      $result.color = color;
    }
    if (created != null) {
      $result.created = created;
    }
    if (updated != null) {
      $result.updated = updated;
    }
    if (id != null) {
      $result.id = id;
    }
    if (address != null) {
      $result.address = address;
    }
    return $result;
  }
  register_user_._() : super();
  factory register_user_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory register_user_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_register_user', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'sex')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'exp', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'coin', $pb.PbFieldType.OU3)
    ..aOS(7, _omitFieldNames ? '' : 'color')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'created', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'updated', $pb.PbFieldType.OD)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(11, _omitFieldNames ? '' : 'address')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  register_user_ clone() => register_user_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  register_user_ copyWith(void Function(register_user_) updates) => super.copyWith((message) => updates(message as register_user_)) as register_user_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static register_user_ create() => register_user_._();
  register_user_ createEmptyInstance() => create();
  static $pb.PbList<register_user_> createRepeated() => $pb.PbList<register_user_>();
  @$core.pragma('dart2js:noInline')
  static register_user_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<register_user_>(create);
  static register_user_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sex => $_getSZ(3);
  @$pb.TagNumber(4)
  set sex($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSex() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get exp => $_getIZ(4);
  @$pb.TagNumber(5)
  set exp($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExp() => $_has(4);
  @$pb.TagNumber(5)
  void clearExp() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get coin => $_getIZ(5);
  @$pb.TagNumber(6)
  set coin($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCoin() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoin() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get color => $_getSZ(6);
  @$pb.TagNumber(7)
  set color($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearColor() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get created => $_getN(7);
  @$pb.TagNumber(8)
  set created($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreated() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreated() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get updated => $_getN(8);
  @$pb.TagNumber(9)
  set updated($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasUpdated() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdated() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get id => $_getIZ(9);
  @$pb.TagNumber(10)
  set id($core.int v) { $_setUnsignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasId() => $_has(9);
  @$pb.TagNumber(10)
  void clearId() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get address => $_getSZ(10);
  @$pb.TagNumber(11)
  set address($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAddress() => $_has(10);
  @$pb.TagNumber(11)
  void clearAddress() => clearField(11);
}

class register_body_ extends $pb.GeneratedMessage {
  factory register_body_({
    register_user_? user,
    $core.String? token,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  register_body_._() : super();
  factory register_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory register_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_register_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOM<register_user_>(1, _omitFieldNames ? '' : 'user', subBuilder: register_user_.create)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  register_body_ clone() => register_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  register_body_ copyWith(void Function(register_body_) updates) => super.copyWith((message) => updates(message as register_body_)) as register_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static register_body_ create() => register_body_._();
  register_body_ createEmptyInstance() => create();
  static $pb.PbList<register_body_> createRepeated() => $pb.PbList<register_body_>();
  @$core.pragma('dart2js:noInline')
  static register_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<register_body_>(create);
  static register_body_? _defaultInstance;

  @$pb.TagNumber(1)
  register_user_ get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(register_user_ v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  register_user_ ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class register_ extends $pb.GeneratedMessage {
  factory register_({
    $core.bool? error,
    $core.String? message,
    register_body_? body,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (message != null) {
      $result.message = message;
    }
    if (body != null) {
      $result.body = body;
    }
    return $result;
  }
  register_._() : super();
  factory register_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory register_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_register', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<register_body_>(3, _omitFieldNames ? '' : 'body', subBuilder: register_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  register_ clone() => register_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  register_ copyWith(void Function(register_) updates) => super.copyWith((message) => updates(message as register_)) as register_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static register_ create() => register_._();
  register_ createEmptyInstance() => create();
  static $pb.PbList<register_> createRepeated() => $pb.PbList<register_>();
  @$core.pragma('dart2js:noInline')
  static register_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<register_>(create);
  static register_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get error => $_getBF(0);
  @$pb.TagNumber(1)
  set error($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  register_body_ get body => $_getN(2);
  @$pb.TagNumber(3)
  set body(register_body_ v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);
  @$pb.TagNumber(3)
  register_body_ ensureBody() => $_ensure(2);
}

/// 注册请求
class register_request_ extends $pb.GeneratedMessage {
  factory register_request_({
    $core.String? email,
    $core.String? code,
    $core.String? name,
    $core.String? password,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (code != null) {
      $result.code = code;
    }
    if (name != null) {
      $result.name = name;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  register_request_._() : super();
  factory register_request_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory register_request_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_register_request', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  register_request_ clone() => register_request_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  register_request_ copyWith(void Function(register_request_) updates) => super.copyWith((message) => updates(message as register_request_)) as register_request_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static register_request_ create() => register_request_._();
  register_request_ createEmptyInstance() => create();
  static $pb.PbList<register_request_> createRepeated() => $pb.PbList<register_request_>();
  @$core.pragma('dart2js:noInline')
  static register_request_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<register_request_>(create);
  static register_request_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get password => $_getSZ(3);
  @$pb.TagNumber(4)
  set password($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPassword() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassword() => clearField(4);
}

/// 修改密码
class change_password_user_ extends $pb.GeneratedMessage {
  factory change_password_user_({
    $core.String? email,
    $core.String? name,
    $core.String? role,
    $core.String? sex,
    $core.int? exp,
    $core.int? coin,
    $core.String? color,
    $core.double? created,
    $core.double? updated,
    $core.int? id,
    $core.String? address,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (name != null) {
      $result.name = name;
    }
    if (role != null) {
      $result.role = role;
    }
    if (sex != null) {
      $result.sex = sex;
    }
    if (exp != null) {
      $result.exp = exp;
    }
    if (coin != null) {
      $result.coin = coin;
    }
    if (color != null) {
      $result.color = color;
    }
    if (created != null) {
      $result.created = created;
    }
    if (updated != null) {
      $result.updated = updated;
    }
    if (id != null) {
      $result.id = id;
    }
    if (address != null) {
      $result.address = address;
    }
    return $result;
  }
  change_password_user_._() : super();
  factory change_password_user_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory change_password_user_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_change_password_user', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'sex')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'exp', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'coin', $pb.PbFieldType.OU3)
    ..aOS(7, _omitFieldNames ? '' : 'color')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'created', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'updated', $pb.PbFieldType.OD)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(11, _omitFieldNames ? '' : 'address')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  change_password_user_ clone() => change_password_user_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  change_password_user_ copyWith(void Function(change_password_user_) updates) => super.copyWith((message) => updates(message as change_password_user_)) as change_password_user_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static change_password_user_ create() => change_password_user_._();
  change_password_user_ createEmptyInstance() => create();
  static $pb.PbList<change_password_user_> createRepeated() => $pb.PbList<change_password_user_>();
  @$core.pragma('dart2js:noInline')
  static change_password_user_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<change_password_user_>(create);
  static change_password_user_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sex => $_getSZ(3);
  @$pb.TagNumber(4)
  set sex($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSex() => $_has(3);
  @$pb.TagNumber(4)
  void clearSex() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get exp => $_getIZ(4);
  @$pb.TagNumber(5)
  set exp($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasExp() => $_has(4);
  @$pb.TagNumber(5)
  void clearExp() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get coin => $_getIZ(5);
  @$pb.TagNumber(6)
  set coin($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCoin() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoin() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get color => $_getSZ(6);
  @$pb.TagNumber(7)
  set color($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearColor() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get created => $_getN(7);
  @$pb.TagNumber(8)
  set created($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreated() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreated() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get updated => $_getN(8);
  @$pb.TagNumber(9)
  set updated($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasUpdated() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdated() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get id => $_getIZ(9);
  @$pb.TagNumber(10)
  set id($core.int v) { $_setUnsignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasId() => $_has(9);
  @$pb.TagNumber(10)
  void clearId() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get address => $_getSZ(10);
  @$pb.TagNumber(11)
  set address($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasAddress() => $_has(10);
  @$pb.TagNumber(11)
  void clearAddress() => clearField(11);
}

class change_password_body_ extends $pb.GeneratedMessage {
  factory change_password_body_({
    change_password_user_? user,
    $core.String? token,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  change_password_body_._() : super();
  factory change_password_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory change_password_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_change_password_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOM<change_password_user_>(1, _omitFieldNames ? '' : 'user', subBuilder: change_password_user_.create)
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  change_password_body_ clone() => change_password_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  change_password_body_ copyWith(void Function(change_password_body_) updates) => super.copyWith((message) => updates(message as change_password_body_)) as change_password_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static change_password_body_ create() => change_password_body_._();
  change_password_body_ createEmptyInstance() => create();
  static $pb.PbList<change_password_body_> createRepeated() => $pb.PbList<change_password_body_>();
  @$core.pragma('dart2js:noInline')
  static change_password_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<change_password_body_>(create);
  static change_password_body_? _defaultInstance;

  @$pb.TagNumber(1)
  change_password_user_ get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(change_password_user_ v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  change_password_user_ ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class change_password_ extends $pb.GeneratedMessage {
  factory change_password_({
    $core.bool? error,
    $core.String? message,
    change_password_body_? body,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (message != null) {
      $result.message = message;
    }
    if (body != null) {
      $result.body = body;
    }
    return $result;
  }
  change_password_._() : super();
  factory change_password_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory change_password_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_change_password', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<change_password_body_>(3, _omitFieldNames ? '' : 'body', subBuilder: change_password_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  change_password_ clone() => change_password_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  change_password_ copyWith(void Function(change_password_) updates) => super.copyWith((message) => updates(message as change_password_)) as change_password_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static change_password_ create() => change_password_._();
  change_password_ createEmptyInstance() => create();
  static $pb.PbList<change_password_> createRepeated() => $pb.PbList<change_password_>();
  @$core.pragma('dart2js:noInline')
  static change_password_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<change_password_>(create);
  static change_password_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get error => $_getBF(0);
  @$pb.TagNumber(1)
  set error($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  change_password_body_ get body => $_getN(2);
  @$pb.TagNumber(3)
  set body(change_password_body_ v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);
  @$pb.TagNumber(3)
  change_password_body_ ensureBody() => $_ensure(2);
}

/// 修改密码请求
class change_password_request_ extends $pb.GeneratedMessage {
  factory change_password_request_({
    $core.String? email,
    $core.String? code,
    $core.String? password,
  }) {
    final $result = create();
    if (email != null) {
      $result.email = email;
    }
    if (code != null) {
      $result.code = code;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  change_password_request_._() : super();
  factory change_password_request_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory change_password_request_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_change_password_request', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'email')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  change_password_request_ clone() => change_password_request_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  change_password_request_ copyWith(void Function(change_password_request_) updates) => super.copyWith((message) => updates(message as change_password_request_)) as change_password_request_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static change_password_request_ create() => change_password_request_._();
  change_password_request_ createEmptyInstance() => create();
  static $pb.PbList<change_password_request_> createRepeated() => $pb.PbList<change_password_request_>();
  @$core.pragma('dart2js:noInline')
  static change_password_request_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<change_password_request_>(create);
  static change_password_request_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get email => $_getSZ(0);
  @$pb.TagNumber(1)
  set email($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEmail() => $_has(0);
  @$pb.TagNumber(1)
  void clearEmail() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get password => $_getSZ(2);
  @$pb.TagNumber(3)
  set password($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPassword() => $_has(2);
  @$pb.TagNumber(3)
  void clearPassword() => clearField(3);
}

/// 初始化信息
class init_user_ extends $pb.GeneratedMessage {
  factory init_user_({
    $core.String? avatar,
    $core.String? email,
    $core.String? name,
    $core.String? role,
    $core.String? sex,
    $core.int? exp,
    $core.int? coin,
    $core.String? color,
    $core.double? created,
    $core.double? updated,
    $core.int? id,
    $core.String? address,
  }) {
    final $result = create();
    if (avatar != null) {
      $result.avatar = avatar;
    }
    if (email != null) {
      $result.email = email;
    }
    if (name != null) {
      $result.name = name;
    }
    if (role != null) {
      $result.role = role;
    }
    if (sex != null) {
      $result.sex = sex;
    }
    if (exp != null) {
      $result.exp = exp;
    }
    if (coin != null) {
      $result.coin = coin;
    }
    if (color != null) {
      $result.color = color;
    }
    if (created != null) {
      $result.created = created;
    }
    if (updated != null) {
      $result.updated = updated;
    }
    if (id != null) {
      $result.id = id;
    }
    if (address != null) {
      $result.address = address;
    }
    return $result;
  }
  init_user_._() : super();
  factory init_user_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory init_user_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_init_user', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'avatar')
    ..aOS(2, _omitFieldNames ? '' : 'email')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'role')
    ..aOS(5, _omitFieldNames ? '' : 'sex')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'exp', $pb.PbFieldType.OU3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'coin', $pb.PbFieldType.OU3)
    ..aOS(8, _omitFieldNames ? '' : 'color')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'created', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'updated', $pb.PbFieldType.OD)
    ..a<$core.int>(11, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(12, _omitFieldNames ? '' : 'address')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  init_user_ clone() => init_user_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  init_user_ copyWith(void Function(init_user_) updates) => super.copyWith((message) => updates(message as init_user_)) as init_user_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static init_user_ create() => init_user_._();
  init_user_ createEmptyInstance() => create();
  static $pb.PbList<init_user_> createRepeated() => $pb.PbList<init_user_>();
  @$core.pragma('dart2js:noInline')
  static init_user_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<init_user_>(create);
  static init_user_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get avatar => $_getSZ(0);
  @$pb.TagNumber(1)
  set avatar($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAvatar() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvatar() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get email => $_getSZ(1);
  @$pb.TagNumber(2)
  set email($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmail() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmail() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get role => $_getSZ(3);
  @$pb.TagNumber(4)
  set role($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRole() => $_has(3);
  @$pb.TagNumber(4)
  void clearRole() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get sex => $_getSZ(4);
  @$pb.TagNumber(5)
  set sex($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSex() => $_has(4);
  @$pb.TagNumber(5)
  void clearSex() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get exp => $_getIZ(5);
  @$pb.TagNumber(6)
  set exp($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasExp() => $_has(5);
  @$pb.TagNumber(6)
  void clearExp() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get coin => $_getIZ(6);
  @$pb.TagNumber(7)
  set coin($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCoin() => $_has(6);
  @$pb.TagNumber(7)
  void clearCoin() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get color => $_getSZ(7);
  @$pb.TagNumber(8)
  set color($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasColor() => $_has(7);
  @$pb.TagNumber(8)
  void clearColor() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get created => $_getN(8);
  @$pb.TagNumber(9)
  set created($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreated() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreated() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get updated => $_getN(9);
  @$pb.TagNumber(10)
  set updated($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasUpdated() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdated() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get id => $_getIZ(10);
  @$pb.TagNumber(11)
  set id($core.int v) { $_setUnsignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasId() => $_has(10);
  @$pb.TagNumber(11)
  void clearId() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get address => $_getSZ(11);
  @$pb.TagNumber(12)
  set address($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasAddress() => $_has(11);
  @$pb.TagNumber(12)
  void clearAddress() => clearField(12);
}

class init_body_ extends $pb.GeneratedMessage {
  factory init_body_({
    init_user_? user,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    return $result;
  }
  init_body_._() : super();
  factory init_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory init_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_init_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOM<init_user_>(1, _omitFieldNames ? '' : 'user', subBuilder: init_user_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  init_body_ clone() => init_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  init_body_ copyWith(void Function(init_body_) updates) => super.copyWith((message) => updates(message as init_body_)) as init_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static init_body_ create() => init_body_._();
  init_body_ createEmptyInstance() => create();
  static $pb.PbList<init_body_> createRepeated() => $pb.PbList<init_body_>();
  @$core.pragma('dart2js:noInline')
  static init_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<init_body_>(create);
  static init_body_? _defaultInstance;

  @$pb.TagNumber(1)
  init_user_ get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(init_user_ v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  init_user_ ensureUser() => $_ensure(0);
}

class init_ extends $pb.GeneratedMessage {
  factory init_({
    $core.bool? error,
    $core.String? message,
    init_body_? body,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (message != null) {
      $result.message = message;
    }
    if (body != null) {
      $result.body = body;
    }
    return $result;
  }
  init_._() : super();
  factory init_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory init_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_init', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<init_body_>(3, _omitFieldNames ? '' : 'body', subBuilder: init_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  init_ clone() => init_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  init_ copyWith(void Function(init_) updates) => super.copyWith((message) => updates(message as init_)) as init_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static init_ create() => init_._();
  init_ createEmptyInstance() => create();
  static $pb.PbList<init_> createRepeated() => $pb.PbList<init_>();
  @$core.pragma('dart2js:noInline')
  static init_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<init_>(create);
  static init_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get error => $_getBF(0);
  @$pb.TagNumber(1)
  set error($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  init_body_ get body => $_getN(2);
  @$pb.TagNumber(3)
  set body(init_body_ v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);
  @$pb.TagNumber(3)
  init_body_ ensureBody() => $_ensure(2);
}

class token_ extends $pb.GeneratedMessage {
  factory token_({
    $core.String? token,
    $core.String? time,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (time != null) {
      $result.time = time;
    }
    return $result;
  }
  token_._() : super();
  factory token_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory token_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_token', package: const $pb.PackageName(_omitMessageNames ? '' : 'account'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'token')
    ..aOS(2, _omitFieldNames ? '' : 'time')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  token_ clone() => token_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  token_ copyWith(void Function(token_) updates) => super.copyWith((message) => updates(message as token_)) as token_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static token_ create() => token_._();
  token_ createEmptyInstance() => create();
  static $pb.PbList<token_> createRepeated() => $pb.PbList<token_>();
  @$core.pragma('dart2js:noInline')
  static token_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<token_>(create);
  static token_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get token => $_getSZ(0);
  @$pb.TagNumber(1)
  set token($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get time => $_getSZ(1);
  @$pb.TagNumber(2)
  set time($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
