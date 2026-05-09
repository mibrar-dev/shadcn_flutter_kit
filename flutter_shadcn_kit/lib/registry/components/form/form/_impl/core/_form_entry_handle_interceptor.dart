// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// _FormEntryHandleInterceptor represents a form-related type in the registry.
class _FormEntryHandleInterceptor with FormFieldHandle {
  /// Field storing `handle` for this form implementation.
  final FormFieldHandle? handle;
  final void Function(Object? value) onValueReported;

  const _FormEntryHandleInterceptor(this.handle, this.onValueReported);

  /// Field storing `formKey` for this form implementation.
  @override
  FormKey get formKey => handle!.formKey;

  /// Field storing `mounted` for this form implementation.
  @override
  bool get mounted => handle!.mounted;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    onValueReported(value);
    return handle?.reportNewFormValue<T>(value);
  }

  /// Performs `revalidate` logic for this form component.
  @override
  FutureOr<ValidationResult?> revalidate() {
    return handle?.revalidate();
  }

  /// Field storing `validity` for this form implementation.
  @override
  ValueListenable<ValidationResult?>? get validity => handle?.validity;

  /// Returns a debug-friendly string representation.
  @override
  String toString() {
    return '_FormEntryHandleInterceptor($handle, $onValueReported)';
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    return other is _FormEntryHandleInterceptor &&
        other.handle == handle &&
        other.onValueReported == onValueReported;
  }

  @override
  int get hashCode => Object.hash(handle, onValueReported);
}
