// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/material.dart' show VerticalDivider;
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../shared/theme/theme.dart';
import '../../../shared/utils/util.dart';
import '../../display/text/text.dart';
part '_impl/core/step_item.dart';
part '_impl/core/steps_2.dart';

/// Theme for [Steps].
class StepsTheme extends ComponentThemeData {
  /// Diameter of the step indicator circle.
  final double? indicatorSize;

  /// Gap between the indicator and the step content.
  final double? spacing;

  /// Color of the indicator and connector line.
  final Color? indicatorColor;

  /// Thickness of the connector line.
  final double? connectorThickness;

  /// Creates a [StepsTheme].
  const StepsTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.indicatorSize,
    this.spacing,
    this.indicatorColor,
    this.connectorThickness,
  });

  /// Creates a copy of this theme with the given fields replaced.
  StepsTheme copyWith({
    ValueGetter<double?>? indicatorSize,
    ValueGetter<double?>? spacing,
    ValueGetter<Color?>? indicatorColor,
    ValueGetter<double?>? connectorThickness,
  }) {
    return StepsTheme(
      indicatorSize: indicatorSize == null
          ? this.indicatorSize
          : indicatorSize(),
      spacing: spacing == null ? this.spacing : spacing(),
      indicatorColor: indicatorColor == null
          ? this.indicatorColor
          : indicatorColor(),
      connectorThickness: connectorThickness == null
          ? this.connectorThickness
          : connectorThickness(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StepsTheme &&
        other.indicatorSize == indicatorSize &&
        other.spacing == spacing &&
        other.indicatorColor == indicatorColor &&
        other.connectorThickness == connectorThickness;
  }

  @override
  int get hashCode =>
      Object.hash(indicatorSize, spacing, indicatorColor, connectorThickness);
}

/// Vertical step progression widget with numbered indicators and connectors.
///
/// A layout widget that displays a vertical sequence of steps, each with a
/// numbered circular indicator connected by lines. Ideal for showing progress
/// through multi-step processes, tutorials, or workflows.
///
/// ## Features
///
/// - **Numbered indicators**: Circular indicators with automatic step numbering
/// - **Connector lines**: Visual lines connecting consecutive steps
/// - **Flexible content**: Each step can contain any widget content
/// - **Responsive theming**: Customizable indicator size, spacing, and colors
/// - **Intrinsic sizing**: Automatically adjusts to content height
///
/// The widget automatically numbers each step starting from 1 and connects
/// them with vertical lines. Each step's content is placed to the right of
/// its indicator.
///
/// Example:
/// ```dart
/// Steps(
///   children: [
///     Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: [
///         Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
///         Text('Sign up with your email address'),
///       ],
///     ),
///     Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: [
///         Text('Verify Email', style: TextStyle(fontWeight: FontWeight.bold)),
///         Text('Check your inbox for verification'),
///       ],
///     ),
///     Column(
///       crossAxisAlignment: CrossAxisAlignment.start,
///       children: [
///         Text('Complete Profile', style: TextStyle(fontWeight: FontWeight.bold)),
///         Text('Add your personal information'),
///       ],
///     ),
///   ],
/// );
/// ```

/// A vertical step indicator widget that displays a step's title and content.
///
/// Typically used as children within [Steps] to create a multi-step
/// process visualization. Displays a title in bold followed by content items.
///
/// Example:
/// ```dart
/// StepItem(
///   title: Text('Step Title'),
///   content: [
///     Text('Step description'),
///     Text('Additional details'),
///   ],
/// )
/// ```
