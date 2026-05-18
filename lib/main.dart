import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:exo/screens/shell_screen.dart';
import 'package:exo/core/theme/app_theme.dart';
import 'package:exo/core/constants/app_constants.dart';
import 'package:exo/core/hive/adapters.dart';
import 'package:exo/providers/storage_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ExerciseMediaAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(WorkoutDayAdapter());
  Hive.registerAdapter(WorkoutPlanAdapter());
  Hive.registerAdapter(WorkoutLogAdapter());

  late Box appBox;
  try {
    appBox = await Hive.openBox(AppConstants.appDataBox);
  } catch (_) {
    await Hive.deleteBoxFromDisk(AppConstants.appDataBox);
    appBox = await Hive.openBox(AppConstants.appDataBox);
  }

  late Box snapshotBox;
  try {
    snapshotBox = await Hive.openBox(AppConstants.activeWorkoutSnapshotBox);
  } catch (_) {
    await Hive.deleteBoxFromDisk(AppConstants.activeWorkoutSnapshotBox);
    snapshotBox = await Hive.openBox(AppConstants.activeWorkoutSnapshotBox);
  }

  runApp(
    ProviderScope(
      overrides: [
        appBoxProvider.overrideWithValue(appBox),
        snapshotBoxProvider.overrideWithValue(snapshotBox),
      ],
      child: const ExoApp(),
    ),
  );
}

class ExoApp extends StatelessWidget {
  const ExoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'برنامه تمرینی ۳ روزه',
      locale: const Locale('fa', 'IR'),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const ShellScreen(),
    );
  }
}
