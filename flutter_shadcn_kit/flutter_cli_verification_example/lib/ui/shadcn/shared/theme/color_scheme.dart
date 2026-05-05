import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../utils/color_extensions.dart';
import 'generated_colors.dart';
import 'theme.dart';

part '_impl/core/chart_color_scheme.dart';
part '_impl/core/color_scheme.dart';
part '_impl/core/color_schemes.dart';
part '_impl/core/color_shades.dart';
part '_impl/core/single_chart_color_scheme.dart';

/// Executes `_fromAHSL` behavior for this component/composite.
Color _fromAHSL(double a, double h, double s, double l) {
  return HSLColor.fromAHSL(a, h, s, l).toColor();
}

/// A chart color scheme that uses a single color for all chart elements.
