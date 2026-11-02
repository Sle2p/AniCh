//
//  Generated code. Do not modify.
//  source: bangumi.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use vod_item_Descriptor instead')
const vod_item_$json = {
  '1': '_vod_item',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
    {'1': 'sort', '3': 2, '4': 1, '5': 13, '10': 'sort'},
    {'1': 'type', '3': 3, '4': 1, '5': 9, '10': 'type'},
    {'1': 'caption', '3': 4, '4': 1, '5': 9, '10': 'caption'},
  ],
};

/// Descriptor for `_vod_item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vod_item_Descriptor = $convert.base64Decode(
    'Cglfdm9kX2l0ZW0SEAoDdXJsGAEgASgJUgN1cmwSEgoEc29ydBgCIAEoDVIEc29ydBISCgR0eX'
    'BlGAMgASgJUgR0eXBlEhgKB2NhcHRpb24YBCABKAlSB2NhcHRpb24=');

@$core.Deprecated('Use vod_Descriptor instead')
const vod_$json = {
  '1': '_vod',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.bangumi._vod_item', '10': 'data'},
  ],
};

/// Descriptor for `_vod`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vod_Descriptor = $convert.base64Decode(
    'CgRfdm9kEiYKBGRhdGEYASADKAsyEi5iYW5ndW1pLl92b2RfaXRlbVIEZGF0YQ==');

@$core.Deprecated('Use bangumi_list_item_Descriptor instead')
const bangumi_list_item_$json = {
  '1': '_bangumi_list_item',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'episode', '3': 3, '4': 1, '5': 13, '10': 'episode'},
    {'1': 'episodes_total', '3': 4, '4': 1, '5': 13, '10': 'episodesTotal'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {'1': 'date', '3': 6, '4': 1, '5': 1, '10': 'date'},
    {'1': 'image', '3': 7, '4': 1, '5': 9, '10': 'image'},
    {'1': 'tagline', '3': 8, '4': 1, '5': 9, '10': 'tagline'},
  ],
};

/// Descriptor for `_bangumi_list_item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_list_item_Descriptor = $convert.base64Decode(
    'ChJfYmFuZ3VtaV9saXN0X2l0ZW0SDgoCaWQYASABKA1SAmlkEhQKBXRpdGxlGAIgASgJUgV0aX'
    'RsZRIYCgdlcGlzb2RlGAMgASgNUgdlcGlzb2RlEiUKDmVwaXNvZGVzX3RvdGFsGAQgASgNUg1l'
    'cGlzb2Rlc1RvdGFsEhYKBnN0YXR1cxgFIAEoCVIGc3RhdHVzEhIKBGRhdGUYBiABKAFSBGRhdG'
    'USFAoFaW1hZ2UYByABKAlSBWltYWdlEhgKB3RhZ2xpbmUYCCABKAlSB3RhZ2xpbmU=');

@$core.Deprecated('Use bangumi_list_Descriptor instead')
const bangumi_list_$json = {
  '1': '_bangumi_list',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.bangumi._bangumi_list_item', '10': 'data'},
    {'1': 'prev', '3': 2, '4': 1, '5': 13, '10': 'prev'},
    {'1': 'next', '3': 3, '4': 1, '5': 13, '10': 'next'},
  ],
};

/// Descriptor for `_bangumi_list`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_list_Descriptor = $convert.base64Decode(
    'Cg1fYmFuZ3VtaV9saXN0Ei8KBGRhdGEYASADKAsyGy5iYW5ndW1pLl9iYW5ndW1pX2xpc3RfaX'
    'RlbVIEZGF0YRISCgRwcmV2GAIgASgNUgRwcmV2EhIKBG5leHQYAyABKA1SBG5leHQ=');

