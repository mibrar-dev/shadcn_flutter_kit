// Named examples for the `filter_bar` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Each example
// owns its filter state. The fixed width is inherent: the search field needs
// a bounded box, and `inline` keeps the bar on the stage instead of a sheet.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'filter_bar.dart';

const List<FilterSortOption> _sortOptions = <FilterSortOption>[
  FilterSortOption(id: 'newest', label: 'Newest'),
  FilterSortOption(id: 'oldest', label: 'Oldest'),
];

/// Inline bar with sort options and a result count.
class _DefaultFilterBar extends StatefulWidget {
  const _DefaultFilterBar();

  @override
  State<_DefaultFilterBar> createState() => _DefaultFilterBarState();
}

class _DefaultFilterBarState extends State<_DefaultFilterBar> {
  FilterState _state = const FilterState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: FilterBar(
        state: _state,
        onStateChanged: (FilterState next) => setState(() => _state = next),
        sortOptions: _sortOptions,
        resultsCount: 42,
        presentation: FilterBarPresentation.inline,
      ),
    );
  }
}

Widget _default(BuildContext context) => const _DefaultFilterBar();

/// Inline bar with an active filter chip.
class _ChipsFilterBar extends StatefulWidget {
  const _ChipsFilterBar();

  @override
  State<_ChipsFilterBar> createState() => _ChipsFilterBarState();
}

class _ChipsFilterBarState extends State<_ChipsFilterBar> {
  FilterState _state = const FilterState(
    sortId: 'newest',
    chips: <FilterChipData>[FilterChipData(key: 'tag:vip', label: 'Tag: VIP')],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      child: FilterBar(
        state: _state,
        onStateChanged: (FilterState next) => setState(() => _state = next),
        sortOptions: _sortOptions,
        resultsCount: 3,
        presentation: FilterBarPresentation.inline,
      ),
    );
  }
}

Widget _withChips(BuildContext context) => const _ChipsFilterBar();

/// Named docs examples for `filter_bar`; the first entry is the default.
const List<ComponentPreview> filterBarPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('With chips', _withChips),
];
