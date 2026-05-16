# Project System Instruction for AI Studio / Cursor AI

## Overview

**exo** is a Flutter workout tracker application designed for managing a 3-day workout program. The app supports adding exercises, running timed workouts with automatic rest periods, and tracking daily progress with a sequential day-unlock system.

---

## Project Metadata

| Property | Value |
|----------|-------|
| **Name** | exo |
| **Type** | Mobile Application (iOS & Android) |
| **Language** | Dart / Flutter |
| **Framework** | Flutter 3.11.5 / Riverpod 2.6.1 |
| **State Management** | Riverpod 2 (StateNotifier + Selectors) |
| **Architecture** | Clean Architecture (3-layer) |
| **Persistence** | SharedPreferences |
| **UI Direction** | RTL (Persian/Farsi) |
| **Design System** | Material Design 3 |
| **License** | MIT |
| **Author** | Ali Joder |
| **Email** | ali.masoudi.alavi@gmail.com |
| **Repository** | https://github.com/unknownman/exo |

---

## Project Structure

```
lib/
├── main.dart                          # Entry point + ProviderScope + DI
├── app.dart                           # MaterialApp configuration
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # All app constants (validation limits, equipment types, etc.)
│   ├── theme/
│   │   └── app_theme.dart             # Material 3 theme configuration
│   └── router/
│       └── app_router.dart            # Named routes with RouteSettings
│
├── data/
│   ├── models/
│   │   ├── exercise.dart               # Immutable Exercise model (copyWith, ==, hashCode)
│   │   └── workout_day.dart           # Immutable WorkoutDay model (computed properties)
│   ├── datasources/
│   │   └── local_storage_datasource.dart  # SharedPreferences wrapper with JSON encode/decode
│   └── repositories/
│       └── workout_repository_impl.dart   # Concrete repository implementation
│
├── domain/
│   └── repositories/
│       └── workout_repository.dart    # Abstract repository interface
│
└── presentation/
    ├── providers/
    │   ├── workout_provider.dart      # WorkoutNotifier: manages days, exercises, progress
    │   ├── active_workout_provider.dart # ActiveWorkoutNotifier: timer, sets, workout flow
    │   └── providers.dart               # Export all providers
    ├── screens/
    │   ├── home_screen.dart           # Main screen with list of workout days
    │   ├── active_workout_screen.dart  # Active workout execution screen
    │   └── add_exercise_screen.dart    # Form for adding new exercises
    └── widgets/
        └── day_card.dart             # Reusable day card widget with Selector
```

---

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Screens   │  │  Providers  │  │      Widgets        │ │
│  │   (UI)     │  │ (Riverpod)  │  │    (Reusable)       │ │
│  └──────┬──────┘  └──────┬──────┘  └─────────────────────┘ │
└─────────┼───────────────┼─────────────────────────────────┘
          │               │
          ▼               ▼
┌─────────────────────────────────────────────────────────────┐
│                       Domain Layer                          │
│  ┌─────────────────────────────────────────────────────┐  │
│  │              WorkoutRepository (Abstract)          │  │
│  └─────────────────────────┬───────────────────────────┘  │
└────────────────────────────┼───────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                            │
│  ┌────────────┐  ┌─────────────┐  ┌────────────────────┐  │
│  │   Models   │  │ DataSources │  │Repository Impl     │  │
│  │  (Entity)  │  │ (Storage)   │  │ (Concrete)         │  │
│  └────────────┘  └─────────────┘  └────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## Key Technical Concepts

### 1. State Management (Riverpod 2)

**Providers:**

```dart
// Repository Provider (DI)
final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  throw UnimplementedError('Override in main.dart');
});

// Main Workout State Provider
final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  final repository = ref.watch(workoutRepositoryProvider);
  return WorkoutNotifier(repository);
});

// Active Workout Provider
final activeWorkoutProvider = StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>((ref) {
  return ActiveWorkoutNotifier(ref);
});

// Selector Providers (for optimal rebuilds)
final daySelectorProvider = Provider.family<WorkoutDay?, int>((ref, dayId) {
  final state = ref.watch(workoutProvider);
  return state.getDayById(dayId);
});

final currentExerciseProvider = Provider<Exercise?>((ref) {
  // Returns current exercise based on active workout state
});
```

### 2. Immutable State Pattern

```dart
// ❌ BAD: Mutating state directly
state.days.add(newDay);
notifyListeners();

// ✅ GOOD: Creating new state
state = state.copyWith(days: [...state.days, newDay]);
notifyListeners();
```

### 3. Error Handling Pattern

```dart
Future<void> loadData() async {
  try {
    final days = await _repository.getWorkoutDays();
    state = state.copyWith(days: days, isLoading: false);
  } catch (e, stackTrace) {
    debugPrint('[WorkoutNotifier] Error: $e');
    debugPrint('StackTrace: $stackTrace');
    state = state.copyWith(
      isLoading: false,
      errorMessage: 'خطا در بارگذاری داده‌ها',
    );
  }
}
```

### 4. Null Safety Pattern

```dart
// ❌ BAD: firstWhere without orElse (crashes if not found)
final day = _days.firstWhere((d) => d.id == dayId);

// ✅ GOOD: indexWhere with null check
final index = _days.indexWhere((d) => d.id == dayId);
if (index < 0) return null;
return _days[index];
```

### 5. Selector for Optimal Rebuilds

```dart
// Only rebuilds when this specific day changes
Selector<WorkoutProvider, WorkoutDay>(
  selector: (_, provider) => provider.getDayById(day.id) ?? day,
  builder: (context, currentDay, _) {
    return DayCard(day: currentDay);
  },
)
```

---

## Data Models

### Exercise

