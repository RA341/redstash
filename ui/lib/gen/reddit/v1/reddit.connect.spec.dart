//
//  Generated code. Do not modify.
//  source: reddit/v1/reddit.proto
//

import "package:connectrpc/connect.dart" as connect;
import "reddit.pb.dart" as redditv1reddit;

abstract final class RedditService {
  /// Fully-qualified name of the RedditService service.
  static const name = 'reddit.v1.RedditService';

  static const addAccount = connect.Spec(
    '/$name/AddAccount',
    connect.StreamType.unary,
    redditv1reddit.AddAccountRequest.new,
    redditv1reddit.AddAccountResponse.new,
  );

  static const deleteAccount = connect.Spec(
    '/$name/DeleteAccount',
    connect.StreamType.unary,
    redditv1reddit.DeleteAccountRequest.new,
    redditv1reddit.DeleteAccountResponse.new,
  );

  static const listAccount = connect.Spec(
    '/$name/ListAccount',
    connect.StreamType.unary,
    redditv1reddit.ListAccountRequest.new,
    redditv1reddit.ListAccountResponse.new,
  );

  static const syncPosts = connect.Spec(
    '/$name/SyncPosts',
    connect.StreamType.unary,
    redditv1reddit.RunTaskRequest.new,
    redditv1reddit.RunTaskResponse.new,
  );
}
