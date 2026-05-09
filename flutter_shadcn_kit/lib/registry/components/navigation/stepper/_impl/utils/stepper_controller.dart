// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stepper.dart';

/// StepperController defines a reusable type for this registry module.
class StepperController extends ValueNotifier<StepperValue> {
  /// Creates a [StepperController].
  ///
  /// Parameters:
  /// - [stepStates] (`Map<int, StepState>?`): initial step states (default: empty)
  /// - [currentStep] (int?): initial active step index (default: 0)
  ///
  /// Example:
  /// ```dart
  /// final controller = StepperController(
  ///   currentStep: 1,
  ///   stepStates: {0: StepState.failed},
  /// );
  /// ```
  StepperController({Map<int, StepState>? stepStates, int? currentStep})
    : super(
        StepperValue(
          stepStates: stepStates ?? {},
          currentStep: currentStep ?? 0,
        ),
      );

  /// Advances to the next step.
  ///
  /// Increments the current step index by 1. Does not validate
  /// if the next step exists - callers should check bounds.
  ///
  /// Example:
  /// ```dart
  /// if (controller.value.currentStep < steps.length - 1) {
  ///   controller.nextStep();
  /// }
  /// ```
  void nextStep() {
    value = StepperValue(
      stepStates: value.stepStates,
      currentStep: value.currentStep + 1,
    );
  }

  /// Returns to the previous step.
  ///
  /// Decrements the current step index by 1. Does not validate
  /// if the previous step exists - callers should check bounds.
  ///
  /// Example:
  /// ```dart
  /// if (controller.value.currentStep > 0) {
  ///   controller.previousStep();
  /// }
  /// ```
  void previousStep() {
    value = StepperValue(
      stepStates: value.stepStates,
      currentStep: value.currentStep - 1,
    );
  }

  /// Sets or clears the state of a specific step.
  ///
  /// Parameters:
  /// - [step] (int): zero-based step index to modify
  /// - [state] (StepState?): new state, or null to clear
  ///
  /// Example:
  /// ```dart
  /// // Mark step as failed
  /// controller.setStatus(2, StepState.failed);
  ///
  /// // Clear step state
  /// controller.setStatus(2, null);
  /// ```
  void setStatus(int step, StepState? state) {
    Map<int, StepState> newStates = Map.from(value.stepStates);
    if (state == null) {
      newStates.remove(step);
    } else {
      newStates[step] = state;
    }
    value = StepperValue(stepStates: newStates, currentStep: value.currentStep);
  }

  /// Jumps directly to the specified step.
  ///
  /// Parameters:
  /// - [step] (int): zero-based step index to navigate to
  ///
  /// Example:
  /// ```dart
  /// // Jump to final step
  /// controller.jumpToStep(steps.length - 1);
  /// ```
  void jumpToStep(int step) {
    value = StepperValue(stepStates: value.stepStates, currentStep: step);
  }
}
