
import 'package:flutter_test/flutter_test.dart';
import 'package:Stryve/main.dart';

void main() {
  testWidgets('Fit Journey starts successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FitnessApp());

    expect(find.text('Fit Journey'), findsOneWidget);
  });
}

