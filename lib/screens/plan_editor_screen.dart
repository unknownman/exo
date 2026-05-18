import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/workout_plan.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/models/exercise_media.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/providers/media_provider.dart';
import 'package:exo/widgets/exercise_media_widget.dart';
import 'package:exo/core/constants/app_strings.dart';
import 'package:exo/core/utils/persian_digits.dart';
import 'package:exo/core/utils/id_generator.dart';

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
        title: const Text(AppStrings.editPlan),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDayDialog(context),
            tooltip: AppStrings.addDay,
          ),
        ],
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${AppStrings.errorWithMessage}$e')),
        data: (state) {
          final plan = state.plan;
          if (plan == null) {
            return const Center(child: Text(AppStrings.noPlan));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPlanNameCard(plan),
              const SizedBox(height: 16),
              _buildStatsRow(plan),
              const SizedBox(height: 24),
              const Text(
                AppStrings.workoutDays,
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
          label: AppStrings.days,
          value: plan.days.length.toPersian(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.fitness_center,
          label: AppStrings.exercises,
          value: plan.totalExercises.toPersian(),
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.timer,
          label: AppStrings.duration,
          value: '${plan.totalDurationMinutes.toPersian()} ${AppStrings.minutes}',
        ),
      ],
    );
  }

  void _showRenameDialog(String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.renamePlan),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: AppStrings.planNameInput,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.dismiss),
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
            child: const Text(AppStrings.confirm),
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
        title: const Text(AppStrings.addNewDay),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: AppStrings.dayNameInput,
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
                child: const Text(AppStrings.add),
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
                    dayNumber.toPersian(),
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
                      '${day.exercises.length.toPersian()} ${AppStrings.exercises} - ${day.totalSets.toPersian()} ${AppStrings.set} - ${day.estimatedDurationMinutes.toPersian()} ${AppStrings.minutes}',
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
        title: const Text(AppStrings.deleteDay),
        content: Text(AppStrings.confirmDeleteDay.replaceFirst('%s', day.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(AppStrings.dismiss),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete!();
            },
            child: const Text(AppStrings.delete),
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
        error: (e, _) => Center(child: Text('${AppStrings.errorWithMessage}$e')),
        data: (state) {
          final day = state.getDayById(widget.dayId);
          if (day == null) {
            return const Center(child: Text(AppStrings.dayDetails));
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
                    AppStrings.noExercisesAdded,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showAddExerciseSheet(context),
                    icon: const Icon(Icons.add),
                    label: const Text(AppStrings.addExercise),
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
                onTap: () => _editExercise(exercise),
              );
            },
          );
        },
      ),
    );
  }

  String _getDayName(AsyncValue<WorkoutPlanState> stateAsync) {
    return stateAsync.valueOrNull?.getDayById(widget.dayId)?.name ??
        AppStrings.dayDetails;
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

  void _editExercise(Exercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _AddExerciseSheet(
        dayId: widget.dayId,
        existingExercise: exercise,
      ),
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
  final VoidCallback onTap;

  const _ExerciseCard({
    super.key,
    required this.exercise,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
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
            '${exercise.sets.toPersian()} ${AppStrings.set} × ${exercise.repsOrDuration.toPersian()} ${exercise.isTimeBased ? AppStrings.second : AppStrings.rep}',
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
      ),
    );
  }
}

class _AddExerciseSheet extends ConsumerStatefulWidget {
  final String dayId;
  final Exercise? existingExercise;

  const _AddExerciseSheet({
    required this.dayId,
    this.existingExercise,
  });

