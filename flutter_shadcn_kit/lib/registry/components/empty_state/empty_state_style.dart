// Registry-owned theme data for the `empty_state` component: the
// [EmptyStateTheme] container, the [EmptyStateSize] scale, the token-derived
// [emptyStateDefaults] and the per-size lookup tables.
//
// shadcn empty state: a muted icon in a rounded container, a semibold title, a
// muted description clamped to a readable measure, and up to three actions. The
// compact size drops the whole thing onto a `Card` surface; the full-page size
// centres it in the available space. User-owned overrides live in
// `empty_state_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Presentation scale of an empty state.
///
/// `compact` is the inline variant (a card inside a panel, smaller type and
/// icon); `fullPage` is the route-level variant.
enum EmptyStateSize {
  compact,
  fullPage;

  /// Whether this size draws its own surface. The compact size is a card inside
  /// a panel; the full-page size centres in the available space.
  bool get hasSurface => this == EmptyStateSize.compact;

  /// Whether the icon sits in the muted container.
  bool get hasIconContainer => true;
}

/// Every metric one [EmptyStateSize] resolves.
class EmptyStateMetrics {
  /// Creates a metrics slice.
  const EmptyStateMetrics({
    required this.iconSize,
    required this.titleStyle,
    required this.descriptionStyle,
    required this.padding,
    required this.contentGap,
    required this.titleGap,
    required this.actionGap,
    required this.actionSpacing,
    required this.maxWidth,
    required this.descriptionMaxWidth,
    this.iconContainerPadding,
    this.iconContainerBorderRadius,
  });

  /// Icon side.
  final double iconSize;

  /// Title text style.
  final TextStyle titleStyle;

  /// Description text style.
  final TextStyle descriptionStyle;

  /// Padding around the whole block; the size table stores density
  /// multipliers, resolved by [emptyStateMetrics].
  final EdgeInsetsGeometry padding;

  /// Space between the icon block and the title.
  final double contentGap;

  /// Space between the title and the description.
  final double titleGap;

  /// Space above the action row.
  final double actionGap;

  /// Horizontal gap between two actions.
  final double actionSpacing;

  /// Clamp of the whole block.
  final double maxWidth;

  /// Clamp of the description measure.
  final double descriptionMaxWidth;

  /// Padding inside the icon container; null falls through to the theme field
  /// and then to the size table, whose value is a density multiplier resolved
  /// by [emptyStateMetrics].
  final EdgeInsetsGeometry? iconContainerPadding;

  /// Corner radius of the icon container; null falls through to the theme field
  /// and then to the size table.
  final BorderRadiusGeometry? iconContainerBorderRadius;
}

