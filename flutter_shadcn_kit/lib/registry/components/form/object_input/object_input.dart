// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/icons/lucide_icons.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/localizations/shadcn_localizations_extensions.dart';
import '../../../shared/primitives/form_control.dart';
import '../../../shared/utils/util.dart';
import '../../layout/card/card.dart';
import '../../display/calendar/calendar.dart';
import '../date_picker/date_picker.dart';
import '../formatted_input/formatted_input.dart';
import '../form_field/form_field.dart';
import '../../utility/locale_utils/locale_utils.dart';

part '_impl/state/_date_input_state.dart';
part '_impl/state/_duration_input_state.dart';
part '_impl/state/_time_input_state.dart';
part '_impl/core/duration_input.dart';
part '_impl/core/nullable_date.dart';
part '_impl/core/nullable_time_of_day.dart';
part '_impl/core/time_input.dart';

/// Reactive date input field with integrated date picker and text editing.
///
/// A high-level date input widget that combines text field functionality with
/// date picker integration. Provides automatic state management through the
/// controlled component pattern with support for both dialog and popover modes.
///
/// ## Features
///
/// - **Dual input modes**: Text field editing with date picker integration
/// - **Multiple presentation modes**: Dialog or popover-based date selection
/// - **Flexible date formatting**: Customizable date part ordering and separators
/// - **Calendar integration**: Rich calendar interface with multiple view types
/// - **Form integration**: Automatic validation and form field registration
/// - **Accessibility**: Full screen reader and keyboard navigation support
///
/// ## Usage Patterns
///
/// **Controller-based (recommended for complex state):**
/// ```dart
/// final controller = DatePickerController(DateTime.now());
///
/// DateInput(
///   controller: controller,
///   mode: PromptMode.popover,
///   placeholder: Text('Select date'),
/// )
/// ```
///
/// **Callback-based (simple state management):**
/// ```dart
/// DateTime? selectedDate;
///
/// DateInput(
///   initialValue: selectedDate,
///   onChanged: (date) => setState(() => selectedDate = date),
///   mode: PromptMode.dialog,
///   dialogTitle: Text('Choose Date'),
/// )
/// ```
class DateInput extends StatefulWidget with ControlledComponent<DateTime?> {
  /// Current value stored for `initialValue`.
  @override
  final DateTime? initialValue;

  /// Callback invoked for `onChanged` events.
  @override
  final ValueChanged<DateTime?>? onChanged;

  /// Field storing `enabled` for this form implementation.
  @override
  final bool enabled;

  /// Controller used to coordinate `controller` behavior.
  @override
  final DatePickerController? controller;

  /// Placeholder widget shown when no date is selected.
  final Widget? placeholder;

  /// Presentation mode for date picker (dialog or popover).
  final PromptMode mode;

  /// Initial calendar view to display.
  final CalendarView? initialView;

  /// Alignment of popover relative to anchor.
  final AlignmentGeometry? popoverAlignment;

  /// Alignment of anchor for popover positioning.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover.
  final EdgeInsetsGeometry? popoverPadding;

  /// Title widget for dialog mode.
  final Widget? dialogTitle;

  /// Initial view type (date, month, or year).
  final CalendarViewType? initialViewType;

  /// Callback to determine date state (enabled/disabled).
  final DateStateBuilder? stateBuilder;

  /// Order of date components in the input display.
  final List<DatePart>? datePartsOrder;

  /// Separator widget between date parts.
  final InputPart? separator;

  /// Custom placeholders for individual date parts.
  final Map<DatePart, Widget>? placeholders;

  /// Creates a [DateInput].
  ///
  /// Either [controller] or [onChanged] should be provided for interactivity.
  /// The widget supports both controller-based and callback-based state management
  /// patterns with flexible date picker integration options.
  ///
  /// Parameters:
  /// - [controller] (DatePickerController?, optional): external state controller
  /// - [initialValue] (DateTime?, optional): starting date when no controller
  /// - [onChanged] (`ValueChanged<DateTime?>?`, optional): date change callback
  /// - [enabled] (bool, default: true): whether input is interactive
  /// - [placeholder] (Widget?, optional): widget shown when no date selected
  /// - [mode] (PromptMode, default: dialog): date picker presentation mode
  /// - [initialView] (CalendarView?, optional): starting calendar view
  /// - [popoverAlignment] (AlignmentGeometry?, optional): popover alignment
  /// - [popoverAnchorAlignment] (AlignmentGeometry?, optional): anchor alignment
  /// - [popoverPadding] (EdgeInsetsGeometry?, optional): popover padding
  /// - [dialogTitle] (Widget?, optional): title for dialog mode
  /// - [initialViewType] (CalendarViewType?, optional): calendar view type
  /// - [stateBuilder] (DateStateBuilder?, optional): custom date state builder
  /// - [datePartsOrder] (`List<DatePart>?`, optional): order of date components
  /// - [separator] (InputPart?, optional): separator between date parts
  /// - [placeholders] (`Map<DatePart, Widget>?`, optional): placeholders for date parts
  ///
  /// Example:
  /// ```dart
  /// DateInput(
  ///   controller: controller,
  ///   mode: PromptMode.popover,
  ///   placeholder: Text('Select date'),
  ///   datePartsOrder: [DatePart.month, DatePart.day, DatePart.year],
  /// )
  /// ```
  const DateInput({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.placeholder,
    this.mode = PromptMode.dialog,
    this.initialView,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.initialViewType,
    this.stateBuilder,
    this.datePartsOrder,
    this.separator,
    this.placeholders,
  });

  /// Creates the `State` object for this widget.
  @override
  State<DateInput> createState() => _DateInputState();
}
