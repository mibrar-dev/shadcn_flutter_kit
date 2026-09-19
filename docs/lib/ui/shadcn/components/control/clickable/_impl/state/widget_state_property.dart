// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

/// Resolves a value from the widget's current states and its build context.
///
/// Flutter's own [WidgetPropertyResolver] only receives the states; this adds
/// the [BuildContext] so a resolver can read the ambient [Theme] instead of
/// having the colors baked in at construction time.
///
/// Parameters:
/// - [context]: The build context, for reading theme data.
/// - [states]: The states currently active on the widget.
///
/// Returns the value of type [T] appropriate for those states.
///
/// Example:
/// ```dart
/// WidgetStatePropertyResolver<Color> background = (context, states) {
///   if (states.disabled) return Theme.of(context).colorScheme.muted;
///   if (states.hovered) return Theme.of(context).colorScheme.accent;
///   return Theme.of(context).colorScheme.background;
/// };
/// ```
///
/// See also:
/// - [WidgetStatePropertyDelegate], for overriding an already-resolved value.
typedef WidgetStatePropertyResolver<T> = T Function(
  BuildContext context,
  Set<WidgetState> states,
);

/// Overrides a value that has already been resolved for the current states.
///
/// Unlike [WidgetStatePropertyResolver], a delegate also receives the [value]
/// the widget would otherwise have used, so it can adjust one facet and leave
/// the rest of the resolved value alone rather than rebuilding it from nothing.
///
/// Parameters:
/// - [context]: The build context, for reading theme data.
/// - [states]: The states currently active on the widget.
/// - [value]: The value the widget resolved on its own.
///
/// Returns the final value of type [T].
///
/// Example:
/// ```dart
/// WidgetStatePropertyDelegate<Decoration> outline = (context, states, value) {
///   return (value as BoxDecoration).copyWith(
///     border: Border.all(
///       color: states.focused ? Colors.blue : Colors.gray,
///     ),
///   );
/// };
/// ```
typedef WidgetStatePropertyDelegate<T> = T Function(
  BuildContext context,
  Set<WidgetState> states,
  T value,
);
