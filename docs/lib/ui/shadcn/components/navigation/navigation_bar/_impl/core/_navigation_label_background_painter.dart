// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// _NavigationLabelBackgroundPainter defines a reusable type for this registry module.
class _NavigationLabelBackgroundPainter extends CustomPainter {
  /// Stores `color` state/configuration for this implementation.
  final Color color;

  /// Stores `indent` state/configuration for this implementation.
  final double indent;

  /// Stores `endIndent` state/configuration for this implementation.
  final double endIndent;

  /// Stores `direction` state/configuration for this implementation.
  final Axis direction;

  /// Creates a `_NavigationLabelBackgroundPainter` instance.
  _NavigationLabelBackgroundPainter({
    required this.color,
    required this.indent,
    required this.endIndent,
    required this.direction,
  });

  @override
  /// Executes `paint` behavior for this component/composite.
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    // indent and endIndent is direction dependent
    if (direction == Axis.vertical) {
      /// Creates a `canvas.drawRect` instance.
      canvas.drawRect(
        /// Creates a `Rect.fromLTWH` instance.
        Rect.fromLTWH(indent, 0, size.width - indent - endIndent, size.height),
        paint,
      );
    } else {
      /// Creates a `canvas.drawRect` instance.
      canvas.drawRect(
        /// Creates a `Rect.fromLTWH` instance.
        Rect.fromLTWH(0, indent, size.width, size.height - indent - endIndent),
        paint,
      );
    }
  }

  @override
  /// Executes `shouldRepaint` behavior for this component/composite.
  bool shouldRepaint(covariant _NavigationLabelBackgroundPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.indent != indent ||
        oldDelegate.endIndent != endIndent ||
        oldDelegate.direction != direction;
  }
}
