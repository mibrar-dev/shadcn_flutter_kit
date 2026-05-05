import 'dart:math';

import 'package:flutter/widgets.dart';

/// A function that modifies button padding based on density requirements.
///
/// Takes the base padding and returns modified padding appropriate for the
/// desired button density level.
typedef DensityModifier = EdgeInsets Function(EdgeInsets padding);

/// Defines the padding density for button components.
///
/// [ButtonDensity] controls how much internal padding buttons have, affecting
/// their overall size and touch target area. Different density levels are
/// appropriate for different use cases and layout constraints.
///
/// Example:
/// ```dart
/// Button.primary(
///   style: ButtonStyle.primary().copyWith(density: ButtonDensity.compact),
///   child: Text('Compact Button'),
/// );
/// ```
class ButtonDensity {
  /// Function that modifies base padding to achieve the desired density.
  final DensityModifier modifier;

  /// Creates a [ButtonDensity] with the specified padding modifier.
  const ButtonDensity(this.modifier);

  /// Standard padding density (no modification).
  static const ButtonDensity normal = ButtonDensity(_densityNormal);

  /// Increased padding for more comfortable touch targets.
  static const ButtonDensity comfortable = ButtonDensity(_densityComfortable);

  /// Square padding suitable for icon-only buttons.
  static const ButtonDensity icon = ButtonDensity(_densityIcon);

  /// Comfortable square padding for icon-only buttons.
  static const ButtonDensity iconComfortable = ButtonDensity(
    _densityIconComfortable,
  );

  /// Dense square padding for compact icon buttons.
  static const ButtonDensity iconDense = ButtonDensity(_densityIconDense);

  /// Reduced padding for tighter layouts (50% of normal).
  static const ButtonDensity dense = ButtonDensity(_densityDense);

  /// Minimal padding for very compact layouts (zero padding).
  static const ButtonDensity compact = ButtonDensity(_densityCompact);
}

/// Executes `_densityNormal` behavior for this component/composite.
EdgeInsets _densityNormal(EdgeInsets padding) {
  return padding;
}

/// Executes `_densityDense` behavior for this component/composite.
EdgeInsets _densityDense(EdgeInsets padding) {
  return padding * 0.5;
}

/// Executes `_densityCompact` behavior for this component/composite.
EdgeInsets _densityCompact(EdgeInsets padding) {
  return EdgeInsets.zero;
}

/// Executes `_densityIcon` behavior for this component/composite.
EdgeInsets _densityIcon(EdgeInsets padding) {
  return EdgeInsets.all(
/// Creates a `min` instance.
    min(padding.top, min(padding.bottom, min(padding.left, padding.right))),
  );
}

/// Executes `_densityIconComfortable` behavior for this component/composite.
EdgeInsets _densityIconComfortable(EdgeInsets padding) {
  return EdgeInsets.all(
/// Creates a `max` instance.
    max(padding.top, max(padding.bottom, max(padding.left, padding.right))),
  );
}

/// Executes `_densityIconDense` behavior for this component/composite.
EdgeInsets _densityIconDense(EdgeInsets padding) {
  return EdgeInsets.all(
/// Creates a `min` instance.
    min(padding.top, min(padding.bottom, min(padding.left, padding.right))) *
        0.5,
  );
}

/// Executes `_densityComfortable` behavior for this component/composite.
EdgeInsets _densityComfortable(EdgeInsets padding) {
  return padding * 2;
}
