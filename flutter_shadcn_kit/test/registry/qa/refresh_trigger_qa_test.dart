// QA for `refresh_trigger` previews (P7-Q2).
//
// Pumps every `refreshTriggerPreviews` example under neutral/claude x
// light/dark, RTL and 375px, and pulls to refresh like a user.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/refresh_trigger/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/refresh_trigger/refresh_trigger.dart';
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
    for (final ComponentPreview preview in refreshTriggerPreviews) {
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

  testWidgets('Default list pulls to refresh and settles', (tester) async {
    await _pumpPreview(tester, refreshTriggerPreviews[0]);
    expect(find.byType(RefreshTrigger), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, 250));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
    expect(find.text('Row 0'), findsWidgets);
  });

  testWidgets('Refreshing indicator renders its stage', (tester) async {
    await _pumpPreview(tester, refreshTriggerPreviews[1]);
    expect(find.byType(DefaultRefreshIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in refreshTriggerPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
