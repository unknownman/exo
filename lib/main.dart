import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/screens/shell_screen.dart';
import 'package:exo/core/theme/app_theme.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ExoApp()));
}

class ExoApp extends StatelessWidget {
  const ExoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'برنامه تمرینی ۳ روزه',
        locale: const Locale('fa', 'IR'),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const ShellScreen(),
      ),
    );
  }
}
