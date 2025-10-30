import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redstash/gen/posts/v1/posts.connect.client.dart';
import 'package:redstash/gen/posts/v1/posts.pb.dart';
import 'package:redstash/grpc/api.dart';
import 'package:redstash/pages/home/post_list.dart';
import 'package:redstash/providers/account.dart';

enum PostFilter { downloaded, error, downloading }

typedef PostListArgs = ({int userId, PostFilter filter});

// final postListArgsProvider = Provider<PostListArgs?>((ref) {});

final postArgProvider = NotifierProvider<PostListArgsNotifier, PostListArgs?>(
  PostListArgsNotifier.new,
);

class PostListArgsNotifier extends Notifier<PostListArgs?> {
  late final activeAccount = ref.watch(activeAccountProvider);

  @override
  PostListArgs? build() {
    if (activeAccount == null) {
      return null;
    }
    return (userId: activeAccount!, filter: PostFilter.downloaded);
  }

  void set(PostFilter filter) =>
      state = (userId: activeAccount!, filter: filter);
}

final postApiProvider = Provider<PostsServiceClient>((ref) {
  final transport = ref.watch(connectTransportProvider);
  return PostsServiceClient(transport);
});

final postListProvider = AsyncNotifierProvider.autoDispose
    .family<PostListNotifier, List<Post>, int>(PostListNotifier.new);

class PostListNotifier extends AsyncNotifier<List<Post>> {
  PostListNotifier(this.userid);

  final int userid;

  late final postApi = ref.watch(postApiProvider);

  @override
  FutureOr<List<Post>> build() => fetch();

  var offset = 0;
  var limit = 30;

  Future<void> refetch() async {
    offset = 0; // Reset offset when refetching
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(fetch);
  }

  Future<void> forward() async {
    offset += limit;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(fetch);
  }

  Future<void> backward() async {
    if (offset >= limit) {
      offset -= limit;
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(fetch);
    }
  }

  Future<List<Post>> fetch() async {
    final resp = await mustRunGrpcRequest(
      () => postApi.listDownloaded(
        ListDownloadedRequest(
          userid: userid,
          limit: Int64(limit),
          offset: Int64(offset),
        ),
      ),
    );

    return resp.posts.toList();
  }
}
