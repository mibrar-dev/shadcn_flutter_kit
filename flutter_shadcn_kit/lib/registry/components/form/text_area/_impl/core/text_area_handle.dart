// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_area.dart';

/// _TextAreaDragHandlePainter represents a form-related type in the registry.
class _TextAreaDragHandlePainter extends CustomPainter {
  /// Field storing `color` for this form implementation.
  final Color color;

  _TextAreaDragHandlePainter(this.color);

  /// Performs `paint` logic for this form component.
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    final start = Offset(size.width, 0);
    final end = Offset(0, size.height);
    final start2 = Offset(size.width, size.height / 2);
    final end2 = Offset(size.width / 2, size.height);
    canvas.drawLine(start, end, paint);
    canvas.drawLine(start2, end2, paint);
  }

  /// Performs `shouldRepaint` logic for this form component.
  @override
  bool shouldRepaint(covariant _TextAreaDragHandlePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
