// Widget tests for the `filter_bar` component: light/dark rendering, real
// sizes, search flow (immediate + debounced), the debounce-clear regression,
// chips, sort, clear policy, the raw-breakpoint and live-sheet regressions,
// typed custom filters, the controller assert and theme precedence.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/filter_bar/filter_bar.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const List<FilterSortOption> _sorts = <FilterSortOption>[
  FilterSortOption(id: 'newest', label: 'Newest'),
  FilterSortOption(id: 'oldest', label: 'Oldest'),
];
final FilterField<String> _statusField = FilterField<String>(
  id: 'status',
  matcher: FilterMatchers.exact(),
);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  FilterBarTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<FilterBarTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Navigator(
            onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
              settings: settings,
              pageBuilder:
                  (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) => Align(alignment: Alignment.topLeft, child: body),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _pump(
  WidgetTester tester, {
  FilterState state = const FilterState(),
  FilterBarController? controller,
  ValueChanged<FilterState>? onStateChanged,
  List<FilterSortOption> sortOptions = const <FilterSortOption>[],
  bool enableDateRange = false,
  int? resultsCount,
  Duration? searchDebounce,
  List<FilterCustomFilter> customFilters = const <FilterCustomFilter>[],
  List<FilterGroup> groups = const <FilterGroup>[],
  List<Widget> trailingFilters = const <Widget>[],
  FilterClearPolicy clearPolicy = const FilterClearPolicy(),
  bool showClearAllWhenEmpty = false,
  FilterBarPresentation presentation = FilterBarPresentation.inline,
  double sheetBreakpoint = 720,
  double width = 800,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  FilterBarTheme? scoped,
  FilterBarTheme? widgetTheme,
}) async {
  // The frame's Navigator keeps its first route, so each pump starts fresh.
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    _frame(
      SizedBox(
        width: width,
        child: FilterBar(
          state: controller == null ? state : null,
          onStateChanged: controller == null
              ? (onStateChanged ?? (_) {})
              : null,
          controller: controller,
          sortOptions: sortOptions,
          enableDateRange: enableDateRange,
          resultsCount: resultsCount,
          searchDebounce: searchDebounce,
          customFilters: customFilters,
          groups: groups,
          trailingFilters: trailingFilters,
          clearPolicy: clearPolicy,
          showClearAllWhenEmpty: showClearAllWhenEmpty,
          presentation: presentation,
          sheetBreakpoint: sheetBreakpoint,
          theme: widgetTheme,
        ),
      ),
      data: data,
      app: app,
      scoped: scoped,
    ),
  );
  await tester.pump();
}

Finder _searchEditable() => find.descendant(
  of: find.byType(FilterBarSearchField),
  matching: find.byType(EditableText),
);

