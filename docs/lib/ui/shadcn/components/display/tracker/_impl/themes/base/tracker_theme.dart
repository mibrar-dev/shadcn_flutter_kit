// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../tracker.dart';

/// Theme for tracker appearance.
class TrackerTheme extends ComponentThemeData {
  /// Layout/size setting that affects tracker rendering.
  final double? radius;

  /// Layout/size setting that affects tracker rendering.
  final double? gap;

  /// Layout/size setting that affects tracker rendering.
  final double? itemHeight;

  /// Creates `TrackerTheme` for configuring or rendering tracker.
  const TrackerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.radius,
    this.gap,
    this.itemHeight,
  });

  TrackerTheme copyWith({
    ValueGetter<double?>? radius,
    ValueGetter<double?>? gap,
    ValueGetter<double?>? itemHeight,
  }) {
    return TrackerTheme(
      radius: radius == null ? this.radius : radius(),
      gap: gap == null ? this.gap : gap(),
      itemHeight: itemHeight == null ? this.itemHeight : itemHeight(),
    );
  }

  /// Compares two tracker values for structural equality.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TrackerTheme &&
        other.radius == radius &&
        other.gap == gap &&
        other.itemHeight == itemHeight;
  }

  /// State flag that toggles specific tracker behavior.
  @override
  int get hashCode => Object.hash(radius, gap, itemHeight);
}
