// The filter engine behind the `filter_bar` component: the immutable
// [FilterState] and its value types.
//
// Moved down from the old `filter_bar_logic.dart` (a separate public entry in
// the old tree — the docs imported it standalone) because the flat component
// folder has room for one widget file plus one style file. Pure data: no
// widgets, no components.

import 'package:flutter/foundation.dart';

/// Immutable value of every filter a `filter_bar` carries.
///
/// `copyWith` uses a sentinel for the nullable fields so `null` can be stored
/// deliberately (`sortId: null` clears the sort).
@immutable
class FilterState {
  static const Object _sentinel = Object();

  /// Free-text query.
  final String search;

  /// Selected sort option id, or null.
  final String? sortId;

  /// Selected date span, or null.
  final FilterDateRange? dateRange;

  /// Removable filter chips.
  final List<FilterChipData> chips;

  /// Custom filter values keyed by field id (matcher ids included).
  final Map<String, Object?> customFilters;

  /// Creates a filter state.
  const FilterState({
    this.search = '',
    this.sortId,
    this.dateRange,
    this.chips = const <FilterChipData>[],
    this.customFilters = const <String, Object?>{},
  });

  /// Returns a copy; the sentinel keeps explicit nulls.
  FilterState copyWith({
    String? search,
    Object? sortId = _sentinel,
    Object? dateRange = _sentinel,
    List<FilterChipData>? chips,
    Object? customFilters = _sentinel,
  }) {
    return FilterState(
      search: search ?? this.search,
      sortId: identical(sortId, _sentinel) ? this.sortId : sortId as String?,
      dateRange: identical(dateRange, _sentinel)
          ? this.dateRange
          : dateRange as FilterDateRange?,
      chips: chips ?? this.chips,
      customFilters: identical(customFilters, _sentinel)
          ? this.customFilters
          : customFilters as Map<String, Object?>,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FilterState) return false;
    if (other.search != search ||
        other.sortId != sortId ||
        other.dateRange != dateRange ||
        other.chips.length != chips.length ||
        other.customFilters.length != customFilters.length) {
      return false;
    }
    for (var i = 0; i < chips.length; i++) {
      if (other.chips[i] != chips[i]) return false;
    }
    for (final MapEntry<String, Object?> entry in customFilters.entries) {
      if (!other.customFilters.containsKey(entry.key) ||
          other.customFilters[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    search,
    sortId,
    dateRange,
    Object.hashAll(chips),
    Object.hashAll(customFilters.keys.toList()..sort()),
    _customValuesHash(customFilters),
  );
}

int _customValuesHash(Map<String, Object?> values) {
  final List<String> keys = values.keys.toList()..sort();
  return Object.hashAll(keys.map((key) => Object.hash(key, values[key])));
}

/// One removable chip: [key] identifies it, [label] is what users read.
@immutable
class FilterChipData {
  /// Creates a chip.
  const FilterChipData({required this.key, required this.label});

  /// Stable identity used by [FilterStateExtensions.withoutChip].
  final String key;

  /// Chip text.
  final String label;

  @override
  bool operator ==(Object other) =>
      other is FilterChipData && other.key == key && other.label == label;

  @override
  int get hashCode => Object.hash(key, label);
}

/// A start/end date span; either end may be null.
@immutable
class FilterDateRange {
  /// Creates a date range.
  const FilterDateRange({this.start, this.end});

  /// First day, or null.
  final DateTime? start;

  /// Last day, or null.
  final DateTime? end;

  /// Whether both ends are null.
  bool get isEmpty => start == null && end == null;

  @override
  bool operator ==(Object other) =>
      other is FilterDateRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// One sort dropdown option.
@immutable
class FilterSortOption {
  /// Creates a sort option.
  const FilterSortOption({required this.id, required this.label});

  /// Stable id stored in [FilterState.sortId].
  final String id;

  /// Dropdown text.
  final String label;

  @override
  bool operator ==(Object other) =>
      other is FilterSortOption && other.id == id && other.label == label;

  @override
  int get hashCode => Object.hash(id, label);
}
