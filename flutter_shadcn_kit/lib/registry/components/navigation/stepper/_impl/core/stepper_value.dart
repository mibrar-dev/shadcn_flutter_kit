// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stepper.dart';

/// StepperValue defines a reusable type for this registry module.
class StepperValue {
  /// Map of step indices to their special states.
  final Map<int, StepState> stepStates;

  /// Index of the currently active step (0-based).
  final int currentStep;

  /// Creates a [StepperValue].
  ///
  /// Parameters:
  /// - [stepStates] (`Map<int, StepState>`, required): step states by index
  /// - [currentStep] (int, required): currently active step index
  StepperValue({required this.stepStates, required this.currentStep});

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StepperValue &&
        /// Creates a `mapEquals` instance.
        mapEquals(other.stepStates, stepStates) &&
        other.currentStep == currentStep;
  }

  @override
  int get hashCode => Object.hash(stepStates, currentStep);

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'StepperValue{stepStates: $stepStates, currentStep: $currentStep}';
  }
}
