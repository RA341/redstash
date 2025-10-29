import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:redstash/config/config.dart';
import 'package:redstash/pages/auth/auth.dart';
import 'package:redstash/pages/home/home.dart';

import 'config/service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    // Video permissions.
    if (await Permission.videos.isDenied ||
        await Permission.videos.isPermanentlyDenied) {
      final state = await Permission.videos.request();
      if (!state.isGranted) {
        await SystemNavigator.pop();
      }
    }
    // Audio permissions.
    if (await Permission.audio.isDenied ||
        await Permission.audio.isPermanentlyDenied) {
      final state = await Permission.audio.request();
      if (!state.isGranted) {
        await SystemNavigator.pop();
      }
    }
  } else {
    if (await Permission.storage.isDenied ||
        await Permission.storage.isPermanentlyDenied) {
      final state = await Permission.storage.request();
      if (!state.isGranted) {
        await SystemNavigator.pop();
      }
    }
  }

  MediaKit.ensureInitialized();

  await PreferencesService.init();

  runApp(const ProviderScope(child: AppRoot()));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redstash Client',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),
      home: const Root(),
    );
  }
}

class Root extends ConsumerWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basepath = ref.watch(localSettingsProvider).basepath;

    if (basepath.isEmpty) return AuthPage();

    return HomePage();
  }
}
