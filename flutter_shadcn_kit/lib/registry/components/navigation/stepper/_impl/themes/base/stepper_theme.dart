// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../stepper.dart';

/// Theme configuration for [Stepper] components.
///
/// Defines default values for stepper direction, size, and visual variant.
/// Applied through [ComponentTheme] to provide consistent styling across
/// stepper widgets in the application.
///
/// Example:
/// ```dart
/// ComponentTheme(
///   data: StepperTheme(
///     direction: Axis.vertical,
///     size: StepSize.large,
///     variant: StepVariant.circle,
///   ),
///   child: MyApp(),
/// );
/// ```
class StepperTheme extends ComponentThemeData {
  /// Layout direction for the stepper.
  final Axis? direction;

  /// Size variant for step indicators.
  final StepSize? size;

  /// Visual variant for step presentation.
  final StepVariant? variant;

  /// Creates a [StepperTheme].
  ///
  /// All parameters are optional and provide default values for
  /// stepper components in the widget tree.
  ///
  /// Parameters:
  /// - [direction] (Axis?): horizontal or vertical layout
  /// - [size] (StepSize?): step indicator size (small, medium, large)
  /// - [variant] (StepVariant?): visual style (circle, circleAlt, line)
  const StepperTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.size,
    this.variant,
  });

  /// Creates a copy of this theme with optionally overridden properties.
  StepperTheme copyWith({
    ValueGetter<Axis?>? direction,
    ValueGetter<StepSize?>? size,
    ValueGetter<StepVariant?>? variant,
  }) {
    return StepperTheme(
      direction: direction == null ? this.direction : direction(),
      size: size == null ? this.size : size(),
      variant: variant == null ? this.variant : variant(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StepperTheme &&
        other.direction == direction &&
        other.size == size &&
        other.variant == variant;
  }

  @override
  int get hashCode => Object.hash(direction, size, variant);
}
