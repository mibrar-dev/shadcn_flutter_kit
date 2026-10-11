// QA for `filter_bar` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: the sheet snapshotting a stale theme, external search
// updates dropping the caret, and physical sheet insets in RTL.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/filter_bar/filter_bar.dart';
import 'package:flutter_shadcn_kit/registry/components/filter_bar/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const List<FilterSortOption> _sorts = <FilterSortOption>[
  FilterSortOption(id: 'newest', label: 'Newest'),
  FilterSortOption(id: 'oldest', label: 'Oldest'),
];

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (BuildContext context, _, _) => Center(
            child: width == null ? child : SizedBox(width: width, child: child),
          ),
        ),
      ),
    ),
  );
}

EditableText _searchField(WidgetTester tester) {
  return tester.widget<EditableText>(
    find.descendant(
      of: find.byType(FilterBar),
      matching: find.byType(EditableText),
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in filterBarPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('external search append keeps the caret at the end', (
    tester,
  ) async {
    final FilterBarController controller = FilterBarController(
      const FilterState(search: 'ab'),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        FilterBar(
          controller: controller,
          presentation: FilterBarPresentation.inline,
        ),
        width: 800,
      ),
    );
    await tester.pump();
    _searchField(tester).controller.selection = const TextSelection.collapsed(
      offset: 2,
    );
    controller.setValue(const FilterState(search: 'abc'));
    await tester.pump();
    final EditableText field = _searchField(tester);
    expect(field.controller.text, 'abc');
    expect(field.controller.selection.baseOffset, 3);
    expect(field.controller.selection.extentOffset, 3);
  });

  testWidgets('external search edit clamps a stale selection', (tester) async {
    final FilterBarController controller = FilterBarController(
      const FilterState(search: 'abcd'),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        FilterBar(
          controller: controller,
          presentation: FilterBarPresentation.inline,
        ),
        width: 800,
      ),
    );
    await tester.pump();
    _searchField(tester).controller.selection = const TextSelection.collapsed(
      offset: 4,
    );
    controller.setValue(const FilterState(search: 'a'));
    await tester.pump();
    final EditableText field = _searchField(tester);
    expect(field.controller.text, 'a');
    expect(field.controller.selection.baseOffset, 1);
    expect(field.controller.selection.extentOffset, 1);
  });

  testWidgets('sheet opens at narrow width with directional insets', (
    tester,
  ) async {
    final FilterBarController controller = FilterBarController(
      const FilterState(),
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        FilterBar(
          controller: controller,
          sortOptions: _sorts,
          presentation: FilterBarPresentation.autoSheet,
        ),
        width: 300,
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Filters'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(FilterBarSheetScaffold), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(FilterBarSheetScaffold),
        matching: find.byWidgetPredicate(
          (Widget widget) =>
              widget is Padding && widget.padding is EdgeInsetsDirectional,
        ),
      ),
      findsWidgets,
      reason: 'sheet insets must be directional for RTL',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: filterBarPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    for (final preview in filterBarPreviews) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        _frame(Builder(builder: preview.builder), direction: TextDirection.rtl),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
