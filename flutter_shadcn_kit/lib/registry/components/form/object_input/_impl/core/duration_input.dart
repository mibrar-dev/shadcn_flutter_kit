// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../object_input.dart';

/// Reactive duration input field with formatted text editing and validation.
///
/// A high-level duration input widget that provides structured duration entry through
/// formatted text fields. Supports hours, minutes, and optional seconds with
/// automatic state management through the controlled component pattern.
///
/// ## Features
///
/// - **Structured duration entry**: Separate fields for hours, minutes, and seconds
/// - **Format validation**: Automatic validation and formatting of duration components
/// - **Flexible display**: Optional seconds display and customizable separators
/// - **Large value support**: Handle durations spanning multiple hours or days
/// - **Form integration**: Automatic validation and form field registration
/// - **Keyboard navigation**: Tab navigation between duration components
/// - **Accessibility**: Full screen reader support and keyboard input
///
/// ## Usage Patterns
///
/// **Controller-based (recommended for complex state):**
/// ```dart
/// final controller = ComponentController<Duration?>(Duration(hours: 1, minutes: 30));
///
/// DurationInput(
///   controller: controller,
///   showSeconds: true,
///   placeholder: Text('Enter duration'),
/// )
/// ```
///
/// **Callback-based (simple state management):**
/// ```dart
/// Duration? selectedDuration;
///
/// DurationInput(
///   initialValue: selectedDuration,
///   onChanged: (duration) => setState(() => selectedDuration = duration),
///   showSeconds: false,
///   separator: InputPart.text(':'),
/// )
/// ```
class DurationInput extends StatefulWidget with ControlledComponent<Duration?> {
  /// Current value stored for `initialValue`.
  @override
  final Duration? initialValue;

  /// Callback invoked for `onChanged` events.
  @override
  final ValueChanged<Duration?>? onChanged;

  /// Field storing `enabled` for this form implementation.
  @override
  final bool enabled;

  /// Controller used to coordinate `controller` behavior.
  @override
  final ComponentController<Duration?>? controller;

  /// Placeholder widget shown when no duration is selected.
  final Widget? placeholder;

  /// Whether to show seconds input field.
  final bool showSeconds;

  /// Separator widget between duration parts.
  final InputPart? separator;

  /// Custom placeholders for individual time parts.
  final Map<TimePart, Widget>? placeholders;

  /// Creates a [DurationInput].
  ///
  /// Either [controller] or [onChanged] should be provided for interactivity.
  /// The widget supports both controller-based and callback-based state management
  /// patterns with structured duration component entry.
  ///
  /// Parameters:
  /// - [controller] (`ComponentController<Duration?>?`, optional): external state controller
  /// - [initialValue] (Duration?, optional): starting duration when no controller
  /// - [onChanged] (`ValueChanged<Duration?>?`, optional): duration change callback
  /// - [enabled] (bool, default: true): whether input is interactive
  /// - [placeholder] (Widget?, optional): widget shown when no duration selected
  /// - [showSeconds] (bool, default: false): whether to include seconds input
  /// - [separator] (InputPart?, optional): separator between duration components
  /// - [placeholders] (`Map<TimePart, Widget>?`, optional): placeholders for time parts
  ///
  /// Example:
  /// ```dart
  /// DurationInput(
  ///   controller: controller,
  ///   showSeconds: true,
  ///   separator: InputPart.text(':'),
  ///   placeholders: {
  ///     TimePart.hour: Text('HH'),
  ///     TimePart.minute: Text('MM'),
  ///     TimePart.second: Text('SS'),
  ///   },
  /// )
  /// ```
  const DurationInput({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.placeholder,
    this.showSeconds = false,
    this.separator,
    this.placeholders,
  });

  /// Creates the `State` object for this widget.
  @override
  State<DurationInput> createState() => _DurationInputState();
}
