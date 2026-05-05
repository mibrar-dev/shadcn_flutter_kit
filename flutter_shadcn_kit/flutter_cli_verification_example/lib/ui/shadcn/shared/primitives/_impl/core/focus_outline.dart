part of '../../focus_outline.dart';

class FocusOutline extends StatelessWidget {
  final Widget child;
  final bool focused;
  final BorderRadiusGeometry? borderRadius;
  final double? align;
  final Border? border;
  final BoxShape? shape;

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
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<FocusOutlineTheme>(context);
    final align = styleValue(
      defaultValue: 3.0,
      themeValue: compTheme?.align,
      widgetValue: this.align,
    );
    final resolvedRadius = styleValue(
      themeValue: compTheme?.borderRadius,
      widgetValue: borderRadius,
      defaultValue: null,
    );
    final offset = -align;
    final textDirection = Directionality.of(context);
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        child,
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
                        color: Theme.of(context)
                            .colorScheme
                            .ring
                            .scaleAlpha(0.5),
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
