# EXO — Roadmap (Next 4 Days)

> **Phase:** Plan Showcase, AI Flow, Sync Engine, Monetization  
> **Branch:** `main` (commit: `6ff0f18` — AI Recommendation Service + Drift Repository Rewrite)  
> **Analyze:** `flutter analyze` passes with 0 errors (4 pre-existing infos/warnings)  
> **Strings:** All user-facing Persian strings in `AppStrings`

---

## Day 1: The Plan Showcase (Vitrine) & Multi-Plan UI

| Category | Item | Description |
|----------|------|-------------|
| **UI** | `PlanShowcaseScreen` | Tabbed screen with three sections: "Active Program" (current rotation), "My Library" (previously used/created plans), "Premium Store" (mocked purchasable pro plans). Each section presents a horizontal scrollable card list. |
| **UI** | Active Program card | Displays plan name, day index progress (e.g. "روز ۳ از ۱۲"), completion %, and a "Continue" CTA. Tap navigates to `ActiveWorkoutScreen`. |
| **UI** | My Library card | Shows plan name, creation date, last-used date, star rating (mock). Tap opens `PlanEditorScreen` in read-only mode. Long-press reveals context menu: Activate / Edit / Delete. |
| **UI** | Premium Store card | Blurred or locked thumbnail overlay with a "قفل" badge. Tap shows a "نمایش پیش‌نمایش" button that reveals 2 sample days but gates full plan behind credit/purchase. |
| **Logic** | Plan cloning from Store | `PlanEditorScreen` gains a `cloneFrom` parameter. When a premium plan is "purchased" (mock), deep-copy the plan via `WorkoutRepositoryImpl._savePlanInternal`, generate new UUIDs for plan and all day/exercise IDs. |
| **Logic** | Plan activation switch | `WorkoutNotifier.switchActivePlan(String planId)` preserves the old plan's `currentDayIndex` in a `Map<String, int>` in Drift (new `plan_progress` table or JSON column on `WorkoutPlans`). When switching back, restore the saved index. |
| **Architecture** | `plan_progress` table | New Drift table: `plan_id TEXT PK, current_day_index INT, last_activated_at INT`. DAO extension with `getProgress(planId)`, `saveProgress(planId, index)`. No FK — progress is a soft read-model. |
| **Data** | `PlanShowcaseState` model | Freezed state with `activePlan`, `libraryPlans: List<WorkoutPlan>`, `storePlans: List<WorkoutPlan>`, `isLoading`. Riverpod `@riverpod` notifier fetches all 3 sources in parallel. |

---

## Day 2: AI Questionnaire & Recommendation UX

| Category | Item | Description |
|----------|------|-------------|
| **UI** | `AIQuestionnaireScreen` | Multi-step form (3 steps): (1) Energy level slider + sleep hours picker, (2) Equipment checkboxes (دمبل, کش, وزن بدن, none), (3) Target focus chips (قدرت, استقامت, هایپرتروفی, چربی‌سوزی). Navigation via `Stepper` widget. |
| **UI** | `AIGeneratingOverlay` | Full-screen skeleton animation with pulsing card placeholders and Persian text "در حال تحلیل تمرینات شما...". Uses `AnimatedBuilder` or Lottie for the 2-second mock delay. |
| **UI** | `AIPlanPreviewScreen` | Read-only day-by-day preview of the generated `WorkoutPlan`. Each day expandable via `ExpansionTile`. Bottom bar has "ذخیره و فعال‌سازی" (calls `RecommendationNotifier.acceptRecommendation`) and "رد پیشنهاد" (calls `.rejectRecommendation()`). |
| **Logic** | Questionnaire → Service bridge | `prepareAIRequest` accepts an `AIContext` object (energy, equipment, focus) and passes it to `generateRecommendation`. The mock AI adjusts exercise selection/reps based on context (e.g. more reps for استقامت, heavier suggestion for قدرت). |
| **Architecture** | `AIContext` model | Simple data class: `{energyLevel: int, equipment: List<String>, focus: String}`. Stored in `StateProvider<AIContext?>` so it survives screen transitions. |
| **Architecture** | Credit consumption timing | Credits are deducted *after* the user taps "Accept", not at generation. This allows previews without cost. `RecommendationService.deductCredit` moves from `generateRecommendation` to a new `confirmAccept()` method called by the notifier. |
| **Data** | `ai_context` serialization | Serialize `AIContext` to JSON and store in `SharedPreferences` (or a lightweight `SecureStorage` key) so the last-used preferences can pre-fill the form. |

---

## Day 3: Sync Engine & Eventual Consistency

| Category | Item | Description |
|----------|------|-------------|
| **Logic** | `SyncEngine` (Riverpod Notifier) | `@Riverpod(keepAlive: true)` class that subscribes to `connectivity_plus` stream. On connectivity restored, drains the `SyncQueue` table FIFO — each item is HTTP POSTed to the mock API endpoint. On success, marks `isSynced = true` and removes from queue. On failure, retries with exponential backoff (capped at 5 attempts). |
| **Logic** | Write-Through pattern | Every repository write method (`savePlan`, `completeDay`, `deletePlan`) now enqueues a `SyncOperation` *in the same Drift transaction* that writes the data. This guarantees at-least-once delivery. `SyncDao.addToQueue` is called inside each repository method after the main write. |
| **Logic** | Conflict resolution | If a sync item fails after 5 retries, set `isSynced = false` on the source record and emit a `SyncFailureState` so the UI can show a warning. A "manual retry" button in Settings triggers `SyncEngine.retryAll()` |
| **Data** | `SyncQueue` schema review | Ensure `SyncQueue` has: `id (INT AUTO PK)`, `operationType (TEXT: create/update/delete)`, `entityType (TEXT: plan/log)`, `entityId (TEXT)`, `payload (TEXT — JSON blob)`, `retryCount (INT DEFAULT 0)`, `createdAt (INT)`. |
| **UI** | Sync Status indicator | Small `StreamBuilder<bool>` widget in `DashboardScreen` and `ProfileScreen`. Shows a cloud icon: solid cloud = all synced, cloud with upward arrow = syncing, cloud with exclamation = failed. Icon taps navigate to `SyncLogScreen`. |
| **UI** | `SyncLogScreen` | Read-only list of recent sync operations with status badges (✅ synced, ⏳ pending, ❌ failed). Pull-to-refresh triggers `SyncEngine.processQueue()`. |

