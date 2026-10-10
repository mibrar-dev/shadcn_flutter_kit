// Named examples for the `time_picker` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/time_of_day.dart';
import 'time_picker.dart';

/// Clock trigger; owns its value.
class _ClockTrigger extends StatefulWidget {
  const _ClockTrigger();

  @override
  State<_ClockTrigger> createState() => _ClockTriggerState();
}

class _ClockTriggerState extends State<_ClockTrigger> {
  TimeOfDay? _value = const TimeOfDay(hour: 14, minute: 30);

  @override
  Widget build(BuildContext context) {
    return TimePicker(
      value: _value,
      onChanged: (TimeOfDay? value) => setState(() => _value = value),
      use24HourFormat: true,
    );
  }
}

Widget _clock(BuildContext context) => const _ClockTrigger();

/// Duration trigger; owns its value.
class _DurationTrigger extends StatefulWidget {
  const _DurationTrigger();

  @override
  State<_DurationTrigger> createState() => _DurationTriggerState();
}

class _DurationTriggerState extends State<_DurationTrigger> {
  Duration? _value = const Duration(hours: 1, minutes: 30);

  @override
  Widget build(BuildContext context) {
    return DurationPicker(
      value: _value,
      onChanged: (Duration? value) => setState(() => _value = value),
    );
  }
}

Widget _duration(BuildContext context) => const _DurationTrigger();

/// The inline clock sheet.
Widget _clockDialog(BuildContext context) {
  return const TimePickerDialog(use24HourFormat: true);
}

/// The inline duration sheet.
Widget _durationDialog(BuildContext context) {
  return const DurationPickerDialog();
}

/// Named docs examples for `time_picker`; the first entry is the default.
const List<ComponentPreview> timePickerPreviews = <ComponentPreview>[
  ComponentPreview('Clock', _clock),
  ComponentPreview('Duration', _duration),
  ComponentPreview('Clock dialog', _clockDialog),
  ComponentPreview('Duration dialog', _durationDialog),
];
