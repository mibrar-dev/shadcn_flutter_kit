// Named examples for the `object_input` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each field carries its own bounded width because
// the segment rows measure an intrinsic width.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/time_of_day.dart';
import '../../primitives/form_core/object_form_field.dart';
import 'object_input.dart';

/// A date field; the value lives in this example's state.
class _DateDemo extends StatefulWidget {
  const _DateDemo();

  @override
  State<_DateDemo> createState() => _DateDemoState();
}

class _DateDemoState extends State<_DateDemo> {
  DateTime? _date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: DateInput(
        value: _date,
        // Dialog: the example may not provide an OverlayManager.
        mode: PromptMode.dialog,
        onChanged: (DateTime? next) => setState(() => _date = next),
      ),
    );
  }
}

/// A time field; the value lives in this example's state.
class _TimeDemo extends StatefulWidget {
  const _TimeDemo();

  @override
  State<_TimeDemo> createState() => _TimeDemoState();
}

class _TimeDemoState extends State<_TimeDemo> {
  TimeOfDay? _time;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: TimeInput(
        value: _time,
        onChanged: (TimeOfDay? next) => setState(() => _time = next),
      ),
    );
  }
}

/// A duration field; the value lives in this example's state.
class _DurationDemo extends StatefulWidget {
  const _DurationDemo();

  @override
  State<_DurationDemo> createState() => _DurationDemoState();
}

class _DurationDemoState extends State<_DurationDemo> {
  Duration? _duration;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: DurationInput(
        value: _duration,
        onChanged: (Duration? next) => setState(() => _duration = next),
      ),
    );
  }
}

Widget _date(BuildContext context) => const _DateDemo();

Widget _time(BuildContext context) => const _TimeDemo();

Widget _duration(BuildContext context) => const _DurationDemo();

/// Named docs examples for `object_input`; the first entry is the default.
const List<ComponentPreview> objectInputPreviews = <ComponentPreview>[
  ComponentPreview('Date', _date),
  ComponentPreview('Time', _time),
  ComponentPreview('Duration', _duration),
];
