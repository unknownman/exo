import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/core/constants/app_constants.dart';

class AddExerciseScreen extends ConsumerStatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  ConsumerState<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends ConsumerState<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsOrDurationController = TextEditingController();
  final _restTimeController = TextEditingController();
  final _imagePathController = TextEditingController();

  bool _isTimeBased = false;

  @override
  void initState() {
    super.initState();
    _setsController.text = AppConstants.defaultSets.toString();
    _restTimeController.text = AppConstants.defaultRest.toString();
    if (_isTimeBased) {
      _repsOrDurationController.text = AppConstants.defaultDuration.toString();
    } else {
      _repsOrDurationController.text = AppConstants.defaultReps.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsOrDurationController.dispose();
    _restTimeController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName را وارد کنید';
    }
    return null;
  }

  String? _validatePositiveInt(String? value, String fieldName) {
    final emptyError = _validateNotEmpty(value, fieldName);
    if (emptyError != null) return emptyError;

    final number = int.tryParse(value!.trim());
    if (number == null) {
      return 'عدد معتبر وارد کنید';
    }
    if (number <= 0) {
      return 'عدد مثبت وارد کنید';
    }
    return null;
  }

  String? _validateRestTime(String? value) {
    final error = _validatePositiveInt(value, 'زمان استراحت');
    if (error != null) return error;

    final number = int.parse(value!.trim());
    if (number < 5 || number > 300) {
      return 'زمان استراحت باید بین ۵ تا ۳۰۰ ثانیه باشد';
    }
    return null;
  }

  String? _validateSets(String? value) {
    final error = _validatePositiveInt(value, 'تعداد ست‌ها');
    if (error != null) return error;

    final number = int.parse(value!.trim());
    if (number > 20) {
      return 'تعداد ست نباید بیشتر از ۲۰ باشد';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final sets = int.tryParse(_setsController.text) ?? AppConstants.defaultSets;
    final repsOrDuration =
        int.tryParse(_repsOrDurationController.text) ??
        (_isTimeBased
            ? AppConstants.defaultDuration
            : AppConstants.defaultReps);
    final restTime =
        int.tryParse(_restTimeController.text) ?? AppConstants.defaultRest;

    final exercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      sets: sets,
      repsOrDuration: repsOrDuration,
      isTimeBased: _isTimeBased,
      restTime: restTime,
      equipment: AppConstants.equipmentTypes.first,
      imagePath: _imagePathController.text.trim().isEmpty
          ? null
          : _imagePathController.text.trim(),
    );

    ref.read(workoutNotifierProvider.notifier).addExercise(1, exercise);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('افزودن تمرین')),
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
                    labelText: 'نام تمرین',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _validateNotEmpty(v, 'نام تمرین'),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: AppConstants.equipmentTypes.first,
                  decoration: const InputDecoration(
                    labelText: 'تجهیزات',
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
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _imagePathController,
                  decoration: const InputDecoration(
                    labelText: 'آدرس تصویر (اختیاری)',
                    hintText: 'https://example.com/image.png',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _setsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'تعداد ست‌ها',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateSets,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(_isTimeBased ? 'زمانی' : 'تکراری'),
                  subtitle: Text(
                    _isTimeBased
                        ? 'مدت زمان هر ست بر حسب ثانیه'
                        : 'تعداد تکرار در هر ست',
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
                        ? 'زمان هر ست (ثانیه)'
                        : 'تعداد تکرار',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => _validatePositiveInt(v, 'این فیلد'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _restTimeController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'زمان استراحت (ثانیه)',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateRestTime,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: 1,
                  decoration: const InputDecoration(
                    labelText: 'روز تمرینی',
                    border: OutlineInputBorder(),
                  ),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(
                      value: 1,
                      child: Text('روز اول', overflow: TextOverflow.ellipsis),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('روز دوم', overflow: TextOverflow.ellipsis),
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text('روز سوم', overflow: TextOverflow.ellipsis),
                    ),
                  ],
                  onChanged: (_) {},
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('ثبت تمرین'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
