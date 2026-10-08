// Matchers, filter fields and model bindings of the `filter_bar` engine.
//
// See `filter_state.dart` for the state these rules read.

import 'package:flutter/foundation.dart';

import 'filter_state.dart';

/// Tests a stored selection against a candidate value.
typedef FilterMatcherCallback<T> = bool Function(T selected, Object? candidate);

/// One reusable matching rule.
@immutable
class FilterMatcher<T> {
  /// Creates a matcher from its callback.
  const FilterMatcher(this._matches);

  final FilterMatcherCallback<T> _matches;

  /// Whether [candidate] passes the rule for [selected].
  bool matches(T selected, Object? candidate) => _matches(selected, candidate);
}

/// The built-in matcher factories.
abstract final class FilterMatchers {
  /// `candidate == selected`.
  static FilterMatcher<T> exact<T>() =>
      FilterMatcher<T>((selected, candidate) => candidate == selected);

  /// Substring match; case-insensitive by default.
  static FilterMatcher<String> contains({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) return false;
      final String needle = caseSensitive ? selected : selected.toLowerCase();
      final String haystack = caseSensitive
          ? candidate
          : candidate.toLowerCase();
      return haystack.contains(needle);
    });
  }

  /// SQL-LIKE match: `%` is any run, `_` one character.
  static FilterMatcher<String> like({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) return false;
      return _likeExpression(selected, caseSensitive).hasMatch(candidate);
    });
  }

  /// Prefix match; case-insensitive by default.
  static FilterMatcher<String> startsWith({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) return false;
      final String needle = caseSensitive ? selected : selected.toLowerCase();
      final String haystack = caseSensitive
          ? candidate
          : candidate.toLowerCase();
      return haystack.startsWith(needle);
    });
  }

  /// Suffix match; case-insensitive by default.
  static FilterMatcher<String> endsWith({bool caseSensitive = false}) {
    return FilterMatcher<String>((selected, candidate) {
      if (candidate is! String) return false;
      final String needle = caseSensitive ? selected : selected.toLowerCase();
      final String haystack = caseSensitive
          ? candidate
          : candidate.toLowerCase();
      return haystack.endsWith(needle);
    });
  }

  /// Membership in a stored collection.
  static FilterMatcher<Iterable<T>> anyOf<T>() => FilterMatcher<Iterable<T>>(
    (selected, candidate) => selected.contains(candidate),
  );

  /// Membership in a stored set.
  static FilterMatcher<Set<T>> inSet<T>() => FilterMatcher<Set<T>>(
    (selected, candidate) => selected.contains(candidate),
  );

  /// `candidate > selected`. A candidate of another type never matches (the
  /// old check accepted any `Comparable<Object>` and threw when the runtime
  /// types differed, e.g. an int selection against a String candidate).
  static FilterMatcher<T> greaterThan<T extends Comparable<Object>>() {
    return FilterMatcher<T>((selected, candidate) {
      if (candidate is! T) return false;
      return selected.compareTo(candidate) < 0;
    });
  }

  /// `candidate < selected`; see [greaterThan] for the type guard.
  static FilterMatcher<T> lessThan<T extends Comparable<Object>>() {
    return FilterMatcher<T>((selected, candidate) {
      if (candidate is! T) return false;
      return selected.compareTo(candidate) > 0;
    });
  }

  static RegExp _likeExpression(String pattern, bool caseSensitive) {
    final StringBuffer buffer = StringBuffer('^');
    for (var i = 0; i < pattern.length; i++) {
      final String char = pattern[i];
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

/// One selectable matcher of a [FilterField].
@immutable
class FilterMatcherOption<T> {
  /// Creates a matcher option.
  const FilterMatcherOption({
    required this.id,
    required this.label,
    required this.matcher,
  });

  /// Stable id stored by `setMatcherIdOf`.
  final String id;

  /// Label shown by a matcher picker.
  final String label;

  /// The rule this option selects.
  final FilterMatcher<T> matcher;
}

/// A typed custom filter keyed by [id].
@immutable
class FilterField<T> {
  /// Creates a filter field.
  const FilterField({
    required this.id,
    this.label,
    this.matcher,
    this.matchers = const [],
    this.defaultMatcherId,
  });

  /// Key under which the value is stored in `customFilters`.
  final String id;

  /// Optional display label.
  final String? label;

  /// Fallback matcher when [matchers] is empty.
  final FilterMatcher<T>? matcher;

  /// Selectable matchers; empty means a single [matcher].
  final List<FilterMatcherOption<T>> matchers;

  /// Matcher selected until the user picks another.
  final String? defaultMatcherId;
}

/// Tests one model against one [FilterState].
@immutable
abstract class FilterBinding<TModel> {
  /// Creates a binding.
  const FilterBinding();

  /// Whether [model] passes this binding under [state].
  bool matches(FilterState state, TModel model);
}
