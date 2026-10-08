// Error models for the `error_handling` primitive: the [AppError] shape, the
// action factories and the typed exceptions the built-in rules match on.
//
// Ported from `components/utility/error_system/_impl/core/{app_error,error_code,
// error_action,error_scope_type,error_exceptions}.dart`. Icons come from the
// Lucide set (the old tree used Radix, which the new tree keeps only as a
// legacy set).

import 'package:flutter/widgets.dart';

import '../../foundation/icons/lucide_icons.dart';
import '../localizations/localizations.dart';

/// Compile-time flags for the error handling primitive.
class Env {
  /// Whether [AppError.technicalDetails] is attached by the built-in rules.
  /// Set with `--dart-define=SHADCN_SHOW_TECHNICAL_ERRORS=true`.
  static bool showTechnicalDetails = const bool.fromEnvironment(
    'SHADCN_SHOW_TECHNICAL_ERRORS',
    defaultValue: false,
  );
}

/// Severity of an [AppError]; drives the icon and border colour.
enum AppErrorCode {
  network,
  timeout,
  noInternet,
  sslError,
  unauthorized,
  forbidden,
  sessionExpired,
  invalidCredentials,
  notFound,
  conflict,
  validation,
  rateLimited,
  server,
  badRequest,
  cancelled,
  invalidInput,
  platformError,
  permissionDenied,
  unknown,
}

/// Where an error is published in [AppErrorHub].
enum ErrorScopeType { app, screen }

/// What an [ErrorAction] does.
enum ErrorActionType { retry, report, navigate, custom }

/// A user action rendered by the error UI.
class ErrorAction {
  /// Creates an error action.
  const ErrorAction({
    required this.label,
    required this.onPressed,
    this.primary = false,
    this.icon,
    this.type = ErrorActionType.custom,
  });

  /// Retry the failed operation.
  factory ErrorAction.retry(
    VoidCallback onRetry, {
    ShadcnLocalizations strings = ShadcnLocalizations.english,
  }) => ErrorAction(
    label: strings.errorActionRetry,
    onPressed: onRetry,
    primary: true,
    icon: LucideIcons.refreshCw,
    type: ErrorActionType.retry,
  );

  /// Report the error.
  factory ErrorAction.report(
    VoidCallback onReport, {
    ShadcnLocalizations strings = ShadcnLocalizations.english,
  }) => ErrorAction(
    label: strings.errorActionReport,
    onPressed: onReport,
    icon: LucideIcons.messageCircleQuestion,
    type: ErrorActionType.report,
  );

  /// Navigate back.
  factory ErrorAction.back(
    VoidCallback onBack, {
    ShadcnLocalizations strings = ShadcnLocalizations.english,
  }) => ErrorAction(
    label: strings.errorActionBack,
    onPressed: onBack,
    icon: LucideIcons.arrowLeft,
    type: ErrorActionType.navigate,
  );

  /// Log in again.
  factory ErrorAction.login(
    VoidCallback onLogin, {
    ShadcnLocalizations strings = ShadcnLocalizations.english,
  }) => ErrorAction(
    label: strings.errorActionLogin,
    onPressed: onLogin,
    primary: true,
    icon: LucideIcons.logIn,
    type: ErrorActionType.navigate,
  );

  /// Open settings.
  factory ErrorAction.settings(
    VoidCallback onSettings, {
    ShadcnLocalizations strings = ShadcnLocalizations.english,
  }) => ErrorAction(
    label: strings.errorActionSettings,
    onPressed: onSettings,
    icon: LucideIcons.settings,
    type: ErrorActionType.navigate,
  );

  /// Contact support.
  factory ErrorAction.contactSupport(
    VoidCallback onContact, {
    ShadcnLocalizations strings = ShadcnLocalizations.english,
  }) => ErrorAction(
    label: strings.errorActionContactSupport,
    onPressed: onContact,
    icon: LucideIcons.messageCircle,
    type: ErrorActionType.navigate,
  );

