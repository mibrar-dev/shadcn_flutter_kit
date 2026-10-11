// `Hidden`: collapses its child with an animation while keeping the layout
// extent configurable.
//
// Ported from `shared/primitives/hidden.dart` + `_impl/**`.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../foundation/constants.dart';
import '../foundation/style_value.dart';
import '../theme/color_tokens.dart';
import '../theme/theme.dart';
import 'animated_value_builder.dart';

/// Direction, duration, curve and size-keeping flags of [Hidden].
class HiddenTheme extends ComponentThemeData implements Mergeable<HiddenTheme> {
  /// Collapse direction. Defaults to [Axis.horizontal].
  final Axis? direction;

  /// Animation duration. Defaults to `kDefaultDuration`.
  final Duration? duration;

  /// Animation curve. Defaults to [Curves.easeInOut].
  final Curve? curve;

  /// Whether the collapse animation runs in reverse.
  final bool? reverse;

  /// Whether the cross-axis size is kept while hidden.
  final bool? keepCrossAxisSize;

  /// Whether the main-axis size is kept while hidden.
  final bool? keepMainAxisSize;

  /// Creates a [HiddenTheme].
  const HiddenTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.duration,
    this.curve,
    this.reverse,
    this.keepCrossAxisSize,
    this.keepMainAxisSize,
  });

  /// Returns a copy with the given fields replaced.
  HiddenTheme copyWith({
    ValueGetter<Axis?>? direction,
    ValueGetter<Duration?>? duration,
    ValueGetter<Curve?>? curve,
    ValueGetter<bool?>? reverse,
    ValueGetter<bool?>? keepCrossAxisSize,
    ValueGetter<bool?>? keepMainAxisSize,
  }) {
    return HiddenTheme(
      direction: direction == null ? this.direction : direction(),
      duration: duration == null ? this.duration : duration(),
      curve: curve == null ? this.curve : curve(),
      reverse: reverse == null ? this.reverse : reverse(),
      keepCrossAxisSize: keepCrossAxisSize == null
          ? this.keepCrossAxisSize
          : keepCrossAxisSize(),
      keepMainAxisSize: keepMainAxisSize == null
          ? this.keepMainAxisSize
          : keepMainAxisSize(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  HiddenTheme merge(HiddenTheme? fallback) {
    if (fallback == null) return this;
    return HiddenTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      direction: direction ?? fallback.direction,
      duration: duration ?? fallback.duration,
      curve: curve ?? fallback.curve,
      reverse: reverse ?? fallback.reverse,
      keepCrossAxisSize: keepCrossAxisSize ?? fallback.keepCrossAxisSize,
      keepMainAxisSize: keepMainAxisSize ?? fallback.keepMainAxisSize,
    );
  }
}

/// Collapses [child] with a fade + size animation while [hidden] is true.
class Hidden extends StatelessWidget {
  /// Whether the child is hidden.
  final bool hidden;

  /// The child.
  final Widget child;

  /// Collapse direction. Defaults to [Axis.horizontal].
  final Axis? direction;

  /// Whether the collapse animation runs in reverse.
  final bool? reverse;

  /// Animation duration. Defaults to `kDefaultDuration`.
  final Duration? duration;

  /// Animation curve. Defaults to [Curves.easeInOut].
  final Curve? curve;

  /// Whether the cross-axis size is kept while hidden.
  final bool? keepCrossAxisSize;

  /// Whether the main-axis size is kept while hidden.
  final bool? keepMainAxisSize;

  /// Creates a [Hidden] widget.
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
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final componentTheme = resolveComponentStyle<HiddenTheme, HiddenTheme>(
      context,
      select: (t) => t,
      defaults: const HiddenTheme(),
    );
    final directionValue = styleValue(
      widgetValue: direction,
      themeValue: componentTheme.direction,
      defaultValue: Axis.horizontal,
    );
    final durationValue = styleValue(
      widgetValue: duration,
      themeValue: componentTheme.duration,
      defaultValue: kDefaultDuration,
    );
    final curveValue = styleValue(
      widgetValue: curve,
      themeValue: componentTheme.curve,
      defaultValue: Curves.easeInOut,
    );
    final reverseValue = styleValue(
      widgetValue: reverse,
      themeValue: componentTheme.reverse,
      defaultValue: false,
    );
    final keepCrossAxisSizeValue = styleValue(
      widgetValue: keepCrossAxisSize,
      themeValue: componentTheme.keepCrossAxisSize,
      defaultValue: false,
    );
    final keepMainAxisSizeValue = styleValue(
      widgetValue: keepMainAxisSize,
      themeValue: componentTheme.keepMainAxisSize,
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

class _HiddenLayout extends SingleChildRenderObjectWidget {
  final bool keepCrossAxisSize;
  final bool keepMainAxisSize;
  final TextDirection textDirection;
  final Axis direction;
  final bool reverse;
  final double progress;

  const _HiddenLayout({
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
    required this.textDirection,
    required this.direction,
    required this.reverse,
    required this.progress,
    super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _HiddenLayoutRender(
      keepCrossAxisSize: keepCrossAxisSize,
      keepMainAxisSize: keepMainAxisSize,
      textDirection: textDirection,
      direction: direction,
      reverse: reverse,
      progress: progress,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _HiddenLayoutRender renderObject,
  ) {
    // The shared fork never relaid out on progress changes; the component
    // fork (the ownership winner) marks layout, which is required for the
    // collapse animation to be visible.
    var needsLayout = false;
    if (renderObject.keepCrossAxisSize != keepCrossAxisSize) {
      renderObject.keepCrossAxisSize = keepCrossAxisSize;
      needsLayout = true;
    }
    if (renderObject.keepMainAxisSize != keepMainAxisSize) {
      renderObject.keepMainAxisSize = keepMainAxisSize;
      needsLayout = true;
    }
    if (renderObject.textDirection != textDirection) {
      renderObject.textDirection = textDirection;
      needsLayout = true;
    }
    if (renderObject.direction != direction) {
      renderObject.direction = direction;
      needsLayout = true;
    }
    if (renderObject.reverse != reverse) {
      renderObject.reverse = reverse;
      needsLayout = true;
    }
    if (renderObject.progress != progress) {
      renderObject.progress = progress;
      needsLayout = true;
    }
    if (needsLayout) {
      renderObject.markNeedsLayout();
    }
  }
}

class _HiddenLayoutRender extends RenderShiftedBox {
  bool keepCrossAxisSize;
  bool keepMainAxisSize;
  TextDirection textDirection;
  Axis direction;
  bool reverse;
  double progress;

  _HiddenLayoutRender({
    required this.keepCrossAxisSize,
    required this.keepMainAxisSize,
    required this.textDirection,
    required this.direction,
    required this.reverse,
    required this.progress,
    RenderBox? child,
  }) : super(child);

  @override
  void performLayout() {
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child!.layout(constraints, parentUsesSize: true);
    final childSize = child!.size;
    final mainAxisSize = direction == Axis.horizontal
        ? childSize.width
        : childSize.height;
    final crossAxisSize = direction == Axis.horizontal
        ? childSize.height
        : childSize.width;
    final mainAxisProgress = keepMainAxisSize ? 1.0 : progress;
    final crossAxisProgress = keepCrossAxisSize ? 1.0 : progress;
    final constrainedMainAxis = mainAxisSize * mainAxisProgress;
    final constrainedCrossAxis = crossAxisSize * crossAxisProgress;
    final width = direction == Axis.horizontal
        ? constrainedMainAxis
        : constrainedCrossAxis;
    final height = direction == Axis.horizontal
        ? constrainedCrossAxis
        : constrainedMainAxis;
    size = constraints.constrain(Size(width, height));
    final alignment = direction == Axis.horizontal
        ? (textDirection == TextDirection.ltr
              ? Alignment.centerLeft
              : Alignment.centerRight)
        : Alignment.topCenter;
    final offset = alignment.alongOffset(
      Offset(size.width - childSize.width, size.height - childSize.height),
    );
    final shift = reverse
        ? Offset(-offset.dx, -offset.dy)
        : Offset(offset.dx, offset.dy);
    (child!.parentData as BoxParentData).offset = shift;
  }
}
