//
//  Generated code. Do not modify.
//  source: thread.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Images extends $pb.GeneratedMessage {
  factory Images({
    $core.String? color,
    $core.int? height,
    $core.int? width,
    $core.int? originalSize,
    $core.int? masterSize,
    $core.String? original,
    $core.String? master,
  }) {
    final $result = create();
    if (color != null) {
      $result.color = color;
    }
    if (height != null) {
      $result.height = height;
    }
    if (width != null) {
      $result.width = width;
    }
    if (originalSize != null) {
      $result.originalSize = originalSize;
    }
    if (masterSize != null) {
      $result.masterSize = masterSize;
    }
    if (original != null) {
      $result.original = original;
    }
    if (master != null) {
      $result.master = master;
    }
    return $result;
  }
  Images._() : super();
  factory Images.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Images.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Images', package: const $pb.PackageName(_omitMessageNames ? '' : 'thread'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'color')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'originalSize', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'masterSize', $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'original')
    ..aOS(7, _omitFieldNames ? '' : 'master')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Images clone() => Images()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Images copyWith(void Function(Images) updates) => super.copyWith((message) => updates(message as Images)) as Images;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Images create() => Images._();
  Images createEmptyInstance() => create();
  static $pb.PbList<Images> createRepeated() => $pb.PbList<Images>();
  @$core.pragma('dart2js:noInline')
  static Images getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Images>(create);
  static Images? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get color => $_getSZ(0);
  @$pb.TagNumber(1)
  set color($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearColor() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get width => $_getIZ(2);
  @$pb.TagNumber(3)
  set width($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearWidth() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get originalSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set originalSize($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOriginalSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginalSize() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get masterSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set masterSize($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMasterSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearMasterSize() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get original => $_getSZ(5);
  @$pb.TagNumber(6)
  set original($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasOriginal() => $_has(5);
  @$pb.TagNumber(6)
  void clearOriginal() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get master => $_getSZ(6);
  @$pb.TagNumber(7)
  set master($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaster() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaster() => clearField(7);
}

class Tags extends $pb.GeneratedMessage {
  factory Tags({
    $core.String? name,
    $core.String? translate,
    $core.String? color,
    $core.String? image,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (translate != null) {
      $result.translate = translate;
    }
    if (color != null) {
      $result.color = color;
    }
    if (image != null) {
      $result.image = image;
    }
    return $result;
  }
  Tags._() : super();
  factory Tags.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Tags.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Tags', package: const $pb.PackageName(_omitMessageNames ? '' : 'thread'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'translate')
    ..aOS(3, _omitFieldNames ? '' : 'color')
    ..aOS(4, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Tags clone() => Tags()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Tags copyWith(void Function(Tags) updates) => super.copyWith((message) => updates(message as Tags)) as Tags;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tags create() => Tags._();
  Tags createEmptyInstance() => create();
  static $pb.PbList<Tags> createRepeated() => $pb.PbList<Tags>();
  @$core.pragma('dart2js:noInline')
  static Tags getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tags>(create);
  static Tags? _defaultInstance;

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
  $core.String get color => $_getSZ(2);
  @$pb.TagNumber(3)
  set color($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearColor() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get image => $_getSZ(3);
  @$pb.TagNumber(4)
  set image($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearImage() => clearField(4);
}

class thread_ extends $pb.GeneratedMessage {
  factory thread_({
    $core.int? id,
    $core.String? title,
    $core.bool? ai,
    $core.int? viewsCount,
    $core.int? collectsCount,
    $core.int? likesCount,
    $core.double? date,
    $core.double? created,
    $core.double? updated,
    $core.String? type,
    $core.bool? nsfw,
    $core.String? source,
    $core.Iterable<Images>? images,
    $core.Iterable<Tags>? tags,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (title != null) {
      $result.title = title;
    }
    if (ai != null) {
      $result.ai = ai;
    }
    if (viewsCount != null) {
      $result.viewsCount = viewsCount;
    }
    if (collectsCount != null) {
      $result.collectsCount = collectsCount;
    }
    if (likesCount != null) {
      $result.likesCount = likesCount;
    }
    if (date != null) {
      $result.date = date;
    }
    if (created != null) {
      $result.created = created;
    }
    if (updated != null) {
      $result.updated = updated;
    }
    if (type != null) {
      $result.type = type;
    }
    if (nsfw != null) {
      $result.nsfw = nsfw;
    }
    if (source != null) {
      $result.source = source;
    }
    if (images != null) {
      $result.images.addAll(images);
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    return $result;
  }
  thread_._() : super();
  factory thread_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory thread_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_thread', package: const $pb.PackageName(_omitMessageNames ? '' : 'thread'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOB(3, _omitFieldNames ? '' : 'ai')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'viewsCount', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'collectsCount', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'likesCount', $pb.PbFieldType.OU3)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'date', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'created', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'updated', $pb.PbFieldType.OD)
    ..aOS(10, _omitFieldNames ? '' : 'type')
    ..aOB(11, _omitFieldNames ? '' : 'nsfw')
    ..aOS(12, _omitFieldNames ? '' : 'source')
    ..pc<Images>(13, _omitFieldNames ? '' : 'images', $pb.PbFieldType.PM, subBuilder: Images.create)
    ..pc<Tags>(14, _omitFieldNames ? '' : 'tags', $pb.PbFieldType.PM, subBuilder: Tags.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  thread_ clone() => thread_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  thread_ copyWith(void Function(thread_) updates) => super.copyWith((message) => updates(message as thread_)) as thread_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static thread_ create() => thread_._();
  thread_ createEmptyInstance() => create();
  static $pb.PbList<thread_> createRepeated() => $pb.PbList<thread_>();
  @$core.pragma('dart2js:noInline')
  static thread_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<thread_>(create);
  static thread_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get ai => $_getBF(2);
  @$pb.TagNumber(3)
  set ai($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAi() => $_has(2);
  @$pb.TagNumber(3)
  void clearAi() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get viewsCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set viewsCount($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasViewsCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearViewsCount() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get collectsCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set collectsCount($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCollectsCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearCollectsCount() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get likesCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set likesCount($core.int v) { $_setUnsignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLikesCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearLikesCount() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get date => $_getN(6);
  @$pb.TagNumber(7)
  set date($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearDate() => clearField(7);

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
  $core.String get type => $_getSZ(9);
  @$pb.TagNumber(10)
  set type($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasType() => $_has(9);
  @$pb.TagNumber(10)
  void clearType() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get nsfw => $_getBF(10);
  @$pb.TagNumber(11)
  set nsfw($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasNsfw() => $_has(10);
  @$pb.TagNumber(11)
  void clearNsfw() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get source => $_getSZ(11);
  @$pb.TagNumber(12)
  set source($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSource() => $_has(11);
  @$pb.TagNumber(12)
  void clearSource() => clearField(12);

  @$pb.TagNumber(13)
  $core.List<Images> get images => $_getList(12);

  @$pb.TagNumber(14)
  $core.List<Tags> get tags => $_getList(13);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