```dart
class Exercise {
  final String id;
  final String name;
  final int sets;
  final int repsOrDuration;  // reps or seconds depending on isTimeBased
  final bool isTimeBased;
  final int restTime;         // seconds between sets
  final String equipment;      // 'وزن بدن', 'دمبل', 'هالتر', etc.
}
```

### WorkoutDay

```dart
class WorkoutDay {
  final int id;
  final String dayName;         // 'روز اول', 'روز دوم', 'روز سوم'
  final List<Exercise> exercises;
  final bool isUnlocked;        // false until previous day is completed
  final bool isCompletedToday;  // true when all exercises are done
}
```

---

## Active Workout State Machine

```
[Start Workout] 
     ↓
[Exercise 1: Set 1] → [Rest] → [Exercise 1: Set 2] → [Rest] → ...
     ↓
[All Sets Done] → [Next Exercise] or [Workout Complete]
     ↓
[Finish Workout] → [Complete Day] → [Unlock Next Day]
```

### ActiveWorkoutState

```dart
class ActiveWorkoutState {
  final int? dayId;
  final int currentExerciseIndex;
  final int currentSet;
  final bool isResting;
  final bool isWorkoutTimerRunning;
  final int remainingWorkoutSeconds;  // for time-based exercises
  final int remainingRestSeconds;    // countdown timer
  final bool isAllDone;
  final String? errorMessage;
}
```

---

## Navigation (Named Routes)

| Route | Screen | Arguments |
|-------|--------|-----------|
| `/` | HomeScreen | - |
| `/workout` | ActiveWorkoutScreen | `{dayId: int, dayName: String}` |
| `/add-exercise` | AddExerciseScreen | - |

---

## Constants (app_constants.dart)

```dart
abstract final class AppConstants {
  static const String storageKey = 'workout_data';
  static const int defaultDayCount = 3;
  static const List<String> defaultDayNames = ['روز اول', 'روز دوم', 'روز سوم'];
  
  // Validation
  static const int minSets = 1;
  static const int maxSets = 20;
  static const int minRestSeconds = 5;
  static const int maxRestSeconds = 300;
  static const int minExerciseNameLength = 2;
  
  // Equipment Types
  static const List<String> equipmentTypes = ['وزن بدن', 'دمبل', 'هالتر', 'کش ورزشی', 'دستگاه'];
}
```

---

## Features

| Feature | Implementation |
|---------|----------------|
| Add Exercise | Form with name, sets, reps/duration, rest time, equipment type |
| Run Workout | Timer or reps counter with automatic rest between sets |
| Skip Rest | Button to skip rest timer and continue |
| Complete Day | Marks day as done, unlocks next day |
| Progress Tracking | SharedPreferences persistence |
| Lock System | Next day locked until current day is completed |
| RTL Support | Full Persian/Farsi UI with Directionality |

---

## Important Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point with ProviderScope and DI overrides |
| `lib/presentation/providers/workout_provider.dart` | Main state management |
| `lib/presentation/providers/active_workout_provider.dart` | Active workout timer/logic |
| `lib/data/repositories/workout_repository_impl.dart` | Data access layer |
| `lib/core/router/app_router.dart` | Navigation configuration |
| `lib/core/constants/app_constants.dart` | All constants |

---

## Common Tasks

### Adding a new Exercise
1. User fills form in AddExerciseScreen
2. WorkoutProvider.addExercise() is called
3. Exercise is added to specific day's list
4. State is saved to SharedPreferences

### Running a Workout
1. User taps "Start Workout" on unlocked day
2. ActiveWorkoutProvider.startWorkout() initializes state
3. Timer/reps counter runs per exercise
4. Rest timer starts between sets
5. On completion, workoutProvider.completeDay() marks day done

### Completing a Day
1. All exercises in day are done
2. User taps "Finish Workout"
3. Day.isCompletedToday = true
4. Next day.isUnlocked = true
5. State persisted to SharedPreferences

---

## Best Practices Used

1. **Immutable State** - All states use `copyWith()` pattern
2. **Null Safety** - No `!` assertions, proper null checks
3. **Error Handling** - try-catch with debug logging
4. **Separation of Concerns** - UI, Business Logic, Data Access separated
5. **Selector Optimization** - Granular rebuilds with Selectors
6. **Type Safety** - Named routes with typed arguments
7. **Constants** - No magic numbers, all in constants classes

---

## Development Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for release (Android)
flutter build apk --release

# Build for release (iOS)
flutter build ios --release

# Run code generation (if using annotations)
flutter pub run build_runner build -d
```

---

## Notes for AI Assistant

1. **When adding new features**, follow Clean Architecture:
   - UI in `presentation/screens/`
   - Business logic in `presentation/providers/`
   - Data access in `data/repositories/` or `data/datasources/`
   - Interfaces in `domain/repositories/`

2. **When modifying state**, always use the `copyWith()` pattern:
   ```dart
   state = state.copyWith(newValue: newValue);
   ```

3. **When accessing state**, prefer Selectors for performance:
   ```dart
   ref.watch(provider.select((s) => s.specificField));
   ```

4. **Never mutate state directly** - always create new instances

5. **For navigation**, use named routes defined in `app_router.dart`

6. **All strings should be in constants** - create abstract classes like `FormStrings`, `CardStrings`, etc.

7. **RTL Support** - Wrap screens with `Directionality(textDirection: TextDirection.rtl)`

---

## Version History

| Version | Score | Description |
|---------|-------|-------------|
| v1.0 (MVP) | 4.5/10 | Simple Provider, mixed UI/logic, no error handling |
| v2.0 (Current) | 8.3/10 | Clean Architecture, Riverpod 2, Immutable State, Full Error Handling |

---

## Contact

**Author:** Ali Joder  
**Email:** ali.masoudi.alavi@gmail.com  
**GitHub:** https://github.com/unknownman