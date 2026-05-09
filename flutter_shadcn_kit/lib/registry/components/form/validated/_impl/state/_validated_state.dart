// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../validated.dart';

/// _ValidatedState stores and manages mutable widget state.
class _ValidatedState extends State<Validated> {
  final formKey = const FormKey(#validated);

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Form(
      child: FormEntry(
        key: formKey,
        validator: widget.validator,
        child: FormEntryErrorBuilder(
          builder: (context, error, child) {
            return widget.builder(context, error, child);
          },
          child: widget.child,
        ),
      ),
    );
  }
}