---

## Day 4: Monetization UI & Advanced SQL Analytics

| Category | Item | Description |
|----------|------|-------------|
| **UI** | `CreditsWidget` | Small badge in `PlanShowcaseScreen` top bar showing "۵ اعتبار" with a ⚡ icon. Uses `aiCreditsAvailable` provider. When credits = 0, badge turns red and is tappable. |
| **UI** | Paywall Mock dialog | `showCreditsTopUpDialog()` — modal bottom sheet with 3 tiers: ۵ اعتبار (رایگان), ۱۵ اعتبار (۹۹,۰۰۰ تومان), ۳۰ اعتبار (۱۷۹,۰۰۰ تومان). Tier 1 is auto-granted after watching a mock ad; tiers 2-3 show a "درگاه پرداخت" button that logs to console. |
| **Logic** | `CreditsService` | Lightweight service holding a `BehaviorSubject<int>` for reactive credit balance. Reads initial balance from `SecureStorage`. `deductCredit` writes back immediately. `addCredits(int)` called by the paywall mock. |
| **Data** | Volume Progression query | Drift raw query (or compiled custom query) joining `WorkoutLogs` + `SetLogs` + `Exercises` on `WorkoutLogs.id = SetLogs.logId AND SetLogs.exerciseId = Exercises.id`. Groups by `date(completedAt)` and computes `SUM(sets.completedCount * exercises.weight)` → "Volume Over Time" chart data. |
| **Logic** | Premium gating | Wrap the Volume Progression chart in a `PremiumGate` widget. If `hasPremiumAccess` (derived from `CreditsService`, mock) is false, show a blurred preview with a "اشتراک ویژه" overlay. |
| **Architecture** | `AnalyticsRepository` | New abstract repository + Drift impl for analytical queries. Methods: `getVolumeProgression(days: 30)`, `getMuscleGroupBreakdown()`, `getStreakData()`. Each returns a typed result model (`VolumePoint`, `MuscleGroupStat`, `StreakInfo`). |
| **Final Pass** | `flutter analyze` & RTL audit | Full `flutter analyze` — 0 errors. Check every newly added screen for RTL layout issues (`TextDirection.rtl`, correct `EdgeInsets` mirroring). Audit `AppStrings` for missing Persian translations — all user-facing text must be in `AppStrings`. |

---

## Technical Debt

| Item | Priority | Notes |
|------|----------|-------|
| Hive `storage_providers.dart` still throws `UnimplementedError` | **High** | `appBox` and `snapshotBox` providers remain for `ActiveWorkoutNotifier`. Either migrate snapshot persistence to Drift or keep Hive for ephemeral workout state. |
| `setDayIndex` is a no-op stub | **Medium** | Needs real persistence (likely the `plan_progress` table planned in Day 1). Until then, day index resets to 0 on app restart. |
| Mock API layer is not swappable | **Medium** | `RecommendationService.generateRecommendation` returns hardcoded exercises. Introduce a `RecommendationDataSource` abstract class with `MockDataSource` and `RemoteDataSource` (Dio) so the real API can be plugged in without service changes. |
| `WorkoutDefaults.assetImg` references non-existent `.webp` files | **Low** | Several images (`goblet_squat.png.webp`, `single_leg_deadlift.png.webp`) have double extensions. The asset directory `assets/images/exercises/` is populated but filenames need normalization. |
| No offline fallback for Premium Store plans | **Low** | Store plans are currently mock-only. A future iteration should cache purchased/premium plan JSON in Drift for offline access. |
| Drift schema migrations not tested | **Low** | `AppDatabase.migrationStrategy` only handles schema v1. Add integration tests for schema upgrades when `plan_progress` or new tables are introduced. |

---

## Architectural Notes

- **Plan Activation**: When switching active plans, the `WorkoutNotifier` must save the current plan's `currentDayIndex` *before* loading the new plan's state. The `plan_progress` table acts as a read-model that does not affect the plan entity itself.
- **Credit Deduction Timing**: Credits are consumed only on "Accept", not on "Generate Preview". The `RecommendationService` exposes `confirmAccept()` which deducts a credit and returns `Result<void>`. The `RecommendationNotifier` calls this before saving the plan.
- **Sync Queue Ordering**: The `SyncEngine` processes items in `createdAt` ascending order. If a `delete` operation precedes a `create` for the same `entityId`, the engine skips the orphaned `delete`. This is handled by a deduplication pass at the start of each sync cycle.
- **Premium Gating**: No true IAP implementation. The paywall mock uses a simple `bool _hasPremium` flag stored in `SecureStorage`. In production, this would be replaced by `in_app_purchase` verification.
- **RTL / Persian**: All screens must use `Directionality( textDirection: TextDirection.rtl, child: ... )` at the top level. List views should use `reverse: true` for Persian-first ordering where appropriate.

---

*Generated: 2026-05-19*  
*Last commit: `6ff0f18`*