@$core.Deprecated('Use bangumi_latest_item_Descriptor instead')
const bangumi_latest_item_$json = {
  '1': '_bangumi_latest_item',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 8, '10': 'status'},
    {'1': 'id', '3': 2, '4': 1, '5': 13, '10': 'id'},
    {'1': 'ep', '3': 3, '4': 1, '5': 13, '10': 'ep'},
    {'1': 'airdate', '3': 4, '4': 1, '5': 1, '10': 'airdate'},
    {'1': 'duration', '3': 5, '4': 1, '5': 13, '10': 'duration'},
    {'1': 'image', '3': 6, '4': 1, '5': 9, '10': 'image'},
    {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    {'1': 'name', '3': 8, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `_bangumi_latest_item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_latest_item_Descriptor = $convert.base64Decode(
    'ChRfYmFuZ3VtaV9sYXRlc3RfaXRlbRIWCgZzdGF0dXMYASABKAhSBnN0YXR1cxIOCgJpZBgCIA'
    'EoDVICaWQSDgoCZXAYAyABKA1SAmVwEhgKB2FpcmRhdGUYBCABKAFSB2FpcmRhdGUSGgoIZHVy'
    'YXRpb24YBSABKA1SCGR1cmF0aW9uEhQKBWltYWdlGAYgASgJUgVpbWFnZRIUCgV0aXRsZRgHIA'
    'EoCVIFdGl0bGUSEgoEbmFtZRgIIAEoCVIEbmFtZQ==');

@$core.Deprecated('Use bangumi_latest_Descriptor instead')
const bangumi_latest_$json = {
  '1': '_bangumi_latest',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.bangumi._bangumi_latest_item', '10': 'data'},
  ],
};

/// Descriptor for `_bangumi_latest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_latest_Descriptor = $convert.base64Decode(
    'Cg9fYmFuZ3VtaV9sYXRlc3QSMQoEZGF0YRgBIAMoCzIdLmJhbmd1bWkuX2Jhbmd1bWlfbGF0ZX'
    'N0X2l0ZW1SBGRhdGE=');

@$core.Deprecated('Use bangumi_episodes_sites_Descriptor instead')
const bangumi_episodes_sites_$json = {
  '1': '_bangumi_episodes_sites',
  '2': [
    {'1': 'site', '3': 1, '4': 1, '5': 9, '10': 'site'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `_bangumi_episodes_sites`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_episodes_sites_Descriptor = $convert.base64Decode(
    'ChdfYmFuZ3VtaV9lcGlzb2Rlc19zaXRlcxISCgRzaXRlGAEgASgJUgRzaXRlEg4KAmlkGAIgAS'
    'gJUgJpZA==');

@$core.Deprecated('Use bangumi_episodes_rating_Descriptor instead')
const bangumi_episodes_rating_$json = {
  '1': '_bangumi_episodes_rating',
  '2': [
    {'1': 'site', '3': 1, '4': 1, '5': 9, '10': 'site'},
    {'1': 'score', '3': 2, '4': 1, '5': 13, '10': 'score'},
    {'1': 'count', '3': 3, '4': 1, '5': 13, '10': 'count'},
  ],
};

/// Descriptor for `_bangumi_episodes_rating`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_episodes_rating_Descriptor = $convert.base64Decode(
    'ChhfYmFuZ3VtaV9lcGlzb2Rlc19yYXRpbmcSEgoEc2l0ZRgBIAEoCVIEc2l0ZRIUCgVzY29yZR'
    'gCIAEoDVIFc2NvcmUSFAoFY291bnQYAyABKA1SBWNvdW50');

@$core.Deprecated('Use bangumi_episodes_data_Descriptor instead')
const bangumi_episodes_data_$json = {
  '1': '_bangumi_episodes_data',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 8, '10': 'status'},
    {'1': 'sort', '3': 2, '4': 1, '5': 13, '10': 'sort'},
    {'1': 'airdate', '3': 3, '4': 1, '5': 1, '10': 'airdate'},
    {'1': 'duration', '3': 4, '4': 1, '5': 13, '10': 'duration'},
    {'1': 'sites', '3': 5, '4': 3, '5': 11, '6': '.bangumi._bangumi_episodes_sites', '10': 'sites'},
    {'1': 'rating', '3': 6, '4': 3, '5': 11, '6': '.bangumi._bangumi_episodes_rating', '10': 'rating'},
    {'1': 'image', '3': 7, '4': 1, '5': 9, '10': 'image'},
    {'1': 'title', '3': 8, '4': 1, '5': 9, '10': 'title'},
    {'1': 'overview', '3': 9, '4': 1, '5': 9, '10': 'overview'},
  ],
};

/// Descriptor for `_bangumi_episodes_data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_episodes_data_Descriptor = $convert.base64Decode(
    'ChZfYmFuZ3VtaV9lcGlzb2Rlc19kYXRhEhYKBnN0YXR1cxgBIAEoCFIGc3RhdHVzEhIKBHNvcn'
    'QYAiABKA1SBHNvcnQSGAoHYWlyZGF0ZRgDIAEoAVIHYWlyZGF0ZRIaCghkdXJhdGlvbhgEIAEo'
    'DVIIZHVyYXRpb24SNgoFc2l0ZXMYBSADKAsyIC5iYW5ndW1pLl9iYW5ndW1pX2VwaXNvZGVzX3'
    'NpdGVzUgVzaXRlcxI5CgZyYXRpbmcYBiADKAsyIS5iYW5ndW1pLl9iYW5ndW1pX2VwaXNvZGVz'
    'X3JhdGluZ1IGcmF0aW5nEhQKBWltYWdlGAcgASgJUgVpbWFnZRIUCgV0aXRsZRgIIAEoCVIFdG'
    'l0bGUSGgoIb3ZlcnZpZXcYCSABKAlSCG92ZXJ2aWV3');

@$core.Deprecated('Use bangumi_episodes_Descriptor instead')
const bangumi_episodes_$json = {
  '1': '_bangumi_episodes',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.bangumi._bangumi_episodes_data', '10': 'data'},
  ],
};

