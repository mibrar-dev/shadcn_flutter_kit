// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Typed exceptions (ApiException/AuthException/ValidationException) used by rules.
// Throw these from adapters/repositories to ensure consistent mapping and UI messages.

/// ApiException defines a reusable type for this registry module.
class ApiException implements Exception {
  ApiException({required this.statusCode, this.message, this.details});

  /// Stores `statusCode` state/configuration for this implementation.
  final int statusCode;

  /// Stores `message` state/configuration for this implementation.
  final String? message;

  /// Stores `details` state/configuration for this implementation.
  final Object? details;

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() =>
      'ApiException(statusCode: $statusCode, message: $message, details: $details)';
}

/// AuthException defines a reusable type for this registry module.
class AuthException implements Exception {
  AuthException({this.message, this.reason});

  /// Stores `message` state/configuration for this implementation.
  final String? message;

  /// Stores `reason` state/configuration for this implementation.
  final String? reason;

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() => 'AuthException(message: $message, reason: $reason)';
}

/// ValidationException defines a reusable type for this registry module.
class ValidationException implements Exception {
  ValidationException({this.message, this.fieldErrors = const {}});

  /// Stores `message` state/configuration for this implementation.
  final String? message;

  /// Stores `fieldErrors` state/configuration for this implementation.
  final Map<String, String> fieldErrors;

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() =>
      'ValidationException(message: $message, fieldErrors: $fieldErrors)';
}
