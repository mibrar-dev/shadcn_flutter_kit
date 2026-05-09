// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../time_picker.dart';

/// Dialog widget for interactive duration selection.
///
/// Displays input fields for days, hours, minutes, and seconds
/// for selecting durations.
class DurationPickerDialog extends StatefulWidget {
  /// The initial duration value.
  final Duration? initialValue;

  /// Callback invoked when the duration changes.
  final ValueChanged<Duration?>? onChanged;

  /// Creates a duration picker dialog.
  const DurationPickerDialog({super.key, this.initialValue, this.onChanged});

  /// Creates the `State` object for this widget.
  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}
