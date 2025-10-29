// This is a generated file - do not edit.
//
// Generated from downloader/v1/downloader.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use triggerDownloaderRequestDescriptor instead')
const TriggerDownloaderRequest$json = {
  '1': 'TriggerDownloaderRequest',
};

/// Descriptor for `TriggerDownloaderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerDownloaderRequestDescriptor =
    $convert.base64Decode('ChhUcmlnZ2VyRG93bmxvYWRlclJlcXVlc3Q=');

@$core.Deprecated('Use triggerDownloaderResponseDescriptor instead')
const TriggerDownloaderResponse$json = {
  '1': 'TriggerDownloaderResponse',
};

/// Descriptor for `TriggerDownloaderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerDownloaderResponseDescriptor =
    $convert.base64Decode('ChlUcmlnZ2VyRG93bmxvYWRlclJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> DownloaderServiceBase$json = {
  '1': 'DownloaderService',
  '2': [
    {
      '1': 'TriggerDownloader',
      '2': '.downloader.v1.TriggerDownloaderRequest',
      '3': '.downloader.v1.TriggerDownloaderResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use downloaderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DownloaderServiceBase$messageJson = {
  '.downloader.v1.TriggerDownloaderRequest': TriggerDownloaderRequest$json,
  '.downloader.v1.TriggerDownloaderResponse': TriggerDownloaderResponse$json,
};

/// Descriptor for `DownloaderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List downloaderServiceDescriptor = $convert.base64Decode(
    'ChFEb3dubG9hZGVyU2VydmljZRJoChFUcmlnZ2VyRG93bmxvYWRlchInLmRvd25sb2FkZXIudj'
    'EuVHJpZ2dlckRvd25sb2FkZXJSZXF1ZXN0GiguZG93bmxvYWRlci52MS5UcmlnZ2VyRG93bmxv'
    'YWRlclJlc3BvbnNlIgA=');
