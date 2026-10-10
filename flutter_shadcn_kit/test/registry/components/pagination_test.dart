// Widget tests for the `pagination` component.
//
// Covers: the page window and ellipsis, labelled vs icon-only controls, the
// current-page variant, callbacks, the out-of-range/totalPages-0 regression
// and the four theme legs.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/pagination/pagination.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('shows labelled previous/next by default', (tester) async {
    await tester.pumpWidget(
      _frame(child: Pagination(page: 2, totalPages: 5, onPageChanged: (_) {})),
    );
    expect(find.text('Previous'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('current page uses the outline variant', (tester) async {
    await tester.pumpWidget(
      _frame(child: Pagination(page: 3, totalPages: 5, onPageChanged: (_) {})),
    );
    final Iterable<Button> buttons = tester
        .widgetList<Button>(find.byType(Button))
        .where((button) => button.variant == ButtonVariant.outline);
    expect(buttons, hasLength(1));
    expect(
      find.descendant(
        of: find.byWidget(buttons.first),
        matching: find.text('3'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders an ellipsis window for many pages', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Pagination(page: 10, totalPages: 20, onPageChanged: (_) {}),
      ),
    );
    expect(find.text('1'), findsOneWidget);
    expect(find.text('20'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    expect(find.text('4'), findsNothing);
  });

  testWidgets('tapping a page calls onPageChanged', (tester) async {
    int? changed;
    await tester.pumpWidget(
      _frame(
        child: Pagination(
          page: 3,
          totalPages: 5,
          onPageChanged: (int page) => changed = page,
        ),
      ),
    );
    await tester.tap(find.text('4'));
    expect(changed, 4);
  });

  testWidgets('previous is disabled on the first page', (tester) async {
    await tester.pumpWidget(
      _frame(child: Pagination(page: 1, totalPages: 5, onPageChanged: (_) {})),
    );
    final Button previous = tester
        .widgetList<Button>(find.byType(Button))
        .firstWhere(
          (button) =>
              button.child is Text && (button.child as Text).data == 'Previous',
        );
    expect(previous.onPressed, isNull);
  });

  testWidgets('icon-only mode drops the labels', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Pagination(
          page: 2,
          totalPages: 5,
          showLabel: false,
          onPageChanged: (_) {},
        ),
      ),
    );
    expect(find.text('Previous'), findsNothing);
    expect(find.text('Next'), findsNothing);
    expect(find.byType(Icon), findsNWidgets(2));
  });

  testWidgets('out-of-range page does not throw (regression)', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Pagination(page: 999, totalPages: 5, onPageChanged: (_) {}),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('totalPages of zero does not throw (regression)', (tester) async {
    await tester.pumpWidget(
      _frame(child: Pagination(page: 1, totalPages: 0, onPageChanged: (_) {})),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    double gapOf(WidgetTester tester) {
      final Row row = tester.widget<Row>(
        find
            .descendant(of: find.byType(Pagination), matching: find.byType(Row))
            .first,
      );
      final SizedBox box = row.children.whereType<SizedBox>().first;
      return box.width!;
    }

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[PaginationTheme(gap: 6)],
        child: Pagination(page: 2, totalPages: 5, onPageChanged: (_) {}),
      ),
    );
    expect(gapOf(tester), 6);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[PaginationTheme(gap: 6)],
        child: const ComponentTheme<PaginationTheme>(
          data: PaginationTheme(gap: 12),
          child: Pagination(page: 2, totalPages: 5, onPageChanged: _noop),
        ),
      ),
    );
    expect(gapOf(tester), 12);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[PaginationTheme(gap: 6)],
        child: const ComponentTheme<PaginationTheme>(
          data: PaginationTheme(gap: 12),
          child: Pagination(
            page: 2,
            totalPages: 5,
            gap: 18,
            onPageChanged: _noop,
          ),
        ),
      ),
    );
    expect(gapOf(tester), 18);
  });

  testWidgets('dark tokens drive the icons', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: Pagination(
          page: 2,
          totalPages: 5,
          showLabel: false,
          onPageChanged: (_) {},
        ),
      ),
    );
    expect(find.byType(Icon), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  group('narrow columns', () {
    Future<void> pumpNarrow(
      WidgetTester tester,
      double width,
      Pagination child,
    ) async {
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentThemes(
            themes: const <ComponentThemeData>[],
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: width, child: child),
              ),
            ),
          ),
        ),
      );
    }

    for (final double width in <double>[240, 300, 375]) {
      testWidgets('many pages fit at $width px, all controls reachable', (
        tester,
      ) async {
        int? changed;
        await pumpNarrow(
          tester,
          width,
          Pagination(
            page: 10,
            totalPages: 20,
            onPageChanged: (int page) => changed = page,
          ),
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(Pagination)).width,
          lessThanOrEqualTo(width),
        );
        // Collapsed: icon-only ends, the current page, both ellipsis jumps.
        expect(find.text('Previous'), findsNothing);
        expect(find.text('Next'), findsNothing);
        expect(find.text('10'), findsOneWidget);
        expect(find.text('1'), findsNothing);
        expect(find.text('20'), findsNothing);
        // Every remaining control still fires.
        await tester.tap(find.byIcon(LucideIcons.chevronRight));
        expect(changed, 11);
        await tester.tap(find.byIcon(LucideIcons.chevronLeft));
        expect(changed, 9);
        await tester.tap(find.text('10'));
        expect(changed, 10);
      });

      testWidgets('a small pager fits at $width px', (tester) async {
        int? changed;
        await pumpNarrow(
          tester,
          width,
          Pagination(
            page: 2,
            totalPages: 5,
            onPageChanged: (int page) => changed = page,
          ),
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(Pagination)).width,
          lessThanOrEqualTo(width),
        );
        expect(find.text('2'), findsOneWidget);
        await tester.tap(find.byIcon(LucideIcons.chevronRight));
        expect(changed, 3);
      });

      testWidgets('icon-only pager fits at $width px', (tester) async {
        await pumpNarrow(
          tester,
          width,
          Pagination(
            page: 5,
            totalPages: 12,
            showLabel: false,
            onPageChanged: (_) {},
          ),
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(Pagination)).width,
          lessThanOrEqualTo(width),
        );
        expect(find.text('5'), findsOneWidget);
      });
    }

    testWidgets('unbounded widths keep the full layout', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Pagination(page: 1, totalPages: 10, onPageChanged: (_) {}),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Previous'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });
  });
}

void _noop(int page) {}
