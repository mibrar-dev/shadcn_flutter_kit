// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../avatar.dart';

/// Core class used by the avatar component.
class AvatarGroup extends StatelessWidget {
  /// Creates `AvatarGroup` for configuring or rendering avatar.
  const AvatarGroup({
    super.key,
    required this.alignment,
    required this.children,
    this.gap,
    this.clipBehavior,
  });

  /// Child content displayed inside the avatar widget.
  final List<AvatarWidget> children;

  /// Controls how avatar content is aligned within available space.
  final AlignmentGeometry alignment;

  /// Layout/size setting that affects avatar rendering.
  final double? gap;

  /// Clip behavior applied when avatar content overflows bounds.
  final Clip? clipBehavior;

  /// Factory constructor that derives a `AvatarGroup.toLeft` configuration for avatar.
  factory AvatarGroup.toLeft({
    Key? key,
    required List<AvatarWidget> children,
    double? gap,
    double offset = 0.5,
  }) {
    return AvatarGroup(
      key: key,
      alignment: Alignment(offset, 0),
      gap: gap,
      children: children,
    );
  }

  /// Factory constructor that derives a `AvatarGroup.toRight` configuration for avatar.
  factory AvatarGroup.toRight({
    Key? key,
    required List<AvatarWidget> children,
    double? gap,
    double offset = 0.5,
  }) {
    return AvatarGroup(
      key: key,
      alignment: Alignment(-offset, 0),
      gap: gap,
      children: children,
    );
  }

  /// Factory constructor that derives a `AvatarGroup.toStart` configuration for avatar.
  factory AvatarGroup.toStart({
    Key? key,
    required List<AvatarWidget> children,
    double? gap,
    double offset = 0.5,
  }) {
    return AvatarGroup(
      key: key,
      alignment: AlignmentDirectional(offset, 0),
      gap: gap,
      children: children,
    );
  }

  /// Factory constructor that derives a `AvatarGroup.toEnd` configuration for avatar.
  factory AvatarGroup.toEnd({
    Key? key,
    required List<AvatarWidget> children,
    double? gap,
    double offset = 0.5,
  }) {
    return AvatarGroup(
      key: key,
      alignment: AlignmentDirectional(-offset, 0),
      gap: gap,
      children: children,
    );
  }

  /// Factory constructor that derives a `AvatarGroup.toTop` configuration for avatar.
  factory AvatarGroup.toTop({
    Key? key,
    required List<AvatarWidget> children,
    double? gap,
    double offset = 0.5,
  }) {
    return AvatarGroup(
      key: key,
      alignment: Alignment(0, offset),
      gap: gap,
      children: children,
    );
  }

  /// Factory constructor that derives a `AvatarGroup.toBottom` configuration for avatar.
  factory AvatarGroup.toBottom({
    Key? key,
    required List<AvatarWidget> children,
    double? gap,
    double offset = 0.5,
  }) {
    return AvatarGroup(
      key: key,
      alignment: Alignment(0, -offset),
      gap: gap,
      children: children,
    );
  }

  /// Builds the widget tree for avatar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Positioned> entries = [];

    double currentX = 0;

    double currentY = 0;

    double currentWidth = 0;

    double currentHeight = 0;

    Rect rect = Rect.zero;

    double currentBorderRadius = 0;
    final resolved = alignment.optionallyResolve(context);

    for (var i = 0; i < children.length; i++) {
      final avatar = children[i];

      final size = avatar.size ?? theme.scaling * 40;
      if (i == 0) {
        entries.add(Positioned(left: currentX, top: currentY, child: avatar));
        rect = Rect.fromLTWH(currentX, currentY, size, size);
        currentWidth = size;
        currentHeight = size;
        currentBorderRadius = avatar.borderRadius ?? theme.radius * size;
        continue;
      }

      final width = size;

      final height = size;

      final widthDiff = currentWidth - width;

      final heightDiff = currentHeight - height;

      final offsetWidth = -currentWidth * resolved.x;

      final offsetHeight = -currentHeight * resolved.y;

      final offsetWidthDiff = widthDiff * resolved.x;

      final offsetHeightDiff = heightDiff * resolved.y;
      final x = (widthDiff / 2) + offsetWidth + currentX + offsetWidthDiff;
      final y = (heightDiff / 2) + offsetHeight + currentY + offsetHeightDiff;

      entries.add(
        Positioned(
          left: x,
          top: y,
          width: size,
          height: size,
          child: ClipPath(
            clipper: AvatarGroupClipper(
              borderRadius: currentBorderRadius,
              alignment: resolved,
              previousAvatarSize: currentWidth,
              gap: gap ?? theme.scaling * 4,
            ),
            child: avatar,
          ),
        ),
      );

      currentX = x;
      currentY = y;
      currentWidth = size;
      currentHeight = size;
      currentBorderRadius = avatar.borderRadius ?? theme.radius * size;
      rect = rect.expandToInclude(Rect.fromLTWH(x, y, size, size));
    }

    return SizedBox(
      width: rect.width,
      height: rect.height,
      child: Stack(
        clipBehavior: clipBehavior ?? Clip.none,
        alignment: Alignment.center,
        children: entries
            .map(
              (entry) => Positioned(
                left: entry.left! - rect.left,
                top: entry.top! - rect.top,
                width: entry.width,
                height: entry.height,
                child: entry.child,
              ),
            )
            .toList(),
      ),
    );
  }
}
