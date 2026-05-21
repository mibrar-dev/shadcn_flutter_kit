// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../stage_container.dart';

/// StagedBreakpoint defines a reusable type for this registry module.
class StagedBreakpoint implements StageBreakpoint {
  /// Default breakpoints matching common responsive design values.
  static const List<double> _defaultBreakpoints = [576, 768, 992, 1200, 1400];

  /// List of breakpoint width values in ascending order.
  final List<double> breakpoints;

  /// Creates a [StagedBreakpoint] with custom breakpoints.
  ///
  /// Requires at least 2 breakpoints.
  const StagedBreakpoint(this.breakpoints) : assert(breakpoints.length > 1);

  /// Creates a [StagedBreakpoint] with default responsive breakpoints.
  const StagedBreakpoint.defaultBreakpoints()
    : breakpoints = _defaultBreakpoints;

  @override
  /// Executes `getMinWidth` behavior for this component/composite.
  double getMinWidth(double width) {
    for (int i = 1; i < breakpoints.length; i++) {
      if (width < breakpoints[i]) {
        return breakpoints[i - 1];
      }
    }
    return width;
  }

  @override
  /// Executes `getMaxWidth` behavior for this component/composite.
  double getMaxWidth(double width) {
    for (var breakpoint in breakpoints) {
      if (width < breakpoint) {
        return breakpoint;
      }
    }
    return maxSize;
  }

  @override
  /// Stores `minSize` state/configuration for this implementation.
  double get minSize => breakpoints.first;

  @override
  /// Stores `maxSize` state/configuration for this implementation.
  double get maxSize => breakpoints.last;
}
