// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// Public upstream-parity alias for the internal labeled-layout widget.
///
/// Upstream `shadcn_flutter` exposes `NavigationLabeled`; the registry kept
/// the same implementation private as [_NavigationLabeled]. This subclass
/// preserves the upstream name so existing code keeps compiling. Accepts the
/// same layout/layout-animation parameters plus an optional [key].
class NavigationLabeled extends _NavigationLabeled {
  /// Creates a [NavigationLabeled] (upstream-parity alias).
  const NavigationLabeled({
    super.key,
    required super.child,
    required super.label,
    required super.spacing,
    required super.position,
    required super.showLabel,
    required super.labelType,
    required super.direction,
    required super.keepCrossAxisSize,
    required super.keepMainAxisSize,
  });
}

/// Public upstream-parity alias for the internal overflow widget.
///
/// Upstream `shadcn_flutter` exposes `NavigationChildOverflowHandle`; the
/// registry kept the same implementation private as
/// [_NavigationChildOverflowHandle]. This subclass preserves the upstream
/// name so existing code keeps compiling.
class NavigationChildOverflowHandle extends _NavigationChildOverflowHandle {
  /// Creates a [NavigationChildOverflowHandle] (upstream-parity alias).
  const NavigationChildOverflowHandle({
    super.key,
    required super.overflow,
    required super.child,
  });
}
