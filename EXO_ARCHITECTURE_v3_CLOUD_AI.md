# EXO — Architecture Design Document: Cloud Integration & AI Recommendation

> **Phase**: 3 (Planning)  
> **Version**: 3.0  
> **Status**: Draft for Review  
> **Ecosystem**: Flutter 3.41+ / Riverpod 2.x / Hive 5 / GoRouter 17  

---

## Table of Contents

1. [Sync Strategy & Data Flow](#1-sync-strategy--data-flow)
2. [API Contract Blueprint](#2-api-contract-blueprint)
3. [Repository Interface Evolution](#3-repository-interface-evolution)
4. [Recommendation Engine Data Flow](#4-recommendation-engine-data-flow)
5. [Tech Stack Recommendations](#5-tech-stack-recommendations)
6. [Risk Mitigation](#6-risk-mitigation)
7. [Implementation Roadmap](#7-implementation-roadmap)

---

## 1. Sync Strategy & Data Flow

### 1.1 Core Principle: Local-First

The app **never** waits for the network to render UI. Every user action writes to Hive first, then syncs to the server in the background. Reads always come from Hive — the remote API is a write-through replication target and a read-source-of-truth only when the local cache is empty (e.g., first launch).

```
User Action
    │
    ▼
┌──────────────────────┐     ┌──────────────────────┐
│  1. Write to Hive    │────►│  2. Queue Sync Job   │
│     (immediate)      │     │     (fire & forget)  │
└──────────────────────┘     └──────────┬───────────┘
                                        │
                                        ▼
                               ┌──────────────────────┐
                               │  3. API Call         │
                               │     (retry on fail)  │
                               └──────────────────────┘
```

### 1.2 Three Sync Categories

| Category           | Direction     | Frequency      | Staleness Tolerance | Blocking? |
| ------------------ | ------------- | -------------- | ------------------- | --------- |
| **Exercise Bank**  | Server → Local | On app start + periodic | Low (exercise defs rarely change) | ❌ Never |
| **Workout Logs**   | Local → Server | On completion + periodic | Medium (sync queue)                | ❌ Never |
| **Recommendations**| Server → Local | On-demand      | Low (user expects fresh results)   | ✅ User-facing button waits |
| **Physical Stats** | Local → Server | On update      | High (can batch)                   | ❌ Never |

### 1.3 Exercise Bank Sync Flow

```
App Cold Start
    │
    ▼
┌──────────────────────┐   NO   ┌──────────────────────┐
│  Exercise Bank       │────────►│  Show cached bank    │
│  in Hive?            │         │  (immediate)         │
└──────┬───────────────┘         └──────────────────────┘
       │ YES
       ▼
┌──────────────────────┐
│  Show cached bank    │  ← UI renders immediately
│  (immediate)         │
└──────┬───────────────┘
       │
       ▼ (background)
┌──────────────────────┐
│  GET /api/exercises/ │
│  sync?lastUpdated=   │
│         T1           │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────────────────────┐
│  Server returns {updates, deletes,   │
│  serverTimestamp}                    │
└──────┬───────────────────────────────┘
       │
       ▼
┌──────────────────────┐
│  Apply patches to    │
│  local Hive          │
│  (no UI rebuild)     │
└──────────────────────┘
```

**Key decisions:**
- The server sends **diffs** (not full dump) based on `lastUpdated` timestamp.
- Diffs are applied silently to Hive; the Riverpod provider invalidates only if the user is actively viewing the exercise list or form.
- If the server is unreachable, the cached bank is used indefinitely.

### 1.4 Sync Queue Architecture

Workout logs and physical stats are written to Hive immediately, then a **sync queue** (backed by a dedicated Hive box) processes them in FIFO order.

```
┌──────────────┐    ┌─────────────────┐    ┌──────────────────┐
│  Write to    │───►│  Add to Sync    │───►│  Process Queue   │
│  Hive        │    │  Queue (Hive)   │    │  (background)    │
└──────────────┘    └─────────────────┘    └────────┬─────────┘
                                                    │
                                           ┌────────▼────────┐
                                           │  Success →       │
                                           │  Remove from Q   │
                                           │  Failure → Retry │
                                           │  (max 3, exp.)   │
                                           └─────────────────┘
```

**Queue triggers:**
- Immediate: on workout completion, on physical stats update.
- Periodic: `WorkManager` / `android_alarm_manager` (Android), `BGTaskScheduler` (iOS) every ~15 minutes.
- On reconnect: when connectivity status changes from offline → online.

### 1.5 Conflict Resolution

| Conflict Type              | Strategy                           |
| -------------------------- | ---------------------------------- |
| Exercise Bank (Server→Local) | Server wins (authoritative)       |
| Workout Logs (Local→Server) | Client wins (append-only, no conflict) |
| Recommendations            | N/A (server computes fresh each request) |
| Physical Stats             | Last-write-wins by `updatedAt` timestamp |

---

## 2. API Contract Blueprint

### 2.1 Authentication (`/api/auth`)

**`POST /api/auth/register`**
```json
{
  "deviceId": "uuid-v4",
  "locale": "fa-IR",
  "platform": "android | ios",
  "appVersion": "1.0.0+1"
}
```

**Response:**
```json
{
  "userId": "uuid-v4",
  "token": "jwt-or-api-key",
  "tokenExpiresAt": "ISO-8601"
}
```

**`POST /api/auth/refresh`**
```json
{
  "token": "current-jwt"
}
```

**Response:**
```json
{
  "token": "new-jwt",
  "tokenExpiresAt": "ISO-8601"
}
```

### 2.2 Exercise Bank Sync (`/api/exercises`)

**`POST /api/exercises/sync`**
```json
{
  "userId": "uuid-v4",
  "lastSyncTimestamp": "ISO-8601 | null"
}
```

**Response:**
```json
{
  "serverTimestamp": "ISO-8601",
  "updates": [
    {
      "id": "uuid-v4",
      "name": "Push Up",
      "nameFa": "شنا سوئدی",
      "description": "Standard push-up with full range of motion",
      "descriptionFa": "شنا رفتن با دامنه کامل حرکت",
      "equipmentType": "bodyweight",
      "targetMuscles": ["chest", "triceps", "shoulders"],
      "difficulty": "beginner | intermediate | advanced",
      "media": {
        "type": "video | image | lottie",
        "url": "https://cdn.exo.app/exercises/push-up.mp4"
      },
      "version": 3
    }
  ],
  "deletes": ["uuid-of-removed-exercise"]
}
```

**Design notes:**
- `equipmentType` uses fixed enum values (`bodyweight`, `dumbbell`, `barbell`, `cable`, `machine`, `pullup_bar`, `resistance_band`) rather than the current Persian string keys, with a localization map on the server to serve `nameFa`.
- The client merges `updates` by `id` and removes any `id` in `deletes`.
- `version` field enables the client to skip re-processing identical records.
- The response is **delta-only**: empty `updates`/`deletes` if nothing changed since `lastSyncTimestamp`.

### 2.3 Workout Log Upload (`/api/workouts`)

**`POST /api/workouts/log`**
```json
{
  "userId": "uuid-v4",
  "logs": [
    {
      "clientId": "uuid-v4",
      "dayId": "uuid-v4",
      "dayName": "Push Day",
      "completedAt": "ISO-8601",
      "totalDurationMinutes": 45,
      "exercises": [
        {
          "exerciseId": "uuid-v4",
          "exerciseName": "Bench Press",
          "sets": [
            {
              "setNumber": 1,
              "weight": 80.0,
              "reps": 10,
              "isCompleted": true,
              "rpe": 8,
              "restTimeSeconds": 90
            }
          ]
        }
      ]
    }
  ]
}
```

**Response:**
```json
{
  "accepted": 3,
  "rejected": 0,
  "serverTimestamps": ["ISO-8601"]
}
```

**Design notes:**
- `clientId` is generated locally before the log is ever written to Hive, ensuring idempotent retries (server deduplicates by `clientId`).
- The server returns `serverTimestamps` in order; the client stores this alongside the local log for future conflict resolution.
- Batch upload (up to 10 logs per request) to reduce connection overhead.

### 2.4 AI Recommendation (`/api/recommendations`)

**`POST /api/recommendations/generate`**
```json
{
  "userId": "uuid-v4",
  "goal": "strength | hypertrophy | endurance | general",
  "experienceLevel": "beginner | intermediate | advanced",
  "availableEquipment": ["dumbbell", "barbell", "bodyweight"],
  "daysPerWeek": 4,
  "sessionDurationMinutes": 60,
  "recentLogs": [
    {
      "dayId": "uuid-v4",
      "dayName": "Push Day",
      "completedAt": "ISO-8601",
      "exercises": [
        {
          "exerciseId": "uuid-v4",
          "exerciseName": "Bench Press",
          "sets": [
            {
              "setNumber": 1,
              "weight": 80,
              "reps": 10,
              "isCompleted": true
            }
          ]
        }
      ],
      "totalSetsCompleted": 12
    }
  ],
  "bestLifts": [
    {
      "exerciseId": "uuid-v4",
      "exerciseName": "Bench Press",
      "best1RM": 95.5,
      "bestWeight": 80,
      "bestReps": 10,
      "date": "ISO-8601"
    }
  ],
  "physicalProfile": {
    "age": 28,
    "gender": "male | female",
    "heightCm": 178,
    "currentWeightKg": 82,
    "bodyFatPercentage": null
  },
  "injuriesOrLimitations": ["lower_back", "left_shoulder"]
}
```

**Response:**
```json
{
  "recommendationId": "uuid-v4",
  "plan": {
    "name": "Intermediate Push/Pull/Legs",
    "nameFa": "برنامه intermediate پوش/پول/پا",
    "description": "A 4-day upper/lower split focused on hypertrophy",
    "descriptionFa": "برنامه ۴ روزه بالاتنه/پایین‌تنه با تمرکز بر هایپرتروفی",
    "estimatedWeeklyVolume": 120,
    "days": [
      {
        "name": "Push Day",
        "nameFa": "روز فشار",
        "exercises": [
          {
            "exerciseId": "uuid-v4",
            "nameFa": "پرس سینه هالتر",
            "sets": 4,
            "repsOrDuration": 8,
            "isTimeBased": false,
            "restTime": 90,
            "equipment": "barbell",
            "orderIndex": 1,
            "notes": "Focus on explosive concentric",
            "notesFa": "روی بخش مثبت حرکت انفجاری کار کنید"
          }
        ]
      }
    ]
  },
  "expiresAt": "ISO-8601",
  "feedbackToken": "opaque-token-for-future-feedback-endpoint"
}
```

**Design notes:**
- The payload includes the user's own goals, physical profile, and recent history — the minimum data required for a personalized AI plan.
- `feedbackToken` enables a future feedback endpoint where users can rate the recommendation.
- The response `expiresAt` allows the client to cache the recommendation locally for a defined period (e.g., 4 weeks) before prompting the user to regenerate.

---

## 3. Repository Interface Evolution

### 3.1 Current State (Phase 1/2)

```dart
abstract class WorkoutRepository {
  Future<Result<List<WorkoutPlan>>> loadPlans();
  Future<Result<String?>> getActivePlanId();
  Future<Result<int?>> getCurrentDayIndex();
  Future<Result<List<WorkoutLog>>> loadLogs();
  Future<Result<void>> savePlans(List<WorkoutPlan> plans);
  Future<Result<void>> saveActivePlanId(String planId);
  Future<Result<void>> saveCurrentDayIndex(int dayIndex);
  Future<Result<void>> saveLogs(List<WorkoutLog> logs);
  Future<Result<void>> clearAll();
}
```

### 3.2 Target State (Phase 3)

```dart
abstract class WorkoutRepository {
  // Local CRUD (unchanged)
  Future<Result<List<WorkoutPlan>>> loadPlans();
  Future<Result<String?>> getActivePlanId();
  Future<Result<int?>> getCurrentDayIndex();
  Future<Result<List<WorkoutLog>>> loadLogs();
  Future<Result<void>> savePlans(List<WorkoutPlan> plans);
  Future<Result<void>> saveActivePlanId(String planId);
  Future<Result<void>> saveCurrentDayIndex(int dayIndex);
  Future<Result<void>> saveLogs(List<WorkoutLog> logs);
  Future<Result<void>> clearAll();

  // NEW: Sync-aware operations
  Future<Result<SyncStatus>> getSyncStatus();
  Future<Result<void>> markSynced(String logClientId);
  Future<Result<List<WorkoutLog>>> getUnsyncedLogs({int limit = 10});
  Future<Result<DateTime>> getLastSyncTimestamp();

  // NEW: Exercise Bank
  Future<Result<List<ExerciseDefinition>>> getExerciseBank();
  Future<Result<void>> applyExerciseBankDiffs(
    List<ExerciseDefinition> updates,
    List<String> deletes,
  );
  Future<Result<DateTime>> getExerciseBankLastUpdated();

  // NEW: Remote operations (called by sync engine, not by UI)
  Future<Result<SyncResult<WorkoutLog>>> uploadLogs(List<WorkoutLog> logs);
  Future<Result<ExerciseBankDiff>> fetchExerciseBankDiffs(DateTime? since);
}
```

### 3.3 Data Source Separation

```dart
abstract class WorkoutLocalDataSource {
  Future<Result<List<WorkoutPlan>>> loadPlans();
  Future<Result<void>> savePlans(List<WorkoutPlan> plans);
  Future<Result<List<WorkoutLog>>> loadLogs();
  Future<Result<void>> saveLogs(List<WorkoutLog> logs);
  Future<Result<void>> clearAll();
  Future<Result<List<SyncQueueItem>>> getPendingSyncItems();
  Future<Result<void>> addSyncItem(SyncQueueItem item);
  Future<Result<void>> removeSyncItem(String id);
  Future<Result<void>> incrementRetry(String id, String error);
}

abstract class WorkoutRemoteDataSource {
  Future<Result<String>> registerDevice(String deviceId);
  Future<Result<String>> refreshToken(String token);
  Future<Result<ExerciseBankDiff>> fetchExerciseBankDiffs(DateTime? since);
  Future<Result<List<String>>> uploadLogs(
    List<Map<String, dynamic>> serializedLogs,
  );
  Future<Result<WorkoutPlanRecommendation>> fetchRecommendation(
    RecommendationRequest request,
  );
}
```

### 3.4 Sync Queue Model

```dart
class SyncQueueItem {
  final String id;
  final String entityType; // 'workout_log' | 'body_weight'
  final String entityId;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;

  bool get isStale => retryCount >= 3;
}

class SyncStatus {
  final DateTime? lastFullSync;
  final int pendingItems;
  final int failedItems;
  final bool isSyncing;
}
```

### 3.5 Implementation: SyncingWorkoutRepository

```dart
class SyncingWorkoutRepository implements WorkoutRepository {
  final WorkoutLocalDataSource local;
  final WorkoutRemoteDataSource remote;
  final SyncQueue queue;

  // Local reads always from Hive, no network
  Future<Result<List<WorkoutPlan>>> loadPlans() => local.loadPlans();
  Future<Result<List<WorkoutLog>>> loadLogs() => local.loadLogs();

  // Writes: local first, then queue for remote
  Future<Result<void>> saveLogs(List<WorkoutLog> logs) async {
    final localResult = await local.saveLogs(logs);
    if (localResult.isError) return localResult;
    for (final log in logs) {
      await queue.enqueue(SyncQueueItem(
        entityType: 'workout_log',
        entityId: log.id,
        payload: log.toJson(),
      ));
    }
    return localResult;
  }

  // Sync orchestration
  Future<void> performFullSync() async {
    final pending = await local.getPendingSyncItems();
    for (final item in pending) {
      final result = await remote.uploadLogs([item.payload]);
      result.fold(
        onSuccess: (_) => local.removeSyncItem(item.id),
        onError: (e) => local.incrementRetry(item.id, e.message),
      );
    }
    final lastUpdated = await local.getExerciseBankLastUpdated();
    final diffs = await remote.fetchExerciseBankDiffs(lastUpdated.valueOrNull);
    diffs.fold(
      onSuccess: (diff) =>
          local.applyExerciseBankDiffs(diff.updates, diff.deletes),
      onError: (_) => {},
    );
  }
}
```

### 3.6 Riverpod Provider Refactoring

```dart
@riverpod
WorkoutLocalDataSource localWorkoutDataSource(LocalWorkoutDataSourceRef ref) {
  final box = ref.watch(appBoxProvider);
  return HiveWorkoutLocalDataSource(box);
}

@riverpod
WorkoutRemoteDataSource remoteWorkoutDataSource(RemoteWorkoutDataSourceRef ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ApiWorkoutRemoteDataSource(apiClient);
}

@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(WorkoutRepositoryRef ref) {
  final local = ref.watch(localWorkoutDataSourceProvider);
  final remote = ref.watch(remoteWorkoutDataSourceProvider);
  final queue = ref.watch(syncQueueProvider);

  ref.listen(connectivityStatusProvider, (prev, next) {
    if (prev == ConnectivityStatus.offline &&
        next == ConnectivityStatus.online) {
      ref.read(syncEngineProvider.notifier).performFullSync();
    }
  });

  return SyncingWorkoutRepository(local: local, remote: remote, queue: queue);
}
```

### 3.7 What Stays the Same

| Component                    | Changes Needed             | Reason                                  |
| ---------------------------- | -------------------------- | --------------------------------------- |
| `WorkoutNotifier`            | None                       | Depends on `WorkoutRepository` (abstract) |
| `ActiveWorkoutNotifier`      | None                       | Depends on `WorkoutNotifier`, not DB     |
| `AnalyticsNotifier`          | None                       | Depends on `WorkoutNotifier`, not DB     |
| `AddExerciseFormNotifier`    | Add API exercise bank lookup | May suggest exercises from central bank |
| All Screen files             | None (or minimal)          | UI reads from same Riverpod providers   |
| `ActiveWorkoutState`         | None                       | No data model changes                   |
| `WorkoutPlanState`           | None                       | No data model changes                   |

---

## 4. Recommendation Engine Data Flow

### 4.1 Complete Data Payload

```
RECOMMENDATION REQUEST PAYLOAD
├── USER IDENTITY & GOALS
│   ├── userId (String)
│   ├── goal: strength | hypertrophy | endurance | general
│   ├── experienceLevel: beginner | intermediate | advanced
│   ├── daysPerWeek (int 1-7)
│   └── sessionDurationMinutes (int)
├── AVAILABLE EQUIPMENT
│   └── List<String> ["dumbbell", "barbell", "bodyweight"]
├── RECENT WORKOUT LOGS (last 10)
│   └── Each log contains:
│       ├── dayName (String)
│       ├── completedAt (ISO-8601)
│       ├── totalSetsCompleted (int)
│       ├── totalDurationMinutes (int)
│       └── exercises: List of {exerciseId, exerciseName,
│            sets: List of {setNumber, weight, reps,
│            isCompleted, rpe?}}
├── BEST LIFTS / PERSONAL RECORDS
│   └── List of {exerciseId, exerciseName, best1RM, date}
├── PHYSICAL PROFILE
│   ├── age (int)
│   ├── gender (String)
│   ├── heightCm (double)
│   ├── currentWeightKg (double)
│   ├── bodyFatPercentage (double?)
│   └── injuriesOrLimitations (List<String>)
└── CLIENT HINTS (optional)
    ├── preferredRestTime: 60-90-120 (int?)
    ├── preferredSetScheme: straight | pyramid | drop (String?)
    └── excludedExercises: ["exerciseId"] (List<String>?)
```

### 4.2 Mobile-Side Preparation

```dart
Future<RecommendationRequest> _buildRecommendationRequest() async {
  final state = ref.read(workoutNotifierProvider).valueOrNull;
  if (state == null) throw Exception('No plan state available');

  final recentLogs = state.workoutLogs
    .sortedByDescending((l) => l.completedAt)
    .take(10)
    .map((log) => LogSummary(/* map fields */))
    .toList();

  final analytics = ref.read(analyticsNotifierProvider);
  final bestLifts = analytics.bestLifts.entries
    .map((e) => BestLiftSummary(/* map fields */))
    .toList();

  final weightState = ref.read(weightLogNotifierProvider);
  final latestWeight = weightState.records.isNotEmpty
    ? weightState.records.first.weight
    : null;

  return RecommendationRequest(
    goal: _userGoal,
    experienceLevel: _experienceLevel,
    daysPerWeek: _daysPerWeek,
    availableEquipment: _equipment,
    recentLogs: recentLogs,
    bestLifts: bestLifts,
    physicalProfile: PhysicalProfile(
      age: _userAge,
      currentWeightKg: latestWeight,
    ),
  );
}
```

### 4.3 Caching & Display Strategy

```
User taps "Generate Recommendation"
    │
    ▼
┌──────────────────────────────────────┐
│  Check local cache for unexpired     │
│  recommendation                      │
└──────────┬───────────────────────────┘
           │
     ┌─────┴─────┐
     │           │
     ▼           ▼
  Valid        Expired
  Cache        or None
     │           │
     │           ▼
     │    ┌──────────────────────┐
     │    │  Show loading state  │
     │    │  (skeleton UI)      │
     │    └──────────┬───────────┘
     │               │
     │               ▼
     │    ┌──────────────────────┐
     │    │  POST /api/          │
     │    │  recommendations/    │
     │    │  generate            │
     │    └──────────┬───────────┘
     │               │
     │         ┌─────┴─────┐
     │         │           │
     │         ▼           ▼
     │      Success     Failure
     │         │           │
     │         ▼           ▼
     │    ┌──────────┐ ┌──────────────────┐
     │    │ Save to  │ │ Show error with  │
     │    │ Hive     │ │ retry button     │
     │    │ Cache    │ └──────────────────┘
     │    └────┬─────┘
     │         ▼
     │    ┌──────────────────────┐
     └────► Display plan UI     │
          │ (User can accept,   │
          │ edit, or dismiss)   │
          └──────────────────────┘
```

### 4.4 Privacy & Security

- **End-to-end encryption** for workout logs payload using device key (generated at registration, stored in `flutter_secure_storage`, never sent to server in plaintext).
- **Local computation option**: On-device rule-based recommendation engine (`goal + equipment → template`) runs from cached exercise bank for users who decline cloud sync.
- **Data retention**: Server retains last 10 logs for recommendation computation; full history stored only on-device.
- **Account deletion**: `DELETE /api/user/data` removes all server-stored logs and profile data (GDPR compliance).

---

## 5. Tech Stack Recommendations

### 5.1 Networking

| Library              | Purpose                     | Why                                      |
| -------------------- | --------------------------- | ---------------------------------------- |
| **Dio**              | HTTP client                 | Auth interceptor, retry, cancellation, multipart upload |
| **connectivity_plus** | Network status detection   | Trigger sync engine on reconnect          |
| **Riverpod**         | State for connectivity      | Already in use; `StreamProvider` for connectivity stream |

```dart
@riverpod
Dio apiClient(ApiClientRef ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
  ));
  dio.interceptors.add(AuthInterceptor(
    tokenProvider: ref.read(authTokenProvider),
    onTokenExpired: () => ref.read(authRepositoryProvider).refreshToken(),
  ));
  dio.interceptors.add(RetryInterceptor(
    retries: 3,
    retryDelay: const Duration(seconds: 2),
  ));
  return dio;
}
```

### 5.2 Background Sync

| Library                        | Platform      | Purpose                             |
| ------------------------------ | ------------- | ----------------------------------- |
| **workmanager**                | Android + iOS | Periodic background sync (15-min)   |
| **flutter_background_service** | Android + iOS | Keep sync alive during long uploads |

```dart
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await initializeHive();
    final container = ProviderContainer();
    await container.read(syncEngineProvider.notifier).performFullSync();
    return Future.value(true);
  });
}

void registerPeriodicSync() {
  Workmanager().registerPeriodicTask(
    'exo-sync',
    'periodicBackgroundSync',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );
}
```

### 5.3 Local Storage & Security

| Library                     | Purpose                        | Why                                      |
| --------------------------- | ------------------------------ | ---------------------------------------- |
| **Hive**                    | Primary local DB               | Already in use; fast key-value           |
| **flutter_secure_storage**  | Auth tokens, device key        | Encrypted at rest (Keychain/Keystore)    |
| **crypto** (Dart)           | HMAC signing, key derivation   | No native dependencies                   |
| **pointycastle**            | E2E encryption                 | AES-GCM for workout payload encryption   |

### 5.4 Serialization

| Library              | Purpose                  | Why                                      |
| -------------------- | ------------------------ | ---------------------------------------- |
| **freezed**          | Immutable models         | `copyWith`, union types, JSON serialization |
| **json_serializable** | JSON code gen (Dart)    | Pair with freezed for round-trip safety   |

### 5.5 AI Model (Server-Side, Reference Only)

- **Model type**: Gradient-boosted tree (CatBoost / XGBoost) over tabular features
- **Input features**: Volume progression, intensity trend, exercise diversity, rest behavior, user profile
- **Constraint**: Never recommend exercises requiring equipment the client marked unavailable
- **Latency target**: < 2 seconds at P95

---

## 6. Risk Mitigation

| Risk                              | Likelihood | Impact | Mitigation                                     |
| --------------------------------- | ---------- | ------ | ---------------------------------------------- |
| Hive schema drift after sync      | Low        | High   | Version all models; run migration in `main()`  |
| Token expiry during background    | Medium     | Medium | Auth interceptor with silent refresh; queue retry |
| Large exercise bank payload       | Low        | Medium | Delta sync with `lastUpdated`; paginate >1000  |
| User declines network permissions | Medium     | Medium | Full offline fallback; on-device recommendations |
| Sync queue grows unbounded        | Low        | Low    | Max 100 items; auto-expire items older than 7 days |
| API rate limiting                 | Medium     | Low    | Batch uploads; exponential backoff             |

---

## 7. Implementation Roadmap

### Phase 3.1 — Connectivity & Auth (Weeks 1-2)
- Add `Dio` + `connectivity_plus` dependencies
- Implement `ApiClient` provider with auth interceptor
- Implement device registration + token refresh
- Add `flutter_secure_storage` for token persistence
- Connect to staging server, verify handshake

### Phase 3.2 — Exercise Bank Sync (Weeks 3-4)
- Extend `WorkoutRepository` with sync-related methods
- Implement `HiveWorkoutLocalDataSource` (extract from current impl)
- Implement `ApiWorkoutRemoteDataSource` for exercise bank
- Implement delta sync logic on app startup
- Add `lastUpdated` timestamp to exercise bank Hive box

### Phase 3.3 — Workout Log Sync (Weeks 5-6)
- Implement sync queue (Hive-backed FIFO)
- Implement `POST /api/workouts/log` upload with batching
- Add `WorkManager` periodic sync task
- Add sync status indicator to Profile screen

### Phase 3.4 — AI Recommendations (Weeks 7-8)
- Implement recommendation request builder provider
- Add recommendation caching layer (Hive box)
- Build recommendation display screen (accept/edit/dismiss)
- Connect to `/api/recommendations/generate` endpoint
- Add on-device fallback recommendation engine

### Phase 3.5 — Hardening (Weeks 9-10)
- Add E2E encryption for sensitive payloads
- Implement retry + exponential backoff in sync engine
- Add comprehensive error handling and sync status UI
- Load test with 1000+ logs to verify sync queue
- Full `flutter analyze` + integration tests for sync engine
