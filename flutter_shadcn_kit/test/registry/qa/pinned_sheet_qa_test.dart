// QA for `pinned_sheet` previews (P7-Q2).
//
// Pumps every `pinnedSheetPreviews` example under neutral/claude x light/dark,
// RTL and 375px, snaps between stages with the buttons, and drags the sheet
// like a user.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/pinned_sheet/pinned_sheet.dart';
import 'package:flutter_shadcn_kit/registry/components/pinned_sheet/preview.dart';
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
    for (final ComponentPreview preview in pinnedSheetPreviews) {
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

  testWidgets('Default sheet drags between stages', (tester) async {
    await _pumpPreview(tester, pinnedSheetPreviews[0]);
    expect(find.byType(PinnedSheet), findsOneWidget);
    expect(find.text('Sheet content'), findsOneWidget);
    final double before = tester.getTopLeft(find.text('Sheet content')).dy;
    // The sheet starts at the 0.4 stage, so most of the body sits below the
    // box (off-viewport, unhittable): drag from the visible strip near the
    // bottom of the 280px box, far enough to settle on `expanded`.
    await tester.dragFrom(const Offset(400, 400), const Offset(0, -150));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    final double after = tester.getTopLeft(find.text('Sheet content')).dy;
    expect(after, isNot(equals(before)));
  });

  testWidgets('Snapping buttons move the sheet without exceptions', (
    tester,
  ) async {
    await _pumpPreview(tester, pinnedSheetPreviews[1]);
    for (final String label in const <String>['Close', 'Half', 'Open']) {
      await tester.tap(find.text(label));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull);
    }
    expect(find.text('Sheet content'), findsOneWidget);
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in pinnedSheetPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
