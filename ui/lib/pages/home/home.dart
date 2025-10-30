import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:redstash/gen/downloader/v1/downloader.pb.dart';
import 'package:redstash/gen/reddit/v1/reddit.pb.dart';
import 'package:redstash/grpc/api.dart';
import 'package:redstash/pages/home/add_account.dart';
import 'package:redstash/pages/home/post_list.dart';
import 'package:redstash/providers/account.dart';
import 'package:redstash/providers/credentials.dart';
import 'package:redstash/providers/downloader.dart';
import 'package:redstash/providers/posts.dart';
import 'package:redstash/utils/async_button.dart';
import 'package:redstash/utils/error_display.dart';
import 'package:redstash/utils/loading_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountList = ref.watch(credentialListProvider);

    return accountList.when(
      data: (accounts) => Scaffold(
        appBar: AppBar(
          title: Text("Redstash", style: TextStyle(fontSize: 20)),
          elevation: 10,
          actionsPadding: EdgeInsets.symmetric(horizontal: 10),
          actions: [
            IconButton(
              onPressed: () {
                final activeAccount = ref.watch(activeAccountProvider);
                if (activeAccount != null) {
                  ref.invalidate(postListProvider(activeAccount));
                }
              },
              icon: Icon(Icons.refresh),
            ),
            SizedBox(
              width: 170,
              child: DropdownButton<int?>(
                underline: Container(),
                padding: EdgeInsets.all(10),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                value: ref.watch(activeAccountProvider),
                items: accounts
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.accountID,
                        child: Text(e.account.username),
                      ),
                    )
                    .toList(),
                onChanged: ref.activeAccount.switchAccount,
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AddAccountWidget(),
                );
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AsyncButton(
                loadingButton: Text("Syncing posts"),
                normalButton: Text("Sync posts"),
                icon: Icon(Icons.post_add, size: 25),
                onPress: () async {
                  final err = await runGrpcRequestErr(
                    () => ref
                        .read(credentialsApiProvider)
                        .syncPosts(RunTaskRequest()),
                  );

                  if (!context.mounted) return;
                  if (err != null) {
                    await showErrorDialog(
                      context: context,
                      title: "Error running task",
                      error: err,
                    );
                  }
                },
              ),
              AsyncButton(
                loadingButton: Text("Syncing downloads"),
                normalButton: Text("Sync downloads"),
                icon: Icon(Icons.post_add, size: 25),
                onPress: () async {
                  final err = await runGrpcRequestErr(
                    () => ref
                        .read(downloadApiProvider)
                        .triggerDownloader(TriggerDownloaderRequest()),
                  );

                  if (!context.mounted) return;
                  if (err != null) {
                    await showErrorDialog(
                      context: context,
                      title: "Error running task",
                      error: err,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            final activeAccount = ref.watch(activeAccountProvider);
            if (activeAccount != null) {
              ref.invalidate(postListProvider(activeAccount));
            }
          },
          child: PostTabView(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: ErrorDisplay(
          title: "Error getting accounts",
          error: error.toString(),
          stacktrace: stackTrace.toString(),
        ),
      ),
      loading: () => Scaffold(body: LoadingSpinner()),
    );
  }
}

class PostTabView extends HookConsumerWidget {
  const PostTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabList = [PostList(), ErrorList(), PendingList()];

    final tab = useTabController(
      initialLength: tabList.length,
      initialIndex: 0,
    );

    return Column(
      children: [
        TabBar(
          padding: EdgeInsets.all(20),
          controller: tab,
          tabs: [Text("Downloaded"), Text("Error"), Text("Downloading")],
        ),
        Expanded(
          child: TabBarView(controller: tab, children: tabList),
        ),
      ],
    );
  }
}

class ErrorList extends ConsumerWidget {
  const ErrorList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text("Error list");
  }
}

class PendingList extends ConsumerWidget {
  const PendingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text("Pending list");
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
