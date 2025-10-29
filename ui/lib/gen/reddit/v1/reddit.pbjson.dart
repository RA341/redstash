// This is a generated file - do not edit.
//
// Generated from reddit/v1/reddit.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use runTaskRequestDescriptor instead')
const RunTaskRequest$json = {
  '1': 'RunTaskRequest',
  '2': [
    {'1': 'username', '3': 1, '4': 1, '5': 9, '10': 'username'},
  ],
};

/// Descriptor for `RunTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runTaskRequestDescriptor = $convert.base64Decode(
    'Cg5SdW5UYXNrUmVxdWVzdBIaCgh1c2VybmFtZRgBIAEoCVIIdXNlcm5hbWU=');

@$core.Deprecated('Use runTaskResponseDescriptor instead')
const RunTaskResponse$json = {
  '1': 'RunTaskResponse',
};

/// Descriptor for `RunTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runTaskResponseDescriptor =
    $convert.base64Decode('Cg9SdW5UYXNrUmVzcG9uc2U=');

@$core.Deprecated('Use listAccountRequestDescriptor instead')
const ListAccountRequest$json = {
  '1': 'ListAccountRequest',
};

/// Descriptor for `ListAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAccountRequestDescriptor =
    $convert.base64Decode('ChJMaXN0QWNjb3VudFJlcXVlc3Q=');

@$core.Deprecated('Use fullCredentialsDescriptor instead')
const FullCredentials$json = {
  '1': 'FullCredentials',
  '2': [
    {'1': 'AccountID', '3': 1, '4': 1, '5': 13, '10': 'AccountID'},
    {
      '1': 'account',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.reddit.v1.AccountDetails',
      '10': 'account'
    },
    {'1': 'postBefore', '3': 3, '4': 1, '5': 9, '10': 'postBefore'},
    {'1': 'postAfter', '3': 4, '4': 1, '5': 9, '10': 'postAfter'},
  ],
};

/// Descriptor for `FullCredentials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fullCredentialsDescriptor = $convert.base64Decode(
    'Cg9GdWxsQ3JlZGVudGlhbHMSHAoJQWNjb3VudElEGAEgASgNUglBY2NvdW50SUQSMwoHYWNjb3'
    'VudBgCIAEoCzIZLnJlZGRpdC52MS5BY2NvdW50RGV0YWlsc1IHYWNjb3VudBIeCgpwb3N0QmVm'
    'b3JlGAMgASgJUgpwb3N0QmVmb3JlEhwKCXBvc3RBZnRlchgEIAEoCVIJcG9zdEFmdGVy');

@$core.Deprecated('Use listAccountResponseDescriptor instead')
const ListAccountResponse$json = {
  '1': 'ListAccountResponse',
  '2': [
    {
      '1': 'cred',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.reddit.v1.FullCredentials',
      '10': 'cred'
    },
  ],
};

/// Descriptor for `ListAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAccountResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0QWNjb3VudFJlc3BvbnNlEi4KBGNyZWQYASADKAsyGi5yZWRkaXQudjEuRnVsbENyZW'
    'RlbnRpYWxzUgRjcmVk');

@$core.Deprecated('Use deleteAccountRequestDescriptor instead')
const DeleteAccountRequest$json = {
  '1': 'DeleteAccountRequest',
  '2': [
    {'1': 'accountId', '3': 1, '4': 1, '5': 13, '10': 'accountId'},
  ],
};

/// Descriptor for `DeleteAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAccountRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVBY2NvdW50UmVxdWVzdBIcCglhY2NvdW50SWQYASABKA1SCWFjY291bnRJZA==');

@$core.Deprecated('Use deleteAccountResponseDescriptor instead')
const DeleteAccountResponse$json = {
  '1': 'DeleteAccountResponse',
};

/// Descriptor for `DeleteAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteAccountResponseDescriptor =
    $convert.base64Decode('ChVEZWxldGVBY2NvdW50UmVzcG9uc2U=');

@$core.Deprecated('Use addAccountRequestDescriptor instead')
const AddAccountRequest$json = {
  '1': 'AddAccountRequest',
  '2': [
    {
      '1': 'details',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.reddit.v1.AccountDetails',
      '10': 'details'
    },
  ],
};

/// Descriptor for `AddAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAccountRequestDescriptor = $convert.base64Decode(
    'ChFBZGRBY2NvdW50UmVxdWVzdBIzCgdkZXRhaWxzGAEgASgLMhkucmVkZGl0LnYxLkFjY291bn'
    'REZXRhaWxzUgdkZXRhaWxz');

