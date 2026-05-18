import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:exo/models/exercise_media.dart';
import 'package:exo/core/utils/logger.dart';

class ExerciseMediaWidget extends StatefulWidget {
  final ExerciseMedia media;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ExerciseMediaWidget({
    super.key,
    required this.media,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  State<ExerciseMediaWidget> createState() => _ExerciseMediaWidgetState();
}

class _ExerciseMediaWidgetState extends State<ExerciseMediaWidget> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    if (widget.media.type != ExerciseMediaType.video) return;
    final source = widget.media.source;
    if (source.isEmpty) return;

    _videoController = widget.media.isLocal
        ? VideoPlayerController.file(File(source))
        : VideoPlayerController.networkUrl(Uri.parse(source));

    _videoController!.initialize().then((_) {
      if (mounted) {
        _videoController!.setLooping(true);
        _videoController!.play();
        setState(() {});
      }
    }).catchError((e) {
      AppLogger.logError(e);
    });
  }

  @override
  void didUpdateWidget(covariant ExerciseMediaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media.source != widget.media.source ||
        oldWidget.media.type != widget.media.type) {
      _videoController?.dispose();
      _videoController = null;
      _initVideo();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final source = widget.media.source;
    if (source.isEmpty) {
      return const SizedBox.shrink();
    }

    switch (widget.media.type) {
      case ExerciseMediaType.lottie:
        return widget.media.isLocal
            ? Lottie.file(
                File(source),
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              )
            : Lottie.network(
                source,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              );

      case ExerciseMediaType.video:
        if (_videoController == null || !_videoController!.value.isInitialized) {
          return const SizedBox(
            width: 48,
            height: 48,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: VideoPlayer(_videoController!),
        );

      case ExerciseMediaType.image:
        return widget.media.isLocal
            ? Image.file(
                File(source),
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              )
            : CachedNetworkImage(
                imageUrl: source,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
                placeholder: (_, _) => const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => Icon(
                  Icons.broken_image,
                  size: widget.width ?? 48,
                  color: Colors.grey,
                ),
              );

      case ExerciseMediaType.none:
        return const SizedBox.shrink();
    }
  }
}
