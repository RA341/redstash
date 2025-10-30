// This is a generated file - do not edit.
//
// Generated from posts/v1/posts.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use listDownloadedRequestDescriptor instead')
const ListDownloadedRequest$json = {
  '1': 'ListDownloadedRequest',
  '2': [
    {'1': 'userid', '3': 1, '4': 1, '5': 5, '10': 'userid'},
    {'1': 'limit', '3': 2, '4': 1, '5': 4, '10': 'limit'},
    {'1': 'offset', '3': 3, '4': 1, '5': 4, '10': 'offset'},
  ],
};

/// Descriptor for `ListDownloadedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDownloadedRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0RG93bmxvYWRlZFJlcXVlc3QSFgoGdXNlcmlkGAEgASgFUgZ1c2VyaWQSFAoFbGltaX'
    'QYAiABKARSBWxpbWl0EhYKBm9mZnNldBgDIAEoBFIGb2Zmc2V0');

@$core.Deprecated('Use listDownloadedResponseDescriptor instead')
const ListDownloadedResponse$json = {
  '1': 'ListDownloadedResponse',
  '2': [
    {
      '1': 'posts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.posts.v1.Post',
      '10': 'posts'
    },
  ],
};

/// Descriptor for `ListDownloadedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDownloadedResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RG93bmxvYWRlZFJlc3BvbnNlEiQKBXBvc3RzGAEgAygLMg4ucG9zdHMudjEuUG9zdF'
        'IFcG9zdHM=');

@$core.Deprecated('Use galleryDescriptor instead')
const Gallery$json = {
  '1': 'Gallery',
  '2': [
    {'1': 'images', '3': 1, '4': 3, '5': 9, '10': 'images'},
  ],
};

/// Descriptor for `Gallery`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List galleryDescriptor =
    $convert.base64Decode('CgdHYWxsZXJ5EhYKBmltYWdlcxgBIAMoCVIGaW1hZ2Vz');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 9, '10': 'image'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor =
    $convert.base64Decode('CgVJbWFnZRIUCgVpbWFnZRgBIAEoCVIFaW1hZ2U=');

@$core.Deprecated('Use videoDescriptor instead')
const Video$json = {
  '1': 'Video',
  '2': [
    {'1': 'video', '3': 1, '4': 3, '5': 9, '10': 'video'},
  ],
};

/// Descriptor for `Video`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List videoDescriptor =
    $convert.base64Decode('CgVWaWRlbxIUCgV2aWRlbxgBIAMoCVIFdmlkZW8=');

@$core.Deprecated('Use postDescriptor instead')
const Post$json = {
  '1': 'Post',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'directLink', '3': 2, '4': 1, '5': 9, '10': 'directLink'},
    {'1': 'gallery', '3': 3, '4': 3, '5': 9, '10': 'gallery'},
    {'1': 'redditId', '3': 4, '4': 1, '5': 9, '10': 'redditId'},
    {'1': 'subreddit', '3': 5, '4': 1, '5': 9, '10': 'subreddit'},
    {'1': 'RedditCreated', '3': 6, '4': 1, '5': 3, '10': 'RedditCreated'},
  ],
};

/// Descriptor for `Post`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postDescriptor = $convert.base64Decode(
    'CgRQb3N0EhQKBXRpdGxlGAEgASgJUgV0aXRsZRIeCgpkaXJlY3RMaW5rGAIgASgJUgpkaXJlY3'
    'RMaW5rEhgKB2dhbGxlcnkYAyADKAlSB2dhbGxlcnkSGgoIcmVkZGl0SWQYBCABKAlSCHJlZGRp'
    'dElkEhwKCXN1YnJlZGRpdBgFIAEoCVIJc3VicmVkZGl0EiQKDVJlZGRpdENyZWF0ZWQYBiABKA'
    'NSDVJlZGRpdENyZWF0ZWQ=');

const $core.Map<$core.String, $core.dynamic> PostsServiceBase$json = {
  '1': 'PostsService',
  '2': [
    {
      '1': 'ListDownloaded',
      '2': '.posts.v1.ListDownloadedRequest',
      '3': '.posts.v1.ListDownloadedResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use postsServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    PostsServiceBase$messageJson = {
  '.posts.v1.ListDownloadedRequest': ListDownloadedRequest$json,
  '.posts.v1.ListDownloadedResponse': ListDownloadedResponse$json,
  '.posts.v1.Post': Post$json,
};

/// Descriptor for `PostsService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List postsServiceDescriptor = $convert.base64Decode(
    'CgxQb3N0c1NlcnZpY2USVQoOTGlzdERvd25sb2FkZWQSHy5wb3N0cy52MS5MaXN0RG93bmxvYW'
    'RlZFJlcXVlc3QaIC5wb3N0cy52MS5MaXN0RG93bmxvYWRlZFJlc3BvbnNlIgA=');
