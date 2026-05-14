import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'core/constants.dart';
import 'core/app_providers.dart';
import 'data/adapters/hive_adapters.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  HiveAdapters.register();
  await Hive.openBox(AppConstants.hiveBoxName);

  await _initNotifications();

  runApp(
    const ProviderScope(
      child: WorkoutTrackerApp(),
    ),
  );
}

Future<void> _initNotifications() async {
  try {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(settings);
  } catch (_) {}
}

Future<void> scheduleWorkoutReminder() async {
  try {
    const androidDetails = AndroidNotificationDetails(
      'workout_reminder',
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'زمان تمرین! 💪',
      'وقتشه که یک روز عالی رو با تمرین شروع کنی',
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  } catch (_) {}
}

Future<void> cancelWorkoutReminder() async {
  try {
    await flutterLocalNotificationsPlugin.cancel(0);
  } catch (_) {}
}

class WorkoutTrackerApp extends ConsumerWidget {
  const WorkoutTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final onboardingAsync = ref.watch(onboardingCompleteProvider);

    return MaterialApp.router(
      title: AppConstants.appNameFa,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: onboardingAsync.when(
        data: (onboardingComplete) => appRouter,
        loading: () => appRouter,
        error: (_, _) => appRouter,
      ),
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
