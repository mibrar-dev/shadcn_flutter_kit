// Unit tests for the `filter_core` primitive behind `filter_bar`: state
// equality/copyWith, matchers, typed fields, the clear policy, the controller
// and the extension helpers.

import 'package:flutter_shadcn_kit/registry_next/primitives/filter_core/filter_controller.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/filter_core/filter_matching.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/filter_core/filter_state.dart';
import 'package:flutter_test/flutter_test.dart';

final FilterField<String> _status = FilterField<String>(
  id: 'status',
  matcher: FilterMatchers.exact(),
);
final FilterField<String> _brand = FilterField<String>(
  id: 'brand',
  defaultMatcherId: 'contains',
  matchers: <FilterMatcherOption<String>>[
    FilterMatcherOption<String>(
      id: 'contains',
      label: 'Contains',
      matcher: FilterMatchers.contains(),
    ),
    FilterMatcherOption<String>(
      id: 'starts',
      label: 'Starts with',
      matcher: FilterMatchers.startsWith(),
    ),
  ],
);

void main() {
  group('FilterState', () {
    test('copyWith can clear nullable fields explicitly', () {
      const FilterState state = FilterState(sortId: 'newest');
      expect(state.copyWith(sortId: null).sortId, isNull);
      expect(state.copyWith().sortId, 'newest');
      expect(state.copyWith(search: 'x').sortId, 'newest');
    });

    test(
      'equality is order-sensitive for chips, order-insensitive for maps',
      () {
        const FilterState a = FilterState(
          chips: <FilterChipData>[
            FilterChipData(key: 'a', label: 'A'),
            FilterChipData(key: 'b', label: 'B'),
          ],
          customFilters: <String, Object?>{'x': 1, 'y': 2},
        );
        const FilterState b = FilterState(
          chips: <FilterChipData>[
            FilterChipData(key: 'b', label: 'B'),
            FilterChipData(key: 'a', label: 'A'),
          ],
          customFilters: <String, Object?>{'y': 2, 'x': 1},
        );
        expect(a == b, isFalse);
        const FilterState mapFlipped = FilterState(
          customFilters: <String, Object?>{'y': 2, 'x': 1},
        );
        expect(
          mapFlipped ==
              const FilterState(
                customFilters: <String, Object?>{'x': 1, 'y': 2},
              ),
          isTrue,
        );
        expect(a.hashCode, a.copyWith().hashCode);
      },
    );
  });

  group('matchers', () {
    test('exact / contains / like / startsWith / endsWith', () {
      expect(FilterMatchers.exact<int>().matches(1, 1), isTrue);
      expect(FilterMatchers.exact<int>().matches(1, 2), isFalse);
      expect(FilterMatchers.contains().matches('oo', 'FOOD'), isTrue);
      expect(FilterMatchers.contains().matches('OO', 'food'), isTrue);
      expect(
        FilterMatchers.contains(caseSensitive: true).matches('oo', 'FOOD'),
        isFalse,
      );
      expect(FilterMatchers.like().matches('f%d', 'food'), isTrue);
      expect(FilterMatchers.like().matches('f_d', 'food'), isFalse);
      expect(FilterMatchers.like().matches('f__d', 'food'), isTrue);
      expect(FilterMatchers.startsWith().matches('fo', 'Food'), isTrue);
      expect(FilterMatchers.endsWith().matches('od', 'FOOD'), isTrue);
    });

    test('anyOf / inSet / greaterThan / lessThan', () {
      expect(
        FilterMatchers.anyOf<String>().matches(<String>['a', 'b'], 'a'),
        isTrue,
      );
      expect(
        FilterMatchers.inSet<String>().matches(<String>{'a'}, 'c'),
        isFalse,
      );
      expect(FilterMatchers.greaterThan<int>().matches(5, 6), isTrue);
      expect(FilterMatchers.greaterThan<int>().matches(5, 5), isFalse);
      expect(FilterMatchers.lessThan<int>().matches(5, 4), isTrue);
      expect(FilterMatchers.lessThan<int>().matches(5, 'x'), isFalse);
    });
  });

  group('fields', () {
    test('setValue/valueOf round-trip and inactive values are removed', () {
      FilterState state = const FilterState().setValue(_status, 'open');
      expect(state.valueOf(_status), 'open');
      expect(state.hasActiveFilters, isTrue);
      state = state.setValue(_status, null);
      expect(state.valueOf(_status), isNull);
      expect(state.hasActiveFilters, isFalse);
    });

    test('matcher selection falls back to the default and validates ids', () {
      const FilterState state = FilterState();
      expect(state.matcherIdOf(_brand), 'contains');
      expect(state.matcherOptionOf(_brand)?.id, 'contains');
      expect(state.matcherOf(_brand), isNotNull);
      final FilterState selected = state.setMatcherIdOf(_brand, 'starts');
      expect(selected.matcherIdOf(_brand), 'starts');
      // Regression: an unknown id used to return a new state that stored
      // nothing; it now returns the same state.
      expect(
        identical(selected.setMatcherIdOf(_brand, 'nope'), selected),
        isTrue,
      );
      expect(
        selected.setMatcherIdOf(_brand, null).matcherIdOf(_brand),
        'contains',
      );
      expect(
        identical(state.setMatcherIdOf(_status, 'x'), state),
        isTrue,
        reason: 'a field without matcher options never changes',
      );
    });

    test('matchesValue uses the active matcher and passes unset fields', () {
      const FilterState unset = FilterState();
      expect(unset.matchesValue(_brand, 'anything'), isTrue);
      final FilterState state = const FilterState().setValue(_brand, 'oo');
      expect(state.matchesValue(_brand, 'food'), isTrue);
      expect(state.matchesValue(_brand, 'bar'), isFalse);
      final FilterState starts = state.setMatcherIdOf(_brand, 'starts');
      expect(starts.matchesValue(_brand, 'food'), isFalse);
    });
  });

  group('extensions', () {
    test('activeFilterCount counts search, sort, date, chips and values', () {
      final FilterState state = const FilterState(
        search: 'x',
        sortId: 'newest',
        dateRange: FilterDateRange(start: null, end: null),
        chips: <FilterChipData>[FilterChipData(key: 'a', label: 'A')],
      ).setCustomValue('price', 10);
      expect(state.activeFilterCount, 5);
      expect(state.withoutChip('a').chips, isEmpty);
    });

    test('cleared honours the policy', () {
      const FilterState state = FilterState(
        search: 'x',
        sortId: 'newest',
        chips: <FilterChipData>[FilterChipData(key: 'a', label: 'A')],
        customFilters: <String, Object?>{'price': 10},
      );
      final FilterState kept = state.cleared(
        policy: const FilterClearPolicy(clearChips: false, clearSearch: false),
      );
      expect(kept.search, 'x');
      expect(kept.sortId, isNull);
      expect(kept.chips, hasLength(1));
      expect(kept.customFilters, isEmpty);
      expect(state.cleared().hasActiveFilters, isFalse);
    });

    test('whereMatches applies typed bindings to models', () {
      final List<String> source = <String>['open', 'closed', 'open'];
      final FilterState state = const FilterState().setValue(_status, 'open');
      final List<FilterBinding<String>> bindings = <FilterBinding<String>>[
        TypedFilterBinding<String, String>(
          field: _status,
          selector: (String model) => model,
        ),
      ];
      expect(state.whereMatches(source, bindings), <String>['open', 'open']);
      expect(state.matchesModel('closed', bindings), isFalse);
    });
  });

  group('controller', () {
    test('setValue ignores equal states and notifies once', () {
      final FilterBarController controller = FilterBarController();
      addTearDown(controller.dispose);
      var notifications = 0;
      controller.addListener(() => notifications++);
      controller.setValue(const FilterState());
      expect(notifications, 0);
      controller.update((FilterState current) => current.copyWith(search: 'a'));
      expect(controller.value.search, 'a');
      expect(notifications, 1);
      controller.clear();
      expect(controller.value.hasActiveFilters, isFalse);
      expect(notifications, 2);
    });
  });
}
