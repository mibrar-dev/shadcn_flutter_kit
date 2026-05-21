// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' show Icons, TextAlignVertical;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/localizations/shadcn_localizations_extensions.dart';
import '../../../shared/primitives/form_control.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/util.dart';
import '../../control/button/button.dart';
import '../form_field/form_field.dart';
import '../../display/text/text.dart';
import '../text_field/text_field.dart';

part '_impl/themes/base/time_picker_theme.dart';

part '_impl/state/_duration_picker_dialog_state.dart';
part '_impl/utils/_time_formatter.dart';
part '_impl/state/_time_picker_dialog_state.dart';
part '_impl/core/controlled_time_picker.dart';
part '_impl/core/duration_picker.dart';
part '_impl/utils/duration_picker_controller.dart';
part '_impl/core/duration_picker_dialog.dart';
part '_impl/utils/time_picker_controller.dart';
part '_impl/core/time_picker_dialog.dart';
part '_impl/core/time_range.dart';

/// A time picker widget for selecting time values.
///
/// Provides time selection interface with hours, minutes, and optional
/// seconds in either popover or dialog mode.
class TimePicker extends StatelessWidget {
  /// The currently selected time value.
  final TimeOfDay? value;

  /// Callback invoked when the selected time changes.
  final ValueChanged<TimeOfDay?>? onChanged;

  /// The display mode for the time picker (popover or dialog).
  final PromptMode mode;

  /// Placeholder widget shown when no time is selected.
  final Widget? placeholder;

  /// Alignment of the popover relative to the anchor.
  final AlignmentGeometry? popoverAlignment;

  /// Anchor alignment for the popover.
  final AlignmentGeometry? popoverAnchorAlignment;

  /// Padding inside the popover.
  final EdgeInsetsGeometry? popoverPadding;

  /// Whether to use 24-hour format.
  final bool? use24HourFormat;

  /// Whether to show seconds selection.
  final bool showSeconds;

  /// Title widget for the dialog mode.
  final Widget? dialogTitle;

  /// Whether the time picker is enabled.
  final bool? enabled;

  /// Creates a time picker.
  const TimePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.mode = PromptMode.dialog,
    this.placeholder,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.use24HourFormat,
    this.showSeconds = false,
    this.dialogTitle,
    this.enabled,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    ShadcnLocalizations localizations = ShadcnLocalizations.of(context);
    final compTheme = ComponentTheme.maybeOf<TimePickerTheme>(context);
    bool use24HourFormat =
        this.use24HourFormat ??
        compTheme?.use24HourFormat ??
        MediaQuery.of(context).alwaysUse24HourFormat;
    final bool showSeconds = compTheme?.showSeconds ?? this.showSeconds;
    return ObjectFormField(
      value: value,
      placeholder: placeholder ?? Text(localizations.placeholderTimePicker),
      onChanged: onChanged,
      builder: (context, value) {
        return Text(
          localizations.formatTimeOfDay(
            value,
            use24HourFormat: use24HourFormat,
            showSeconds: showSeconds,
          ),
        );
      },
      enabled: enabled,
      mode: compTheme?.mode ?? mode,
      dialogTitle: dialogTitle ?? compTheme?.dialogTitle,
      popoverAlignment: popoverAlignment ?? compTheme?.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? compTheme?.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? compTheme?.popoverPadding,
      trailing: const Icon(Icons.access_time),
      editorBuilder: (context, handler) {
        return TimePickerDialog(
          initialValue: handler.value,
          onChanged: (value) {
            handler.value = value;
          },
          use24HourFormat: use24HourFormat,
          showSeconds: showSeconds,
        );
      },
    );
  }
}
