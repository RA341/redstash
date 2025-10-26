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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class RunTaskRequest extends $pb.GeneratedMessage {
  factory RunTaskRequest({
    $core.String? username,
  }) {
    final result = create();
    if (username != null) result.username = username;
    return result;
  }

  RunTaskRequest._();

  factory RunTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunTaskRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'username')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunTaskRequest clone() => RunTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunTaskRequest copyWith(void Function(RunTaskRequest) updates) =>
      super.copyWith((message) => updates(message as RunTaskRequest))
          as RunTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunTaskRequest create() => RunTaskRequest._();
  @$core.override
  RunTaskRequest createEmptyInstance() => create();
  static $pb.PbList<RunTaskRequest> createRepeated() =>
      $pb.PbList<RunTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static RunTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunTaskRequest>(create);
  static RunTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => $_clearField(1);
}

class RunTaskResponse extends $pb.GeneratedMessage {
  factory RunTaskResponse() => create();

  RunTaskResponse._();

  factory RunTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RunTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RunTaskResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunTaskResponse clone() => RunTaskResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RunTaskResponse copyWith(void Function(RunTaskResponse) updates) =>
      super.copyWith((message) => updates(message as RunTaskResponse))
          as RunTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunTaskResponse create() => RunTaskResponse._();
  @$core.override
  RunTaskResponse createEmptyInstance() => create();
  static $pb.PbList<RunTaskResponse> createRepeated() =>
      $pb.PbList<RunTaskResponse>();
  @$core.pragma('dart2js:noInline')
  static RunTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RunTaskResponse>(create);
  static RunTaskResponse? _defaultInstance;
}

class ListAccountRequest extends $pb.GeneratedMessage {
  factory ListAccountRequest() => create();

  ListAccountRequest._();

  factory ListAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAccountRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountRequest clone() => ListAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountRequest copyWith(void Function(ListAccountRequest) updates) =>
      super.copyWith((message) => updates(message as ListAccountRequest))
          as ListAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAccountRequest create() => ListAccountRequest._();
  @$core.override
  ListAccountRequest createEmptyInstance() => create();
  static $pb.PbList<ListAccountRequest> createRepeated() =>
      $pb.PbList<ListAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAccountRequest>(create);
  static ListAccountRequest? _defaultInstance;
}

class FullCredentials extends $pb.GeneratedMessage {
  factory FullCredentials({
    AddAccountRequest? account,
    $core.String? postBefore,
    $core.String? postAfter,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (postBefore != null) result.postBefore = postBefore;
    if (postAfter != null) result.postAfter = postAfter;
    return result;
  }

  FullCredentials._();

  factory FullCredentials.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FullCredentials.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FullCredentials',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..aOM<AddAccountRequest>(1, _omitFieldNames ? '' : 'account',
        subBuilder: AddAccountRequest.create)
    ..aOS(2, _omitFieldNames ? '' : 'postBefore', protoName: 'postBefore')
    ..aOS(3, _omitFieldNames ? '' : 'postAfter', protoName: 'postAfter')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FullCredentials clone() => FullCredentials()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FullCredentials copyWith(void Function(FullCredentials) updates) =>
      super.copyWith((message) => updates(message as FullCredentials))
          as FullCredentials;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FullCredentials create() => FullCredentials._();
  @$core.override
  FullCredentials createEmptyInstance() => create();
  static $pb.PbList<FullCredentials> createRepeated() =>
      $pb.PbList<FullCredentials>();
  @$core.pragma('dart2js:noInline')
  static FullCredentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FullCredentials>(create);
  static FullCredentials? _defaultInstance;

