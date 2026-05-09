// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../star_rating.dart';

/// Intent for decreasing the star rating value via keyboard shortcuts.
///
/// Used with Flutter's shortcuts and actions system to handle keyboard
/// input for decrementing the rating. Typically bound to left arrow key.
class DecreaseStarIntent extends Intent {
  /// The step size to decrease the rating by.
  final double step;

  /// Creates a [DecreaseStarIntent].
  const DecreaseStarIntent(this.step);
}
