// Named examples for the `stepper` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'stepper.dart';

List<StepperStep> _steps() => const <StepperStep>[
  StepperStep(title: Text('Account'), content: Text('Email, password')),
  StepperStep(title: Text('Profile'), content: Text('Name, avatar')),
  StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
];

/// A stepper that moves when a step is activated; owns its index.
class _InteractiveStepper extends StatefulWidget {
  const _InteractiveStepper({this.direction = Axis.horizontal});

  final Axis direction;

  @override
  State<_InteractiveStepper> createState() => _InteractiveStepperState();
}

class _InteractiveStepperState extends State<_InteractiveStepper> {
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _current,
      onStepChanged: (int index) => setState(() => _current = index),
      direction: widget.direction,
      steps: _steps(),
    );
  }
}

/// Horizontal circle stepper.
Widget _default(BuildContext context) => const _InteractiveStepper();

/// Vertical circle stepper.
Widget _vertical(BuildContext context) {
  return const _InteractiveStepper(direction: Axis.vertical);
}

/// The three indicator sizes in one column.
Widget _sizes(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      for (final StepperSize size in StepperSize.values) ...<Widget>[
        Text('${size.name} (${size.indicatorSize}px)'),
        Stepper(currentStep: 1, size: size, steps: _steps()),
        Gap(spacing.md),
      ],
    ],
  );
}

/// A controller-driven stepper with the first step flagged as failed.
class _FailedStepper extends StatefulWidget {
  const _FailedStepper();

  @override
  State<_FailedStepper> createState() => _FailedStepperState();
}

class _FailedStepperState extends State<_FailedStepper> {
  final StepperController _controller = StepperController(1);

  @override
  void initState() {
    super.initState();
    _controller.setStepState(0, StepperStepState.failed);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stepper(controller: _controller, steps: _steps());
  }
}

Widget _failed(BuildContext context) => const _FailedStepper();

/// Named docs examples for `stepper`; the first entry is the default.
const List<ComponentPreview> stepperPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Vertical', _vertical),
  ComponentPreview('Sizes', _sizes),
  ComponentPreview('Failed step', _failed),
];
