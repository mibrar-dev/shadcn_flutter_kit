part of '../../color_scheme.dart';

/// ChartColorScheme defines a reusable type for this registry module.
class ChartColorScheme {
  /// The list of chart colors.
  final List<Color> chartColors;

  /// Creates a chart color scheme with the given colors.
  const ChartColorScheme(this.chartColors);

  /// Creates a chart color scheme using a single color for all elements.
  factory ChartColorScheme.single(Color color) {
    return SingleChartColorScheme(color);
  }

  /// Color for the first chart series.
  Color get chart1 => chartColors[0];

  /// Color for the second chart series.
  Color get chart2 => chartColors[1];

  /// Color for the third chart series.
  Color get chart3 => chartColors[2];

  /// Color for the fourth chart series.
  Color get chart4 => chartColors[3];

  /// Color for the fifth chart series.
  Color get chart5 => chartColors[4];
}

/// A collection of color shades from light to dark.
///
/// Implements both [Color] and [ColorSwatch] to provide a primary color
/// and access to different shade values (50, 100, 200, ..., 950).
