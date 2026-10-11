// QA for `sortable` previews (P7-Q2).
//
// Pumps every `sortablePreviews` example under neutral/claude x light/dark,
// RTL and 375px, and drags items to reorder like a user.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/sortable/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/sortable/sortable.dart';
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

Future<void> _dragOnto(
  WidgetTester tester,
  String dragged,
  String target, {
  Offset dropBias = const Offset(0, -12),
}) async {
  final Offset from = tester.getCenter(find.text(dragged));
  final Offset to = tester.getCenter(find.text(target));
  final TestGesture gesture = await tester.startGesture(from);
  // Land clearly inside the target's top half: dead-center lands on the
  // top/bottom boundary and may resolve to a no-op move.
  await gesture.moveTo(to + dropBias);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  await gesture.up();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 500));
  expect(tester.takeException(), isNull);
}

void main() {
  testWidgets('every preview pumps neutral/claude x light/dark', (
    tester,
  ) async {
    for (final ComponentPreview preview in sortablePreviews) {
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

  testWidgets('Default list reorders on drag', (tester) async {
    await _pumpPreview(tester, sortablePreviews[0]);
    expect(
      tester.getTopLeft(find.text('Alpha')).dy,
      lessThan(tester.getTopLeft(find.text('Beta')).dy),
    );
    await _dragOnto(tester, 'Beta', 'Alpha');
    // Beta is now above Alpha.
    expect(
      tester.getTopLeft(find.text('Beta')).dy,
      lessThan(tester.getTopLeft(find.text('Alpha')).dy),
    );
  });

  testWidgets('Grid tiles reorder on drag', (tester) async {
    await _pumpPreview(tester, sortablePreviews[1]);
    expect(find.byType(SortableLayer), findsOneWidget);
    final Offset alphaWas = tester.getTopLeft(find.text('Alpha'));
    await _dragOnto(tester, 'Beta', 'Alpha');
    // Beta took Alpha's old cell.
    final Offset betaNow = tester.getTopLeft(find.text('Beta'));
    expect((betaNow - alphaWas).distance, lessThanOrEqualTo(2));
  });

  testWidgets('previews mirror in RTL and fit 375px', (tester) async {
    for (final ComponentPreview preview in sortablePreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await _pumpPreview(tester, preview, width: 375);
    }
  });
}
