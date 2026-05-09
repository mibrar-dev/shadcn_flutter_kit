// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../stage_container.dart';

/// StageContainerTheme defines a reusable type for this registry module.
class StageContainerTheme extends ComponentThemeData {
  /// The breakpoint strategy to use.
  final StageBreakpoint? breakpoint;

  /// Default padding for the container.
  final EdgeInsets? padding;

  /// Creates a [StageContainerTheme].
  const StageContainerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.breakpoint,
    this.padding,
  });

  /// Creates a copy of this theme with the given fields replaced.
  StageContainerTheme copyWith({
    ValueGetter<StageBreakpoint?>? breakpoint,
    ValueGetter<EdgeInsets?>? padding,
  }) {
    return StageContainerTheme(
      breakpoint: breakpoint == null ? this.breakpoint : breakpoint(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StageContainerTheme &&
        other.breakpoint == breakpoint &&
        other.padding == padding;
  }

  @override
  int get hashCode => Object.hash(breakpoint, padding);
}
