// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// RetryStrategy: computes exponential backoff delays with jitter.
// Use delayForAttempt(attempt) to schedule retries in networking/data layers.

import 'dart:math';

/// RetryStrategy defines a reusable type for this registry module.
class RetryStrategy {
  /// Creates a `RetryStrategy` instance.
  RetryStrategy({
    this.maxAttempts = 3,
    this.baseDelay = const Duration(milliseconds: 300),
    this.maxDelay = const Duration(seconds: 5),
    this.jitter = 0.2,
  });

  /// Stores `maxAttempts` state/configuration for this implementation.
  final int maxAttempts;

  /// Stores `baseDelay` state/configuration for this implementation.
  final Duration baseDelay;

  /// Stores `maxDelay` state/configuration for this implementation.
  final Duration maxDelay;

  /// Stores `jitter` state/configuration for this implementation.
  final double jitter;

  /// Executes `delayForAttempt` behavior for this component/composite.
  Duration delayForAttempt(int attempt) {
    final exp = pow(2, attempt).toDouble();

    /// Stores `raw` state/configuration for this implementation.
    final raw = baseDelay.inMilliseconds * exp;
    final capped = raw.clamp(baseDelay.inMilliseconds, maxDelay.inMilliseconds);
    final jitterFactor = 1 + ((Random().nextDouble() * 2 - 1) * jitter);
    return Duration(milliseconds: (capped * jitterFactor).round());
  }
}
