import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/workout_plan.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/screens/active_workout_screen.dart';
import 'package:exo/screens/add_exercise_screen.dart';
import 'package:exo/screens/create_plan_screen.dart';
import 'package:exo/widgets/tts_toggle_button.dart';
import 'package:exo/core/theme/app_theme.dart';

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
            title: state.plans.length > 1
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: state.activePlanId,
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        items: state.plans.map((p) {
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
                        }).toList(),
                        onChanged: (planId) {
                          if (planId != null) {
                            ref
                                .read(workoutNotifierProvider.notifier)
                                .switchActivePlan(planId);
                          }
                        },
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fitness_center, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(plan.name),
                    ],
                  ),
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
              _buildProgressBar(state, plan),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: plan.days.length,
                  itemBuilder: (context, index) {
                    final day = plan.days[index];
                    return _DayCard(
                      day: day,
                      isSelected: index == state.currentDayIndex,
                    );
                  },
                ),
              ),
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

  Widget _buildProgressBar(WorkoutPlanState state, WorkoutPlan plan) {
    final completed = state.completedDaysCount;
    final total = state.totalDays;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed از $total روز تکمیل شده',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.tealPrimary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: AppTheme.tealPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.tealPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final WorkoutDay day;
  final bool isSelected;

  const _DayCard({required this.day, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final isLocked = !day.isUnlocked;
    final isCompleted = day.isCompleted;

    return Card(
      elevation: isSelected ? 2 : 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isSelected
            ? BorderSide(color: AppTheme.tealPrimary, width: 2.5)
            : isLocked
            ? BorderSide(color: Colors.grey.shade300, width: 1)
            : BorderSide.none,
      ),
      color: isLocked ? Colors.grey.shade50 : null,
      child: isLocked
          ? _buildLockedCard()
          : _buildUnlockedCard(context, day, isSelected, isCompleted),
    );
  }

  Widget _buildLockedCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.lock, color: Colors.grey.shade400),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ابتدا روز قبلی را کامل کنید',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnlockedCard(
    BuildContext context,
    WorkoutDay day,
    bool isSelected,
    bool isCompleted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isCompleted
                ? AppTheme.tealPrimary.withAlpha(25)
                : isSelected
                ? AppTheme.tealPrimary.withAlpha(15)
                : Colors.grey.shade50,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.tealPrimary
                      : isSelected
                      ? AppTheme.tealPrimary.withAlpha(50)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.fitness_center,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? AppTheme.tealDark : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.exercises.length} تمرین • ${day.estimatedDurationMinutes} دقیقه',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected && !isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.tealPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'امروز',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (isCompleted)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.check_circle,
                    color: AppTheme.tealPrimary,
                    size: 26,
                  ),
                ),
            ],
          ),
        ),
        if (day.exercises.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Column(
              children: [
                ...day.exercises
                    .take(3)
                    .map(
                      (ex) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                '${ex.name} • ${ex.sets}×${ex.repsOrDuration}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                if (day.exercises.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'و ${day.exercises.length - 3} تمرین دیگر...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCompleted
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ActiveWorkoutScreen(dayId: day.id),
                      ),
                    ),
              icon: Icon(isCompleted ? Icons.check : Icons.play_arrow),
              label: Text(isCompleted ? 'انجام شد' : 'شروع'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCompleted
                    ? Colors.grey.shade300
                    : AppTheme.tealPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
