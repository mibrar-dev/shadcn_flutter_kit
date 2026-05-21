// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input.dart';

/// Adds a single increment button to numeric input fields.
class InputStepperButtonFeature extends InputFeature {
  /// The amount to increment on each press.
  final double step;

  /// Default value when the input is invalid or empty.
  final double? invalidValue;

  /// Minimum allowed value.
  final double? min;

  /// Maximum allowed value.
  final double? max;

  /// Position of the increment button.
  final InputFeaturePosition position;

  /// Custom icon for the increment button.
  final Widget? icon;

  /// Creates an [InputStepperButtonFeature].
  const InputStepperButtonFeature({
    super.visibility,
    super.skipFocusTraversal,
    this.step = 1.0,
    this.invalidValue = 0.0,
    this.min,
    this.max,
    this.position = InputFeaturePosition.trailing,
    this.icon = const Icon(LucideIcons.plus),
  });

  /// Creates a decrement button feature for numeric inputs.
  const InputStepperButtonFeature.decrement({
    super.visibility,
    super.skipFocusTraversal,
    this.step = -1.0,
    this.invalidValue = 0.0,
    this.min,
    this.max,
    this.position = InputFeaturePosition.trailing,
    this.icon = const Icon(LucideIcons.minus),
  });

  /// Creates the `State` object for this widget.
  @override
  InputFeatureState createState() => _InputStepperButtonFeatureState();
}
