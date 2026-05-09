// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show Colors, Divider, Icons, VerticalDivider;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../shared/primitives/clickable.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/util.dart';
import '../../display/icon/icon.dart';
import '../../display/text/text.dart';
part '_impl/state/_step_container_state.dart';
part '_impl/core/step_container.dart';
part '_impl/core/step_title.dart';
part '_impl/core/step_number.dart';
part '_impl/core/step_number_data.dart';
part '_impl/core/stepper_2.dart';
part '_impl/utils/stepper_controller.dart';
part '_impl/themes/base/stepper_theme.dart';
part '_impl/core/step_properties.dart';
part '_impl/variants/step_variant.dart';
part '_impl/variants/_step_variant_line.dart';
part '_impl/variants/_step_variant_circle_alternative.dart';
part '_impl/variants/_step_variant_circle.dart';
part '_impl/core/step.dart';
part '_impl/core/stepper_value.dart';

/// Represents the state of an individual step in a stepper.
///
/// Currently supports failed state indication, with potential for
/// expansion to include additional states like completed, active, etc.
enum StepState {
  /// Indicates a step has failed validation or encountered an error.
  failed,
}

/// Immutable value representing the current state of a stepper.
///
/// Contains the current active step index and a map of step states
/// for any steps that have special states (like failed). Used by
/// [StepperController] to track and notify about stepper state changes.
///
/// Example:
/// ```dart
/// final value = StepperValue(
///   currentStep: 2,
///   stepStates: {1: StepState.failed},
/// );
/// ```

/// Represents a single step in a stepper component.
///
/// Contains the step's title, optional content builder for step details,
/// and an optional custom icon. The content builder is called when
/// the step becomes active to show step-specific content.
///
/// Example:
/// ```dart
/// Step(
///   title: Text('Personal Info'),
///   icon: Icon(Icons.person),
///   contentBuilder: (context) => PersonalInfoForm(),
/// );
/// ```

/// Function type for building size-appropriate step content.
///
/// Takes a [BuildContext] and child widget, returns a styled widget
/// with appropriate sizing applied.
typedef StepSizeBuilder = Widget Function(BuildContext context, Widget child);

/// Defines the size variants available for step indicators.
///
/// Each size includes both a numeric size value and a builder function
/// that applies appropriate text and icon styling. Sizes scale with
/// the theme's scaling factor.
///
/// Example:
/// ```dart
/// Stepper(
///   size: StepSize.large,
///   steps: mySteps,
///   controller: controller,
/// );
/// ```
enum StepSize {
  /// Small step indicators with compact text and icons.
  small(_smallSize, kSmallStepIndicatorSize),

  /// Medium step indicators with normal text and icons (default).
  medium(_mediumSize, kMediumStepIndicatorSize),

  /// Large step indicators with larger text and icons.
  large(_largeSize, kLargeStepIndicatorSize);

  /// The numeric size value for the step indicator.
  final double size;

  /// Builder function that applies size-appropriate styling.
  final StepSizeBuilder wrapper;

  const StepSize(this.wrapper, this.size);
}

/// Applies small text and icon sizing to the child widget.
Widget _smallSize(BuildContext context, Widget child) {
  return child.small().iconSmall();
}

/// Applies normal text and icon sizing to the child widget.
Widget _mediumSize(BuildContext context, Widget child) {
  return child.normal().iconMedium();
}

/// Applies large text and icon sizing to the child widget.
Widget _largeSize(BuildContext context, Widget child) {
  return child.large().iconLarge();
}

/// Default small step indicator size in logical pixels.
const kSmallStepIndicatorSize = 36.0;

/// Default medium step indicator size in logical pixels.
const kMediumStepIndicatorSize = 40.0;

/// Default large step indicator size in logical pixels.
const kLargeStepIndicatorSize = 44.0;

/// Contains properties and state information for stepper rendering.
///
/// Used internally by [StepVariant] implementations to build the
/// appropriate stepper layout. Provides access to step data, current
/// state, sizing configuration, and layout direction.
///
/// Also includes utility methods like [hasFailure] to check for failed
/// steps and array-style access to individual steps.

