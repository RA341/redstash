import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:redstash/config/config.dart';
import 'package:redstash/config/logger.dart';
import 'package:redstash/utils/async_button.dart';
import 'package:redstash/utils/error_display.dart';

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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Redstash Setup", style: TextStyle(fontSize: 30)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Server URL',
                  hintText: 'localhost:8558',
                  prefixIcon: Icon(Icons.ac_unit_rounded),
                  border: OutlineInputBorder(),
                ),
                controller: basepath,
              ),
            ),

            AsyncButton(
              onPress: () async {
                if (basepath.text.isEmpty) {
                  await showErrorDialog(
                    context: context,
                    title: "Base url cannot be empty",
                    error: "Enter a valid redstash server url",
                  );
                  return;
                }

                final (result, candidates) = await inferServerUrl(
                  basepath.text.trim(),
                );
                if (result == null) {
                  logger.i("urls $candidates");
                  await showErrorDialog(
                    context: context,
                    title: 'Unable to find Redstash server',
                    error:
                        "Check your address, tried the following urls:\n\n${candidates.join("\n")}",
                  );
                  return;
                }

                final baseurl = result;
                ref.read(localSettingsProvider.notifier).saveUrl(baseurl);
              },
              normalButton: Text("Next"),
              loadingButton: Text("Checking"),
              icon: Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}

Future<(String?, List<String>)> inferServerUrl(String url) async {
  final candidates = generateUrlCandidates(url);

  for (final url in candidates) {
    if (await checkServerUrl(url)) {
      return (url, <String>[]);
    }
  }

  return (null, candidates);
}

Future<bool> checkServerUrl(String base) async {
  try {
    final url = Uri.parse("$base/info");
    final response = await http.get(url).timeout(Duration(seconds: 2));
    final serverInfo = jsonDecode(response.body);
    logger.i(serverInfo);

    return true;
  } catch (e) {
    return false;
  }
}

/// generate URL candidates based on the input URL.
List<String> generateUrlCandidates(
  String initialInput, {
  String defaultHttpsPort = "8558",
  String defaultHttpPort = "8558",
}) {
  var input = initialInput;

  if (input.endsWith('/')) {
    input = input.substring(0, input.length - 1);
  }

  final result = parseUrl(input);

  if (result == null) return [];

  final (scheme, host, port, path) = result;

  final protoCandidates = <String>[];
  final supportedProtos = <String>['https:', 'http:'];

  if (scheme.isNotEmpty) {
    protoCandidates.add('$scheme//$host');
  } else {
    // The user did not declare a protocol
    for (final proto in supportedProtos) {
      protoCandidates.add('$proto//$host');
    }
  }

  final finalCandidates = <String>[];

  if (port.isNotEmpty) {
    for (final candidate in protoCandidates) {
      finalCandidates.add('$candidate:$port$path');
    }
  } else {
    // The port wasn't declared, so use default Jellyfin and protocol ports

    for (final finalUrl in protoCandidates) {
      // add url without port
      finalCandidates.add('$finalUrl$path');

      if (finalUrl.startsWith('https')) {
        finalCandidates.add('$finalUrl:$defaultHttpsPort$path');
      } else if (finalUrl.startsWith('http')) {
        finalCandidates.add('$finalUrl:$defaultHttpPort$path');
      }
    }
  }

  return finalCandidates;
}

/// parse url and separate it into its components
/// if you are wondering why we don't use Uri.tryParse() it cannot parse ipv4 or ipv6 addresses
(String, String, String, String)? parseUrl(String initialInput) {
  var input = initialInput;

  if (!(input.startsWith('http://') || input.startsWith('https://'))) {
    // fill in a empty protocol, so regex matches
    input = 'none://$input';
  }

  final rgx = RegExp(r'^(.*:)//([A-Za-z0-9\-.]+)(:[0-9]+)?(.*)$');
  final match = rgx.firstMatch(input);
  if (match != null) {
    var scheme = match.group(1) ?? ''; // add back the //
    final body = match.group(2) ?? '';
    final port = match.group(3)?.substring(1) ?? ''; // Remove leading colon
    final path = match.group(4) ?? '';

    if (scheme == 'none:') {
      scheme = '';
    }

    return (scheme, body, port, path);
  }

  return null;
}
