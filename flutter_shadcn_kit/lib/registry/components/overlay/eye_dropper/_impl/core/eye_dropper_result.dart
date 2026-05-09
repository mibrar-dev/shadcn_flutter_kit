// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../eye_dropper.dart';

/// EyeDropperResult defines a reusable type for this registry module.
class EyeDropperResult {
  /// The size of the captured area.
  final Size size;

  /// All colors in the captured area, stored row by row.
  final List<Color> colors;

  /// The specific color that was picked by the user.
  final Color pickedColor;

  /// Creates an [EyeDropperResult].
  const EyeDropperResult(this.colors, this.size, this.pickedColor);

  /// Gets the color at the specified position in the captured area.
  ///
  /// Parameters:
  /// - [position]: The offset position within the captured area.
  ///
  /// Returns: The color at that position.
  Color operator [](Offset position) {
    int index = (position.dy.floor() * size.width + position.dx.floor())
        .toInt();
    return colors[index];
  }
}
