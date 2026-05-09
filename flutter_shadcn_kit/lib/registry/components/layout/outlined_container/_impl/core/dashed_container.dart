// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../outlined_container.dart';

/// DashedContainer defines a reusable type for this registry module.
class DashedContainer extends StatelessWidget {
  /// Creates a `DashedContainer` instance.
  const DashedContainer({
    super.key,
    this.strokeWidth,
    this.gap,
    this.thickness,
    this.color,
    this.borderRadius,
    required this.child,
  });

  /// Stores `strokeWidth` state/configuration for this implementation.
  final double? strokeWidth;

  /// Stores `gap` state/configuration for this implementation.
  final double? gap;

  /// Stores `thickness` state/configuration for this implementation.
  final double? thickness;

  /// Stores `color` state/configuration for this implementation.
  final Color? color;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedValueBuilder<DashedContainerProperties>(
      value: DashedContainerProperties(
        width: strokeWidth ?? 8 * theme.scaling,
        gap: gap ?? 5 * theme.scaling,
        thickness: thickness ?? 1 * theme.scaling,
        color: color ?? theme.colorScheme.border,
        borderRadius: borderRadius ?? theme.borderRadiusLg,
      ),
      duration: kDefaultDuration,
      lerp: (a, b, t) {
        /// Stores `start` state/configuration for this implementation.
        final start = a ?? b;

        /// Stores `end` state/configuration for this implementation.
        final end = b ?? a ?? start;
        if (start == null || end == null) {
          return a ?? b;
        }
        return DashedContainerProperties.lerp(context, start, end, t);
      },
      builder: (context, value, child) {
        return CustomPaint(
          painter: DashedPainter(
            width: value.width,
            gap: value.gap,
            thickness: value.thickness,
            color: value.color,
            borderRadius: value.borderRadius.optionallyResolve(context),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
