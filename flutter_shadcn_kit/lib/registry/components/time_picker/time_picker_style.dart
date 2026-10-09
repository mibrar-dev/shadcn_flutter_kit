// Registry-owned theme data for the `time_picker` component: the
// [TimePickerTheme] behaviour container and `timePickerDefaults`.
//
// User-owned overrides live in `time_picker_theme.dart`; CLI updates may
// replace this file. Only presentation mode, clock convention and placement
// are theme rows; colours come from the `input`/`button` components and
// global tokens.

import 'package:flutter/widgets.dart';

import '../../primitives/form_core/object_form_field.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Behaviour contract of the time picker trigger.
class TimePickerTheme extends ComponentThemeData
    implements Mergeable<TimePickerTheme> {
  /// Creates a time picker theme.
  const TimePickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.mode,
    this.use24HourFormat,
    this.showSeconds,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
  });

  /// Dialog or popover presentation; null resolves dialog.
  final PromptMode? mode;

  /// 12/24-hour clock; null resolves the ambient convention.
  final bool? use24HourFormat;

  /// Whether the seconds field shows; null resolves false.
  final bool? showSeconds;

  /// Card placement in popover mode; null resolves top-left.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor edge in popover mode; null resolves bottom-left.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover surface; null resolves the primitive default.
  final EdgeInsetsGeometry? popoverPadding;

  /// Title of the dialog prompt; null shows no title.
  final Widget? dialogTitle;

  /// Returns a copy with the given fields replaced.
  TimePickerTheme copyWith({
    ValueGetter<PromptMode?>? mode,
    ValueGetter<bool?>? use24HourFormat,
    ValueGetter<bool?>? showSeconds,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? popoverAnchorAlignment,
    ValueGetter<EdgeInsetsGeometry?>? popoverPadding,
    ValueGetter<Widget?>? dialogTitle,
  }) => TimePickerTheme(
    themeDensity: themeDensity,
    themeSpacing: themeSpacing,
    themeShadows: themeShadows,
    mode: mode == null ? this.mode : mode(),
    use24HourFormat: use24HourFormat == null
        ? this.use24HourFormat
        : use24HourFormat(),
    showSeconds: showSeconds == null ? this.showSeconds : showSeconds(),
    popoverAlignment: popoverAlignment == null
        ? this.popoverAlignment
        : popoverAlignment(),
    popoverAnchorAlignment: popoverAnchorAlignment == null
        ? this.popoverAnchorAlignment
        : popoverAnchorAlignment(),
    popoverPadding: popoverPadding == null
        ? this.popoverPadding
        : popoverPadding(),
    dialogTitle: dialogTitle == null ? this.dialogTitle : dialogTitle(),
  );

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  TimePickerTheme merge(TimePickerTheme? fallback) {
    if (fallback == null) return this;
    return TimePickerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      mode: mode ?? fallback.mode,
      use24HourFormat: use24HourFormat ?? fallback.use24HourFormat,
      showSeconds: showSeconds ?? fallback.showSeconds,
      popoverAlignment: popoverAlignment ?? fallback.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? fallback.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? fallback.popoverPadding,
      dialogTitle: dialogTitle ?? fallback.dialogTitle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimePickerTheme &&
          other.mode == mode &&
          other.use24HourFormat == use24HourFormat &&
          other.showSeconds == showSeconds &&
          other.popoverAlignment == popoverAlignment &&
          other.popoverAnchorAlignment == popoverAnchorAlignment &&
          other.popoverPadding == popoverPadding &&
          other.dialogTitle == dialogTitle &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    mode,
    use24HourFormat,
    showSeconds,
    popoverAlignment,
    popoverAnchorAlignment,
    popoverPadding,
    dialogTitle,
  );
}

/// Baseline behaviour; every unset override field falls through here.
const TimePickerTheme timePickerDefaults = TimePickerTheme(
  mode: PromptMode.dialog,
  popoverAlignment: Alignment.topLeft,
  popoverAnchorAlignment: Alignment.bottomLeft,
);
