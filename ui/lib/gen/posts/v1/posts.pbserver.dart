// This is a generated file - do not edit.
//
// Generated from posts/v1/posts.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'posts.pb.dart' as $0;
import 'posts.pbjson.dart';

export 'posts.pb.dart';

abstract class PostsServiceBase extends $pb.GeneratedService {
  $async.Future<$0.ListDownloadedResponse> listDownloaded(
      $pb.ServerContext ctx, $0.ListDownloadedRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'ListDownloaded':
        return $0.ListDownloadedRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'ListDownloaded':
        return listDownloaded(ctx, request as $0.ListDownloadedRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PostsServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => PostsServiceBase$messageJson;
}
