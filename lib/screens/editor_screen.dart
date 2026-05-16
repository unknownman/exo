import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/workout_plan.dart';
import 'package:exo/providers/workout_provider.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final _planNameController = TextEditingController();
  bool _editingName = false;

  @override
  void dispose() {
    _planNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(workoutNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ویرایشگر برنامه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _showResetDialog(context),
            tooltip: 'بازنشانی',
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطا: $e')),
        data: (state) {
          final plan = state.plan;
          if (plan == null) {
            return const Center(child: Text('برنامه‌ای وجود ندارد'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPlanHeader(plan),
                const SizedBox(height: 24),
                _buildStatsRow(plan),
                const SizedBox(height: 24),
                const Text(
                  'روزهای تمرین',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildDaysList(plan),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanHeader(WorkoutPlan plan) {
    if (_editingName) {
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _planNameController,
              decoration: const InputDecoration(
                labelText: 'نام برنامه',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              ref
                  .read(workoutNotifierProvider.notifier)
                  .updatePlanName(_planNameController.text);
              setState(() => _editingName = false);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _editingName = false),
          ),
        ],
      );
    }

    return Card(
      child: ListTile(
        leading: const Icon(Icons.edit_note),
        title: Text(
          plan.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _planNameController.text = plan.name;
            setState(() => _editingName = true);
          },
        ),
      ),
    );
  }

  Widget _buildStatsRow(WorkoutPlan plan) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.calendar_today,
          label: 'روزها',
          value: '${plan.days.length}',
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.fitness_center,
          label: 'تمرین‌ها',
          value: '${plan.totalExercises}',
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.timer,
          label: 'مدت',
          value: '${plan.totalDurationMinutes} دقیقه',
        ),
      ],
    );
  }

  Widget _buildDaysList(WorkoutPlan plan) {
    if (plan.days.isEmpty) {
      return const Center(child: Text('روزی وجود ندارد'));
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plan.days.length,
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < newIndex) newIndex -= 1;
        final days = List<WorkoutDay>.from(plan.days);
        final day = days.removeAt(oldIndex);
        days.insert(newIndex, day);
        for (int i = 0; i < days.length; i++) {
          days[i] = days[i].copyWith(orderIndex: i);
        }
        final updatedPlan = plan.copyWith(days: days);
        ref.read(workoutNotifierProvider.notifier).updatePlanOrder(updatedPlan);
      },
      itemBuilder: (context, index) {
        final day = plan.days[index];
        return _DayEditorCard(
          key: ValueKey(day.id),
          day: day,
          onDelete: day.isUnlocked && plan.days.length > 1
              ? () =>
                    ref.read(workoutNotifierProvider.notifier).removeDay(day.id)
              : null,
          onRemoveExercise: day.isUnlocked
              ? (exerciseId) => ref
                    .read(workoutNotifierProvider.notifier)
                    .removeExercise(day.id, exerciseId)
              : null,
        );
      },
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بازنشانی پیشرفت'),
        content: const Text('آیا مطمئن هستید؟ تمام پیشرفت شما از بین می‌رود.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(workoutNotifierProvider.notifier).resetAllProgress();
              Navigator.of(ctx).pop();
            },
            child: const Text('بازنشانی'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 24, color: Colors.blueGrey),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayEditorCard extends StatelessWidget {
  final WorkoutDay day;
  final VoidCallback? onDelete;
  final void Function(String exerciseId)? onRemoveExercise;

  const _DayEditorCard({
    super.key,
    required this.day,
    this.onDelete,
    this.onRemoveExercise,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.drag_handle, color: Colors.grey.shade400),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${day.exercises.length} تمرین - ${day.totalSets} ست',
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade400),
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
          if (day.exercises.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: day.exercises.length,
              itemBuilder: (context, index) {
                final ex = day.exercises[index];
                return ListTile(
                  dense: true,
                  leading: Icon(
                    ex.isTimeBased ? Icons.timer : Icons.repeat,
                    size: 20,
                    color: Colors.grey,
                  ),
                  title: Text(ex.name),
                  subtitle: Text('${ex.sets} ست × ${ex.repsOrDuration}'),
                  trailing: onRemoveExercise != null
                      ? IconButton(
                          icon: Icon(
                            Icons.remove_circle_outline,
                            size: 20,
                            color: Colors.red.shade300,
                          ),
                          onPressed: () => onRemoveExercise!(ex.id),
                        )
                      : null,
                );
              },
            ),
        ],
      ),
    );
  }
}
