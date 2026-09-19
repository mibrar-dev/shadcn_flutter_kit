// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// Bridges a form-system [FormFieldHandle] to the shared-primitives type.
///
/// The registry contains two identically-shaped but distinct handle types:
/// this library's [FormFieldHandle] (published by [FormEntryState]) and
/// `shared_form.FormFieldHandle` (consumed by widgets built on the shared
/// `FormValueSupplier`, e.g. `TextField`). A `Data.maybeOf` lookup is typed,
/// so without this bridge the text field's value reports never reach the
/// [FormController] and validators silently see nothing (e.g. Sign In with
/// empty fields submits instead of showing required-field errors).
///
/// Error display keeps flowing through the form system ([FormEntryState]
/// validity + [FormEntryErrorBuilder]); this adapter intentionally only
/// forwards value reports (fire-and-forget, returning `null`) rather than
/// translating validation-result hierarchies between the two systems.
class SharedFormHandleAdapter implements shared_form.FormFieldHandle {
  /// The form-system handle to forward value reports to.
  final FormFieldHandle _handle;

  /// Creates an adapter forwarding to [_handle].
  const SharedFormHandleAdapter(this._handle);

  @override
  bool get mounted => _handle.mounted;

  @override
  shared_form.FormKey get formKey =>
      shared_form.FormKey(_handle.formKey.key);

  @override
  ValueListenable<shared_form.ValidationResult?>? get validity => null;

  @override
  FutureOr<shared_form.ValidationResult?> reportNewFormValue<T>(T? value) {
    final result = _handle.reportNewFormValue<T>(value);
    if (result is Future) {
      return result.then<shared_form.ValidationResult?>((_) => null);
    }
    return null;
  }

  @override
  FutureOr<shared_form.ValidationResult?> revalidate() {
    final result = _handle.revalidate();
    if (result is Future) {
      return result.then<shared_form.ValidationResult?>((_) => null);
    }
    return null;
  }
}
