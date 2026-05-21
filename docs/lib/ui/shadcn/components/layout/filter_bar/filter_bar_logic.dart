// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/foundation.dart';

@immutable
/// FilterState defines a reusable type for this registry module.
class FilterState {
  static const Object _sentinel = Object();

  /// Stores `search` state/configuration for this implementation.
  final String search;

  /// Stores `sortId` state/configuration for this implementation.
  final String? sortId;

  /// Stores `dateRange` state/configuration for this implementation.
  final FilterDateRange? dateRange;

  /// Stores `chips` state/configuration for this implementation.
  final List<FilterChipData> chips;

  /// Stores `customFilters` state/configuration for this implementation.
  final Map<String, Object?> customFilters;

  /// Creates a `FilterState` instance.
  const FilterState({
    this.search = '',
    this.sortId,
    this.dateRange,
    this.chips = const [],
    this.customFilters = const {},
  });

  /// Creates a `FilterState` instance.
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
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final otherChips = other is FilterState
        ? other.chips
        : const <FilterChipData>[];
    final sameChips =
        otherChips.length == chips.length &&
        chips.asMap().entries.every(
          (entry) => otherChips[entry.key] == entry.value,
        );
    final otherCustomFilters = other is FilterState
        ? other.customFilters
        : const <String, Object?>{};
    final sameCustomFilters =
        otherCustomFilters.length == customFilters.length &&
        customFilters.keys.every(
          (key) =>
              otherCustomFilters.containsKey(key) &&
              otherCustomFilters[key] == customFilters[key],
        );
    return other is FilterState &&
        other.search == search &&
        other.sortId == sortId &&
        other.dateRange == dateRange &&
        sameChips &&
        sameCustomFilters;
  }

  @override
  int get hashCode => Object.hash(
    search,
    sortId,
    dateRange,
    Object.hashAll(chips),
    _hashCustomFilters(customFilters),
  );
}

int _hashCustomFilters(Map<String, Object?> values) {
  final keys = values.keys.toList()..sort();
  return Object.hashAll(keys.map((key) => Object.hash(key, values[key])));
}

@immutable
/// FilterChipData defines a reusable type for this registry module.
class FilterChipData {
  /// Stores `key` state/configuration for this implementation.
  final String key;

  /// Stores `label` state/configuration for this implementation.
  final String label;

  const FilterChipData({required this.key, required this.label});

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterChipData && other.key == key && other.label == label;
  }

  @override
  int get hashCode => Object.hash(key, label);
}

@immutable
/// FilterDateRange defines a reusable type for this registry module.
class FilterDateRange {
  /// Stores `start` state/configuration for this implementation.
  final DateTime? start;

  /// Stores `end` state/configuration for this implementation.
  final DateTime? end;

  const FilterDateRange({this.start, this.end});

  /// Stores `isEmpty` state/configuration for this implementation.
  bool get isEmpty => start == null && end == null;

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterDateRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

@immutable
/// FilterSortOption defines a reusable type for this registry module.
class FilterSortOption {
  /// Stores `id` state/configuration for this implementation.
  final String id;

  /// Stores `label` state/configuration for this implementation.
  final String label;

  const FilterSortOption({required this.id, required this.label});

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterSortOption && other.id == id && other.label == label;
  }

  @override
  int get hashCode => Object.hash(id, label);
}

/// Type alias for matcher callbacks used by logical filtering APIs.
typedef FilterMatcherCallback<T> = bool Function(T selected, Object? candidate);

@immutable
/// FilterMatcher defines a reusable type for this registry module.
class FilterMatcher<T> {
  final FilterMatcherCallback<T> _matches;

  /// Creates a `FilterMatcher` instance.
  const FilterMatcher(this._matches);

  /// Executes `matches` behavior for this component/composite.
  bool matches(T selected, Object? candidate) {
    return _matches(selected, candidate);
  }
}

/// FilterMatchers defines a reusable type for this registry module.
abstract final class FilterMatchers {
  /// Executes `exact` behavior for this component/composite.
  static FilterMatcher<T> exact<T>() {
    return FilterMatcher<T>((selected, candidate) => candidate == selected);
  }

