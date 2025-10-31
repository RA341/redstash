import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:redstash/config/config.dart';
import 'package:redstash/config/logger.dart';
import 'package:redstash/gen/posts/v1/posts.pb.dart' hide Image, Video;
import 'package:redstash/providers/account.dart';
import 'package:redstash/providers/posts.dart';
import 'package:media_kit/media_kit.dart';
import 'package:redstash/utils/error_display.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAccount = ref.watch(activeAccountProvider);
    if (activeAccount == null) {
      return Center(child: Text("Please select an account from the dropdown"));
    }

    final postList = ref.watch(postListProvider(activeAccount));

    return postList.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text("No posts found"));
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => PostCard(post: data[index]),
        );
      },
      error: (error, stackTrace) => Center(
        child: Column(
          children: [Text("Error fetching posts"), Text(error.toString())],
        ),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}

class PostCard extends ConsumerWidget {
  const PostCard({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basePath = ref.watch(localSettingsProvider).basepath;

    final isGallery = post.gallery.isNotEmpty;
    final isVideo = !isGallery && (post.directLink.endsWith(".mp4"));

    final Widget displayWidget;

    if (isVideo) {
      String fullMediaUrl = getUrl(basePath: basePath, link: post.directLink);
      displayWidget = VideoPlayer(videoLink: fullMediaUrl);
    } else if (isGallery) {
      displayWidget = GalleryWidget(gallery: post.gallery);
    } else {
      displayWidget = ImageWidget(url: post.directLink);
    }

    // 1. Get screen height and calculate max height
    final screenHeight = MediaQuery.of(context).size.height;
    // 0.7 * screenHeight is 70% of the screen height
    final maxHeight = screenHeight * 0.7;

    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                post.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Align(alignment: Alignment.topCenter, child: displayWidget),
            // ConstrainedBox(
            //   constraints: BoxConstraints(maxHeight: maxHeight),
            //   child: Align(
            //     alignment: Alignment.topCenter,
            //     child: displayWidget,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  const GalleryWidget({super.key, required this.gallery});

  final List<String> gallery;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late final PageController controller;

  @override
  void initState() {
    controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: controller,
            children: widget.gallery.map((e) => ImageWidget(url: e)).toList(),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () async {
                await controller.previousPage(
                  duration: Duration(milliseconds: 10),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 30,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black45,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () async {
                await controller.previousPage(
                  duration: Duration(milliseconds: 10),
                  curve: Curves.easeIn,
                );
              },
              icon: const Icon(Icons.arrow_forward_ios),
              iconSize: 30,
              style: IconButton.styleFrom(
                backgroundColor: Colors.black45,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageWidget extends ConsumerWidget {
  const ImageWidget({required this.url, super.key});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basePath = ref.watch(localSettingsProvider).basepath;

    var fullUrl = getUrl(basePath: basePath, link: url);

    return Image.network(
      fullUrl,
      fit: BoxFit.contain,
      alignment: Alignment.center,
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) return child;

            double? progress;
            if (loadingProgress.expectedTotalBytes != null) {
              progress =
                  loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!;
            }

            return Center(child: CircularProgressIndicator(value: progress));
          },
      errorBuilder: (context, error, stackTrace) => ErrorDisplay(
        title: "Unable to fetch image",
        error: error.toString(),
        stacktrace: stackTrace.toString(),
      ),
    );
  }
}

// todo pause/unpause on hide
// custom controls
class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.videoLink});

  final String videoLink;

  @override
  State<VideoPlayer> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
  late final player = Player(
    configuration: PlayerConfiguration(muted: kDebugMode),
  );

  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media(widget.videoLink));
  }

  var videoRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.rect,
      builder: (context, value, child) {
        if (value != null) {
          // todo precompute aspect ratio
          videoRatio = value.width / value.height >= 1.0
              // Landscape or square (Wider than 1:1, so we set a standard 16:9)
              ? 16 / 9
              // Portrait or Taller (Taller than 1:1, so we set a standard 4:5)
              : 4 / 5;

          // logger.i("Target: $videoRatio");
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: videoRatio,
              child: Video(
                controller: controller,
                pauseUponEnteringBackgroundMode: true,
                wakelock: true,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

String getUrl({required String basePath, required String link}) =>
    "$basePath/api/posts/$link";
