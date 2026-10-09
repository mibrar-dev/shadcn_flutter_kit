import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'theme.dart';
import 'tokens.dart';

/// Padding multipliers applied to `density.baseContainerPadding`.
const double padXs = 0.5;
const double padSm = 1.0;
const double padMd = 1.5;
const double padLg = 2.0;
const double padXl = 2.5;
const double pad2xl = 3.0;
const double pad3xl = 3.5;
const double pad4xl = 4.0;

/// Gap multipliers applied to `density.baseGap`.
const double gapXs = 0.5;
const double gapSm = 1.0;
const double gapMd = 1.5;
const double gapLg = 2.0;
const double gapXl = 2.5;
const double gap2xl = 3.0;
const double gap3xl = 3.5;
const double gap4xl = 4.0;

/// Density bases for container padding, content padding and gaps.
class Density {
  const Density({
    required this.baseContainerPadding,
    required this.baseGap,
    required this.baseContentPadding,
  });

  static const Density defaultDensity = Density(
    baseContainerPadding: 16.0,
    baseGap: 8.0,
    baseContentPadding: 16.0,
  );
  static const Density reducedDensity = Density(
    baseContainerPadding: 12.0,
    baseGap: 6.0,
    baseContentPadding: 12.0,
  );
  static const Density spaciousDensity = Density(
    baseContainerPadding: 20.0,
    baseGap: 10.0,
    baseContentPadding: 20.0,
  );
  static const Density compactDensity = Density(
    baseContainerPadding: 8.0,
    baseGap: 4.0,
    baseContentPadding: 8.0,
  );

  /// Preset-spacing bridge: container/content = base * 4, gap = base * 2.
  factory Density.fromSpacingScale(SpacingScale spacing) {
    return Density(
      baseContainerPadding: spacing.base * 4,
      baseGap: spacing.base * 2,
      baseContentPadding: spacing.base * 4,
    );
  }

  final double baseContainerPadding;
  final double baseGap;
  final double baseContentPadding;

  SpacingScale toSpacingScale() => SpacingScale(baseGap / 2);

  Density copyWith({
    double? baseContainerPadding,
    double? baseGap,
    double? baseContentPadding,
  }) {
    return Density(
      baseContainerPadding: baseContainerPadding ?? this.baseContainerPadding,
      baseGap: baseGap ?? this.baseGap,
      baseContentPadding: baseContentPadding ?? this.baseContentPadding,
    );
  }

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Density &&
          other.baseContainerPadding == baseContainerPadding &&
          other.baseGap == baseGap &&
          other.baseContentPadding == baseContentPadding;
  @override
  int get hashCode =>
      Object.hash(baseContainerPadding, baseGap, baseContentPadding);
}

/// Padding whose multipliers resolve against a density base at build.
abstract interface class DensityEdgeInsetsGeometry extends EdgeInsetsGeometry {
  /// Resolves multipliers against [basePadding].
  EdgeInsetsGeometry resolveDensity(double basePadding);
}

/// Directional padding with density multipliers.
class DirectionalEdgeInsetsDensity extends EdgeInsetsDirectional
    implements DensityEdgeInsetsGeometry {
  const DirectionalEdgeInsetsDensity.only({
    super.start = 0.0,
    super.top = 0.0,
    super.end = 0.0,
    super.bottom = 0.0,
  }) : super.only();

  const DirectionalEdgeInsetsDensity.all(super.value) : super.all();

  const DirectionalEdgeInsetsDensity.symmetric({
    super.vertical = 0.0,
    super.horizontal = 0.0,
  }) : super.symmetric();

  @override
  EdgeInsetsDirectional resolveDensity(double basePadding) {
    return EdgeInsetsDirectional.only(
      start: start * basePadding,
      top: top * basePadding,
      end: end * basePadding,
      bottom: bottom * basePadding,
    );
  }
}

