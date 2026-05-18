import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  static const _allowedExtensions = [
    'jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi', 'json',
  ];

  static const _mediaSubDir = 'exercise_media';

  @override
  Future<String?> pickAndSaveMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final tempPath = file.path;
    if (tempPath == null) return null;

    final extension = tempPath.split('.').last;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${appDir.path}/$_mediaSubDir');
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final destPath = '${mediaDir.path}/$timestamp.$extension';
      await File(tempPath).copy(destPath);

      return destPath;
    } catch (e, st) {
      AppLogger.logError(e, st);
      return null;
    }
  }

  @override
  Future<void> deleteMedia(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e, st) {
      AppLogger.logError(e, st);
    }
  }
}
