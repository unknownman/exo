import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/core/constants/app_strings.dart';

class CreatePlanScreen extends ConsumerStatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  ConsumerState<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

const _ordinals = ['اول', 'دوم', 'سوم', 'چهارم', 'پنجم', 'ششم', 'هفتم'];

class _CreatePlanScreenState extends ConsumerState<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _planNameController = TextEditingController();
  final List<String> _dayNames = [];

  @override
  void initState() {
    super.initState();
    _dayNames.addAll(['روز اول', 'روز دوم', 'روز سوم']);
  }

  @override
  void dispose() {
    _planNameController.dispose();
    super.dispose();
  }

  void _reindexNames() {
    for (int i = 0; i < _dayNames.length; i++) {
      final ordinal = i < _ordinals.length ? _ordinals[i] : '${i + 1}';
      _dayNames[i] = 'روز $ordinal';
    }
  }

  void _addDay() {
    setState(() {
      final index = _dayNames.length;
      final ordinal = index < _ordinals.length ? _ordinals[index] : '${index + 1}';
      _dayNames.add('روز $ordinal');
    });
  }

  void _removeDay(int index) {
    if (_dayNames.length > 1) {
      setState(() {
        _dayNames.removeAt(index);
        _reindexNames();
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(workoutNotifierProvider.notifier);
    await notifier.createPlan(
      _planNameController.text.trim(),
      dayNames: _dayNames,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.createNewPlan)),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _planNameController,
                  decoration: const InputDecoration(
                    labelText: 'نام برنامه',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? AppStrings.planNameRequired
                      : null,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.workoutDays,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addDay,
                      icon: const Icon(Icons.add),
                      label: const Text(AppStrings.addDay),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(_dayNames.length, (index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          index < _ordinals.length ? _ordinals[index] : '${index + 1}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      title: Text(_dayNames[index]),
                      trailing: _dayNames.length > 1
                          ? IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeDay(index),
                            )
                          : null,
                    ),
                  );
                }),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(AppStrings.createPlan),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
