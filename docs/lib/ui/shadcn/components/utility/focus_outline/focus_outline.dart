// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme;

import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/themes/base/focus_outline_theme.dart';

/// Draws a subtle outline around a focused widget.
class FocusOutline extends StatelessWidget {
  /// Creates a focus outline.
  const FocusOutline({
    super.key,
    required this.child,
    required this.focused,
    this.borderRadius,
    this.align,
    this.border,
    this.shape,
  });

  /// The wrapped child.
  final Widget child;

  /// Whether the focus outline is visible.
  final bool focused;

  /// Custom border radius.
  final BorderRadiusGeometry? borderRadius;

  /// Custom alignment offset.
  final double? align;

  /// Custom border style.
  final Border? border;

  /// Custom shape (rectangle or circle).
  final BoxShape? shape;

  BorderRadius _getAdjustedBorderRadius(
    TextDirection textDirection,
    double align,
    BorderRadiusGeometry? borderRadius,
  ) {
    /// Stores `rawRadius` state/configuration for this implementation.
    final rawRadius = borderRadius;
    if (rawRadius == null) return BorderRadius.zero;
    final resolved = rawRadius.resolve(textDirection);
    final offset = Radius.circular(align);
    return BorderRadius.only(
      topLeft: resolved.topLeft + offset,
      topRight: resolved.topRight + offset,
      bottomLeft: resolved.bottomLeft + offset,
      bottomRight: resolved.bottomRight + offset,
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<FocusOutlineTheme>(context);
    final theme = Theme.of(context);
    final effectiveAlign = styleValue(
      defaultValue: 3.0,
      themeValue: compTheme?.align,
      widgetValue: align,
    );
    final effectiveRadius = styleValue(
      themeValue: compTheme?.borderRadius,
      widgetValue: borderRadius,
      defaultValue: null,
    );

    /// Stores `ringColor` state/configuration for this implementation.
    final ringColor = theme.colorScheme.ring;
    final halfAlpha = ((ringColor.a * 255 * 0.5).round()).clamp(0, 255);
    final visibleRingColor = ringColor.withAlpha(halfAlpha);
    final effectiveBorder = styleValue(
      defaultValue: Border.all(color: visibleRingColor, width: 3.0),
      themeValue: compTheme?.border,
      widgetValue: border,
    );

    /// Stores `offset` state/configuration for this implementation.
    final offset = -effectiveAlign;
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
                    border: effectiveBorder.scale(value),
                    shape: shape ?? BoxShape.rectangle,
                    borderRadius: shape != BoxShape.circle
                        ? _getAdjustedBorderRadius(
                            textDirection,
                            effectiveAlign,
                            effectiveRadius,
                          )
                        : null,
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
