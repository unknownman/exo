import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/models/exercise_media.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/providers/media_provider.dart';
import 'package:exo/core/constants/app_constants.dart';
import 'package:exo/widgets/exercise_media_widget.dart';
import 'package:exo/core/constants/app_strings.dart';
import 'package:exo/core/utils/id_generator.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _coachCuesController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsOrDurationController = TextEditingController();
  final _restTimeController = TextEditingController();

  bool _isTimeBased = false;
  String? _selectedEquipment;
  String? _selectedDayId;
  ExerciseMedia? _selectedMedia;

  @override
  void initState() {
    super.initState();
    _setsController.text = AppConstants.defaultSets.toString();
    _restTimeController.text = AppConstants.defaultRest.toString();
    _repsOrDurationController.text = AppConstants.defaultReps.toString();
    _selectedEquipment = AppConstants.equipmentTypes.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _coachCuesController.dispose();
    _setsController.dispose();
    _repsOrDurationController.dispose();
    _restTimeController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired.replaceFirst('%s', fieldName);
    }
    return null;
  }

  String? _validatePositiveInt(String? value, String fieldName) {
    final emptyError = _validateNotEmpty(value, fieldName);
    if (emptyError != null) return emptyError;

    final number = int.tryParse(value!.trim());
    if (number == null) {
      return AppStrings.enterValidNumber;
    }
    if (number <= 0) {
      return AppStrings.enterPositiveNumber;
    }
    return null;
  }

  String? _validateRestTime(String? value) {
    final error = _validatePositiveInt(value, AppStrings.restTime);
    if (error != null) return error;

    final number = int.parse(value!.trim());
    if (number < 5 || number > 300) {
      return AppStrings.restTimeRangeError;
    }
    return null;
  }

  String? _validateSets(String? value) {
    final error = _validatePositiveInt(value, AppStrings.numberOfSets);
    if (error != null) return error;

    final number = int.parse(value!.trim());
    if (number > 20) {
      return AppStrings.setsCountError;
    }
    return null;
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDayId == null || _selectedEquipment == null) return;

    final sets = int.tryParse(_setsController.text) ?? AppConstants.defaultSets;
    final repsOrDuration =
        int.tryParse(_repsOrDurationController.text) ??
        (_isTimeBased
            ? AppConstants.defaultDuration
            : AppConstants.defaultReps);
    final restTime =
        int.tryParse(_restTimeController.text) ?? AppConstants.defaultRest;

    final exercise = Exercise(
      id: IdGenerator.generate(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      coachCues: _coachCuesController.text.trim(),
      sets: sets,
      repsOrDuration: repsOrDuration,
      isTimeBased: _isTimeBased,
      restTime: restTime,
      equipment: _selectedEquipment!,
      media: _selectedMedia ?? const ExerciseMedia.empty(),
    );

    await ref
        .read(workoutNotifierProvider.notifier)
        .addExercise(_selectedDayId!, exercise);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(workoutNotifierProvider);

    return stateAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('${AppStrings.errorWithMessage}$e'))),
      data: (WorkoutPlanState state) {
        final plan = state.plan;
        if (plan == null || plan.days.isEmpty) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.noPlan)),
          );
        }

        final unlockedDays = plan.days.where((d) => d.isUnlocked).toList();
        if (unlockedDays.isEmpty) {
          return const Scaffold(
            body: Center(child: Text(AppStrings.noActiveDays)),
          );
        }

        String effectiveDayId;
        if (_selectedDayId != null &&
            unlockedDays.any((d) => d.id == _selectedDayId)) {
          effectiveDayId = _selectedDayId!;
        } else if (state.currentDay?.id != null &&
            unlockedDays.any((d) => d.id == state.currentDay!.id)) {
          effectiveDayId = state.currentDay!.id;
        } else {
          effectiveDayId = unlockedDays.first.id;
        }
        _selectedDayId ??= effectiveDayId;

        final dayOptions = unlockedDays
            .map(
              (d) => DropdownMenuItem(
                value: d.id,
                child: Text(d.name, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList();

        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.addExercise)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: AppStrings.exerciseNameInput,
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) => _validateNotEmpty(v, AppStrings.exerciseNameInput),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    _buildMediaSection(),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedEquipment,
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
                        if (v != null) setState(() => _selectedEquipment = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: effectiveDayId,
                      decoration: const InputDecoration(
                        labelText: AppStrings.workoutDay,
                        border: OutlineInputBorder(),
                      ),
                      isExpanded: true,
                      items: dayOptions,
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedDayId = v);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _setsController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: AppStrings.numberOfSets,
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateSets,
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(_isTimeBased ? AppStrings.timed : AppStrings.repBased),
                      subtitle: Text(
                        _isTimeBased
                            ? AppStrings.timedSubtitle
                            : AppStrings.repsSubtitle,
                      ),
                      value: _isTimeBased,
                      onChanged: (v) {
                        setState(() {
                          _isTimeBased = v;
                          _repsOrDurationController.text = v
                              ? AppConstants.defaultDuration.toString()
                              : AppConstants.defaultReps.toString();
                        });
                      },
                    ),
                    TextFormField(
                      controller: _repsOrDurationController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: _isTimeBased
                            ? AppStrings.timePerSet
                            : AppStrings.repsCount,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => _validatePositiveInt(v, AppStrings.fieldLabel),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _restTimeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: AppStrings.restTimeSeconds,
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateRestTime,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(AppStrings.saveExercise),
                    ),
                  ],
              ),
            ),
          ),
        );
      },
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
                  height: 160,
                  color: Colors.grey.shade100,
                  child: ExerciseMediaWidget(
                    media: _selectedMedia!,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 160,
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
          const SizedBox(height: 12),
        ],
        OutlinedButton.icon(
          onPressed: _pickMedia,
          icon: const Icon(Icons.attach_file),
          label: Text(
            _selectedMedia != null ? AppStrings.changeFile : AppStrings.selectFile,
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
