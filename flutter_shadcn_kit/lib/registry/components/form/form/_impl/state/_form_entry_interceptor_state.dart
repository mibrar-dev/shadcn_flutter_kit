// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../form.dart';

/// _FormEntryInterceptorState stores and manages mutable widget state.
class _FormEntryInterceptorState<T> extends State<FormEntryInterceptor<T>> {
  /// Field storing `_handle` for this form implementation.
  FormFieldHandle? _handle;

  /// Updates derived state when inherited dependencies change.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handle = Data.maybeOf<FormFieldHandle>(context);
  }

  /// Performs `_onValueReported` logic for this form component.
  void _onValueReported(Object? value) {
    var callback = widget.onValueReported;
    if (callback != null && value is T) {
      callback(value);
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final handle = _FormEntryHandleInterceptor(_handle, _onValueReported);
    final inner = Data<FormFieldHandle>.inherit(
      data: handle,
      child: widget.child,
    );
    // Mirror the FormEntry bridge so shared-supplier widgets below an
    // interceptor also reach the form controller. Guarded: with no parent
    // handle there is nothing to forward to.
    if (_handle == null) return inner;
    return Data<shared_form.FormFieldHandle>.inherit(
      data: SharedFormHandleAdapter(handle),
      child: inner,
    );
  }
}
