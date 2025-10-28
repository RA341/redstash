import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redstash/gen/reddit/v1/reddit.connect.client.dart';
import 'package:redstash/gen/reddit/v1/reddit.pb.dart';
import 'package:redstash/grpc/api.dart';

final credentialsApiProvider = Provider<RedditServiceClient>((ref) {
  final transport = ref.watch(connectTransportProvider);
  return RedditServiceClient(transport);
});

extension CredRef on WidgetRef {
  CredentialsNotifier cred() {
    return read(credentialListProvider.notifier);
  }
}

final credentialListProvider =
    AsyncNotifierProvider<CredentialsNotifier, List<FullCredentials>>(
      CredentialsNotifier.new,
    );

class CredentialsNotifier extends AsyncNotifier<List<FullCredentials>> {
  late final cred = ref.watch(credentialsApiProvider);

  @override
  Future<List<FullCredentials>> build() => fetch();

  Future<List<FullCredentials>> fetch() async {
    var resp = await mustRunGrpcRequest(
      () => cred.listAccount(ListAccountRequest()),
    );
    return resp.cred.toList();
  }

  Future<void> refetch() async {
    state = AsyncLoading();
    state = await AsyncValue.guard(fetch);
  }

  Future<String?> add(AddAccountRequest newCred) async {
    final (_, err) = await runGrpcRequest(() => cred.addAccount(newCred));
    if (err.isNotEmpty) return err;
    await refetch();

    return null;
  }

  Future<String?> delete(int credId) async {
    final (_, err) = await runGrpcRequest(
      () => cred.deleteAccount(DeleteAccountRequest(accountId: Int64(credId))),
    );
    if (err.isEmpty) return err;
    await refetch();

    return null;
  }
}
