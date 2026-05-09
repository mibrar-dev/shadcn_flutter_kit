// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Network rules for IO platforms (Socket/Timeout/Handshake).
// Maps low-level IO exceptions to AppError with Retry/Settings/Report actions.

import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '../core/app_error.dart';
import '../core/error_action.dart';
import '../core/error_code.dart';
import '../core/error_rule.dart';
import 'env.dart';

List<ErrorRule> networkRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  required VoidCallback onSettings,
}) {
  return [
    rule<SocketException>(
      build: (e, st) => AppError(
        code: AppErrorCode.network,
        title: 'Connection failed',
        message: 'Check your internet connection and try again.',
        actions: [
          /// Creates a `ErrorAction.retry` instance.
          ErrorAction.retry(onRetry),

          /// Creates a `ErrorAction.settings` instance.
          ErrorAction.settings(onSettings),

          /// Creates a `ErrorAction.report` instance.
          ErrorAction.report(onReport),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: {'address': e.address?.host, 'port': e.port},
      ),
      priority: 10,
    ),
    rule<TimeoutException>(
      build: (e, st) => AppError(
        code: AppErrorCode.timeout,
        title: 'Request timed out',
        message: 'The server is taking too long to respond.',
        actions: [ErrorAction.retry(onRetry), ErrorAction.report(onReport)],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
      priority: 9,
    ),
    rule<HandshakeException>(
      build: (e, st) => AppError(
        code: AppErrorCode.sslError,
        title: 'Secure connection failed',
        message: 'We could not establish a secure connection.',
        actions: [ErrorAction.retry(onRetry), ErrorAction.report(onReport)],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
      priority: 8,
    ),
  ];
}
