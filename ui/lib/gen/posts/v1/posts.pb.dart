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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ListDownloadedRequest extends $pb.GeneratedMessage {
  factory ListDownloadedRequest({
    $core.int? userid,
    $fixnum.Int64? limit,
    $fixnum.Int64? offset,
  }) {
    final result = create();
    if (userid != null) result.userid = userid;
    if (limit != null) result.limit = limit;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListDownloadedRequest._();

  factory ListDownloadedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDownloadedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDownloadedRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'posts.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'userid', $pb.PbFieldType.O3)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownloadedRequest clone() =>
      ListDownloadedRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownloadedRequest copyWith(
          void Function(ListDownloadedRequest) updates) =>
      super.copyWith((message) => updates(message as ListDownloadedRequest))
          as ListDownloadedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDownloadedRequest create() => ListDownloadedRequest._();
  @$core.override
  ListDownloadedRequest createEmptyInstance() => create();
  static $pb.PbList<ListDownloadedRequest> createRepeated() =>
      $pb.PbList<ListDownloadedRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDownloadedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDownloadedRequest>(create);
  static ListDownloadedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userid => $_getIZ(0);
  @$pb.TagNumber(1)
  set userid($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserid() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get limit => $_getI64(1);
  @$pb.TagNumber(2)
  set limit($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);
}

class ListDownloadedResponse extends $pb.GeneratedMessage {
  factory ListDownloadedResponse({
    $core.Iterable<Post>? posts,
  }) {
    final result = create();
    if (posts != null) result.posts.addAll(posts);
    return result;
  }

  ListDownloadedResponse._();

  factory ListDownloadedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDownloadedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDownloadedResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'posts.v1'),
      createEmptyInstance: create)
    ..pc<Post>(1, _omitFieldNames ? '' : 'posts', $pb.PbFieldType.PM,
        subBuilder: Post.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownloadedResponse clone() =>
      ListDownloadedResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownloadedResponse copyWith(
          void Function(ListDownloadedResponse) updates) =>
      super.copyWith((message) => updates(message as ListDownloadedResponse))
          as ListDownloadedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDownloadedResponse create() => ListDownloadedResponse._();
  @$core.override
  ListDownloadedResponse createEmptyInstance() => create();
  static $pb.PbList<ListDownloadedResponse> createRepeated() =>
      $pb.PbList<ListDownloadedResponse>();
  @$core.pragma('dart2js:noInline')
  static ListDownloadedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDownloadedResponse>(create);
  static ListDownloadedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Post> get posts => $_getList(0);
}

class Gallery extends $pb.GeneratedMessage {
  factory Gallery({
    $core.Iterable<$core.String>? images,
  }) {
    final result = create();
    if (images != null) result.images.addAll(images);
    return result;
  }

  Gallery._();

  factory Gallery.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Gallery.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Gallery',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'posts.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'images')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gallery clone() => Gallery()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Gallery copyWith(void Function(Gallery) updates) =>
      super.copyWith((message) => updates(message as Gallery)) as Gallery;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Gallery create() => Gallery._();
  @$core.override
  Gallery createEmptyInstance() => create();
  static $pb.PbList<Gallery> createRepeated() => $pb.PbList<Gallery>();
  @$core.pragma('dart2js:noInline')
  static Gallery getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Gallery>(create);
  static Gallery? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get images => $_getList(0);
}

class Image extends $pb.GeneratedMessage {
  factory Image({
    $core.String? image,
  }) {
    final result = create();
    if (image != null) result.image = image;
    return result;
  }

  Image._();

  factory Image.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Image.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Image',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'posts.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'image')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Image clone() => Image()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Image copyWith(void Function(Image) updates) =>
      super.copyWith((message) => updates(message as Image)) as Image;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Image create() => Image._();
  @$core.override
  Image createEmptyInstance() => create();
  static $pb.PbList<Image> createRepeated() => $pb.PbList<Image>();
  @$core.pragma('dart2js:noInline')
  static Image getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Image>(create);
  static Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get image => $_getSZ(0);
  @$pb.TagNumber(1)
  set image($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => $_clearField(1);
}

class Video extends $pb.GeneratedMessage {
  factory Video({
    $core.Iterable<$core.String>? video,
  }) {
    final result = create();
    if (video != null) result.video.addAll(video);
    return result;
  }

  Video._();

  factory Video.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Video.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Video',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'posts.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'video')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Video clone() => Video()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Video copyWith(void Function(Video) updates) =>
      super.copyWith((message) => updates(message as Video)) as Video;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Video create() => Video._();
  @$core.override
  Video createEmptyInstance() => create();
  static $pb.PbList<Video> createRepeated() => $pb.PbList<Video>();
  @$core.pragma('dart2js:noInline')
  static Video getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Video>(create);
  static Video? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get video => $_getList(0);
}

class Post extends $pb.GeneratedMessage {
  factory Post({
    $core.String? title,
    $core.String? directLink,
    $core.Iterable<$core.String>? gallery,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (directLink != null) result.directLink = directLink;
    if (gallery != null) result.gallery.addAll(gallery);
    return result;
  }

  Post._();

  factory Post.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Post.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Post',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'posts.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOS(2, _omitFieldNames ? '' : 'directLink', protoName: 'directLink')
    ..pPS(3, _omitFieldNames ? '' : 'gallery')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Post clone() => Post()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Post copyWith(void Function(Post) updates) =>
      super.copyWith((message) => updates(message as Post)) as Post;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Post create() => Post._();
  @$core.override
  Post createEmptyInstance() => create();
  static $pb.PbList<Post> createRepeated() => $pb.PbList<Post>();
  @$core.pragma('dart2js:noInline')
  static Post getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Post>(create);
  static Post? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get directLink => $_getSZ(1);
  @$pb.TagNumber(2)
  set directLink($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDirectLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirectLink() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get gallery => $_getList(2);
}

class PostsServiceApi {
  final $pb.RpcClient _client;

  PostsServiceApi(this._client);

  $async.Future<ListDownloadedResponse> listDownloaded(
          $pb.ClientContext? ctx, ListDownloadedRequest request) =>
      _client.invoke<ListDownloadedResponse>(ctx, 'PostsService',
          'ListDownloaded', request, ListDownloadedResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
