// This is a generated file - do not edit.
//
// Generated from downloader/v1/downloader.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class TriggerDownloaderRequest extends $pb.GeneratedMessage {
  factory TriggerDownloaderRequest() => create();

  TriggerDownloaderRequest._();

  factory TriggerDownloaderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TriggerDownloaderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriggerDownloaderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerDownloaderRequest clone() =>
      TriggerDownloaderRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerDownloaderRequest copyWith(
          void Function(TriggerDownloaderRequest) updates) =>
      super.copyWith((message) => updates(message as TriggerDownloaderRequest))
          as TriggerDownloaderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TriggerDownloaderRequest create() => TriggerDownloaderRequest._();
  @$core.override
  TriggerDownloaderRequest createEmptyInstance() => create();
  static $pb.PbList<TriggerDownloaderRequest> createRepeated() =>
      $pb.PbList<TriggerDownloaderRequest>();
  @$core.pragma('dart2js:noInline')
  static TriggerDownloaderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TriggerDownloaderRequest>(create);
  static TriggerDownloaderRequest? _defaultInstance;
}

class TriggerDownloaderResponse extends $pb.GeneratedMessage {
  factory TriggerDownloaderResponse() => create();

  TriggerDownloaderResponse._();

  factory TriggerDownloaderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TriggerDownloaderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TriggerDownloaderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'downloader.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerDownloaderResponse clone() =>
      TriggerDownloaderResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TriggerDownloaderResponse copyWith(
          void Function(TriggerDownloaderResponse) updates) =>
      super.copyWith((message) => updates(message as TriggerDownloaderResponse))
          as TriggerDownloaderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TriggerDownloaderResponse create() => TriggerDownloaderResponse._();
  @$core.override
  TriggerDownloaderResponse createEmptyInstance() => create();
  static $pb.PbList<TriggerDownloaderResponse> createRepeated() =>
      $pb.PbList<TriggerDownloaderResponse>();
  @$core.pragma('dart2js:noInline')
  static TriggerDownloaderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TriggerDownloaderResponse>(create);
  static TriggerDownloaderResponse? _defaultInstance;
}

class DownloaderServiceApi {
  final $pb.RpcClient _client;

  DownloaderServiceApi(this._client);

  $async.Future<TriggerDownloaderResponse> triggerDownloader(
          $pb.ClientContext? ctx, TriggerDownloaderRequest request) =>
      _client.invoke<TriggerDownloaderResponse>(ctx, 'DownloaderService',
          'TriggerDownloader', request, TriggerDownloaderResponse());
}

const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
