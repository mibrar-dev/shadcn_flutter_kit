// QA for `resizable` previews (P7-Q2): behaviour, spacing, functionality.
//
// Pumps every `resizablePreviews` example under neutral/claude x light/dark,
// RTL and 375px, and drags the divider like a user. Below-minimum overflow is
// pinned in `_probe_p7q2_test.dart` (CSS-like, not a bug); this file pins that
// the previews drag cleanly.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/resizable/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/resizable/resizable.dart';
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

Future<void> _dragDivider(WidgetTester tester, double dx) async {
  final Finder handle = find.byType(ResizableHandleView);
  expect(handle, findsOneWidget);
  final Offset center = tester.getCenter(handle);
  await tester.dragFrom(center, Offset(dx, 0));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(tester.takeException(), isNull);
}

void main() {
  testWidgets('every preview pumps neutral/claude x light/dark', (
    tester,
  ) async {
    for (final ComponentPreview preview in resizablePreviews) {
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

  testWidgets('Absolute preview divider drag resizes panes', (tester) async {
    await _pumpPreview(tester, resizablePreviews[0]);
    expect(find.text('Sidebar'), findsOneWidget);
    expect(find.text('Main'), findsOneWidget);
    final Finder panels = find.byType(ResizablePanel);
    expect(panels, findsNWidgets(2));
    final double before = tester.getSize(panels.first).width;
    await _dragDivider(tester, 40);
    final double after = tester.getSize(panels.first).width;
    expect(after, isNot(equals(before)));
  });

  testWidgets('Flexible preview divider drag resizes panes', (tester) async {
    await _pumpPreview(tester, resizablePreviews[1]);
    expect(find.text('Main'), findsOneWidget);
    expect(find.text('Inspector'), findsOneWidget);
    final Finder panels = find.byType(ResizablePanel);
    expect(panels, findsNWidgets(2));
    final double before = tester.getSize(panels.first).width;
    await _dragDivider(tester, -40);
    final double after = tester.getSize(panels.first).width;
    expect(after, isNot(equals(before)));
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in resizablePreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
