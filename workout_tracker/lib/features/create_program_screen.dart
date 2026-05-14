import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import '../core/extensions.dart';
import '../data/providers/workout_providers.dart';
import '../data/models/exercise.dart';
import '../data/models/exercise_type.dart';
import '../data/models/workout_day.dart';
import '../data/models/workout_program.dart';


class CreateEditProgramScreen extends ConsumerStatefulWidget {
  final String? programId;

  const CreateEditProgramScreen({super.key, this.programId});

  @override
  ConsumerState<CreateEditProgramScreen> createState() =>
      _CreateEditProgramScreenState();
}

class _DayFormData {
  final String id;
  final TextEditingController nameController;
  List<Exercise> exercises;

  _DayFormData({
    String? id,
    TextEditingController? nameController,
    List<Exercise>? exercises,
  })  : id = id ?? const Uuid().v4(),
        nameController = nameController ?? TextEditingController(),
        exercises = exercises ?? [];
}

class _CreateEditProgramScreenState
    extends ConsumerState<CreateEditProgramScreen> {
  final _formKey = GlobalKey<FormState>();
  final _programNameController = TextEditingController();
  final _days = <_DayFormData>[];
  bool _isLoading = false;
  bool _initialized = false;

  bool get _isEditMode => widget.programId != null;

  @override
  void dispose() {
    _programNameController.dispose();
    for (final d in _days) {
      d.nameController.dispose();
    }
    super.dispose();
  }

  void _initFromProgram(WorkoutProgram program) {
    if (_initialized) return;
    _initialized = true;
    _programNameController.text = program.name;
    for (final day in program.days) {
      final dayData = _DayFormData(
        id: day.id,
        nameController: TextEditingController(text: day.dayName),
        exercises: List.from(day.exercises),
      );
      _days.add(dayData);
    }
    setState(() {});
  }

  Future<void> _loadProgram() async {
    if (widget.programId == null) return;
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final program = await repo.getProgram(widget.programId!);
      if (program != null && mounted) {
        _initFromProgram(program);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addDay() {
    setState(() {
      _days.add(_DayFormData());
    });
  }

  void _removeDay(int index) {
    setState(() {
      _days[index].nameController.dispose();
      _days.removeAt(index);
    });
  }

  void _reorderDay(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _days.removeAt(oldIndex);
      _days.insert(newIndex, item);
    });
  }

  Future<void> _addExercise(int dayIndex) async {
    final exercise = await _showExerciseFormSheet(context);
    if (exercise != null) {
      setState(() {
        _days[dayIndex].exercises.add(exercise);
      });
    }
  }

  Future<void> _editExercise(int dayIndex, int exerciseIndex) async {
    final existing = _days[dayIndex].exercises[exerciseIndex];
    final exercise = await _showExerciseFormSheet(
      context,
      existing: existing,
    );
    if (exercise != null) {
      setState(() {
        _days[dayIndex].exercises[exerciseIndex] = exercise;
      });
    }
  }

  void _removeExercise(int dayIndex, int exerciseIndex) {
    setState(() {
      _days[dayIndex].exercises.removeAt(exerciseIndex);
    });
  }

  void _reorderExercise(int dayIndex, int oldIndex, int newIndex) {
    setState(() {
      final exercises = _days[dayIndex].exercises;
      if (newIndex > oldIndex) newIndex--;
      final item = exercises.removeAt(oldIndex);
      exercises.insert(newIndex, item);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_programNameController.text.trim().isEmpty) return;
    if (_days.any((d) => d.nameController.text.trim().isEmpty)) {
      _showSnackBar('لطفاً نام تمام روزها را وارد کنید');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(workoutRepositoryProvider);
      final days = _days.asMap().entries.map((entry) {
        final i = entry.key;
        final d = entry.value;
        return WorkoutDay(
          id: d.id,
          dayName: d.nameController.text.trim(),
          exercises: d.exercises,
          order: i,
        );
      }).toList();

      if (_isEditMode) {
        final existing = await repo.getProgram(widget.programId!);
        if (existing != null) {
          final updated = WorkoutProgram(
            id: existing.id,
            name: _programNameController.text.trim(),
            days: days,
            createdAt: existing.createdAt,
          );
          await repo.saveProgram(updated);
        }
      } else {
        await repo.createProgram(
          name: _programNameController.text.trim(),
          days: days,
        );
      }

      if (mounted) {
        ref.invalidate(programListProvider);
        _showSnackBar(
          _isEditMode ? 'برنامه با موفقیت ویرایش شد' : 'برنامه با موفقیت ساخته شد',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) _showSnackBar('خطا: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _loadProgram();
    } else {
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'ویرایش برنامه' : 'برنامه جدید'),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('ذخیره'),
            ),
          ],
        ),
        body: _isLoading && _days.isEmpty && _isEditMode
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TextFormField(
                      controller: _programNameController,
                      decoration: const InputDecoration(
                        labelText: 'نام برنامه',
                        hintText: 'مثال: برنامه حرفه ای',
                        prefixIcon: Icon(Icons.fitness_center),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'نام برنامه را وارد کنید' : null,
                    ),
                    const SizedBox(height: 24),
                    if (_days.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'روزهای تمرین',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: _days.length,
                      onReorder: _reorderDay,
                      itemBuilder: (context, index) {
                        final day = _days[index];
                        return _DayCard(
                          key: ValueKey(day.id),
                          dayData: day,
                          dayIndex: index,
                          onRemove: () => _removeDay(index),
                          onAddExercise: () => _addExercise(index),
                          onEditExercise: (exIndex) =>
                              _editExercise(index, exIndex),
                          onRemoveExercise: (exIndex) =>
                              _removeExercise(index, exIndex),
                          onReorderExercise: (oldI, newI) =>
                              _reorderExercise(index, oldI, newI),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _addDay,
                      icon: const Icon(Icons.add),
                      label: const Text('اضافه کردن روز'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _save,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isEditMode ? 'ویرایش برنامه' : 'ساخت برنامه'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final _DayFormData dayData;
  final int dayIndex;
  final VoidCallback onRemove;
  final VoidCallback onAddExercise;
  final void Function(int) onEditExercise;
  final void Function(int) onRemoveExercise;
  final void Function(int, int) onReorderExercise;

  const _DayCard({
    required Key key,
    required this.dayData,
    required this.dayIndex,
    required this.onRemove,
    required this.onAddExercise,
    required this.onEditExercise,
    required this.onRemoveExercise,
    required this.onReorderExercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReorderableDragStartListener(
                  index: dayIndex,
                  child: Icon(
                    Icons.drag_handle,
                    color: cs.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 14,
                  backgroundColor: cs.primaryContainer,
                  child: Text(
                    '${dayIndex + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: dayData.nameController,
                    decoration: const InputDecoration(
                      labelText: 'نام روز',
                      hintText: 'مثال: روز اول - سینه',
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'نام روز را وارد کنید' : null,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 18, color: cs.error),
                  onPressed: onRemove,
                  tooltip: 'حذف روز',
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (dayData.exercises.isNotEmpty)
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                itemCount: dayData.exercises.length,
                onReorder: onReorderExercise,
                itemBuilder: (context, exIndex) {
                  final exercise = dayData.exercises[exIndex];
                  return _ExerciseTile(
                    key: ValueKey(exercise.id),
                    exercise: exercise,
                    index: exIndex,
                    onEdit: () => onEditExercise(exIndex),
                    onRemove: () => onRemoveExercise(exIndex),
                  );
                },
              ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: onAddExercise,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('اضافه کردن تمرین'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final Exercise exercise;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _ExerciseTile({
    required Key key,
    required this.exercise,
    required this.index,
    required this.onEdit,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Icon(
              Icons.drag_handle,
              size: 18,
              color: cs.onSurface.withValues(alpha: 0.3),
            ),
          ),
          CircleAvatar(
            radius: 12,
            backgroundColor: cs.secondaryContainer,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: cs.onSecondaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onEdit,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _exerciseDetail(exercise),
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (exercise.imageUrl != null || exercise.videoUrl != null)
            Icon(
              exercise.videoUrl != null ? Icons.videocam : Icons.image,
              size: 16,
              color: cs.primary,
            ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(Icons.edit, size: 16, color: cs.primary),
            onPressed: onEdit,
            tooltip: 'ویرایش',
            visualDensity: VisualDensity.compact,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 16, color: cs.error),
            onPressed: onRemove,
            tooltip: 'حذف',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _exerciseDetail(Exercise e) {
    final parts = <String>[];
    parts.add('${e.sets} ست');
    if (e.type == ExerciseType.reps && e.reps != null) {
      parts.add('${e.reps} تکرار');
    } else if (e.type == ExerciseType.timed && e.durationSeconds != null) {
      final min = e.durationSeconds! ~/ 60;
      final sec = e.durationSeconds! % 60;
      if (min > 0) {
        parts.add('$min:${sec.toString().padLeft(2, '0')} دقیقه');
      } else {
        parts.add('$sec ثانیه');
      }
    }
    final restMin = e.restSeconds ~/ 60;
    final restSec = e.restSeconds % 60;
    if (restMin > 0) {
      parts.add('$restMin:${restSec.toString().padLeft(2, '0')} استراحت');
    } else {
      parts.add('$restSec ث استراحت');
    }
    if (e.equipment != null && e.equipment!.isNotEmpty) {
      parts.add(e.equipment!);
    }
    return parts.join(' • ');
  }
}

Future<Exercise?> _showExerciseFormSheet(
  BuildContext context, {
  Exercise? existing,
}) {
  return showModalBottomSheet<Exercise>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _ExerciseFormSheet(existing: existing),
  );
}

class _ExerciseFormSheet extends StatefulWidget {
  final Exercise? existing;

  const _ExerciseFormSheet({this.existing});

  @override
  State<_ExerciseFormSheet> createState() => _ExerciseFormSheetState();
}

class _ExerciseFormSheetState extends State<_ExerciseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController(text: '3');
  final _repsController = TextEditingController(text: '10');
  final _durationMinController = TextEditingController();
  final _durationSecController = TextEditingController(text: '30');
  final _restMinController = TextEditingController();
  final _restSecController = TextEditingController(text: '60');
  final _equipmentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();

  ExerciseType _type = ExerciseType.reps;


  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      final e = widget.existing!;
      _nameController.text = e.name;
      _type = e.type;
      _setsController.text = e.sets.toString();
      if (e.reps != null) _repsController.text = e.reps.toString();
      if (e.durationSeconds != null) {
        _durationMinController.text = (e.durationSeconds! ~/ 60).toString();
        _durationSecController.text = (e.durationSeconds! % 60).toString();
      }
      _restMinController.text = (e.restSeconds ~/ 60).toString();
      _restSecController.text = (e.restSeconds % 60).toString();
      if (e.equipment != null) _equipmentController.text = e.equipment!;
      if (e.imageUrl != null) _imageUrlController.text = e.imageUrl!;
      if (e.videoUrl != null) _videoUrlController.text = e.videoUrl!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _durationMinController.dispose();
    _durationSecController.dispose();
    _restMinController.dispose();
    _restSecController.dispose();
    _equipmentController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final sets = int.tryParse(_setsController.text) ?? 3;
    int? reps;
    int? durationSeconds;

    if (_type == ExerciseType.reps) {
      reps = int.tryParse(_repsController.text);
    } else {
      final min = int.tryParse(_durationMinController.text) ?? 0;
      final sec = int.tryParse(_durationSecController.text) ?? 0;
      durationSeconds = min * 60 + sec;
    }

    final restMin = int.tryParse(_restMinController.text) ?? 0;
    final restSec = int.tryParse(_restSecController.text) ?? 60;
    final restSeconds = restMin * 60 + restSec;

    final equipment = _equipmentController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final videoUrl = _videoUrlController.text.trim();

    final exercise = Exercise(
      id: widget.existing?.id ?? const Uuid().v4(),
      name: name,
      type: _type,
      sets: sets,
      reps: reps,
      durationSeconds: durationSeconds,
      restSeconds: restSeconds,
      equipment: equipment.isNotEmpty ? equipment : null,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      videoUrl: videoUrl.isNotEmpty ? videoUrl : null,
    );

    Navigator.of(context).pop(exercise);
  }

  void _previewImage() {
    final url = _imageUrlController.text.trim();
    if (url.isEmpty) return;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('پیش‌نمایش تصویر'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, _) => const Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (_, _, _) => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image, size: 48),
                      SizedBox(height: 8),
                      Text('خطا در بارگذاری تصویر'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previewVideo() {
    final url = _videoUrlController.text.trim();
    if (url.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _VideoPreviewScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.existing != null ? 'ویرایش تمرین' : 'تمرین جدید',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'نام تمرین',
                  hintText: 'مثال: پرس سینه هالتر',
                  prefixIcon: Icon(Icons.fitness_center),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'نام تمرین را وارد کنید' : null,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              Text(
                'نوع تمرین',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<ExerciseType>(
                segments: const [
                  ButtonSegment(
                    value: ExerciseType.reps,
                    label: Text('ست و تکرار'),
                    icon: Icon(Icons.repeat),
                  ),
                  ButtonSegment(
                    value: ExerciseType.timed,
                    label: Text('تایمر'),
                    icon: Icon(Icons.timer),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (v) => setState(() => _type = v.first),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _setsController,
                      decoration: const InputDecoration(
                        labelText: 'تعداد ست',
                        prefixIcon: Icon(Icons.layers),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          (v == null || int.tryParse(v) == null || int.parse(v) <= 0)
                              ? 'مقدار معتبر'
                              : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _type == ExerciseType.reps
                        ? TextFormField(
                            controller: _repsController,
                            decoration: const InputDecoration(
                              labelText: 'تعداد تکرار',
                              prefixIcon: Icon(Icons.repeat),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) =>
                                (v == null || int.tryParse(v) == null || int.parse(v) <= 0)
                                    ? 'مقدار معتبر'
                                    : null,
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _durationMinController,
                                  decoration: const InputDecoration(
                                    labelText: 'دقیقه',
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Text(':'),
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _durationSecController,
                                  decoration: const InputDecoration(
                                    labelText: 'ثانیه',
                                    isDense: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (v) {
                                    final min = int.tryParse(_durationMinController.text) ?? 0;
                                    final sec = int.tryParse(v ?? '') ?? 0;
                                    return (min == 0 && sec == 0) ? 'مدت زمان را وارد کنید' : null;
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'زمان استراحت',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _restMinController,
                      decoration: const InputDecoration(
                        labelText: 'دقیقه',
                        prefixIcon: Icon(Icons.timer_outlined),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(':'),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _restSecController,
                      decoration: const InputDecoration(
                        labelText: 'ثانیه',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final min = int.tryParse(_restMinController.text) ?? 0;
                        final sec = int.tryParse(v ?? '') ?? 0;
                        return (min == 0 && sec == 0) ? 'زمان استراحت را وارد کنید' : null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _equipmentController,
                decoration: const InputDecoration(
                  labelText: 'تجهیزات (اختیاری)',
                  hintText: 'مثال: هالتر، دمبل، نیمکت',
                  prefixIcon: Icon(Icons.handyman),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'آدرس تصویر (اختیاری)',
                  hintText: 'https://example.com/image.jpg',
                  prefixIcon: const Icon(Icons.image),
                  suffixIcon: _imageUrlController.text.trim().isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.preview),
                          onPressed: _previewImage,
                          tooltip: 'پیش‌نمایش',
                        )
                      : null,
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _videoUrlController,
                decoration: InputDecoration(
                  labelText: 'آدرس ویدیو (اختیاری)',
                  hintText: 'https://example.com/video.mp4',
                  prefixIcon: const Icon(Icons.videocam),
                  suffixIcon: _videoUrlController.text.trim().isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.preview),
                          onPressed: _previewVideo,
                          tooltip: 'پیش‌نمایش',
                        )
                      : null,
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: Icon(
                  widget.existing != null ? Icons.check : Icons.add,
                ),
                label: Text(
                  widget.existing != null ? 'تایید ویرایش' : 'اضافه کردن تمرین',
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoPreviewScreen extends StatefulWidget {
  final String url;

  const _VideoPreviewScreen({required this.url});

  @override
  State<_VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<_VideoPreviewScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _videoController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    );
    await _videoController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoController!.value.aspectRatio,
      placeholder: const Center(child: CircularProgressIndicator()),
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('پیش‌نمایش ویدیو'),
      ),
      body: _chewieController != null && _videoController != null
          ? Center(
              child: Chewie(controller: _chewieController!),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
