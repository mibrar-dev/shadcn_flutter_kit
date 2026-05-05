import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' show CircularProgressIndicator, Icons;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../layout/card/card.dart';
import '../../form/checkbox/checkbox.dart';
import '../../../shared/localizations/shadcn_localizations.dart';
import '../../../shared/primitives/animated_value_builder.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/style_value.dart';
import '../../../shared/utils/util.dart';

part '_impl/themes/base/refresh_trigger_theme.dart';
part '_impl/core/refresh_trigger_widget.dart';
part '_impl/core/default_refresh_indicator.dart';
part '_impl/state/_default_refresh_indicator_state.dart';
part '_impl/utils/_refresh_trigger_tween.dart';
part '_impl/state/refresh_trigger_state.dart';
part '_impl/core/refresh_trigger_stage.dart';
part '_impl/utils/refresh_trigger_physics.dart';

/// Builder function for custom refresh indicators.
///
/// Parameters:
/// - [context]: The build context
/// - [stage]: Current refresh trigger stage with progress information
///
/// Returns a widget that visualizes the refresh state.
typedef RefreshIndicatorBuilder =
    Widget Function(BuildContext context, RefreshTriggerStage stage);

/// Theme configuration for [RefreshTrigger].
///
/// Example usage:
/// ```dart
/// ComponentTheme(
///   data: RefreshTriggerTheme(
///     minExtent: 100.0,
///     maxExtent: 200.0,
///     curve: Curves.easeInOut,
///     completeDuration: Duration(milliseconds: 800),
///   ),
///   child: RefreshTrigger(
///     onRefresh: () async {
///       // Refresh logic here
///     },
///     child: ListView(
///       children: [
///         // List items
///       ],
///     ),
///   ),
/// )
/// ```
