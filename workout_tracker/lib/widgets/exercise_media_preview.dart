import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ExerciseMediaPreview {
  static void show(BuildContext context, {String? imageUrl, String? videoUrl}) {
    if (imageUrl != null && videoUrl != null) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('نمایش تصویر'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showImage(context, imageUrl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('پخش ویدیو'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showVideo(context, videoUrl);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    } else if (imageUrl != null) {
      _showImage(context, imageUrl);
    } else if (videoUrl != null) {
      _showVideo(context, videoUrl);
    }
  }

  static void _showImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('پیش‌نمایش'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, _) => const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, _, _) => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image, size: 48),
                      SizedBox(height: 8),
                      Text('خطا در بارگذاری'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showVideo(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _VideoPreviewScreen(url: url),
      ),
    );
  }
}

class _VideoPreviewScreen extends StatefulWidget {
  final String url;
  const _VideoPreviewScreen({required this.url});

  @override
  State<_VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<_VideoPreviewScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    await _videoController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoController!.value.aspectRatio,
      placeholder: const Center(child: CircularProgressIndicator()),
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ویدیو')),
      body: _chewieController != null && _videoController != null
          ? Center(child: Chewie(controller: _chewieController!))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