  /// Executes `contains` behavior for this component/composite.
  static FilterMatcher<String> contains({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) {
        return false;
      }
      final needle = caseSensitive ? selected : selected.toLowerCase();
      final haystack = caseSensitive ? candidate : candidate.toLowerCase();
      return haystack.contains(needle);
    });
  }

  /// Executes `like` behavior for this component/composite.
  static FilterMatcher<String> like({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) {
        return false;
      }
      final expression = _buildLikeExpression(
        selected,
        caseSensitive: caseSensitive,
      );
      return expression.hasMatch(candidate);
    });
  }

  /// Executes `startsWith` behavior for this component/composite.
  static FilterMatcher<String> startsWith({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) {
        return false;
      }
      final needle = caseSensitive ? selected : selected.toLowerCase();
      final haystack = caseSensitive ? candidate : candidate.toLowerCase();
      return haystack.startsWith(needle);
    });
  }

  /// Executes `endsWith` behavior for this component/composite.
  static FilterMatcher<String> endsWith({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) {
        return false;
      }
      final needle = caseSensitive ? selected : selected.toLowerCase();
      final haystack = caseSensitive ? candidate : candidate.toLowerCase();
      return haystack.endsWith(needle);
    });
  }

  /// Executes `anyOf` behavior for this component/composite.
  static FilterMatcher<Iterable<T>> anyOf<T>() {
    return FilterMatcher<Iterable<T>>((selected, candidate) {
      return selected.contains(candidate);
    });
  }

  /// Executes `inSet` behavior for this component/composite.
  static FilterMatcher<Set<T>> inSet<T>() {
    return FilterMatcher<Set<T>>((selected, candidate) {
      return selected.contains(candidate);
    });
  }

  /// Executes `greaterThan` behavior for this component/composite.
  static FilterMatcher<T> greaterThan<T extends Comparable<Object>>() {
    return FilterMatcher<T>((selected, candidate) {
      if (candidate is! Comparable<Object>) {
        return false;
      }
      return candidate.compareTo(selected) > 0;
    });
  }

  /// Executes `lessThan` behavior for this component/composite.
  static FilterMatcher<T> lessThan<T extends Comparable<Object>>() {
    return FilterMatcher<T>((selected, candidate) {
      if (candidate is! Comparable<Object>) {
        return false;
      }
      return candidate.compareTo(selected) < 0;
    });
  }

  static RegExp _buildLikeExpression(
    String pattern, {
    required bool caseSensitive,
  }) {
    final buffer = StringBuffer('^');
    for (var i = 0; i < pattern.length; i++) {
      final char = pattern[i];
      if (char == '%') {
        buffer.write('.*');
      } else if (char == '_') {
        buffer.write('.');
      } else {
        buffer.write(RegExp.escape(char));
      }
    }
    buffer.write(r'$');
    return RegExp(buffer.toString(), caseSensitive: caseSensitive);
  }
}

@immutable
/// FilterMatcherOption defines a reusable type for this registry module.
class FilterMatcherOption<T> {
  final String id;
  final String label;
  final FilterMatcher<T> matcher;

  const FilterMatcherOption({
    required this.id,
    required this.label,
    required this.matcher,
  });
}

@immutable
/// FilterField defines a reusable type for this registry module.
class FilterField<T> {
  final String id;
  final String? label;
  final FilterMatcher<T>? matcher;
  final List<FilterMatcherOption<T>> matchers;
  final String? defaultMatcherId;

  const FilterField({
    required this.id,
    this.label,
    this.matcher,
    this.matchers = const [],
    this.defaultMatcherId,
  });
}

@immutable
/// FilterBinding defines a reusable type for this registry module.
abstract class FilterBinding<TModel> {
  const FilterBinding();

  /// Executes `matches` behavior for this component/composite.
  bool matches(FilterState state, TModel model);
}

@immutable
/// TypedFilterBinding defines a reusable type for this registry module.
class TypedFilterBinding<TModel, TValue> extends FilterBinding<TModel> {
  final FilterField<TValue> field;
  final TValue? Function(TModel model) selector;

  const TypedFilterBinding({required this.field, required this.selector});

  @override
  bool matches(FilterState state, TModel model) {
    return state.matchesValue<TValue>(field, selector(model));
  }
}

@immutable
/// FilterClearPolicy defines a reusable type for this registry module.
class FilterClearPolicy {
  final bool clearSearch;
  final bool clearSort;
  final bool clearDateRange;
  final bool clearChips;
  final bool clearCustomFilters;

  /// Creates a `FilterClearPolicy` instance.
  const FilterClearPolicy({
    this.clearSearch = true,
    this.clearSort = true,
    this.clearDateRange = true,
    this.clearChips = true,
    this.clearCustomFilters = true,
  });

  /// Creates a `FilterClearPolicy` instance.
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FilterClearPolicy &&
        other.clearSearch == clearSearch &&
        other.clearSort == clearSort &&
        other.clearDateRange == clearDateRange &&
        other.clearChips == clearChips &&
        other.clearCustomFilters == clearCustomFilters;
  }

  @override
  int get hashCode => Object.hash(
    clearSearch,
    clearSort,
    clearDateRange,
    clearChips,
    clearCustomFilters,
  );
}

/// FilterBarController defines a reusable type for this registry module.
class FilterBarController extends ValueNotifier<FilterState> {
  /// Creates a `FilterBarController` instance.
  FilterBarController([super.value = const FilterState()]);

