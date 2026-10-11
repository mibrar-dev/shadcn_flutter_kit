// QA for `keyboard_shortcut` previews (P7-Q2).
//
// Pumps every `keyboardShortcutPreviews` example under neutral/claude x
// light/dark, RTL and 375px. The component is display-only; this file pins
// that activator chords, explicit key rows and scoped labels all render.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/keyboard_shortcut/keyboard_shortcut.dart';
import 'package:flutter_shadcn_kit/registry/components/keyboard_shortcut/preview.dart';
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
    for (final ComponentPreview preview in keyboardShortcutPreviews) {
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

  testWidgets('chords render caps for every key', (tester) async {
    await _pumpPreview(tester, keyboardShortcutPreviews[0]);
    expect(find.byType(KeyboardShortcut), findsOneWidget);
    expect(find.byType(KeyboardKeyCap), findsWidgets);
    await _pumpPreview(tester, keyboardShortcutPreviews[1]);
    expect(find.byType(KeyboardShortcut), findsNWidgets(3));
  });

  testWidgets('scoped preview uses the custom uppercase labels', (
    tester,
  ) async {
    await _pumpPreview(tester, keyboardShortcutPreviews[2]);
    // Alt + F through the scope builder render as uppercase text.
    expect(find.text('ALT'), findsOneWidget);
    expect(find.text('F'), findsOneWidget);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in keyboardShortcutPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
