// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/util.dart';

part '_impl/utils/_linear_progress_indicator_painter.dart';

part '_impl/utils/linear_progress_indicator_painter.dart';
part '_impl/themes/base/linear_progress_indicator_theme.dart';

const int _kIndeterminateLinearDuration = 1800;

/// Smooth determinate/indeterminate linear progress component with sparks.
class LinearProgressIndicator extends StatelessWidget {
  static const Curve _line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve _line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve _line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve _line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  /// Creates `LinearProgressIndicator` for configuring or rendering linear progress indicator.
  const LinearProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.minHeight,
    this.color,
    this.borderRadius,
    this.showSparks,
    this.disableAnimation,
  });

  /// Data consumed by `LinearProgressIndicator` to render linear progress indicator content.
  final double? value;

  /// Color value used by linear progress indicator painting or state styling.
  final Color? backgroundColor;

  /// Layout/size setting that affects linear progress indicator rendering.
  final double? minHeight;

  /// Color value used by linear progress indicator painting or state styling.
  final Color? color;

  /// Layout/size setting that affects linear progress indicator rendering.
  final BorderRadiusGeometry? borderRadius;

  /// Input parameter used by `LinearProgressIndicator` during rendering and behavior handling.
  final bool? showSparks;

  /// Animation/progress setting used by linear progress indicator transitions.
  final bool? disableAnimation;

  /// Builds the widget tree for linear progress indicator.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final directionality = Directionality.of(context);
    final compTheme = ComponentTheme.maybeOf<LinearProgressIndicatorTheme>(
      context,
    );

    final colorValue = styleValue(
      widgetValue: color,
      themeValue: compTheme?.color,
      defaultValue: theme.colorScheme.primary,
    );
    final backgroundColorValue = styleValue(
      widgetValue: backgroundColor,
      themeValue: compTheme?.backgroundColor,
      defaultValue: colorValue.scaleAlpha(0.2),
    );
    final minHeightValue = styleValue(
      widgetValue: minHeight,
      themeValue: compTheme?.minHeight,
      defaultValue: theme.scaling * 2,
    );
    final borderRadiusValue = styleValue(
      widgetValue: borderRadius,
      themeValue: compTheme?.borderRadius,
      defaultValue: BorderRadius.zero,
    );
    final showSparksValue = styleValue(
      widgetValue: showSparks,
      themeValue: compTheme?.showSparks,
      defaultValue: false,
    );
    final disableAnimationValue = styleValue(
      widgetValue: disableAnimation,
      themeValue: compTheme?.disableAnimation,
      defaultValue: false,
    );

    Widget childWidget;
    if (value != null) {
      childWidget = AnimatedValueBuilder(
        value: _LinearProgressIndicatorProperties(
          start: 0,
          end: value!.clamp(0, 1),
          color: colorValue,
          backgroundColor: backgroundColorValue,
          showSparks: showSparksValue,
          sparksColor: colorValue,
          sparksRadius: theme.scaling * 16,
          textDirection: directionality,
        ),
        duration: disableAnimationValue ? Duration.zero : kDefaultDuration,
        lerp: _LinearProgressIndicatorProperties.lerp,
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          return CustomPaint(
            painter: _LinearProgressIndicatorPainter(
              start: 0,
              end: value.end,
              start2: value.start2,
              end2: value.end2,
              color: value.color,
              backgroundColor: value.backgroundColor,
              showSparks: value.showSparks,
              sparksColor: value.sparksColor,
              sparksRadius: value.sparksRadius,
              textDirection: value.textDirection,
            ),
          );
        },
      );
    } else {
      childWidget = RepeatedAnimationBuilder(
        start: 0,
        end: 1,
        duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
        builder: (context, value, child) {
          final start = _line1Tail.transform(value);
          final end = _line1Head.transform(value);
          final start2 = _line2Tail.transform(value);
          final end2 = _line2Head.transform(value);
          return AnimatedValueBuilder(
            duration: kDefaultDuration,
            lerp: _LinearProgressIndicatorProperties.lerp,
            value: _LinearProgressIndicatorProperties(
              start: start,
              end: end,
              start2: start2,
              end2: end2,
              color: colorValue,
              backgroundColor: backgroundColorValue,
              showSparks: showSparksValue,
              sparksColor: colorValue,
              sparksRadius: theme.scaling * 16,
              textDirection: directionality,
            ),
            builder: (context, prop, child) {
              return CustomPaint(
                painter: _LinearProgressIndicatorPainter(
                  start: start,
                  end: end,
                  start2: start2,
                  end2: end2,
                  color: prop.color,
                  backgroundColor: prop.backgroundColor,
                  showSparks: prop.showSparks,
                  sparksColor: prop.sparksColor,
                  sparksRadius: prop.sparksRadius,
                  textDirection: prop.textDirection,
                ),
              );
            },
          );
        },
      );
    }

    return RepaintBoundary(
      child: SizedBox(
        height: minHeightValue,
        child: ClipRRect(borderRadius: borderRadiusValue, child: childWidget),
      ),
    );
  }
}
