// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _ObjectInputPreviewState stores and manages mutable widget state.
class _ObjectInputPreviewState extends State<ObjectInputPreview> {
  /// Current value stored for `_value`.
  DateTime? _value;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DateInput(
          initialValue: _value,
          onChanged: (value) {
            /// Triggers a rebuild after mutating local state.
            setState(() {
              _value = value;
            });
          },
          placeholder: const Text('Pick date'),
        ),
      ),
    );
  }
}
