import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exo/models/exercise.dart';
import 'package:exo/providers/workout_provider.dart';

class AddExerciseScreen extends StatefulWidget {
  const AddExerciseScreen({super.key});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _setsController = TextEditingController();
  final _repsOrDurationController = TextEditingController();
  final _restTimeController = TextEditingController();

  String _selectedEquipment = 'وزن بدن';
  bool _isTimeBased = false;
  int _selectedDayId = 1;

  static const List<String> _equipmentOptions = [
    'وزن بدن',
    'دمبل',
    'هالتر',
    'کش ورزشی',
    'دستگاه',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _setsController.dispose();
    _repsOrDurationController.dispose();
    _restTimeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final exercise = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      sets: int.parse(_setsController.text),
      repsOrDuration: int.parse(_repsOrDurationController.text),
      isTimeBased: _isTimeBased,
      restTime: int.parse(_restTimeController.text),
      equipment: _selectedEquipment,
    );

    context.read<WorkoutProvider>().addExercise(_selectedDayId, exercise);
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
                  decoration: const InputDecoration(
                    labelText: 'نام تمرین',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'نام تمرین را وارد کنید' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _selectedEquipment,
                  decoration: const InputDecoration(
                    labelText: 'تجهیزات',
                    border: OutlineInputBorder(),
                  ),
                  items: _equipmentOptions
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedEquipment = v);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _setsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'تعداد ست‌ها',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'تعداد ست‌ها را وارد کنید' : null,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(_isTimeBased ? 'زمانی' : 'تکراری'),
                  subtitle: Text(_isTimeBased
                      ? 'مدت زمان هر ست بر حسب ثانیه'
                      : 'تعداد تکرار در هر ست'),
                  value: _isTimeBased,
                  onChanged: (v) => setState(() => _isTimeBased = v),
                ),
                TextFormField(
                  controller: _repsOrDurationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        _isTimeBased ? 'زمان هر ست (ثانیه)' : 'تعداد تکرار (Reps)',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'این فیلد را وارد کنید'
                          : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _restTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'زمان استراحت (ثانیه)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'زمان استراحت را وارد کنید'
                          : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  initialValue: _selectedDayId,
                  decoration: const InputDecoration(
                    labelText: 'روز تمرینی',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('روز اول')),
                    DropdownMenuItem(value: 2, child: Text('روز دوم')),
                    DropdownMenuItem(value: 3, child: Text('روز سوم')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _selectedDayId = v);
                  },
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
