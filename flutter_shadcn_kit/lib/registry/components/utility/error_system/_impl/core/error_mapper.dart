// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorMapper + RuleBasedErrorMapper: converts any thrown error into an AppError.
// RuleBasedErrorMapper tries rules in priority order and falls back to a default mapping.

import 'app_error.dart';
import 'error_rule.dart';

/// ErrorMapper defines a reusable type for this registry module.
abstract class ErrorMapper {
  AppError map(Object error, [StackTrace? stackTrace]);
}

/// RuleBasedErrorMapper defines a reusable type for this registry module.
class RuleBasedErrorMapper implements ErrorMapper {
  /// Creates a `RuleBasedErrorMapper` instance.
  RuleBasedErrorMapper({required List<ErrorRule> rules, required this.fallback})
    : rules = _sortByPriority(rules);

  /// Stores `rules` state/configuration for this implementation.
  final List<ErrorRule> rules;
  final AppError Function(Object error, StackTrace? stackTrace) fallback;

  /// Executes `_sortByPriority` behavior for this component/composite.
  static List<ErrorRule> _sortByPriority(List<ErrorRule> rules) {
    final sorted = List<ErrorRule>.from(rules);
    sorted.sort((a, b) => b.priority.compareTo(a.priority));
    return sorted;
  }

  @override
  /// Executes `map` behavior for this component/composite.
  AppError map(Object error, [StackTrace? stackTrace]) {
    for (final rule in rules) {
      if (rule.matches(error, stackTrace)) {
        return rule.build(error, stackTrace);
      }
    }
    return fallback(error, stackTrace);
  }
}
