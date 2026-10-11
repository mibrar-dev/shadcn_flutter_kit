// Network rules for the `error_handling` primitive.
//
// The old tree split this into `network_rules{,_io,_stub}.dart` behind a
// conditional export. That pair declares the same top-level `networkRules`
// twice, which the single-owner check rejects, and `dart:io` types cannot be
// named on web. This single file matches the IO exception types by name, so the
// rules build everywhere (on web they simply never match).

import 'dart:async';

import 'package:flutter/widgets.dart' show VoidCallback;

import '../localizations/localizations.dart';
import 'error_models.dart';
import 'error_rules.dart';

/// Rules mapping `SocketException` / `TimeoutException` / `HandshakeException`
/// to [AppError].
///
/// [strings] localizes the built-in titles, messages and action labels; it
/// defaults to the English table.
List<ErrorRule> networkRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  required VoidCallback onSettings,
  ShadcnLocalizations strings = ShadcnLocalizations.english,
}) {
  ErrorRule ioRule(
    String typeName, {
    required AppError Function(Object error) build,
    required int priority,
  }) {
    return ErrorRule(
      priority: priority,
      matches: (Object e, StackTrace? st) => e.toString().startsWith(typeName),
      build: (Object e, StackTrace? st) => build(e),
    );
  }

  return <ErrorRule>[
    ioRule(
      'SocketException',
      priority: 10,
      build: (Object e) => AppError(
        code: AppErrorCode.network,
        title: strings.errorConnectionFailed,
        message: strings.errorConnectionFailedMessage,
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.settings(onSettings, strings: strings),
          ErrorAction.report(onReport, strings: strings),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e' : null,
        metadata: <String, Object?>{'error': '$e'},
      ),
    ),
    rule<TimeoutException>(
      priority: 9,
      build: (TimeoutException e, StackTrace? st) => AppError(
        code: AppErrorCode.timeout,
        title: strings.errorRequestTimedOut,
        message: strings.errorRequestTimedOutMessage,
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.report(onReport, strings: strings),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
    ),
    ioRule(
      'HandshakeException',
      priority: 8,
      build: (Object e) => AppError(
        code: AppErrorCode.sslError,
        title: strings.errorSecureConnectionFailed,
        message: strings.errorSecureConnectionMessage,
        actions: <ErrorAction>[
          ErrorAction.retry(onRetry, strings: strings),
          ErrorAction.report(onReport, strings: strings),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e' : null,
      ),
    ),
  ];
}
