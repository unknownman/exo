import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/extensions.dart';
import '../core/constants.dart';
import '../core/app_providers.dart';
import '../main.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = context.colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final reminderAsync = ref.watch(dailyReminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: cs.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 44,
                      color: cs.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'کاربر',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppConstants.appNameFa,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : themeMode == ThemeMode.light
                            ? Icons.light_mode
                            : Icons.brightness_auto,
                    color: cs.primary,
                  ),
                  title: const Text('حالت نمایش'),
                  subtitle: Text(
                    switch (themeMode) {
                      ThemeMode.dark => 'تیره',
                      ThemeMode.light => 'روشن',
                      _ => 'همراه با سیستم',
                    },
                  ),
                  trailing: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.light_mode, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.system,
                        icon: Icon(Icons.brightness_auto, size: 16),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode, size: 16),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (v) {
                      ref.read(themeModeProvider.notifier).setTheme(v.first);
                    },
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(Icons.notifications, color: cs.primary),
                  title: const Text('یادآور روزانه'),
                  subtitle: const Text('هر روز یادآوری تمرین'),
                  value: reminderAsync.valueOrNull ?? false,
                  onChanged: (v) async {
                    await setDailyReminder(v);
                    if (v) {
                      await scheduleWorkoutReminder();
                    } else {
                      await cancelWorkoutReminder();
                    }
                    ref.invalidate(dailyReminderProvider);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.info_outline, color: cs.primary),
                  title: const Text('نسخه'),
                  trailing: Text(
                    AppConstants.appVersion,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              AppConstants.appNameFa,
              style: context.textTheme.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
