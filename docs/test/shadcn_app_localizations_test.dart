import 'package:docs/ui/shadcn/components/layout/app/app.dart';
import 'package:docs/ui/shadcn/shared/localizations/shadcn_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ShadcnApp exposes ShadcnLocalizations to descendants', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ShadcnApp(
        locale: Locale('en'),
        supportedLocales: ShadcnLocalizations.supportedLocales,
        home: _LocalizationsProbe(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Must be at least 4 characters.'), findsOneWidget);
  });
}

class _LocalizationsProbe extends StatelessWidget {
  const _LocalizationsProbe();

  @override
  Widget build(BuildContext context) {
    final localizations = Localizations.of<ShadcnLocalizations>(
      context,
      ShadcnLocalizations,
    );
    final text = localizations?.formLengthLessThan(4) ?? 'missing';
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(text),
    );
  }
}
