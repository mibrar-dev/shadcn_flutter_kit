// The `time_picker` component: [TimePicker] and [DurationPicker] triggers
// opening digit-field sheets in a dialog or popover. Ported from
// `components/form/time_picker/**`: Material TimeOfDay/Icons/TextField are
// gone; `_TimeFormatter` is imported; zero-reader `TimeRange` is deleted.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../foundation/time_of_day.dart';
import '../../primitives/date_math.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/localizations/localizations_extensions.dart';
import '../../primitives/localizations/locale_parts.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../formatter/formatter.dart';
import '../input/input.dart';
import 'time_picker_style.dart';

export 'time_picker_style.dart';

/// Resolves [TimePickerTheme] through widget > tree > app > defaults.
TimePickerTheme _resolveTimePickerTheme(BuildContext c, TimePickerTheme? w) =>
    resolveComponentStyle<TimePickerTheme, TimePickerTheme>(
      c,
      widget: w,
      select: (t) => t,
      defaults: timePickerDefaults,
    );

String _two(int value) => value.toString().padLeft(2, '0');

/// A clock-time field opening a [TimePickerDialog] sheet.
class TimePicker extends StatelessWidget {
  const TimePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.mode,
    this.placeholder,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.use24HourFormat,
    this.showSeconds = false,
    this.dialogTitle,
    this.enabled,
    this.theme,
  });
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay?>? onChanged;
  final PromptMode? mode;
  final Widget? placeholder;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final bool? use24HourFormat;
  final bool showSeconds;
  final Widget? dialogTitle;
  final bool? enabled;
  final TimePickerTheme? theme;
  @override
  Widget build(BuildContext context) {
    final TimePickerTheme style = _resolveTimePickerTheme(context, theme);
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    final bool clock24 =
        use24HourFormat ??
        style.use24HourFormat ??
        MediaQuery.of(context).alwaysUse24HourFormat;
    final bool seconds = showSeconds || (style.showSeconds ?? false);
    return ObjectFormField<TimeOfDay>(
      value: value,
      onChanged: onChanged,
      placeholder: placeholder ?? Text(strings.placeholderTimePicker),
      builder: (context, value) => Text(
        strings.formatTimeOfDay(
          value,
          use24HourFormat: clock24,
          showSeconds: seconds,
        ),
      ),
      trailing: const Icon(LucideIcons.clock),
      mode: mode ?? style.mode ?? PromptMode.dialog,
      popoverAlignment: popoverAlignment ?? style.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? style.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? style.popoverPadding,
      dialogTitle: dialogTitle ?? style.dialogTitle,
      enabled: enabled,
      editorBuilder: (context, handler) => TimePickerDialog(
        initialValue: handler.value,
        onChanged: (next) => handler.value = next,
        use24HourFormat: clock24,
        showSeconds: seconds,
      ),
    );
  }
}

/// The clock sheet: hour/minute(/second) digit fields plus AM/PM in 12-hour
/// mode. Edits clamp into range and report live.
class TimePickerDialog extends StatefulWidget {
  const TimePickerDialog({
    super.key,
    this.initialValue,
    this.onChanged,
    required this.use24HourFormat,
    this.showSeconds = false,
  });
  final TimeOfDay? initialValue;
  final ValueChanged<TimeOfDay?>? onChanged;
  final bool use24HourFormat;
  final bool showSeconds;
  @override
  State<TimePickerDialog> createState() => _TimePickerDialogState();
}

class _TimePickerDialogState extends State<TimePickerDialog> {
  late final TextEditingController _hour = TextEditingController(
    text: _two(_displayHour),
  );
  late final TextEditingController _minute = TextEditingController(
    text: _two(widget.initialValue?.minute ?? 0),
  );
  late final TextEditingController _second = TextEditingController(
    text: _two(widget.initialValue?.second ?? 0),
  );
  late bool _pm = (widget.initialValue?.hour ?? 0) >= 12;

  int get _displayHour {
    final int hour = widget.initialValue?.hour ?? 0;
    if (widget.use24HourFormat) return hour;
    final int twelve = hour % 12;
    return twelve == 0 ? 12 : twelve;
  }

  @override
  void dispose() {
    _hour.dispose();
    _minute.dispose();
    _second.dispose();
    super.dispose();
  }

  void _report() {
    final int hourMax = timePartValueRange(TimePart.hour).$2;
    final int minuteMax = timePartValueRange(TimePart.minute).$2;
    final int secondMax = timePartValueRange(TimePart.second).$2;
    int hour = (int.tryParse(_hour.text) ?? 0).clamp(0, hourMax);
    if (!widget.use24HourFormat) {
      hour = (hour % 12) + (_pm ? 12 : 0);
    }
    widget.onChanged?.call(
      TimeOfDay(
        hour: hour,
        minute: (int.tryParse(_minute.text) ?? 0).clamp(0, minuteMax),
        second: (int.tryParse(_second.text) ?? 0).clamp(0, secondMax),
      ),
    );
  }

