//
//  Generated code. Do not modify.
//  source: account.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use login_user_Descriptor instead')
const login_user_$json = {
  '1': '_login_user',
  '2': [
    {'1': 'avatar', '3': 1, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'role', '3': 4, '4': 1, '5': 9, '10': 'role'},
    {'1': 'sex', '3': 5, '4': 1, '5': 9, '10': 'sex'},
    {'1': 'exp', '3': 6, '4': 1, '5': 13, '10': 'exp'},
    {'1': 'coin', '3': 7, '4': 1, '5': 13, '10': 'coin'},
    {'1': 'color', '3': 8, '4': 1, '5': 9, '10': 'color'},
    {'1': 'created', '3': 9, '4': 1, '5': 1, '10': 'created'},
    {'1': 'updated', '3': 10, '4': 1, '5': 1, '10': 'updated'},
    {'1': 'id', '3': 11, '4': 1, '5': 13, '10': 'id'},
    {'1': 'address', '3': 12, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `_login_user`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List login_user_Descriptor = $convert.base64Decode(
    'CgtfbG9naW5fdXNlchIWCgZhdmF0YXIYASABKAlSBmF2YXRhchIUCgVlbWFpbBgCIAEoCVIFZW'
    '1haWwSEgoEbmFtZRgDIAEoCVIEbmFtZRISCgRyb2xlGAQgASgJUgRyb2xlEhAKA3NleBgFIAEo'
    'CVIDc2V4EhAKA2V4cBgGIAEoDVIDZXhwEhIKBGNvaW4YByABKA1SBGNvaW4SFAoFY29sb3IYCC'
    'ABKAlSBWNvbG9yEhgKB2NyZWF0ZWQYCSABKAFSB2NyZWF0ZWQSGAoHdXBkYXRlZBgKIAEoAVIH'
    'dXBkYXRlZBIOCgJpZBgLIAEoDVICaWQSGAoHYWRkcmVzcxgMIAEoCVIHYWRkcmVzcw==');

@$core.Deprecated('Use login_body_Descriptor instead')
const login_body_$json = {
  '1': '_login_body',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.account._login_user', '10': 'user'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `_login_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List login_body_Descriptor = $convert.base64Decode(
    'CgtfbG9naW5fYm9keRIoCgR1c2VyGAEgASgLMhQuYWNjb3VudC5fbG9naW5fdXNlclIEdXNlch'
    'IUCgV0b2tlbhgCIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use login_Descriptor instead')
const login_$json = {
  '1': '_login',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 1, '5': 11, '6': '.account._login_body', '10': 'body'},
  ],
};

/// Descriptor for `_login`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List login_Descriptor = $convert.base64Decode(
    'CgZfbG9naW4SFAoFZXJyb3IYASABKAhSBWVycm9yEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2'
    'USKAoEYm9keRgDIAEoCzIULmFjY291bnQuX2xvZ2luX2JvZHlSBGJvZHk=');

@$core.Deprecated('Use login_request_Descriptor instead')
const login_request_$json = {
  '1': '_login_request',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 9, '10': 'user'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `_login_request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List login_request_Descriptor = $convert.base64Decode(
    'Cg5fbG9naW5fcmVxdWVzdBISCgR1c2VyGAEgASgJUgR1c2VyEhoKCHBhc3N3b3JkGAIgASgJUg'
    'hwYXNzd29yZA==');

@$core.Deprecated('Use register_user_Descriptor instead')
const register_user_$json = {
  '1': '_register_user',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'sex', '3': 4, '4': 1, '5': 9, '10': 'sex'},
    {'1': 'exp', '3': 5, '4': 1, '5': 13, '10': 'exp'},
    {'1': 'coin', '3': 6, '4': 1, '5': 13, '10': 'coin'},
    {'1': 'color', '3': 7, '4': 1, '5': 9, '10': 'color'},
    {'1': 'created', '3': 8, '4': 1, '5': 1, '10': 'created'},
    {'1': 'updated', '3': 9, '4': 1, '5': 1, '10': 'updated'},
    {'1': 'id', '3': 10, '4': 1, '5': 13, '10': 'id'},
    {'1': 'address', '3': 11, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `_register_user`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List register_user_Descriptor = $convert.base64Decode(
    'Cg5fcmVnaXN0ZXJfdXNlchIUCgVlbWFpbBgBIAEoCVIFZW1haWwSEgoEbmFtZRgCIAEoCVIEbm'
    'FtZRISCgRyb2xlGAMgASgJUgRyb2xlEhAKA3NleBgEIAEoCVIDc2V4EhAKA2V4cBgFIAEoDVID'
    'ZXhwEhIKBGNvaW4YBiABKA1SBGNvaW4SFAoFY29sb3IYByABKAlSBWNvbG9yEhgKB2NyZWF0ZW'
    'QYCCABKAFSB2NyZWF0ZWQSGAoHdXBkYXRlZBgJIAEoAVIHdXBkYXRlZBIOCgJpZBgKIAEoDVIC'
    'aWQSGAoHYWRkcmVzcxgLIAEoCVIHYWRkcmVzcw==');

@$core.Deprecated('Use register_body_Descriptor instead')
const register_body_$json = {
  '1': '_register_body',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.account._register_user', '10': 'user'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `_register_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List register_body_Descriptor = $convert.base64Decode(
    'Cg5fcmVnaXN0ZXJfYm9keRIrCgR1c2VyGAEgASgLMhcuYWNjb3VudC5fcmVnaXN0ZXJfdXNlcl'
    'IEdXNlchIUCgV0b2tlbhgCIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use register_Descriptor instead')
const register_$json = {
  '1': '_register',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 1, '5': 11, '6': '.account._register_body', '10': 'body'},
  ],
};

