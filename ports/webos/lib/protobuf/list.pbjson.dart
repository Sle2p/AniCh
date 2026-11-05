//
//  Generated code. Do not modify.
//  source: list.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use thread_list_data_Descriptor instead')
const thread_list_data_$json = {
  '1': '_thread_list_data',
  '2': [
    {'1': 'ai', '3': 1, '4': 1, '5': 8, '10': 'ai'},
    {'1': 'id', '3': 2, '4': 1, '5': 13, '10': 'id'},
    {'1': 'nsfw', '3': 3, '4': 1, '5': 8, '10': 'nsfw'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'image', '3': 5, '4': 1, '5': 9, '10': 'image'},
    {'1': 'count', '3': 6, '4': 1, '5': 13, '10': 'count'},
    {'1': 'color', '3': 7, '4': 1, '5': 9, '10': 'color'},
    {'1': 'width', '3': 8, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 9, '4': 1, '5': 13, '10': 'height'},
  ],
};

/// Descriptor for `_thread_list_data`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thread_list_data_Descriptor = $convert.base64Decode(
    'ChFfdGhyZWFkX2xpc3RfZGF0YRIOCgJhaRgBIAEoCFICYWkSDgoCaWQYAiABKA1SAmlkEhIKBG'
    '5zZncYAyABKAhSBG5zZncSFAoFdGl0bGUYBCABKAlSBXRpdGxlEhQKBWltYWdlGAUgASgJUgVp'
    'bWFnZRIUCgVjb3VudBgGIAEoDVIFY291bnQSFAoFY29sb3IYByABKAlSBWNvbG9yEhQKBXdpZH'
    'RoGAggASgNUgV3aWR0aBIWCgZoZWlnaHQYCSABKA1SBmhlaWdodA==');

@$core.Deprecated('Use thread_list_body_Descriptor instead')
const thread_list_body_$json = {
  '1': '_thread_list_body',
  '2': [
    {'1': 'data', '3': 1, '4': 3, '5': 11, '6': '.list._thread_list_data', '10': 'data'},
    {'1': 'prev', '3': 2, '4': 1, '5': 13, '10': 'prev'},
    {'1': 'next', '3': 3, '4': 1, '5': 13, '10': 'next'},
  ],
};

/// Descriptor for `_thread_list_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thread_list_body_Descriptor = $convert.base64Decode(
    'ChFfdGhyZWFkX2xpc3RfYm9keRIrCgRkYXRhGAEgAygLMhcubGlzdC5fdGhyZWFkX2xpc3RfZG'
    'F0YVIEZGF0YRISCgRwcmV2GAIgASgNUgRwcmV2EhIKBG5leHQYAyABKA1SBG5leHQ=');

@$core.Deprecated('Use thread_list_Descriptor instead')
const thread_list_$json = {
  '1': '_thread_list',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 1, '5': 11, '6': '.list._thread_list_body', '10': 'body'},
  ],
};

/// Descriptor for `_thread_list`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thread_list_Descriptor = $convert.base64Decode(
    'CgxfdGhyZWFkX2xpc3QSFAoFZXJyb3IYASABKAhSBWVycm9yEhgKB21lc3NhZ2UYAiABKAlSB2'
    '1lc3NhZ2USKwoEYm9keRgDIAEoCzIXLmxpc3QuX3RocmVhZF9saXN0X2JvZHlSBGJvZHk=');

@$core.Deprecated('Use autocomplete_body_Descriptor instead')
const autocomplete_body_$json = {
  '1': '_autocomplete_body',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'translate', '3': 2, '4': 1, '5': 9, '10': 'translate'},
  ],
};

/// Descriptor for `_autocomplete_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autocomplete_body_Descriptor = $convert.base64Decode(
    'ChJfYXV0b2NvbXBsZXRlX2JvZHkSEgoEbmFtZRgBIAEoCVIEbmFtZRIcCgl0cmFuc2xhdGUYAi'
    'ABKAlSCXRyYW5zbGF0ZQ==');

