part of '../../theme.dart';

/// IconThemeProperties defines a reusable type for this registry module.
class IconThemeProperties {
  /// Icon theme for 4x-small icons (6px).
  final IconThemeData x4Small;

  /// Icon theme for 3x-small icons (8px).
  final IconThemeData x3Small;

  /// Icon theme for 2x-small icons (10px).
  final IconThemeData x2Small;

  /// Icon theme for extra-small icons (12px).
  final IconThemeData xSmall;

  /// Icon theme for small icons (16px).
  final IconThemeData small;

  /// Icon theme for medium icons (20px).
  final IconThemeData medium;

  /// Icon theme for large icons (24px).
  final IconThemeData large;

  /// Icon theme for extra-large icons (32px).
  final IconThemeData xLarge;

  /// Icon theme for 2x-large icons (40px).
  final IconThemeData x2Large;

  /// Icon theme for 3x-large icons (48px).
  final IconThemeData x3Large;

  /// Icon theme for 4x-large icons (56px).
  final IconThemeData x4Large;

  /// Creates [IconThemeProperties] with default icon sizes.
  ///
  /// All parameters are optional and default to predefined sizes.
  const IconThemeProperties({
    this.x4Small = const IconThemeData(size: 6),
    this.x3Small = const IconThemeData(size: 8),
    this.x2Small = const IconThemeData(size: 10),
    this.xSmall = const IconThemeData(size: 12),
    this.small = const IconThemeData(size: 16),
    this.medium = const IconThemeData(size: 20),
    this.large = const IconThemeData(size: 24),
    this.xLarge = const IconThemeData(size: 32),
    this.x2Large = const IconThemeData(size: 40),
    this.x3Large = const IconThemeData(size: 48),
    this.x4Large = const IconThemeData(size: 56),
  });

  /// Creates a copy with updated icon themes.
  ///
  /// All parameters are optional getters. Omitted values retain their current value.
  ///
  /// Returns: `IconThemeProperties` — a new instance with updated values.
  IconThemeProperties copyWith({
    ValueGetter<IconThemeData>? x4Small,
    ValueGetter<IconThemeData>? x3Small,
    ValueGetter<IconThemeData>? x2Small,
    ValueGetter<IconThemeData>? xSmall,
    ValueGetter<IconThemeData>? small,
    ValueGetter<IconThemeData>? medium,
    ValueGetter<IconThemeData>? large,
    ValueGetter<IconThemeData>? xLarge,
    ValueGetter<IconThemeData>? x2Large,
    ValueGetter<IconThemeData>? x3Large,
    ValueGetter<IconThemeData>? x4Large,
  }) {
    return IconThemeProperties(
      x4Small: x4Small == null ? this.x4Small : x4Small(),
      x3Small: x3Small == null ? this.x3Small : x3Small(),
      x2Small: x2Small == null ? this.x2Small : x2Small(),
      xSmall: xSmall == null ? this.xSmall : xSmall(),
      small: small == null ? this.small : small(),
      medium: medium == null ? this.medium : medium(),
      large: large == null ? this.large : large(),
      xLarge: xLarge == null ? this.xLarge : xLarge(),
      x2Large: x2Large == null ? this.x2Large : x2Large(),
      x3Large: x3Large == null ? this.x3Large : x3Large(),
      x4Large: x4Large == null ? this.x4Large : x4Large(),
    );
  }

  /// Scales all icon sizes by the given factor.
  ///
  /// Parameters:
  /// - [factor] (`double`, required): Scaling factor to apply.
  ///
  /// Returns: `IconThemeProperties` — scaled icon theme properties.
  IconThemeProperties scale(double factor) {
    return IconThemeProperties(
      x4Small: x4Small.size == null
          ? x4Small
          : x4Small.copyWith(size: x4Small.size! * factor),
      x3Small: x3Small.size == null
          ? x3Small
          : x3Small.copyWith(size: x3Small.size! * factor),
      x2Small: x2Small.size == null
          ? x2Small
          : x2Small.copyWith(size: x2Small.size! * factor),
      xSmall: xSmall.size == null
          ? xSmall
          : xSmall.copyWith(size: xSmall.size! * factor),
      small: small.size == null
          ? small
          : small.copyWith(size: small.size! * factor),
      medium: medium.size == null
          ? medium
          : medium.copyWith(size: medium.size! * factor),
      large: large.size == null
          ? large
          : large.copyWith(size: large.size! * factor),
      xLarge: xLarge.size == null
          ? xLarge
          : xLarge.copyWith(size: xLarge.size! * factor),
      x2Large: x2Large.size == null
          ? x2Large
          : x2Large.copyWith(size: x2Large.size! * factor),
      x3Large: x3Large.size == null
          ? x3Large
          : x3Large.copyWith(size: x3Large.size! * factor),
      x4Large: x4Large.size == null
          ? x4Large
          : x4Large.copyWith(size: x4Large.size! * factor),
    );
  }

  /// Linearly interpolates between two icon theme properties.
  ///
  /// Parameters:
  /// - [a] (`IconThemeProperties`, required): Start properties.
  /// - [b] (`IconThemeProperties`, required): End properties.
  /// - [t] (`double`, required): Interpolation position (0.0 to 1.0).
  ///
  /// Returns: `IconThemeProperties` — interpolated properties.
  static IconThemeProperties lerp(
    IconThemeProperties a,
    IconThemeProperties b,
    double t,
  ) {
    return IconThemeProperties(
      x4Small: IconThemeData.lerp(a.x4Small, b.x4Small, t),
      x3Small: IconThemeData.lerp(a.x3Small, b.x3Small, t),
      x2Small: IconThemeData.lerp(a.x2Small, b.x2Small, t),
      xSmall: IconThemeData.lerp(a.xSmall, b.xSmall, t),
      small: IconThemeData.lerp(a.small, b.small, t),
      medium: IconThemeData.lerp(a.medium, b.medium, t),
      large: IconThemeData.lerp(a.large, b.large, t),
      xLarge: IconThemeData.lerp(a.xLarge, b.xLarge, t),
      x2Large: IconThemeData.lerp(a.x2Large, b.x2Large, t),
      x3Large: IconThemeData.lerp(a.x3Large, b.x3Large, t),
      x4Large: IconThemeData.lerp(a.x4Large, b.x4Large, t),
    );
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IconThemeProperties &&
        other.x4Small == x4Small &&
        other.x3Small == x3Small &&
        other.x2Small == x2Small &&
        other.xSmall == xSmall &&
        other.small == small &&
        other.medium == medium &&
        other.large == large &&
        other.xLarge == xLarge &&
        other.x2Large == x2Large &&
        other.x3Large == x3Large &&
        other.x4Large == x4Large;
  }

  @override
  int get hashCode {
    return Object.hash(
      x4Small,
      x3Small,
      x2Small,
      xSmall,
      small,
      medium,
      large,
      xLarge,
      x2Large,
      x3Large,
      x4Large,
    );
  }

  @override
/// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'IconThemeProperties(x4Small: $x4Small, x3Small: $x3Small, x2Small: $x2Small, xSmall: $xSmall, small: $small, medium: $medium, large: $large, xLarge: $xLarge, x2Large: $x2Large, x3Large: $x3Large, x4Large: $x4Large)';
  }
}

/// A base class for component-specific theme data.
///
/// This class is used as a base class for component-specific theme data,
/// whether as super class or as interface.