  /// Dismiss the error.
  ///
  /// The label is [ShadcnLocalizations.dialogDismiss] - Flutter's translated
  /// `modalBarrierDismissLabel` - because the two share the English string.
  factory ErrorAction.dismiss(
    VoidCallback onDismiss, {
    ShadcnLocalizations strings = ShadcnLocalizations.english,
  }) => ErrorAction(label: strings.dialogDismiss, onPressed: onDismiss);

  /// Button label.
  final String label;

  /// Called on press.
  final VoidCallback onPressed;

  /// Whether the action is the primary control.
  final bool primary;

  /// Optional leading icon.
  final IconData? icon;

  /// Semantic kind of the action.
  final ErrorActionType type;
}

/// A UI-safe, user-facing error.
class AppError implements Exception {
  /// Creates an app error.
  AppError({
    required this.code,
    required this.title,
    required this.message,
    this.actions = const <ErrorAction>[],
    this.technicalDetails,
    this.metadata,
    DateTime? timestamp,
    this.fingerprint,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Severity category.
  final AppErrorCode code;

  /// Short headline.
  final String title;

  /// User-facing message.
  final String message;

  /// Actions rendered by the UI.
  final List<ErrorAction> actions;

  /// Developer-only details; never rendered by default.
  final String? technicalDetails;

  /// Analytics metadata.
  final Map<String, Object?>? metadata;

  /// When the error was created.
  final DateTime timestamp;

  /// Stable identifier for deduplication.
  final String? fingerprint;

  /// Whether [technicalDetails] is present and non-blank.
  bool get hasTechnicalDetails =>
      technicalDetails != null && technicalDetails!.trim().isNotEmpty;

  /// Whether [metadata] is non-empty.
  bool get hasMetadata => metadata != null && metadata!.isNotEmpty;

  /// Whether [actions] is non-empty.
  bool get hasActions => actions.isNotEmpty;

  /// Returns a copy with [newActions].
  AppError copyWithActions(List<ErrorAction> newActions) => AppError(
    code: code,
    title: title,
    message: message,
    actions: newActions,
    technicalDetails: technicalDetails,
    metadata: metadata,
    timestamp: timestamp,
    fingerprint: fingerprint,
  );

  /// JSON form for analytics.
  Map<String, Object?> toJson() => <String, Object?>{
    'code': code.name,
    'title': title,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'fingerprint': fingerprint,
    'metadata': metadata,
  };

  @override
  String toString() =>
      'AppError(code: $code, title: $title, message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppError &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          title == other.title &&
          message == other.message;

  @override
  int get hashCode => code.hashCode ^ title.hashCode ^ message.hashCode;
}

/// Thrown by an API adapter; mapped by `apiRules`.
class ApiException implements Exception {
  /// Creates an API exception.
  ApiException({required this.statusCode, this.message, this.details});

  /// HTTP-like status code.
  final int statusCode;

  /// Optional server message.
  final String? message;

  /// Optional payload.
  final Object? details;

  @override
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, details: $details)';
}

/// Thrown by an auth adapter; mapped by `authRules`.
class AuthException implements Exception {
  /// Creates an auth exception.
  AuthException({this.message, this.reason});

  /// Optional message.
  final String? message;

  /// Optional reason.
  final String? reason;

  @override
  String toString() => 'AuthException(message: $message, reason: $reason)';
}

/// Thrown by a validation adapter; mapped by `validationRules`.
class ValidationException implements Exception {
  /// Creates a validation exception.
  ValidationException({
    this.message,
    this.fieldErrors = const <String, String>{},
  });

  /// Optional message.
  final String? message;

  /// Per-field messages.
  final Map<String, String> fieldErrors;

  @override
  String toString() =>
      'ValidationException(message: $message, fieldErrors: $fieldErrors)';
}
