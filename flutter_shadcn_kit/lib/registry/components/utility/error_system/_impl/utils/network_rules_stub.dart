// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// Network rules stub for non-IO platforms.
// Returns no rules because dart:io exception types are unavailable on web.

import 'package:flutter/widgets.dart';

import '../core/error_rule.dart';

List<ErrorRule> networkRules({
  required VoidCallback onRetry,
  required VoidCallback onReport,
  required VoidCallback onSettings,
}) {
  return const [];
}
