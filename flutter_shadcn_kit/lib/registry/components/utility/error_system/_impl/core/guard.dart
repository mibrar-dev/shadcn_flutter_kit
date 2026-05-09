// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// guard/guardSync: run an operation and publish any AppError to a provided ErrorScope.
// Use this when you want reactive UI updates without writing try/catch in every call site.

import 'package:flutter/foundation.dart';

import 'app_error.dart';
import 'error_code.dart';
import 'error_mapper.dart';
import 'error_scope.dart';

/// Type alias for `AsyncFn` used by public or internal APIs.
typedef AsyncFn<T> = Future<T> Function();

Future<T?> guard<T>(
  AsyncFn<T> fn, {
  ErrorScope? scope,
  ValueNotifier<AppError?>? channel,
  bool clearBeforeRun = true,
  ErrorMapper? fallbackMapper,
}) async {
  /// Stores `notifier` state/configuration for this implementation.
  final notifier = channel ?? scope?.notifier;
  if (notifier == null) {
    throw ArgumentError('guard() requires either scope or channel.');
  }

  if (clearBeforeRun) {
    scope?.clear();
    notifier.value = null;
  }

  try {
    return await fn();
  } on AppError catch (e) {
    notifier.value = e;
    return null;
  } catch (e, st) {
    notifier.value =
        fallbackMapper?.map(e, st) ??
        /// Creates a `AppError` instance.
        AppError(
          code: AppErrorCode.unknown,
          title: 'Unexpected Error',
          message: 'Something went wrong. Please try again.',
          technicalDetails: '$e\n$st',
        );
    return null;
  }
}

T? guardSync<T>(
  T Function() fn, {
  ErrorScope? scope,
  ValueNotifier<AppError?>? channel,
  bool clearBeforeRun = true,
  ErrorMapper? fallbackMapper,
}) {
  /// Stores `notifier` state/configuration for this implementation.
  final notifier = channel ?? scope?.notifier;
  if (notifier == null) {
    throw ArgumentError('guardSync() requires either scope or channel.');
  }

  if (clearBeforeRun) {
    scope?.clear();
    notifier.value = null;
  }

  try {
    return fn();
  } on AppError catch (e) {
    notifier.value = e;
    return null;
  } catch (e, st) {
    notifier.value =
        fallbackMapper?.map(e, st) ??
        /// Creates a `AppError` instance.
        AppError(
          code: AppErrorCode.unknown,
          title: 'Unexpected Error',
          message: 'Something went wrong. Please try again.',
          technicalDetails: '$e\n$st',
        );
    return null;
  }
}
