// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A form field entry that wraps a form widget with validation.
///
/// [FormEntry] associates a [FormKey] with a form field widget and optional
/// validator. It integrates with the form state management system to track
/// field values and validation states.
class FormEntry<T> extends StatefulWidget {
  /// The form field widget to wrap.
  final Widget child;

  /// Optional validator function for this form field.
  ///
  /// Called when form validation is triggered. Should return `null` for valid
  /// values or a validation error message for invalid values.
  final Validator<T>? validator;

  /// Creates a form entry with a typed key.
  ///
  /// The [key] parameter must be a [FormKey<T>] to ensure type safety.
  const FormEntry({
    required FormKey<T> super.key,
    required this.child,
    this.validator,
  });

  /// Field storing `key` for this form implementation.
  @override
  FormKey get key => super.key as FormKey;

  /// Creates the `State` object for this widget.
  @override
  State<FormEntry> createState() => FormEntryState();
}