/// Padding with density multipliers.
class EdgeInsetsDensity extends EdgeInsets
    implements DensityEdgeInsetsGeometry {
  const EdgeInsetsDensity.only({
    super.left = 0.0,
    super.top = 0.0,
    super.right = 0.0,
    super.bottom = 0.0,
  }) : super.only();

  const EdgeInsetsDensity.all(super.value) : super.all();

  const EdgeInsetsDensity.symmetric({
    super.vertical = 0.0,
    super.horizontal = 0.0,
  }) : super.symmetric();
  @override
  EdgeInsets resolveDensity(double basePadding) {
    return EdgeInsets.only(
      left: left * basePadding,
      right: right * basePadding,
      top: top * basePadding,
      bottom: bottom * basePadding,
    );
  }
}

/// Resolves density-multiplier padding, passing other padding through.
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

/// Padding resolved against content density and ambient scaling.
class DensityContentPadding extends StatelessWidget {
  const DensityContentPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: resolveEdgeInsets(
        padding,
        theme.density.baseContentPadding * theme.scaling,
      ),
      child: child,
    );
  }
}

/// Padding resolved against container density and ambient scaling.
class DensityContainerPadding extends StatelessWidget {
  const DensityContainerPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return Padding(
      padding: resolveEdgeInsets(
        padding,
        theme.density.baseContainerPadding * theme.scaling,
      ),
      child: child,
    );
  }
}

/// Per-axis scaling factors for adaptive layouts.
class AdaptiveScaling {
  static const AdaptiveScaling desktop = AdaptiveScaling();
  static const AdaptiveScaling mobile = AdaptiveScaling(1.25);

  final double radiusScaling;
  final double sizeScaling;
  final double textScaling;

  const AdaptiveScaling([double scaling = 1])
    : this.only(
        radiusScaling: scaling,
        sizeScaling: scaling,
        textScaling: scaling,
      );

  const AdaptiveScaling.only({
    this.radiusScaling = 1,
    this.sizeScaling = 1,
    this.textScaling = 1,
  });

  /// Returns a copy of [theme] with radius/sizing/typography/icon sizes
  /// scaled. Takes [ShadcnThemeData] (new tree) — same factors as before.
  ShadcnThemeData scale(ShadcnThemeData theme) {
    return theme.copyWith(
      tokens: radiusScaling == 1
          ? null
          : () => theme.tokens.copyWith(
              radius: theme.tokens.radius * radiusScaling,
            ),
      scaling: sizeScaling == 1 ? null : () => theme.scaling * sizeScaling,
      typography: textScaling == 1
          ? null
          : () => theme.typography.scale(textScaling),
      iconTheme: textScaling == 1
          ? null
          : () => theme.iconTheme.scale(textScaling),
    );
  }

  static AdaptiveScaling lerp(AdaptiveScaling a, AdaptiveScaling b, double t) {
    return AdaptiveScaling.only(
      radiusScaling: lerpDouble(a.radiusScaling, b.radiusScaling, t)!,
      sizeScaling: lerpDouble(a.sizeScaling, b.sizeScaling, t)!,
      textScaling: lerpDouble(a.textScaling, b.textScaling, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdaptiveScaling &&
          other.radiusScaling == radiusScaling &&
          other.sizeScaling == sizeScaling &&
          other.textScaling == textScaling;
  @override
  int get hashCode => Object.hash(radiusScaling, sizeScaling, textScaling);
}

/// Applies [scaling] to the ambient theme for its subtree.
class AdaptiveScaler extends StatelessWidget {
  const AdaptiveScaler({super.key, required this.scaling, required this.child});

  /// Mobile scaling on iOS/Android, desktop elsewhere.
  static AdaptiveScaling defaultScalingOf(BuildContext context) {
    return defaultScaling(ShadcnTheme.of(context));
  }

  /// Mobile scaling on iOS/Android, desktop elsewhere.
  static AdaptiveScaling defaultScaling(ShadcnThemeData theme) {
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.android:
        return AdaptiveScaling.mobile;
      default:
        return AdaptiveScaling.desktop;
    }
  }

  final AdaptiveScaling scaling;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
    return ShadcnTheme(data: scaling.scale(theme), child: child);
  }
}
