// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../star_rating.dart';

/// Intent for increasing the star rating value via keyboard shortcuts.
///
/// Used with Flutter's shortcuts and actions system to handle keyboard
/// input for incrementing the rating. Typically bound to right arrow key.
class IncreaseStarIntent extends Intent {
  /// The step size to increase the rating by.
  final double step;

  /// Creates an [IncreaseStarIntent].
  const IncreaseStarIntent(this.step);
}
