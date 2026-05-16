import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/workout_plan.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/screens/active_workout_screen.dart';
import 'package:exo/screens/add_exercise_screen.dart';
import 'package:exo/screens/create_plan_screen.dart';
import 'package:exo/widgets/tts_toggle_button.dart';

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
                      horizontal: 8,
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
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        items: state.plans.map((p) {
                          return DropdownMenuItem(
                            value: p.id,
                            child: Text(p.name),
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
                : Text(plan.name),
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
              Text('$completed از $total روز تکمیل شده'),
              Text('${(progress * 100).toInt()}%'),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
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
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(color: Colors.blue.shade400, width: 2)
            : BorderSide.none,
      ),
      child: !day.isUnlocked
          ? _buildLockedCard()
          : _buildUnlockedCard(context, day, isSelected),
    );
  }

  Widget _buildLockedCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.lock, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ابتدا روز قبلی را کامل کنید',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: day.isCompleted
                      ? Colors.green.shade100
                      : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  day.isCompleted ? Icons.check : Icons.fitness_center,
                  color: day.isCompleted ? Colors.green : Colors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${day.exercises.length} تمرین - ${day.estimatedDurationMinutes} دقیقه',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
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
              if (day.isCompleted)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green.shade400,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
        if (day.exercises.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ...day.exercises
                    .take(3)
                    .map(
                      (ex) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 6,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${ex.name} - ${ex.sets} ست × ${ex.repsOrDuration} ${ex.isTimeBased ? 'ثانیه' : 'تکرار'}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
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
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: day.isCompleted
                      ? null
                      : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ActiveWorkoutScreen(dayId: day.id),
                          ),
                        ),
                  icon: Icon(day.isCompleted ? Icons.check : Icons.play_arrow),
                  label: Text(day.isCompleted ? 'انجام شد' : 'شروع'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
