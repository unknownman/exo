import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/app_providers.dart';
import '../features/shell_screen.dart';
import '../features/home_screen.dart';
import '../features/programs_screen.dart';
import '../features/history_screen.dart';
import '../features/profile_screen.dart';
import '../features/create_program_screen.dart';
import '../features/workout_session_screen.dart';
import '../features/exercise_detail_screen.dart';
import '../features/program_detail_screen.dart';
import '../features/onboarding_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final onboarding = container.read(onboardingCompleteProvider);
    final isOnboarding = state.matchedLocation == '/onboarding';

    if (onboarding is AsyncData && !onboarding.requireValue && !isOnboarding) {
      return '/onboarding';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (_, _) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ShellScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const HomeScreen(),
                transitionsBuilder: (_, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/programs',
              name: 'programs',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProgramsScreen(),
                transitionsBuilder: (_, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'programDetail',
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return ProgramDetailScreen(programId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              name: 'history',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const HistoryScreen(),
                transitionsBuilder: (_, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
                transitionsBuilder: (_, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/create-program',
      name: 'createProgram',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CreateEditProgramScreen(),
        transitionsBuilder: (_, animation, _, child) =>
            ScaleTransition(scale: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/edit-program/:id',
      name: 'editProgram',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return CreateEditProgramScreen(programId: id);
      },
    ),
    GoRoute(
      path: '/workout/:programId/:dayId',
      name: 'workoutSession',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: WorkoutSessionScreen(
          programId: state.pathParameters['programId'] ?? '',
          dayId: state.pathParameters['dayId'] ?? '',
        ),
        transitionsBuilder: (_, animation, _, child) =>
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
      ),
    ),
    GoRoute(
      path: '/exercise-detail',
      name: 'exerciseDetail',
      builder: (context, state) => const ExerciseDetailScreen(),
    ),
  ],
);
