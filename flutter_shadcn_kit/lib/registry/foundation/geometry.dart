// Geometry helpers shared across the registry: directional axes, axis
// alignments/insets, border math and `optionallyResolve` extensions.

import 'dart:math';

import 'package:flutter/widgets.dart';

/// A directional axis (up/down/start/end) that resolves to a concrete
/// [AxisDirection] based on [TextDirection].
enum AxisDirectional {
  up,
  down,
  start,
  end;

  /// Resolves this directional axis to a concrete [AxisDirection].
  AxisDirection resolve(TextDirection textDirection) {
    return switch ((this, textDirection)) {
      (AxisDirectional.up, _) => AxisDirection.up,
      (AxisDirectional.down, _) => AxisDirection.down,
      (AxisDirectional.start, TextDirection.ltr) => AxisDirection.left,
      (AxisDirectional.start, TextDirection.rtl) => AxisDirection.right,
      (AxisDirectional.end, TextDirection.ltr) => AxisDirection.right,
      (AxisDirectional.end, TextDirection.rtl) => AxisDirection.left,
    };
  }

  /// The opposite directional axis.
  AxisDirectional get reversed => switch (this) {
    AxisDirectional.up => AxisDirectional.down,
    AxisDirectional.down => AxisDirectional.up,
    AxisDirectional.start => AxisDirectional.end,
    AxisDirectional.end => AxisDirectional.start,
  };
}

/// Base class for axis alignments that resolve based on [TextDirection].
abstract class AxisAlignmentGeometry {
  const AxisAlignmentGeometry();

  /// Resolves this alignment to a concrete [AxisAlignment] for a text
  /// direction.
  AxisAlignment resolve(TextDirection textDirection);
}

/// Alignment along a single axis, compatible with [AxisAlignmentGeometry].
class AxisAlignment extends AxisAlignmentGeometry {
  static const AxisAlignment left = AxisAlignment(-1.0);
  static const AxisAlignment right = AxisAlignment(1.0);
  static const AxisAlignment center = AxisAlignment(0.0);

  /// The resolved text direction, if any.
  final TextDirection? direction;

  /// The alignment value in `-1.0..1.0`.
  final double value;

  const AxisAlignment._(this.direction, this.value);
  const AxisAlignment(this.value) : direction = null;

  /// Returns the resolved alignment value for [axis].
  double resolveValue(Axis axis) {
    return switch ((direction, axis)) {
      (TextDirection.ltr, Axis.horizontal) => value,
      (TextDirection.rtl, Axis.horizontal) => value * -1,
      _ => value,
    };
  }

  /// Positions a child within a span of [size] using this alignment.
  double alongValue(Axis axis, double size) {
    final center = size / 2;
    return center + resolveValue(axis) * center;
  }

  /// Converts this alignment to an [Alignment] for a horizontal layout.
  Alignment asHorizontalAlignment(AxisAlignment crossAxisAlignment) {
    return Alignment(resolveValue(Axis.horizontal), crossAxisAlignment.value);
  }

  /// Converts this alignment to an [Alignment] for a vertical layout.
  Alignment asVerticalAlignment(AxisAlignment crossAxisAlignment) {
    return Alignment(crossAxisAlignment.value, resolveValue(Axis.vertical));
  }

  @override
  AxisAlignment resolve(TextDirection textDirection) {
    return AxisAlignment._(textDirection, value);
  }
}

/// Directional axis alignment that resolves relative to text direction.
class AxisAlignmentDirectional extends AxisAlignmentGeometry {
  static const AxisAlignmentDirectional start = AxisAlignmentDirectional(-1.0);
  static const AxisAlignmentDirectional end = AxisAlignmentDirectional(1.0);
  static const AxisAlignmentDirectional center = AxisAlignmentDirectional(0.0);

  /// The alignment value in `-1.0..1.0`.
  final double value;

  const AxisAlignmentDirectional(this.value);

  @override
  AxisAlignment resolve(TextDirection textDirection) {
    return AxisAlignment._(textDirection, value);
  }
}

/// Base class for axis-based insets (start/end) that resolve to concrete
/// values based on [TextDirection].
abstract class AxisInsetsGeometry {
  const AxisInsetsGeometry();

