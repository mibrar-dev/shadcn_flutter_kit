// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:ui' as ui;

import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../form/history/history.dart';
import '../../../shared/primitives/text.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/color_extensions.dart';

part '_impl/core/eye_dropper_layer.dart';
part '_impl/utils/_screenshot_result.dart';
part '_impl/utils/_screenshot_image.dart';
part '_impl/utils/_eye_dropper_completer.dart';
part '_impl/state/_eye_dropper_layer_state.dart';
part '_impl/utils/_color_preview_painter.dart';
part '_impl/core/eye_dropper_layer_scope.dart';
part '_impl/core/eye_dropper_result.dart';

/// A function that builds a preview label widget for the eye dropper.
///
/// Parameters:
/// - [context]: The build context.
/// - [color]: The currently selected color under the cursor.
///
/// Returns: A widget to display as the color preview label.
typedef PreviewLabelBuilder =
    Widget Function(BuildContext context, Color color);

/// A layer widget that provides eye dropper (color picking) functionality.
///
/// [EyeDropperLayer] wraps its child widget and enables screen color sampling.
/// When active, it displays a magnified preview of the area under the cursor
/// and allows users to pick colors directly from the screen.
///
/// Features:
/// - Magnified preview of screen area
/// - Customizable preview size and scale
/// - Optional color label display
/// - Flexible preview positioning
///
/// Example:
/// ```dart
/// EyeDropperLayer(
///   child: MyApp(),
///   showPreview: true,
///   previewScale: 10,
///   previewLabelBuilder: (context, color) {
///     return Text('Color: ${colorToHex(color)}');
///   },
/// )
/// ```
