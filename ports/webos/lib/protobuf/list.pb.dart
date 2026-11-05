//
//  Generated code. Do not modify.
//  source: list.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// 文章列表
class thread_list_data_ extends $pb.GeneratedMessage {
  factory thread_list_data_({
    $core.bool? ai,
    $core.int? id,
    $core.bool? nsfw,
    $core.String? title,
    $core.String? image,
    $core.int? count,
    $core.String? color,
    $core.int? width,
    $core.int? height,
  }) {
    final $result = create();
    if (ai != null) {
      $result.ai = ai;
    }
    if (id != null) {
      $result.id = id;
    }
    if (nsfw != null) {
      $result.nsfw = nsfw;
    }
    if (title != null) {
      $result.title = title;
    }
    if (image != null) {
      $result.image = image;
    }
    if (count != null) {
      $result.count = count;
    }
    if (color != null) {
      $result.color = color;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    return $result;
  }
  thread_list_data_._() : super();
  factory thread_list_data_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory thread_list_data_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_thread_list_data', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'ai')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOB(3, _omitFieldNames ? '' : 'nsfw')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'image')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU3)
    ..aOS(7, _omitFieldNames ? '' : 'color')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  thread_list_data_ clone() => thread_list_data_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  thread_list_data_ copyWith(void Function(thread_list_data_) updates) => super.copyWith((message) => updates(message as thread_list_data_)) as thread_list_data_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static thread_list_data_ create() => thread_list_data_._();
  thread_list_data_ createEmptyInstance() => create();
  static $pb.PbList<thread_list_data_> createRepeated() => $pb.PbList<thread_list_data_>();
  @$core.pragma('dart2js:noInline')
  static thread_list_data_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<thread_list_data_>(create);
  static thread_list_data_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get ai => $_getBF(0);
  @$pb.TagNumber(1)
  set ai($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAi() => $_has(0);
  @$pb.TagNumber(1)
  void clearAi() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(2)
  set id($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get nsfw => $_getBF(2);
  @$pb.TagNumber(3)
  set nsfw($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNsfw() => $_has(2);
  @$pb.TagNumber(3)
  void clearNsfw() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get image => $_getSZ(4);
  @$pb.TagNumber(5)
  set image($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImage() => $_has(4);
  @$pb.TagNumber(5)
  void clearImage() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get count => $_getIZ(5);
  @$pb.TagNumber(6)
  set count($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearCount() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get color => $_getSZ(6);
  @$pb.TagNumber(7)
  set color($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasColor() => $_has(6);
  @$pb.TagNumber(7)
  void clearColor() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get width => $_getIZ(7);
  @$pb.TagNumber(8)
  set width($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasWidth() => $_has(7);
  @$pb.TagNumber(8)
  void clearWidth() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get height => $_getIZ(8);
  @$pb.TagNumber(9)
  set height($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasHeight() => $_has(8);
  @$pb.TagNumber(9)
  void clearHeight() => clearField(9);
}

class thread_list_body_ extends $pb.GeneratedMessage {
  factory thread_list_body_({
    $core.Iterable<thread_list_data_>? data,
    $core.int? prev,
    $core.int? next,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    if (prev != null) {
      $result.prev = prev;
    }
    if (next != null) {
      $result.next = next;
    }
    return $result;
  }
  thread_list_body_._() : super();
  factory thread_list_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory thread_list_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_thread_list_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..pc<thread_list_data_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: thread_list_data_.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'prev', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'next', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  thread_list_body_ clone() => thread_list_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  thread_list_body_ copyWith(void Function(thread_list_body_) updates) => super.copyWith((message) => updates(message as thread_list_body_)) as thread_list_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static thread_list_body_ create() => thread_list_body_._();
  thread_list_body_ createEmptyInstance() => create();
  static $pb.PbList<thread_list_body_> createRepeated() => $pb.PbList<thread_list_body_>();
  @$core.pragma('dart2js:noInline')
  static thread_list_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<thread_list_body_>(create);
  static thread_list_body_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<thread_list_data_> get data => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get prev => $_getIZ(1);
  @$pb.TagNumber(2)
  set prev($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPrev() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrev() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get next => $_getIZ(2);
  @$pb.TagNumber(3)
  set next($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNext() => $_has(2);
  @$pb.TagNumber(3)
  void clearNext() => clearField(3);
}

class thread_list_ extends $pb.GeneratedMessage {
  factory thread_list_({
    $core.bool? error,
    $core.String? message,
    thread_list_body_? body,
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
  thread_list_._() : super();
  factory thread_list_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory thread_list_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_thread_list', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<thread_list_body_>(3, _omitFieldNames ? '' : 'body', subBuilder: thread_list_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  thread_list_ clone() => thread_list_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  thread_list_ copyWith(void Function(thread_list_) updates) => super.copyWith((message) => updates(message as thread_list_)) as thread_list_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static thread_list_ create() => thread_list_._();
  thread_list_ createEmptyInstance() => create();
  static $pb.PbList<thread_list_> createRepeated() => $pb.PbList<thread_list_>();
  @$core.pragma('dart2js:noInline')
  static thread_list_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<thread_list_>(create);
  static thread_list_? _defaultInstance;

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
  thread_list_body_ get body => $_getN(2);
  @$pb.TagNumber(3)
  set body(thread_list_body_ v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);
  @$pb.TagNumber(3)
  thread_list_body_ ensureBody() => $_ensure(2);
}

/// 关键词-自动完成
class autocomplete_body_ extends $pb.GeneratedMessage {
  factory autocomplete_body_({
    $core.String? name,
    $core.String? translate,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (translate != null) {
      $result.translate = translate;
    }
    return $result;
  }
  autocomplete_body_._() : super();
  factory autocomplete_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory autocomplete_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_autocomplete_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'translate')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  autocomplete_body_ clone() => autocomplete_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  autocomplete_body_ copyWith(void Function(autocomplete_body_) updates) => super.copyWith((message) => updates(message as autocomplete_body_)) as autocomplete_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static autocomplete_body_ create() => autocomplete_body_._();
  autocomplete_body_ createEmptyInstance() => create();
  static $pb.PbList<autocomplete_body_> createRepeated() => $pb.PbList<autocomplete_body_>();
  @$core.pragma('dart2js:noInline')
  static autocomplete_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<autocomplete_body_>(create);
  static autocomplete_body_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get translate => $_getSZ(1);
  @$pb.TagNumber(2)
  set translate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTranslate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranslate() => clearField(2);
}

class autocomplete_ extends $pb.GeneratedMessage {
  factory autocomplete_({
    $core.bool? error,
    $core.String? message,
    $core.Iterable<autocomplete_body_>? body,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    if (message != null) {
      $result.message = message;
    }
    if (body != null) {
      $result.body.addAll(body);
    }
    return $result;
  }
  autocomplete_._() : super();
  factory autocomplete_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory autocomplete_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_autocomplete', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<autocomplete_body_>(3, _omitFieldNames ? '' : 'body', $pb.PbFieldType.PM, subBuilder: autocomplete_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  autocomplete_ clone() => autocomplete_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  autocomplete_ copyWith(void Function(autocomplete_) updates) => super.copyWith((message) => updates(message as autocomplete_)) as autocomplete_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static autocomplete_ create() => autocomplete_._();
  autocomplete_ createEmptyInstance() => create();
  static $pb.PbList<autocomplete_> createRepeated() => $pb.PbList<autocomplete_>();
  @$core.pragma('dart2js:noInline')
  static autocomplete_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<autocomplete_>(create);
  static autocomplete_? _defaultInstance;

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
  $core.List<autocomplete_body_> get body => $_getList(2);
}

/// 标签-信息
class tag_info_related_ extends $pb.GeneratedMessage {
  factory tag_info_related_({
    $core.String? name,
    $core.String? translate,
    $core.String? image,
    $core.String? color,
    $core.int? q,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (translate != null) {
      $result.translate = translate;
    }
    if (image != null) {
      $result.image = image;
    }
    if (color != null) {
      $result.color = color;
    }
    if (q != null) {
      $result.q = q;
    }
    return $result;
  }
  tag_info_related_._() : super();
  factory tag_info_related_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory tag_info_related_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_tag_info_related', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'translate')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aOS(4, _omitFieldNames ? '' : 'color')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'q', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  tag_info_related_ clone() => tag_info_related_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  tag_info_related_ copyWith(void Function(tag_info_related_) updates) => super.copyWith((message) => updates(message as tag_info_related_)) as tag_info_related_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static tag_info_related_ create() => tag_info_related_._();
  tag_info_related_ createEmptyInstance() => create();
  static $pb.PbList<tag_info_related_> createRepeated() => $pb.PbList<tag_info_related_>();
  @$core.pragma('dart2js:noInline')
  static tag_info_related_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<tag_info_related_>(create);
  static tag_info_related_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get translate => $_getSZ(1);
  @$pb.TagNumber(2)
  set translate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTranslate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranslate() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get color => $_getSZ(3);
  @$pb.TagNumber(4)
  set color($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasColor() => $_has(3);
  @$pb.TagNumber(4)
  void clearColor() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get q => $_getIZ(4);
  @$pb.TagNumber(5)
  set q($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasQ() => $_has(4);
  @$pb.TagNumber(5)
  void clearQ() => clearField(5);
}

class tag_info_body_ extends $pb.GeneratedMessage {
  factory tag_info_body_({
    $core.String? name,
    $core.String? translate,
    $core.int? count,
    $core.String? desc,
    $core.String? image,
    $core.String? color,
    $core.Iterable<tag_info_related_>? related,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (translate != null) {
      $result.translate = translate;
    }
    if (count != null) {
      $result.count = count;
    }
    if (desc != null) {
      $result.desc = desc;
    }
    if (image != null) {
      $result.image = image;
    }
    if (color != null) {
      $result.color = color;
    }
    if (related != null) {
      $result.related.addAll(related);
    }
    return $result;
  }
  tag_info_body_._() : super();
  factory tag_info_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory tag_info_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_tag_info_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'translate')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'desc')
    ..aOS(5, _omitFieldNames ? '' : 'image')
    ..aOS(6, _omitFieldNames ? '' : 'color')
    ..pc<tag_info_related_>(7, _omitFieldNames ? '' : 'related', $pb.PbFieldType.PM, subBuilder: tag_info_related_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  tag_info_body_ clone() => tag_info_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  tag_info_body_ copyWith(void Function(tag_info_body_) updates) => super.copyWith((message) => updates(message as tag_info_body_)) as tag_info_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static tag_info_body_ create() => tag_info_body_._();
  tag_info_body_ createEmptyInstance() => create();
  static $pb.PbList<tag_info_body_> createRepeated() => $pb.PbList<tag_info_body_>();
  @$core.pragma('dart2js:noInline')
  static tag_info_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<tag_info_body_>(create);
  static tag_info_body_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get translate => $_getSZ(1);
  @$pb.TagNumber(2)
  set translate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTranslate() => $_has(1);
  @$pb.TagNumber(2)
  void clearTranslate() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get desc => $_getSZ(3);
  @$pb.TagNumber(4)
  set desc($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDesc() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesc() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get image => $_getSZ(4);
  @$pb.TagNumber(5)
  set image($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImage() => $_has(4);
  @$pb.TagNumber(5)
  void clearImage() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get color => $_getSZ(5);
  @$pb.TagNumber(6)
  set color($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasColor() => $_has(5);
  @$pb.TagNumber(6)
  void clearColor() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<tag_info_related_> get related => $_getList(6);
}

class tag_info_ extends $pb.GeneratedMessage {
  factory tag_info_({
    $core.bool? error,
    $core.String? message,
    tag_info_body_? body,
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
  tag_info_._() : super();
  factory tag_info_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory tag_info_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_tag_info', package: const $pb.PackageName(_omitMessageNames ? '' : 'list'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<tag_info_body_>(3, _omitFieldNames ? '' : 'body', subBuilder: tag_info_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  tag_info_ clone() => tag_info_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  tag_info_ copyWith(void Function(tag_info_) updates) => super.copyWith((message) => updates(message as tag_info_)) as tag_info_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static tag_info_ create() => tag_info_._();
  tag_info_ createEmptyInstance() => create();
  static $pb.PbList<tag_info_> createRepeated() => $pb.PbList<tag_info_>();
  @$core.pragma('dart2js:noInline')
  static tag_info_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<tag_info_>(create);
  static tag_info_? _defaultInstance;

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
  tag_info_body_ get body => $_getN(2);
  @$pb.TagNumber(3)
  set body(tag_info_body_ v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);
  @$pb.TagNumber(3)
  tag_info_body_ ensureBody() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
