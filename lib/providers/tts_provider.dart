import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'music_provider.dart';

part 'tts_provider.g.dart';

class TTSState {
  final bool enabled;
  final bool isSpeaking;
  final bool isFallback;

  const TTSState({
    this.enabled = false,
    this.isSpeaking = false,
    this.isFallback = false,
  });

  TTSState copyWith({
    bool? enabled,
    bool? isSpeaking,
    bool? isFallback,
  }) {
    return TTSState(
      enabled: enabled ?? this.enabled,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      isFallback: isFallback ?? this.isFallback,
    );
  }
}

@riverpod
class TTSService extends _$TTSService {
  FlutterTts? _flutterTts;

  @override
  TTSState build() {
    _initTts();
    ref.onDispose(() {
      _flutterTts?.stop();
    });
    return const TTSState();
  }

  Future<void> _initTts() async {
    try {
      _flutterTts = FlutterTts();
      bool faAvailable = false;
      try {
        faAvailable = await _flutterTts?.isLanguageAvailable('fa-IR') ?? false;
      } catch (_) {}

      if (faAvailable) {
        await _flutterTts?.setLanguage('fa-IR');
        state = state.copyWith(isFallback: false);
      } else {
        await _flutterTts?.setLanguage('en-US');
        state = state.copyWith(isFallback: true);
      }

      await _flutterTts?.setSpeechRate(0.5);
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);

      _flutterTts?.setStartHandler(() {
        state = state.copyWith(isSpeaking: true);
      });
      _flutterTts?.setCompletionHandler(() {
        state = state.copyWith(isSpeaking: false);
        ref.read(musicProviderProvider.notifier).unduck();
      });
    } catch (_) {
      _flutterTts = null;
    }
  }

  void toggle() {
    state = state.copyWith(enabled: !state.enabled);
  }

  void enable() {
    state = state.copyWith(enabled: true);
  }

  void disable() {
    state = state.copyWith(enabled: false);
  }

  Future<void> speak(String text) async {
    if (!state.enabled || _flutterTts == null) return;
    try {
      await ref.read(musicProviderProvider.notifier).duck();
      await _flutterTts?.speak(text);
    } catch (_) {
      ref.read(musicProviderProvider.notifier).unduck();
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
      state = state.copyWith(isSpeaking: false);
      ref.read(musicProviderProvider.notifier).unduck();
    } catch (_) {}
  }

  Future<void> announceExerciseStart(String exerciseName) async {
    if (state.isFallback) {
      await speak('Start $exerciseName');
    } else {
      await speak('شروع $exerciseName');
    }
  }

  Future<void> announceRestStart(int seconds, {String? nextExerciseName}) async {
    if (state.isFallback) {
      final msg = nextExerciseName != null
          ? 'Rest $seconds seconds, next up $nextExerciseName'
          : 'Rest $seconds seconds';
      await speak(msg);
    } else {
      final msg = nextExerciseName != null
          ? 'زمان استراحت $seconds ثانیه، تمرین بعدی $nextExerciseName'
          : 'زمان استراحت $seconds ثانیه';
      await speak(msg);
    }
  }

  Future<void> announceSetComplete(int setNumber, int totalSets) async {
    if (state.isFallback) {
      await speak('Set $setNumber of $totalSets complete');
    } else {
      await speak('ست $setNumber از $totalSets تمام شد');
    }
  }

  Future<void> announceMidway() async {
    if (state.isFallback) {
      await speak('Halfway there, keep going');
    } else {
      await speak('نیمی از زمان باقی‌مانده');
    }
  }

  Future<void> announceExerciseComplete(String exerciseName) async {
    if (state.isFallback) {
      await speak('$exerciseName complete');
    } else {
      await speak('$exerciseName تمام شد');
    }
  }

  Future<void> announceWorkoutComplete() async {
    if (state.isFallback) {
      await speak('Great job! Workout complete');
    } else {
      await speak('آفرین! تمرین با موفقیت انجام شد');
    }
  }

  Future<void> announceNextExercise(String exerciseName) async {
    if (state.isFallback) {
      await speak('Next exercise: $exerciseName');
    } else {
      await speak('تمرین بعدی: $exerciseName');
    }
  }
}
