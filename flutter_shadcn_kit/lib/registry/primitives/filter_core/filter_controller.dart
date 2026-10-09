// The controller and value helpers of the `filter_bar` engine.

import 'package:flutter/foundation.dart';

import 'filter_matching.dart';
import 'filter_state.dart';

/// Which parts of a [FilterState] `clear` resets.
@immutable
class FilterClearPolicy {
  /// Creates a clear policy; everything clears by default.
  const FilterClearPolicy({
    this.clearSearch = true,
    this.clearSort = true,
    this.clearDateRange = true,
    this.clearChips = true,
    this.clearCustomFilters = true,
  });

  /// Whether the search text clears.
  final bool clearSearch;

  /// Whether the sort id clears.
  final bool clearSort;

  /// Whether the date range clears.
  final bool clearDateRange;

  /// Whether chips clear.
  final bool clearChips;

  /// Whether custom filter values clear.
  final bool clearCustomFilters;

  /// Returns a copy with the given flags replaced.
  FilterClearPolicy copyWith({
    bool? clearSearch,
    bool? clearSort,
    bool? clearDateRange,
    bool? clearChips,
    bool? clearCustomFilters,
  }) {
    return FilterClearPolicy(
      clearSearch: clearSearch ?? this.clearSearch,
      clearSort: clearSort ?? this.clearSort,
      clearDateRange: clearDateRange ?? this.clearDateRange,
      clearChips: clearChips ?? this.clearChips,
      clearCustomFilters: clearCustomFilters ?? this.clearCustomFilters,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is FilterClearPolicy &&
      other.clearSearch == clearSearch &&
      other.clearSort == clearSort &&
      other.clearDateRange == clearDateRange &&
      other.clearChips == clearChips &&
      other.clearCustomFilters == clearCustomFilters;

  @override
  int get hashCode => Object.hash(
    clearSearch,
    clearSort,
    clearDateRange,
    clearChips,
    clearCustomFilters,
  );
}

/// Notifies listeners whenever a [FilterState] changes.
class FilterBarController extends ValueNotifier<FilterState> {
  /// Creates a controller around [value].
  FilterBarController([super.value = const FilterState()]);

  /// Replaces the state; equal states are ignored.
  void setValue(FilterState next) {
    if (next == value) {
      return;
    }
    value = next;
  }

  /// Applies [transform] to the current state.
  void update(FilterState Function(FilterState current) transform) {
    setValue(transform(value));
  }

  /// Clears the state per [policy].
  void clear({FilterClearPolicy policy = const FilterClearPolicy()}) {
    setValue(value.cleared(policy: policy));
  }
}

/// A binding that reads a value out of the model and matches it through a
/// [FilterField].
@immutable
class TypedFilterBinding<TModel, TValue> extends FilterBinding<TModel> {
  /// Creates a typed binding.
  const TypedFilterBinding({required this.field, required this.selector});

  /// Field holding the selected value.
  final FilterField<TValue> field;

  /// Reads the candidate value from the model.
  final TValue? Function(TModel model) selector;

  @override
  bool matches(FilterState state, TModel model) =>
      state.matchesValue<TValue>(field, selector(model));
}

/// Value helpers on [FilterState] (readability, counting, typed access).
extension FilterStateExtensions on FilterState {
  /// Whether anything is filtered.
  bool get hasActiveFilters =>
      search.trim().isNotEmpty ||
      sortId != null ||
      dateRange != null ||
      chips.isNotEmpty ||
      customFilters.entries.any(
        (MapEntry<String, Object?> entry) =>
            !_isMatcherStateKey(entry.key) &&
            _isCustomFilterActive(entry.value),
      );

  /// How many filters are active (search, sort, date, chips, custom values).
  int get activeFilterCount {
    var count = 0;
    if (search.trim().isNotEmpty) count += 1;
    if (sortId != null) count += 1;
    if (dateRange != null) count += 1;
    count += chips.length;
    count += customFilters.entries
        .where(
          (MapEntry<String, Object?> entry) =>
              !_isMatcherStateKey(entry.key) &&
              _isCustomFilterActive(entry.value),
        )
        .length;
    return count;
  }

  /// Returns a copy without the chip identified by [chipKey].
  FilterState withoutChip(String chipKey) {
    final List<FilterChipData> next = chips
        .where((FilterChipData chip) => chip.key != chipKey)
        .toList(growable: false);
    return copyWith(chips: next);
  }

  /// Returns a copy with the parts selected by [policy] reset.
  FilterState cleared({FilterClearPolicy policy = const FilterClearPolicy()}) {
    return copyWith(
      search: policy.clearSearch ? '' : search,
      sortId: policy.clearSort ? null : sortId,
      dateRange: policy.clearDateRange ? null : dateRange,
      chips: policy.clearChips ? const <FilterChipData>[] : chips,
      customFilters: policy.clearCustomFilters
          ? const <String, Object?>{}
          : customFilters,
    );
  }

  /// The custom value stored under [key], or null when absent/mistyped.
  T? customValue<T>(String key) {
    final Object? value = customFilters[key];
    return value is T ? value : null;
  }

  /// Stores [value] under [key]; inactive values remove the key.
  FilterState setCustomValue(String key, Object? value) {
    final Map<String, Object?> next = Map<String, Object?>.of(customFilters);
    if (_isCustomFilterActive(value)) {
      next[key] = value;
    } else {
      next.remove(key);
    }
    return copyWith(customFilters: next);
  }

  /// The value selected for [field], or null.
  T? valueOf<T>(FilterField<T> field) => customValue<T>(field.id);

  /// Selects [value] for [field] (null clears it).
  FilterState setValue<T>(FilterField<T> field, T? value) =>
      setCustomValue(field.id, value);

  /// The active matcher id of [field], falling back to its default/first.
  String? matcherIdOf<T>(FilterField<T> field) {
    if (field.matchers.isEmpty) {
      return null;
    }
    final Object? stored = customFilters[_matcherStateKey(field.id)];
    if (stored is String &&
        field.matchers.any(
          (FilterMatcherOption<T> option) => option.id == stored,
        )) {
      return stored;
    }
    return field.defaultMatcherId ?? field.matchers.first.id;
  }

  /// Selects a matcher id for [field]; unknown ids and empty option lists
  /// leave the state unchanged (the old code returned a copy that stored
  /// nothing).
  FilterState setMatcherIdOf<T>(FilterField<T> field, String? matcherId) {
    if (field.matchers.isEmpty) {
      return this;
    }
    final String key = _matcherStateKey(field.id);
    if (matcherId == null) {
      if (!customFilters.containsKey(key)) {
        return this;
      }
      final Map<String, Object?> next = Map<String, Object?>.of(customFilters)
        ..remove(key);
      return copyWith(customFilters: next);
    }
    if (!field.matchers.any(
      (FilterMatcherOption<T> option) => option.id == matcherId,
    )) {
      return this;
    }
    return copyWith(
      customFilters: Map<String, Object?>.of(customFilters)..[key] = matcherId,
    );
  }

  /// The active matcher option of [field], or null when it has none.
  FilterMatcherOption<T>? matcherOptionOf<T>(FilterField<T> field) {
    if (field.matchers.isEmpty) {
      return null;
    }
    final String? matcherId = matcherIdOf(field);
    for (final FilterMatcherOption<T> option in field.matchers) {
      if (option.id == matcherId) {
        return option;
      }
    }
    return field.matchers.first;
  }

  /// The matcher that applies to [field]: the selected option or [FilterField.matcher].
  FilterMatcher<T>? matcherOf<T>(FilterField<T> field) =>
      matcherOptionOf(field)?.matcher ?? field.matcher;

  /// Whether [candidate] passes [field]'s active selection (unset matches all).
  bool matchesValue<T>(FilterField<T> field, Object? candidate) {
    final T? selected = valueOf(field);
    if (!_isCustomFilterActive(selected)) {
      return true;
    }
    final FilterMatcher<T> matcher =
        matcherOf(field) ?? FilterMatchers.exact<T>();
    return matcher.matches(selected as T, candidate);
  }

  /// Whether [model] passes every binding.
  bool matchesModel<TModel>(
    TModel model,
    Iterable<FilterBinding<TModel>> bindings,
  ) {
    for (final FilterBinding<TModel> binding in bindings) {
      if (!binding.matches(this, model)) {
        return false;
      }
    }
    return true;
  }

  /// The items of [source] that pass every binding.
  Iterable<TModel> whereMatches<TModel>(
    Iterable<TModel> source,
    Iterable<FilterBinding<TModel>> bindings,
  ) {
    return source.where((TModel item) => matchesModel(item, bindings));
  }
}

bool _isCustomFilterActive(Object? value) {
  if (value == null) return false;
  if (value is String) return value.trim().isNotEmpty;
  if (value is bool) return value;
  if (value is Iterable) return value.isNotEmpty;
  if (value is Map) return value.isNotEmpty;
  return true;
}

String _matcherStateKey(String fieldId) => '__matcher:$fieldId';

bool _isMatcherStateKey(String key) => key.startsWith('__matcher:');
