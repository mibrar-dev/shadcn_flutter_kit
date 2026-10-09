// Widget tests for the `phone_input` component: light/dark rendering, real
// sizes, value flow, digit filtering, the country popup with case-insensitive
// search, controller swap/dispose regression, form validation, theme
// precedence and the bounded country list.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/country_flag/country_flag.dart';
import 'package:flutter_shadcn_kit/registry/components/form/form.dart';
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/components/phone_input/phone_input.dart';
import 'package:flutter_shadcn_kit/registry/components/select/select.dart';
import 'package:flutter_shadcn_kit/registry/primitives/countries.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Country _us = Country(dialCode: '+1', code: 'US');
const Country _id = Country(dialCode: '+62', code: 'ID');

/// Keeps a single `OverlayEntry` so repumping the frame updates its child.
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.child});

  final Widget child;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) => Align(alignment: Alignment.topLeft, child: widget.child),
  );

  @override
  void didUpdateWidget(covariant _OverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  void dispose() {
    _entry
      ..remove()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Overlay(initialEntries: <OverlayEntry>[_entry]);
}

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  PhoneInputTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<PhoneInputTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _OverlayHost(child: body),
      ),
    ),
  );
}

Future<void> _pump(
  WidgetTester tester, {
  PhoneNumber? initialValue,
  Country? initialCountry,
  ValueChanged<PhoneNumber?>? onChanged,
  TextEditingController? controller,
  bool onlyNumber = true,
  List<CountryInfo>? countries,
  Widget? searchPlaceholder,
  PhoneInputTheme? widgetTheme,
  PhoneInputTheme? scoped,
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ShadcnThemeData data = const ShadcnThemeData(),
}) async {
  await tester.pumpWidget(
    _frame(
      PhoneInput(
        initialValue: initialValue,
        initialCountry: initialCountry,
        onChanged: onChanged,
        controller: controller,
        onlyNumber: onlyNumber,
        countries: countries,
        searchPlaceholder: searchPlaceholder,
        theme: widgetTheme,
      ),
      data: data,
      app: app,
      scoped: scoped,
    ),
  );
  await tester.pump();
}

