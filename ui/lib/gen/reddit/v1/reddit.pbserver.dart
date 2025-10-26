// This is a generated file - do not edit.
//
// Generated from reddit/v1/reddit.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'reddit.pb.dart' as $0;
import 'reddit.pbjson.dart';

export 'reddit.pb.dart';

abstract class RedditServiceBase extends $pb.GeneratedService {
  $async.Future<$0.AddAccountResponse> addAccount(
      $pb.ServerContext ctx, $0.AddAccountRequest request);
  $async.Future<$0.DeleteAccountResponse> deleteAccount(
      $pb.ServerContext ctx, $0.DeleteAccountRequest request);
  $async.Future<$0.ListAccountResponse> listAccount(
      $pb.ServerContext ctx, $0.ListAccountRequest request);
  $async.Future<$0.RunTaskResponse> runTask(
      $pb.ServerContext ctx, $0.RunTaskRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'AddAccount':
        return $0.AddAccountRequest();
      case 'DeleteAccount':
        return $0.DeleteAccountRequest();
      case 'ListAccount':
        return $0.ListAccountRequest();
      case 'RunTask':
        return $0.RunTaskRequest();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'AddAccount':
        return addAccount(ctx, request as $0.AddAccountRequest);
      case 'DeleteAccount':
        return deleteAccount(ctx, request as $0.DeleteAccountRequest);
      case 'ListAccount':
        return listAccount(ctx, request as $0.ListAccountRequest);
      case 'RunTask':
        return runTask(ctx, request as $0.RunTaskRequest);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => RedditServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => RedditServiceBase$messageJson;
}
