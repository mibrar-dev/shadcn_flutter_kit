import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import 'color_scheme.dart';
import 'component_theme_global_registry.dart';
import 'typography.dart';
export 'schema/component_schema.dart';

part '_impl/core/adaptive_scaler.dart';
part '_impl/core/adaptive_scaling.dart';
part '_impl/core/density.dart';
part '_impl/core/design_tokens.dart';
part '_impl/themes/__animated_theme_state.dart';
part '_impl/themes/animated_theme.dart';
part '_impl/themes/component_theme.dart';
part '_impl/themes/component_theme_data.dart';
part '_impl/themes/icon_theme_properties.dart';
part '_impl/themes/theme.dart';
part '_impl/themes/theme_data.dart';
part '_impl/themes/theme_data_tween.dart';

/// Defines scaling behavior for adaptive layouts.
///
/// Provides different scaling strategies for text and icons.
