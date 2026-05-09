// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _TimePickerPreviewState stores and manages mutable widget state.
class _TimePickerPreviewState extends State<TimePickerPreview> {
  /// Field storing `_time` for this form implementation.
  TimeOfDay? _time;

  /// Field storing `_duration` for this form implementation.
  Duration? _duration;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TimePicker(
              value: _time,
              mode: PromptMode.popover,
              showSeconds: true,
              onChanged: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  _time = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DurationPicker(
              value: _duration,
              mode: PromptMode.dialog,
              onChanged: (value) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  _duration = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
