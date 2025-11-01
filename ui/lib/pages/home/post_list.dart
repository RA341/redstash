import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart' as mkit;
import 'package:media_kit_video/media_kit_video.dart';
import 'package:redstash/config/config.dart';
import 'package:redstash/gen/posts/v1/posts.pb.dart' hide Image, Video;
import 'package:redstash/providers/account.dart';
import 'package:redstash/providers/posts.dart';
import 'package:redstash/utils/error_display.dart';
import 'package:redstash/utils/loading_widget.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAccount = ref.watch(activeAccountProvider);
    if (activeAccount == null) {
      return const Center(
        child: Text("Please select an account from the dropdown"),
      );
    }

    final postListAsyncValue = ref.watch(postListProvider(activeAccount));
    final postListNotifier = ref.read(postListProvider(activeAccount).notifier);

    return postListAsyncValue.when(
      data: (paginatedData) {
        final posts = paginatedData;

        if (posts.isEmpty) {
          return const Center(child: Text("No posts found"));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            // Check if user is near the end of the list
            final metrics = scrollInfo.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent * 0.9 &&
                // todo last page
                // !isLastPage && // Don't load if we know it's the last page
                // Don't load if already loading
                !postListAsyncValue.isLoading) {
              postListNotifier.forward();
            }
            return false; // Allow the notification to continue to bubble up
          },
          child: ListView.builder(
            // +1 for the loading indicator/footer if not on the last page
            itemCount: posts.length + (1),
            itemBuilder: (context, index) {
              // --- Last item is the loading indicator ---
              if (index == posts.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              // --- Regular post item ---
              return PostCard(post: posts[index]);
            },
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Error fetching initial posts"),
            Text(error.toString()),
          ],
        ),
      ),

      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class PostCard extends ConsumerWidget {
  const PostCard({required this.post, super.key});

  final Post post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGallery = post.gallery.isNotEmpty;
    final isVideo = !isGallery && (post.directLink.url.endsWith(".mp4"));

    var widgetRatio = 16 / 9;

    final Widget displayWidget;
    if (isGallery) {
      displayWidget = GalleryPostView(post: post, gallery: post.gallery);

      if (post.gallery.first.hasRatio()) {
        widgetRatio = post.gallery.first.ratio;
      }
    } else {
      if (isVideo) {
        displayWidget = VideoPostView(post: post, videoLink: post.directLink);
      } else {
        displayWidget = ImagePostView(post: post, media: post.directLink);
      }
      if (post.directLink.hasRatio()) {
        widgetRatio = post.directLink.ratio;
      }
    }

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
            Align(
              alignment: Alignment.topCenter,
              child: AspectRatio(
                aspectRatio: widgetRatio,
                child: displayWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryPostView extends StatefulWidget {
  const GalleryPostView({super.key, required this.gallery, required this.post});

  final List<Media> gallery;
  final Post post;

  @override
  State<GalleryPostView> createState() => _GalleryPostViewState();
}

class _GalleryPostViewState extends State<GalleryPostView> {
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
            children: widget.gallery
                .map((e) => ImagePostView(post: widget.post, media: e))
                .toList(),
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

class ImagePostView extends ConsumerWidget {
  const ImagePostView({required this.post, required this.media, super.key});

  final Post post;
  final Media media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final base = ref.watch(localSettingsProvider).basepath;
    final url = getUrl(basePath: base, link: media.url);

    return Image.network(
      url,
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
      errorBuilder: (context, error, stackTrace) {
        return ErrorDisplay(
          title: "Unable to fetch image",
          error: error.toString(),
          stacktrace: stackTrace.toString(),
        );
      },
    );
  }
}

// todo pause/unpause on hide
// custom controls
class VideoPostView extends ConsumerStatefulWidget {
  const VideoPostView({required this.post, required this.videoLink, super.key});

  final Post post;
  final Media videoLink;

  @override
  ConsumerState createState() => _VideoPostWidgetState();
}

class _VideoPostWidgetState extends ConsumerState<VideoPostView> {
  late final player = mkit.Player(
    configuration: mkit.PlayerConfiguration(muted: kDebugMode),
  );

  late final controller = VideoController(player);

  late final base = ref.read(localSettingsProvider).basepath;

  @override
  void initState() {
    super.initState();

    final url = getUrl(basePath: base, link: widget.videoLink.url);
    player.open(mkit.Media(url));
  }

  @override
  Widget build(BuildContext context) {
    return Video(
      controller: controller,
      pauseUponEnteringBackgroundMode: true,
      wakelock: true,
    );
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}

String getUrl({required String basePath, required String link}) =>
    "${kIsWeb ? "" : basePath}api/posts/$link";
