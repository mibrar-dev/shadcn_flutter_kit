import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_cli_verification_example/main.dart';

void main() {
  testWidgets('verification harness smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(VerificationHarnessScreen), findsOneWidget);
    expect(find.text('Registry Verification Harness'), findsOneWidget);
    expect(
      find.text(
        'Exercises the locally installed button, text field, and dialog components.',
      ),
      findsOneWidget,
    );
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Open Dialog'), findsOneWidget);
  });
}
