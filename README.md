# Exo — The Smart Offline Workout Tracker

> **Version**: 1.0.0+1 • **Locale**: fa-IR (Persian RTL)

A professional, fully offline workout tracking application built with Flutter. Exo combines intelligent Personal Record detection, equipment-aware input logic, and a rich Persian-first UI to deliver a premium training experience without any backend dependency.

---

## Key Features

- **Smart PR Detection** — Automatically calculates estimated 1RM (Brzycki formula) and detects new personal records. Bodyweight exercises score by max reps; weighted exercises use proven strength formulas.
- **Equipment-Aware Inputs** — The active workout screen dynamically adapts labels, hints, and units based on exercise equipment (resistance bands → tension level 1–5, bodyweight → added weight, free weights → kg).
- **Consistency Calendar** — Visual monthly calendar with intensity heatmap and weekly workout frequency.
- **Analytics Dashboard** — Per-exercise volume and weight trend charts, best lift records, and PR badges.
- **GoRouter Navigation** — Declarative routing with `StatefulShellRoute.indexedStack` for bottom tab navigation and type-safe path/extra parameters.
- **Riverpod 2.x (Code Gen)** — Reactive state management with auto-dispose form notifiers, select-based performance optimizations, and family providers for scoped data.
- **Hive Local Database** — Zero-dependency, encrypted local storage with snapshot-based active workout persistence (survives app restarts).
- **RTL Persian UI** — Full right-to-left layout with Persian digit conversion and culturally appropriate string resources.
- **TTS Audio Coach** — Text-to-speech set announcements and rest timer guidance.
- **Lottie & Media Support** — Exercise demonstration videos, images, and Lottie animations with in-app media picker.
- **Body Weight Tracking** — Weight log with trend chart and quick-add functionality.
- **Background Music** — Built-in music player for workout ambience.

---

## Tech Stack

| Layer              | Technology                             |
| ------------------ | -------------------------------------- |
| **Framework**      | Flutter 3.41+ / Dart 3.11+             |
| **State Mgmt**     | Riverpod 2.6 (with `riverpod_generator`) |
| **Navigation**     | GoRouter 17 (declarative + shell routes) |
| **Local DB**       | Hive 5 (with `hive_flutter`)           |
| **Charts**         | fl_chart                               |
| **Animations**     | lottie                                 |
| **Audio**          | audioplayers, TTS (flutter_tts)        |
| **Media Pick**     | image_picker, file_picker              |
| **UUID**           | uuid                                   |
| **Architecture**   | Clean Architecture inspired            |

---

## Architecture

Exo follows a **Clean Architecture–inspired, local-first** design with three primary layers:

```
┌─────────────────────────────┐
│  Presentation (Screens)     │  ConsumerWidgets, ConsumerStatefulWidgets
├─────────────────────────────┤
│  State (Providers)          │  Riverpod Notifiers, family providers
├─────────────────────────────┤
│  Domain (Business Logic)    │  Services (AnalyticsService, etc.)
├─────────────────────────────┤
│  Data (Persistence)         │  Hive adapters, Repository implementations
└─────────────────────────────┘
```

### Key Principles

- **All state is Riverpod**. Every screen reads from a provider; no local `setState` for business data.
- **Immutable state classes** with strict `copyWith` usage.
- **`select()` for performance**. Provider watchers use targeted selects to avoid unnecessary rebuilds.
- **Auto-dispose form providers**. Form state lives only while the screen is mounted.
- **Repository pattern**. Data sources are abstracted behind interfaces (`MediaRepository`, etc.).

