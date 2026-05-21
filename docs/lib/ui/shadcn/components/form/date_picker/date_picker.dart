// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../display/calendar/calendar.dart';
import '../form_field/form_field.dart';
import '../../../shared/icons/lucide_icons.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/localizations/shadcn_localizations_extensions.dart';
import '../../../shared/primitives/form_control.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/themes/base/date_picker_theme.dart';

part '_impl/core/controlled_date_picker.dart';
part '_impl/utils/date_picker_controller.dart';
part '_impl/core/date_range_picker.dart';
part '_impl/core/date_time_range.dart';

/// A date picker widget for selecting dates.
///
/// Provides a date selection interface with calendar view in either
/// popover or dialog mode.
class DatePicker extends StatelessWidget {
  /// The currently selected date value.
  final DateTime? value;

  /// Callback invoked when the selected date changes.
  final ValueChanged<DateTime?>? onChanged;

  /// Placeholder widget shown when no date is selected.
  final Widget? placeholder;

  /// The display mode for the date picker (popover or dialog).
  final PromptMode? mode;

  /// The initial calendar view to display.
  final CalendarView? initialView;

  /// Alignment of the popover relative to the anchor.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for the popover.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover.
  final EdgeInsetsGeometry? popoverPadding;

  /// Title widget for the dialog mode.
  final Widget? dialogTitle;

  /// The initial calendar view type (date, month, or year).
  final CalendarViewType? initialViewType;

  /// Builder function to determine the state of each date.
  final DateStateBuilder? stateBuilder;

  /// Whether the date picker is enabled.
  final bool? enabled;

  /// Creates a date picker.
  const DatePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.placeholder,
    this.mode,
    this.initialView,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.initialViewType,
    this.stateBuilder,
    this.enabled,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    final compTheme = ComponentTheme.maybeOf<DatePickerTheme>(context);
    final resolvedMode = styleValue(
      widgetValue: mode,
      themeValue: compTheme?.mode,
      defaultValue: PromptMode.dialog,
    );
    final resolvedAlignment = styleValue(
      widgetValue: popoverAlignment,
      themeValue: compTheme?.popoverAlignment,
      defaultValue: Alignment.topLeft,
    );
    final resolvedAnchorAlignment = styleValue(
      widgetValue: popoverAnchorAlignment,
      themeValue: compTheme?.popoverAnchorAlignment,
      defaultValue: Alignment.bottomLeft,
    );
    final resolvedPadding = styleValue(
      widgetValue: popoverPadding,
      themeValue: compTheme?.popoverPadding,
      defaultValue: null,
    );
    final resolvedInitialView = styleValue(
      widgetValue: initialView,
      themeValue: compTheme?.initialView,
      defaultValue: CalendarView.now(),
    );
    final resolvedInitialViewType = styleValue(
      widgetValue: initialViewType,
      themeValue: compTheme?.initialViewType,
      defaultValue: CalendarViewType.date,
    );
    return ObjectFormField(
      dialogTitle: dialogTitle,
      enabled: enabled,
      popoverAlignment: resolvedAlignment,
      popoverAnchorAlignment: resolvedAnchorAlignment,
      popoverPadding: resolvedPadding,
      value: value,
      onChanged: onChanged,
      placeholder: placeholder ?? Text(localizations.placeholderDatePicker),
      trailing: const Icon(LucideIcons.calendarDays),
      builder: (context, value) {
        return Text(localizations.formatDateTime(value, showTime: false));
      },
      mode: resolvedMode,
      editorBuilder: (context, handler) {
        return DatePickerDialog(
          initialView: resolvedInitialView,
          initialViewType: resolvedInitialViewType,
          selectionMode: CalendarSelectionMode.single,
          initialValue: handler.value == null
              ? null
              : CalendarValue.single(handler.value!),
          onChanged: (value) {
            handler.value = value == null
                ? null
                : (value as SingleCalendarValue).date;
          },
          stateBuilder: stateBuilder,
        );
      },
    );
  }
}
