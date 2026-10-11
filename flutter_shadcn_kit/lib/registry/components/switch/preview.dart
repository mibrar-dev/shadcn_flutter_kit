// Named examples for the `switch` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../theme/theme.dart';
import 'switch.dart';

/// Controlled switch; owns its value.
class _ControlledSwitch extends StatefulWidget {
  const _ControlledSwitch();

  @override
  State<_ControlledSwitch> createState() => _ControlledSwitchState();
}

class _ControlledSwitchState extends State<_ControlledSwitch> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _value,
      onChanged: (bool value) => setState(() => _value = value),
      label: const Text('Airplane mode'),
    );
  }
}

Widget _default(BuildContext context) => const _ControlledSwitch();

/// Controller-driven switch; the controller owns the value.
class _ControllerSwitch extends StatefulWidget {
  const _ControllerSwitch();

  @override
  State<_ControllerSwitch> createState() => _ControllerSwitchState();
}

class _ControllerSwitchState extends State<_ControllerSwitch> {
  final SwitchController _controller = SwitchController(true);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Switch(
          controller: _controller,
          label: const Text('Driven by a controller'),
        ),
        Text('value: ${_controller.value}'),
      ],
    );
  }
}

Widget _controller(BuildContext context) => const _ControllerSwitch();

Widget _switchRows(BuildContext context) => const _SwitchRows();

/// On and off switches with no callback, so both are disabled.
Widget _disabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Wrap(
    spacing: spacing.xl,
    runSpacing: spacing.md,
    children: const <Widget>[
      Switch(value: true, label: Text('on')),
      Switch(value: false, label: Text('off')),
    ],
  );
}

/// A stack of switch rows: the group gap (shadcn `gap-3`) between them, the
/// same one the radio group and a checkbox list use.
class _SwitchRows extends StatefulWidget {
  const _SwitchRows();

  @override
  State<_SwitchRows> createState() => _SwitchRowsState();
}

class _SwitchRowsState extends State<_SwitchRows> {
  bool _notifications = true;
  bool _sounds = false;

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing.md,
      children: <Widget>[
        Switch(
          value: _notifications,
          onChanged: (bool value) => setState(() => _notifications = value),
          label: const Text('Notifications'),
        ),
        Switch(
          value: _sounds,
          onChanged: (bool value) => setState(() => _sounds = value),
          label: const Text('Sounds'),
        ),
      ],
    );
  }
}

/// Named docs examples for `switch`; the first entry is the default.
const List<ComponentPreview> switchPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Rows', _switchRows),
  ComponentPreview('Controller', _controller),
  ComponentPreview('Disabled', _disabled),
];
