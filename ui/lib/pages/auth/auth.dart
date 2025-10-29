import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:redstash/config/config.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conf = ref.watch(localSettingsProvider);

    final basepath = useTextEditingController(text: conf.basepath);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10,
          children: [
            Text("Redstash Setup", style: TextStyle(fontSize: 30)),
            TextField(
              decoration: InputDecoration(
                labelText: 'Basepath',
                hintText: 'Enter server url',
                prefixIcon: Icon(Icons.ac_unit_rounded),
                border: OutlineInputBorder(),
              ),
              controller: basepath,
            ),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(localSettingsProvider.notifier).saveUrl(basepath.text);
              },
              label: Text("Next"),
              icon: Icon(Icons.ac_unit),
            ),
          ],
        ),
      ),
    );
  }
}
