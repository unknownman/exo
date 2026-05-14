import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_tracker/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: WorkoutTrackerApp(),
      ),
    );

    expect(find.text('Workout Tracker'), findsOneWidget);
  });
}
