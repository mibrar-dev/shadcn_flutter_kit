// Rule-based error mapping for the `error_handling` primitive: the [ErrorRule]
// unit, the mapper, the mutable registry and the built-in rule builders.
//
// Ported from `components/utility/error_system/_impl/core/{error_rule,
// error_mapper,error_registry}.dart` and `_impl/utils/{api_rules,auth_rules,
// validation_rules,platform_rules}.dart`.

import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/widgets.dart' show VoidCallback;

import 'error_models.dart';

/// Predicate deciding whether a rule handles an error.
typedef ErrorMatch = bool Function(Object error, StackTrace? stackTrace);

/// Builds an [AppError] from a handled error.
typedef ErrorBuild = AppError Function(Object error, StackTrace? stackTrace);

/// One mapping rule; rules are tried in descending [priority].
class ErrorRule {
  /// Creates a mapping rule.
  const ErrorRule({
    required this.matches,
    required this.build,
    this.priority = 0,
  });

  /// Predicate.
  final ErrorMatch matches;

  /// Factory.
  final ErrorBuild build;

  /// Higher runs first.
  final int priority;
}

/// Builds an [ErrorRule] from a typed [build] and an optional [where] guard.
ErrorRule rule<T>({
  required AppError Function(T error, StackTrace? stackTrace) build,
  bool Function(T error, StackTrace? stackTrace)? where,
  int priority = 0,
}) {
  return ErrorRule(
    matches: (Object e, StackTrace? st) =>
        e is T && (where == null || where(e as T, st)),
    build: (Object e, StackTrace? st) => build(e as T, st),
    priority: priority,
  );
}

/// Converts any thrown error into an [AppError].
abstract class ErrorMapper {
  /// Maps [error] to an [AppError].
  AppError map(Object error, [StackTrace? stackTrace]);
}

/// Tries [rules] in priority order, then [fallback].
class RuleBasedErrorMapper implements ErrorMapper {
  /// Creates a rule-based mapper.
  RuleBasedErrorMapper({required List<ErrorRule> rules, required this.fallback})
    : rules = List<ErrorRule>.from(rules)
        ..sort((ErrorRule a, ErrorRule b) => b.priority.compareTo(a.priority));

  /// Rules, sorted by priority.
  final List<ErrorRule> rules;

  /// Used when no rule matches.
  final AppError Function(Object error, StackTrace? stackTrace) fallback;

  @override
  AppError map(Object error, [StackTrace? stackTrace]) {
    for (final ErrorRule r in rules) {
      if (r.matches(error, stackTrace)) {
        return r.build(error, stackTrace);
      }
    }
    return fallback(error, stackTrace);
  }
}

/// A mutable [ErrorRule] list features can register into at runtime.
class ErrorRegistry {
  /// Creates a registry, optionally seeded with [rules].
  ErrorRegistry({List<ErrorRule>? rules})
    : _rules = List<ErrorRule>.from(rules ?? const <ErrorRule>[]);

  final List<ErrorRule> _rules;

  /// An unmodifiable view of the registered rules.
  List<ErrorRule> get rules => List<ErrorRule>.unmodifiable(_rules);

  /// Registers one rule.
  void add(ErrorRule rule) => _rules.add(rule);

  /// Registers several rules.
  void addAll(Iterable<ErrorRule> rules) => _rules.addAll(rules);

  /// Removes every rule.
  void clear() => _rules.clear();
}

/// Rules mapping `ApiException` and `TimeoutException` to [AppError].
List<ErrorRule> apiRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  required VoidCallback onBack,
}) {
  return <ErrorRule>[
    rule<ApiException>(
      priority: 5,
      build: (ApiException e, StackTrace? st) => AppError(
        code: _mapStatusToCode(e.statusCode),
        title: _titleForStatus(e.statusCode),
        message: e.message ?? _messageForStatus(e.statusCode),
        actions: <ErrorAction>[
          if (e.statusCode >= 500) ErrorAction.retry(onRetry),
          ErrorAction.back(onBack),
          ErrorAction.report(onReport),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: <String, Object?>{'statusCode': e.statusCode},
      ),
    ),
    rule<TimeoutException>(
      priority: 4,
      build: (TimeoutException e, StackTrace? st) => AppError(
        code: AppErrorCode.timeout,
        title: 'Request timed out',
        message: 'The server is taking too long to respond.',
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry),
          ErrorAction.report(onReport),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
    ),
  ];
}

/// Rules mapping `AuthException` to [AppError].
List<ErrorRule> authRules({
  required VoidCallback onLogin,
  required VoidCallback onRetry,
  required VoidCallback onReport,
}) {
  return <ErrorRule>[
    rule<AuthException>(
      priority: 8,
      build: (AuthException e, StackTrace? st) => AppError(
        code: AppErrorCode.unauthorized,
        title: 'Authentication required',
        message: e.message ?? 'Please log in to continue.',
        actions: <ErrorAction>[
          ErrorAction.login(onLogin),
          ErrorAction.retry(onRetry),
          ErrorAction.report(onReport),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
    ),
  ];
}

/// Rules mapping `ValidationException` to [AppError].
List<ErrorRule> validationRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
}) {
  return <ErrorRule>[
    rule<ValidationException>(
      priority: 6,
      build: (ValidationException e, StackTrace? st) => AppError(
        code: AppErrorCode.validation,
        title: 'Invalid input',
        message: e.message ?? 'Please review the highlighted fields.',
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry),
          ErrorAction.report(onReport),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: <String, Object?>{'fields': e.fieldErrors},
      ),
    ),
  ];
}

/// Rules mapping `PlatformException` to [AppError].
List<ErrorRule> platformRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
}) {
  return <ErrorRule>[
    rule<PlatformException>(
      priority: 3,
      build: (PlatformException e, StackTrace? st) => AppError(
        code: AppErrorCode.platformError,
        title: 'Platform error',
        message: e.message ?? 'Something went wrong on this device.',
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry),
          ErrorAction.report(onReport),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: <String, Object?>{'code': e.code},
      ),
    ),
  ];
}

AppErrorCode _mapStatusToCode(int statusCode) {
  if (statusCode == 400) return AppErrorCode.badRequest;
  if (statusCode == 401) return AppErrorCode.unauthorized;
  if (statusCode == 403) return AppErrorCode.forbidden;
  if (statusCode == 404) return AppErrorCode.notFound;
  if (statusCode == 409) return AppErrorCode.conflict;
  if (statusCode == 422) return AppErrorCode.validation;
  if (statusCode == 429) return AppErrorCode.rateLimited;
  if (statusCode >= 500) return AppErrorCode.server;
  return AppErrorCode.unknown;
}

String _titleForStatus(int statusCode) => switch (statusCode) {
  400 => 'Bad request',
  401 => 'Unauthorized',
  403 => 'Access denied',
  404 => 'Not found',
  409 => 'Conflict',
  422 => 'Invalid data',
  429 => 'Too many requests',
  _ => 'Server error',
};

String _messageForStatus(int statusCode) => switch (statusCode) {
  400 => 'The request was invalid. Please review and try again.',
  401 => 'Please log in to continue.',
  403 => 'You do not have permission to perform this action.',
  404 => 'We couldn’t find what you were looking for.',
  409 => 'This action conflicts with existing data.',
  422 => 'Some fields need your attention.',
  429 => 'Please wait a moment and try again.',
  _ => 'The server encountered a problem. Please try again.',
};