  /// Resolves the insets to a concrete [AxisInsets].
  AxisInsets resolve(TextDirection textDirection);
}

/// Insets along an axis with support for directionality.
class AxisInsets extends AxisInsetsGeometry {
  /// The resolved text direction, if any.
  final TextDirection? direction;

  /// The start value.
  final double start;

  /// The end value.
  final double end;

  const AxisInsets({required this.start, required this.end}) : direction = null;
  const AxisInsets._(this.start, this.end, this.direction);

  /// Resolves the start and end values for [axis].
  ({double start, double end}) resolveValue(Axis axis) {
    return switch ((direction, axis)) {
      (TextDirection.ltr, Axis.horizontal) => (start: start, end: end),
      (TextDirection.rtl, Axis.horizontal) => (start: end, end: start),
      _ => (start: start, end: end),
    };
  }

  @override
  AxisInsets resolve(TextDirection textDirection) {
    return AxisInsets._(start, end, textDirection);
  }
}

/// Directional insets along an axis, resolved by [TextDirection].
class AxisInsetsDirectional extends AxisInsetsGeometry {
  /// The start value.
  final double start;

  /// The end value.
  final double end;

  const AxisInsetsDirectional({required this.start, required this.end});

  @override
  AxisInsets resolve(TextDirection textDirection) {
    return AxisInsets._(start, end, textDirection);
  }
}

/// Subtracts [borderWidth] from every corner of [radius], never going below
/// zero.
BorderRadius subtractByBorder(BorderRadius radius, double borderWidth) {
  return BorderRadius.only(
    topLeft: _subtractSafe(radius.topLeft, Radius.circular(borderWidth)),
    topRight: _subtractSafe(radius.topRight, Radius.circular(borderWidth)),
    bottomLeft: _subtractSafe(radius.bottomLeft, Radius.circular(borderWidth)),
    bottomRight: _subtractSafe(
      radius.bottomRight,
      Radius.circular(borderWidth),
    ),
  );
}

Radius _subtractSafe(Radius a, Radius b) {
  return Radius.elliptical(max(0, a.x - b.x), max(0, a.y - b.y));
}

/// Resolves [radius] to a [BorderRadius] with the ambient [Directionality],
/// or returns null when [radius] is null.
BorderRadius? optionallyResolveBorderRadius(
  BuildContext context,
  BorderRadiusGeometry? radius,
) {
  if (radius == null) {
    return null;
  }
  if (radius is BorderRadius) {
    return radius;
  }
  return radius.resolve(Directionality.of(context));
}

/// Resolves the geometry against the ambient [Directionality] only when
/// needed.
extension AlignmentGeometryExtension on AlignmentGeometry {
  /// Returns this alignment as an [Alignment].
  Alignment optionallyResolve(BuildContext context) {
    if (this is Alignment) {
      return this as Alignment;
    }
    return resolve(Directionality.of(context));
  }
}

/// Resolves the geometry against the ambient [Directionality] only when
/// needed.
extension BorderRadiusGeometryExtension on BorderRadiusGeometry {
  /// Returns this radius as a [BorderRadius].
  BorderRadius optionallyResolve(BuildContext context) {
    if (this is BorderRadius) {
      return this as BorderRadius;
    }
    return resolve(Directionality.of(context));
  }
}

/// Resolves the geometry against the ambient [Directionality] only when
/// needed.
extension EdgeInsetsGeometryExtension on EdgeInsetsGeometry {
  /// Returns these insets as an [EdgeInsets].
  EdgeInsets optionallyResolve(BuildContext context) {
    if (this is EdgeInsets) {
      return this as EdgeInsets;
    }
    return resolve(Directionality.of(context));
  }
}

/// Removes [border] from each side of [padding], never going below zero.
///
/// Bordered controls paint their border as decoration padding, which adds
/// layout; insetting the padding by the border width keeps the control at its
/// size-table total (F1: outline md measured 38, not 36).
EdgeInsets insetBorder(EdgeInsets padding, double border) {
  if (border <= 0) {
    return padding;
  }
  return EdgeInsets.fromLTRB(
    max(0, padding.left - border),
    max(0, padding.top - border),
    max(0, padding.right - border),
    max(0, padding.bottom - border),
  );
}