---

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart       # App-wide defaults and enums
│   │   └── app_strings.dart         # All Persian UI strings (single source of truth)
│   ├── theme/
│   │   └── app_theme.dart           # Material 3 color scheme and text styles
│   └── utils/
│       ├── id_generator.dart        # UUID v4 generator
│       └── persian_digits.dart      # Extension: int.toPersian(), String.toPersianDigits()
│
├── data/
│   ├── adapters/
│   │   ├── exercise_adapter.dart
│   │   ├── workout_log_adapter.dart
│   │   ├── workout_plan_adapter.dart
│   │   └── body_weight_adapter.dart
│   └── repositories/
│       ├── media_repository_impl.dart
│       └── plan_repository_impl.dart
│
├── domain/
│   ├── repositories/
│   │   ├── media_repository.dart      # Abstract interface
│   │   └── plan_repository.dart       # Abstract interface
│   └── services/
│       ├── analytics_service.dart     # PR detection, volume calc, chart data
│       └── workout_plan_manager.dart  # Plan CRUD, exercise add/update/remove
│
├── models/
│   ├── exercise.dart
│   ├── exercise_media.dart
│   ├── body_weight_record.dart
│   ├── personal_record.dart
│   ├── workout_log.dart
│   └── workout_plan.dart
│
├── providers/
│   ├── active_workout_provider.dart   # Live workout session state
│   ├── add_exercise_form_provider.dart# Form state for exercise creation
│   ├── analytics_provider.dart        # PRs, best lifts, per-exercise analytics
│   ├── media_provider.dart            # MediaRepository DI
│   ├── music_provider.dart            # Background music player
│   ├── tts_provider.dart              # Text-to-speech state
│   ├── weight_provider.dart           # Body weight log state
│   └── workout_provider.dart          # Root plan + log state
│
├── router/
│   └── app_router.dart                # All routes, shell navigation, path constants
│
├── screens/
│   ├── active_workout_screen.dart     # Live workout with set logging
│   ├── add_exercise_screen.dart       # Exercise creation form
│   ├── create_plan_screen.dart        # New plan wizard
│   ├── dashboard_screen.dart          # Main tab: calendar, day nav, exercise list
│   ├── exercise_analytics_screen.dart # Per-exercise charts and PRs
│   ├── plan_editor_screen.dart        # Full plan editor (days + exercises)
│   ├── profile_screen.dart            # Settings, body weight, music
│   ├── rest_screen.dart               # Rest timer between sets
│   ├── shell_screen.dart              # Bottom tab scaffold
│   └── workout_history_screen.dart    # Past workout logs and volume trends
│
└── widgets/
    ├── exercise_media_widget.dart     # Renders image/video/lottie media
    ├── tts_toggle_button.dart         # TTS on/off toggle
    └── workout_calendar_widget.dart   # Consistency calendar grid
```

---

## Getting Started

### Prerequisites

- Flutter SDK 3.41+ (Dart 3.11+)
- A code editor (VS Code, Android Studio, or IntelliJ)
- iOS simulator / Android emulator, or a physical device

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/unknownman/exo.git
cd exo

# 2. Install dependencies
flutter pub get

# 3. Generate Riverpod code
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

> **Note**: Build runner takes ~2 minutes on first run. Subsequent incremental builds are faster.

### Regenerating Providers

Whenever you modify a `@riverpod` or `@Riverpod()` annotated file, regenerate:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Development Guidelines

### Adding a New Screen

1. Create the screen file in `lib/screens/`.
2. Add a path constant in `AppRoutes` (`lib/router/app_router.dart`).
3. Register the route in the `GoRouter` configuration.
4. Add any new providers in `lib/providers/`.

### Adding UI Strings

All user-facing text lives in `AppStrings` (`lib/core/constants/app_strings.dart`). Never hardcode Persian text in widget files.

### State Management Rules

- Use `@Riverpod(keepAlive: true)` for app-wide singletons (plan state, active workout).
- Use `@Riverpod()` (auto-dispose) for ephemeral state (form inputs, screen-scoped data).
- Use `ref.watch(provider.select(...))` for field-level granularity.
- Never read a provider inside `build()` without watching it (use `ref.watch` or `ref.listen`).

---

## License

Private project — all rights reserved.
