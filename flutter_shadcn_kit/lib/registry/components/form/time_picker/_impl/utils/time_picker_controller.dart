// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../time_picker.dart';

/// A controller for managing [ControlledTimePicker] values programmatically.
///
/// This controller extends `ValueNotifier<TimeOfDay?>` to provide reactive
/// state management for time picker components. It implements [ComponentController]
/// to integrate with the controlled component system, allowing external control
/// and listening to time selection changes.
///
/// Example:
/// ```dart
/// final controller = TimePickerController(TimeOfDay(hour: 12, minute: 30));
/// controller.addListener(() {
///   print('Selected time: ${controller.value}');
/// });
/// ```
class TimePickerController extends ValueNotifier<TimeOfDay?>
    with ComponentController<TimeOfDay?> {
  /// Creates a [TimePickerController] with an optional initial value.
  ///
  /// Parameters:
  /// - [value] (TimeOfDay?, optional): Initial time value for the controller
  TimePickerController([super.value]);
}
