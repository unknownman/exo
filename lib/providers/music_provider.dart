import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/utils/logger.dart';
import 'storage_providers.dart';

part 'music_provider.g.dart';

const _savedTrackKey = 'background_music_path';
const _musicSubDir = 'exercise_media';

class MusicState {
  final bool isPlaying;
  final double volume;
  final String? currentTrack;
  final String? savedTrackPath;

  const MusicState({
    this.isPlaying = false,
    this.volume = 1.0,
    this.currentTrack,
    this.savedTrackPath,
  });

  MusicState copyWith({
    bool? isPlaying,
    double? volume,
    String? currentTrack,
    String? savedTrackPath,
    bool clearTrack = false,
    bool clearSaved = false,
  }) {
    return MusicState(
      isPlaying: isPlaying ?? this.isPlaying,
      volume: volume ?? this.volume,
      currentTrack: clearTrack ? null : (currentTrack ?? this.currentTrack),
      savedTrackPath:
          clearSaved ? null : (savedTrackPath ?? this.savedTrackPath),
    );
  }
}

@Riverpod(keepAlive: true)
class MusicProvider extends _$MusicProvider {
  AudioPlayer? _player;

  @override
  MusicState build() {
    _loadSavedTrack();
    ref.onDispose(() {
      _player?.dispose();
    });
    return const MusicState();
  }

  Future<void> _loadSavedTrack() async {
    try {
      final box = ref.read(appBoxProvider);
      final path = box.get(_savedTrackKey) as String?;
      if (path != null && path.isNotEmpty) {
        state = state.copyWith(savedTrackPath: path);
      }
    } catch (e, st) { AppLogger.logError(e, st); }
  }

  Future<void> _saveTrackPath(String path) async {
    final box = ref.read(appBoxProvider);
    await box.put(_savedTrackKey, path);
  }

  Future<void> _removeTrackPath() async {
    final box = ref.read(appBoxProvider);
    await box.delete(_savedTrackKey);
  }

  Future<void> pickBackgroundMusic() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'aac', 'wav', 'ogg', 'm4a'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final tempPath = file.path;
    if (tempPath == null) return;

    final extension = tempPath.split('.').last;

    try {
      final appDir = await getApplicationDocumentsDirectory();
      final mediaDir = Directory('${appDir.path}/$_musicSubDir');
      if (!await mediaDir.exists()) {
        await mediaDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final destPath = '${mediaDir.path}/bg_$timestamp.$extension';
      await File(tempPath).copy(destPath);

      await _saveTrackPath(destPath);
      state = state.copyWith(savedTrackPath: destPath);
    } catch (e, st) { AppLogger.logError(e, st); }
  }

  Future<void> clearBackgroundMusic() async {
    await _removeTrackPath();
    state = state.copyWith(clearSaved: true);
  }

  Future<void> playSavedTrack() async {
    String? path = state.savedTrackPath;
    if (path == null) {
      final box = ref.read(appBoxProvider);
      path = box.get(_savedTrackKey) as String?;
      if (path == null || path.isEmpty) return;
      state = state.copyWith(savedTrackPath: path);
    }
    await playLocalFile(path, loop: true);
  }

  Future<void> playLocalFile(String path, {bool loop = false}) async {
    try {
      if (_player == null) {
        _player = AudioPlayer();
        // Configure audio session for background music playback
        final session = await AudioSession.instance;
        await session.configure(const AudioSessionConfiguration(
          avAudioSessionCategory: AVAudioSessionCategory.playback,
          avAudioSessionMode: AVAudioSessionMode.defaultMode,
          androidAudioAttributes: AndroidAudioAttributes(
            contentType: AndroidAudioContentType.music,
            usage: AndroidAudioUsage.media,
          ),
          androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        ));
      }
      await _player!.setFilePath(path);
      if (loop) {
        _player!.setLoopMode(LoopMode.one);
      }
      await _player!.play();
      state = MusicState(
        isPlaying: true,
        volume: state.volume,
        currentTrack: path,
        savedTrackPath: state.savedTrackPath,
      );
    } catch (e, st) { AppLogger.logError(e, st); }
  }

  String? getSavedTrackName() {
    final p = state.savedTrackPath;
    if (p == null) return null;
    return p.split('/').last;
  }

  Future<void> pause() async {
    try {
      await _player?.pause();
      state = state.copyWith(isPlaying: false);
    } catch (e, st) { AppLogger.logError(e, st); }
  }

  Future<void> resume() async {
    try {
      await _player?.play();
      state = state.copyWith(isPlaying: true);
    } catch (e, st) { AppLogger.logError(e, st); }
  }

  Future<void> stop() async {
    try {
      await _player?.stop();
      state = state.copyWith(isPlaying: false, clearTrack: true);
    } catch (e, st) { AppLogger.logError(e, st); }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _player?.setVolume(volume);
      state = state.copyWith(volume: volume);
    } catch (e, st) { AppLogger.logError(e, st); }
  }

  Future<void> duck() async {
    await setVolume(0.2);
  }

  Future<void> unduck() async {
    await setVolume(1.0);
  }
}
