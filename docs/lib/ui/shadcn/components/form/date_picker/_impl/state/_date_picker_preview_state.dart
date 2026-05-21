// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _DatePickerPreviewState stores and manages mutable widget state.
class _DatePickerPreviewState extends State<DatePickerPreview> {
  /// Current value stored for `_value`.
  DateTime? _value;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            // Popover mode date picker
            DatePicker(
              value: _value,
              mode: PromptMode.popover,
              stateBuilder: (date) {
                if (date.isAfter(DateTime.now())) {
                  return DateState.disabled;
                }
                return DateState.enabled;
              },
              onChanged: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  _value = value;
                });
              },
            ),
            // Dialog mode date picker
            DatePicker(
              value: _value,
              mode: PromptMode.dialog,
              dialogTitle: const Text('Pick a date'),
              stateBuilder: (date) {
                if (date.isAfter(DateTime.now())) {
                  return DateState.disabled;
                }
                return DateState.enabled;
              },
              onChanged: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  _value = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
