// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../time_picker.dart';

/// Theme configuration for [TimePicker] widget appearance and behavior.
///
/// Defines default settings for time picker components including display
/// format, popover positioning, and dialog customization.
class TimePickerTheme extends ComponentThemeData {
  /// Mode for displaying the time picker (popover or dialog).
  final PromptMode? mode;

  /// Alignment of the popover relative to its anchor.
  final AlignmentGeometry? popoverAlignment;

  /// Alignment point on the anchor widget for popover positioning.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover.
  final EdgeInsetsGeometry? popoverPadding;

  /// Whether to use 24-hour time format.
  final bool? use24HourFormat;

  /// Whether to show seconds picker.
  final bool? showSeconds;

  /// Custom title widget for the time picker dialog.
  final Widget? dialogTitle;

  /// Creates a [TimePickerTheme].
  const TimePickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.mode,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.use24HourFormat,
    this.showSeconds,
    this.dialogTitle,
  });

  /// Creates a copy of this theme with the given fields replaced.
  TimePickerTheme copyWith({
    ValueGetter<PromptMode?>? mode,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? popoverAnchorAlignment,
    ValueGetter<EdgeInsetsGeometry?>? popoverPadding,
    ValueGetter<bool?>? use24HourFormat,
    ValueGetter<bool?>? showSeconds,
    ValueGetter<Widget?>? dialogTitle,
  }) {
    return TimePickerTheme(
      mode: mode == null ? this.mode : mode(),
      popoverAlignment: popoverAlignment == null
          ? this.popoverAlignment
          : popoverAlignment(),
      popoverAnchorAlignment: popoverAnchorAlignment == null
          ? this.popoverAnchorAlignment
          : popoverAnchorAlignment(),
      popoverPadding: popoverPadding == null
          ? this.popoverPadding
          : popoverPadding(),
      use24HourFormat: use24HourFormat == null
          ? this.use24HourFormat
          : use24HourFormat(),
      showSeconds: showSeconds == null ? this.showSeconds : showSeconds(),
      dialogTitle: dialogTitle == null ? this.dialogTitle : dialogTitle(),
    );
  }

  /// Compares this object with another for value equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimePickerTheme &&
        other.mode == mode &&
        other.popoverAlignment == popoverAlignment &&
        other.popoverAnchorAlignment == popoverAnchorAlignment &&
        other.popoverPadding == popoverPadding &&
        other.use24HourFormat == use24HourFormat &&
        other.showSeconds == showSeconds &&
        other.dialogTitle == dialogTitle;
  }

  @override
  int get hashCode => Object.hash(
    mode,
    popoverAlignment,
    popoverAnchorAlignment,
    popoverPadding,
    use24HourFormat,
    showSeconds,
    dialogTitle,
  );
}
