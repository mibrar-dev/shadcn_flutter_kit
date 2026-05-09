// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stepper.dart';

/// StepProperties defines a reusable type for this registry module.
class StepProperties {
  /// Size configuration for step indicators.
  final StepSize size;

  /// List of steps in the stepper.
  final List<Step> steps;

  /// Listenable state containing current step and step states.
  final ValueListenable<StepperValue> state;

  /// Layout direction for the stepper.
  final Axis direction;

  /// Creates [StepProperties].
  const StepProperties({
    required this.size,
    required this.steps,
    required this.state,
    required this.direction,
  });

  /// Safely accesses a step by index, returning null if out of bounds.
  Step? operator [](int index) {
    if (index < 0 || index >= steps.length) {
      return null;
    }
    return steps[index];
  }

  /// Returns true if any step has a failed state.
  bool get hasFailure => state.value.stepStates.containsValue(StepState.failed);

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StepProperties &&
        other.size == size &&
        /// Creates a `listEquals` instance.
        listEquals(other.steps, steps) &&
        other.state == state &&
        other.direction == direction;
  }

  @override
  int get hashCode => Object.hash(size, steps, state, direction);
}
