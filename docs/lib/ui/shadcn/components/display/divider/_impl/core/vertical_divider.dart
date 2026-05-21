// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../divider.dart';

/// Vertical line that divides horizontal layouts.
class VerticalDivider extends StatelessWidget implements PreferredSizeWidget {
  /// Creates `VerticalDivider` for configuring or rendering divider.
  const VerticalDivider({
    super.key,
    this.color,
    this.width,
    this.thickness,
    this.indent,
    this.endIndent,
    this.child,
    this.padding,
    this.childAlignment,
  });

  /// Color value used by divider painting or state styling.
  final Color? color;

  /// Layout/size setting that affects divider rendering.
  final double? width;

  /// Input parameter used by `VerticalDivider` during rendering and behavior handling.
  final double? thickness;

  /// Input parameter used by `VerticalDivider` during rendering and behavior handling.
  final double? indent;

  /// Input parameter used by `VerticalDivider` during rendering and behavior handling.
  final double? endIndent;

  /// Child content displayed inside the divider widget.
  final Widget? child;

  /// Layout/size setting that affects divider rendering.
  final EdgeInsetsGeometry? padding;

  /// Child content displayed inside the divider widget.
  final AxisAlignmentGeometry? childAlignment;

  @override
  Size get preferredSize => Size(width ?? 1, 0);

  /// Builds the widget tree for divider.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final resolvedChildAlignment = (childAlignment ?? AxisAlignment.center)
        .resolve(textDirection);
    if (child != null) {
      final clampedAlignmentValue = resolvedChildAlignment.value.clamp(
        -1.0,
        1.0,
      );
      final topRatio = (clampedAlignmentValue + 1) / 2;

      final bottomRatio = 1 - topRatio;
      final topFlex = (topRatio * 1000).round();
      final bottomFlex = (bottomRatio * 1000).round();
      return SizedBox(
        height: double.infinity,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (topFlex > 0)
                Expanded(
                  flex: topFlex,
                  child: SizedBox(
                    width: width ?? 1,
                    child: AnimatedValueBuilder(
                      value: DividerProperties(
                        color: color ?? theme.colorScheme.border,
                        thickness: thickness ?? 1,
                        indent: indent ?? 0,
                        endIndent: 0,
                      ),
                      duration: kDefaultDuration,
                      lerp: DividerProperties.lerp,
                      builder: (context, value, child) {
                        return CustomPaint(
                          painter: VerticalDividerPainter(
                            color: value.color,
                            thickness: value.thickness,
                            indent: value.indent,
                            endIndent: value.endIndent,
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              child!.muted().small().withPadding(
                padding:
                    padding ??
                    EdgeInsets.symmetric(vertical: theme.density.baseGap),
              ),
              if (bottomFlex > 0)
                Expanded(
                  flex: bottomFlex,
                  child: SizedBox(
                    width: width ?? 1,
                    child: AnimatedValueBuilder(
                      value: DividerProperties(
                        color: color ?? theme.colorScheme.border,
                        thickness: thickness ?? 1,
                        indent: 0,
                        endIndent: endIndent ?? 0,
                      ),
                      duration: kDefaultDuration,
                      lerp: DividerProperties.lerp,
                      builder: (context, value, child) {
                        return CustomPaint(
                          painter: VerticalDividerPainter(
                            color: value.color,
                            thickness: value.thickness,
                            indent: value.indent,
                            endIndent: value.endIndent,
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: width ?? 1,
      height: double.infinity,
      child: AnimatedValueBuilder(
        value: DividerProperties(
          color: color ?? theme.colorScheme.border,
          thickness: thickness ?? 1,
          indent: indent ?? 0,
          endIndent: endIndent ?? 0,
        ),
        lerp: DividerProperties.lerp,
        duration: kDefaultDuration,
        builder: (context, value, child) {
          return CustomPaint(
            painter: VerticalDividerPainter(
              color: value.color,
              thickness: value.thickness,
              indent: value.indent,
              endIndent: value.endIndent,
            ),
          );
        },
      ),
    );
  }
}
