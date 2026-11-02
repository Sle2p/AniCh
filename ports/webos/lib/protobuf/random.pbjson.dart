//
//  Generated code. Do not modify.
//  source: random.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use images_body_Descriptor instead')
const images_body_$json = {
  '1': '_images_body',
  '2': [
    {'1': 'color', '3': 1, '4': 1, '5': 9, '10': 'color'},
    {'1': 'width', '3': 2, '4': 1, '5': 13, '10': 'width'},
    {'1': 'height', '3': 3, '4': 1, '5': 13, '10': 'height'},
    {'1': 'image', '3': 4, '4': 1, '5': 9, '10': 'image'},
  ],
};

/// Descriptor for `_images_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List images_body_Descriptor = $convert.base64Decode(
    'CgxfaW1hZ2VzX2JvZHkSFAoFY29sb3IYASABKAlSBWNvbG9yEhQKBXdpZHRoGAIgASgNUgV3aW'
    'R0aBIWCgZoZWlnaHQYAyABKA1SBmhlaWdodBIUCgVpbWFnZRgEIAEoCVIFaW1hZ2U=');

@$core.Deprecated('Use images_Descriptor instead')
const images_$json = {
  '1': '_images',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 3, '5': 11, '6': '.random._images_body', '10': 'body'},
  ],
};

/// Descriptor for `_images`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List images_Descriptor = $convert.base64Decode(
    'CgdfaW1hZ2VzEhQKBWVycm9yGAEgASgIUgVlcnJvchIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYW'
    'dlEigKBGJvZHkYAyADKAsyFC5yYW5kb20uX2ltYWdlc19ib2R5UgRib2R5');
