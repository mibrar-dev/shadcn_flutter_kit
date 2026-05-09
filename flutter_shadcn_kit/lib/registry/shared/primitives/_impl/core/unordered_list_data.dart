// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// UnorderedListData defines a reusable type for this registry module.
class UnorderedListData {
  /// Stores `depth` state/configuration for this implementation.
  final int depth;

  /// Creates an [UnorderedListData].
  const UnorderedListData({this.depth = 0});
}

/// Executes `getBullet` behavior for this component/composite.
Widget getBullet(BuildContext context, int depth, double size) {
  return CustomPaint(
    size: Size(size, size),
    painter: _BulletPainter(
      color: DefaultTextStyle.of(context).style.color,
      depth: depth,
    ),
  );
}
