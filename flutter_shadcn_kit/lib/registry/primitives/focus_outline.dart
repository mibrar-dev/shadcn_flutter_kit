// Keyboard-focus outline: an animated ring drawn around a child.
//
// Ported from `shared/primitives/focus_outline.dart` + `_impl/**`.

import 'package:flutter/widgets.dart';

import '../foundation/color_extensions.dart';
import '../foundation/constants.dart';
import '../foundation/style_value.dart';
import '../theme/color_tokens.dart';
import '../theme/theme.dart';
import 'animated_value_builder.dart';

/// Alignment, radius and border of the [FocusOutline] ring.
class FocusOutlineTheme extends ComponentThemeData
    implements Mergeable<FocusOutlineTheme> {
  /// Extra distance between the child edge and the ring. Defaults to 3.
  final double? align;

  /// Corner radius of the ring.
  final BorderRadiusGeometry? borderRadius;

  /// Ring border. Defaults to a 3px `ring`-colored border at half alpha.
  final Border? border;

  /// Creates a [FocusOutlineTheme].
  const FocusOutlineTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.align,
    this.border,
    this.borderRadius,
  });

  /// Returns a copy with the given fields replaced.
  FocusOutlineTheme copyWith({
    ValueGetter<Border?>? border,
    ValueGetter<double?>? align,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
  }) {
    return FocusOutlineTheme(
      align: align == null ? this.align : align(),
      border: border == null ? this.border : border(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  FocusOutlineTheme merge(FocusOutlineTheme? fallback) {
    if (fallback == null) return this;
    return FocusOutlineTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      align: align ?? fallback.align,
      border: border ?? fallback.border,
      borderRadius: borderRadius ?? fallback.borderRadius,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FocusOutlineTheme &&
        other.align == align &&
        other.border == border &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(border, align, borderRadius);
}

/// Draws an animated focus ring around [child] while [focused] is true.
class FocusOutline extends StatelessWidget {
  /// The wrapped child.
  final Widget child;

  /// Whether the ring is shown.
  final bool focused;

  /// Corner radius of the ring. Defaults to the child's rectangular edge.
  final BorderRadiusGeometry? borderRadius;

  /// Extra distance between the child edge and the ring. Defaults to 3.
  final double? align;

  /// Ring border. Defaults to a 3px `ring`-colored border at half alpha.
  final Border? border;

  /// Ring shape. Defaults to [BoxShape.rectangle].
  final BoxShape? shape;

  /// Creates a [FocusOutline].
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
    if (borderRadius == null) return BorderRadius.zero;
    final resolved = borderRadius.resolve(textDirection);
    return BorderRadius.only(
      topLeft: resolved.topLeft + Radius.circular(align),
      topRight: resolved.topRight + Radius.circular(align),
      bottomLeft: resolved.bottomLeft + Radius.circular(align),
      bottomRight: resolved.bottomRight + Radius.circular(align),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    final componentTheme =
        resolveComponentStyle<FocusOutlineTheme, FocusOutlineTheme>(
          context,
          select: (t) => t,
          defaults: const FocusOutlineTheme(),
        );
    final double align = styleValue(
      defaultValue: 3.0,
      themeValue: componentTheme.align,
      widgetValue: this.align,
    );
    final BorderRadiusGeometry? resolvedRadius = styleValue(
      themeValue: componentTheme.borderRadius,
      widgetValue: borderRadius,
      defaultValue: null,
    );
    final double offset = -align;
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
                        color: theme.colors.ring.scaleAlpha(0.5),
                        width: 3.0,
                      ),
                      themeValue: componentTheme.border,
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
