// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// _ValidatorResultStash represents a form-related type in the registry.
class _ValidatorResultStash {
  /// Field storing `result` for this form implementation.
  final FutureOr<ValidationResult?> result;

  /// Field storing `state` for this form implementation.
  final FormValidationMode state;

  const _ValidatorResultStash(this.result, this.state);
}
