// Recovery helpers for the `error_handling` primitive: `guard`, the
// repository base class, the retry backoff, the reporter hook and the
// fingerprint / fallback utilities.
//
// Ported from `components/utility/error_system/_impl/core/{guard,
// error_handled_repository}.dart` and `_impl/utils/{error_reporter,
// retry_strategy,error_fingerprint,fallback_rule}.dart`.

import 'dart:math';

import 'package:flutter/foundation.dart';

import '../localizations/localizations.dart';
import 'error_models.dart';
import 'error_rules.dart';
import 'error_scopes.dart';

/// Runs [fn], publishing any error to [scope] (or [channel]).
///
/// Returns null when the operation failed; the error is on the channel.
/// [strings] localizes the fallback error built when no [mapper] maps it.
Future<T?> guard<T>(
  Future<T> Function() fn, {
  ErrorScope? scope,
  ValueNotifier<AppError?>? channel,
  bool clearBeforeRun = true,
  ErrorMapper? mapper,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
}) async {
  final ValueNotifier<AppError?> notifier = _resolveScope(scope, channel);
  if (clearBeforeRun) {
    notifier.value = null;
  }
  try {
    return await fn();
  } on AppError catch (error) {
    notifier.value = error;
    return null;
  } catch (error, stackTrace) {
    notifier.value =
        mapper?.map(error, stackTrace) ??
        _unexpected(error, stackTrace, strings);
    return null;
  }
}

/// The synchronous form of [guard].
T? guardSync<T>(
  T Function() fn, {
  ErrorScope? scope,
  ValueNotifier<AppError?>? channel,
  bool clearBeforeRun = true,
  ErrorMapper? mapper,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
}) {
  final ValueNotifier<AppError?> notifier = _resolveScope(scope, channel);
  if (clearBeforeRun) {
    notifier.value = null;
  }
  try {
    return fn();
  } on AppError catch (error) {
    notifier.value = error;
    return null;
  } catch (error, stackTrace) {
    notifier.value =
        mapper?.map(error, stackTrace) ??
        _unexpected(error, stackTrace, strings);
    return null;
  }
}

ValueNotifier<AppError?> _resolveScope(
  ErrorScope? scope,
  ValueNotifier<AppError?>? channel,
) {
  final ValueNotifier<AppError?>? notifier = channel ?? scope?.notifier;
  if (notifier == null) {
    throw ArgumentError('guard requires a scope or a channel');
  }
  return notifier;
}

AppError _unexpected(
  Object error,
  StackTrace? stackTrace,
  ShadcnLocalizations strings,
) => AppError(
  code: AppErrorCode.unknown,
  title: strings.errorSomethingWentWrong,
  message: strings.errorUnexpectedMessage,
  technicalDetails: stackTrace == null ? '$error' : '$error\n$stackTrace',
);

/// Base class for repositories with automatic [AppError] mapping.
abstract class ErrorHandledRepository {
  /// Creates a repository.
  ErrorHandledRepository({required this.errorMapper, this.errorReporter});

  /// Maps raw errors to [AppError].
  final ErrorMapper errorMapper;

  /// Optional analytics hook.
  final ErrorReporter? errorReporter;

  /// Runs [operation], mapping and reporting a failure as an [AppError].
  Future<T> execute<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final AppError mapped = errorMapper.map(error, stackTrace);
      errorReporter?.report(mapped, error, stackTrace);
      throw mapped;
    }
  }

  /// The synchronous form of [execute].
  T executeSync<T>(T Function() operation) {
    try {
      return operation();
    } catch (error, stackTrace) {
      final AppError mapped = errorMapper.map(error, stackTrace);
      errorReporter?.report(mapped, error, stackTrace);
      throw mapped;
    }
  }

  /// Runs [operation]; when [onError] returns a value it wins, otherwise the
  /// mapped [AppError] is reported and rethrown.
  Future<T> executeWithHandler<T>({
    required Future<T> Function() operation,
    required T? Function(Object error) onError,
  }) async {
    try {
      return await operation();
    } catch (error, stackTrace) {
      final T? handled = onError(error);
      if (handled != null) {
        return handled;
      }
      final AppError mapped = errorMapper.map(error, stackTrace);
      errorReporter?.report(mapped, error, stackTrace);
      throw mapped;
    }
  }
}

/// Computes exponential backoff delays with jitter.
class RetryStrategy {
  /// Creates a retry strategy.
  RetryStrategy({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 300),
    this.maxDelay = const Duration(seconds: 5),
    this.jitter = 0.2,
  });

  /// Maximum number of attempts.
  final int maxAttempts;

  /// Delay of the first attempt.
  final Duration baseDelay;

  /// Upper bound of the computed delay.
  final Duration maxDelay;

  /// Fraction of random jitter, 0..1.
  final double jitter;

  /// The delay before attempt [attempt] (0-based), capped at [maxDelay].
  Duration delayForAttempt(int attempt) {
    final double raw = baseDelay.inMilliseconds * pow(2, attempt).toDouble();
    final double capped = raw.clamp(
      baseDelay.inMilliseconds.toDouble(),
      maxDelay.inMilliseconds.toDouble(),
    );
    final double jitterFactor = 1 + ((Random().nextDouble() * 2 - 1) * jitter);
    return Duration(milliseconds: (capped * jitterFactor).round());
  }
}

/// Hook point for analytics / crash reporting.
abstract class ErrorReporter {
  /// Reports a mapped error.
  void report(AppError appError, Object error, StackTrace stackTrace);
}

/// An [ErrorReporter] that writes to the debug console.
class ConsoleErrorReporter implements ErrorReporter {
  @override
  void report(AppError appError, Object error, StackTrace stackTrace) {
    debugPrint('[ErrorReporter] $appError');
    debugPrint('$error');
  }
}

/// A stable identifier built from an [AppError]'s fields.
String fingerprintFor(AppError error) {
  final int hash = Object.hash(
    error.code,
    error.title,
    error.message,
    error.metadata?.toString(),
  );
  return hash.toRadixString(16);
}

/// The default mapping when no [ErrorRule] matches.
///
/// [strings] localizes the fallback title and message; it defaults to the
/// English table.
AppError fallbackRule(
  Object error, [
  StackTrace? stackTrace,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
]) {
  final String? details = Env.showTechnicalDetails
      ? '$error\n$stackTrace'
      : null;
  final String fingerprint = fingerprintFor(
    AppError(
      code: AppErrorCode.unknown,
      title: strings.errorSomethingWentWrong,
      message: strings.errorUnexpectedMessage,
    ),
  );
  return AppError(
    code: AppErrorCode.unknown,
    title: strings.errorSomethingWentWrong,
    message: strings.errorUnexpectedMessage,
    technicalDetails: details,
    metadata: <String, Object?>{'fingerprint': fingerprint},
    fingerprint: fingerprint,
  );
}
