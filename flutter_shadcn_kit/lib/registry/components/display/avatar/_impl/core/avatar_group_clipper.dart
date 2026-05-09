// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../avatar.dart';

/// Clipper that shapes painted regions used by avatar.
class AvatarGroupClipper extends CustomClipper<Path> {
  /// Creates `AvatarGroupClipper` for configuring or rendering avatar.
  const AvatarGroupClipper({
    required this.borderRadius,
    required this.alignment,
    required this.previousAvatarSize,
    required this.gap,
  });

  /// Layout/size setting that affects avatar rendering.
  final double borderRadius;

  /// Controls how avatar content is aligned within available space.
  final Alignment alignment;

  /// Layout/size setting that affects avatar rendering.
  final double previousAvatarSize;

  /// Layout/size setting that affects avatar rendering.
  final double gap;

  /// Implements `getClip` behavior for avatar.
  @override
  Path getClip(Size size) {
    final widthDiff = size.width - previousAvatarSize;

    final heightDiff = size.height - previousAvatarSize;

    var left = widthDiff / 2;

    var top = heightDiff / 2;
    left += size.width * alignment.x;
    top += size.height * alignment.y;

    final path = Path()..fillType = PathFillType.evenOdd;
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutout = Rect.fromLTWH(
      left - gap,
      top - gap,
      previousAvatarSize + gap * 2,
      previousAvatarSize + gap * 2,
    );

    if (borderRadius > 0) {
      path.addRRect(
        RRect.fromRectAndRadius(
          cutout,

          Radius.circular(borderRadius + gap * 2),
        ),
      );
    } else {
      path.addRect(cutout);
    }
    return path;
  }

  /// Implements `shouldReclip` behavior for avatar.
  @override
  bool shouldReclip(covariant AvatarGroupClipper oldClipper) {
    return oldClipper.borderRadius != borderRadius ||
        oldClipper.alignment != alignment ||
        oldClipper.previousAvatarSize != previousAvatarSize ||
        oldClipper.gap != gap;
  }
}