/// Controller for managing stepper state and navigation.
///
/// Extends [ValueNotifier] to provide reactive state updates when
/// the current step changes or step states are modified. Includes
/// methods for navigation (next/previous), direct step jumping,
/// and setting individual step states.
///
/// The controller should be disposed when no longer needed to prevent
/// memory leaks.
///
/// Example:
/// ```dart
/// final controller = StepperController(currentStep: 0);
///
/// // Navigate to next step
/// controller.nextStep();
///
/// // Mark step as failed
/// controller.setStatus(1, StepState.failed);
///
/// // Jump to specific step
/// controller.jumpToStep(3);
///
/// // Don't forget to dispose
/// controller.dispose();
/// ```

/// A multi-step navigation component with visual progress indication.
///
/// Displays a sequence of steps with customizable visual styles, supporting
/// both horizontal and vertical layouts. Each step can have a title, optional
/// content, and custom icons. The component tracks current step progress and
/// can display failed states.
///
/// Uses a [StepperController] for state management and navigation. Steps are
/// defined using [Step] objects, and visual presentation is controlled by
/// [StepVariant] and [StepSize] configurations.
///
/// The stepper automatically handles step indicators, connecting lines or
/// progress bars, and animated content transitions between steps.
///
/// Example:
/// ```dart
/// final controller = StepperController();
///
/// Stepper(
///   controller: controller,
///   direction: Axis.vertical,
///   variant: StepVariant.circle,
///   size: StepSize.medium,
///   steps: [
///     Step(
///       title: Text('Personal Info'),
///       contentBuilder: (context) => PersonalInfoForm(),
///     ),
///     Step(
///       title: Text('Address'),
///       contentBuilder: (context) => AddressForm(),
///     ),
///     Step(
///       title: Text('Confirmation'),
///       contentBuilder: (context) => ConfirmationView(),
///     ),
///   ],
/// );
/// ```

/// Data class providing step index context to descendant widgets.
///
/// Used internally by the stepper to pass the current step index
/// to child widgets like [StepNumber]. Accessible via [Data.maybeOf].
///
/// Example:
/// ```dart
/// final stepData = Data.maybeOf<StepNumberData>(context);
/// final stepIndex = stepData?.stepIndex ?? 0;
/// ```

/// Step indicator widget displaying step number, checkmark, or custom icon.
///
/// Renders a circular (or rectangular based on theme) step indicator that
/// shows the step number by default, a checkmark for completed steps,
/// or an X for failed steps. Colors and states are automatically managed
/// based on the stepper's current state.
///
/// Must be used within a [Stepper] widget tree to access step context.
/// Optionally supports custom icons and click handling.
///
/// Example:
/// ```dart
/// StepNumber(
///   icon: Icon(Icons.star),
///   onPressed: () => print('Step tapped'),
/// );
/// ```

/// Clickable step title widget with optional subtitle.
///
/// Displays the step title and optional subtitle in a clickable container.
/// Used within stepper layouts to provide interactive step navigation.
/// Supports customizable cross-axis alignment for text positioning.
///
/// Example:
/// ```dart
/// StepTitle(
///   title: Text('Account Setup'),
///   subtitle: Text('Enter your personal details'),
///   onPressed: () => jumpToThisStep(),
/// );
/// ```

/// Container widget for step content with optional action buttons.
///
/// Provides consistent padding and layout for step content, with optional
/// action buttons displayed below the main content. Actions are arranged
/// horizontally with appropriate spacing.
///
/// Typically used within step content builders to provide a consistent
/// layout for form content, descriptions, and navigation buttons.
///
/// Example:
/// ```dart
/// StepContainer(
///   child: Column(
///     children: [
///       TextFormField(decoration: InputDecoration(labelText: 'Name')),
///       TextFormField(decoration: InputDecoration(labelText: 'Email')),
///     ],
///   ),
///   actions: [
///     Button(
///       onPressed: controller.previousStep,
///       child: Text('Back'),
///     ),
///     Button(
///       onPressed: controller.nextStep,
///       child: Text('Next'),
///     ),
///   ],
/// );
/// ```
