// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// ScaffoldBoxConstraints defines a reusable type for this registry module.
class ScaffoldBoxConstraints extends BoxConstraints {
  /// Height of the header section.
  final double headerHeight;

  /// Height of the footer section.
  final double footerHeight;

  /// Creates [ScaffoldBoxConstraints].
  ///
  /// Parameters:
  /// - [headerHeight] (`double`, required): Header height.
  /// - [footerHeight] (`double`, required): Footer height.
  /// - Additional [BoxConstraints] parameters.
  const ScaffoldBoxConstraints({
    required this.headerHeight,
    required this.footerHeight,
    super.minWidth,
    super.maxWidth,
    super.minHeight,
    super.maxHeight,
  });

  /// Creates [ScaffoldBoxConstraints] from existing [BoxConstraints].
  ///
  /// Parameters:
  /// - [constraints] (`BoxConstraints`, required): Base constraints.
  /// - [headerHeight] (`double`, required): Header height.
  /// - [footerHeight] (`double`, required): Footer height.
  ///
  /// Returns: New [ScaffoldBoxConstraints] with scaffold-specific data.
  factory ScaffoldBoxConstraints.fromBoxConstraints({
    required BoxConstraints constraints,
    required double headerHeight,
    required double footerHeight,
  }) {
    return ScaffoldBoxConstraints(
      headerHeight: headerHeight,
      footerHeight: footerHeight,
      minWidth: constraints.minWidth,
      maxWidth: constraints.maxWidth,
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  /// Creates a `ScaffoldBoxConstraints` instance.
  ScaffoldBoxConstraints copyWith({
    double? headerHeight,
    double? footerHeight,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return ScaffoldBoxConstraints(
      headerHeight: headerHeight ?? this.headerHeight,
      footerHeight: footerHeight ?? this.footerHeight,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ScaffoldBoxConstraints) return false;
    return other.headerHeight == headerHeight &&
        other.footerHeight == footerHeight &&
        other.minWidth == minWidth &&
        other.maxWidth == maxWidth &&
        other.minHeight == minHeight &&
        other.maxHeight == maxHeight;
  }

  @override
  int get hashCode {
    return Object.hash(
      headerHeight,
      footerHeight,
      minWidth,
      maxWidth,
      minHeight,
      maxHeight,
    );
  }

  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() {
    return 'ScaffoldBoxConstraints(headerHeight: $headerHeight, footerHeight: $footerHeight, minWidth: $minWidth, maxWidth: $maxWidth, minHeight: $minHeight, maxHeight: $maxHeight)';
  }
}
