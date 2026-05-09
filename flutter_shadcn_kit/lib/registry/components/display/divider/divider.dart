// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/axis.dart';
import '../../../shared/utils/util.dart';

part '_impl/utils/divider_painter.dart';
part '_impl/utils/vertical_divider_painter.dart';
part '_impl/core/vertical_divider.dart';

part '_impl/themes/base/divider_theme.dart';
part '_impl/utils/divider_painters.dart';

/// Horizontal line separating content with optional label.
class Divider extends StatelessWidget implements PreferredSizeWidget {
  /// Creates `Divider` for configuring or rendering divider.
  const Divider({
    super.key,
    this.color,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.child,
    this.padding,
    this.childAlignment,
  });

  /// Color value used by divider painting or state styling.
  final Color? color;

  /// Layout/size setting that affects divider rendering.
  final double? height;

  /// Input parameter used by `Divider` during rendering and behavior handling.
  final double? thickness;

  /// Input parameter used by `Divider` during rendering and behavior handling.
  final double? indent;

  /// Input parameter used by `Divider` during rendering and behavior handling.
  final double? endIndent;

  /// Child content displayed inside the divider widget.
  final Widget? child;

  /// Layout/size setting that affects divider rendering.
  final EdgeInsetsGeometry? padding;

  /// Child content displayed inside the divider widget.
  final AxisAlignmentGeometry? childAlignment;

  @override
  Size get preferredSize => Size(0, height ?? 1);

  /// Builds the widget tree for divider.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final componentTheme = ComponentTheme.maybeOf<DividerTheme>(context);
    final textDirection = Directionality.maybeOf(context) ?? TextDirection.ltr;
    final resolvedColor = styleValue(
      widgetValue: color,
      themeValue: componentTheme?.color,
      defaultValue: theme.colorScheme.border,
    );

    final densityGap = theme.density.baseGap * theme.scaling;
    final resolvedThickness = styleValue(
      widgetValue: thickness,
      themeValue: componentTheme?.thickness,
      defaultValue: 1.0,
    );
    final resolvedHeight = styleValue(
      widgetValue: height,
      themeValue: componentTheme?.height,
      defaultValue: resolvedThickness,
    );
    final resolvedIndent = styleValue(
      widgetValue: indent,
      themeValue: componentTheme?.indent,
      defaultValue: 0.0,
    );
    final resolvedEndIndent = styleValue(
      widgetValue: endIndent,
      themeValue: componentTheme?.endIndent,
      defaultValue: 0.0,
    );
    final resolvedPadding = styleValue(
      widgetValue: padding,
      themeValue: componentTheme?.padding,
      defaultValue: EdgeInsets.symmetric(horizontal: densityGap),
    );
    final resolvedChildAlignment = styleValue(
      widgetValue: childAlignment,
      themeValue: componentTheme?.childAlignment,
      defaultValue: AxisAlignment.center,
    ).resolve(textDirection);

    if (child != null) {
      final clampedAlignmentValue = resolvedChildAlignment.value.clamp(
        -1.0,
        1.0,
      );
      final leftRatio = (clampedAlignmentValue + 1) / 2;

      final rightRatio = 1 - leftRatio;
      final leftFlex = (leftRatio * 1000).round();
      final rightFlex = (rightRatio * 1000).round();

      return SizedBox(
        width: double.infinity,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leftFlex > 0)
                Expanded(
                  flex: leftFlex,
                  child: SizedBox(
                    height: resolvedHeight,
                    child: AnimatedValueBuilder(
                      value: DividerProperties(
                        color: resolvedColor,
                        thickness: resolvedThickness,
                        indent: resolvedIndent,
                        endIndent: 0,
                      ),
                      duration: kDefaultDuration,
                      lerp: DividerProperties.lerp,
                      builder: (context, value, child) {
                        return CustomPaint(
                          painter: DividerPainter(
                            color: value.color,
                            thickness: value.thickness,
                            indent: value.indent,
                            endIndent: value.endIndent,
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              child!.muted().small().withPadding(padding: resolvedPadding),
              if (rightFlex > 0)
                Expanded(
                  flex: rightFlex,
                  child: SizedBox(
                    height: resolvedHeight,
                    child: AnimatedValueBuilder(
                      value: DividerProperties(
                        color: resolvedColor,
                        thickness: resolvedThickness,
                        indent: 0,
                        endIndent: resolvedEndIndent,
                      ),
                      duration: kDefaultDuration,
                      lerp: DividerProperties.lerp,
                      builder: (context, value, child) {
                        return CustomPaint(
                          painter: DividerPainter(
                            color: value.color,
                            thickness: value.thickness,
                            indent: value.indent,
                            endIndent: value.endIndent,
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: resolvedHeight,
      width: double.infinity,
      child: AnimatedValueBuilder(
        value: DividerProperties(
          color: resolvedColor,
          thickness: resolvedThickness,
          indent: resolvedIndent,
          endIndent: resolvedEndIndent,
        ),
        lerp: DividerProperties.lerp,
        duration: kDefaultDuration,
        builder: (context, value, child) {
          return CustomPaint(
            painter: DividerPainter(
              color: value.color,
              thickness: value.thickness,
              indent: value.indent,
              endIndent: value.endIndent,
            ),
          );
        },
      ),
    );
  }
}
