// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

// BuildContext helpers for showing error UI.
// Adds context.showErrorSnackbar(appError) and context.showErrorDialog(appError).

import 'package:flutter/widgets.dart';

import '../core/app_error.dart';
import '../core/error_dialog.dart';
import '../core/error_snackbar.dart';

/// Extension helpers used by this registry module.
extension ContextErrorExtensions on BuildContext {
  /// Executes `showErrorSnackbar` behavior for this component/composite.
  void showErrorSnackbar(AppError error, {Duration? duration}) {
    ErrorSnackbar.show(context: this, error: error, duration: duration);
  }

  Future<T?> showErrorDialog<T>(
    AppError error, {
    bool barrierDismissible = true,
  }) {
    return ErrorDialog.show<T>(
      context: this,
      error: error,
      barrierDismissible: barrierDismissible,
    );
  }
}
