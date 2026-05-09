// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../time_picker.dart';

/// Dialog widget for interactive time selection.
///
/// Displays input fields for hours, minutes, and optional seconds
/// with AM/PM toggle for 12-hour format.
class TimePickerDialog extends StatefulWidget {
  /// The initial time value.
  final TimeOfDay? initialValue;

  /// Callback invoked when the time changes.
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Whether to use 24-hour format.
  final bool use24HourFormat;

  /// Whether to show seconds input.
  final bool showSeconds;

  /// Creates a time picker dialog.
  const TimePickerDialog({
    super.key,
    this.initialValue,
    this.onChanged,
    required this.use24HourFormat,
    this.showSeconds = false,
  });

  /// Creates the `State` object for this widget.
  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}
