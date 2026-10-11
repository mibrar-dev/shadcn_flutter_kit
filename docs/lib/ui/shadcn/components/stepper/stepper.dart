// The `stepper` component: a multi-step flow with progress indication. Ported
// from `components/navigation/stepper` (2,058 LOC): the old tree imported
// `material.dart` and pushed step context through seven `Data.inherit` hops;
// both are gone (README.md "Fixed bugs").

import 'package:flutter/widgets.dart';

import '../../foundation/constants.dart';
import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'stepper_style.dart';

export 'stepper_style.dart';

/// Navigation state for a controller-driven [Stepper].
///
/// The [Stepper] keeps [stepCount] in sync so [next] and [previous] stop at
/// the ends instead of walking past them.
class StepperController extends ChangeNotifier {
  /// Creates a controller starting at [currentStep].
  StepperController([int currentStep = 0]) : _currentStep = currentStep;

  int _currentStep;
  final Map<int, StepperStepState> _stepStates = <int, StepperStepState>{};

  /// Index of the active step (0-based).
  int get currentStep => _currentStep;

  /// Flagged steps by index; unmodifiable.
  Map<int, StepperStepState> get stepStates =>
      Map<int, StepperStepState>.unmodifiable(_stepStates);

  /// Number of steps; written by the [Stepper] on every build.
  int stepCount = 0;

  /// Moves to the next step; false at the last one.
  bool next() => jumpTo(_currentStep + 1);

  /// Moves to the previous step; false at the first one.
  bool previous() => jumpTo(_currentStep - 1);

  /// Jumps to [index], clamped to the valid range; false when unchanged.
  bool jumpTo(int index) {
    final int target = index.clamp(0, stepCount > 0 ? stepCount - 1 : 0);
    if (target == _currentStep) {
      return false;
    }
    _currentStep = target;
    notifyListeners();
    return true;
  }

  /// Flags or clears a step; null clears the flag. A no-op write (the same
  /// flag on the same index) does not notify.
  void setStepState(int index, StepperStepState? state) {
    if (state == null) {
      if (_stepStates.remove(index) == null) {
        return;
      }
    } else {
      if (_stepStates[index] == state) {
        return;
      }
      _stepStates[index] = state;
    }
    notifyListeners();
  }
}

/// One step of a [Stepper].
class StepperStep {
  /// Creates a step.
  const StepperStep({required this.title, this.content, this.icon});

  /// Step label.
  final Widget title;

  /// Content shown while this step is active.
  final Widget? content;

  /// Replaces the number inside the indicator.
  final Widget? icon;
}

/// A sequence of steps with progress indication.
///
/// Two modes, like `Toggle`: uncontrolled with a [StepperController], or
/// controlled with [currentStep] + [onStepChanged]; activating a step jumps to
/// it.
///
/// ```dart
/// Stepper(currentStep: 1, steps: <StepperStep>[
///   StepperStep(title: Text('Account'), content: Text('form')),
/// ]);
/// ```
class Stepper extends StatelessWidget {
  /// Creates a stepper.
  const Stepper({
    super.key,
    required this.steps,
    this.controller,
    this.currentStep,
    this.onStepChanged,
    this.direction,
    this.size,
    this.theme,
  }) : assert(
         controller == null || (currentStep == null && onStepChanged == null),
         'A controller-driven Stepper must not also receive '
         'currentStep/onStepChanged',
       ),
       assert(
         controller != null || currentStep != null,
         'A controlled Stepper requires currentStep',
       );

  /// The steps, in order.
  final List<StepperStep> steps;

  /// Uncontrolled mode: the controller owns the active step.
  final StepperController? controller;

  /// Controlled mode: index of the active step.
  final int? currentStep;

  /// Controlled mode: called with the next index when a step is activated.
  final ValueChanged<int>? onStepChanged;

  /// Layout axis; falls back to the theme.
  final Axis? direction;

  /// Indicator size; falls back to the theme.
  final StepperSize? size;

  /// Widget-leg theme override, merged on top of the other legs.
  final StepperTheme? theme;

  int _clamp(int index) => index.clamp(0, steps.length - 1);

  void _select(int index) {
    final int target = _clamp(index);
    final StepperController? controller = this.controller;
    if (controller != null) {
      controller.jumpTo(target);
    } else if (target != _clamp(currentStep!)) {
      onStepChanged?.call(target);
    }
  }

  Widget _render(BuildContext context, StepperTheme style) {
    final StepperController? controller = this.controller;
    return _StepperRender(
      steps: steps,
      style: style,
      active: _clamp(controller?.currentStep ?? currentStep!),
      failedAt: firstFailedStep(
        controller?.stepStates ?? const <int, StepperStepState>{},
      ),
      direction: direction ?? style.direction ?? Axis.horizontal,
      size: size ?? style.size ?? StepperSize.md,
      onSelect: _select,
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(steps.isNotEmpty, 'A Stepper needs at least one step');
    final StepperTheme style =
        resolveComponentStyle<StepperTheme, StepperTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: stepperDefaults,
        );
    final StepperController? controller = this.controller;
    if (controller == null) {
      return _render(context, style);
    }
    controller.stepCount = steps.length;
    return ListenableBuilder(
      listenable: controller,
      builder: (BuildContext context, Widget? _) {
        controller.stepCount = steps.length;
        return _render(context, style);
      },
    );
  }
}

