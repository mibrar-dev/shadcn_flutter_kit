part of '../../outlined_container.dart';


/// _OutlinedContainerState defines a reusable type for this registry module.
class _OutlinedContainerState extends State<OutlinedContainer> {
  final GlobalKey _mainContainerKey = GlobalKey();

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
/// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<OutlinedContainerTheme>(context);
    final borderRadius = styleValue(
      defaultValue: theme.borderRadiusXl,
      themeValue: compTheme?.borderRadius,
      widgetValue: widget.borderRadius,
    ).resolve(Directionality.of(context));
    var backgroundColor = styleValue(
      defaultValue: theme.colorScheme.background,
      themeValue: compTheme?.backgroundColor,
      widgetValue: widget.backgroundColor,
    );
    final double? surfaceOpacity = styleValue(
      themeValue: compTheme?.surfaceOpacity,
      widgetValue: widget.surfaceOpacity,
      defaultValue: null,
    );
    if (surfaceOpacity != null) {
      backgroundColor = backgroundColor.scaleAlpha(surfaceOpacity);
    }
    final borderColor = styleValue(
      defaultValue: theme.colorScheme.muted,
      themeValue: compTheme?.borderColor,
      widgetValue: widget.borderColor,
    );
    final borderWidth = styleValue(
      defaultValue: 1 * scaling,
      themeValue: compTheme?.borderWidth,
      widgetValue: widget.borderWidth,
    );
    final borderStyle = styleValue<BorderStyle>(
      defaultValue: BorderStyle.solid,
      themeValue: compTheme?.borderStyle,
      widgetValue: widget.borderStyle,
    );
    final boxShadow = styleValue<List<BoxShadow>>(
      themeValue: compTheme?.boxShadow,
      widgetValue: widget.boxShadow,
      defaultValue: [],
    );
    final padding = styleValue<EdgeInsetsGeometry>(
      themeValue: compTheme?.padding,
      widgetValue: widget.padding,
      defaultValue: EdgeInsets.zero,
    );
    final surfaceBlur = styleValue<double?>(
      themeValue: compTheme?.surfaceBlur,
      widgetValue: widget.surfaceBlur,
      defaultValue: null,
    );
    Widget childWidget = AnimatedContainer(
      duration: widget.duration ?? Duration.zero,
      key: _mainContainerKey,
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
          style: borderStyle,
        ),
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: AnimatedContainer(
        duration: widget.duration ?? Duration.zero,
        padding: padding,
        clipBehavior: widget.clipBehavior,
        decoration: BoxDecoration(
          borderRadius: subtractByBorder(borderRadius, borderWidth),
        ),
        child: widget.child,
      ),
    );
    if (surfaceBlur != null && surfaceBlur > 0) {
      childWidget = SurfaceBlur(
        surfaceBlur: surfaceBlur,
        borderRadius: subtractByBorder(borderRadius, borderWidth),
        child: childWidget,
      );
    }
    return childWidget;
  }
}
