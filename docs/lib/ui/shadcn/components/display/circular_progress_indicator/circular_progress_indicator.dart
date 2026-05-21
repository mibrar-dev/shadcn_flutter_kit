// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' as mat;
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/themes/base/circular_progress_indicator_theme.dart';

/// Circular progress indicator with determinate/indeterminate modes and theming.
class CircularProgressIndicator extends StatelessWidget {
  /// Creates `CircularProgressIndicator` for configuring or rendering circular progress indicator.
  const CircularProgressIndicator({
    super.key,
    this.value,
    this.size,
    this.color,
    this.backgroundColor,
    this.strokeWidth,
    this.duration = kDefaultDuration,
    this.animated = true,
    this.onSurface = false,
  });

  /// Data consumed by `CircularProgressIndicator` to render circular progress indicator content.
  final double? value;

  /// Layout/size setting that affects circular progress indicator rendering.
  final double? size;

  /// Color value used by circular progress indicator painting or state styling.
  final Color? color;

  /// Color value used by circular progress indicator painting or state styling.
  final Color? backgroundColor;

  /// Layout/size setting that affects circular progress indicator rendering.
  final double? strokeWidth;

  /// Animation/progress setting used by circular progress indicator transitions.
  final Duration duration;

  /// Input parameter used by `CircularProgressIndicator` during rendering and behavior handling.
  final bool animated;

  /// Callback invoked by circular progress indicator when `onSurface` is triggered.
  final bool onSurface;

  /// Builds the widget tree for circular progress indicator.
  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<CircularProgressIndicatorTheme>(
      context,
    );

    final effectiveSize = styleValue(
      widgetValue: size,
      themeValue: compTheme?.size,
      defaultValue: (iconTheme.size ?? 24 * theme.scaling) - 8 * theme.scaling,
    );

    final effectiveColor = styleValue(
      widgetValue: color,
      themeValue: compTheme?.color,
      defaultValue: onSurface
          ? theme.colorScheme.background
          : theme.colorScheme.primary,
    );

    final effectiveBackgroundColor = styleValue(
      widgetValue: backgroundColor,
      themeValue: compTheme?.backgroundColor,
      defaultValue: effectiveColor.scaleAlpha(0.2),
    );

    final effectiveStrokeWidth = styleValue(
      widgetValue: strokeWidth,
      themeValue: compTheme?.strokeWidth,
      defaultValue: effectiveSize / 12,
    );

    /// Implements `buildIndicator` behavior for circular progress indicator.
    Widget buildIndicator(double? currentValue) {
      final progressIndicator = mat.CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        color: effectiveColor,
        backgroundColor: effectiveBackgroundColor,
        strokeWidth: effectiveStrokeWidth,
        value: currentValue,
      );

      return RepaintBoundary(
        child: SizedBox(
          width: effectiveSize,
          height: effectiveSize,
          child: progressIndicator,
        ),
      );
    }

    if (value == null || !animated) {
      return buildIndicator(value);
    }

    return AnimatedValueBuilder(
      value: value!,
      duration: duration,
      builder: (context, value, child) {
        return buildIndicator(value);
      },
    );
  }
}
