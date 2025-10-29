import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redstash/providers/credentials.dart';

final activeAccountProvider = NotifierProvider<ActiveAccountNotifier, int?>(
  ActiveAccountNotifier.new,
);

extension ActiveAccountExt on WidgetRef {
  ActiveAccountNotifier get activeAccount =>
      read(activeAccountProvider.notifier);
}

class ActiveAccountNotifier extends Notifier<int?> {
  late final cred = ref.watch(credentialsApiProvider);

  @override
  int? build() => null;

  void switchAccount(int? accountId) => state = accountId;
}
