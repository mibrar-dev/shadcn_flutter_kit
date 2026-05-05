part of '../../theme.dart';

/// Extra small padding multiplier (0.5).
const padXs = 0.5;

/// Small padding multiplier (1.0).
const padSm = 1.0;

/// Medium padding multiplier (1.5).
const padMd = 1.5;

/// Standard/large padding multiplier (2.0).
const padLg = 2.0;

/// Extra large padding multiplier (2.5).
const padXl = 2.5;

/// 2x extra large padding multiplier (3.0).
const pad2xl = 3.0;

/// 3x extra large padding multiplier (3.5).
const pad3xl = 3.5;

/// 4x extra large padding multiplier (4.0).
const pad4xl = 4.0;

/// Extra small gap multiplier (0.5).
const gapXs = 0.5;

/// Small gap multiplier (1.0).
const gapSm = 1.0;

/// Medium gap multiplier (1.5).
const gapMd = 1.5;

/// Standard/large gap multiplier (2.0).
const gapLg = 2.0;

/// Extra large gap multiplier (2.5).
const gapXl = 2.5;

/// 2x extra large gap multiplier (3.0).
const gap2xl = 3.0;

/// 3x extra large gap multiplier (3.5).
const gap3xl = 3.5;

/// 4x extra large gap multiplier (4.0).
const gap4xl = 4.0;

/// Density scale used to resolve padding and gap multipliers.
class Density {
/// Executes `lerp` behavior for this component/composite.
  static Density lerp(Density a, Density b, double t) {
    return Density(
      baseContainerPadding: lerpDouble(
        a.baseContainerPadding,
        b.baseContainerPadding,
        t,
      )!,
      baseGap: lerpDouble(a.baseGap, b.baseGap, t)!,
      baseContentPadding: lerpDouble(
        a.baseContentPadding,
        b.baseContentPadding,
        t,
      )!,
    );
  }

  static const defaultDensity = Density(
    baseContainerPadding: 16.0,
    baseGap: 8.0,
    baseContentPadding: 16.0,
  );

  static const reducedDensity = Density(
    baseContainerPadding: 12.0,
    baseGap: 6.0,
    baseContentPadding: 12.0,
  );

  static const spaciousDensity = Density(
    baseContainerPadding: 20.0,
    baseGap: 10.0,
    baseContentPadding: 20.0,
  );

  static const compactDensity = Density(
    baseContainerPadding: 8.0,
    baseGap: 4.0,
    baseContentPadding: 8.0,
  );

  /// Converts legacy spacing scale into density values.
  factory Density.fromSpacingScale(SpacingScale spacing) {
    return Density(
      baseContainerPadding: spacing.base * 4,
      baseGap: spacing.base * 2,
      baseContentPadding: spacing.base * 4,
    );
  }

/// Stores `baseContainerPadding` state/configuration for this implementation.
  final double baseContainerPadding;
/// Stores `baseGap` state/configuration for this implementation.
  final double baseGap;
/// Stores `baseContentPadding` state/configuration for this implementation.
  final double baseContentPadding;

/// Creates a `Density` instance.
  const Density({
    required this.baseContainerPadding,
    required this.baseGap,
    required this.baseContentPadding,
  });

/// Executes `toSpacingScale` behavior for this component/composite.
  SpacingScale toSpacingScale() => SpacingScale(baseGap / 2);

/// Creates a `Density` instance.
  Density copyWith({
    ValueGetter<double>? baseContainerPadding,
    ValueGetter<double>? baseGap,
    ValueGetter<double>? baseContentPadding,
  }) {
    return Density(
      baseContainerPadding: baseContainerPadding == null
          ? this.baseContainerPadding
          : baseContainerPadding(),
      baseGap: baseGap == null ? this.baseGap : baseGap(),
      baseContentPadding: baseContentPadding == null
          ? this.baseContentPadding
          : baseContentPadding(),
    );
  }

  @override
/// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    return other is Density &&
        other.baseContainerPadding == baseContainerPadding &&
        other.baseGap == baseGap &&
        other.baseContentPadding == baseContentPadding;
  }

  @override
  int get hashCode =>
      Object.hash(baseContainerPadding, baseGap, baseContentPadding);
}

