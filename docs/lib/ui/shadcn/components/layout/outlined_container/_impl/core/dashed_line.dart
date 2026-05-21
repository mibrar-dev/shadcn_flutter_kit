// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../outlined_container.dart';

/// DashedLine defines a reusable type for this registry module.
class DashedLine extends StatelessWidget {
  /// Creates a `DashedLine` instance.
  const DashedLine({
    super.key,
    this.width,
    this.gap,
    this.thickness,
    this.color,
  });

  /// Stores `width` state/configuration for this implementation.
  final double? width;

  /// Stores `gap` state/configuration for this implementation.
  final double? gap;

  /// Stores `thickness` state/configuration for this implementation.
  final double? thickness;

  /// Stores `color` state/configuration for this implementation.
  final Color? color;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedValueBuilder<DashedLineProperties>(
      value: DashedLineProperties(
        width: width ?? 8 * theme.scaling,
        gap: gap ?? 5 * theme.scaling,
        thickness: thickness ?? 1 * theme.scaling,
        color: color ?? theme.colorScheme.border,
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
        return DashedLineProperties.lerp(start, end, t);
      },
      builder: (context, value, child) {
        return CustomPaint(
          painter: DashedLinePainter(
            width: value.width,
            gap: value.gap,
            thickness: value.thickness,
            color: value.color,
          ),
        );
      },
    );
  }
}