/// Styling of the `empty_state` block.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields. Colours are
/// [ThemedColor]s so they resolve against the ambient palette rather than
/// being frozen at construction.
class EmptyStateTheme extends ComponentThemeData
    implements Mergeable<EmptyStateTheme> {
  /// Creates an empty-state theme.
  const EmptyStateTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.iconColor,
    this.iconContainerBackground,
    this.iconContainerBorderColor,
    this.iconContainerPadding,
    this.iconContainerBorderRadius,
    this.titleStyle,
    this.descriptionStyle,
    this.padding,
    this.maxWidth,
    this.metrics,
    this.surface,
  });

  /// Icon colour; null falls back to `mutedForeground`.
  final ThemedColor? iconColor;

  /// Fill of the icon container; null falls back to `muted`.
  final ThemedColor? iconContainerBackground;

  /// Border colour of the icon container; null falls back to `border`.
  final ThemedColor? iconContainerBorderColor;

  /// Padding inside the icon container.
  final EdgeInsetsGeometry? iconContainerPadding;

  /// Corner radius of the icon container.
  final BorderRadiusGeometry? iconContainerBorderRadius;

  /// Title text style; the size table's style is used when null.
  final TextStyle? titleStyle;

  /// Description text style; the size table's style is used when null.
  final TextStyle? descriptionStyle;

  /// Padding around the whole block; the size table's is used when null.
  final EdgeInsetsGeometry? padding;

  /// Clamp of the whole block; the size table's is used when null.
  final double? maxWidth;

  /// Per-size metric overrides; a size the caller does not list falls through
  /// to [emptyStateDefaults].
  final Map<EmptyStateSize, EmptyStateMetrics>? metrics;

  /// Fill of the compact surface; null draws no surface (full-page style).
  final ThemedColor? surface;

  /// The metrics for [size]: this leg's slice for that size when it lists one,
  /// otherwise the token-derived table entry. A listed slice wins as a whole,
  /// so a restyled size is never half-default. The top-level
  /// [iconContainerPadding]/[iconContainerBorderRadius] legs win over the size
  /// table, so an explicit widget/container leg is never shadowed by it.
  EmptyStateMetrics metricsFor(EmptyStateSize size, ShadcnThemeData theme) {
    final EmptyStateMetrics fallback = emptyStateMetrics(size, theme);
    final EmptyStateMetrics? override = metrics?[size];
    if (override == null) {
      if (iconContainerPadding == null && iconContainerBorderRadius == null) {
        return fallback;
      }
      return EmptyStateMetrics(
        iconSize: fallback.iconSize,
        titleStyle: fallback.titleStyle,
        descriptionStyle: fallback.descriptionStyle,
        padding: fallback.padding,
        contentGap: fallback.contentGap,
        titleGap: fallback.titleGap,
        actionGap: fallback.actionGap,
        actionSpacing: fallback.actionSpacing,
        maxWidth: fallback.maxWidth,
        descriptionMaxWidth: fallback.descriptionMaxWidth,
        iconContainerPadding:
            iconContainerPadding ?? fallback.iconContainerPadding,
        iconContainerBorderRadius:
            iconContainerBorderRadius ?? fallback.iconContainerBorderRadius,
      );
    }
    return EmptyStateMetrics(
      iconSize: override.iconSize,
      titleStyle: override.titleStyle,
      descriptionStyle: override.descriptionStyle,
      padding: override.padding,
      contentGap: override.contentGap,
      titleGap: override.titleGap,
      actionGap: override.actionGap,
      actionSpacing: override.actionSpacing,
      maxWidth: override.maxWidth,
      descriptionMaxWidth: override.descriptionMaxWidth,
      iconContainerPadding:
          override.iconContainerPadding ??
          iconContainerPadding ??
          fallback.iconContainerPadding,
      iconContainerBorderRadius:
          override.iconContainerBorderRadius ??
          iconContainerBorderRadius ??
          fallback.iconContainerBorderRadius,
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  EmptyStateTheme merge(EmptyStateTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return EmptyStateTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      iconColor: iconColor ?? fallback.iconColor,
      iconContainerBackground:
          iconContainerBackground ?? fallback.iconContainerBackground,
      iconContainerBorderColor:
          iconContainerBorderColor ?? fallback.iconContainerBorderColor,
      iconContainerPadding:
          iconContainerPadding ?? fallback.iconContainerPadding,
      iconContainerBorderRadius:
          iconContainerBorderRadius ?? fallback.iconContainerBorderRadius,
      titleStyle: titleStyle == null
          ? fallback.titleStyle
          : (fallback.titleStyle?.merge(titleStyle) ?? titleStyle),
      descriptionStyle: descriptionStyle == null
          ? fallback.descriptionStyle
          : (fallback.descriptionStyle?.merge(descriptionStyle) ??
                descriptionStyle),
      padding: padding ?? fallback.padding,
      maxWidth: maxWidth ?? fallback.maxWidth,
      metrics: metrics ?? fallback.metrics,
      surface: surface ?? fallback.surface,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is EmptyStateTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.iconColor == iconColor &&
        other.iconContainerBackground == iconContainerBackground &&
        other.iconContainerBorderColor == iconContainerBorderColor &&
        other.iconContainerPadding == iconContainerPadding &&
        other.iconContainerBorderRadius == iconContainerBorderRadius &&
        other.titleStyle == titleStyle &&
        other.descriptionStyle == descriptionStyle &&
        other.padding == padding &&
        other.maxWidth == maxWidth &&
        other.metrics == metrics &&
        other.surface == surface;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    iconColor,
    iconContainerBackground,
    iconContainerBorderColor,
    iconContainerPadding,
    iconContainerBorderRadius,
    titleStyle,
    descriptionStyle,
    padding,
    maxWidth,
    metrics,
    surface,
  );
}

// ---------------------------------------------------------------------------
// Size table (token-derived, exhaustive over EmptyStateSize).
// ---------------------------------------------------------------------------

/// Metrics of the inline `compact` size.
const EmptyStateMetrics _compactMetrics = EmptyStateMetrics(
  iconSize: 28,
  titleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  descriptionStyle: TextStyle(fontSize: 14, height: 1.35),
  // shadcn `p-6`, density-scaled.
  padding: EdgeInsetsDensity.pxAll(24),
  contentGap: 16,
  titleGap: 8,
  actionGap: 16,
  actionSpacing: 12,
  maxWidth: 420,
  descriptionMaxWidth: 420,
  // shadcn `p-2.5`, density-scaled.
  iconContainerPadding: EdgeInsetsDensity.pxAll(10),
  iconContainerBorderRadius: BorderRadius.all(Radius.circular(14)),
);

/// Metrics of the route-level `fullPage` size.
const EmptyStateMetrics _fullPageMetrics = EmptyStateMetrics(
  iconSize: 36,
  titleStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
  descriptionStyle: TextStyle(fontSize: 14, height: 1.35),
  // shadcn `p-8`, density-scaled.
  padding: EdgeInsetsDensity.pxAll(32),
  contentGap: 24,
  titleGap: 12,
  actionGap: 24,
  actionSpacing: 12,
  maxWidth: 520,
  descriptionMaxWidth: 520,
  // shadcn `p-3`, density-scaled.
  iconContainerPadding: EdgeInsetsDensity.pxAll(12),
  iconContainerBorderRadius: BorderRadius.all(Radius.circular(14)),
);

/// The uniform radius of [radius]; the size table only uses `all`, so this is
/// exact rather than an approximation.
double _radius(BorderRadiusGeometry radius) =>
    radius.resolve(TextDirection.ltr).topLeft.x;

/// The size table for [size], with the ambient foreground and muted colours
/// already resolved.
///
/// Colours are applied here rather than stored on the theme so a theme leg can
/// override a single colour without restating the whole [TextStyle].
EmptyStateMetrics emptyStateMetrics(
  EmptyStateSize size,
  ShadcnThemeData theme,
) {
  final EmptyStateMetrics base = switch (size) {
    EmptyStateSize.compact => _compactMetrics,
    EmptyStateSize.fullPage => _fullPageMetrics,
  };
  return EmptyStateMetrics(
    iconSize: base.iconSize * theme.scaling,
    titleStyle: base.titleStyle.copyWith(color: theme.colors.foreground),
    descriptionStyle: base.descriptionStyle.copyWith(
      color: theme.colors.mutedForeground,
    ),
    padding: resolveEdgeInsets(
      base.padding,
      theme.density.baseContentPadding * theme.scaling,
    ),
    contentGap: base.contentGap * theme.scaling,
    titleGap: base.titleGap * theme.scaling,
    actionGap: base.actionGap * theme.scaling,
    actionSpacing: base.actionSpacing * theme.scaling,
    maxWidth: base.maxWidth * theme.scaling,
    descriptionMaxWidth: base.descriptionMaxWidth * theme.scaling,
    iconContainerPadding: resolveEdgeInsets(
      base.iconContainerPadding!,
      theme.density.baseContentPadding * theme.scaling,
    ),
    iconContainerBorderRadius: BorderRadius.circular(
      _radius(base.iconContainerBorderRadius!) * theme.scaling,
    ),
  );
}

/// Token-derived baseline values; unset override fields fall through here.
///
/// `surface` is deliberately null: the full-page size draws no surface, and the
/// compact size follows the ambient `card` token.
const EmptyStateTheme emptyStateDefaults = EmptyStateTheme(
  iconColor: ThemedColor.ref(ColorRef.mutedForeground),
  iconContainerBackground: ThemedColor.ref(ColorRef.muted),
  iconContainerBorderColor: ThemedColor.ref(ColorRef.border),
);
