// Registry-owned theme data for the `date_picker` component: the
// [DatePickerTheme] behaviour container and `datePickerDefaults`.
//
// User-owned overrides live in `date_picker_theme.dart`; CLI updates may
// replace this file. Only placement and presentation mode are theme rows;
// colours come from the `calendar` component and global tokens.

import 'package:flutter/widgets.dart';

import '../../primitives/date_math.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../calendar/calendar_style.dart';

/// Timing-free behaviour contract of the date picker trigger.
class DatePickerTheme extends ComponentThemeData
    implements Mergeable<DatePickerTheme> {
  /// Creates a date picker theme.
  const DatePickerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.mode,
    this.initialView,
    this.initialViewType,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
  });

  /// Dialog or popover presentation; null resolves dialog.
  final PromptMode? mode;

  /// Month the calendar opens on; null resolves the current month.
  final CalendarView? initialView;

  /// Grid shown first; null resolves date.
  final CalendarViewType? initialViewType;

  /// Card placement in popover mode; null resolves top-left.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor edge in popover mode; null resolves bottom-left.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover surface; null resolves the primitive default.
  final EdgeInsetsGeometry? popoverPadding;

  /// Returns a copy with the given fields replaced.
  DatePickerTheme copyWith({
    ValueGetter<PromptMode?>? mode,
    ValueGetter<CalendarView?>? initialView,
    ValueGetter<CalendarViewType?>? initialViewType,
    ValueGetter<AlignmentGeometry?>? popoverAlignment,
    ValueGetter<AlignmentGeometry?>? popoverAnchorAlignment,
    ValueGetter<EdgeInsetsGeometry?>? popoverPadding,
  }) => DatePickerTheme(
    themeDensity: themeDensity,
    themeSpacing: themeSpacing,
    themeShadows: themeShadows,
    mode: mode == null ? this.mode : mode(),
    initialView: initialView == null ? this.initialView : initialView(),
    initialViewType: initialViewType == null
        ? this.initialViewType
        : initialViewType(),
    popoverAlignment: popoverAlignment == null
        ? this.popoverAlignment
        : popoverAlignment(),
    popoverAnchorAlignment: popoverAnchorAlignment == null
        ? this.popoverAnchorAlignment
        : popoverAnchorAlignment(),
    popoverPadding: popoverPadding == null
        ? this.popoverPadding
        : popoverPadding(),
  );

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  DatePickerTheme merge(DatePickerTheme? fallback) {
    if (fallback == null) return this;
    return DatePickerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      mode: mode ?? fallback.mode,
      initialView: initialView ?? fallback.initialView,
      initialViewType: initialViewType ?? fallback.initialViewType,
      popoverAlignment: popoverAlignment ?? fallback.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? fallback.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? fallback.popoverPadding,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DatePickerTheme &&
          other.mode == mode &&
          other.initialView == initialView &&
          other.initialViewType == initialViewType &&
          other.popoverAlignment == popoverAlignment &&
          other.popoverAnchorAlignment == popoverAnchorAlignment &&
          other.popoverPadding == popoverPadding &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    mode,
    initialView,
    initialViewType,
    popoverAlignment,
    popoverAnchorAlignment,
    popoverPadding,
  );
}

/// Baseline behaviour; every unset override field falls through here.
const DatePickerTheme datePickerDefaults = DatePickerTheme(
  mode: PromptMode.dialog,
  initialViewType: CalendarViewType.date,
  popoverAlignment: Alignment.topLeft,
  popoverAnchorAlignment: Alignment.bottomLeft,
);
