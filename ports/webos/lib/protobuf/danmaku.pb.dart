//
//  Generated code. Do not modify.
//  source: danmaku.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class data_ extends $pb.GeneratedMessage {
  factory data_({
    $core.String? id,
    $core.String? color,
    $core.double? date,
    $core.String? text,
    $core.String? t,
    $core.double? time,
    $core.int? type,
    $core.String? from,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (color != null) {
      $result.color = color;
    }
    if (date != null) {
      $result.date = date;
    }
    if (text != null) {
      $result.text = text;
    }
    if (t != null) {
      $result.t = t;
    }
    if (time != null) {
      $result.time = time;
    }
    if (type != null) {
      $result.type = type;
    }
    if (from != null) {
      $result.from = from;
    }
    return $result;
  }
  data_._() : super();
  factory data_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory data_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_data', package: const $pb.PackageName(_omitMessageNames ? '' : 'danmaku'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'color')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'date', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'text')
    ..aOS(5, _omitFieldNames ? '' : 't')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'time', $pb.PbFieldType.OD)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OU3)
    ..aOS(8, _omitFieldNames ? '' : 'from')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  data_ clone() => data_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  data_ copyWith(void Function(data_) updates) => super.copyWith((message) => updates(message as data_)) as data_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static data_ create() => data_._();
  data_ createEmptyInstance() => create();
  static $pb.PbList<data_> createRepeated() => $pb.PbList<data_>();
  @$core.pragma('dart2js:noInline')
  static data_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<data_>(create);
  static data_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get color => $_getSZ(1);
  @$pb.TagNumber(2)
  set color($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearColor() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get date => $_getN(2);
  @$pb.TagNumber(3)
  set date($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDate() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get t => $_getSZ(4);
  @$pb.TagNumber(5)
  set t($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasT() => $_has(4);
  @$pb.TagNumber(5)
  void clearT() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get time => $_getN(5);
  @$pb.TagNumber(6)
  set time($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get type => $_getIZ(6);
  @$pb.TagNumber(7)
  set type($core.int v) { $_setUnsignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasType() => $_has(6);
  @$pb.TagNumber(7)
  void clearType() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get from => $_getSZ(7);
  @$pb.TagNumber(8)
  set from($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFrom() => $_has(7);
  @$pb.TagNumber(8)
  void clearFrom() => clearField(8);
}

class danmaku_ extends $pb.GeneratedMessage {
  factory danmaku_({
    $core.Iterable<data_>? data,
    $core.int? skip,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    if (skip != null) {
      $result.skip = skip;
    }
    return $result;
  }
  danmaku_._() : super();
  factory danmaku_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory danmaku_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_danmaku', package: const $pb.PackageName(_omitMessageNames ? '' : 'danmaku'), createEmptyInstance: create)
    ..pc<data_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: data_.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'skip', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  danmaku_ clone() => danmaku_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  danmaku_ copyWith(void Function(danmaku_) updates) => super.copyWith((message) => updates(message as danmaku_)) as danmaku_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static danmaku_ create() => danmaku_._();
  danmaku_ createEmptyInstance() => create();
  static $pb.PbList<danmaku_> createRepeated() => $pb.PbList<danmaku_>();
  @$core.pragma('dart2js:noInline')
  static danmaku_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<danmaku_>(create);
  static danmaku_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<data_> get data => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get skip => $_getIZ(1);
  @$pb.TagNumber(2)
  set skip($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSkip() => $_has(1);
  @$pb.TagNumber(2)
  void clearSkip() => clearField(2);
}

class bilibili_danmaku_item_ extends $pb.GeneratedMessage {
  factory bilibili_danmaku_item_({
    $core.int? id,
    $core.int? progress,
    $core.int? mode,
    $core.int? fontsize,
    $core.int? color,
    $core.String? midHash,
    $core.String? content,
    $core.int? ctime,
    $core.int? weight,
    $core.String? action,
    $core.int? pool,
    $core.String? idStr,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (progress != null) {
      $result.progress = progress;
    }
    if (mode != null) {
      $result.mode = mode;
    }
    if (fontsize != null) {
      $result.fontsize = fontsize;
    }
    if (color != null) {
      $result.color = color;
    }
    if (midHash != null) {
      $result.midHash = midHash;
    }
    if (content != null) {
      $result.content = content;
    }
    if (ctime != null) {
      $result.ctime = ctime;
    }
    if (weight != null) {
      $result.weight = weight;
    }
    if (action != null) {
      $result.action = action;
    }
    if (pool != null) {
      $result.pool = pool;
    }
    if (idStr != null) {
      $result.idStr = idStr;
    }
    return $result;
  }
  bilibili_danmaku_item_._() : super();
  factory bilibili_danmaku_item_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bilibili_danmaku_item_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bilibili_danmaku_item', package: const $pb.PackageName(_omitMessageNames ? '' : 'danmaku'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'progress', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'fontsize', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'color', $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'midHash', protoName: 'midHash')
    ..aOS(7, _omitFieldNames ? '' : 'content')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'ctime', $pb.PbFieldType.OU3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'weight', $pb.PbFieldType.O3)
    ..aOS(10, _omitFieldNames ? '' : 'action')
    ..a<$core.int>(11, _omitFieldNames ? '' : 'pool', $pb.PbFieldType.O3)
    ..aOS(12, _omitFieldNames ? '' : 'idStr', protoName: 'idStr')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bilibili_danmaku_item_ clone() => bilibili_danmaku_item_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bilibili_danmaku_item_ copyWith(void Function(bilibili_danmaku_item_) updates) => super.copyWith((message) => updates(message as bilibili_danmaku_item_)) as bilibili_danmaku_item_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bilibili_danmaku_item_ create() => bilibili_danmaku_item_._();
  bilibili_danmaku_item_ createEmptyInstance() => create();
  static $pb.PbList<bilibili_danmaku_item_> createRepeated() => $pb.PbList<bilibili_danmaku_item_>();
  @$core.pragma('dart2js:noInline')
  static bilibili_danmaku_item_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bilibili_danmaku_item_>(create);
  static bilibili_danmaku_item_? _defaultInstance;

  /// 弹幕dmid
  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  /// 弹幕出现位置(单位ms)
  @$pb.TagNumber(2)
  $core.int get progress => $_getIZ(1);
  @$pb.TagNumber(2)
  set progress($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => clearField(2);

  /// 弹幕类型 1 2 3:普通弹幕 4:底部弹幕 5:顶部弹幕 6:逆向弹幕 7:高级弹幕 8:代码弹幕 9:BAS弹幕(pool必须为2)
  @$pb.TagNumber(3)
  $core.int get mode => $_getIZ(2);
  @$pb.TagNumber(3)
  set mode($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => clearField(3);

  /// 弹幕字号
  @$pb.TagNumber(4)
  $core.int get fontsize => $_getIZ(3);
  @$pb.TagNumber(4)
  set fontsize($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFontsize() => $_has(3);
  @$pb.TagNumber(4)
  void clearFontsize() => clearField(4);

  /// 弹幕颜色
  @$pb.TagNumber(5)
  $core.int get color => $_getIZ(4);
  @$pb.TagNumber(5)
  set color($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasColor() => $_has(4);
  @$pb.TagNumber(5)
  void clearColor() => clearField(5);

  /// 发送者mid hash
  @$pb.TagNumber(6)
  $core.String get midHash => $_getSZ(5);
  @$pb.TagNumber(6)
  set midHash($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMidHash() => $_has(5);
  @$pb.TagNumber(6)
  void clearMidHash() => clearField(6);

  /// 弹幕正文
  @$pb.TagNumber(7)
  $core.String get content => $_getSZ(6);
  @$pb.TagNumber(7)
  set content($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasContent() => $_has(6);
  @$pb.TagNumber(7)
  void clearContent() => clearField(7);

  /// 发送时间
  @$pb.TagNumber(8)
  $core.int get ctime => $_getIZ(7);
  @$pb.TagNumber(8)
  set ctime($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCtime() => $_has(7);
  @$pb.TagNumber(8)
  void clearCtime() => clearField(8);

  /// 权重 用于屏蔽等级 区间:[1,10]
  @$pb.TagNumber(9)
  $core.int get weight => $_getIZ(8);
  @$pb.TagNumber(9)
  set weight($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasWeight() => $_has(8);
  @$pb.TagNumber(9)
  void clearWeight() => clearField(9);

  /// 动作
  @$pb.TagNumber(10)
  $core.String get action => $_getSZ(9);
  @$pb.TagNumber(10)
  set action($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasAction() => $_has(9);
  @$pb.TagNumber(10)
  void clearAction() => clearField(10);

  /// 弹幕池 0:普通池 1:字幕池 2:特殊池(代码/BAS弹幕)
  @$pb.TagNumber(11)
  $core.int get pool => $_getIZ(10);
  @$pb.TagNumber(11)
  set pool($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasPool() => $_has(10);
  @$pb.TagNumber(11)
  void clearPool() => clearField(11);

  /// 弹幕dmid str
  @$pb.TagNumber(12)
  $core.String get idStr => $_getSZ(11);
  @$pb.TagNumber(12)
  set idStr($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasIdStr() => $_has(11);
  @$pb.TagNumber(12)
  void clearIdStr() => clearField(12);
}

class bilibili_danmaku_ extends $pb.GeneratedMessage {
  factory bilibili_danmaku_({
    $core.Iterable<bilibili_danmaku_item_>? list,
  }) {
    final $result = create();
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  bilibili_danmaku_._() : super();
  factory bilibili_danmaku_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bilibili_danmaku_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bilibili_danmaku', package: const $pb.PackageName(_omitMessageNames ? '' : 'danmaku'), createEmptyInstance: create)
    ..pc<bilibili_danmaku_item_>(1, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: bilibili_danmaku_item_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bilibili_danmaku_ clone() => bilibili_danmaku_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bilibili_danmaku_ copyWith(void Function(bilibili_danmaku_) updates) => super.copyWith((message) => updates(message as bilibili_danmaku_)) as bilibili_danmaku_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bilibili_danmaku_ create() => bilibili_danmaku_._();
  bilibili_danmaku_ createEmptyInstance() => create();
  static $pb.PbList<bilibili_danmaku_> createRepeated() => $pb.PbList<bilibili_danmaku_>();
  @$core.pragma('dart2js:noInline')
  static bilibili_danmaku_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bilibili_danmaku_>(create);
  static bilibili_danmaku_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<bilibili_danmaku_item_> get list => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
