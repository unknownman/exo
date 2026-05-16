import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/workout_plan.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/providers/workout_provider.dart';

class PlanEditorScreen extends ConsumerStatefulWidget {
  const PlanEditorScreen({super.key});

  @override
  ConsumerState<PlanEditorScreen> createState() => _PlanEditorScreenState();
}

class _PlanEditorScreenState extends ConsumerState<PlanEditorScreen> {
  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(workoutNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ویرایش برنامه'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDayDialog(context),
            tooltip: 'افزودن روز',
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPlanNameCard(plan),
              const SizedBox(height: 16),
              _buildStatsRow(plan),
              const SizedBox(height: 24),
              const Text(
                'روزهای تمرین',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...plan.days.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                return _DayCard(
                  key: ValueKey(day.id),
                  day: day,
                  dayNumber: index + 1,
                  onTap: () => _openDayDetail(day),
                  onDelete: plan.days.length > 1
                      ? () => _deleteDay(day.id)
                      : null,
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlanNameCard(WorkoutPlan plan) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.edit_note),
        title: Text(
          plan.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _showRenameDialog(plan.name),
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

  void _showRenameDialog(String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تغییر نام برنامه'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'نام برنامه',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(workoutNotifierProvider.notifier)
                    .updatePlanName(controller.text.trim());
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('ثبت'),
          ),
        ],
      ),
    );
  }

  void _showAddDayDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('افزودن روز جدید'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'نام روز',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(workoutNotifierProvider.notifier)
                    .addDay(controller.text.trim());
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('افزودن'),
          ),
        ],
      ),
    );
  }

  void _openDayDetail(WorkoutDay day) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DayDetailScreen(dayId: day.id)));
  }

  void _deleteDay(String dayId) {
    ref.read(workoutNotifierProvider.notifier).removeDay(dayId);
    _ensureValidDayIndex();
  }

  void _ensureValidDayIndex() {
    final state = ref.read(workoutNotifierProvider).valueOrNull;
    if (state == null || state.plan == null) return;

    final plan = state.plan!;
    if (state.currentDayIndex >= plan.days.length && plan.days.isNotEmpty) {
      ref
          .read(workoutNotifierProvider.notifier)
          .setCurrentDay(plan.days.last.id);
    }
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

class _DayCard extends StatelessWidget {
  final WorkoutDay day;
  final int dayNumber;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _DayCard({
    super.key,
    required this.day,
    required this.dayNumber,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
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
                    const SizedBox(height: 4),
                    Text(
                      '${day.exercises.length} تمرین - ${day.totalSets} ست - ${day.estimatedDurationMinutes} دقیقه',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  onPressed: () => _confirmDelete(context),
                ),
              const Icon(Icons.chevron_left, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف روز'),
        content: Text('آیا مطمئن هستید که "${day.name}" حذف شود؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete!();
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class DayDetailScreen extends ConsumerStatefulWidget {
  final String dayId;

  const DayDetailScreen({super.key, required this.dayId});

  @override
  ConsumerState<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends ConsumerState<DayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(workoutNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(_getDayName(stateAsync))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciseSheet(context),
        child: const Icon(Icons.add),
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطا: $e')),
        data: (state) {
          final day = state.getDayById(widget.dayId);
          if (day == null) {
            return const Center(child: Text('روز یافت نشد'));
          }

          if (day.exercises.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'هنوز تمرینی اضافه نشده',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddExerciseSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text('افزودن تمرین'),
                  ),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: day.exercises.length,
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) newIndex -= 1;
              final exercises = List<Exercise>.from(day.exercises);
              final ex = exercises.removeAt(oldIndex);
              exercises.insert(newIndex, ex);
              _updateDayExercises(day.id, exercises);
            },
            itemBuilder: (context, index) {
              final exercise = day.exercises[index];
              return _ExerciseCard(
                key: ValueKey(exercise.id),
                exercise: exercise,
                onDelete: () => _removeExercise(day.id, exercise.id),
              );
            },
          );
        },
      ),
    );
  }

  String _getDayName(AsyncValue<WorkoutPlanState> stateAsync) {
    return stateAsync.valueOrNull?.getDayById(widget.dayId)?.name ??
        'جزئیات روز';
  }

  void _showAddExerciseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AddExerciseSheet(dayId: widget.dayId),
    );
  }

  void _updateDayExercises(String dayId, List<Exercise> exercises) {
    final state = ref.read(workoutNotifierProvider).valueOrNull;
    if (state == null || state.plan == null) return;

    final updatedDays = state.plan!.days.map((d) {
      if (d.id == dayId) {
        return d.copyWith(exercises: exercises);
      }
      return d;
    }).toList();

    final updatedPlan = state.plan!.copyWith(days: updatedDays);
    ref.read(workoutNotifierProvider.notifier).updatePlanOrder(updatedPlan);
  }

  void _removeExercise(String dayId, String exerciseId) {
    ref
        .read(workoutNotifierProvider.notifier)
        .removeExercise(dayId, exerciseId);
  }
}

class _ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final VoidCallback onDelete;

  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          exercise.isTimeBased ? Icons.timer : Icons.repeat,
          color: Colors.blueGrey,
        ),
        title: Text(
          exercise.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${exercise.sets} ست × ${exercise.repsOrDuration} ${exercise.isTimeBased ? 'ثانیه' : 'تکرار'}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.drag_handle, color: Colors.grey),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddExerciseSheet extends ConsumerStatefulWidget {
  final String dayId;

  const _AddExerciseSheet({required this.dayId});

  @override
  ConsumerState<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<_AddExerciseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '12');
  final _restController = TextEditingController(text: '60');
  String _equipment = 'بدون تجهیزات';
  bool _isTimeBased = false;

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'افزودن تمرین',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'نام تمرین',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v?.trim().isEmpty == true ? 'نام تمرین الزامی است' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: const InputDecoration(
                        labelText: 'تعداد ست',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          int.tryParse(v ?? '') != null ? null : 'عدد معتبر',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: InputDecoration(
                        labelText: _isTimeBased ? 'ثانیه' : 'تکرار',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          int.tryParse(v ?? '') != null ? null : 'عدد معتبر',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _restController,
                decoration: const InputDecoration(
                  labelText: 'زمان استراحت (ثانیه)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _equipment,
                decoration: const InputDecoration(
                  labelText: 'تجهیزات',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'بدون تجهیزات',
                    child: Text('بدون تجهیزات'),
                  ),
                  DropdownMenuItem(value: 'دمبل', child: Text('دمبل')),
                  DropdownMenuItem(value: 'هالتر', child: Text('هالتر')),
                  DropdownMenuItem(value: 'دستگاه', child: Text('دستگاه')),
                  DropdownMenuItem(value: 'سیم‌کش', child: Text('سیم‌کش')),
                  DropdownMenuItem(value: 'کش ورزشی', child: Text('کش ورزشی')),
                ],
                onChanged: (v) =>
                    setState(() => _equipment = v ?? 'بدون تجهیزات'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: Text(_isTimeBased ? 'زمانی' : 'تکراری'),
                value: _isTimeBased,
                onChanged: (v) => setState(() => _isTimeBased = v),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('افزودن'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final exercise = Exercise(
      id: 'ex_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      sets: int.parse(_setsController.text),
      repsOrDuration: int.parse(_repsController.text),
      isTimeBased: _isTimeBased,
      restTime: int.parse(_restController.text),
      equipment: _equipment,
    );

    ref
        .read(workoutNotifierProvider.notifier)
        .addExercise(widget.dayId, exercise);
    Navigator.of(context).pop();
  }
}
