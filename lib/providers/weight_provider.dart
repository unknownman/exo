import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/body_weight_record.dart';
import '../core/utils/id_generator.dart';
import 'storage_providers.dart';

part 'weight_provider.g.dart';

@immutable
class WeightState {
  final List<BodyWeightRecord> records;
  final bool isLoading;

  const WeightState({
    this.records = const [],
    this.isLoading = false,
  });

  List<BodyWeightRecord> get sortedByDate =>
      List.from(records)..sort((a, b) => b.date.compareTo(a.date));

  WeightState copyWith({
    List<BodyWeightRecord>? records,
    bool? isLoading,
  }) {
    return WeightState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@Riverpod(keepAlive: true)
class WeightNotifier extends _$WeightNotifier {
  @override
  WeightState build() {
    final box = ref.read(appBoxProvider);
    final raw = box.get('body_weight_records', defaultValue: <Map>[]);
    final records = (raw as List).map((e) =>
      BodyWeightRecord.fromMap(Map<String, dynamic>.from(e as Map))
    ).toList();
    return WeightState(records: records);
  }

  Future<void> _save() async {
    final box = ref.read(appBoxProvider);
    final data = state.records.map((r) => r.toMap()).toList();
    await box.put('body_weight_records', data);
  }

  Future<void> addRecord(double weight, {String note = ''}) async {
    final record = BodyWeightRecord(
      id: IdGenerator.generate(),
      date: DateTime.now(),
      weight: weight,
      note: note,
    );
    state = state.copyWith(records: [...state.records, record]);
    await _save();
  }

  Future<void> deleteRecord(String id) async {
    state = state.copyWith(
      records: state.records.where((r) => r.id != id).toList(),
    );
    await _save();
  }

  Future<void> updateRecord(BodyWeightRecord updated) async {
    state = state.copyWith(
      records: state.records.map((r) => r.id == updated.id ? updated : r).toList(),
    );
    await _save();
  }
}
