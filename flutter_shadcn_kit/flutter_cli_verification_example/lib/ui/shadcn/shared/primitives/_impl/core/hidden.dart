part of '../../hidden.dart';

/// Hidden defines a reusable type for this registry module.
class Hidden extends StatelessWidget {
/// Stores `hidden` state/configuration for this implementation.
  final bool hidden;
/// Stores `child` state/configuration for this implementation.
  final Widget child;
/// Stores `direction` state/configuration for this implementation.
  final Axis? direction;
/// Stores `reverse` state/configuration for this implementation.
  final bool? reverse;
/// Stores `duration` state/configuration for this implementation.
  final Duration? duration;
/// Stores `curve` state/configuration for this implementation.
  final Curve? curve;
/// Stores `keepCrossAxisSize` state/configuration for this implementation.
  final bool? keepCrossAxisSize;
/// Stores `keepMainAxisSize` state/configuration for this implementation.
  final bool? keepMainAxisSize;

/// Creates a `Hidden` instance.
  const Hidden({
    super.key,
    required this.hidden,
    required this.child,
    this.direction,
    this.duration,
    this.curve,
    this.reverse,
    this.keepCrossAxisSize,
    this.keepMainAxisSize,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final compTheme = ComponentTheme.maybeOf<HiddenTheme>(context);
    final directionValue = styleValue(
      widgetValue: direction,
      themeValue: compTheme?.direction,
      defaultValue: Axis.horizontal,
    );
    final durationValue = styleValue(
      widgetValue: duration,
      themeValue: compTheme?.duration,
      defaultValue: kDefaultDuration,
    );
    final curveValue = styleValue(
      widgetValue: curve,
      themeValue: compTheme?.curve,
      defaultValue: Curves.easeInOut,
    );
    final reverseValue = styleValue(
      widgetValue: reverse,
      themeValue: compTheme?.reverse,
      defaultValue: false,
    );
    final keepCrossAxisSizeValue = styleValue(
      widgetValue: keepCrossAxisSize,
      themeValue: compTheme?.keepCrossAxisSize,
      defaultValue: false,
    );
    final keepMainAxisSizeValue = styleValue(
      widgetValue: keepMainAxisSize,
      themeValue: compTheme?.keepMainAxisSize,
      defaultValue: false,
    );
    return AnimatedOpacity(
      opacity: hidden ? 0.0 : 1.0,
      duration: durationValue,
      curve: curveValue,
      child: AnimatedValueBuilder(
        value: hidden ? 0.0 : 1.0,
        duration: durationValue,
        curve: curveValue,
        child: child,
        builder: (context, value, child) {
          return _HiddenLayout(
            keepCrossAxisSize: keepCrossAxisSizeValue,
            keepMainAxisSize: keepMainAxisSizeValue,
            textDirection: textDirection,
            direction: directionValue,
            reverse: reverseValue,
            progress: value.clamp(0.0, 1.0),
            child: child,
          );
        },
      ),
    );
  }
}
