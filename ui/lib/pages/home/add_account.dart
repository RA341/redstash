import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:redstash/gen/reddit/v1/reddit.pb.dart';
import 'package:redstash/grpc/api.dart';
import 'package:redstash/pages/home/home.dart';
import 'package:redstash/providers/credentials.dart';

class AddAccountWidget extends HookConsumerWidget {
  const AddAccountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appID = useTextEditingController();
    final appSecret = useTextEditingController();
    final username = useTextEditingController();
    final password = useTextEditingController();

    final isAdding = useState(false);

    return Dialog(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight * 0.8,
            width: constraints.maxWidth * 0.8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                spacing: 10,
                children: [
                  Text(
                    "Add a new reddit account",
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Column(
                          spacing: 10,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Reddit API Details"),
                            TextField(
                              controller: appID,
                              decoration: InputDecoration(
                                labelText: 'Client ID',
                                hintText: 'Reddit Client secret',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            TextField(
                              controller: appSecret,
                              decoration: InputDecoration(
                                labelText: 'Client secret',
                                hintText: 'Reddit Client secret',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Text("Generate: https://old.reddit.com/prefs/apps"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 10,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Reddit Details"),
                            TextField(
                              controller: username,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            TextField(
                              controller: password,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            Text("TODO help text"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: isAdding.value
                        ? null
                        : () async {
                            isAdding.value = true;

                            final err = await ref.cred().add(
                              AccountDetails(
                                clientID: appID.text.trim(),
                                clientSecret: appSecret.text.trim(),
                                username: username.text.trim(),
                                password: password.text.trim(),
                              ),
                            );

                            if (!context.mounted) return;

                            if (err.notNull()) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Error adding account"),
                                  content: Text(err ?? ""),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text("Close"),
                                    ),
                                  ],
                                ),
                              );
                            }

                            isAdding.value = false;
                          },
                    child: Text(isAdding.value ? "Adding" : "Add"),
                  ),
                  Divider(),
                  CredentialList(),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
