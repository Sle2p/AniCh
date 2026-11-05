//
//  Generated code. Do not modify.
//  source: danmaku.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use data_Descriptor instead')
const data_$json = {
  '1': '_data',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'color', '3': 2, '4': 1, '5': 9, '10': 'color'},
    {'1': 'date', '3': 3, '4': 1, '5': 1, '10': 'date'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
    {'1': 't', '3': 5, '4': 1, '5': 9, '10': 't'},
    {'1': 'time', '3': 6, '4': 1, '5': 1, '10': 'time'},
    {'1': 'type', '3': 7, '4': 1, '5': 13, '10': 'type'},
    {'1': 'from', '3': 8, '4': 1, '5': 9, '10': 'from'},
  ],
};

/// Descriptor for `_data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List data_Descriptor = $convert.base64Decode(
    'CgVfZGF0YRIOCgJpZBgBIAEoCVICaWQSFAoFY29sb3IYAiABKAlSBWNvbG9yEhIKBGRhdGUYAy'
    'ABKAFSBGRhdGUSEgoEdGV4dBgEIAEoCVIEdGV4dBIMCgF0GAUgASgJUgF0EhIKBHRpbWUYBiAB'
    'KAFSBHRpbWUSEgoEdHlwZRgHIAEoDVIEdHlwZRISCgRmcm9tGAggASgJUgRmcm9t');

@$core.Deprecated('Use danmaku_Descriptor instead')
const danmaku_$json = {
  '1': '_danmaku',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.danmaku._data', '10': 'data'},
    {'1': 'skip', '3': 2, '4': 1, '5': 13, '10': 'skip'},
  ],
};

/// Descriptor for `_danmaku`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List danmaku_Descriptor = $convert.base64Decode(
    'CghfZGFubWFrdRIiCgRkYXRhGAEgAygLMg4uZGFubWFrdS5fZGF0YVIEZGF0YRISCgRza2lwGA'
    'IgASgNUgRza2lw');

@$core.Deprecated('Use bilibili_danmaku_item_Descriptor instead')
const bilibili_danmaku_item_$json = {
  '1': '_bilibili_danmaku_item',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'progress', '3': 2, '4': 1, '5': 5, '10': 'progress'},
    {'1': 'mode', '3': 3, '4': 1, '5': 5, '10': 'mode'},
    {'1': 'fontsize', '3': 4, '4': 1, '5': 5, '10': 'fontsize'},
    {'1': 'color', '3': 5, '4': 1, '5': 13, '10': 'color'},
    {'1': 'midHash', '3': 6, '4': 1, '5': 9, '10': 'midHash'},
    {'1': 'content', '3': 7, '4': 1, '5': 9, '10': 'content'},
    {'1': 'ctime', '3': 8, '4': 1, '5': 13, '10': 'ctime'},
    {'1': 'weight', '3': 9, '4': 1, '5': 5, '10': 'weight'},
    {'1': 'action', '3': 10, '4': 1, '5': 9, '10': 'action'},
    {'1': 'pool', '3': 11, '4': 1, '5': 5, '10': 'pool'},
    {'1': 'idStr', '3': 12, '4': 1, '5': 9, '10': 'idStr'},
  ],
};

/// Descriptor for `_bilibili_danmaku_item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibili_danmaku_item_Descriptor = $convert.base64Decode(
    'ChZfYmlsaWJpbGlfZGFubWFrdV9pdGVtEg4KAmlkGAEgASgNUgJpZBIaCghwcm9ncmVzcxgCIA'
    'EoBVIIcHJvZ3Jlc3MSEgoEbW9kZRgDIAEoBVIEbW9kZRIaCghmb250c2l6ZRgEIAEoBVIIZm9u'
    'dHNpemUSFAoFY29sb3IYBSABKA1SBWNvbG9yEhgKB21pZEhhc2gYBiABKAlSB21pZEhhc2gSGA'
    'oHY29udGVudBgHIAEoCVIHY29udGVudBIUCgVjdGltZRgIIAEoDVIFY3RpbWUSFgoGd2VpZ2h0'
    'GAkgASgFUgZ3ZWlnaHQSFgoGYWN0aW9uGAogASgJUgZhY3Rpb24SEgoEcG9vbBgLIAEoBVIEcG'
    '9vbBIUCgVpZFN0chgMIAEoCVIFaWRTdHI=');

@$core.Deprecated('Use bilibili_danmaku_Descriptor instead')
const bilibili_danmaku_$json = {
  '1': '_bilibili_danmaku',
  '2': [
    {'1': 'list', '3': 1, '4': 3, '5': 11, '6': '.danmaku._bilibili_danmaku_item', '10': 'list'},
  ],
};

/// Descriptor for `_bilibili_danmaku`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bilibili_danmaku_Descriptor = $convert.base64Decode(
    'ChFfYmlsaWJpbGlfZGFubWFrdRIzCgRsaXN0GAEgAygLMh8uZGFubWFrdS5fYmlsaWJpbGlfZG'
    'FubWFrdV9pdGVtUgRsaXN0');
