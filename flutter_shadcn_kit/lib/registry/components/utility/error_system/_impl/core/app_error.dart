// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// AppError: UI-safe, user-facing error model used across the system.
// Carries code/title/message/actions plus optional technicalDetails/metadata for analytics.

import 'error_action.dart';
import 'error_code.dart';

/// AppError defines a reusable type for this registry module.
class AppError implements Exception {
  /// Creates a `AppError` instance.
  AppError({
    required this.code,
    required this.title,
    required this.message,
    this.actions = const [],
    this.technicalDetails,
    this.metadata,
    DateTime? timestamp,
    this.fingerprint,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Stores `code` state/configuration for this implementation.
  final AppErrorCode code;

  /// Stores `title` state/configuration for this implementation.
  final String title;

  /// Stores `message` state/configuration for this implementation.
  final String message;

  /// Stores `actions` state/configuration for this implementation.
  final List<ErrorAction> actions;

  /// Stores `technicalDetails` state/configuration for this implementation.
  final String? technicalDetails;

  /// Stores `metadata` state/configuration for this implementation.
  final Map<String, dynamic>? metadata;

  /// Stores `timestamp` state/configuration for this implementation.
  final DateTime timestamp;

  /// Stores `fingerprint` state/configuration for this implementation.
  final String? fingerprint;

  bool get hasTechnicalDetails =>
      technicalDetails != null && technicalDetails!.trim().isNotEmpty;

  /// Stores `hasMetadata` state/configuration for this implementation.
  bool get hasMetadata => metadata != null && metadata!.isNotEmpty;

  /// Stores `hasActions` state/configuration for this implementation.
  bool get hasActions => actions.isNotEmpty;

  /// Executes `copyWithActions` behavior for this component/composite.
  AppError copyWithActions(List<ErrorAction> newActions) {
    return AppError(
      code: code,
      title: title,
      message: message,
      actions: newActions,
      technicalDetails: technicalDetails,
      metadata: metadata,
      timestamp: timestamp,
      fingerprint: fingerprint,
    );
  }

  /// Executes `toJson` behavior for this component/composite.
  Map<String, dynamic> toJson() => {
    'code': code.name,
    'title': title,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
    'fingerprint': fingerprint,
    'metadata': metadata,
  };

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() =>
      'AppError(code: $code, title: $title, message: $message)';

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) =>
      /// Creates a `identical` instance.
      identical(this, other) ||
      other is AppError &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          title == other.title &&
          message == other.message;

  @override
  /// Stores `hashCode` state/configuration for this implementation.
  int get hashCode => code.hashCode ^ title.hashCode ^ message.hashCode;
}