@$core.Deprecated('Use autocomplete_Descriptor instead')
const autocomplete_$json = {
  '1': '_autocomplete',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 3, '5': 11, '6': '.list._autocomplete_body', '10': 'body'},
  ],
};

/// Descriptor for `_autocomplete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autocomplete_Descriptor = $convert.base64Decode(
    'Cg1fYXV0b2NvbXBsZXRlEhQKBWVycm9yGAEgASgIUgVlcnJvchIYCgdtZXNzYWdlGAIgASgJUg'
    'dtZXNzYWdlEiwKBGJvZHkYAyADKAsyGC5saXN0Ll9hdXRvY29tcGxldGVfYm9keVIEYm9keQ==');

@$core.Deprecated('Use tag_info_related_Descriptor instead')
const tag_info_related_$json = {
  '1': '_tag_info_related',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'translate', '3': 2, '4': 1, '5': 9, '10': 'translate'},
    {'1': 'image', '3': 3, '4': 1, '5': 9, '10': 'image'},
    {'1': 'color', '3': 4, '4': 1, '5': 9, '10': 'color'},
    {'1': 'q', '3': 5, '4': 1, '5': 13, '10': 'q'},
  ],
};

/// Descriptor for `_tag_info_related`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tag_info_related_Descriptor = $convert.base64Decode(
    'ChFfdGFnX2luZm9fcmVsYXRlZBISCgRuYW1lGAEgASgJUgRuYW1lEhwKCXRyYW5zbGF0ZRgCIA'
    'EoCVIJdHJhbnNsYXRlEhQKBWltYWdlGAMgASgJUgVpbWFnZRIUCgVjb2xvchgEIAEoCVIFY29s'
    'b3ISDAoBcRgFIAEoDVIBcQ==');

@$core.Deprecated('Use tag_info_body_Descriptor instead')
const tag_info_body_$json = {
  '1': '_tag_info_body',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'translate', '3': 2, '4': 1, '5': 9, '10': 'translate'},
    {'1': 'count', '3': 3, '4': 1, '5': 13, '10': 'count'},
    {'1': 'desc', '3': 4, '4': 1, '5': 9, '10': 'desc'},
    {'1': 'image', '3': 5, '4': 1, '5': 9, '10': 'image'},
    {'1': 'color', '3': 6, '4': 1, '5': 9, '10': 'color'},
    {'1': 'related', '3': 7, '4': 3, '5': 11, '6': '.list._tag_info_related', '10': 'related'},
  ],
};

/// Descriptor for `_tag_info_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tag_info_body_Descriptor = $convert.base64Decode(
    'Cg5fdGFnX2luZm9fYm9keRISCgRuYW1lGAEgASgJUgRuYW1lEhwKCXRyYW5zbGF0ZRgCIAEoCV'
    'IJdHJhbnNsYXRlEhQKBWNvdW50GAMgASgNUgVjb3VudBISCgRkZXNjGAQgASgJUgRkZXNjEhQK'
    'BWltYWdlGAUgASgJUgVpbWFnZRIUCgVjb2xvchgGIAEoCVIFY29sb3ISMQoHcmVsYXRlZBgHIA'
    'MoCzIXLmxpc3QuX3RhZ19pbmZvX3JlbGF0ZWRSB3JlbGF0ZWQ=');

@$core.Deprecated('Use tag_info_Descriptor instead')
const tag_info_$json = {
  '1': '_tag_info',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 1, '5': 11, '6': '.list._tag_info_body', '10': 'body'},
  ],
};

/// Descriptor for `_tag_info`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tag_info_Descriptor = $convert.base64Decode(
    'CglfdGFnX2luZm8SFAoFZXJyb3IYASABKAhSBWVycm9yEhgKB21lc3NhZ2UYAiABKAlSB21lc3'
    'NhZ2USKAoEYm9keRgDIAEoCzIULmxpc3QuX3RhZ19pbmZvX2JvZHlSBGJvZHk=');
