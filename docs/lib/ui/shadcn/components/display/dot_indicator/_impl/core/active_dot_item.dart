// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../dot_indicator.dart';

/// Active indicator dot.
class ActiveDotItem extends StatelessWidget {
  /// Creates `ActiveDotItem` for configuring or rendering dot indicator.
  const ActiveDotItem({
    super.key,
    this.size,
    this.color,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
  });

  /// Layout/size setting that affects dot indicator rendering.
  final double? size;

  /// Color value used by dot indicator painting or state styling.
  final Color? color;

  /// Layout/size setting that affects dot indicator rendering.
  final double? borderRadius;

  /// Color value used by dot indicator painting or state styling.
  final Color? borderColor;

  /// Layout/size setting that affects dot indicator rendering.
  final double? borderWidth;

  /// Builds the widget tree for dot indicator.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<DotIndicatorTheme>(context);

    final scaling = theme.scaling;
    final resolvedSize = styleValue(
      widgetValue: size,
      themeValue: compTheme?.size,
      defaultValue: 12 * scaling,
    );
    final resolvedColor = styleValue(
      widgetValue: color,
      themeValue: compTheme?.activeColor,
      defaultValue: theme.colorScheme.primary,
    );
    final resolvedBorderRadius = styleValue(
      widgetValue: borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.radiusMd,
    );

    final resolvedBorderColor = borderColor;

    final resolvedBorderWidth = borderWidth;
    return Container(
      width: resolvedSize,
      height: resolvedSize,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: BorderRadius.circular(resolvedBorderRadius),
        border: resolvedBorderColor != null && resolvedBorderWidth != null
            ? Border.all(color: resolvedBorderColor, width: resolvedBorderWidth)
            : null,
      ),
    );
  }
}
