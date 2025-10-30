import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:redstash/gen/downloader/v1/downloader.connect.client.dart';
import 'package:redstash/grpc/api.dart';

final downloadApiProvider = Provider<DownloaderServiceClient>((ref) {
  final transport = ref.watch(connectTransportProvider);
  return DownloaderServiceClient(transport);
});

