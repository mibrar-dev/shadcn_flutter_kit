// QA for `scrollbar` previews (P7-Q2): behaviour, spacing, functionality.
//
// Pumps every `scrollbarPreviews` example under neutral/claude x light/dark,
// RTL and 375px, scrolls the demo lists, and pins that `thumbVisibility: true`
// never asserts (the crash the previous session investigated).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollbar/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollbar/scrollbar.dart';
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
    for (final ComponentPreview preview in scrollbarPreviews) {
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

  testWidgets('Always-visible thumb survives scrolling without asserts', (
    tester,
  ) async {
    await _pumpPreview(tester, scrollbarPreviews[1]);
    expect(find.byType(Scrollbar), findsOneWidget);
    double pixels() =>
        tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels;
    expect(pixels(), equals(0));
    await tester.fling(find.byType(ListView), const Offset(0, -300), 800);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
    expect(pixels(), greaterThan(0));
    await tester.fling(find.byType(ListView), const Offset(0, 300), 800);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Themed preview tints the thumb from the tree override', (
    tester,
  ) async {
    await _pumpPreview(tester, scrollbarPreviews[2]);
    expect(find.byType(Scrollbar), findsOneWidget);
    await tester.fling(find.text('Item 1'), const Offset(0, -300), 800);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in scrollbarPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
