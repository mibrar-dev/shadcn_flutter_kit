import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'animated_value_builder.dart';
import 'focus_outline.dart';
import '../theme/theme.dart';
import '../utils/constants.dart';
import '../utils/platform_utils.dart';

part '_impl/core/__builder_stated_widget.dart';
part '_impl/core/__map_stated_widget.dart';
part '_impl/core/__param_stated_widget.dart';
part '_impl/core/clickable.dart';
part '_impl/core/stated_widget.dart';
part '_impl/core/widget_states_data.dart';
part '_impl/core/widget_states_provider.dart';
part '_impl/state/__clickable_state.dart';

/// Extension on `Set<WidgetState>` providing convenient boolean getters for common states.
///
/// This extension simplifies checking for widget states by providing readable
/// property accessors instead of using `contains()` calls.
///
/// ## Example
///
/// ```dart
/// Set<WidgetState> states = {WidgetState.hovered, WidgetState.focused};
///
/// if (states.hovered) {
///   // Handle hover state
/// }
/// if (states.disabled) {
///   // Handle disabled state
/// }
/// ```
extension WidgetStateExtension on Set<WidgetState> {
  /// Whether the widget is in a disabled state.
  bool get disabled => contains(WidgetState.disabled);

  /// Whether the widget is in an error state.
  bool get error => contains(WidgetState.error);

  /// Whether the widget is in a selected state.
  bool get selected => contains(WidgetState.selected);

  /// Whether the widget is in a pressed state.
  bool get pressed => contains(WidgetState.pressed);

  /// Whether the widget is in a hovered state.
  bool get hovered => contains(WidgetState.hovered);

  /// Whether the widget is in a focused state.
  bool get focused => contains(WidgetState.focused);
}

/// An abstract widget that provides state-aware visual variations.
///
/// Enables widgets to display different appearances based on their current
/// interactive state (disabled, selected, pressed, hovered, focused, error).
/// The widget automatically selects the appropriate visual representation
/// from provided alternatives based on a configurable state priority order.
///
/// Three factory constructors provide different approaches to state handling:
/// - Default constructor: Explicit widgets for each state
/// - `.map()`: Map-based state-to-widget associations
/// - `.builder()`: Function-based dynamic state handling
///
/// The state resolution follows a priority order where earlier states in the
/// order take precedence over later ones. This ensures consistent behavior
/// when multiple states are active simultaneously.
///
/// Example:
/// ```dart
/// StatedWidget(
///   child: Text('Default'),
///   disabled: Text('Disabled State'),
///   hovered: Text('Hovered State'),
///   pressed: Text('Pressed State'),
///   selected: Text('Selected State'),
/// )
/// ```