/// Descriptor for `_register`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List register_Descriptor = $convert.base64Decode(
    'CglfcmVnaXN0ZXISFAoFZXJyb3IYASABKAhSBWVycm9yEhgKB21lc3NhZ2UYAiABKAlSB21lc3'
    'NhZ2USKwoEYm9keRgDIAEoCzIXLmFjY291bnQuX3JlZ2lzdGVyX2JvZHlSBGJvZHk=');

@$core.Deprecated('Use register_request_Descriptor instead')
const register_request_$json = {
  '1': '_register_request',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'password', '3': 4, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `_register_request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List register_request_Descriptor = $convert.base64Decode(
    'ChFfcmVnaXN0ZXJfcmVxdWVzdBIUCgVlbWFpbBgBIAEoCVIFZW1haWwSEgoEY29kZRgCIAEoCV'
    'IEY29kZRISCgRuYW1lGAMgASgJUgRuYW1lEhoKCHBhc3N3b3JkGAQgASgJUghwYXNzd29yZA==');

@$core.Deprecated('Use change_password_user_Descriptor instead')
const change_password_user_$json = {
  '1': '_change_password_user',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'role', '3': 3, '4': 1, '5': 9, '10': 'role'},
    {'1': 'sex', '3': 4, '4': 1, '5': 9, '10': 'sex'},
    {'1': 'exp', '3': 5, '4': 1, '5': 13, '10': 'exp'},
    {'1': 'coin', '3': 6, '4': 1, '5': 13, '10': 'coin'},
    {'1': 'color', '3': 7, '4': 1, '5': 9, '10': 'color'},
    {'1': 'created', '3': 8, '4': 1, '5': 1, '10': 'created'},
    {'1': 'updated', '3': 9, '4': 1, '5': 1, '10': 'updated'},
    {'1': 'id', '3': 10, '4': 1, '5': 13, '10': 'id'},
    {'1': 'address', '3': 11, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `_change_password_user`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List change_password_user_Descriptor = $convert.base64Decode(
    'ChVfY2hhbmdlX3Bhc3N3b3JkX3VzZXISFAoFZW1haWwYASABKAlSBWVtYWlsEhIKBG5hbWUYAi'
    'ABKAlSBG5hbWUSEgoEcm9sZRgDIAEoCVIEcm9sZRIQCgNzZXgYBCABKAlSA3NleBIQCgNleHAY'
    'BSABKA1SA2V4cBISCgRjb2luGAYgASgNUgRjb2luEhQKBWNvbG9yGAcgASgJUgVjb2xvchIYCg'
    'djcmVhdGVkGAggASgBUgdjcmVhdGVkEhgKB3VwZGF0ZWQYCSABKAFSB3VwZGF0ZWQSDgoCaWQY'
    'CiABKA1SAmlkEhgKB2FkZHJlc3MYCyABKAlSB2FkZHJlc3M=');

@$core.Deprecated('Use change_password_body_Descriptor instead')
const change_password_body_$json = {
  '1': '_change_password_body',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.account._change_password_user', '10': 'user'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `_change_password_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List change_password_body_Descriptor = $convert.base64Decode(
    'ChVfY2hhbmdlX3Bhc3N3b3JkX2JvZHkSMgoEdXNlchgBIAEoCzIeLmFjY291bnQuX2NoYW5nZV'
    '9wYXNzd29yZF91c2VyUgR1c2VyEhQKBXRva2VuGAIgASgJUgV0b2tlbg==');

@$core.Deprecated('Use change_password_Descriptor instead')
const change_password_$json = {
  '1': '_change_password',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 1, '5': 11, '6': '.account._change_password_body', '10': 'body'},
  ],
};

