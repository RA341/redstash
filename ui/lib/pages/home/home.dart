import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:redstash/pages/home/add_account.dart';
import 'package:redstash/pages/home/post_list.dart';
import 'package:redstash/providers/account.dart';
import 'package:redstash/providers/credentials.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountList = ref.watch(credentialListProvider);

    return accountList.when(
      data: (accounts) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Redstash home", style: TextStyle(fontSize: 20)),
            actions: [
              DropdownMenu<int?>(
                initialSelection: ref.watch(activeAccountProvider),
                onSelected: ref.activeAccount.switchAccount,
                dropdownMenuEntries: accounts
                    .map(
                      (e) => DropdownMenuEntry(
                        value: e.accountID,
                        label: e.account.username,
                      ),
                    )
                    .toList(),
              ),
              ElevatedButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AddAccountWidget(),
                  );
                },
                child: Text("Add"),
              ),
            ],
          ),
          body: PostList(),
        );
      },
      error: (error, stackTrace) {
        // todo refactor and make a nice shared error view
        return Center(
          child: Column(
            children: [
              Text("Error getting accounts"),
              Text(error.toString()),
              Text(error.toString()),
            ],
          ),
        );
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class CredentialList extends ConsumerWidget {
  const CredentialList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credList = ref.watch(credentialListProvider);

    return Expanded(
      child: credList.when(
        data: (data) => ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            return ListTile(
              title: Text(item.account.username),
              subtitle: Text(item.account.clientID),
            );
          },
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            children: [Text("Error loading accounts"), Text(error.toString())],
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
