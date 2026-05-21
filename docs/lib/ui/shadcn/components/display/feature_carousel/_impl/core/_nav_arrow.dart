// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../feature_carousel.dart';

/// Internal helper class used by the feature carousel component implementation.
class _NavArrow extends StatelessWidget {
  /// Creates `_NavArrow` for configuring or rendering feature carousel.
  const _NavArrow({
    required this.direction,
    required this.size,
    required this.radius,
    required this.background,
    required this.iconColor,
    required this.pressed,
    required this.hovered,
    required this.onPressed,
    required this.onPressedChanged,
    required this.onHoverChanged,
  });

  /// Input parameter used by `_NavArrow` during rendering and behavior handling.
  final _CarouselDirection direction;

  /// Layout/size setting that affects feature carousel rendering.
  final double size;

  /// Layout/size setting that affects feature carousel rendering.
  final double radius;

  /// Input parameter used by `_NavArrow` during rendering and behavior handling.
  final Color background;

  /// Color value used by feature carousel painting or state styling.
  final Color iconColor;

  /// Input parameter used by `_NavArrow` during rendering and behavior handling.
  final bool pressed;

  /// Input parameter used by `_NavArrow` during rendering and behavior handling.
  final bool hovered;

  /// Callback invoked by feature carousel when `onPressed` is triggered.
  final VoidCallback onPressed;

  /// Callback invoked by feature carousel when `onPressedChanged` is triggered.
  final ValueChanged<bool> onPressedChanged;

  /// Callback invoked by feature carousel when `onHoverChanged` is triggered.
  final ValueChanged<bool> onHoverChanged;

  /// Builds the widget tree for feature carousel.
  @override
  Widget build(BuildContext context) {
    final icon = direction == _CarouselDirection.left
        ? Icons.chevron_left
        : Icons.chevron_right;

    return Semantics(
      button: true,
      label: direction == _CarouselDirection.left ? 'Previous' : 'Next',
      child: MouseRegion(
        onEnter: (_) => onHoverChanged(true),
        onExit: (_) => onHoverChanged(false),
        child: GestureDetector(
          onTap: onPressed,
          onTapDown: (_) => onPressedChanged(true),
          onTapUp: (_) => onPressedChanged(false),
          onTapCancel: () => onPressedChanged(false),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 90),
            scale: pressed ? 0.96 : 1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: hovered
                    ? background.withValues(alpha: 0.16)
                    : background,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Icon(
                icon,
                color: hovered ? iconColor.withValues(alpha: 0.75) : iconColor,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