abstract interface class DensityEdgeInsetsGeometry extends EdgeInsetsGeometry {
  EdgeInsetsGeometry resolveDensity(double basePadding);
}

/// DirectionalEdgeInsetsDensity defines a reusable type for this registry module.
class DirectionalEdgeInsetsDensity extends EdgeInsetsDirectional
    implements DensityEdgeInsetsGeometry {
/// Creates a `DirectionalEdgeInsetsDensity.only` instance.
  const DirectionalEdgeInsetsDensity.only({
    super.start = 0.0,
    super.top = 0.0,
    super.end = 0.0,
    super.bottom = 0.0,
  }) : super.only();

  const DirectionalEdgeInsetsDensity.all(super.value) : super.all();

/// Creates a `DirectionalEdgeInsetsDensity.symmetric` instance.
  const DirectionalEdgeInsetsDensity.symmetric({
    super.vertical = 0.0,
    super.horizontal = 0.0,
  }) : super.symmetric();

  @override
/// Executes `resolveDensity` behavior for this component/composite.
  EdgeInsetsDirectional resolveDensity(double basePadding) {
    return EdgeInsetsDirectional.only(
      start: start * basePadding,
      top: top * basePadding,
      end: end * basePadding,
      bottom: bottom * basePadding,
    );
  }

  @override
  DirectionalEdgeInsetsDensity copyWith({
    double? start,
    double? top,
    double? end,
    double? bottom,
  }) {
    return DirectionalEdgeInsetsDensity.only(
      start: start ?? this.start,
      top: top ?? this.top,
      end: end ?? this.end,
      bottom: bottom ?? this.bottom,
    );
  }
}

/// EdgeInsetsDensity defines a reusable type for this registry module.
class EdgeInsetsDensity extends EdgeInsets
    implements DensityEdgeInsetsGeometry {
/// Creates a `EdgeInsetsDensity.only` instance.
  const EdgeInsetsDensity.only({
    super.left = 0.0,
    super.top = 0.0,
    super.right = 0.0,
    super.bottom = 0.0,
  }) : super.only();

  const EdgeInsetsDensity.all(super.value) : super.all();

/// Creates a `EdgeInsetsDensity.symmetric` instance.
  const EdgeInsetsDensity.symmetric({
    super.vertical = 0.0,
    super.horizontal = 0.0,
  }) : super.symmetric();

  @override
/// Executes `resolveDensity` behavior for this component/composite.
  EdgeInsets resolveDensity(double basePadding) {
    return EdgeInsets.only(
      left: left * basePadding,
      right: right * basePadding,
      top: top * basePadding,
      bottom: bottom * basePadding,
    );
  }

  @override
  EdgeInsetsDensity copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return EdgeInsetsDensity.only(
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
    );
  }
}

EdgeInsetsGeometry resolveEdgeInsets(
  EdgeInsetsGeometry padding,
  double basePadding,
) {
  return switch (padding) {
    DensityEdgeInsetsGeometry densityPadding => densityPadding.resolveDensity(
      basePadding,
    ),
    _ => padding,
  };
}

/// DensityContentPadding defines a reusable type for this registry module.
class DensityContentPadding extends StatelessWidget {
/// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry padding;
/// Stores `child` state/configuration for this implementation.
  final Widget child;

/// Creates a `DensityContentPadding` instance.
  const DensityContentPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedPadding = resolveEdgeInsets(
      padding,
      theme.density.baseContentPadding * theme.scaling,
    );
    return Padding(padding: resolvedPadding, child: child);
  }
}

/// DensityContainerPadding defines a reusable type for this registry module.
class DensityContainerPadding extends StatelessWidget {
/// Stores `padding` state/configuration for this implementation.
  final EdgeInsetsGeometry padding;
/// Stores `child` state/configuration for this implementation.
  final Widget child;

/// Creates a `DensityContainerPadding` instance.
  const DensityContainerPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedPadding = resolveEdgeInsets(
      padding,
      theme.density.baseContainerPadding * theme.scaling,
    );
    return Padding(padding: resolvedPadding, child: child);
  }
}

/// DensityGap defines a reusable type for this registry module.
class DensityGap extends StatelessWidget {
/// Stores `gap` state/configuration for this implementation.
  final double gap;

