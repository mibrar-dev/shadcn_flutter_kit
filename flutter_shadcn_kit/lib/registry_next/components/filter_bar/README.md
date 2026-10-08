# FilterBar (`filter_bar`)

Search, sort, date-range and custom filters in one bar, with removable chips,
a clear action and a mobile sheet presentation. Backed by the typed filter
engine in `primitives/filter_core/` (matchers, bindings, controller).

## When to use

- You need a controlled filter bar over a list/table.
- You want a filter value you can also apply to models outside the UI
  (`FilterState.whereMatches`).

Avoid when a single control is enough — use `input` or `select` directly.

## Install

```bash
flutter_shadcn add filter_bar
```

## Import

```dart
import 'package:<your_app>/ui/shadcn/filter_bar/filter_bar.dart';
```

## Minimal example

```dart
FilterBar(
  state: _state,
  sortOptions: const <FilterSortOption>[
    FilterSortOption(id: 'newest', label: 'Newest'),
    FilterSortOption(id: 'oldest', label: 'Oldest'),
  ],
  resultsCount: 42,
  onStateChanged: (next) => setState(() => _state = next),
)
```

## Common patterns

### Controller

```dart
final controller = FilterBarController(const FilterState(sortId: 'newest'));

FilterBar(controller: controller, sortOptions: _sortOptions)
```

### Typed custom filter

```dart
final statusField = FilterField<String>(id: 'status', matcher: FilterMatchers.exact());

FilterBar(
  state: _state,
  customFilters: <FilterCustomFilter>[
    FilterCustomFilter.typed<String>(
      field: statusField,
      builder: (context, value, onChanged) => Select<String>(
        value: value,
        canUnselect: true,
        placeholder: const Text('Status'),
        onChanged: onChanged,
        itemBuilder: (context, value) => Text(value),
        items: const <Widget>[
          SelectItem<String>(value: 'open', child: Text('Open')),
          SelectItem<String>(value: 'closed', child: Text('Closed')),
        ],
      ),
    ),
  ],
  onStateChanged: (next) => setState(() => _state = next),
)
```

### Filtering models

```dart
final bindings = <FilterBinding<Order>>[
  TypedFilterBinding<Order, String>(field: emailField, selector: (o) => o.email),
];
final filtered = _state.whereMatches(orders, bindings);
```

### Grouped filters

```dart
FilterBar(
  state: _state,
  customFilters: _filters,
  groups: const <FilterGroup>[
    FilterGroup(id: 'catalog', title: 'Catalog', filterIds: <String>['category', 'brand']),
    FilterGroup(id: 'price', title: 'Pricing', filterIds: <String>['price', 'rating']),
  ],
  onStateChanged: (next) => setState(() => _state = next),
)
```

Group headers render above their filters; filters not covered by any group
(and `trailingFilters`) render after the blocks. A `FilterGroup.itemBuilder`
replaces the per-item renderer for that group.

### Sheet presentation

```dart
FilterBar(
  state: _state,
  presentation: FilterBarPresentation.autoSheet,
  sheetBreakpoint: 720,
  enableDateRange: true,
  onStateChanged: (next) => setState(() => _state = next),
)
```

## API

- `FilterBar(state, onStateChanged, controller, sortOptions, enableDateRange,
  resultsCount, searchDebounce, trailingFilters, customFilters, clearPolicy,
  onClearAll, showClearAllWhenEmpty, presentation, sheetBreakpoint,
  sheetPosition, useRootNavigator, sheetContentPadding, groups, theme)` —
  provide either `controller` or `state` + `onStateChanged` (asserted).
- `FilterBarController` (`setValue`, `update`, `clear`), `FilterState`,
  `FilterStateExtensions`
  (`hasActiveFilters`, `activeFilterCount`, `withoutChip`, `cleared`,
  `customValue`/`setCustomValue`, `valueOf`/`setValue`, `matcherIdOf`/
  `setMatcherIdOf`, `matchesValue`, `matchesModel`, `whereMatches`).
- `FilterMatcher`/`FilterMatchers` (`exact`, `contains`, `like`, `startsWith`,
  `endsWith`, `anyOf`, `inSet`, `greaterThan`, `lessThan`), `FilterField`,
  `FilterMatcherOption`, `FilterBinding`, `TypedFilterBinding`.
- `FilterCustomFilter` (+ `.typed`), `FilterGroup`, `FilterClearPolicy`,
  `FilterBarPresentation`, `FilterBarGroupedContent` (the grouped/flat
  renderer, also usable standalone).
- Sub-widgets (composable): `FilterBarSearchField`, `FilterBarSortControl`,
  `FilterBarDateControl`, `FilterBarClearButton`, `FilterBarSheetTrigger`,
  `FilterBarSheetScaffold`.

### Theme fields

| Field | Default | Effect |
|---|---|---|
| `spacing` | 12 | gap between controls |
| `runSpacing` | 8 | gap between wrapped runs |
| `searchWidth` | 220 | search field width |
| `controlWidth` | 180 | sort/date control width |
| `dense` | false | compact padding and small buttons |

Resolution: widget `theme` > nearest `ComponentTheme<FilterBarTheme>` >
`ComponentThemes` app overrides > `filterBarDefaults`. The theme class lives
in `primitives/filter_core/filter_theme.dart` (flat-folder budget) and is
re-exported here.

## Differences from the old `FilterBar`

- The value engine moved to `primitives/filter_core/` (the old tree exposed it
  as a second public entry, `filter_bar_logic.dart`); it is no longer a
  component entry file.
- Per-instance label parameters (`searchPlaceholder`, `searchLabel`,
  `sortLabel`, `dateRangeLabel`, `clearAllLabel`, `sheetTriggerLabel`,
  `sheetTitle`, `activeFilterCountLabel`) are gone: strings come from
  `primitives/localizations` (`filterSearch`, `filterSort`,
  `filterDateRange`, `filterClearAll`, `filterFilters`,
  `filterActiveCount`, `filterResultsCount`).
- `FilterBarStyle` became `FilterBarTheme` (per-field merge, four legs).
- Grouping is restored with headers: `FilterGroup(id, title, filterIds,
  itemBuilder)`; the model, the custom-filter descriptor and the renderer
  (`FilterBarGroupedContent`) live in `primitives/filter_core/`. The old
  grouped sheet dropped ungrouped filters — every filter renders exactly once
  now (regression-tested).
- `FilterSheetItemBuilder` (a byte-identical duplicate of
  `FilterCustomFilterBuilder`) and `FilterField.label` are gone.
- Fixed: the debounce timer can no longer resurrect cleared search text; the
  sheet follows live state; `sheetBreakpoint` compares the raw width; a
  half-null date range maps to a one-day span; `controller` + `state` is an
  assert; the sheet trigger only renders when there is something to show.
- `setMatcherIdOf` returns the same state for unknown ids (it used to return a
  copy that stored nothing); `FilterState.hashCode` computes the custom-filter
  hash once.
