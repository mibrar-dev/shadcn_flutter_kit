// Widget-leg validation glue for EditableText wrappers.

import 'package:flutter/widgets.dart';

import '../form_core/form_core.dart';

/// Runs a widget-leg validator against a text getter, honouring
/// [FormValidationMode].
///
/// The owner reads [errorText] at build time; call [onChanged] after text
/// changes, [validateNow] for explicit revalidation and [validateInitial] once
/// at init. Nothing here calls `setState`: the owner decides when to rebuild.
class EditableTextValidation {
  /// Creates a validation helper.
  EditableTextValidation({
    required this.text,
    this.validator,
    this.mode = FormValidationMode.changed,
  });

  /// Reads the current field text.
  final String Function() text;

  /// The widget-leg validator.
  String? Function(String? value)? validator;

  /// When validation runs automatically.
  FormValidationMode mode;

  /// The last validator result, or null.
  String? errorText;

  /// Applies new widget values; clearing the validator clears the error.
  void update({
    required String? Function(String? value)? validator,
    required FormValidationMode mode,
  }) {
    this.validator = validator;
    this.mode = mode;
    if (validator == null) {
      errorText = null;
    }
  }

  /// Validates once when [mode] is [FormValidationMode.initial].
  void validateInitial() {
    if (validator != null && mode == FormValidationMode.initial) {
      errorText = validator!(text());
    }
  }

  /// Validates on a text change when [mode] is [FormValidationMode.changed].
  void onChanged() {
    if (validator != null && mode == FormValidationMode.changed) {
      validateNow();
    }
  }

  /// Validates immediately, regardless of [mode].
  void validateNow() {
    final validator = this.validator;
    if (validator == null) {
      return;
    }
    errorText = validator(text());
  }
}
