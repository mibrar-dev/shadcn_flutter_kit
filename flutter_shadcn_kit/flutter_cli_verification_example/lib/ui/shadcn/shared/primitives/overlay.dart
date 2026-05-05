import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:data_widget/data_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../theme/theme.dart';
import '../utils/constants.dart';
import '../utils/geometry_extensions.dart';
import '../utils/tween_utils.dart';
import 'animated_value_builder.dart';

part '_impl/core/__fallback_overlay_manager.dart';
part '_impl/core/overlay_barrier.dart';
part '_impl/core/overlay_manager.dart';
part '_impl/core/overlay_manager_layer.dart';
part '_impl/core/shadcn_layer.dart';
part '_impl/state/__overlay_manager_layer_state.dart';
part '_impl/utils/overlay_completer.dart';
part '_impl/utils/overlay_handler.dart';

part 'popover.dart';
part '_impl/core/overlay_popover_entry.dart';
part '_impl/core/popover.dart';
part '_impl/core/popover_layout.dart';
part '_impl/core/popover_layout_render.dart';
part '_impl/core/popover_overlay_widget.dart';
part '_impl/state/popover_overlay_widget_state.dart';
part '_impl/utils/popover_controller.dart';
part '_impl/utils/popover_overlay_handler.dart';

/// Closes the currently active overlay with an optional result value.
///
/// Searches up the widget tree for an [OverlayHandlerStateMixin] and
/// requests it to close with the provided result. If no overlay handler
/// is found, returns a completed future.
///
/// Parameters:
/// - [context] (BuildContext, required): Build context from within the overlay
/// - [value] (T?): Optional result value to return when closing
///
/// Returns a [Future] that completes when the overlay is closed.
///
/// Example:
/// ```dart
/// closeOverlay(context, 'user_confirmed');
/// ```
Future<void> closeOverlay<T>(BuildContext context, [T? value]) {
  return Data.maybeFind<OverlayHandlerStateMixin>(context)
          ?.closeWithResult(value) ??
      Future.value();
}

/// Mixin providing overlay state management methods.
///
/// Defines the interface for overlay state classes, including methods for
/// closing overlays and updating overlay configuration dynamically.
///
/// Used by overlay implementations to provide consistent lifecycle management
/// and configuration update capabilities.
mixin OverlayHandlerStateMixin<T extends StatefulWidget> on State<T> {
  /// Closes the overlay.
  ///
  /// Parameters:
  /// - [immediate] (bool): If true, closes immediately without animation
  ///
  /// Returns a [Future] that completes when closed.
  Future<void> close([bool immediate = false]);

  /// Schedules overlay closure for the next frame.
  ///
  /// Useful for closing overlays from callbacks where immediate closure
  /// might cause issues with the widget tree.
  void closeLater();

  /// Closes the overlay with a result value.
  ///
  /// Parameters:
  /// - [value] (X?): Optional result to return
  ///
  /// Returns a [Future] that completes when closed.
  Future<void> closeWithResult<X>([X? value]);

  /// Updates the anchor context for positioning.
  set anchorContext(BuildContext value) {}

  /// Updates the overlay alignment.
  set alignment(AlignmentGeometry value) {}

  /// Updates the anchor alignment.
  set anchorAlignment(AlignmentGeometry value) {}

  /// Updates the width constraint.
  set widthConstraint(PopoverConstraint value) {}

  /// Updates the height constraint.
  set heightConstraint(PopoverConstraint value) {}

  /// Updates the margin.
  set margin(EdgeInsets value) {}

  /// Updates whether the overlay follows the anchor.
  set follow(bool value) {}

  /// Updates the position offset.
  set offset(Offset? value) {}

  /// Updates horizontal inversion permission.
  set allowInvertHorizontal(bool value) {}

  /// Updates vertical inversion permission.
  set allowInvertVertical(bool value) {}
}

/// Abstract interface for overlay operation completion tracking.
///
/// Provides lifecycle management and status tracking for overlay operations,
/// including completion state, animation state, and dismissal.
