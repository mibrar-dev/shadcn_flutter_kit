// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../avatar.dart';

/// Core class used by the avatar component.
class AvatarBadge extends StatelessWidget implements AvatarWidget {
  /// Creates `AvatarBadge` for configuring or rendering avatar.
  const AvatarBadge({
    super.key,
    this.child,
    this.size,
    this.borderRadius,
    this.color,
  });

  /// Child content displayed inside the avatar widget.
  final Widget? child;

  /// Layout/size setting that affects avatar rendering.
  @override
  final double? size;

  /// Layout/size setting that affects avatar rendering.
  @override
  final double? borderRadius;

  /// Color value used by avatar painting or state styling.
  final Color? color;

  /// Builds the widget tree for avatar.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final resolvedSize = size ?? theme.scaling * 12;
    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(
          borderRadius ?? theme.radius * resolvedSize,
        ),
      ),
      child: child,
    );
  }
}