void main() {
  group('rendering', () {
    testWidgets('renders in light and dark with real sizes', (tester) async {
      for (final ShadcnThemeData data in <ShadcnThemeData>[
        const ShadcnThemeData(),
        const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      ]) {
        await _pump(
          tester,
          data: data,
          state: const FilterState(
            sortId: 'newest',
            chips: <FilterChipData>[
              FilterChipData(key: 'tag:vip', label: 'Tag: VIP'),
            ],
          ),
          sortOptions: _sorts,
          resultsCount: 42,
        );
        expect(find.byType(FilterBarSearchField), findsOneWidget);
        expect(find.byType(FilterBarSortControl), findsOneWidget);
        expect(find.text('Tag: VIP'), findsOneWidget);
        expect(find.text('42 results'), findsOneWidget);
        expect(find.text('Clear all'), findsOneWidget);
        expect(
          tester.getSize(find.byType(FilterBarSearchField)),
          const Size(220, 36),
        );
        expect(
          tester.getSize(find.byType(FilterBarSortControl)),
          const Size(180, 36),
        );
      }
    });

    testWidgets('clear action hides when nothing is active', (tester) async {
      await _pump(tester);
      expect(find.text('Clear all'), findsNothing);
      expect(find.textContaining('active filters'), findsNothing);
    });
  });

  group('search', () {
    testWidgets('emits on every edit and syncs external state', (tester) async {
      final List<FilterState> emitted = <FilterState>[];
      await _pump(tester, onStateChanged: emitted.add);
      await tester.enterText(_searchEditable(), 'abc');
      await tester.pump();
      expect(emitted.last.search, 'abc');
      await _pump(tester, state: const FilterState(search: 'xyz'));
      expect(find.text('xyz'), findsOneWidget);
    });

    testWidgets('a pending debounce cannot resurrect a cleared query', (
      tester,
    ) async {
      // Regression: "clear all" did not cancel the timer, so the old query
      // was re-emitted when it fired.
      final List<FilterState> emitted = <FilterState>[];
      await _pump(
        tester,
        onStateChanged: emitted.add,
        searchDebounce: const Duration(milliseconds: 100),
        state: const FilterState(
          chips: <FilterChipData>[
            FilterChipData(key: 'tag:vip', label: 'Tag: VIP'),
          ],
        ),
      );
      await tester.enterText(_searchEditable(), 'abc');
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Clear all'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(emitted.last.search, '');
      expect(find.text('abc'), findsNothing);
    });

    testWidgets('debounced search emits after the delay', (tester) async {
      final List<FilterState> emitted = <FilterState>[];
      await _pump(
        tester,
        onStateChanged: emitted.add,
        searchDebounce: const Duration(milliseconds: 100),
      );
      await tester.enterText(_searchEditable(), 'abc');
      await tester.pump(const Duration(milliseconds: 50));
      expect(emitted, isEmpty);
      await tester.pump(const Duration(milliseconds: 80));
      expect(emitted.last.search, 'abc');
    });
  });

  group('controls', () {
    testWidgets('chips remove through onStateChanged', (tester) async {
      final List<FilterState> emitted = <FilterState>[];
      await _pump(
        tester,
        onStateChanged: emitted.add,
        state: const FilterState(
          chips: <FilterChipData>[
            FilterChipData(key: 'tag:vip', label: 'Tag: VIP'),
          ],
        ),
      );
      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pump();
      expect(emitted.last.chips, isEmpty);
    });

    testWidgets('the sort control updates sortId', (tester) async {
      final List<FilterState> emitted = <FilterState>[];
      await _pump(tester, onStateChanged: emitted.add, sortOptions: _sorts);
      await tester.tap(find.byType(FilterBarSortControl));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Oldest'));
      await tester.pumpAndSettle();
      expect(emitted.last.sortId, 'oldest');
    });

    testWidgets('clear all honours the policy', (tester) async {
      final List<FilterState> emitted = <FilterState>[];
      await _pump(
        tester,
        onStateChanged: emitted.add,
        clearPolicy: const FilterClearPolicy(clearChips: false),
        state: const FilterState(
          search: 'x',
          sortId: 'newest',
          chips: <FilterChipData>[
            FilterChipData(key: 'tag:vip', label: 'Tag: VIP'),
          ],
        ),
      );
      await tester.tap(find.text('Clear all'));
      await tester.pump();
      expect(emitted.last.search, '');
      expect(emitted.last.sortId, isNull);
      expect(emitted.last.chips, hasLength(1));
    });

    testWidgets('typed custom filters write through the state', (tester) async {
      final List<FilterState> emitted = <FilterState>[];
      await _pump(
        tester,
        onStateChanged: emitted.add,
        customFilters: <FilterCustomFilter>[
          FilterCustomFilter.typed<String>(
            field: _statusField,
            builder: (context, value, onChanged) => Button(
              onPressed: () => onChanged('open'),
              child: Text(value ?? 'none'),
            ),
          ),
        ],
      );
      expect(find.text('none'), findsOneWidget);
      await tester.tap(find.byType(Button));
      await tester.pump();
      expect(emitted.last.valueOf(_statusField), 'open');
    });

    testWidgets('date control renders at the control width', (tester) async {
      await _pump(tester, enableDateRange: true, state: const FilterState());
      expect(find.byType(FilterBarDateControl), findsOneWidget);
      expect(find.text('Date range'), findsOneWidget);
      expect(tester.getSize(find.byType(FilterBarDateControl)).width, 180);
    });
  });

  group('grouping', () {
    testWidgets('headers render and every filter appears exactly once', (
      tester,
    ) async {
      // Regression: the old grouped sheet dropped custom filters that were
      // not referenced by any group.
      await _pump(
        tester,
        sortOptions: _sorts,
        customFilters: <FilterCustomFilter>[
          FilterCustomFilter(
            id: 'status',
            builder: (context, state, onChanged) => const Text('status-widget'),
          ),
          FilterCustomFilter(
            id: 'price',
            builder: (context, state, onChanged) => const Text('price-widget'),
          ),
          FilterCustomFilter(
            id: 'tag',
            builder: (context, state, onChanged) => const Text('tag-widget'),
          ),
        ],
        groups: const <FilterGroup>[
          FilterGroup(
            id: 'catalog',
            title: 'Catalog',
            filterIds: <String>['status'],
          ),
          FilterGroup(
            id: 'pricing',
            title: 'Pricing',
            filterIds: <String>['price'],
          ),
        ],
      );
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.text('Pricing'), findsOneWidget);
      expect(find.text('status-widget'), findsOneWidget);
      expect(find.text('price-widget'), findsOneWidget);
      expect(find.text('tag-widget'), findsOneWidget);
      expect(find.byType(FilterBarSortControl), findsOneWidget);
    });

    testWidgets('group itemBuilder replaces the per-item renderer', (
      tester,
    ) async {
      await _pump(
        tester,
        customFilters: <FilterCustomFilter>[
          FilterCustomFilter(
            id: 'status',
            builder: (context, state, onChanged) => const Text('status-widget'),
          ),
        ],
        groups: <FilterGroup>[
          FilterGroup(
            id: 'catalog',
            title: 'Catalog',
            filterIds: <String>['status'],
            itemBuilder: (context, state, onChanged) => const Text('override'),
          ),
        ],
      );
      expect(find.text('override'), findsOneWidget);
      expect(find.text('status-widget'), findsNothing);
    });
  });

  group('presentation', () {
    testWidgets('autoSheet compares the raw breakpoint', (tester) async {
      // Regression: the old staged comparison made the default 720 behave
      // like 768 (700 stayed inline).
      await _pump(
        tester,
        width: 700,
        sortOptions: _sorts,
        presentation: FilterBarPresentation.autoSheet,
      );
      expect(find.byType(FilterBarSheetTrigger), findsOneWidget);
      expect(find.byType(FilterBarSortControl), findsNothing);
      await _pump(
        tester,
        width: 760,
        sortOptions: _sorts,
        presentation: FilterBarPresentation.autoSheet,
      );
      expect(find.byType(FilterBarSheetTrigger), findsNothing);
      expect(find.byType(FilterBarSortControl), findsOneWidget);
    });

    testWidgets('an empty sheet has no trigger', (tester) async {
      // Regression: the old trigger was rendered whenever the sheet mode was
      // active, but opening it did nothing when there were no controls.
      await _pump(
        tester,
        width: 500,
        presentation: FilterBarPresentation.autoSheet,
      );
      expect(find.byType(FilterBarSheetTrigger), findsNothing);
      await _pump(
        tester,
        width: 500,
        presentation: FilterBarPresentation.autoSheet,
        state: const FilterState(
          chips: <FilterChipData>[
            FilterChipData(key: 'tag:vip', label: 'Tag: VIP'),
          ],
        ),
      );
      expect(find.byType(FilterBarSheetTrigger), findsOneWidget);
    });

    testWidgets('the open sheet follows live state', (tester) async {
      // Regression: the sheet copied its state once and went stale.
      final FilterBarController controller = FilterBarController(
        const FilterState(sortId: 'newest'),
      );
      addTearDown(controller.dispose);
      await _pump(
        tester,
        controller: controller,
        width: 500,
        sortOptions: _sorts,
        presentation: FilterBarPresentation.autoSheet,
      );
      await tester.tap(find.byType(FilterBarSheetTrigger));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(FilterBarSheetScaffold), findsOneWidget);
      expect(find.text('Filters'), findsWidgets);
      expect(find.text('Clear all'), findsOneWidget);
      controller.setValue(const FilterState());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Clear all'), findsNothing);
    });
  });

  group('theme', () {
    testWidgets('precedence: widget > tree > app > defaults', (tester) async {
      double searchWidth() =>
          tester.getSize(find.byType(FilterBarSearchField)).width;
      await _pump(tester);
      expect(searchWidth(), 220);
      const FilterBarTheme app = FilterBarTheme(searchWidth: 260);
      await _pump(tester, app: <ComponentThemeData>[app]);
      expect(searchWidth(), 260);
      await _pump(
        tester,
        app: <ComponentThemeData>[app],
        scoped: const FilterBarTheme(searchWidth: 240),
      );
      expect(searchWidth(), 240);
      await _pump(
        tester,
        app: <ComponentThemeData>[app],
        scoped: const FilterBarTheme(searchWidth: 240),
        widgetTheme: const FilterBarTheme(searchWidth: 200),
      );
      expect(searchWidth(), 200);
    });

    testWidgets('per-field merge keeps the lower leg remaining fields', (
      tester,
    ) async {
      await _pump(
        tester,
        sortOptions: _sorts,
        app: const <ComponentThemeData>[FilterBarTheme(controlWidth: 150)],
        scoped: const FilterBarTheme(searchWidth: 210),
      );
      expect(tester.getSize(find.byType(FilterBarSortControl)).width, 150);
    });

    testWidgets('controller and state are mutually exclusive', (tester) async {
      expect(
        () => FilterBar(
          state: const FilterState(),
          onStateChanged: (_) {},
          controller: FilterBarController(),
        ),
        throwsAssertionError,
      );
    });
  });
}