  void _setPm(bool pm) => setState(() {
    _pm = pm;
    _report();
  });

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _DigitsField(
          controller: _hour,
          label: strings.timeHour,
          onChanged: (_) => _report(),
        ),
        const _Colon(),
        _DigitsField(
          controller: _minute,
          label: strings.timeMinute,
          onChanged: (_) => _report(),
        ),
        if (widget.showSeconds) ...<Widget>[
          const _Colon(),
          _DigitsField(
            controller: _second,
            label: strings.timeSecond,
            onChanged: (_) => _report(),
          ),
        ],
        if (!widget.use24HourFormat) ...<Widget>[
          Gap(ShadcnTheme.of(context).spacing.sm),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Button(
                size: ButtonSize.sm,
                variant: _pm ? ButtonVariant.ghost : ButtonVariant.primary,
                onPressed: () => _setPm(false),
                child: Text(strings.timeAM),
              ),
              const SizedBox(height: 4),
              Button(
                size: ButtonSize.sm,
                variant: _pm ? ButtonVariant.primary : ButtonVariant.ghost,
                onPressed: () => _setPm(true),
                child: Text(strings.timePM),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// A duration field opening a [DurationPickerDialog] sheet.
class DurationPicker extends StatelessWidget {
  const DurationPicker({
    super.key,
    required this.value,
    this.onChanged,
    this.mode = PromptMode.dialog,
    this.placeholder,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.enabled,
  });
  final Duration? value;
  final ValueChanged<Duration?>? onChanged;
  final PromptMode mode;
  final Widget? placeholder;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final Widget? dialogTitle;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    return ObjectFormField<Duration>(
      value: value,
      onChanged: onChanged,
      placeholder: placeholder ?? Text(strings.placeholderDurationPicker),
      builder: (context, value) => Text(strings.formatDuration(value)),
      trailing: const Icon(LucideIcons.clock),
      mode: mode,
      popoverAlignment: popoverAlignment,
      popoverAnchorAlignment: popoverAnchorAlignment,
      popoverPadding: popoverPadding,
      dialogTitle: dialogTitle,
      enabled: enabled,
      editorBuilder: (context, handler) => DurationPickerDialog(
        initialValue: handler.value,
        onChanged: (next) => handler.value = next,
      ),
    );
  }
}

/// The duration sheet: day/hour/minute/second digit fields clamping into
/// range and reporting live.
class DurationPickerDialog extends StatefulWidget {
  const DurationPickerDialog({super.key, this.initialValue, this.onChanged});
  final Duration? initialValue;
  final ValueChanged<Duration?>? onChanged;
  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late final TextEditingController _day = TextEditingController(
    text: '${widget.initialValue?.inDays ?? 0}',
  );
  late final TextEditingController _hour = TextEditingController(
    text: _two((widget.initialValue?.inHours ?? 0) % Duration.hoursPerDay),
  );
  late final TextEditingController _minute = TextEditingController(
    text: _two((widget.initialValue?.inMinutes ?? 0) % Duration.minutesPerHour),
  );
  late final TextEditingController _second = TextEditingController(
    text: _two(
      (widget.initialValue?.inSeconds ?? 0) % Duration.secondsPerMinute,
    ),
  );

  @override
  void dispose() {
    _day.dispose();
    _hour.dispose();
    _minute.dispose();
    _second.dispose();
    super.dispose();
  }

  void _report() {
    final int hourMax = durationPartValueRange(DurationPart.hour).$2 ?? 23;
    final int minuteMax = durationPartValueRange(DurationPart.minute).$2 ?? 59;
    final int secondMax = durationPartValueRange(DurationPart.second).$2 ?? 59;
    widget.onChanged?.call(
      Duration(
        days: (int.tryParse(_day.text) ?? 0).clamp(0, 9999),
        hours: (int.tryParse(_hour.text) ?? 0).clamp(0, hourMax),
        minutes: (int.tryParse(_minute.text) ?? 0).clamp(0, minuteMax),
        seconds: (int.tryParse(_second.text) ?? 0).clamp(0, secondMax),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    final List<(TextEditingController, String)> fields =
        <(TextEditingController, String)>[
          (_day, strings.durationDay),
          (_hour, strings.durationHour),
          (_minute, strings.durationMinute),
          (_second, strings.durationSecond),
        ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int i = 0; i < fields.length; i++) ...<Widget>[
          if (i > 0) const _Colon(),
          _DigitsField(
            controller: fields[i].$1,
            label: fields[i].$2,
            onChanged: (_) => _report(),
          ),
        ],
      ],
    );
  }
}

/// One centered two-digit field with its caption below, shared by both sheets.
class _DigitsField extends StatelessWidget {
  const _DigitsField({
    required this.controller,
    required this.label,
    required this.onChanged,
  });
  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Input(
            controller: controller,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              const TimeFormatter(length: 2),
            ],
            style: theme.typography.large,
            onChanged: onChanged,
          ),
          Gap(theme.spacing.xs),
          Text(
            label,
            style: theme.typography.small.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }
}

class _Colon extends StatelessWidget {
  const _Colon();
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 4, right: 4),
      child: Text(
        ':',
        style: theme.typography.large.copyWith(color: theme.colors.foreground),
      ),
    );
  }
}
