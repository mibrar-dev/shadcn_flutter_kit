// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../focus_outline.dart';

/// FocusOutline defines a reusable type for this registry module.
class FocusOutline extends StatelessWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `focused` state/configuration for this implementation.
  final bool focused;

  /// Stores `borderRadius` state/configuration for this implementation.
  final BorderRadiusGeometry? borderRadius;

  /// Stores `align` state/configuration for this implementation.
  final double? align;

  /// Stores `border` state/configuration for this implementation.
  final Border? border;

  /// Stores `shape` state/configuration for this implementation.
  final BoxShape? shape;

  /// Creates a `FocusOutline` instance.
  const FocusOutline({
    super.key,
    required this.child,
    required this.focused,
    this.borderRadius,
    this.align,
    this.border,
    this.shape,
  });

  BorderRadius _getAdjustedBorderRadius(
    TextDirection textDirection,
    double align,
    BorderRadiusGeometry? borderRadius,
  ) {
    /// Stores `rawRadius` state/configuration for this implementation.
    final rawRadius = borderRadius;
    if (rawRadius == null) return BorderRadius.zero;
    final resolved = rawRadius.resolve(textDirection);
    return BorderRadius.only(
      topLeft: resolved.topLeft + Radius.circular(align),
      topRight: resolved.topRight + Radius.circular(align),
      bottomLeft: resolved.bottomLeft + Radius.circular(align),
      bottomRight: resolved.bottomRight + Radius.circular(align),
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<FocusOutlineTheme>(context);
    final double align = styleValue(
      defaultValue: 3.0,
      themeValue: compTheme?.align,
      widgetValue: this.align,
    );
    final BorderRadiusGeometry? resolvedRadius = styleValue(
      themeValue: compTheme?.borderRadius,
      widgetValue: borderRadius,
      defaultValue: null,
    );

    /// Stores `offset` state/configuration for this implementation.
    final double offset = -align;
    final textDirection = Directionality.of(context);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        child,

        /// Creates a `AnimatedValueBuilder` instance.
        AnimatedValueBuilder(
          value: focused ? 1.0 : 0.0,
          duration: kDefaultDuration,
          builder: (context, value, child) {
            return Positioned(
              top: offset * value,
              right: offset * value,
              bottom: offset * value,
              left: offset * value,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: shape != BoxShape.circle
                        ? _getAdjustedBorderRadius(
                            textDirection,
                            align,
                            resolvedRadius,
                          )
                        : null,
                    shape: shape ?? BoxShape.rectangle,
                    border: styleValue(
                      defaultValue: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.ring.scaleAlpha(0.5),
                        width: 3.0,
                      ),
                      themeValue: compTheme?.border,
                      widgetValue: border,
                    ).scale(value),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
