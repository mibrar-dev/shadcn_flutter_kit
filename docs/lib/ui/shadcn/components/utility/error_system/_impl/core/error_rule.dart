// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorRule + rule<T>(): rule-based mapping unit for converting exceptions -> AppError.
// Each rule has a matches() predicate and a build() factory, ordered by priority.

import 'app_error.dart';

/// Type alias for `ErrorMatch` used by public or internal APIs.
typedef ErrorMatch = bool Function(Object error, StackTrace? stackTrace);

/// Type alias for `ErrorBuild` used by public or internal APIs.
typedef ErrorBuild = AppError Function(Object error, StackTrace? stackTrace);

/// ErrorRule defines a reusable type for this registry module.
class ErrorRule {
  /// Creates a `ErrorRule` instance.
  const ErrorRule({
    required this.matches,
    required this.build,
    this.priority = 0,
  });

  /// Stores `matches` state/configuration for this implementation.
  final ErrorMatch matches;

  /// Stores `build` state/configuration for this implementation.
  final ErrorBuild build;

  /// Stores `priority` state/configuration for this implementation.
  final int priority;
}

ErrorRule rule<T>({
  required AppError Function(T error, StackTrace? stackTrace) build,
  bool Function(T error, StackTrace? stackTrace)? where,
  int priority = 0,
}) {
  return ErrorRule(
    matches: (e, st) => e is T && (where == null || where(e as T, st)),
    build: (e, st) => build(e as T, st),
    priority: priority,
  );
}