@$core.Deprecated('Use accountDetailsDescriptor instead')
const AccountDetails$json = {
  '1': 'AccountDetails',
  '2': [
    {'1': 'ClientID', '3': 1, '4': 1, '5': 9, '10': 'ClientID'},
    {'1': 'ClientSecret', '3': 2, '4': 1, '5': 9, '10': 'ClientSecret'},
    {'1': 'Username', '3': 3, '4': 1, '5': 9, '10': 'Username'},
    {'1': 'Password', '3': 4, '4': 1, '5': 9, '10': 'Password'},
  ],
};

/// Descriptor for `AccountDetails`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDetailsDescriptor = $convert.base64Decode(
    'Cg5BY2NvdW50RGV0YWlscxIaCghDbGllbnRJRBgBIAEoCVIIQ2xpZW50SUQSIgoMQ2xpZW50U2'
    'VjcmV0GAIgASgJUgxDbGllbnRTZWNyZXQSGgoIVXNlcm5hbWUYAyABKAlSCFVzZXJuYW1lEhoK'
    'CFBhc3N3b3JkGAQgASgJUghQYXNzd29yZA==');

@$core.Deprecated('Use addAccountResponseDescriptor instead')
const AddAccountResponse$json = {
  '1': 'AddAccountResponse',
};

/// Descriptor for `AddAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addAccountResponseDescriptor =
    $convert.base64Decode('ChJBZGRBY2NvdW50UmVzcG9uc2U=');

@$core.Deprecated('Use testRequestDescriptor instead')
const TestRequest$json = {
  '1': 'TestRequest',
};

/// Descriptor for `TestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testRequestDescriptor =
    $convert.base64Decode('CgtUZXN0UmVxdWVzdA==');

@$core.Deprecated('Use testResponseDescriptor instead')
const TestResponse$json = {
  '1': 'TestResponse',
};

/// Descriptor for `TestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testResponseDescriptor =
    $convert.base64Decode('CgxUZXN0UmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> RedditServiceBase$json = {
  '1': 'RedditService',
  '2': [
    {
      '1': 'AddAccount',
      '2': '.reddit.v1.AddAccountRequest',
      '3': '.reddit.v1.AddAccountResponse',
      '4': {}
    },
    {
      '1': 'DeleteAccount',
      '2': '.reddit.v1.DeleteAccountRequest',
      '3': '.reddit.v1.DeleteAccountResponse',
      '4': {}
    },
    {
      '1': 'ListAccount',
      '2': '.reddit.v1.ListAccountRequest',
      '3': '.reddit.v1.ListAccountResponse',
      '4': {}
    },
    {
      '1': 'RunTask',
      '2': '.reddit.v1.RunTaskRequest',
      '3': '.reddit.v1.RunTaskResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use redditServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RedditServiceBase$messageJson = {
  '.reddit.v1.AddAccountRequest': AddAccountRequest$json,
  '.reddit.v1.AccountDetails': AccountDetails$json,
  '.reddit.v1.AddAccountResponse': AddAccountResponse$json,
  '.reddit.v1.DeleteAccountRequest': DeleteAccountRequest$json,
  '.reddit.v1.DeleteAccountResponse': DeleteAccountResponse$json,
  '.reddit.v1.ListAccountRequest': ListAccountRequest$json,
  '.reddit.v1.ListAccountResponse': ListAccountResponse$json,
  '.reddit.v1.FullCredentials': FullCredentials$json,
  '.reddit.v1.RunTaskRequest': RunTaskRequest$json,
  '.reddit.v1.RunTaskResponse': RunTaskResponse$json,
};

/// Descriptor for `RedditService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List redditServiceDescriptor = $convert.base64Decode(
    'Cg1SZWRkaXRTZXJ2aWNlEksKCkFkZEFjY291bnQSHC5yZWRkaXQudjEuQWRkQWNjb3VudFJlcX'
    'Vlc3QaHS5yZWRkaXQudjEuQWRkQWNjb3VudFJlc3BvbnNlIgASVAoNRGVsZXRlQWNjb3VudBIf'
    'LnJlZGRpdC52MS5EZWxldGVBY2NvdW50UmVxdWVzdBogLnJlZGRpdC52MS5EZWxldGVBY2NvdW'
    '50UmVzcG9uc2UiABJOCgtMaXN0QWNjb3VudBIdLnJlZGRpdC52MS5MaXN0QWNjb3VudFJlcXVl'
    'c3QaHi5yZWRkaXQudjEuTGlzdEFjY291bnRSZXNwb25zZSIAEkIKB1J1blRhc2sSGS5yZWRkaX'
    'QudjEuUnVuVGFza1JlcXVlc3QaGi5yZWRkaXQudjEuUnVuVGFza1Jlc3BvbnNlIgA=');
