import 'package:flutter_test/flutter_test.dart';
import 'package:santhali_keyboard/main.dart';

void main() {
  testWidgets('Santhali Keyboard App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SanthaliKeyboardApp());

    // Verify that our welcome page shows 'Ol Chiki'
    expect(find.text('Ol Chiki'), findsOneWidget);
  });
}
