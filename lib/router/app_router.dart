import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../screens/shell_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/workout_history_screen.dart';
import '../screens/plan_editor_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/active_workout_screen.dart';
import '../screens/rest_screen.dart';
import '../screens/add_exercise_screen.dart';
import '../screens/create_plan_screen.dart';
import '../screens/exercise_analytics_screen.dart';

part 'app_router.g.dart';

class AppRoutes {
  static const dashboard = '/dashboard';
  static const history = '/history';
  static const editor = '/editor';
  static const profile = '/profile';
  static const activeWorkout = '/active-workout';
  static const rest = '/rest';
  static const addExercise = '/add-exercise';
  static const createPlan = '/create-plan';
  static const dayDetail = '/day-detail';
  static const exerciseAnalytics = '/exercise-analytics';
}

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      if (state.matchedLocation == '/') return AppRoutes.dashboard;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                builder: (context, state) => const WorkoutHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.editor,
                builder: (context, state) => const PlanEditorScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.activeWorkout}/:dayId',
        builder: (context, state) {
          final dayId = state.pathParameters['dayId']!;
          return ActiveWorkoutScreen(dayId: dayId);
        },
      ),
      GoRoute(
        path: AppRoutes.rest,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          fullscreenDialog: true,
          child: const RestScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.addExercise,
        builder: (context, state) => const AddExerciseScreen(),
      ),
      GoRoute(
        path: AppRoutes.createPlan,
        builder: (context, state) => const CreatePlanScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.dayDetail}/:dayId',
        builder: (context, state) {
          final dayId = state.pathParameters['dayId']!;
          return DayDetailScreen(dayId: dayId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.exerciseAnalytics}/:exerciseId',
        builder: (context, state) {
          final exerciseId = state.pathParameters['exerciseId']!;
          final exerciseName = state.extra as String? ?? '';
          return ExerciseAnalyticsScreen(
            exerciseId: exerciseId,
            exerciseName: exerciseName,
          );
        },
      ),
    ],
  );
}
