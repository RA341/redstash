//
//  Generated code. Do not modify.
//  source: downloader/v1/downloader.proto
//

import "package:connectrpc/connect.dart" as connect;
import "downloader.pb.dart" as downloaderv1downloader;
import "downloader.connect.spec.dart" as specs;

extension type DownloaderServiceClient (connect.Transport _transport) {
  Future<downloaderv1downloader.TriggerDownloaderResponse> triggerDownloader(
    downloaderv1downloader.TriggerDownloaderRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.DownloaderService.triggerDownloader,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
