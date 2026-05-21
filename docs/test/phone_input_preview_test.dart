import 'package:docs/pages/docs/component_previews.dart';
import 'package:docs/pages/docs/components/phone_input/phone_input_example_1.dart';
import 'package:docs/ui/shadcn/components/form/phone_input/phone_input.dart';
import 'package:docs/ui/shadcn/components/form/phone_input/preview.dart';
import 'package:docs/ui/shadcn/components/layout/app/app.dart';
import 'package:docs/ui/shadcn/shared/localizations/shadcn_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phonecodes/phonecodes.dart' show Country;

void main() {
  testWidgets('phone input preview renders selected country and input field', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ShadcnApp(
        locale: Locale('en'),
        supportedLocales: ShadcnLocalizations.supportedLocales,
        home: PhoneInputPreview(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('+1'), findsOneWidget);
    expect(find.byType(EditableText), findsOneWidget);
  });

  testWidgets('phone input docs example paints the visible control', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ShadcnApp(
        locale: Locale('en'),
        supportedLocales: ShadcnLocalizations.supportedLocales,
        home: Center(child: PhoneInputExample1()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('+62'), findsOneWidget);
    expect(find.byType(EditableText), findsOneWidget);

    final countrySize = tester.getSize(find.text('+62'));
    final editableSize = tester.getSize(find.byType(EditableText));
    expect(countrySize.width, greaterThan(0));
    expect(countrySize.height, greaterThan(0));
    expect(editableSize.height, greaterThan(0));
  });

  testWidgets('phone input initial value is owned by its controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ShadcnApp(
        locale: Locale('en'),
        supportedLocales: ShadcnLocalizations.supportedLocales,
        home: PhoneInput(
          initialValue: PhoneNumber(Country.indonesia, '812345678'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('+62'), findsOneWidget);
    expect(find.text('812345678'), findsOneWidget);
  });

  testWidgets('phone input is registered for component card previews', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadcnApp(
        locale: const Locale('en'),
        supportedLocales: ShadcnLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => buildComponentPreview(context, 'phone_input'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('+1'), findsOneWidget);
    expect(find.byType(EditableText), findsOneWidget);
  });
}
