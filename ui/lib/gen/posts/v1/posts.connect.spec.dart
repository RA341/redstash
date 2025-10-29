//
//  Generated code. Do not modify.
//  source: posts/v1/posts.proto
//

import "package:connectrpc/connect.dart" as connect;
import "posts.pb.dart" as postsv1posts;

abstract final class PostsService {
  /// Fully-qualified name of the PostsService service.
  static const name = 'posts.v1.PostsService';

  static const listDownloaded = connect.Spec(
    '/$name/ListDownloaded',
    connect.StreamType.unary,
    postsv1posts.ListDownloadedRequest.new,
    postsv1posts.ListDownloadedResponse.new,
  );
}
