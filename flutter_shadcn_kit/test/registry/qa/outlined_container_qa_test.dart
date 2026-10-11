// QA for `outlined_container` previews (P7-Q2).
//
// Pumps every `outlinedContainerPreviews` example under neutral/claude x
// light/dark, RTL and 375px. The component is display-only; this file pins
// that token, rounded, translucent/blur and dashed forms all render.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/outlined_container/outlined_container.dart';
import 'package:flutter_shadcn_kit/registry/components/outlined_container/preview.dart';
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
    for (final ComponentPreview preview in outlinedContainerPreviews) {
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

  testWidgets('all surface forms render their content', (tester) async {
    await _pumpPreview(tester, outlinedContainerPreviews[0]);
    expect(find.text('Outlined container'), findsOneWidget);
    expect(find.byType(OutlinedContainer), findsOneWidget);
    await _pumpPreview(tester, outlinedContainerPreviews[1]);
    expect(find.text('Rounded corners'), findsOneWidget);
    await _pumpPreview(tester, outlinedContainerPreviews[2]);
    expect(find.text('Translucent primary fill'), findsOneWidget);
    expect(find.text('Backdrop blur'), findsOneWidget);
    await _pumpPreview(tester, outlinedContainerPreviews[3]);
    expect(find.text('Dashed container'), findsOneWidget);
    expect(find.byType(DashedContainer), findsOneWidget);
    expect(find.byType(DashedLine), findsOneWidget);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in outlinedContainerPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
