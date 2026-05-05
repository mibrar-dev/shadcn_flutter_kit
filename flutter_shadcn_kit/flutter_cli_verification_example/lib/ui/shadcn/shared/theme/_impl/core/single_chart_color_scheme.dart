part of '../../color_scheme.dart';

/// SingleChartColorScheme defines a reusable type for this registry module.
class SingleChartColorScheme implements ChartColorScheme {
  /// The single color used for all chart elements.
  final Color color;

  /// Creates a single color chart scheme.
  const SingleChartColorScheme(this.color);

  @override
/// Stores `chartColors` state/configuration for this implementation.
  List<Color> get chartColors => [color, color, color, color, color];

  @override
/// Stores `chart1` state/configuration for this implementation.
  Color get chart1 => color;

  @override
/// Stores `chart2` state/configuration for this implementation.
  Color get chart2 => color;

  @override
/// Stores `chart3` state/configuration for this implementation.
  Color get chart3 => color;

  @override
/// Stores `chart4` state/configuration for this implementation.
  Color get chart4 => color;

  @override
/// Stores `chart5` state/configuration for this implementation.
  Color get chart5 => color;
}

/// A color scheme for charts with 5 distinct colors.
///
/// Provides colors for up to 5 different data series in charts.