/// Descriptor for `_change_password`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List change_password_Descriptor = $convert.base64Decode(
    'ChBfY2hhbmdlX3Bhc3N3b3JkEhQKBWVycm9yGAEgASgIUgVlcnJvchIYCgdtZXNzYWdlGAIgAS'
    'gJUgdtZXNzYWdlEjIKBGJvZHkYAyABKAsyHi5hY2NvdW50Ll9jaGFuZ2VfcGFzc3dvcmRfYm9k'
    'eVIEYm9keQ==');

@$core.Deprecated('Use change_password_request_Descriptor instead')
const change_password_request_$json = {
  '1': '_change_password_request',
  '2': [
    {'1': 'email', '3': 1, '4': 1, '5': 9, '10': 'email'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'password', '3': 3, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `_change_password_request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List change_password_request_Descriptor = $convert.base64Decode(
    'ChhfY2hhbmdlX3Bhc3N3b3JkX3JlcXVlc3QSFAoFZW1haWwYASABKAlSBWVtYWlsEhIKBGNvZG'
    'UYAiABKAlSBGNvZGUSGgoIcGFzc3dvcmQYAyABKAlSCHBhc3N3b3Jk');

@$core.Deprecated('Use init_user_Descriptor instead')
const init_user_$json = {
  '1': '_init_user',
  '2': [
    {'1': 'avatar', '3': 1, '4': 1, '5': 9, '10': 'avatar'},
    {'1': 'email', '3': 2, '4': 1, '5': 9, '10': 'email'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'role', '3': 4, '4': 1, '5': 9, '10': 'role'},
    {'1': 'sex', '3': 5, '4': 1, '5': 9, '10': 'sex'},
    {'1': 'exp', '3': 6, '4': 1, '5': 13, '10': 'exp'},
    {'1': 'coin', '3': 7, '4': 1, '5': 13, '10': 'coin'},
    {'1': 'color', '3': 8, '4': 1, '5': 9, '10': 'color'},
    {'1': 'created', '3': 9, '4': 1, '5': 1, '10': 'created'},
    {'1': 'updated', '3': 10, '4': 1, '5': 1, '10': 'updated'},
    {'1': 'id', '3': 11, '4': 1, '5': 13, '10': 'id'},
    {'1': 'address', '3': 12, '4': 1, '5': 9, '10': 'address'},
  ],
};

/// Descriptor for `_init_user`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List init_user_Descriptor = $convert.base64Decode(
    'CgpfaW5pdF91c2VyEhYKBmF2YXRhchgBIAEoCVIGYXZhdGFyEhQKBWVtYWlsGAIgASgJUgVlbW'
    'FpbBISCgRuYW1lGAMgASgJUgRuYW1lEhIKBHJvbGUYBCABKAlSBHJvbGUSEAoDc2V4GAUgASgJ'
    'UgNzZXgSEAoDZXhwGAYgASgNUgNleHASEgoEY29pbhgHIAEoDVIEY29pbhIUCgVjb2xvchgIIA'
    'EoCVIFY29sb3ISGAoHY3JlYXRlZBgJIAEoAVIHY3JlYXRlZBIYCgd1cGRhdGVkGAogASgBUgd1'
    'cGRhdGVkEg4KAmlkGAsgASgNUgJpZBIYCgdhZGRyZXNzGAwgASgJUgdhZGRyZXNz');

@$core.Deprecated('Use init_body_Descriptor instead')
const init_body_$json = {
  '1': '_init_body',
  '2': [
    {'1': 'user', '3': 1, '4': 1, '5': 11, '6': '.account._init_user', '10': 'user'},
  ],
};

/// Descriptor for `_init_body`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List init_body_Descriptor = $convert.base64Decode(
    'CgpfaW5pdF9ib2R5EicKBHVzZXIYASABKAsyEy5hY2NvdW50Ll9pbml0X3VzZXJSBHVzZXI=');

@$core.Deprecated('Use init_Descriptor instead')
const init_$json = {
  '1': '_init',
  '2': [
    {'1': 'error', '3': 1, '4': 1, '5': 8, '10': 'error'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'body', '3': 3, '4': 1, '5': 11, '6': '.account._init_body', '10': 'body'},
  ],
};

/// Descriptor for `_init`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List init_Descriptor = $convert.base64Decode(
    'CgVfaW5pdBIUCgVlcnJvchgBIAEoCFIFZXJyb3ISGAoHbWVzc2FnZRgCIAEoCVIHbWVzc2FnZR'
    'InCgRib2R5GAMgASgLMhMuYWNjb3VudC5faW5pdF9ib2R5UgRib2R5');

@$core.Deprecated('Use token_Descriptor instead')
const token_$json = {
  '1': '_token',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
    {'1': 'time', '3': 2, '4': 1, '5': 9, '10': 'time'},
  ],
};

/// Descriptor for `_token`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List token_Descriptor = $convert.base64Decode(
    'CgZfdG9rZW4SFAoFdG9rZW4YASABKAlSBXRva2VuEhIKBHRpbWUYAiABKAlSBHRpbWU=');
