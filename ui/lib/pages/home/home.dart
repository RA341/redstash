import 'package:flutter/material.dart';
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
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) async {
            String? err;

            if (value == 0) {
              err = await runGrpcRequestErr(
                () => ref
                    .read(downloadApiProvider)
                    .triggerDownloader(TriggerDownloaderRequest()),
              );
            } else if (value == 1) {
              err = await runGrpcRequestErr(
                () => ref
                    .read(credentialsApiProvider)
                    .syncPosts(RunTaskRequest()),
              );
            }

            if (!context.mounted) return;

            if (err != null) {
              await showErrorDialog(
                context: context,
                title: "Error running task",
                error: err,
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: "Sync downloads",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: "Sync posts",
            ),
          ],
        ),
        body: PostList(),
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
