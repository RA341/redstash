import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redstash/gen/reddit/v1/reddit.connect.client.dart';
import 'package:redstash/gen/reddit/v1/reddit.pb.dart';
import 'package:redstash/grpc/api.dart';
import 'package:redstash/providers/account.dart';
import 'package:redstash/providers/account.dart';

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
  late final activeAccount = ref.watch(activeAccountProvider);

  @override
  Future<List<FullCredentials>> build() => fetch();

  Future<List<FullCredentials>> fetch() async {
    var resp = await mustRunGrpcRequest(
      () => cred.listAccount(ListAccountRequest()),
    );

    var list = resp.cred.toList();

    if (list.isNotEmpty && activeAccount == null) {
      ref
          .read(activeAccountProvider.notifier)
          .switchAccount(list.first.accountID);
    }

    return list;
  }

  Future<void> refetch() async {
    state = AsyncLoading();
    state = await AsyncValue.guard(fetch);
  }

  Future<String?> add(AccountDetails newCred) async {
    final (_, err) = await runGrpcRequest(
      () => cred.addAccount(AddAccountRequest(details: newCred)),
    );
    if (err.isNotEmpty) return err;
    await refetch();

    return null;
  }

  Future<String?> delete(int credId) async {
    final (_, err) = await runGrpcRequest(
      () => cred.deleteAccount(DeleteAccountRequest(accountId: credId)),
    );
    if (err.isEmpty) return err;
    await refetch();

    return null;
  }
}
