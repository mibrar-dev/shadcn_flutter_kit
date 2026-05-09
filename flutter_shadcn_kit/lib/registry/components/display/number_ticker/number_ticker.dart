// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/style_value.dart';

part '_impl/themes/base/number_ticker_theme.dart';

/// Builder signature for custom ticker content.
typedef NumberTickerBuilder =
    Widget Function(BuildContext context, double value, Widget? child);

/// Formatter signature for textual tickers.
typedef NumberTickerFormatted = String Function(double value);

/// Smooth number animation component with text or custom builder variants.
class NumberTicker extends StatelessWidget {
  /// Creates `NumberTicker.builder` for configuring or rendering number ticker.
  const NumberTicker.builder({
    super.key,
    this.initialNumber,
    required this.number,
    required this.builder,
    this.child,
    this.duration,
    this.curve,
  }) : formatter = null,
       style = null;

  /// Creates `NumberTicker` for configuring or rendering number ticker.
  const NumberTicker({
    super.key,
    this.initialNumber,
    required this.number,
    required this.formatter,
    this.duration,
    this.curve,
    this.style,
  }) : builder = null,
       child = null;

  /// Input parameter used by `NumberTicker` during rendering and behavior handling.
  final num? initialNumber;

  /// Input parameter used by `NumberTicker` during rendering and behavior handling.
  final num number;

  /// Input parameter used by `NumberTicker` during rendering and behavior handling.
  final NumberTickerBuilder? builder;

  /// Child content displayed inside the number ticker widget.
  final Widget? child;

  /// Input parameter used by `NumberTicker` during rendering and behavior handling.
  final NumberTickerFormatted? formatter;

  /// Animation/progress setting used by number ticker transitions.
  final Duration? duration;

  /// Animation/progress setting used by number ticker transitions.
  final Curve? curve;

  /// Style/theme override that customizes `NumberTicker` appearance.
  final TextStyle? style;

  /// Builds the widget tree for number ticker.
  @override
  Widget build(BuildContext context) {
    final compTheme = ComponentTheme.maybeOf<NumberTickerTheme>(context);
    final resolvedDuration = styleValue(
      widgetValue: duration,
      themeValue: compTheme?.duration,
      defaultValue: const Duration(milliseconds: 500),
    );
    final resolvedCurve = styleValue(
      widgetValue: curve,
      themeValue: compTheme?.curve,
      defaultValue: Curves.easeInOut,
    );
    final initial = initialNumber?.toDouble();
    if (formatter != null) {
      final resolvedStyle = styleValue(
        widgetValue: style,
        themeValue: compTheme?.style,
        defaultValue: null,
      );
      return AnimatedValueBuilder(
        value: number.toDouble(),
        duration: resolvedDuration,
        curve: resolvedCurve,
        initialValue: initial,
        builder: (context, value, child) {
          return Text(formatter!(value), style: resolvedStyle);
        },
      );
    }
    return AnimatedValueBuilder(
      value: number.toDouble(),
      duration: resolvedDuration,
      curve: resolvedCurve,
      initialValue: initial,
      builder: (context, value, child) {
        return builder!(context, value, child);
      },
      child: child,
    );
  }
}