  /// Executes `setState` behavior for this component/composite.
  void setState(FilterState next) {
    if (next == value) {
      return;
    }
    value = next;
  }

  /// Executes `update` behavior for this component/composite.
  void update(FilterState Function(FilterState current) transform) {
    setState(transform(value));
  }

  /// Executes `clear` behavior for this component/composite.
  void clear({FilterClearPolicy policy = const FilterClearPolicy()}) {
    setState(value.cleared(policy: policy));
  }
}

/// Extension helpers used by this registry module.
extension FilterStateExtensions on FilterState {
  bool get hasActiveFilters =>
      search.trim().isNotEmpty ||
      sortId != null ||
      dateRange != null ||
      chips.isNotEmpty ||
      customFilters.entries.any(
        (entry) =>
            !_isMatcherStateKey(entry.key) &&
            _isCustomFilterActive(entry.value),
      );

  int get activeFilterCount {
    var count = 0;
    if (search.trim().isNotEmpty) count += 1;
    if (sortId != null) count += 1;
    if (dateRange != null) count += 1;
    count += chips.length;
    count += customFilters.entries
        .where(
          (entry) =>
              !_isMatcherStateKey(entry.key) &&
              _isCustomFilterActive(entry.value),
        )
        .length;
    return count;
  }

  FilterState withoutChip(String chipKey) {
    final next = chips
        .where((chip) => chip.key != chipKey)
        .toList(growable: false);
    return copyWith(chips: next);
  }

  FilterState cleared({FilterClearPolicy policy = const FilterClearPolicy()}) {
    return copyWith(
      search: policy.clearSearch ? '' : search,
      sortId: policy.clearSort ? null : sortId,
      dateRange: policy.clearDateRange ? null : dateRange,
      chips: policy.clearChips ? const [] : chips,
      customFilters: policy.clearCustomFilters
          ? const <String, Object?>{}
          : customFilters,
    );
  }

  T? customValue<T>(String key) {
    final value = customFilters[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  FilterState setCustomValue(String key, Object? value) {
    final next = Map<String, Object?>.of(customFilters);
    if (_isCustomFilterActive(value)) {
      next[key] = value;
    } else {
      next.remove(key);
    }
    return copyWith(customFilters: next);
  }

  T? valueOf<T>(FilterField<T> field) {
    return customValue<T>(field.id);
  }

  FilterState setValue<T>(FilterField<T> field, T? value) {
    return setCustomValue(field.id, value);
  }

  String? matcherIdOf<T>(FilterField<T> field) {
    if (field.matchers.isEmpty) {
      return null;
    }
    final stored = customFilters[_matcherStateKey(field.id)];
    if (stored is String &&
        field.matchers.any((matcherOption) => matcherOption.id == stored)) {
      return stored;
    }
    return field.defaultMatcherId ?? field.matchers.first.id;
  }

  FilterState setMatcherIdOf<T>(FilterField<T> field, String? matcherId) {
    if (field.matchers.isEmpty) {
      return this;
    }
    final next = Map<String, Object?>.of(customFilters);
    final key = _matcherStateKey(field.id);
    if (matcherId == null) {
      next.remove(key);
      return copyWith(customFilters: next);
    }
    final exists = field.matchers.any(
      (matcherOption) => matcherOption.id == matcherId,
    );
    if (exists) {
      next[key] = matcherId;
    }
    return copyWith(customFilters: next);
  }

  FilterMatcherOption<T>? matcherOptionOf<T>(FilterField<T> field) {
    if (field.matchers.isEmpty) {
      return null;
    }
    final matcherId = matcherIdOf(field);
    if (matcherId == null) {
      return field.matchers.first;
    }
    for (final option in field.matchers) {
      if (option.id == matcherId) {
        return option;
      }
    }
    return field.matchers.first;
  }

  FilterMatcher<T>? matcherOf<T>(FilterField<T> field) {
    return matcherOptionOf(field)?.matcher ?? field.matcher;
  }

  bool matchesValue<T>(FilterField<T> field, Object? candidate) {
    final selected = valueOf(field);
    if (!_isCustomFilterActive(selected)) {
      return true;
    }
    final matcher = matcherOf(field) ?? FilterMatchers.exact<T>();
    return matcher.matches(selected as T, candidate);
  }

  /// Executes `matchesModel` behavior for this component/composite.
  bool matchesModel<TModel>(
    TModel model,
    Iterable<FilterBinding<TModel>> bindings,
  ) {
    for (final binding in bindings) {
      if (!binding.matches(this, model)) {
        return false;
      }
    }
    return true;
  }

  /// Executes `whereMatches` behavior for this component/composite.
  Iterable<TModel> whereMatches<TModel>(
    Iterable<TModel> source,
    Iterable<FilterBinding<TModel>> bindings,
  ) {
    return source.where((item) => matchesModel(item, bindings));
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
