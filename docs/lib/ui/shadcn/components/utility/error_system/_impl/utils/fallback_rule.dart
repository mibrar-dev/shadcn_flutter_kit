// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// fallbackRule: default mapping when no ErrorRule matches.
// Produces a generic AppError (AppErrorCode.unknown) with optional technical details.

import '../core/app_error.dart';
import '../core/error_code.dart';
import 'env.dart';
import 'error_fingerprint.dart';

/// Executes `fallbackRule` behavior for this component/composite.
AppError fallbackRule(Object error, [StackTrace? stackTrace]) {
  /// Stores `details` state/configuration for this implementation.
  final details = Env.showTechnicalDetails ? '$error\n$stackTrace' : null;
  final appError = AppError(
    code: AppErrorCode.unknown,
    title: 'Something went wrong',
    message: 'Please try again or contact support if the issue persists.',
    technicalDetails: details,
    metadata: const {},
  );
  final fingerprint = fingerprintFor(appError);
  return AppError(
    code: appError.code,
    title: appError.title,
    message: appError.message,
    actions: appError.actions,
    technicalDetails: appError.technicalDetails,
    metadata: {'fingerprint': fingerprint},
    fingerprint: fingerprint,
  );
}
