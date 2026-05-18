import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/screens/dashboard_screen.dart';
import 'package:exo/screens/workout_history_screen.dart';
import 'package:exo/screens/plan_editor_screen.dart';
import 'package:exo/screens/profile_screen.dart';
import 'package:exo/providers/active_workout_provider.dart';
import 'package:exo/core/theme/app_theme.dart';
import 'package:exo/core/constants/app_strings.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    ref.listen(
      activeWorkoutNotifierProvider.select((s) => s.snapshotRestoredMessage),
      (_, message) {
        if (message != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'ادامه',
                  onPressed: () {
                    ref.read(selectedTabProvider.notifier).state = 0;
                  },
                ),
              ),
            );
          });
          ref.read(activeWorkoutNotifierProvider.notifier).clearSnapshotMessage();
        }
      },
    );

    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: const [
          DashboardScreen(),
          WorkoutHistoryScreen(),
          PlanEditorScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) =>
            ref.read(selectedTabProvider.notifier).state = index,
        indicatorColor: AppTheme.tealPrimary.withAlpha(30),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: AppStrings.tabDashboard,
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: AppStrings.tabHistory,
          ),
          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: AppStrings.tabEditor,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: AppStrings.tabProfile,
          ),
        ],
      ),
    );
  }
}
