import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app_database.dart';

part 'sync_dao.g.dart';

enum SyncOperation { create, update, delete }

class SyncDao {
  final AppDatabase _db;

  SyncDao(this._db);

  Future<void> addToQueue({
    required String entityType,
    required String entityId,
    required SyncOperation operation,
  }) {
    return _db.into(_db.syncQueue).insert(
          SyncQueueCompanion(
            entityType: Value(entityType),
            entityId: Value(entityId),
            operation: Value(operation.name),
            createdAt: Value(DateTime.now()),
          ),
        );
  }

  Future<List<SyncQueueData>> getPendingQueue() {
    return (_db.select(_db.syncQueue)
          ..orderBy([(q) => OrderingTerm(expression: q.createdAt)]))
        .get();
  }

  Future<List<SyncQueueData>> getPendingByEntityType(String entityType) {
    return (_db.select(_db.syncQueue)
          ..where((q) => q.entityType.equals(entityType))
          ..orderBy([(q) => OrderingTerm(expression: q.createdAt)]))
        .get();
  }

  Future<void> removeFromQueue(int id) {
    return (_db.delete(_db.syncQueue)..where((q) => q.id.equals(id))).go();
  }

  Future<void> clearQueue() {
    return _db.delete(_db.syncQueue).go();
  }

  Future<int> getPendingCount() {
    return _db.select(_db.syncQueue).map((q) => q.id).get().then((r) => r.length);
  }

  Future<List<SyncQueueData>> getPendingForEntity(
      String entityType, String entityId) {
    return (_db.select(_db.syncQueue)
          ..where((q) =>
              q.entityType.equals(entityType) & q.entityId.equals(entityId))
          ..orderBy([(q) => OrderingTerm(expression: q.createdAt)]))
        .get();
  }
}

@Riverpod(keepAlive: true)
SyncDao syncDao(SyncDaoRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return SyncDao(db);
}
