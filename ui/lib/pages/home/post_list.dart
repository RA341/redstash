import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:redstash/config/config.dart';
import 'package:redstash/gen/posts/v1/posts.pb.dart' hide Image, Video;
import 'package:redstash/providers/account.dart';
import 'package:redstash/providers/posts.dart';
import 'package:media_kit/media_kit.dart';

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
      displayWidget = GalleryWidget(post.gallery);
    } else {
      displayWidget = ImageWidget(url: post.directLink);
    }

    return Card(
      child: SizedBox(
        height: 700, // Define total height
        child: Column(
          children: [
            Expanded(flex: 1, child: Text(post.title)),
            Expanded(flex: 4, child: displayWidget),
          ],
        ),
      ),
    );
  }
}

// todo remove and cache this outside maybe in the provider
String getUrl({required String basePath, required String link}) {
  var realBase = basePath;
  if (basePath.endsWith("/")) {
    realBase = realBase.substring(0, realBase.length - 1);
  }
  final streamUrl = "$realBase/api/posts/$link";
  return streamUrl;
}

class GalleryWidget extends HookConsumerWidget {
  const GalleryWidget(this.gallery, {super.key});

  final List<String> gallery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController();

    return AspectRatio(
      aspectRatio: 1.0,
      child: PageView(
        physics: ClampingScrollPhysics(),
        controller: controller,
        children: gallery.map((e) => ImageWidget(url: e)).toList(),
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

    return Image.network(fullUrl, fit: BoxFit.contain, width: 400, height: 400);
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
  // Create a [Player] to control playback.
  late final player = Player(configuration: PlayerConfiguration(muted: false));

  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(Media(widget.videoLink));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        // Use [Video] widget to display video output.
        child: Video(
          controller: controller,
          // pauseUponEnteringBackgroundMode: true,
          wakelock: true,
        ),
      ),
    );
  }
}