  const DensityGap(this.gap, {super.key});

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
/// Stores `adjustedGap` state/configuration for this implementation.
    final adjustedGap = gap * theme.density.baseGap * theme.scaling;
    return Gap(adjustedGap);
  }
}

/// DensityRow defines a reusable type for this registry module.
class DensityRow extends StatelessWidget {
/// Stores `spacing` state/configuration for this implementation.
  final double spacing;
/// Stores `children` state/configuration for this implementation.
  final List<Widget> children;
/// Stores `mainAxisAlignment` state/configuration for this implementation.
  final MainAxisAlignment mainAxisAlignment;
/// Stores `crossAxisAlignment` state/configuration for this implementation.
  final CrossAxisAlignment crossAxisAlignment;
/// Stores `mainAxisSize` state/configuration for this implementation.
  final MainAxisSize mainAxisSize;
/// Stores `textDirection` state/configuration for this implementation.
  final TextDirection? textDirection;
/// Stores `verticalDirection` state/configuration for this implementation.
  final VerticalDirection verticalDirection;
/// Stores `textBaseline` state/configuration for this implementation.
  final TextBaseline? textBaseline;

/// Creates a `DensityRow` instance.
  const DensityRow({
    super.key,
    this.spacing = 0,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
/// Stores `adjustedSpacing` state/configuration for this implementation.
    final adjustedSpacing = spacing * theme.density.baseGap * theme.scaling;
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: adjustedSpacing,
      children: children,
    );
  }
}

/// DensityColumn defines a reusable type for this registry module.
class DensityColumn extends StatelessWidget {
/// Stores `spacing` state/configuration for this implementation.
  final double spacing;
/// Stores `children` state/configuration for this implementation.
  final List<Widget> children;
/// Stores `mainAxisAlignment` state/configuration for this implementation.
  final MainAxisAlignment mainAxisAlignment;
/// Stores `crossAxisAlignment` state/configuration for this implementation.
  final CrossAxisAlignment crossAxisAlignment;
/// Stores `mainAxisSize` state/configuration for this implementation.
  final MainAxisSize mainAxisSize;
/// Stores `textDirection` state/configuration for this implementation.
  final TextDirection? textDirection;
/// Stores `verticalDirection` state/configuration for this implementation.
  final VerticalDirection verticalDirection;
/// Stores `textBaseline` state/configuration for this implementation.
  final TextBaseline? textBaseline;

/// Creates a `DensityColumn` instance.
  const DensityColumn({
    super.key,
    this.spacing = 0,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
/// Stores `adjustedSpacing` state/configuration for this implementation.
    final adjustedSpacing = spacing * theme.density.baseGap * theme.scaling;
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      spacing: adjustedSpacing,
      children: children,
    );
  }
}

/// DensityFlex defines a reusable type for this registry module.
class DensityFlex extends StatelessWidget {
/// Stores `direction` state/configuration for this implementation.
  final Axis direction;
/// Stores `spacing` state/configuration for this implementation.
  final double spacing;
/// Stores `children` state/configuration for this implementation.
  final List<Widget> children;
/// Stores `mainAxisAlignment` state/configuration for this implementation.
  final MainAxisAlignment mainAxisAlignment;
/// Stores `crossAxisAlignment` state/configuration for this implementation.
  final CrossAxisAlignment crossAxisAlignment;
/// Stores `mainAxisSize` state/configuration for this implementation.
  final MainAxisSize mainAxisSize;
/// Stores `textDirection` state/configuration for this implementation.
  final TextDirection? textDirection;
/// Stores `verticalDirection` state/configuration for this implementation.
  final VerticalDirection verticalDirection;
/// Stores `textBaseline` state/configuration for this implementation.
  final TextBaseline? textBaseline;
/// Stores `clipBehavior` state/configuration for this implementation.
  final Clip clipBehavior;

/// Creates a `DensityFlex` instance.
  const DensityFlex({
    super.key,
    required this.direction,
    this.spacing = 0,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.clipBehavior = Clip.none,
  });

  @override
/// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
/// Stores `adjustedSpacing` state/configuration for this implementation.
    final adjustedSpacing = spacing * theme.density.baseGap * theme.scaling;
    return Flex(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      clipBehavior: clipBehavior,
      spacing: adjustedSpacing,
      children: children,
    );
  }
}
