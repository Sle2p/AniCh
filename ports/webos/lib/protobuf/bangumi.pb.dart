//
//  Generated code. Do not modify.
//  source: bangumi.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class vod_item_ extends $pb.GeneratedMessage {
  factory vod_item_({
    $core.String? url,
    $core.int? sort,
    $core.String? type,
    $core.String? caption,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    if (sort != null) {
      $result.sort = sort;
    }
    if (type != null) {
      $result.type = type;
    }
    if (caption != null) {
      $result.caption = caption;
    }
    return $result;
  }
  vod_item_._() : super();
  factory vod_item_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory vod_item_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_vod_item', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'sort', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'type')
    ..aOS(4, _omitFieldNames ? '' : 'caption')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  vod_item_ clone() => vod_item_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  vod_item_ copyWith(void Function(vod_item_) updates) => super.copyWith((message) => updates(message as vod_item_)) as vod_item_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static vod_item_ create() => vod_item_._();
  vod_item_ createEmptyInstance() => create();
  static $pb.PbList<vod_item_> createRepeated() => $pb.PbList<vod_item_>();
  @$core.pragma('dart2js:noInline')
  static vod_item_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<vod_item_>(create);
  static vod_item_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get sort => $_getIZ(1);
  @$pb.TagNumber(2)
  set sort($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSort() => $_has(1);
  @$pb.TagNumber(2)
  void clearSort() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get type => $_getSZ(2);
  @$pb.TagNumber(3)
  set type($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get caption => $_getSZ(3);
  @$pb.TagNumber(4)
  set caption($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCaption() => $_has(3);
  @$pb.TagNumber(4)
  void clearCaption() => clearField(4);
}

class vod_ extends $pb.GeneratedMessage {
  factory vod_({
    $core.Iterable<vod_item_>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  vod_._() : super();
  factory vod_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory vod_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_vod', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..pc<vod_item_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: vod_item_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  vod_ clone() => vod_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  vod_ copyWith(void Function(vod_) updates) => super.copyWith((message) => updates(message as vod_)) as vod_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static vod_ create() => vod_._();
  vod_ createEmptyInstance() => create();
  static $pb.PbList<vod_> createRepeated() => $pb.PbList<vod_>();
  @$core.pragma('dart2js:noInline')
  static vod_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<vod_>(create);
  static vod_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<vod_item_> get data => $_getList(0);
}

/// 节目列表
class bangumi_list_item_ extends $pb.GeneratedMessage {
  factory bangumi_list_item_({
    $core.int? id,
    $core.String? title,
    $core.int? episode,
    $core.int? episodesTotal,
    $core.String? status,
    $core.double? date,
    $core.String? image,
    $core.String? tagline,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (title != null) {
      $result.title = title;
    }
    if (episode != null) {
      $result.episode = episode;
    }
    if (episodesTotal != null) {
      $result.episodesTotal = episodesTotal;
    }
    if (status != null) {
      $result.status = status;
    }
    if (date != null) {
      $result.date = date;
    }
    if (image != null) {
      $result.image = image;
    }
    if (tagline != null) {
      $result.tagline = tagline;
    }
    return $result;
  }
  bangumi_list_item_._() : super();
  factory bangumi_list_item_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_list_item_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_list_item', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'episode', $pb.PbFieldType.OU3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'episodesTotal', $pb.PbFieldType.OU3)
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'date', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'image')
    ..aOS(8, _omitFieldNames ? '' : 'tagline')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_list_item_ clone() => bangumi_list_item_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_list_item_ copyWith(void Function(bangumi_list_item_) updates) => super.copyWith((message) => updates(message as bangumi_list_item_)) as bangumi_list_item_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_list_item_ create() => bangumi_list_item_._();
  bangumi_list_item_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_list_item_> createRepeated() => $pb.PbList<bangumi_list_item_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_list_item_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_list_item_>(create);
  static bangumi_list_item_? _defaultInstance;

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
  $core.int get episode => $_getIZ(2);
  @$pb.TagNumber(3)
  set episode($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEpisode() => $_has(2);
  @$pb.TagNumber(3)
  void clearEpisode() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get episodesTotal => $_getIZ(3);
  @$pb.TagNumber(4)
  set episodesTotal($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasEpisodesTotal() => $_has(3);
  @$pb.TagNumber(4)
  void clearEpisodesTotal() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get date => $_getN(5);
  @$pb.TagNumber(6)
  set date($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDate() => $_has(5);
  @$pb.TagNumber(6)
  void clearDate() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get image => $_getSZ(6);
  @$pb.TagNumber(7)
  set image($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasImage() => $_has(6);
  @$pb.TagNumber(7)
  void clearImage() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get tagline => $_getSZ(7);
  @$pb.TagNumber(8)
  set tagline($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTagline() => $_has(7);
  @$pb.TagNumber(8)
  void clearTagline() => clearField(8);
}

class bangumi_list_ extends $pb.GeneratedMessage {
  factory bangumi_list_({
    $core.Iterable<bangumi_list_item_>? data,
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
  bangumi_list_._() : super();
  factory bangumi_list_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_list_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_list', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..pc<bangumi_list_item_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: bangumi_list_item_.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'prev', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'next', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_list_ clone() => bangumi_list_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_list_ copyWith(void Function(bangumi_list_) updates) => super.copyWith((message) => updates(message as bangumi_list_)) as bangumi_list_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_list_ create() => bangumi_list_._();
  bangumi_list_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_list_> createRepeated() => $pb.PbList<bangumi_list_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_list_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_list_>(create);
  static bangumi_list_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<bangumi_list_item_> get data => $_getList(0);

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

/// 最近更新
class bangumi_latest_item_ extends $pb.GeneratedMessage {
  factory bangumi_latest_item_({
    $core.bool? status,
    $core.int? id,
    $core.int? ep,
    $core.double? airdate,
    $core.int? duration,
    $core.String? image,
    $core.String? title,
    $core.String? name,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (id != null) {
      $result.id = id;
    }
    if (ep != null) {
      $result.ep = ep;
    }
    if (airdate != null) {
      $result.airdate = airdate;
    }
    if (duration != null) {
      $result.duration = duration;
    }
    if (image != null) {
      $result.image = image;
    }
    if (title != null) {
      $result.title = title;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  bangumi_latest_item_._() : super();
  factory bangumi_latest_item_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_latest_item_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_latest_item', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'status')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'ep', $pb.PbFieldType.OU3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'airdate', $pb.PbFieldType.OD)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'duration', $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'image')
    ..aOS(7, _omitFieldNames ? '' : 'title')
    ..aOS(8, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_latest_item_ clone() => bangumi_latest_item_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_latest_item_ copyWith(void Function(bangumi_latest_item_) updates) => super.copyWith((message) => updates(message as bangumi_latest_item_)) as bangumi_latest_item_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_latest_item_ create() => bangumi_latest_item_._();
  bangumi_latest_item_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_latest_item_> createRepeated() => $pb.PbList<bangumi_latest_item_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_latest_item_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_latest_item_>(create);
  static bangumi_latest_item_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get status => $_getBF(0);
  @$pb.TagNumber(1)
  set status($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get id => $_getIZ(1);
  @$pb.TagNumber(2)
  set id($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get ep => $_getIZ(2);
  @$pb.TagNumber(3)
  set ep($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEp() => $_has(2);
  @$pb.TagNumber(3)
  void clearEp() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get airdate => $_getN(3);
  @$pb.TagNumber(4)
  set airdate($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAirdate() => $_has(3);
  @$pb.TagNumber(4)
  void clearAirdate() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get duration => $_getIZ(4);
  @$pb.TagNumber(5)
  set duration($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDuration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDuration() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get image => $_getSZ(5);
  @$pb.TagNumber(6)
  set image($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasImage() => $_has(5);
  @$pb.TagNumber(6)
  void clearImage() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(6);
  @$pb.TagNumber(7)
  set title($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitle() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get name => $_getSZ(7);
  @$pb.TagNumber(8)
  set name($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasName() => $_has(7);
  @$pb.TagNumber(8)
  void clearName() => clearField(8);
}

class bangumi_latest_ extends $pb.GeneratedMessage {
  factory bangumi_latest_({
    $core.Iterable<bangumi_latest_item_>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  bangumi_latest_._() : super();
  factory bangumi_latest_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_latest_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_latest', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..pc<bangumi_latest_item_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: bangumi_latest_item_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_latest_ clone() => bangumi_latest_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_latest_ copyWith(void Function(bangumi_latest_) updates) => super.copyWith((message) => updates(message as bangumi_latest_)) as bangumi_latest_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_latest_ create() => bangumi_latest_._();
  bangumi_latest_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_latest_> createRepeated() => $pb.PbList<bangumi_latest_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_latest_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_latest_>(create);
  static bangumi_latest_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<bangumi_latest_item_> get data => $_getList(0);
}

/// 章节
class bangumi_episodes_sites_ extends $pb.GeneratedMessage {
  factory bangumi_episodes_sites_({
    $core.String? site,
    $core.String? id,
  }) {
    final $result = create();
    if (site != null) {
      $result.site = site;
    }
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  bangumi_episodes_sites_._() : super();
  factory bangumi_episodes_sites_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_episodes_sites_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_episodes_sites', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'site')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_episodes_sites_ clone() => bangumi_episodes_sites_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_episodes_sites_ copyWith(void Function(bangumi_episodes_sites_) updates) => super.copyWith((message) => updates(message as bangumi_episodes_sites_)) as bangumi_episodes_sites_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_sites_ create() => bangumi_episodes_sites_._();
  bangumi_episodes_sites_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_episodes_sites_> createRepeated() => $pb.PbList<bangumi_episodes_sites_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_sites_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_episodes_sites_>(create);
  static bangumi_episodes_sites_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get site => $_getSZ(0);
  @$pb.TagNumber(1)
  set site($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSite() => $_has(0);
  @$pb.TagNumber(1)
  void clearSite() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);
}

class bangumi_episodes_rating_ extends $pb.GeneratedMessage {
  factory bangumi_episodes_rating_({
    $core.String? site,
    $core.int? score,
    $core.int? count,
  }) {
    final $result = create();
    if (site != null) {
      $result.site = site;
    }
    if (score != null) {
      $result.score = score;
    }
    if (count != null) {
      $result.count = count;
    }
    return $result;
  }
  bangumi_episodes_rating_._() : super();
  factory bangumi_episodes_rating_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_episodes_rating_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_episodes_rating', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'site')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'score', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'count', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_episodes_rating_ clone() => bangumi_episodes_rating_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_episodes_rating_ copyWith(void Function(bangumi_episodes_rating_) updates) => super.copyWith((message) => updates(message as bangumi_episodes_rating_)) as bangumi_episodes_rating_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_rating_ create() => bangumi_episodes_rating_._();
  bangumi_episodes_rating_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_episodes_rating_> createRepeated() => $pb.PbList<bangumi_episodes_rating_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_rating_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_episodes_rating_>(create);
  static bangumi_episodes_rating_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get site => $_getSZ(0);
  @$pb.TagNumber(1)
  set site($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSite() => $_has(0);
  @$pb.TagNumber(1)
  void clearSite() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get score => $_getIZ(1);
  @$pb.TagNumber(2)
  set score($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearScore() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get count => $_getIZ(2);
  @$pb.TagNumber(3)
  set count($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearCount() => clearField(3);
}

class bangumi_episodes_data_ extends $pb.GeneratedMessage {
  factory bangumi_episodes_data_({
    $core.bool? status,
    $core.int? sort,
    $core.double? airdate,
    $core.int? duration,
    $core.Iterable<bangumi_episodes_sites_>? sites,
    $core.Iterable<bangumi_episodes_rating_>? rating,
    $core.String? image,
    $core.String? title,
    $core.String? overview,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (sort != null) {
      $result.sort = sort;
    }
    if (airdate != null) {
      $result.airdate = airdate;
    }
    if (duration != null) {
      $result.duration = duration;
    }
    if (sites != null) {
      $result.sites.addAll(sites);
    }
    if (rating != null) {
      $result.rating.addAll(rating);
    }
    if (image != null) {
      $result.image = image;
    }
    if (title != null) {
      $result.title = title;
    }
    if (overview != null) {
      $result.overview = overview;
    }
    return $result;
  }
  bangumi_episodes_data_._() : super();
  factory bangumi_episodes_data_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_episodes_data_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_episodes_data', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'status')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'sort', $pb.PbFieldType.OU3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'airdate', $pb.PbFieldType.OD)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'duration', $pb.PbFieldType.OU3)
    ..pc<bangumi_episodes_sites_>(5, _omitFieldNames ? '' : 'sites', $pb.PbFieldType.PM, subBuilder: bangumi_episodes_sites_.create)
    ..pc<bangumi_episodes_rating_>(6, _omitFieldNames ? '' : 'rating', $pb.PbFieldType.PM, subBuilder: bangumi_episodes_rating_.create)
    ..aOS(7, _omitFieldNames ? '' : 'image')
    ..aOS(8, _omitFieldNames ? '' : 'title')
    ..aOS(9, _omitFieldNames ? '' : 'overview')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_episodes_data_ clone() => bangumi_episodes_data_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_episodes_data_ copyWith(void Function(bangumi_episodes_data_) updates) => super.copyWith((message) => updates(message as bangumi_episodes_data_)) as bangumi_episodes_data_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_data_ create() => bangumi_episodes_data_._();
  bangumi_episodes_data_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_episodes_data_> createRepeated() => $pb.PbList<bangumi_episodes_data_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_data_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_episodes_data_>(create);
  static bangumi_episodes_data_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get status => $_getBF(0);
  @$pb.TagNumber(1)
  set status($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get sort => $_getIZ(1);
  @$pb.TagNumber(2)
  set sort($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSort() => $_has(1);
  @$pb.TagNumber(2)
  void clearSort() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get airdate => $_getN(2);
  @$pb.TagNumber(3)
  set airdate($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAirdate() => $_has(2);
  @$pb.TagNumber(3)
  void clearAirdate() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get duration => $_getIZ(3);
  @$pb.TagNumber(4)
  set duration($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<bangumi_episodes_sites_> get sites => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<bangumi_episodes_rating_> get rating => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get image => $_getSZ(6);
  @$pb.TagNumber(7)
  set image($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasImage() => $_has(6);
  @$pb.TagNumber(7)
  void clearImage() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get title => $_getSZ(7);
  @$pb.TagNumber(8)
  set title($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTitle() => $_has(7);
  @$pb.TagNumber(8)
  void clearTitle() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get overview => $_getSZ(8);
  @$pb.TagNumber(9)
  set overview($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasOverview() => $_has(8);
  @$pb.TagNumber(9)
  void clearOverview() => clearField(9);
}

class bangumi_episodes_ extends $pb.GeneratedMessage {
  factory bangumi_episodes_({
    $core.Iterable<bangumi_episodes_data_>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  bangumi_episodes_._() : super();
  factory bangumi_episodes_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_episodes_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_episodes', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..pc<bangumi_episodes_data_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: bangumi_episodes_data_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_episodes_ clone() => bangumi_episodes_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_episodes_ copyWith(void Function(bangumi_episodes_) updates) => super.copyWith((message) => updates(message as bangumi_episodes_)) as bangumi_episodes_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_ create() => bangumi_episodes_._();
  bangumi_episodes_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_episodes_> createRepeated() => $pb.PbList<bangumi_episodes_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_episodes_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_episodes_>(create);
  static bangumi_episodes_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<bangumi_episodes_data_> get data => $_getList(0);
}

/// 角色列表
class bangumi_characters_actors_ extends $pb.GeneratedMessage {
  factory bangumi_characters_actors_({
    $core.int? id,
    $core.String? name,
    $core.String? image,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (image != null) {
      $result.image = image;
    }
    return $result;
  }
  bangumi_characters_actors_._() : super();
  factory bangumi_characters_actors_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_characters_actors_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_characters_actors', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_characters_actors_ clone() => bangumi_characters_actors_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_characters_actors_ copyWith(void Function(bangumi_characters_actors_) updates) => super.copyWith((message) => updates(message as bangumi_characters_actors_)) as bangumi_characters_actors_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_characters_actors_ create() => bangumi_characters_actors_._();
  bangumi_characters_actors_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_characters_actors_> createRepeated() => $pb.PbList<bangumi_characters_actors_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_characters_actors_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_characters_actors_>(create);
  static bangumi_characters_actors_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => clearField(3);
}

class bangumi_characters_data_ extends $pb.GeneratedMessage {
  factory bangumi_characters_data_({
    $core.int? id,
    $core.String? role,
    $core.String? name,
    $core.String? image,
    $core.Iterable<bangumi_characters_actors_>? actors,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (role != null) {
      $result.role = role;
    }
    if (name != null) {
      $result.name = name;
    }
    if (image != null) {
      $result.image = image;
    }
    if (actors != null) {
      $result.actors.addAll(actors);
    }
    return $result;
  }
  bangumi_characters_data_._() : super();
  factory bangumi_characters_data_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_characters_data_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_characters_data', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'role')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'image')
    ..pc<bangumi_characters_actors_>(5, _omitFieldNames ? '' : 'actors', $pb.PbFieldType.PM, subBuilder: bangumi_characters_actors_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_characters_data_ clone() => bangumi_characters_data_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_characters_data_ copyWith(void Function(bangumi_characters_data_) updates) => super.copyWith((message) => updates(message as bangumi_characters_data_)) as bangumi_characters_data_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_characters_data_ create() => bangumi_characters_data_._();
  bangumi_characters_data_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_characters_data_> createRepeated() => $pb.PbList<bangumi_characters_data_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_characters_data_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_characters_data_>(create);
  static bangumi_characters_data_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get role => $_getSZ(1);
  @$pb.TagNumber(2)
  set role($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRole() => $_has(1);
  @$pb.TagNumber(2)
  void clearRole() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get image => $_getSZ(3);
  @$pb.TagNumber(4)
  set image($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasImage() => $_has(3);
  @$pb.TagNumber(4)
  void clearImage() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<bangumi_characters_actors_> get actors => $_getList(4);
}

class bangumi_characters_ extends $pb.GeneratedMessage {
  factory bangumi_characters_({
    $core.Iterable<bangumi_characters_data_>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  bangumi_characters_._() : super();
  factory bangumi_characters_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_characters_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_characters', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..pc<bangumi_characters_data_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: bangumi_characters_data_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_characters_ clone() => bangumi_characters_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_characters_ copyWith(void Function(bangumi_characters_) updates) => super.copyWith((message) => updates(message as bangumi_characters_)) as bangumi_characters_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_characters_ create() => bangumi_characters_._();
  bangumi_characters_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_characters_> createRepeated() => $pb.PbList<bangumi_characters_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_characters_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_characters_>(create);
  static bangumi_characters_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<bangumi_characters_data_> get data => $_getList(0);
}

/// 人物列表
class bangumi_persons_data_ extends $pb.GeneratedMessage {
  factory bangumi_persons_data_({
    $core.int? id,
    $core.String? name,
    $core.String? image,
    $core.String? jobs,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (image != null) {
      $result.image = image;
    }
    if (jobs != null) {
      $result.jobs = jobs;
    }
    return $result;
  }
  bangumi_persons_data_._() : super();
  factory bangumi_persons_data_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_persons_data_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_persons_data', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'image')
    ..aOS(4, _omitFieldNames ? '' : 'jobs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_persons_data_ clone() => bangumi_persons_data_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_persons_data_ copyWith(void Function(bangumi_persons_data_) updates) => super.copyWith((message) => updates(message as bangumi_persons_data_)) as bangumi_persons_data_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_persons_data_ create() => bangumi_persons_data_._();
  bangumi_persons_data_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_persons_data_> createRepeated() => $pb.PbList<bangumi_persons_data_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_persons_data_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_persons_data_>(create);
  static bangumi_persons_data_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get image => $_getSZ(2);
  @$pb.TagNumber(3)
  set image($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasImage() => $_has(2);
  @$pb.TagNumber(3)
  void clearImage() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get jobs => $_getSZ(3);
  @$pb.TagNumber(4)
  set jobs($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasJobs() => $_has(3);
  @$pb.TagNumber(4)
  void clearJobs() => clearField(4);
}

class bangumi_persons_ extends $pb.GeneratedMessage {
  factory bangumi_persons_({
    $core.Iterable<bangumi_persons_data_>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  bangumi_persons_._() : super();
  factory bangumi_persons_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_persons_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_persons', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..pc<bangumi_persons_data_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: bangumi_persons_data_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_persons_ clone() => bangumi_persons_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_persons_ copyWith(void Function(bangumi_persons_) updates) => super.copyWith((message) => updates(message as bangumi_persons_)) as bangumi_persons_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_persons_ create() => bangumi_persons_._();
  bangumi_persons_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_persons_> createRepeated() => $pb.PbList<bangumi_persons_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_persons_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_persons_>(create);
  static bangumi_persons_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<bangumi_persons_data_> get data => $_getList(0);
}

/// 相关推荐
class bangumi_related_data_ extends $pb.GeneratedMessage {
  factory bangumi_related_data_({
    $core.int? id,
    $core.String? title,
    $core.String? name,
    $core.int? episode,
    $core.int? episodesTotal,
    $core.String? status,
    $core.double? date,
    $core.String? image,
    $core.String? tagline,
    $core.String? type,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (title != null) {
      $result.title = title;
    }
    if (name != null) {
      $result.name = name;
    }
    if (episode != null) {
      $result.episode = episode;
    }
    if (episodesTotal != null) {
      $result.episodesTotal = episodesTotal;
    }
    if (status != null) {
      $result.status = status;
    }
    if (date != null) {
      $result.date = date;
    }
    if (image != null) {
      $result.image = image;
    }
    if (tagline != null) {
      $result.tagline = tagline;
    }
    if (type != null) {
      $result.type = type;
    }
    return $result;
  }
  bangumi_related_data_._() : super();
  factory bangumi_related_data_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_related_data_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_related_data', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU3)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'episode', $pb.PbFieldType.OU3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'episodesTotal', $pb.PbFieldType.OU3)
    ..aOS(6, _omitFieldNames ? '' : 'status')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'date', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'image')
    ..aOS(9, _omitFieldNames ? '' : 'tagline')
    ..aOS(10, _omitFieldNames ? '' : 'type')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_related_data_ clone() => bangumi_related_data_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_related_data_ copyWith(void Function(bangumi_related_data_) updates) => super.copyWith((message) => updates(message as bangumi_related_data_)) as bangumi_related_data_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_related_data_ create() => bangumi_related_data_._();
  bangumi_related_data_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_related_data_> createRepeated() => $pb.PbList<bangumi_related_data_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_related_data_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_related_data_>(create);
  static bangumi_related_data_? _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get episode => $_getIZ(3);
  @$pb.TagNumber(4)
  set episode($core.int v) { $_setUnsignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasEpisode() => $_has(3);
  @$pb.TagNumber(4)
  void clearEpisode() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get episodesTotal => $_getIZ(4);
  @$pb.TagNumber(5)
  set episodesTotal($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEpisodesTotal() => $_has(4);
  @$pb.TagNumber(5)
  void clearEpisodesTotal() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get status => $_getSZ(5);
  @$pb.TagNumber(6)
  set status($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get date => $_getN(6);
  @$pb.TagNumber(7)
  set date($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDate() => $_has(6);
  @$pb.TagNumber(7)
  void clearDate() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get image => $_getSZ(7);
  @$pb.TagNumber(8)
  set image($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasImage() => $_has(7);
  @$pb.TagNumber(8)
  void clearImage() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get tagline => $_getSZ(8);
  @$pb.TagNumber(9)
  set tagline($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTagline() => $_has(8);
  @$pb.TagNumber(9)
  void clearTagline() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get type => $_getSZ(9);
  @$pb.TagNumber(10)
  set type($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasType() => $_has(9);
  @$pb.TagNumber(10)
  void clearType() => clearField(10);
}

class bangumi_related_ extends $pb.GeneratedMessage {
  factory bangumi_related_({
    $core.Iterable<bangumi_related_data_>? data,
  }) {
    final $result = create();
    if (data != null) {
      $result.data.addAll(data);
    }
    return $result;
  }
  bangumi_related_._() : super();
  factory bangumi_related_.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory bangumi_related_.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : '_bangumi_related', package: const $pb.PackageName(_omitMessageNames ? '' : 'bangumi'), createEmptyInstance: create)
    ..pc<bangumi_related_data_>(1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: bangumi_related_data_.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  bangumi_related_ clone() => bangumi_related_()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  bangumi_related_ copyWith(void Function(bangumi_related_) updates) => super.copyWith((message) => updates(message as bangumi_related_)) as bangumi_related_;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static bangumi_related_ create() => bangumi_related_._();
  bangumi_related_ createEmptyInstance() => create();
  static $pb.PbList<bangumi_related_> createRepeated() => $pb.PbList<bangumi_related_>();
  @$core.pragma('dart2js:noInline')
  static bangumi_related_ getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<bangumi_related_>(create);
  static bangumi_related_? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<bangumi_related_data_> get data => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
