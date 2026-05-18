import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/utils/logger.dart';
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

@Riverpod(keepAlive: true)
class TTSService extends _$TTSService {
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  int _speechQueueCount = 0;

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
      } catch (e, st) { AppLogger.logError(e, st); }

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
        _speechQueueCount--;
        state = state.copyWith(isSpeaking: _speechQueueCount > 0);
        if (_speechQueueCount <= 0) {
          ref.read(musicProviderProvider.notifier).unduck();
        }
      });
    } catch (e, st) {
      _flutterTts = null;
      AppLogger.logError(e, st);
    }
    _isInitialized = true;
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
    if (!state.enabled) return;

    while (!_isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (_flutterTts == null) return;

    _speechQueueCount++;
    try {
      await ref.read(musicProviderProvider.notifier).duck();
      await _flutterTts?.speak(text);
    } catch (e, st) {
      _speechQueueCount--;
      if (_speechQueueCount <= 0) {
        ref.read(musicProviderProvider.notifier).unduck();
      }
      AppLogger.logError(e, st);
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
      _speechQueueCount = 0;
      state = state.copyWith(isSpeaking: false);
      ref.read(musicProviderProvider.notifier).unduck();
    } catch (e, st) { AppLogger.logError(e, st); }
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
