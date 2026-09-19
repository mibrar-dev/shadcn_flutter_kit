// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// A [FormKey] whose value type is not known at compile time.
///
/// Use it when fields are built from data — a schema, a JSON form definition —
/// so the concrete type cannot be written as `FormKey<String>` or similar.
/// Values read back through this key are typed `Object?` and must be checked by
/// the caller.
///
/// ```dart
/// final key = DynamicFormKey(field.id);
/// final Object? value = FormController.of(context).getValue(key);
/// ```
class DynamicFormKey extends FormKey<Object?> {
  /// Creates a [DynamicFormKey] identified by [key].
  const DynamicFormKey(super.key);
}
