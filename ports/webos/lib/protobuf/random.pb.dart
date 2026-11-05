//
//  Generated code. Do not modify.
//  source: random.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// 随机图像
class images_body_ extends $pb.GeneratedMessage {
  factory images_body_({
    $core.String? color,
    $core.int? width,
    $core.int? height,
    $core.String? image,
  }) {
    final $result = create();
    if (color != null) {
      $result.color = color;
    }
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (image != null) {
      $result.image = image;
    }
    return $result;
  }
  images_body_._() : super();
  factory images_body_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory images_body_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_images_body', package: const $pb.PackageName(_omitMessageNames ? '' : 'random'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'color')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..aOS(4, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  images_body_ clone() => images_body_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  images_body_ copyWith(void Function(images_body_) updates) => super.copyWith((message) => updates(message as images_body_)) as images_body_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static images_body_ create() => images_body_._();
  images_body_ createEmptyInstance() => create();
  static $pb.PbList<images_body_> createRepeated() => $pb.PbList<images_body_>();
  @$core.pragma('dart2js:noInline')
  static images_body_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<images_body_>(create);
  static images_body_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get color => $_getSZ(0);
  @$pb.TagNumber(1)
  set color($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearColor() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get width => $_getIZ(1);
  @$pb.TagNumber(2)
  set width($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearWidth() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get height => $_getIZ(2);
  @$pb.TagNumber(3)
  set height($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeight() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get image => $_getSZ(3);
  @$pb.TagNumber(4)
  set image($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearImage() => clearField(4);
}

class images_ extends $pb.GeneratedMessage {
  factory images_({
    $core.bool? error,
    $core.String? message,
    $core.Iterable<images_body_>? body,
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
  images_._() : super();
  factory images_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory images_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_images', package: const $pb.PackageName(_omitMessageNames ? '' : 'random'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'error')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<images_body_>(3, _omitFieldNames ? '' : 'body', $pb.PbFieldType.PM, subBuilder: images_body_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  images_ clone() => images_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  images_ copyWith(void Function(images_) updates) => super.copyWith((message) => updates(message as images_)) as images_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static images_ create() => images_._();
  images_ createEmptyInstance() => create();
  static $pb.PbList<images_> createRepeated() => $pb.PbList<images_>();
  @$core.pragma('dart2js:noInline')
  static images_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<images_>(create);
  static images_? _defaultInstance;

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
  $core.List<images_body_> get body => $_getList(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
