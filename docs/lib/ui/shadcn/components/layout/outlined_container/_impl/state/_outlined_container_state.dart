// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../outlined_container.dart';

/// _OutlinedContainerState defines a reusable type for this registry module.
class _OutlinedContainerState extends State<OutlinedContainer> {
  final GlobalKey _mainKey = GlobalKey();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<OutlinedContainerTheme>(context);
    final borderRadius = styleValue<BorderRadiusGeometry>(
      widgetValue: widget.borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: theme.borderRadiusXl,
    );
    final backgroundColor = styleValue<Color>(
      widgetValue: widget.backgroundColor,
      themeValue: compTheme?.backgroundColor,
      defaultValue: theme.colorScheme.background,
    );
    final resolvedBorderRadius = borderRadius.resolve(
      /// Creates a `Directionality.of` instance.
      Directionality.of(context),
    );
    final surfaceOpacity = styleValue<double?>(
      widgetValue: widget.surfaceOpacity,
      themeValue: compTheme?.surfaceOpacity,
      defaultValue: null,
    );
    final baseBackgroundColor = surfaceOpacity != null
        ? backgroundColor.withValues(
            alpha: ((backgroundColor.a / 255.0) * surfaceOpacity).clamp(
              0.0,
              1.0,
            ),
          )
        : backgroundColor;
    final borderColor = styleValue<Color>(
      widgetValue: widget.borderColor,
      themeValue: compTheme?.borderColor,
      defaultValue: theme.colorScheme.muted,
    );
    final borderWidth = styleValue<double>(
      widgetValue: widget.borderWidth,
      themeValue: compTheme?.borderWidth,
      defaultValue: 1.0 * theme.scaling,
    );
    final borderStyle = styleValue<BorderStyle>(
      widgetValue: widget.borderStyle,
      themeValue: compTheme?.borderStyle,
      defaultValue: BorderStyle.solid,
    );
    final boxShadow = styleValue<List<BoxShadow>>(
      widgetValue: widget.boxShadow,
      themeValue: compTheme?.boxShadow,
      defaultValue: [],
    );
    final padding = styleValue<EdgeInsetsGeometry>(
      widgetValue: widget.padding,
      themeValue: compTheme?.padding,
      defaultValue: EdgeInsets.zero,
    );
    final surfaceBlur = styleValue<double?>(
      widgetValue: widget.surfaceBlur,
      themeValue: compTheme?.surfaceBlur,
      defaultValue: null,
    );

    Widget current = AnimatedContainer(
      duration: widget.duration ?? Duration.zero,
      key: _mainKey,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: baseBackgroundColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
          style: borderStyle,
        ),
        borderRadius: resolvedBorderRadius,
        boxShadow: boxShadow,
      ),
      child: AnimatedContainer(
        duration: widget.duration ?? Duration.zero,
        decoration: widget.clipBehavior == Clip.none
            ? null
            : const BoxDecoration(),
        clipBehavior: widget.clipBehavior,
        padding: padding,
        child: widget.child,
      ),
    );

    if (surfaceBlur != null && surfaceBlur > 0) {
      current = SurfaceBlur(
        surfaceBlur: surfaceBlur,
        borderRadius: subtractByBorder(resolvedBorderRadius, borderWidth),
        child: current,
      );
    }

    return current;
  }
}
