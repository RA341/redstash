import 'dart:convert';

import 'package:connectrpc/connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redstash/config/config.dart';
import 'package:http/http.dart' as http;
import '../config/logger.dart' show logger;
import 'grpc_channel_shared.dart';

final connectTransportProvider = Provider<Transport>((ref) {
  final localConfig = ref.watch(localSettingsProvider);
  final basePath = localConfig.basepath;

  // final Interceptor authentiation = <I extends Object, O extends Object>(next) {
  //   return (req) {
  //     req.headers.add('Authorization', sessionToken);
  //     return next(req);
  //   };
  // };

  return setupClientTransport(basePath, [
    // authentiation
  ]);
});

extension Err on String? {
  bool notNull() => this != null;
}

/// throws if error occurs
Future<T> mustRunGrpcRequest<T>(Future<T> Function() request) async {
  final (val, err) = await runGrpcRequest<T>(request);
  if (err.isNotEmpty) throw err;

  return val! as T;
}

// returns err only ignores value
Future<String?> runGrpcRequestErr<T>(Future<T> Function() request) async {
  final (_, err) = await runGrpcRequest(request);
  return err.isEmpty ? null : err;
}

/// returns error as string
Future<(T?, String)> runGrpcRequest<T>(Future<T> Function() request) async {
  try {
    final res = await request();
    return (res, '');
  } on ConnectException catch (e) {
    logger.e('Grpc error, $e');
    return (null, e.message);
  } catch (e) {
    logger.e('Failed to run GRPC request\nUnknown error: $e');
    return (null, 'Unknown Error: $e');
  }
}

Future<(Map<String, String>, String?)> checkServer(String basepath) async {
  var serverInfo = <String, String>{};

  try {

    return (serverInfo, null);
  } catch (e) {
    return (serverInfo, e.toString());
  }
}
