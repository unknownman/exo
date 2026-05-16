import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsProvider = StateNotifierProvider<TTSNotifier, bool>((ref) {
  return TTSNotifier();
});

class TTSNotifier extends StateNotifier<bool> {
  FlutterTts? _flutterTts;

  TTSNotifier() : super(false) {
    _initTts();
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage('fa-IR');
      await _flutterTts?.setSpeechRate(0.5);
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);
    } catch (_) {
      _flutterTts = null;
    }
  }

  void toggle() {
    state = !state;
  }

  void enable() {
    state = true;
  }

  void disable() {
    state = false;
  }

  Future<void> speak(String text) async {
    if (!state || _flutterTts == null) return;
    try {
      await _flutterTts?.speak(text);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
    } catch (_) {}
  }

  Future<void> announceExerciseStart(String exerciseName) async {
    await speak('شروع $exerciseName');
  }

  Future<void> announceRestStart(int seconds) async {
    await speak('زمان استراحت $seconds ثانیه');
  }

  Future<void> announceSetComplete(int setNumber, int totalSets) async {
    await speak('ست $setNumber از $totalSets تمام شد');
  }

  Future<void> announceExerciseComplete(String exerciseName) async {
    await speak('$exerciseName تمام شد');
  }

  Future<void> announceWorkoutComplete() async {
    await speak('آفرین! تمرین با موفقیت انجام شد');
  }

  Future<void> announceNextExercise(String exerciseName) async {
    await speak('تمرین بعدی: $exerciseName');
  }
}
