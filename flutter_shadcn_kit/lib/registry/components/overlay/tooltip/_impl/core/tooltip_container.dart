// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tooltip.dart';

/// Styled container widget for tooltip content.
class TooltipContainer extends StatelessWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `surfaceOpacity` state/configuration for this implementation.
  final double? surfaceOpacity;

  /// Stores `surfaceBlur` state/configuration for this implementation.
  final double? surfaceBlur;

  /// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry? padding;

  /// Stores `backgroundColor` state/configuration for this implementation.
  final Color? backgroundColor;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Creates a `TooltipContainer` instance.
  const TooltipContainer({
    super.key,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    required this.child,
  });

  /// Executes `call` behavior for this component/composite.
  Widget call(BuildContext context) {
    return this;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<TooltipTheme>(context);
    Color resolvedColor = styleValue(
      widgetValue: backgroundColor,
      themeValue: compTheme?.backgroundColor,
      defaultValue: theme.colorScheme.primary,
    );

    /// Stores `resolvedOpacity` state/configuration for this implementation.
    var resolvedOpacity = surfaceOpacity ?? compTheme?.surfaceOpacity;

    /// Stores `resolvedBlur` state/configuration for this implementation.
    var resolvedBlur = surfaceBlur ?? compTheme?.surfaceBlur;
    if (resolvedOpacity != null) {
      resolvedColor = resolvedColor.scaleAlpha(resolvedOpacity);
    }
    final resolvedPadding =
        /// Creates a `styleValue` instance.
        styleValue(
          widgetValue: padding,
          themeValue: compTheme?.padding,
          defaultValue: EdgeInsets.symmetric(
            horizontal: theme.density.baseContentPadding * 0.75,
            vertical: theme.density.baseGap * 0.75,
          ),
        ).resolve(Directionality.of(context)) *
        scaling;
    final resolvedRadius = styleValue(
      widgetValue: borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: BorderRadius.circular(theme.radiusSm),
    );

    Widget container = Container(
      padding: resolvedPadding,
      decoration: BoxDecoration(
        color: resolvedColor,
        borderRadius: resolvedRadius,
      ),
      child: child.xSmall().primaryForeground(),
    );

    if (resolvedBlur != null && resolvedBlur > 0) {
      container = SurfaceBlur(
        surfaceBlur: resolvedBlur,
        borderRadius: resolvedRadius,
        child: container,
      );
    }

    return Padding(
      padding: EdgeInsets.all(theme.density.baseGap * scaling * 0.75),
      child: container,
    );
  }
}
