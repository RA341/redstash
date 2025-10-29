//
//  Generated code. Do not modify.
//  source: posts/v1/posts.proto
//

import "package:connectrpc/connect.dart" as connect;
import "posts.pb.dart" as postsv1posts;
import "posts.connect.spec.dart" as specs;

extension type PostsServiceClient (connect.Transport _transport) {
  Future<postsv1posts.ListDownloadedResponse> listDownloaded(
    postsv1posts.ListDownloadedRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PostsService.listDownloaded,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