Future<void> _openCountryMenu(WidgetTester tester) async {
  await tester.tap(find.byType(Select<Country>));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Finder _numberField() => find.descendant(
  of: find.byType(Input),
  matching: find.byType(EditableText),
);

void main() {
  group('rendering', () {
    testWidgets('renders in light and dark with real sizes', (tester) async {
      for (final ShadcnThemeData data in <ShadcnThemeData>[
        const ShadcnThemeData(),
        const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      ]) {
        await _pump(
          tester,
          initialValue: const PhoneNumber(_us, '5551234'),
          data: data,
        );
        expect(find.byType(PhoneInput), findsOneWidget);
        expect(find.byType(Select<Country>), findsOneWidget);
        expect(find.byType(CountryFlag), findsOneWidget);
        expect(find.text('+1'), findsOneWidget);
        expect(find.text('+15551234'), findsOneWidget);
        expect(tester.getSize(find.byType(Select<Country>)).height, 36);
        expect(tester.getSize(find.byType(Select<Country>)).width, 180);
        expect(tester.getSize(find.byType(Input)).height, 36);
        expect(tester.getSize(find.byType(Input)).width, 200);
        expect(tester.getSize(find.byType(CountryFlag)), const Size(24, 18));
      }
    });

    testWidgets(
      'initialCountry seeds the selector and the field starts empty',
      (tester) async {
        await _pump(tester, initialCountry: _id);
        expect(find.text('+62'), findsOneWidget);
        expect(find.text('812345678'), findsNothing);
      },
    );
  });

  group('value flow', () {
    testWidgets(
      'typing reports PhoneNumber(country, text); empty reports null',
      (tester) async {
        final List<PhoneNumber?> values = <PhoneNumber?>[];
        await _pump(
          tester,
          initialValue: const PhoneNumber(_id, '812'),
          onChanged: values.add,
        );
        await tester.enterText(_numberField(), '812345678');
        await tester.pump();
        expect(values.last, const PhoneNumber(_id, '812345678'));
        await tester.enterText(_numberField(), '');
        await tester.pump();
        expect(values.last, isNull);
      },
    );

    testWidgets('onlyNumber filters non-digits; false keeps letters', (
      tester,
    ) async {
      await _pump(tester, onChanged: (_) {});
      await tester.enterText(_numberField(), '12ab34');
      await tester.pump();
      expect(find.text('1234'), findsOneWidget);

      await _pump(tester, onlyNumber: false, onChanged: (_) {});
      await tester.enterText(_numberField(), '12ab34');
      await tester.pump();
      expect(find.text('12ab34'), findsOneWidget);
    });

    testWidgets('selection-only changes never fire onChanged', (tester) async {
      // Regression: the old controller listener ran detection and onChanged
      // on every caret move, not only on text edits.
      final TextEditingController controller = TextEditingController(
        text: '555',
      );
      addTearDown(controller.dispose);
      int calls = 0;
      await _pump(
        tester,
        controller: controller,
        initialCountry: _us,
        onChanged: (_) => calls++,
      );
      controller.selection = const TextSelection.collapsed(offset: 1);
      await tester.pump();
      expect(calls, 0);
      controller.text = '5551';
      await tester.pump();
      expect(calls, 1);
    });

    testWidgets('the popup changes the country and reports it', (tester) async {
      final List<PhoneNumber?> values = <PhoneNumber?>[];
      await _pump(
        tester,
        initialValue: const PhoneNumber(_us, '555'),
        onChanged: values.add,
      );
      await _openCountryMenu(tester);
      await tester.enterText(find.byType(EditableText).last, 'Indonesia');
      await tester.pump();
      await tester.tap(find.byType(SelectItem<Country>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('+62'), findsOneWidget);
      expect(values.last, const PhoneNumber(_id, '555'));
    });

    testWidgets('a typed dial-code prefix selects the country', (tester) async {
      final List<PhoneNumber?> values = <PhoneNumber?>[];
      await _pump(tester, initialCountry: _us, onChanged: values.add);
      await tester.enterText(_numberField(), '+353555');
      await tester.pump();
      expect(find.text('+353'), findsOneWidget); // the selector trigger
      expect(
        values.last,
        const PhoneNumber(Country(dialCode: '+353', code: 'IE'), '555'),
      );
    });

    testWidgets('shared dial codes resolve to the primary country', (
      tester,
    ) async {
      // Regression: +44 used to resolve to Guernsey (first table row); shared
      // codes now pick the row marked `primary`.
      final List<PhoneNumber?> values = <PhoneNumber?>[];
      await _pump(tester, initialCountry: _us, onChanged: values.add);
      await tester.enterText(_numberField(), '+1555');
      await tester.pump();
      expect(values.last?.country, _us, reason: '+1 -> US');
      await tester.enterText(_numberField(), '+7555');
      await tester.pump();
      expect(
        values.last?.country,
        const Country(dialCode: '+7', code: 'RU'),
        reason: '+7 -> RU',
      );
      await tester.enterText(_numberField(), '+44555');
      await tester.pump();
      expect(
        values.last,
        const PhoneNumber(Country(dialCode: '+44', code: 'GB'), '555'),
        reason: '+44 -> GB',
      );
      await tester.enterText(_numberField(), '+64555');
      await tester.pump();
      expect(
        values.last?.country,
        const Country(dialCode: '+64', code: 'NZ'),
        reason: '+64 -> NZ (found by the audit, not in the QA list)',
      );
      await tester.enterText(_numberField(), '+590555');
      await tester.pump();
      expect(
        values.last?.country,
        const Country(dialCode: '+590', code: 'GP'),
        reason: '+590 -> GP',
      );
    });

    testWidgets('the longest dial code wins', (tester) async {
      final List<PhoneNumber?> values = <PhoneNumber?>[];
      await _pump(tester, initialCountry: _us, onChanged: values.add);
      await tester.enterText(_numberField(), '+1242555');
      await tester.pump();
      expect(
        values.last?.country,
        const Country(dialCode: '+1242', code: 'BS'),
        reason: '+1242 beats +1',
      );
      expect(values.last?.number, '555');
    });

    testWidgets('shared dial codes prefer the current selection', (
      tester,
    ) async {
      const Country canada = Country(dialCode: '+1', code: 'CA');
      final List<PhoneNumber?> values = <PhoneNumber?>[];
      await _pump(tester, initialCountry: canada, onChanged: values.add);
      await tester.enterText(_numberField(), '+1555');
      await tester.pump();
      expect(values.last?.country, canada, reason: 'CA shares +1 with US');
      expect(values.last?.number, '555');
    });

    testWidgets('a custom country list bounds detection', (tester) async {
      final List<PhoneNumber?> values = <PhoneNumber?>[];
      await _pump(
        tester,
        countries: const <CountryInfo>[
          CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
          CountryInfo('IE', '+353', 'EUR', 'Ireland'),
        ],
        onChanged: values.add,
      );
      await tester.enterText(_numberField(), '+33555');
      await tester.pump();
      expect(values.last?.country, _us, reason: 'France is not in the list');
      expect(values.last?.number, '+33555');
      await tester.enterText(_numberField(), '+353555');
      await tester.pump();
      expect(
        values.last,
        const PhoneNumber(Country(dialCode: '+353', code: 'IE'), '555'),
      );
    });

    testWidgets('the selector rewrites the prefix', (tester) async {
      final List<PhoneNumber?> values = <PhoneNumber?>[];
      await _pump(
        tester,
        initialValue: const PhoneNumber(_us, '555'),
        onChanged: values.add,
      );
      expect(find.text('+1555'), findsOneWidget);
      await _openCountryMenu(tester);
      await tester.enterText(find.byType(EditableText).last, 'Indonesia');
      await tester.pump();
      await tester.tap(find.byType(SelectItem<Country>));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('+62555'), findsOneWidget);
      expect(values.last, const PhoneNumber(_id, '555'));
    });

    testWidgets('country search is case-insensitive and matches codes', (
      tester,
    ) async {
      // Regression: the old filter lowercased the row but not the query.
      await _pump(tester, initialCountry: _us, onChanged: (_) {});
      await _openCountryMenu(tester);
      await tester.enterText(find.byType(EditableText).last, 'IndoneSIA');
      await tester.pump();
      expect(find.text('Indonesia'), findsOneWidget);
      expect(find.text('United States'), findsNothing);
      await tester.enterText(find.byType(EditableText).last, 'ID');
      await tester.pump();
      expect(find.text('Indonesia'), findsOneWidget);
    });

    testWidgets('a custom country list bounds the popup', (tester) async {
      await _pump(
        tester,
        countries: const <CountryInfo>[
          CountryInfo('GB', '+44', 'GBP', 'United Kingdom'),
          CountryInfo('IE', '+353', 'EUR', 'Ireland'),
        ],
        onChanged: (_) {},
      );
      await _openCountryMenu(tester);
      expect(find.text('United Kingdom'), findsOneWidget);
      expect(find.text('Ireland'), findsOneWidget);
      expect(find.text('Indonesia'), findsNothing);
    });

    testWidgets('searchPlaceholder reaches the popup search field', (
      tester,
    ) async {
      await _pump(
        tester,
        initialCountry: _us,
        searchPlaceholder: const Text('Find a country'),
        onChanged: (_) {},
      );
      await _openCountryMenu(tester);
      expect(find.text('Find a country'), findsOneWidget);
    });
  });

  group('controller', () {
    testWidgets(
      'external controllers are not seeded; swaps re-attach cleanly',
      (tester) async {
        // Regressions: the old code rewrote an external controller in initState
        // and leaked it on a controller swap.
        final TextEditingController first = TextEditingController(text: '111');
        final TextEditingController second = TextEditingController(text: '222');
        addTearDown(first.dispose);
        addTearDown(second.dispose);
        int calls = 0;
        await _pump(
          tester,
          controller: first,
          initialValue: const PhoneNumber(_us, '999'),
          onChanged: (_) => calls++,
        );
        expect(find.text('111'), findsOneWidget);
        await _pump(
          tester,
          controller: second,
          initialValue: const PhoneNumber(_us, '999'),
          onChanged: (_) => calls++,
        );
        expect(find.text('222'), findsOneWidget);
        first.text = '333';
        await tester.pump();
        expect(find.text('333'), findsNothing);
        expect(calls, 0);
      },
    );

    testWidgets('an owned controller is seeded from initialValue', (
      tester,
    ) async {
      await _pump(
        tester,
        initialValue: const PhoneNumber(_id, '812345678'),
        onChanged: (_) {},
      );
      expect(find.text('+62812345678'), findsOneWidget);
    });
  });

  group('form', () {
    testWidgets('form field validates and updates its value', (tester) async {
      PhoneNumber? stored;
      await tester.pumpWidget(
        _frame(
          ShadcnForm(
            child: ShadcnFormField<PhoneNumber>(
              key: const FormKey<PhoneNumber>('phone'),
              label: const Text('Phone'),
              validator: const PhoneNumberValidator(),
              child: PhoneInput(
                initialCountry: _us,
                onChanged: (value) => stored = value,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('Phone number is required.'), findsOneWidget);
      await tester.enterText(_numberField(), '5551234');
      await tester.pump();
      await tester.pump();
      expect(stored, const PhoneNumber(_us, '5551234'));
      expect(find.text('Phone number is required.'), findsNothing);
    });

    testWidgets('validator messages and success paths', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Builder(
            builder: (BuildContext ctx) {
              context = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      const PhoneNumberValidator validator = PhoneNumberValidator();
      final ValidationResult? empty = await validator.validate(
        context,
        null,
        FormValidationMode.changed,
      );
      expect((empty! as InvalidResult).message, 'Phone number is required.');
      final ValidationResult? invalid = await validator.validate(
        context,
        const PhoneNumber(null, '123'),
        FormValidationMode.changed,
      );
      expect((invalid! as InvalidResult).message, 'Phone number is invalid.');
      final ValidationResult? emptyNumber = await validator.validate(
        context,
        const PhoneNumber(_us, ''),
        FormValidationMode.changed,
      );
      expect(emptyNumber, isNotNull);
      final ValidationResult? ok = await validator.validate(
        context,
        const PhoneNumber(_us, '555'),
        FormValidationMode.changed,
      );
      expect(ok, isNull);
    });
  });

  group('theme', () {
    testWidgets('precedence: widget > tree > app > defaults', (tester) async {
      double fieldWidth() => tester.getSize(find.byType(Input)).width;
      await _pump(tester);
      expect(fieldWidth(), 200);
      const PhoneInputTheme app = PhoneInputTheme(maxWidth: 240);
      await _pump(tester, app: <ComponentThemeData>[app]);
      expect(fieldWidth(), 240);
      await _pump(
        tester,
        app: <ComponentThemeData>[app],
        scoped: const PhoneInputTheme(maxWidth: 220),
      );
      expect(fieldWidth(), 220);
      await _pump(
        tester,
        app: <ComponentThemeData>[app],
        scoped: const PhoneInputTheme(maxWidth: 220),
        widgetTheme: const PhoneInputTheme(maxWidth: 180),
      );
      expect(fieldWidth(), 180);
    });

    testWidgets('per-field merge keeps the lower leg remaining fields', (
      tester,
    ) async {
      await _pump(
        tester,
        app: const <ComponentThemeData>[PhoneInputTheme(selectWidth: 150)],
        scoped: const PhoneInputTheme(maxWidth: 210),
      );
      expect(tester.getSize(find.byType(Input)).width, 210);
      expect(tester.getSize(find.byType(Select<Country>)).width, 150);
    });
  });
}
