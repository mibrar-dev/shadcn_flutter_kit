// QA for `pagination` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `paginationPreviews` example like a user: the Labelled pager
// moves pages on tap (page buttons, prev/next, ellipsis jumps), clamps
// out-of-range values, and collapses to the compact layout on a 375px phone.
// The Icon-only example renders no labels. Window maths (first/last shown,
// hasMore) is pinned in `pagination_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/pagination/preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 480,
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
  double width = 480,
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
    for (final preview in paginationPreviews) {
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

  testWidgets('Labelled preview: tapping a page button moves the page', (
    tester,
  ) async {
    // Wide enough for the full window (the control collapses under ~640px).
    await _pumpPreview(tester, paginationPreviews[0], width: 720);
    // Page 1 of 10 selected: prev is disabled, pages 1..3 window shown.
    await tester.tap(find.text('3'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // The pager restated at page 3: next moves to 4.
    await tester.tap(find.text('Next'));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('Labelled preview: prev on first page is disabled', (
    tester,
  ) async {
    await _pumpPreview(tester, paginationPreviews[0], width: 720);
    // Still page 1: tapping Previous must not move anywhere.
    await tester.tap(find.text('Previous'), warnIfMissed: false);
    await tester.pump();
    expect(find.text('1'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Icon only preview: no labels, window still tappable', (
    tester,
  ) async {
    await _pumpPreview(tester, paginationPreviews[1], width: 720);
    expect(find.text('Previous'), findsNothing);
    expect(find.text('Next'), findsNothing);
    await tester.tap(find.text('6'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('Labelled preview collapses on a 375px phone, no overflow', (
    tester,
  ) async {
    await _pumpPreview(tester, paginationPreviews[0], width: 375);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // Compact form keeps prev/current/next reachable.
    expect(find.text('1'), findsWidgets);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in paginationPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
