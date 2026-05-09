// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

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
