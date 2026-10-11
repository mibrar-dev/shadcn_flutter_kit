// QA for `spinner` previews (P7-Q2): behaviour, spacing, functionality.
//
// Pumps every `spinnerPreviews` example under neutral/claude x light/dark,
// RTL and 375px, and advances the rotation animation to prove it never throws.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/spinner/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/spinner/spinner.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../themes/generated_theme.dart';

final Map<String, GeneratedTheme> _presets = <String, GeneratedTheme>{};

ShadcnThemeData _theme(String preset, Brightness brightness) {
  final GeneratedTheme theme = _presets.putIfAbsent(
    preset,
    () => loadGeneratedTheme('lib/registry/themes/$preset.json'),
  );
  final view = theme.view(brightness);
  return ShadcnThemeData(
    colors: view.colors,
    tokens: view.tokens,
    fonts: view.fonts,
  );
}

Future<void> _pumpPreview(
  WidgetTester tester,
  ComponentPreview preview, {
  String preset = 'neutral',
  Brightness brightness = Brightness.light,
  TextDirection direction = TextDirection.ltr,
  double width = 360,
}) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: _theme(preset, brightness),
      child: Directionality(
        textDirection: direction,
        child: Overlay.wrap(
          child: Center(
            child: SizedBox(
              width: width,
              child: Builder(builder: preview.builder),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(
    tester.takeException(),
    isNull,
    reason: 'preview "${preview.name}" threw',
  );
}

void main() {
  testWidgets('every preview pumps neutral/claude x light/dark', (
    tester,
  ) async {
    for (final ComponentPreview preview in spinnerPreviews) {
      for (final String preset in const <String>['neutral', 'claude']) {
        for (final Brightness brightness in Brightness.values) {
          await _pumpPreview(
            tester,
            preview,
            preset: preset,
            brightness: brightness,
          );
        }
      }
    }
  });

  testWidgets('Default preview shows the size scale and keeps spinning', (
    tester,
  ) async {
    await _pumpPreview(tester, spinnerPreviews[0]);
    expect(find.byType(Spinner), findsWidgets);
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
    // All spinners still mounted after several rotations.
    expect(find.byType(Spinner), findsWidgets);
  });

  testWidgets('Small preview pairs the spinner with its label', (tester) async {
    await _pumpPreview(tester, spinnerPreviews[1]);
    expect(find.byType(Spinner), findsOneWidget);
    expect(find.text('Loading...'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in spinnerPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
