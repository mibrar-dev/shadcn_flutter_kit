// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../input.dart';

/// Adds a custom widget above or below the text input area.
///
/// Use this feature to place helper content directly above or below the field.
class InputAboveBelowFeature extends InputFeature {
  /// Widget shown above or below the input.
  final Widget? child;

  /// Position of the [child] relative to the input.
  final InputFeaturePosition position;

  /// Creates an [InputAboveBelowFeature].
  const InputAboveBelowFeature({
    super.visibility,
    super.skipFocusTraversal,
    this.child,
    this.position = InputFeaturePosition.below,
  });

  /// Creates an [InputAboveBelowFeature] above the input.
  const InputAboveBelowFeature.above(
    this.child, {
    super.visibility,
    super.skipFocusTraversal,
  }) : position = InputFeaturePosition.above;

  /// Creates an [InputAboveBelowFeature] below the input.
  const InputAboveBelowFeature.below(
    this.child, {
    super.visibility,
    super.skipFocusTraversal,
  }) : position = InputFeaturePosition.below;

  /// Creates the `State` object for this widget.
  @override
  InputFeatureState createState() => _InputAboveBelowFeatureState();
}
