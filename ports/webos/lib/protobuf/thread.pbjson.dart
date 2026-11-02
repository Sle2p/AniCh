//
//  Generated code. Do not modify.
//  source: thread.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use imagesDescriptor instead')
const Images$json = {
  '1': 'Images',
  '2': [
    {'1': 'color', '3': 1, '4': 1, '5': 9, '10': 'color'},
    {'1': 'height', '3': 2, '4': 1, '5': 13, '10': 'height'},
    {'1': 'width', '3': 3, '4': 1, '5': 13, '10': 'width'},
    {'1': 'original_size', '3': 4, '4': 1, '5': 13, '10': 'originalSize'},
    {'1': 'master_size', '3': 5, '4': 1, '5': 13, '10': 'masterSize'},
    {'1': 'original', '3': 6, '4': 1, '5': 9, '10': 'original'},
    {'1': 'master', '3': 7, '4': 1, '5': 9, '10': 'master'},
  ],
};

/// Descriptor for `Images`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imagesDescriptor = $convert.base64Decode(
    'CgZJbWFnZXMSFAoFY29sb3IYASABKAlSBWNvbG9yEhYKBmhlaWdodBgCIAEoDVIGaGVpZ2h0Eh'
    'QKBXdpZHRoGAMgASgNUgV3aWR0aBIjCg1vcmlnaW5hbF9zaXplGAQgASgNUgxvcmlnaW5hbFNp'
    'emUSHwoLbWFzdGVyX3NpemUYBSABKA1SCm1hc3RlclNpemUSGgoIb3JpZ2luYWwYBiABKAlSCG'
    '9yaWdpbmFsEhYKBm1hc3RlchgHIAEoCVIGbWFzdGVy');

@$core.Deprecated('Use tagsDescriptor instead')
const Tags$json = {
  '1': 'Tags',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'translate', '3': 2, '4': 1, '5': 9, '10': 'translate'},
    {'1': 'color', '3': 3, '4': 1, '5': 9, '10': 'color'},
    {'1': 'image', '3': 4, '4': 1, '5': 9, '10': 'image'},
  ],
};

/// Descriptor for `Tags`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tagsDescriptor = $convert.base64Decode(
    'CgRUYWdzEhIKBG5hbWUYASABKAlSBG5hbWUSHAoJdHJhbnNsYXRlGAIgASgJUgl0cmFuc2xhdG'
    'USFAoFY29sb3IYAyABKAlSBWNvbG9yEhQKBWltYWdlGAQgASgJUgVpbWFnZQ==');

@$core.Deprecated('Use thread_Descriptor instead')
const thread_$json = {
  '1': '_thread',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 13, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'ai', '3': 3, '4': 1, '5': 8, '10': 'ai'},
    {'1': 'views_count', '3': 4, '4': 1, '5': 13, '10': 'viewsCount'},
    {'1': 'collects_count', '3': 5, '4': 1, '5': 13, '10': 'collectsCount'},
    {'1': 'likes_count', '3': 6, '4': 1, '5': 13, '10': 'likesCount'},
    {'1': 'date', '3': 7, '4': 1, '5': 1, '10': 'date'},
    {'1': 'created', '3': 8, '4': 1, '5': 1, '10': 'created'},
    {'1': 'updated', '3': 9, '4': 1, '5': 1, '10': 'updated'},
    {'1': 'type', '3': 10, '4': 1, '5': 9, '10': 'type'},
    {'1': 'nsfw', '3': 11, '4': 1, '5': 8, '10': 'nsfw'},
    {'1': 'source', '3': 12, '4': 1, '5': 9, '10': 'source'},
    {'1': 'images', '3': 13, '4': 3, '5': 11, '6': '.thread.Images', '10': 'images'},
    {'1': 'tags', '3': 14, '4': 3, '5': 11, '6': '.thread.Tags', '10': 'tags'},
  ],
};

/// Descriptor for `_thread`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List thread_Descriptor = $convert.base64Decode(
    'CgdfdGhyZWFkEg4KAmlkGAEgASgNUgJpZBIUCgV0aXRsZRgCIAEoCVIFdGl0bGUSDgoCYWkYAy'
    'ABKAhSAmFpEh8KC3ZpZXdzX2NvdW50GAQgASgNUgp2aWV3c0NvdW50EiUKDmNvbGxlY3RzX2Nv'
    'dW50GAUgASgNUg1jb2xsZWN0c0NvdW50Eh8KC2xpa2VzX2NvdW50GAYgASgNUgpsaWtlc0NvdW'
    '50EhIKBGRhdGUYByABKAFSBGRhdGUSGAoHY3JlYXRlZBgIIAEoAVIHY3JlYXRlZBIYCgd1cGRh'
    'dGVkGAkgASgBUgd1cGRhdGVkEhIKBHR5cGUYCiABKAlSBHR5cGUSEgoEbnNmdxgLIAEoCFIEbn'
    'NmdxIWCgZzb3VyY2UYDCABKAlSBnNvdXJjZRImCgZpbWFnZXMYDSADKAsyDi50aHJlYWQuSW1h'
    'Z2VzUgZpbWFnZXMSIAoEdGFncxgOIAMoCzIMLnRocmVhZC5UYWdzUgR0YWdz');
