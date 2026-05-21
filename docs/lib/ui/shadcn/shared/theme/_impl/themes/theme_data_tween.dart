// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../theme.dart';

/// ThemeDataTween defines a reusable type for this registry module.
class ThemeDataTween extends Tween<ThemeData> {
  /// Creates a [ThemeDataTween].
  ///
  /// Parameters:
  /// - [begin] (`ThemeData`, required): Starting theme.
  /// - [end] (`ThemeData`, required): Ending theme.
  ThemeDataTween({required ThemeData super.begin, required super.end});

  @override
  /// Executes `lerp` behavior for this component/composite.
  ThemeData lerp(double t) {
    if (end == null) {
      return begin!;
    }
    return ThemeData.lerp(begin!, end!, t);
  }
}

/// A widget that animates theme changes over time.
