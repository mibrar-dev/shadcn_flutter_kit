// Gallery preview for the `stepper` component: both variants in both
// directions, the three sizes, a failed step and the dark palette.
// Widgets-only; the docs app embeds [StepperPreview] directly.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import 'stepper.dart';

/// Renders the stepper gallery.
class StepperPreview extends StatelessWidget {
  /// Creates the preview.
  const StepperPreview({super.key});

  List<StepperStep> _steps() => const <StepperStep>[
    StepperStep(title: Text('Account'), content: Text('Email, password')),
    StepperStep(title: Text('Profile'), content: Text('Name, avatar')),
    StepperStep(title: Text('Payment'), content: Text('Card, invoice')),
  ];

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  'Circle, horizontal',
                  Stepper(currentStep: 1, steps: _steps()),
                ),
                const Gap(24),
                _section(
                  'Circle, vertical',
                  Stepper(
                    currentStep: 2,
                    direction: Axis.vertical,
                    steps: _steps(),
                  ),
                ),
                const Gap(24),
                _section('Sizes', _sizes()),
                const Gap(24),
                _section('Failed step', _failed()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (final StepperSize size in StepperSize.values) ...<Widget>[
          Text('${size.name} (${size.indicatorSize}px)'),
          Stepper(currentStep: 1, size: size, steps: _steps()),
          const Gap(12),
        ],
      ],
    );
  }

  Widget _failed() {
    final StepperController controller = StepperController(1);
    controller.setStepState(0, StepperStepState.failed);
    return Stepper(controller: controller, steps: _steps());
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const Gap(8),
        child,
      ],
    );
  }
}

/// The same gallery rendered with the dark token set.
class StepperPreviewDark extends StatelessWidget {
  /// Creates the dark preview.
  const StepperPreviewDark({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnTheme(
      data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
      child: const StepperPreview(),
    );
  }
}
