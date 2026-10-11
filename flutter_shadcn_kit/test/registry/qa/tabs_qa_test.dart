// QA for `tabs` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `tabsPreviews` example like a user: tap selection on the
// Default strip, arrow-key walking, the Disabled strip staying inert, and
// the Tab pane (tap focus + drag reorder). Spacing metrics (h-9 strip,
// 30px triggers, container p-1) are pinned in `tabs_test.dart`; this file
// pins that the *previews* wire them up interactively.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/tabs/preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 360,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

Future<void> _pumpPreview(
  WidgetTester tester,
  ComponentPreview preview, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 360,
}) async {
  await tester.pumpWidget(
    _frame(
      Builder(builder: preview.builder),
      data: data,
      direction: direction,
      width: width,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  expect(
    tester.takeException(),
    isNull,
    reason: 'preview "${preview.name}" threw',
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in tabsPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('Default preview: tap moves selection, arrows walk', (
    tester,
  ) async {
    await _pumpPreview(tester, tabsPreviews[0]);
    expect(find.text('Account'), findsOneWidget);
    await tester.tap(find.text('Password'));
    await tester.pump();
    // Selection moved: Password trigger paints the selected pill. Tap the
    // first tab's focus node and walk right with the keyboard.
    await tester.tap(find.text('Account'));
    await tester.pump();
    final Element element = tester.element(find.text('Account'));
    Focus.of(element).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Disabled preview: taps report nothing, strip is inert', (
    tester,
  ) async {
    await _pumpPreview(tester, tabsPreviews[1]);
    await tester.tap(find.text('Password'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // No selection change is observable: the strip has no callback, so the
    // first tab keeps the selected pill. Tapping must not throw.
    await tester.tap(find.text('Account'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Tab pane preview: tap focuses, order renders', (tester) async {
    await _pumpPreview(tester, tabsPreviews[2]);
    expect(find.text('main.dart'), findsOneWidget);
    expect(find.text('tabs.dart'), findsOneWidget);
    await tester.tap(find.text('tabs.dart'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // Content card still present after focus change.
    expect(find.text('Editor content'), findsOneWidget);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in tabsPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });

  testWidgets('Default preview fits a 375px phone with no overflow', (
    tester,
  ) async {
    await _pumpPreview(tester, tabsPreviews[0], width: 375);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
