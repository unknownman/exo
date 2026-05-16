import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/screens/dashboard_screen.dart';
import 'package:exo/screens/workout_history_screen.dart';
import 'package:exo/screens/plan_editor_screen.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTab = ref.watch(selectedTabProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: IndexedStack(
          index: selectedTab,
          children: const [
            DashboardScreen(),
            WorkoutHistoryScreen(),
            PlanEditorScreen(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedTab,
          onTap: (index) =>
              ref.read(selectedTabProvider.notifier).state = index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'داشبورد',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'تاریخچه',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit_note),
              label: 'ویرایشگر',
            ),
          ],
        ),
      ),
    );
  }
}
