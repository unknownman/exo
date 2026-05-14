import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exo/models/workout_day.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/screens/active_workout_screen.dart';
import 'package:exo/screens/add_exercise_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: Consumer<WorkoutProvider>(
          builder: (context, provider, _) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.days.length,
              itemBuilder: (context, index) {
                final day = provider.days[index];
                return _DayCard(day: day);
              },
            );
          },
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final WorkoutDay day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final isLocked = !day.isUnlocked;
    final isCompleted = day.isCompletedToday;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isLocked ? Colors.grey[300] : null,
      child: isLocked ? _buildLockedCard() : _buildUnlockedCard(context, isCompleted),
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            ...day.exercises.map((ex) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${ex.name} | ${ex.equipment} | ${ex.sets} ست × ${ex.repsOrDuration} ${ex.isTimeBased ? 'ثانیه' : 'تکرار'} | استراحت: ${ex.restTime}ث',
                    style: const TextStyle(fontSize: 14),
                  ),
                )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isCompleted
                  ? null
                  : () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ActiveWorkoutScreen(day: day),
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
