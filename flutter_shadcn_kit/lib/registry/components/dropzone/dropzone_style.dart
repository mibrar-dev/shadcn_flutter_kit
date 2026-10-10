// Registry-owned theme data for the `dropzone` component: the
// [DropzoneTheme] surface, the [DropzoneState] table and the token-derived
// [dropzoneDefaults].
//
// shadcn dropzone: a dashed-looking outline drawn as a plain 1px border (the kit
// has no dashed primitive), a muted icon, a status line, an optional hint, and
// an outline browse button. The border colour is the only thing that changes
// per state, so the whole surface never moves. User-owned overrides live in
// `dropzone_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Visual state of a dropzone surface.
///
/// The widget owns none of these transitions: the caller drives them from the
/// drag stream and the upload result.
enum DropzoneState {
  /// Nothing is happening.
  idle,

  /// A drag is hovering over the surface.
  dragging,

  /// Files are being written.
  uploading,

  /// The upload finished.
  success,

  /// The upload failed or the files did not validate.
  error,

  /// The surface does not accept input.
  disabled;

  /// Border colour token for this state; null draws no border.
  ColorRef? get borderRef => switch (this) {
    DropzoneState.idle => null,
    DropzoneState.dragging => ColorRef.primary,
    DropzoneState.uploading => ColorRef.primary,
    DropzoneState.success => ColorRef.accent,
    DropzoneState.error => ColorRef.destructive,
    DropzoneState.disabled => null,
  };
}

/// Styling of the dropzone surface.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class DropzoneTheme extends ComponentThemeData
    implements Mergeable<DropzoneTheme> {
  /// Creates a dropzone theme.
  const DropzoneTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.dragBorder,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.minHeight,
    this.iconColor,
    this.iconSize,
    this.statusStyle,
    this.hintStyle,
    this.gap,
    this.hintGap,
    this.actionGap,
    this.focusRingColor,
    this.focusRingSpread,
    this.hoverScale,
    this.duration,
  });

  /// Surface fill; null draws no fill (the ambient background shows through).
  final ThemedColor? background;

  /// Per-state border colour; a state's own colour wins over this.
  final StateValue<ThemedColor>? borderColor;

  /// Border colour while a drag hovers over the surface; null falls back to
  /// the `hovered` row of [borderColor], then to [DropzoneState.dragging]'s
  /// token.
  final ThemedColor? dragBorder;

  /// Border width; null resolves 1.
  final double? borderWidth;

  /// Corner radius; null resolves the ambient `radiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves `p-6` (24), density-scaled.
  final EdgeInsetsGeometry? padding;

  /// Minimum height; null resolves 0 (the surface hugs its content).
  final double? minHeight;

  /// Icon colour; null resolves `mutedForeground`.
  final ThemedColor? iconColor;

  /// Icon side; null resolves 28.
  final double? iconSize;

  /// Status line style; its colour falls back to `mutedForeground`.
  final TextStyle? statusStyle;

  /// Hint line style; its colour falls back to `mutedForeground`.
  final TextStyle? hintStyle;

  /// Space between the icon, the status line and the action; null resolves 16.
  final double? gap;

  /// Space between the status line and the hint; null resolves 4.
  final double? hintGap;

  /// Space between the hint and the action; null resolves 24.
  final double? actionGap;

  /// Focus ring colour; null resolves `ring`.
  final ThemedColor? focusRingColor;

  /// Focus ring spread; null resolves 2.
  final double? focusRingSpread;

  /// Icon scale while a drag hovers; null resolves 1.05.
  final double? hoverScale;

  /// Animation duration; null resolves 150ms.
  final Duration? duration;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  DropzoneTheme merge(DropzoneTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return DropzoneTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      minHeight: minHeight ?? fallback.minHeight,
      iconColor: iconColor ?? fallback.iconColor,
      iconSize: iconSize ?? fallback.iconSize,
      statusStyle: statusStyle == null
          ? fallback.statusStyle
          : (fallback.statusStyle?.merge(statusStyle) ?? statusStyle),
      hintStyle: hintStyle == null
          ? fallback.hintStyle
          : (fallback.hintStyle?.merge(hintStyle) ?? hintStyle),
      gap: gap ?? fallback.gap,
      hintGap: hintGap ?? fallback.hintGap,
      actionGap: actionGap ?? fallback.actionGap,
      focusRingColor: focusRingColor ?? fallback.focusRingColor,
      focusRingSpread: focusRingSpread ?? fallback.focusRingSpread,
      hoverScale: hoverScale ?? fallback.hoverScale,
      duration: duration ?? fallback.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is DropzoneTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.dragBorder == dragBorder &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.minHeight == minHeight &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize &&
        other.statusStyle == statusStyle &&
        other.hintStyle == hintStyle &&
        other.gap == gap &&
        other.hintGap == hintGap &&
        other.actionGap == actionGap &&
        other.focusRingColor == focusRingColor &&
        other.focusRingSpread == focusRingSpread &&
        other.hoverScale == hoverScale &&
        other.duration == duration;
  }

  @override
  // `Object.hash` takes at most 20 positional arguments, so the three
  // ambient-theme legs are folded into one sub-hash.
  int get hashCode => Object.hashAll(<Object?>[
    Object.hash(themeDensity, themeSpacing, themeShadows),
    background,
    borderColor,
    dragBorder,
    borderWidth,
    borderRadius,
    padding,
    minHeight,
    iconColor,
    iconSize,
    statusStyle,
    hintStyle,
    gap,
    hintGap,
    actionGap,
    focusRingColor,
    focusRingSpread,
    hoverScale,
    duration,
  ]);
}

/// Default animation duration for the surface transitions.
const Duration dropzoneDefaultDuration = Duration(milliseconds: 150);

/// Surface padding: shadcn `p-6` (24px), density-scaled.
const EdgeInsetsGeometry dropzoneDefaultPadding = EdgeInsetsDensity.pxAll(24);

/// Token-derived baseline values; unset override fields fall through here.
///
/// `borderColor` is set per state from the token table, so the `rest` entry is
/// deliberately null: an idle dropzone has no border colour of its own and
/// follows the ambient `border` token.
const DropzoneTheme dropzoneDefaults = DropzoneTheme(
  dragBorder: ThemedColor.ref(ColorRef.primary),
  borderColor: StateValue(
    rest: ThemedColor.ref(ColorRef.border),
    hovered: ThemedColor.ref(ColorRef.border),
    focused: ThemedColor.ref(ColorRef.border),
    disabled: ThemedColor.ref(ColorRef.border),
  ),
  borderWidth: 1,
  padding: dropzoneDefaultPadding,
  iconColor: ThemedColor.ref(ColorRef.mutedForeground),
  iconSize: 28,
  statusStyle: TextStyle(fontSize: 14),
  hintStyle: TextStyle(fontSize: 12),
  gap: 16,
  hintGap: 4,
  actionGap: 24,
  focusRingColor: ThemedColor.ref(ColorRef.ring),
  focusRingSpread: 2,
  hoverScale: 1.05,
  duration: dropzoneDefaultDuration,
);
