import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exo/providers/workout_provider.dart';
import 'package:exo/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = WorkoutProvider();
  await provider.loadData();
  runApp(ExoApp(provider: provider));
}

class ExoApp extends StatelessWidget {
  final WorkoutProvider provider;
  const ExoApp({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'برنامه تمرینی ۳ روزه',
        theme: ThemeData(
          colorSchemeSeed: Colors.blueGrey,
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
