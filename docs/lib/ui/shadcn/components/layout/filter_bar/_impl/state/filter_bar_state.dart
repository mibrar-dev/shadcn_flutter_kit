// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Backward-compatible shim.
//
// FilterBar state models now live in `filter_bar_logic.dart` so logic can be
// used independently from the FilterBar UI widgets.
export '../../filter_bar_logic.dart'
    show FilterChipData, FilterDateRange, FilterSortOption, FilterState;
