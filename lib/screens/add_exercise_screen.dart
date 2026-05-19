import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/providers/media_provider.dart';
import 'package:exo/providers/add_exercise_form_provider.dart';
import 'package:exo/core/constants/app_constants.dart';
import 'package:exo/widgets/exercise_media_widget.dart';
import 'package:exo/core/constants/app_strings.dart';

class AddExerciseScreen extends ConsumerWidget {
  const AddExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(workoutNotifierProvider);
    final formState = ref.watch(addExerciseFormNotifierProvider);

    return stateAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('${AppStrings.errorWithMessage}$e'))),
      data: (WorkoutPlanState planState) {
        final plan = planState.plan;
        if (plan == null || plan.days.isEmpty) {
          return const Scaffold(body: Center(child: Text(AppStrings.noPlan)));
        }

        final unlockedDays = plan.days.where((d) => d.isUnlocked).toList();
        if (unlockedDays.isEmpty) {
          return const Scaffold(body: Center(child: Text(AppStrings.noActiveDays)));
        }

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.addExercise)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: formState.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: AppStrings.exerciseNameInput,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      ref.read(addExerciseFormNotifierProvider.notifier).updateName(v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formState.description,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: AppStrings.exerciseDescription,
                    hintText: AppStrings.exerciseDescriptionHint,
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (v) =>
                      ref.read(addExerciseFormNotifierProvider.notifier).updateDescription(v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formState.coachCues,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: AppStrings.coachCues,
                    hintText: AppStrings.coachCuesHint,
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (v) =>
                      ref.read(addExerciseFormNotifierProvider.notifier).updateCoachCues(v),
                ),
                const SizedBox(height: 16),
                _buildMediaSection(formState, ref),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: formState.equipment,
                  decoration: const InputDecoration(
                    labelText: AppStrings.equipment,
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: AppConstants.equipmentTypes
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(addExerciseFormNotifierProvider.notifier).updateEquipment(v);
                    }
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: formState.selectedDayId ?? unlockedDays.firstOrNull?.id,
                  decoration: const InputDecoration(
                    labelText: AppStrings.workoutDay,
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: unlockedDays
                      .map(
                        (d) => DropdownMenuItem(
                          value: d.id,
                          child: Text(d.name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(addExerciseFormNotifierProvider.notifier).updateSelectedDayId(v);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formState.sets.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: AppStrings.numberOfSets,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      ref.read(addExerciseFormNotifierProvider.notifier).updateSets(v),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(
                    formState.isTimeBased ? AppStrings.timed : AppStrings.repBased,
                  ),
                  subtitle: Text(
                    formState.isTimeBased
                        ? AppStrings.timedSubtitle
                        : AppStrings.repsSubtitle,
                  ),
                  value: formState.isTimeBased,
                  onChanged: (v) =>
                      ref.read(addExerciseFormNotifierProvider.notifier).toggleTimeBased(v),
                ),
                TextFormField(
                  initialValue: formState.repsOrDuration.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: formState.isTimeBased
                        ? AppStrings.timePerSet
                        : AppStrings.repsCount,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      ref.read(addExerciseFormNotifierProvider.notifier).updateRepsOrDuration(v),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: formState.restTime.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: AppStrings.restTimeSeconds,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) =>
                      ref.read(addExerciseFormNotifierProvider.notifier).updateRestTime(v),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final success =
                        await ref.read(addExerciseFormNotifierProvider.notifier).submit(null);
                    if (success && context.mounted) {
                      context.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(AppStrings.saveExercise),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMediaSection(AddExerciseFormState formState, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (formState.selectedMedia != null) ...[
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 160,
                  color: Colors.grey.shade100,
                  child: ExerciseMediaWidget(
                    media: formState.selectedMedia!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 160,
                  ),
                ),
              ),
              IconButton(
                onPressed: () =>
                    ref.read(addExerciseFormNotifierProvider.notifier).clearMedia(),
                icon: const Icon(Icons.close, color: Colors.red),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          onPressed: () =>
              ref.read(addExerciseFormNotifierProvider.notifier).pickMedia(
                    ref.read(mediaRepositoryProvider),
                  ),
          icon: const Icon(Icons.attach_file),
          label: Text(
            formState.selectedMedia != null
                ? AppStrings.changeFile
                : AppStrings.selectFile,
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        Text(
          AppStrings.supportedMediaFormats,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
