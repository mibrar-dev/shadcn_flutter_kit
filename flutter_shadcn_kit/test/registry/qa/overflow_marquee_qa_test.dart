// QA for `overflow_marquee` previews (P7-Q2).
//
// Pumps every `overflowMarqueePreviews` example under neutral/claude x
// light/dark, RTL and 375px, and advances the clock past full ticker cycles
// to prove the animation loops without exceptions.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/overflow_marquee/overflow_marquee.dart';
import 'package:flutter_shadcn_kit/registry/components/overflow_marquee/preview.dart';
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
    for (final ComponentPreview preview in overflowMarqueePreviews) {
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

  testWidgets('horizontal ticker loops past a full cycle', (tester) async {
    await _pumpPreview(tester, overflowMarqueePreviews[0]);
    expect(find.byType(OverflowMarquee), findsOneWidget);
    await tester.pump(const Duration(seconds: 7));
    expect(tester.takeException(), isNull);
    expect(find.byType(OverflowMarquee), findsOneWidget);
  });

  testWidgets('vertical ticker loops past a full cycle', (tester) async {
    await _pumpPreview(tester, overflowMarqueePreviews[1]);
    expect(find.byType(OverflowMarquee), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
    expect(find.byType(OverflowMarquee), findsOneWidget);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in overflowMarqueePreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
