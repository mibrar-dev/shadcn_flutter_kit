// Rule-based error mapping for the `error_handling` primitive: the [ErrorRule]
// unit, the mapper, the mutable registry and the built-in rule builders.
//
// Ported from `components/utility/error_system/_impl/core/{error_rule,
// error_mapper,error_registry}.dart` and `_impl/utils/{api_rules,auth_rules,
// validation_rules,platform_rules}.dart`.

import 'dart:async';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter/widgets.dart' show VoidCallback;

import '../localizations/localizations.dart';
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
///
/// [strings] localizes the built-in titles, messages and action labels;
/// it defaults to the English table.
List<ErrorRule> apiRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  required VoidCallback onBack,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
}) {
  return <ErrorRule>[
    rule<ApiException>(
      priority: 5,
      build: (ApiException e, StackTrace? st) => AppError(
        code: _mapStatusToCode(e.statusCode),
        title: _titleForStatus(strings, e.statusCode),
        message: e.message ?? _messageForStatus(strings, e.statusCode),
        actions: <ErrorAction>[
          if (e.statusCode >= 500) ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.back(onBack, strings: strings),
          ErrorAction.report(onReport, strings: strings),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: <String, Object?>{'statusCode': e.statusCode},
      ),
    ),
    rule<TimeoutException>(
      priority: 4,
      build: (TimeoutException e, StackTrace? st) => AppError(
        code: AppErrorCode.timeout,
        title: strings.errorRequestTimedOut,
        message: strings.errorRequestTimedOutMessage,
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.report(onReport, strings: strings),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
    ),
  ];
}

/// Rules mapping `AuthException` to [AppError].
///
/// [strings] localizes the built-in title, message and action labels; it
/// defaults to the English table.
List<ErrorRule> authRules({
  required VoidCallback onLogin,
  required VoidCallback onRetry,
  required VoidCallback onReport,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
}) {
  return <ErrorRule>[
    rule<AuthException>(
      priority: 8,
      build: (AuthException e, StackTrace? st) => AppError(
        code: AppErrorCode.unauthorized,
        title: strings.errorAuthenticationRequired,
        message: e.message ?? strings.errorLoginRequiredMessage,
        actions: <ErrorAction>[
          ErrorAction.login(onLogin, strings: strings),
          ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.report(onReport, strings: strings),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
    ),
  ];
}

/// Rules mapping `ValidationException` to [AppError].
///
/// [strings] localizes the built-in title, message and action labels; it
/// defaults to the English table.
List<ErrorRule> validationRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
}) {
  return <ErrorRule>[
    rule<ValidationException>(
      priority: 6,
      build: (ValidationException e, StackTrace? st) => AppError(
        code: AppErrorCode.validation,
        title: strings.errorInvalidInput,
        message: e.message ?? strings.errorReviewFieldsMessage,
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.report(onReport, strings: strings),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: <String, Object?>{'fields': e.fieldErrors},
      ),
    ),
  ];
}

/// Rules mapping `PlatformException` to [AppError].
///
/// [strings] localizes the built-in title, message and action labels; it
/// defaults to the English table.
List<ErrorRule> platformRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
}) {
  return <ErrorRule>[
    rule<PlatformException>(
      priority: 3,
      build: (PlatformException e, StackTrace? st) => AppError(
        code: AppErrorCode.platformError,
        title: strings.errorPlatformError,
        message: e.message ?? strings.errorDeviceErrorMessage,
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.report(onReport, strings: strings),
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

String _titleForStatus(ShadcnLocalizations s, int statusCode) =>
    switch (statusCode) {
      400 => s.errorBadRequest,
      401 => s.errorUnauthorized,
      403 => s.errorAccessDenied,
      404 => s.errorNotFound,
      409 => s.errorConflict,
      422 => s.errorInvalidData,
      429 => s.errorTooManyRequests,
      _ => s.errorServerError,
    };

String _messageForStatus(ShadcnLocalizations s, int statusCode) =>
    switch (statusCode) {
      400 => s.errorBadRequestMessage,
      401 => s.errorLoginRequiredMessage,
      403 => s.errorAccessDeniedMessage,
      404 => s.errorNotFoundMessage,
      409 => s.errorConflictMessage,
      422 => s.errorInvalidDataMessage,
      429 => s.errorTooManyRequestsMessage,
      _ => s.errorServerErrorMessage,
    };
