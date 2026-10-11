// QA for `star_rating` previews (P7-Q2).
//
// Pumps every `starRatingPreviews` example under neutral/claude x light/dark,
// RTL and 375px, and taps the interactive rating at both ends like a user:
// the tap position maps to the value and the slider semantics report it.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/star_rating/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/star_rating/star_rating.dart';
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

Finder _sliderValue(String value) => find.byWidgetPredicate(
  (Widget w) => w is Semantics && w.properties.value == value,
);

void main() {
  testWidgets('every preview pumps neutral/claude x light/dark', (
    tester,
  ) async {
    for (final ComponentPreview preview in starRatingPreviews) {
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

  testWidgets('Default rating sets value by tap position', (tester) async {
    await _pumpPreview(tester, starRatingPreviews[0]);
    expect(find.byType(StarRating), findsOneWidget);
    expect(_sliderValue('3.5'), findsOneWidget);
    final Finder rating = find.byType(StarRating);
    final Offset center = tester.getCenter(rating);
    final Size size = tester.getSize(rating);
    await tester.tapAt(center + Offset(size.width / 2 - 2, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    expect(_sliderValue('5.0'), findsOneWidget);
    await tester.tapAt(center - Offset(size.width / 2 - 2, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    expect(_sliderValue('0.0'), findsOneWidget);
  });

  testWidgets('Read-only and disabled ratings ignore taps', (tester) async {
    await _pumpPreview(tester, starRatingPreviews[1]);
    await tester.tap(find.byType(StarRating));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
    await _pumpPreview(tester, starRatingPreviews[3]);
    await tester.tap(find.byType(StarRating));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in starRatingPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
