import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'core/constants.dart';
import 'data/adapters/hive_adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  HiveAdapters.register();
  await Hive.openBox(AppConstants.hiveBoxName);

  runApp(
    const ProviderScope(
      child: WorkoutTrackerApp(),
    ),
  );
}

class WorkoutTrackerApp extends ConsumerStatefulWidget {
  const WorkoutTrackerApp({super.key});

  @override
  ConsumerState<WorkoutTrackerApp> createState() => _WorkoutTrackerAppState();
}

class _WorkoutTrackerAppState extends ConsumerState<WorkoutTrackerApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(AppConstants.themePrefKey);
    setState(() {
      _themeMode = switch (value) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: appRouter,
      locale: const Locale('fa', 'IR'),
      supportedLocales: const [
        Locale('fa', 'IR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
