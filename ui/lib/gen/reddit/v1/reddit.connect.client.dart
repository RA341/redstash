//
//  Generated code. Do not modify.
//  source: reddit/v1/reddit.proto
//

import "package:connectrpc/connect.dart" as connect;
import "reddit.pb.dart" as redditv1reddit;
import "reddit.connect.spec.dart" as specs;

extension type RedditServiceClient (connect.Transport _transport) {
  Future<redditv1reddit.AddAccountResponse> addAccount(
    redditv1reddit.AddAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RedditService.addAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<redditv1reddit.DeleteAccountResponse> deleteAccount(
    redditv1reddit.DeleteAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RedditService.deleteAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<redditv1reddit.ListAccountResponse> listAccount(
    redditv1reddit.ListAccountRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RedditService.listAccount,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<redditv1reddit.RunTaskResponse> runTask(
    redditv1reddit.RunTaskRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.RedditService.runTask,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
