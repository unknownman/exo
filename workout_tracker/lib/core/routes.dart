import 'package:go_router/go_router.dart';
import '../features/shell_screen.dart';
import '../features/home_screen.dart';
import '../features/programs_screen.dart';
import '../features/history_screen.dart';
import '../features/profile_screen.dart';
import '../features/create_program_screen.dart';
import '../features/workout_session_screen.dart';
import '../features/exercise_detail_screen.dart';
import '../features/program_detail_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ShellScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/programs',
              name: 'programs',
              builder: (context, state) => const ProgramsScreen(),
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
              builder: (context, state) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/create-program',
      name: 'createProgram',
      builder: (context, state) => const CreateProgramScreen(),
    ),
    GoRoute(
      path: '/workout/:dayId',
      name: 'workoutSession',
      builder: (context, state) {
        final dayId = state.pathParameters['dayId'] ?? '';
        return WorkoutSessionScreen(dayId: dayId);
      },
    ),
    GoRoute(
      path: '/exercise-detail',
      name: 'exerciseDetail',
      builder: (context, state) => const ExerciseDetailScreen(),
    ),
  ],
);
