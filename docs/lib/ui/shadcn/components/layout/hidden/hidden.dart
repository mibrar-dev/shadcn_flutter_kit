// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/core/hidden_layout.dart';
part '_impl/themes/base/hidden_theme.dart';
part '_impl/core/_render_hidden_layout.dart';

/// Shows or hides a single child with optional animation along an axis.
class Hidden extends StatelessWidget {
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

  /// Whether the child should be hidden.
  final bool hidden;

  /// The child that's shown or hidden.
  final Widget child;

  /// Axis used for slide animations.
  final Axis? direction;

  /// Duration of the animation.
  final Duration? duration;

  /// Curve applied to the animation.
  final Curve? curve;

  /// Reverse the animation direction.
  final bool? reverse;

  /// Preserve cross-axis size when hidden.
  final bool? keepCrossAxisSize;

  /// Preserve main-axis size when hidden.
  final bool? keepMainAxisSize;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
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
            textDirection: Directionality.of(context),
            direction: directionValue,
            reverse: reverseValue,
            progress: value.clamp(0.0, 1.0),
            keepCrossAxisSize: keepCrossAxisSizeValue,
            keepMainAxisSize: keepMainAxisSizeValue,
            child: child,
          );
        },
      ),
    );
  }
}
