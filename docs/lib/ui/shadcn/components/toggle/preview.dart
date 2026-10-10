// Named examples for the `toggle` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../theme/theme.dart';
import 'toggle.dart';

/// Controlled toggle: the example owns the value.
class _ToggleControlledToggle extends StatefulWidget {
  const _ToggleControlledToggle();

  @override
  State<_ToggleControlledToggle> createState() =>
      _ToggleControlledToggleState();
}

class _ToggleControlledToggleState extends State<_ToggleControlledToggle> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Toggle(
        value: _value,
        onChanged: (bool value) => setState(() => _value = value),
        child: Text(_value ? 'On' : 'Off'),
      ),
    );
  }
}

/// Controller-driven toggles: the [ToggleController] is created inside this
/// state, so two examples can never attach one controller twice.
class _ToggleControllerToggle extends StatefulWidget {
  const _ToggleControllerToggle();

  @override
  State<_ToggleControllerToggle> createState() =>
      _ToggleControllerToggleState();
}

class _ToggleControllerToggleState extends State<_ToggleControllerToggle> {
  final ToggleController _toggleController = ToggleController();

  @override
  void dispose() {
    _toggleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ShadcnTheme.of(context).spacing;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Toggle(controller: _toggleController, child: const Text('Controller')),
        Gap(spacing.md),
        Toggle(
          controller: _toggleController,
          child: const Icon(LucideIcons.bell, size: 16),
        ),
      ],
    );
  }
}

/// Disabled toggles in both states.
Widget _toggleDisabled(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      const Toggle(value: true, child: Text('On')),
      Gap(spacing.md),
      const Toggle(value: false, onChanged: null, child: Text('Off')),
    ],
  );
}

Widget _toggleDefault(BuildContext context) => const _ToggleControlledToggle();

Widget _toggleController(BuildContext context) =>
    const _ToggleControllerToggle();

/// Named docs examples for `toggle`; the first entry is the default.
const List<ComponentPreview> togglePreviews = <ComponentPreview>[
  ComponentPreview('Default', _toggleDefault),
  ComponentPreview('Controller', _toggleController),
  ComponentPreview('Disabled', _toggleDisabled),
];
