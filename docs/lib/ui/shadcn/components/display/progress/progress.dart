// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' hide Theme, LinearProgressIndicator;

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';
import '../linear_progress_indicator/linear_progress_indicator.dart';

part '_impl/themes/base/progress_theme.dart';

/// Normalized progress indicator that respects theme defaults.
class Progress extends StatelessWidget implements Styleable<ProgressTheme> {

  /// Styling for this widget alone, overriding the ancestor theme.
  @override
  final ProgressTheme? theme;

  /// Creates `Progress` for configuring or rendering progress.
  const Progress({
    super.key,
    this.progress,
    this.min = 0.0,
    this.max = 1.0,
    this.disableAnimation = false,
    this.color,
    this.backgroundColor,
    this.theme,
  }) : assert(
         progress == null || (progress >= min && progress <= max),
         'Progress must be between min and max',
       );

  /// Animation/progress setting used by progress transitions.
  final double? progress;

  /// Input parameter used by `Progress` during rendering and behavior handling.
  final double min;

  /// Input parameter used by `Progress` during rendering and behavior handling.
  final double max;

  /// Whether to disable smooth transitions on progress changes.
  ///
  /// Matches upstream `Progress.disableAnimation` (default `false`).
  final bool disableAnimation;

  /// Color value used by progress painting or state styling.
  final Color? color;

  /// Color value used by progress painting or state styling.
  final Color? backgroundColor;

  double? get normalizedValue {
    if (progress == null) return null;
    return (progress! - min) / (max - min);
  }

  /// Builds the widget tree for progress.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = this.theme ?? ComponentTheme.maybeOf<ProgressTheme>(context);
    return LinearProgressIndicator(
      value: normalizedValue,
      disableAnimation: disableAnimation,
      backgroundColor: styleValue(
        widgetValue: backgroundColor,
        themeValue: compTheme?.backgroundColor,
        defaultValue: null,
      ),
      color: styleValue(
        widgetValue: color,
        themeValue: compTheme?.color,
        defaultValue: null,
      ),
      minHeight: styleValue(
        widgetValue: null,
        themeValue: compTheme?.minHeight,
        defaultValue: 8.0 * theme.scaling,
      ),
      borderRadius: styleValue(
        widgetValue: null,
        themeValue: compTheme?.borderRadius,
        defaultValue: theme.borderRadiusSm,
      ),
    );
  }
}