/// Descriptor for `_bangumi_episodes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_episodes_Descriptor = $convert.base64Decode(
    'ChFfYmFuZ3VtaV9lcGlzb2RlcxIzCgRkYXRhGAEgAygLMh8uYmFuZ3VtaS5fYmFuZ3VtaV9lcG'
    'lzb2Rlc19kYXRhUgRkYXRh');

@$core.Deprecated('Use bangumi_characters_actors_Descriptor instead')
const bangumi_characters_actors_$json = {
  '1': '_bangumi_characters_actors',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'image', '3': 3, '4': 1, '5': 9, '10': 'image'},
  ],
};

/// Descriptor for `_bangumi_characters_actors`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_characters_actors_Descriptor = $convert.base64Decode(
    'ChpfYmFuZ3VtaV9jaGFyYWN0ZXJzX2FjdG9ycxIOCgJpZBgBIAEoDVICaWQSEgoEbmFtZRgCIA'
    'EoCVIEbmFtZRIUCgVpbWFnZRgDIAEoCVIFaW1hZ2U=');

@$core.Deprecated('Use bangumi_characters_data_Descriptor instead')
const bangumi_characters_data_$json = {
  '1': '_bangumi_characters_data',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'image', '3': 4, '4': 1, '5': 9, '10': 'image'},
    {'1': 'actors', '3': 5, '4': 3, '5': 11, '6': '.bangumi._bangumi_characters_actors', '10': 'actors'},
  ],
};

/// Descriptor for `_bangumi_characters_data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_characters_data_Descriptor = $convert.base64Decode(
    'ChhfYmFuZ3VtaV9jaGFyYWN0ZXJzX2RhdGESDgoCaWQYASABKA1SAmlkEhIKBHJvbGUYAiABKA'
    'lSBHJvbGUSEgoEbmFtZRgDIAEoCVIEbmFtZRIUCgVpbWFnZRgEIAEoCVIFaW1hZ2USOwoGYWN0'
    'b3JzGAUgAygLMiMuYmFuZ3VtaS5fYmFuZ3VtaV9jaGFyYWN0ZXJzX2FjdG9yc1IGYWN0b3Jz');

@$core.Deprecated('Use bangumi_characters_Descriptor instead')
const bangumi_characters_$json = {
  '1': '_bangumi_characters',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.bangumi._bangumi_characters_data', '10': 'data'},
  ],
};

