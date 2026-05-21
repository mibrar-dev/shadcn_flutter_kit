// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Validation rules for mapping ValidationException to AppError.
// Attaches field metadata and provides retry/report actions for correction flows.

import 'package:flutter/widgets.dart';

import '../core/app_error.dart';
import '../core/error_action.dart';
import '../core/error_code.dart';
import '../core/error_exceptions.dart';
import '../core/error_rule.dart';
import 'env.dart';

List<ErrorRule> validationRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
}) {
  return [
    rule<ValidationException>(
      build: (e, st) => AppError(
        code: AppErrorCode.validation,
        title: 'Invalid input',
        message: e.message ?? 'Please review the highlighted fields.',
        actions: [ErrorAction.retry(onRetry), ErrorAction.report(onReport)],
        technicalDetails: Env.showTechnicalDetails ? '$e\n$st' : null,
        metadata: {'fields': e.fieldErrors},
      ),
      priority: 6,
    ),
  ];
}
