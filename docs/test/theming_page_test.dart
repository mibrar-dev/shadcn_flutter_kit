// D4b theming + dark mode tests: the pages render the generated token table
// and sections, every Dart sample parses with `package:analyzer`, and the
// APIs the samples name are exercised in a real widget tree against the
// registry mirror.

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:docs/generated/app_theme.dart';
import 'package:docs/generated/docs_data.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/app/app.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/docs_samples.dart';
import 'package:docs/widgets/theme_token_table.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('theming page', () {
    testWidgets('renders the sections and the generated token table', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/theming');
      expect(find.text('Theming'), findsWidgets);
      for (final String heading in const <String>[
        'Token Convention',
        'Theme Tokens',
        'Radius Scale',
        'Presets',
        'Component Themes',
        'Animated Theming',
      ]) {
        expect(find.text(heading), findsWidgets, reason: heading);
      }
      // Generated token rows (camelCase name + CSS variable).
      expect(find.text('cardForeground'), findsWidgets);
      expect(find.text('--card-foreground'), findsWidgets);
      expect(find.text('--chart-1'), findsWidgets);
      expect(find.text('--radius'), findsWidgets);
      expect(find.byType(ThemeTokenTable), findsOneWidget);
      // The preset command from the sample.
      expect(find.text('flutter_shadcn theme apply neutral'), findsOneWidget);
    });

    test('every generated token has a docs description', () {
      for (final DocsThemeToken token in kThemeTokens) {
        expect(
          kThemeTokenDescriptions[token.name],
          isNotNull,
          reason: token.name,
        );
      }
    });
  });

  group('dark mode page', () {
    testWidgets('renders its sections', (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/docs/dark-mode');
      expect(find.text('Dark Mode'), findsWidgets);
      for (final String heading in const <String>[
        'How It Works',
        'Setting the Mode',
        'Toggling the Mode',
        'Following the System',
      ]) {
        expect(find.text(heading), findsWidgets, reason: heading);
      }
      expect(find.textContaining('ThemeMode.system'), findsWidgets);
    });
  });

  group('samples', () {
    test('every Dart sample parses without syntax errors', () {
      expect(kAllDocsSamples, isNotEmpty);
      for (final MapEntry<String, DocsSample> entry
          in kAllDocsSamples.entries) {
        final DocsSample sample = entry.value;
        expect(sample.code, isNotEmpty, reason: entry.key);
        if (sample.language != 'dart') {
          continue;
        }
        final ParseStringResult result = parseString(
          content: sample.code,
          throwIfDiagnostics: false,
        );
        expect(
          result.errors,
          isEmpty,
          reason: '${entry.key}: ${result.errors}',
        );
      }
    });

    testWidgets('the snippet APIs compile and run against the registry', (
      WidgetTester tester,
    ) async {
      final ShadcnThemeData light = buildDocsTheme('neutral', Brightness.light);
      final ShadcnThemeData dark = buildDocsTheme('neutral', Brightness.dark);
      late ShadcnThemeData resolved;
      await tester.pumpWidget(
        ShadcnApp(
          theme: light,
          darkTheme: dark,
          themeMode: ThemeMode.light,
          home: AnimatedShadcnTheme(
            data: light,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            child: ComponentTheme<ButtonTheme>(
              data: const ButtonTheme(primary: ButtonVariantStyle()),
              child: Builder(
                builder: (BuildContext context) {
                  resolved = ShadcnTheme.of(context);
                  return Button(
                    variant: ButtonVariant.primary,
                    theme: const ButtonVariantStyle(padding: EdgeInsets.zero),
                    onPressed: () {},
                    child: const Text('Save'),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Save'), findsOneWidget);
      expect(resolved.brightness, Brightness.light);
      expect(resolved.borderRadiusLg, isNotNull);
      expect(resolved.radiusSm, isNotNull);
      expect(resolved.tokens.radius, greaterThan(0));
    });
  });
}
