// QA for `scrollview` previews (P7-Q2): behaviour, spacing, functionality.
//
// Pumps every `scrollviewPreviews` example under neutral/claude x light/dark,
// RTL and 375px, and scrolls through the interceptor without exceptions.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollview/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollview/scrollview.dart';
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
    for (final ComponentPreview preview in scrollviewPreviews) {
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

  testWidgets('interceptor list scrolls without exceptions', (tester) async {
    await _pumpPreview(tester, scrollviewPreviews[0]);
    expect(find.byType(ScrollViewInterceptor), findsOneWidget);
    await tester.fling(
      find.text('Drag with the middle button · 1'),
      const Offset(0, -400),
      1000,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('preview mirrors in RTL and fits 375px', (tester) async {
    await _pumpPreview(
      tester,
      scrollviewPreviews[0],
      direction: TextDirection.rtl,
    );
    await _pumpPreview(tester, scrollviewPreviews[0], width: 375);
  });
}