/// Renders the resolved stepper: the variant/direction table.
class _StepperRender extends StatelessWidget {
  const _StepperRender({
    required this.steps,
    required this.style,
    required this.active,
    required this.failedAt,
    required this.direction,
    required this.size,
    required this.onSelect,
  });

  final List<StepperStep> steps;
  final StepperTheme style;
  final int active;
  final int? failedAt;
  final Axis direction;
  final StepperSize size;
  final ValueChanged<int> onSelect;

  /// The phase slot of [index]; `index == failedAt` is the failed one.
  StepperPhase phaseFor(int index) {
    if (index == failedAt) {
      return StepperPhase.failed;
    }
    if (index < active) {
      return StepperPhase.completed;
    }
    return index == active ? StepperPhase.active : StepperPhase.pending;
  }

  StepperIndicatorStyle styleFor(StepperPhase phase) => switch (phase) {
    StepperPhase.failed => style.failed ?? stepperDefaults.failed!,
    StepperPhase.completed => style.completed ?? stepperDefaults.completed!,
    StepperPhase.active => style.active ?? stepperDefaults.active!,
    StepperPhase.pending => style.pending ?? stepperDefaults.pending!,
  };

  Color connectorColor(int index, ShadcnColors colors) {
    if (failedAt != null && index >= failedAt!) {
      return (style.failed?.borderColor ?? stepperDefaults.failed!.borderColor)!
          .resolve(colors);
    }
    final ThemedColor color = index < active
        ? (style.connectorColor ?? stepperDefaults.connectorColor!)
        : (style.connectorPendingColor ??
              stepperDefaults.connectorPendingColor!);
    return color.resolve(colors);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnColors colors = theme.colors;
    final double scaling = theme.scaling;
    final double box = size.indicatorSize * scaling;
    final double gap = (style.gap ?? 8) * scaling;
    final double thickness = (style.connectorThickness ?? 2) * scaling;
    final TextStyle title = (style.titleStyle ?? size.titleStyleFor(theme))
        .copyWith(color: colors.foreground);
    final EdgeInsetsGeometry padding = resolveEdgeInsets(
      // Density multipliers (P7-Q2): a plain `EdgeInsets` would pass the
      // resolver through unchanged and pin 8px at every density.
      const EdgeInsetsDensity.pxSymmetric(vertical: 8),
      theme.density.baseContentPadding * scaling,
    );

    // Only the active step stays mounted, so the row collapses to its content
    // instead of reserving room for every step (the old IndexedStack did).
    // Directional indent (P7-Q2): mirrors with the indicator in RTL.
    Widget content(int index, double indent) => AnimatedSwitcher(
      duration: kDefaultDuration,
      child: Padding(
        key: ValueKey<int>(index),
        padding: padding.add(EdgeInsetsDirectional.only(start: indent)),
        child: steps[index].content ?? const SizedBox.shrink(),
      ),
    );

    Widget bar(int index, double width, double? height) => SizedBox(
      width: width,
      height: height,
      child: ColoredBox(color: connectorColor(index, colors)),
    );

    Widget dot(int index) => StepperIndicator(
      index: index,
      phase: phaseFor(index),
      style: styleFor(phaseFor(index)),
      size: box,
      icon: steps[index].icon,
      textStyle: title,
      iconTheme: size.iconThemeFor(theme),
      onPressed: () => onSelect(index),
    );

    if (direction == Axis.horizontal) {
      final List<Widget> cells = <Widget>[];
      for (int i = 0; i < steps.length; i++) {
        final bool last = i == steps.length - 1;
        cells.add(
          Expanded(
            child: Row(
              children: <Widget>[
                dot(i),
                Gap(gap),
                Flexible(
                  child: DefaultTextStyle.merge(
                    style: title,
                    child: steps[i].title,
                  ),
                ),
                if (!last) ...<Widget>[
                  Gap(gap),
                  Expanded(child: bar(i, double.infinity, thickness)),
                ],
              ],
            ),
          ),
        );
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: cells,
            ),
          ),
          content(active, 0),
        ],
      );
    }

    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < steps.length; i++) {
      final bool last = i == steps.length - 1;
      rows.add(
        Row(
          children: <Widget>[
            dot(i),
            Gap(gap),
            Expanded(
              child: DefaultTextStyle.merge(
                style: title,
                child: steps[i].title,
              ),
            ),
          ],
        ),
      );
      if (!last) {
        rows.add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                bar(i, thickness, null),
                Expanded(child: content(i, box + gap * 2)),
              ],
            ),
          ),
        );
        rows.add(SizedBox(height: gap));
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
