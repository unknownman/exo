import 'package:flutter_test/flutter_test.dart';
import 'package:exo/main.dart';
import 'package:exo/providers/workout_provider.dart';

void main() {
  testWidgets('App loads home screen', (WidgetTester tester) async {
    await tester.pumpWidget(ExoApp(
      provider: WorkoutProvider(),
    ));
    await tester.pump();
    expect(find.text('برنامه تمرینی ۳ روزه'), findsOneWidget);
  });
}