  @$pb.TagNumber(1)
  AddAccountRequest get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(AddAccountRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  AddAccountRequest ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get postBefore => $_getSZ(1);
  @$pb.TagNumber(2)
  set postBefore($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPostBefore() => $_has(1);
  @$pb.TagNumber(2)
  void clearPostBefore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get postAfter => $_getSZ(2);
  @$pb.TagNumber(3)
  set postAfter($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPostAfter() => $_has(2);
  @$pb.TagNumber(3)
  void clearPostAfter() => $_clearField(3);
}

class ListAccountResponse extends $pb.GeneratedMessage {
  factory ListAccountResponse({
    $core.Iterable<FullCredentials>? cred,
  }) {
    final result = create();
    if (cred != null) result.cred.addAll(cred);
    return result;
  }

  ListAccountResponse._();

  factory ListAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAccountResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..pc<FullCredentials>(1, _omitFieldNames ? '' : 'cred', $pb.PbFieldType.PM,
        subBuilder: FullCredentials.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountResponse clone() => ListAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAccountResponse copyWith(void Function(ListAccountResponse) updates) =>
      super.copyWith((message) => updates(message as ListAccountResponse))
          as ListAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAccountResponse create() => ListAccountResponse._();
  @$core.override
  ListAccountResponse createEmptyInstance() => create();
  static $pb.PbList<ListAccountResponse> createRepeated() =>
      $pb.PbList<ListAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAccountResponse>(create);
  static ListAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FullCredentials> get cred => $_getList(0);
}

class DeleteAccountRequest extends $pb.GeneratedMessage {
  factory DeleteAccountRequest({
    $fixnum.Int64? accountId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  DeleteAccountRequest._();

  factory DeleteAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAccountRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'accountId', protoName: 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountRequest clone() =>
      DeleteAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountRequest copyWith(void Function(DeleteAccountRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteAccountRequest))
          as DeleteAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAccountRequest create() => DeleteAccountRequest._();
  @$core.override
  DeleteAccountRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteAccountRequest> createRepeated() =>
      $pb.PbList<DeleteAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAccountRequest>(create);
  static DeleteAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get accountId => $_getI64(0);
  @$pb.TagNumber(1)
  set accountId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);
}

class DeleteAccountResponse extends $pb.GeneratedMessage {
  factory DeleteAccountResponse() => create();

  DeleteAccountResponse._();

  factory DeleteAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteAccountResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountResponse clone() =>
      DeleteAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteAccountResponse copyWith(
          void Function(DeleteAccountResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteAccountResponse))
          as DeleteAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteAccountResponse create() => DeleteAccountResponse._();
  @$core.override
  DeleteAccountResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteAccountResponse> createRepeated() =>
      $pb.PbList<DeleteAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteAccountResponse>(create);
  static DeleteAccountResponse? _defaultInstance;
}

class AddAccountRequest extends $pb.GeneratedMessage {
  factory AddAccountRequest({
    $core.String? clientID,
    $core.String? clientSecret,
    $core.String? username,
    $core.String? password,
  }) {
    final result = create();
    if (clientID != null) result.clientID = clientID;
    if (clientSecret != null) result.clientSecret = clientSecret;
    if (username != null) result.username = username;
    if (password != null) result.password = password;
    return result;
  }

  AddAccountRequest._();

  factory AddAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAccountRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ClientID', protoName: 'ClientID')
    ..aOS(2, _omitFieldNames ? '' : 'ClientSecret', protoName: 'ClientSecret')
    ..aOS(3, _omitFieldNames ? '' : 'Username', protoName: 'Username')
    ..aOS(4, _omitFieldNames ? '' : 'Password', protoName: 'Password')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAccountRequest clone() => AddAccountRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAccountRequest copyWith(void Function(AddAccountRequest) updates) =>
      super.copyWith((message) => updates(message as AddAccountRequest))
          as AddAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAccountRequest create() => AddAccountRequest._();
  @$core.override
  AddAccountRequest createEmptyInstance() => create();
  static $pb.PbList<AddAccountRequest> createRepeated() =>
      $pb.PbList<AddAccountRequest>();
  @$core.pragma('dart2js:noInline')
  static AddAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAccountRequest>(create);
  static AddAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientID => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientID($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClientID() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientID() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get clientSecret => $_getSZ(1);
  @$pb.TagNumber(2)
  set clientSecret($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasClientSecret() => $_has(1);
  @$pb.TagNumber(2)
  void clearClientSecret() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get username => $_getSZ(2);
  @$pb.TagNumber(3)
  set username($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearUsername() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get password => $_getSZ(3);
  @$pb.TagNumber(4)
  set password($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPassword() => $_has(3);
  @$pb.TagNumber(4)
  void clearPassword() => $_clearField(4);
}

class AddAccountResponse extends $pb.GeneratedMessage {
  factory AddAccountResponse() => create();

  AddAccountResponse._();

  factory AddAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddAccountResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAccountResponse clone() => AddAccountResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddAccountResponse copyWith(void Function(AddAccountResponse) updates) =>
      super.copyWith((message) => updates(message as AddAccountResponse))
          as AddAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddAccountResponse create() => AddAccountResponse._();
  @$core.override
  AddAccountResponse createEmptyInstance() => create();
  static $pb.PbList<AddAccountResponse> createRepeated() =>
      $pb.PbList<AddAccountResponse>();
  @$core.pragma('dart2js:noInline')
  static AddAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddAccountResponse>(create);
  static AddAccountResponse? _defaultInstance;
}

class Credentials extends $pb.GeneratedMessage {
  factory Credentials() => create();

  Credentials._();

  factory Credentials.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Credentials.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Credentials',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Credentials clone() => Credentials()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Credentials copyWith(void Function(Credentials) updates) =>
      super.copyWith((message) => updates(message as Credentials))
          as Credentials;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Credentials create() => Credentials._();
  @$core.override
  Credentials createEmptyInstance() => create();
  static $pb.PbList<Credentials> createRepeated() => $pb.PbList<Credentials>();
  @$core.pragma('dart2js:noInline')
  static Credentials getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Credentials>(create);
  static Credentials? _defaultInstance;
}

class TestRequest extends $pb.GeneratedMessage {
  factory TestRequest() => create();

  TestRequest._();

  factory TestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRequest clone() => TestRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestRequest copyWith(void Function(TestRequest) updates) =>
      super.copyWith((message) => updates(message as TestRequest))
          as TestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestRequest create() => TestRequest._();
  @$core.override
  TestRequest createEmptyInstance() => create();
  static $pb.PbList<TestRequest> createRepeated() => $pb.PbList<TestRequest>();
  @$core.pragma('dart2js:noInline')
  static TestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestRequest>(create);
  static TestRequest? _defaultInstance;
}

class TestResponse extends $pb.GeneratedMessage {
  factory TestResponse() => create();

  TestResponse._();

  factory TestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'reddit.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestResponse clone() => TestResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestResponse copyWith(void Function(TestResponse) updates) =>
      super.copyWith((message) => updates(message as TestResponse))
          as TestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestResponse create() => TestResponse._();
  @$core.override
  TestResponse createEmptyInstance() => create();
  static $pb.PbList<TestResponse> createRepeated() =>
      $pb.PbList<TestResponse>();
  @$core.pragma('dart2js:noInline')
  static TestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestResponse>(create);
  static TestResponse? _defaultInstance;
}

class RedditServiceApi {
  final $pb.RpcClient _client;

  RedditServiceApi(this._client);

  $async.Future<AddAccountResponse> addAccount(
          $pb.ClientContext? ctx, AddAccountRequest request) =>
      _client.invoke<AddAccountResponse>(
          ctx, 'RedditService', 'AddAccount', request, AddAccountResponse());
  $async.Future<DeleteAccountResponse> deleteAccount(
          $pb.ClientContext? ctx, DeleteAccountRequest request) =>
      _client.invoke<DeleteAccountResponse>(ctx, 'RedditService',
          'DeleteAccount', request, DeleteAccountResponse());
  $async.Future<ListAccountResponse> listAccount(
          $pb.ClientContext? ctx, ListAccountRequest request) =>
      _client.invoke<ListAccountResponse>(
          ctx, 'RedditService', 'ListAccount', request, ListAccountResponse());
  $async.Future<RunTaskResponse> runTask(
          $pb.ClientContext? ctx, RunTaskRequest request) =>
      _client.invoke<RunTaskResponse>(
          ctx, 'RedditService', 'RunTask', request, RunTaskResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
