import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/workout_day.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/screens/active_workout_screen.dart';
import 'package:exo/screens/add_exercise_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutStateAsync = ref.watch(workoutNotifierProvider);

    return workoutStateAsync.when(
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
      data: (workoutState) {
        if (workoutState.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (workoutState.errorMessage != null) {
          return Scaffold(
            body: Center(child: Text(workoutState.errorMessage!)),
          );
        }

        final days = workoutState.days;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(title: const Text('برنامه تمرینی ۳ روزه')),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AddExerciseScreen()),
              ),
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return _DayCard(day: day);
              },
            ),
          ),
        );
      },
    );
  }
}

class _DayCard extends StatelessWidget {
  final WorkoutDay day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: !day.isUnlocked ? Colors.grey[300] : null,
      child: !day.isUnlocked
          ? _buildLockedCard()
          : _buildUnlockedCard(context, day.isCompletedToday),
    );
  }

  Widget _buildLockedCard() {
    return ListTile(
      leading: const Icon(Icons.lock, size: 32),
      title: Text(day.dayName, style: const TextStyle(fontSize: 20)),
      subtitle: const Text('ابتدا روز قبلی را کامل کنید'),
    );
  }

  Widget _buildUnlockedCard(BuildContext context, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  day.dayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isCompleted)
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
            ],
          ),
          const Divider(),
          if (day.exercises.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('هنوز تمرینی اضافه نشده'),
            )
          else
            ...day.exercises.map(
              (ex) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  '${ex.name} | ${ex.equipment} | ${ex.sets} ست × ${ex.repsOrDuration} ${ex.isTimeBased ? 'ثانیه' : 'تکرار'} | استراحت: ${ex.restTime}ث',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCompleted
                  ? null
                  : () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ActiveWorkoutScreen(
                          dayId: day.id,
                          dayName: day.dayName,
                        ),
                      ),
                    ),
              icon: Icon(isCompleted ? Icons.check : Icons.play_arrow),
              label: Text(isCompleted ? 'انجام شد' : 'شروع تمرین'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
