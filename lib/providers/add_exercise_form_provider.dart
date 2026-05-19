import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/exercise.dart';
import '../models/exercise_media.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/id_generator.dart';
import '../domain/repositories/media_repository.dart';
import 'workout_provider.dart';

part 'add_exercise_form_provider.g.dart';

class AddExerciseFormState {
  final String name;
  final String description;
  final String coachCues;
  final int sets;
  final int repsOrDuration;
  final int restTime;
  final String equipment;
  final String? selectedDayId;
  final bool isTimeBased;
  final ExerciseMedia? selectedMedia;

  AddExerciseFormState({
    this.name = '',
    this.description = '',
    this.coachCues = '',
    this.sets = AppConstants.defaultSets,
    this.repsOrDuration = AppConstants.defaultReps,
    this.restTime = AppConstants.defaultRest,
    this.equipment = AppConstants.defaultEquipment,
    this.selectedDayId,
    this.isTimeBased = false,
    this.selectedMedia,
  });

  bool get isValid =>
      name.trim().isNotEmpty &&
      sets > 0 &&
      repsOrDuration > 0 &&
      restTime > 0 &&
      selectedDayId != null;

  AddExerciseFormState copyWith({
    String? name,
    String? description,
    String? coachCues,
    int? sets,
    int? repsOrDuration,
    int? restTime,
    String? equipment,
    Object? selectedDayId = _unset,
    bool? isTimeBased,
    Object? selectedMedia = _unset,
  }) {
    return AddExerciseFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      coachCues: coachCues ?? this.coachCues,
      sets: sets ?? this.sets,
      repsOrDuration: repsOrDuration ?? this.repsOrDuration,
      restTime: restTime ?? this.restTime,
      equipment: equipment ?? this.equipment,
      selectedDayId: selectedDayId is _Unset
          ? this.selectedDayId
          : (selectedDayId as String?),
      isTimeBased: isTimeBased ?? this.isTimeBased,
      selectedMedia: selectedMedia is _Unset
          ? this.selectedMedia
          : (selectedMedia as ExerciseMedia?),
    );
  }
}

class _Unset {
  const _Unset();
}

const _unset = _Unset();

@Riverpod()
class AddExerciseFormNotifier extends _$AddExerciseFormNotifier {
  @override
  AddExerciseFormState build() {
    final planState = ref.read(workoutNotifierProvider).valueOrNull;
    String? defaultDayId;
    if (planState?.plan != null) {
      final unlockedDays =
          planState!.plan!.days.where((d) => d.isUnlocked).toList();
      if (unlockedDays.isNotEmpty) {
        if (planState.currentDay != null &&
            unlockedDays.any((d) => d.id == planState.currentDay!.id)) {
          defaultDayId = planState.currentDay!.id;
        } else {
          defaultDayId = unlockedDays.first.id;
        }
      }
    }
    return AddExerciseFormState(selectedDayId: defaultDayId);
  }

  void updateName(String v) => state = state.copyWith(name: v);
  void updateDescription(String v) => state = state.copyWith(description: v);
  void updateCoachCues(String v) => state = state.copyWith(coachCues: v);

  void updateSets(String v) {
    final parsed = int.tryParse(v);
    if (parsed != null && parsed > 0) {
      state = state.copyWith(sets: parsed);
    }
  }

  void updateRepsOrDuration(String v) {
    final parsed = int.tryParse(v);
    if (parsed != null && parsed > 0) {
      state = state.copyWith(repsOrDuration: parsed);
    }
  }

  void updateRestTime(String v) {
    final parsed = int.tryParse(v);
    if (parsed != null && parsed > 0) {
      state = state.copyWith(restTime: parsed);
    }
  }

  void updateEquipment(String v) => state = state.copyWith(equipment: v);
  void updateSelectedDayId(String v) =>
      state = state.copyWith(selectedDayId: v);

  void toggleTimeBased(bool v) {
    state = state.copyWith(
      isTimeBased: v,
      repsOrDuration:
          v ? AppConstants.defaultDuration : AppConstants.defaultReps,
    );
  }

  Future<void> pickMedia(MediaRepository repo) async {
    final path = await repo.pickAndSaveMedia();
    if (path != null) {
      state = state.copyWith(selectedMedia: ExerciseMedia.local(path));
    }
  }

  void clearMedia() {
    state = state.copyWith(selectedMedia: null);
  }

  Future<bool> submit(String? existingExerciseId) async {
    if (!state.isValid || state.selectedDayId == null) return false;

    final exercise = Exercise(
      id: existingExerciseId ?? IdGenerator.generate(),
      name: state.name.trim(),
      description: state.description.trim(),
      coachCues: state.coachCues.trim(),
      sets: state.sets,
      repsOrDuration: state.repsOrDuration,
      isTimeBased: state.isTimeBased,
      restTime: state.restTime,
      equipment: state.equipment,
      media: state.selectedMedia ?? const ExerciseMedia.empty(),
    );

    final notifier = ref.read(workoutNotifierProvider.notifier);
    if (existingExerciseId != null) {
      await notifier.updateExercise(
        state.selectedDayId!,
        existingExerciseId,
        exercise,
      );
    } else {
      await notifier.addExercise(state.selectedDayId!, exercise);
    }
    return true;
  }
}
