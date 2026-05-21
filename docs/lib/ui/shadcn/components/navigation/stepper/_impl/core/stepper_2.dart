// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stepper.dart';

/// Stepper defines a reusable type for this registry module.
class Stepper extends StatelessWidget {
  /// Controller for managing stepper state and navigation.
  final StepperController controller;

  /// List of steps to display in the stepper.
  final List<Step> steps;

  /// Layout direction (horizontal or vertical).
  final Axis? direction;

  /// Size variant for step indicators.
  final StepSize? size;

  /// Visual variant for step presentation.
  final StepVariant? variant;

  /// Creates a [Stepper].
  ///
  /// The [controller] and [steps] are required. Other parameters are optional
  /// and will use theme defaults or built-in defaults if not provided.
  ///
  /// Parameters:
  /// - [controller] (StepperController, required): manages state and navigation
  /// - [steps] (`List<Step>`, required): list of steps to display
  /// - [direction] (Axis?): horizontal or vertical layout (default: horizontal)
  /// - [size] (StepSize?): step indicator size (default: medium)
  /// - [variant] (StepVariant?): visual style (default: circle)
  ///
  /// Example:
  /// ```dart
  /// final controller = StepperController(currentStep: 0);
  ///
  /// Stepper(
  ///   controller: controller,
  ///   direction: Axis.vertical,
  ///   size: StepSize.large,
  ///   variant: StepVariant.line,
  ///   steps: [
  ///     Step(title: Text('Step 1')),
  ///     Step(title: Text('Step 2')),
  ///     Step(title: Text('Step 3')),
  ///   ],
  /// );
  /// ```
  const Stepper({
    super.key,
    required this.controller,
    required this.steps,
    this.direction,
    this.size,
    this.variant,
  });

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<StepperTheme>(context);

    /// Stores `dir` state/configuration for this implementation.
    final dir = direction ?? compTheme?.direction ?? Axis.horizontal;

    /// Stores `sz` state/configuration for this implementation.
    final sz = size ?? compTheme?.size ?? StepSize.medium;

    /// Stores `varnt` state/configuration for this implementation.
    final varnt = variant ?? compTheme?.variant ?? StepVariant.circle;
    var stepProperties = StepProperties(
      size: sz,
      steps: steps,
      state: controller,
      direction: dir,
    );
    return Data.inherit(
      data: stepProperties,
      child: varnt.build(context, stepProperties),
    );
  }
}