/// Descriptor for `_bangumi_characters`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_characters_Descriptor = $convert.base64Decode(
    'ChNfYmFuZ3VtaV9jaGFyYWN0ZXJzEjUKBGRhdGEYASADKAsyIS5iYW5ndW1pLl9iYW5ndW1pX2'
    'NoYXJhY3RlcnNfZGF0YVIEZGF0YQ==');

@$core.Deprecated('Use bangumi_persons_data_Descriptor instead')
const bangumi_persons_data_$json = {
  '1': '_bangumi_persons_data',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'image', '3': 3, '4': 1, '5': 9, '10': 'image'},
    {'1': 'jobs', '3': 4, '4': 1, '5': 9, '10': 'jobs'},
  ],
};

/// Descriptor for `_bangumi_persons_data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_persons_data_Descriptor = $convert.base64Decode(
    'ChVfYmFuZ3VtaV9wZXJzb25zX2RhdGESDgoCaWQYASABKA1SAmlkEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSFAoFaW1hZ2UYAyABKAlSBWltYWdlEhIKBGpvYnMYBCABKAlSBGpvYnM=');

@$core.Deprecated('Use bangumi_persons_Descriptor instead')
const bangumi_persons_$json = {
  '1': '_bangumi_persons',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.bangumi._bangumi_persons_data', '10': 'data'},
  ],
};

/// Descriptor for `_bangumi_persons`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_persons_Descriptor = $convert.base64Decode(
    'ChBfYmFuZ3VtaV9wZXJzb25zEjIKBGRhdGEYASADKAsyHi5iYW5ndW1pLl9iYW5ndW1pX3Blcn'
    'NvbnNfZGF0YVIEZGF0YQ==');

@$core.Deprecated('Use bangumi_related_data_Descriptor instead')
const bangumi_related_data_$json = {
  '1': '_bangumi_related_data',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'episode', '3': 4, '4': 1, '5': 13, '10': 'episode'},
    {'1': 'episodes_total', '3': 5, '4': 1, '5': 13, '10': 'episodesTotal'},
    {'1': 'status', '3': 6, '4': 1, '5': 9, '10': 'status'},
    {'1': 'date', '3': 7, '4': 1, '5': 1, '10': 'date'},
    {'1': 'image', '3': 8, '4': 1, '5': 9, '10': 'image'},
    {'1': 'tagline', '3': 9, '4': 1, '5': 9, '10': 'tagline'},
    {'1': 'type', '3': 10, '4': 1, '5': 9, '10': 'type'},
  ],
};

/// Descriptor for `_bangumi_related_data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_related_data_Descriptor = $convert.base64Decode(
    'ChVfYmFuZ3VtaV9yZWxhdGVkX2RhdGESDgoCaWQYASABKA1SAmlkEhQKBXRpdGxlGAIgASgJUg'
    'V0aXRsZRISCgRuYW1lGAMgASgJUgRuYW1lEhgKB2VwaXNvZGUYBCABKA1SB2VwaXNvZGUSJQoO'
    'ZXBpc29kZXNfdG90YWwYBSABKA1SDWVwaXNvZGVzVG90YWwSFgoGc3RhdHVzGAYgASgJUgZzdG'
    'F0dXMSEgoEZGF0ZRgHIAEoAVIEZGF0ZRIUCgVpbWFnZRgIIAEoCVIFaW1hZ2USGAoHdGFnbGlu'
    'ZRgJIAEoCVIHdGFnbGluZRISCgR0eXBlGAogASgJUgR0eXBl');

@$core.Deprecated('Use bangumi_related_Descriptor instead')
const bangumi_related_$json = {
  '1': '_bangumi_related',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.bangumi._bangumi_related_data', '10': 'data'},
  ],
};

/// Descriptor for `_bangumi_related`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bangumi_related_Descriptor = $convert.base64Decode(
    'ChBfYmFuZ3VtaV9yZWxhdGVkEjIKBGRhdGEYASADKAsyHi5iYW5ndW1pLl9iYW5ndW1pX3JlbG'
    'F0ZWRfZGF0YVIEZGF0YQ==');
