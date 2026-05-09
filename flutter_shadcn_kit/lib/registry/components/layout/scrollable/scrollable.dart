// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';

part '_impl/core/faded_scrollable_viewport.dart';
part '_impl/core/render_scrollable_client_viewport.dart';
part '_impl/core/scrollable_client.dart';
part '_impl/core/scrollable_client_child_vicinity.dart';
part '_impl/core/scrollable_client_viewport.dart';
part '_impl/themes/base/scrollable_client_theme.dart';

/// Builder function for creating scrollable content with viewport information.
///
/// Parameters:
/// - [context] (`BuildContext`): Build context.
/// - [offset] (`Offset`): Current scroll offset.
/// - [viewportSize] (`Size`): Size of the visible viewport.
/// - [child] (`Widget?`): Optional child widget.
typedef ScrollableBuilder =
    Widget Function(
      BuildContext context,
      Offset offset,
      Size viewportSize,
      Widget? child,
    );
