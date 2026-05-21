// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A notification sent when a form field's validation state changes.
///
/// [FormValidityNotification] is dispatched through the notification system
/// when a field's validity transitions between valid, invalid, or null states.
/// Useful for updating UI or tracking form validation status.
class FormValidityNotification extends Notification {
  /// The previous validation result, or null if there was none.
  final ValidationResult? oldValidity;

  /// The new validation result, or null if now valid.
  final ValidationResult? newValidity;

  /// Creates a [FormValidityNotification] with old and new validity states.
  const FormValidityNotification(this.newValidity, this.oldValidity);
}
