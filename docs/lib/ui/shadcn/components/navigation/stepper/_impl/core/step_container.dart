// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stepper.dart';

/// StepContainer defines a reusable type for this registry module.
class StepContainer extends StatefulWidget {
  /// The main content widget for the step.
  final Widget child;

  /// List of action widgets (typically buttons) displayed below content.
  final List<Widget> actions;

  /// Creates a [StepContainer].
  ///
  /// The [child] and [actions] parameters are required. Actions can be
  /// an empty list if no buttons are needed.
  ///
  /// Parameters:
  /// - [child] (Widget, required): main step content
  /// - [actions] (`List<Widget>`, required): action buttons or widgets
  ///
  /// Example:
  /// ```dart
  /// StepContainer(
  ///   child: FormFields(),
  ///   actions: [
  ///     Button(onPressed: previousStep, child: Text('Back')),
  ///     Button(onPressed: nextStep, child: Text('Continue')),
  ///   ],
  /// );
  /// ```
  const StepContainer({super.key, required this.child, required this.actions});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<StepContainer> createState() => _StepContainerState();
}
