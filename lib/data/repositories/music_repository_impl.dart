import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/logger.dart';
import '../../domain/repositories/music_repository.dart';

class MusicRepositoryImpl implements MusicRepository {
  final Box _appBox;
  static const _savedTrackKey = 'background_music_path';
  static const _musicSubDir = 'exercise_media';

  MusicRepositoryImpl(this._appBox);

  @override
  Future<String?> pickAndSaveMusic() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac', 'wav', 'ogg', 'm4a'],
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final tempPath = file.path;
    if (tempPath == null) return null;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${appDir.path}/$_musicSubDir');
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final extension = tempPath.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final destPath = '${mediaDir.path}/bg_$timestamp.$extension';
      await File(tempPath).copy(destPath);

      return destPath;
    } catch (e, st) {
      AppLogger.logError(e, st);
      return null;
    }
  }

  @override
  Future<void> clearSavedMusic() async {
    try {
      final path = _appBox.get(_savedTrackKey) as String?;
      if (path != null && path.isNotEmpty) {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
      await _appBox.delete(_savedTrackKey);
    } catch (e, st) {
      AppLogger.logError(e, st);
    }
  }

  @override
  Future<String?> getSavedMusicPath() async {
    try {
      return _appBox.get(_savedTrackKey) as String?;
    } catch (e, st) {
      AppLogger.logError(e, st);
      return null;
    }
  }

  @override
  Future<void> saveMusicPath(String path) async {
    try {
      await _appBox.put(_savedTrackKey, path);
    } catch (e, st) {
      AppLogger.logError(e, st);
    }
  }
}
