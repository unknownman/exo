import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/models/workout_plan.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/screens/active_workout_screen.dart';
import 'package:exo/screens/add_exercise_screen.dart';
import 'package:exo/screens/create_plan_screen.dart';
import 'package:exo/widgets/tts_toggle_button.dart';
import 'package:exo/core/theme/app_theme.dart';

const _addNewPlanValue = '__add_new_plan__';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(workoutNotifierProvider);

    return stateAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('خطا: $error'),
            ],
          ),
        ),
      ),
      data: (WorkoutPlanState state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.errorMessage != null) {
          return Scaffold(body: Center(child: Text(state.errorMessage!)));
        }

        final plan = state.plan;
        if (plan == null) {
          return _buildNoPlanView(context);
        }

        return Scaffold(
          appBar: AppBar(
            title: _PlanSelector(plans: state.plans, activePlanId: state.activePlanId),
            actions: const [TTSToggleButton()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddExerciseScreen()),
            ),
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              const _DayNavigationBar(),
              const _ProgressBar(),
              const _StartWorkoutButton(),
              const Expanded(child: _ExerciseListView()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoPlanView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('داشبورد')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 80, color: Colors.grey),
            const SizedBox(height: 24),
            const Text('هنوز برنامه‌ای ندارید', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CreatePlanScreen()),
              ),
              icon: const Icon(Icons.add),
              label: const Text('ایجاد برنامه جدید'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanSelector extends ConsumerWidget {
  final List<WorkoutPlan> plans;
  final String? activePlanId;

  const _PlanSelector({required this.plans, required this.activePlanId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: activePlanId,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          items: [
            ...plans.map((p) {
              return DropdownMenuItem(
                value: p.id,
                child: Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 18,
                      color: AppTheme.tealLight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(p.name)),
                  ],
                ),
              );
            }),
            const DropdownMenuItem(
              enabled: false,
              child: Divider(height: 1, thickness: 1),
            ),
            DropdownMenuItem(
              value: _addNewPlanValue,
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 18,
                    color: AppTheme.tealPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ایجاد برنامه جدید',
                    style: TextStyle(
                      color: AppTheme.tealPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            if (value == _addNewPlanValue) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CreatePlanScreen(),
                ),
              );
            } else {
              ref
                  .read(workoutNotifierProvider.notifier)
                  .switchActivePlan(value);
            }
          },
        ),
      ),
    );
  }
}

class _DayNavigationBar extends ConsumerWidget {
  const _DayNavigationBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(
      workoutNotifierProvider.select((s) => s.valueOrNull?.currentDayIndex ?? 0),
    );
    final days = ref.watch(
      workoutNotifierProvider.select((s) => s.valueOrNull?.plan?.days ?? <WorkoutDay>[]),
    );
    final isCompleted = days.isNotEmpty && currentIndex < days.length
        ? days[currentIndex].isCompleted
        : false;
    final totalDays = days.length;
    final currentDayName = currentIndex < days.length && days.isNotEmpty
        ? days[currentIndex].name
        : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                final newIndex = (currentIndex - 1 + totalDays) % totalDays;
                ref
                    .read(workoutNotifierProvider.notifier)
                    .setCurrentDayByIndex(newIndex);
              },
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.tealPrimary.withAlpha(20),
                foregroundColor: AppTheme.tealPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.tealPrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withAlpha(60),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.tealPrimary.withAlpha(50),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.fitness_center,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      currentDayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isCompleted) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.check, color: Colors.white, size: 17),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                final newIndex = (currentIndex + 1) % totalDays;
                ref
                    .read(workoutNotifierProvider.notifier)
                    .setCurrentDayByIndex(newIndex);
              },
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.tealPrimary.withAlpha(20),
                foregroundColor: AppTheme.tealPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completed = ref.watch(
      workoutNotifierProvider.select((s) => s.valueOrNull?.completedDaysCount ?? 0),
    );
    final total = ref.watch(
      workoutNotifierProvider.select((s) => s.valueOrNull?.totalDays ?? 0),
    );
    if (total == 0) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: completed / total,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$completed/$total',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class _StartWorkoutButton extends ConsumerWidget {
  const _StartWorkoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = ref.watch(
      workoutNotifierProvider.select((s) => s.valueOrNull?.currentDay),
    );
    if (currentDay == null) return const SizedBox.shrink();

    final isCompleted = currentDay.isCompleted;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: ElevatedButton.icon(
        onPressed: isCompleted
            ? null
            : () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ActiveWorkoutScreen(dayId: currentDay.id),
                  ),
                ),
        icon: Icon(isCompleted ? Icons.check_circle : Icons.play_arrow),
        label: Text(
          isCompleted ? 'انجام شد' : 'شروع تمرین',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? Colors.grey.shade300 : AppTheme.tealPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: isCompleted ? 0 : 2,
        ),
      ),
    );
  }
}

class _ExerciseListView extends ConsumerWidget {
  const _ExerciseListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDay = ref.watch(
      workoutNotifierProvider.select((s) => s.valueOrNull?.currentDay),
    );
    if (currentDay == null || currentDay.exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fitness_center, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'هیچ تمرینی برای این روز ثبت نشده',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Text(
              'با دکمه + تمرین اضافه کنید',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: currentDay.exercises.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final exercise = currentDay.exercises[index];
        return _ExerciseTile(exercise: exercise);
      },
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseTile({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final repsText = exercise.isTimeBased
        ? '${exercise.repsOrDuration}ث'
        : '${exercise.repsOrDuration} تکرار';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.tealPrimary.withAlpha(15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${exercise.sets}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.tealPrimary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            repsText,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              exercise.equipment,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
