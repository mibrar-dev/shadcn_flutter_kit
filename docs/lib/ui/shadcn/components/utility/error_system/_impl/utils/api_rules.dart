// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// API rules for mapping ApiException and timeouts to AppError.
// Converts HTTP-like status codes into AppErrorCode and attaches context actions (retry/report/back).

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../core/app_error.dart';
import '../core/error_action.dart';
import '../core/error_code.dart';
import '../core/error_exceptions.dart';
import '../core/error_rule.dart';
import 'env.dart';

List<ErrorRule> apiRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  required VoidCallback onBack,
}) {
  return [
    rule<ApiException>(
      build: (e, st) => AppError(
        code: _mapStatusToCode(e.statusCode),
        title: _titleForStatus(e.statusCode),
        message: e.message ?? _messageForStatus(e.statusCode),
        actions: [
          if (e.statusCode >= 500) ErrorAction.retry(onRetry),

          /// Creates a `ErrorAction.back` instance.
          ErrorAction.back(onBack),

          /// Creates a `ErrorAction.report` instance.
          ErrorAction.report(onReport),
        ],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: {'statusCode': e.statusCode},
      ),
      priority: 5,
    ),
    rule<TimeoutException>(
      build: (e, st) => AppError(
        code: AppErrorCode.timeout,
        title: 'Request timed out',
        message: 'The server is taking too long to respond.',
        actions: [ErrorAction.retry(onRetry), ErrorAction.report(onReport)],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
      ),
      priority: 4,
    ),
  ];
}

/// Executes `_mapStatusToCode` behavior for this component/composite.
AppErrorCode _mapStatusToCode(int statusCode) {
  if (statusCode == 400) return AppErrorCode.badRequest;
  if (statusCode == 401) return AppErrorCode.unauthorized;
  if (statusCode == 403) return AppErrorCode.forbidden;
  if (statusCode == 404) return AppErrorCode.notFound;
  if (statusCode == 409) return AppErrorCode.conflict;
  if (statusCode == 422) return AppErrorCode.validation;
  if (statusCode == 429) return AppErrorCode.rateLimited;
  if (statusCode >= 500) return AppErrorCode.server;
  return AppErrorCode.unknown;
}

/// Executes `_titleForStatus` behavior for this component/composite.
String _titleForStatus(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'Bad request';
    case 401:
      return 'Unauthorized';
    case 403:
      return 'Access denied';
    case 404:
      return 'Not found';
    case 409:
      return 'Conflict';
    case 422:
      return 'Invalid data';
    case 429:
      return 'Too many requests';
    case 500:
    default:
      return 'Server error';
  }
}

/// Executes `_messageForStatus` behavior for this component/composite.
String _messageForStatus(int statusCode) {
  switch (statusCode) {
    case 400:
      return 'The request was invalid. Please review and try again.';
    case 401:
      return 'Please log in to continue.';
    case 403:
      return 'You do not have permission to perform this action.';
    case 404:
      return 'We couldn’t find what you were looking for.';
    case 409:
      return 'This action conflicts with existing data.';
    case 422:
      return 'Some fields need your attention.';
    case 429:
      return 'Please wait a moment and try again.';
    default:
      return 'The server encountered a problem. Please try again.';
  }
}
