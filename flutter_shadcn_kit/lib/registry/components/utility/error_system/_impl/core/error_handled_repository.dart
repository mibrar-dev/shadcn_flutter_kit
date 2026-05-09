// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// ErrorHandledRepository: base class for repositories with automatic AppError mapping.
// execute()/executeSync() wrap operations, map errors via ErrorMapper, and forward to ErrorReporter.

import 'app_error.dart';
import 'error_mapper.dart';
import '../utils/error_reporter.dart';

/// ErrorHandledRepository defines a reusable type for this registry module.
abstract class ErrorHandledRepository {
  ErrorHandledRepository({required this.errorMapper, this.errorReporter});

  /// Stores `errorMapper` state/configuration for this implementation.
  final ErrorMapper errorMapper;

  /// Stores `errorReporter` state/configuration for this implementation.
  final ErrorReporter? errorReporter;

  Future<T> execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final mapped = errorMapper.map(error, stackTrace);
      errorReporter?.report(mapped, error, stackTrace);

      /// Stores `mapped` state/configuration for this implementation.
      throw mapped;
    }
  }

  T executeSync<T>(T Function() operation) {
    try {
      return operation();
    } catch (error, stackTrace) {
      final mapped = errorMapper.map(error, stackTrace);
      errorReporter?.report(mapped, error, stackTrace);

      /// Stores `mapped` state/configuration for this implementation.
      throw mapped;
    }
  }

  Future<T> executeWithHandler<T>({
    required Future<T> Function() operation,
    required T? Function(Object error) onError,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final handled = onError(error);
      if (handled != null) return handled;
      final mapped = errorMapper.map(error, stackTrace);
      errorReporter?.report(mapped, error, stackTrace);

      /// Stores `mapped` state/configuration for this implementation.
      throw mapped;
    }
  }
}
