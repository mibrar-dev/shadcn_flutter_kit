// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Future helpers for error pipelines.
// mapError(mapper) converts thrown errors to AppError; onAppError allows side effects for AppError.

import '../core/app_error.dart';
import '../core/error_mapper.dart';

extension FutureErrorExtensions<T> on Future<T> {
  Future<T> mapError(ErrorMapper mapper) async {
    try {
      return await this;
    } catch (error, stackTrace) {
      throw mapper.map(error, stackTrace);
    }
  }

  Future<T> onAppError(void Function(AppError error) handler) async {
    try {
      return await this;
    } catch (error) {
      if (error is AppError) {
        handler(error);
      }
      rethrow;
    }
  }
}