  @override
  ConsumerState<_AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends ConsumerState<_AddExerciseSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coachCuesController = TextEditingController();
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '12');
  final _restController = TextEditingController(text: '60');
  String _equipment = AppStrings.noEquipment;
  bool _isTimeBased = false;
  ExerciseMedia? _selectedMedia;
  bool get _isEditing => widget.existingExercise != null;

  @override
  void initState() {
    super.initState();
    final ex = widget.existingExercise;
    if (ex != null) {
      _nameController.text = ex.name;
      _descriptionController.text = ex.description;
      _coachCuesController.text = ex.coachCues;
      _setsController.text = ex.sets.toString();
      _repsController.text = ex.repsOrDuration.toString();
      _restController.text = ex.restTime.toString();
      _equipment = ex.equipment;
      _isTimeBased = ex.isTimeBased;
      if (ex.media.type != ExerciseMediaType.none) {
        _selectedMedia = ex.media;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _coachCuesController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final path = await ref.read(mediaRepositoryProvider).pickAndSaveMedia();
    if (path == null || !mounted) return;
    setState(() {
      _selectedMedia = ExerciseMedia.local(path);
    });
  }

  void _clearMedia() {
    setState(() {
      _selectedMedia = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEditing ? 'ویرایش تمرین' : AppStrings.addExercise;

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
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: AppStrings.exerciseNameInput,
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v?.trim().isEmpty == true ? AppStrings.exerciseNameRequired : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: AppStrings.exerciseDescription,
                  hintText: AppStrings.exerciseDescriptionHint,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _coachCuesController,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: AppStrings.coachCues,
                  hintText: AppStrings.coachCuesHint,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 12),
              _buildMediaSection(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: const InputDecoration(
                        labelText: AppStrings.numberOfSets,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          int.tryParse(v ?? '') != null ? null : AppStrings.validNumber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _repsController,
                      decoration: InputDecoration(
                        labelText: _isTimeBased ? AppStrings.second : AppStrings.rep,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          int.tryParse(v ?? '') != null ? null : AppStrings.validNumber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _restController,
                decoration: const InputDecoration(
                  labelText: AppStrings.restTimeSeconds,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _equipment,
                decoration: const InputDecoration(
                  labelText: AppStrings.equipment,
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: AppStrings.noEquipment,
                    child: Text(AppStrings.noEquipment),
                  ),
                  DropdownMenuItem(value: 'دمبل', child: Text('دمبل')),
                  DropdownMenuItem(value: 'هالتر', child: Text('هالتر')),
                  DropdownMenuItem(value: 'دستگاه', child: Text('دستگاه')),
                  DropdownMenuItem(value: 'سیم‌کش', child: Text('سیم‌کش')),
                  DropdownMenuItem(value: 'کش ورزشی', child: Text('کش ورزشی')),
                ],
                onChanged: (v) =>
                    setState(() => _equipment = v ?? AppStrings.noEquipment),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: Text(_isTimeBased ? AppStrings.timed : AppStrings.repBased),
                value: _isTimeBased,
                onChanged: (v) => setState(() => _isTimeBased = v),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isEditing ? 'ذخیره تغییرات' : AppStrings.add),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_selectedMedia != null) ...[
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 140,
                  color: Colors.grey.shade100,
                  child: ExerciseMediaWidget(
                    media: _selectedMedia!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 140,
                  ),
                ),
              ),
              IconButton(
                onPressed: _clearMedia,
                icon: const Icon(Icons.close, color: Colors.red),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withAlpha(200),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        OutlinedButton.icon(
          onPressed: _pickMedia,
          icon: const Icon(Icons.attach_file),
          label: Text(
            _selectedMedia != null ? AppStrings.changeFile : AppStrings.selectFile,
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ex = widget.existingExercise;
    final exercise = Exercise(
      id: ex?.id ?? IdGenerator.generate(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      coachCues: _coachCuesController.text.trim(),
      sets: int.parse(_setsController.text),
      repsOrDuration: int.parse(_repsController.text),
      isTimeBased: _isTimeBased,
      restTime: int.parse(_restController.text),
      equipment: _equipment,
      media: _selectedMedia ?? const ExerciseMedia.empty(),
    );

    if (_isEditing) {
      await ref
          .read(workoutNotifierProvider.notifier)
          .updateExercise(widget.dayId, ex!.id, exercise);
    } else {
      await ref
          .read(workoutNotifierProvider.notifier)
          .addExercise(widget.dayId, exercise);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
