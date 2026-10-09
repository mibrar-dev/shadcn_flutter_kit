// Registry-owned theme data for the `command` component: the [CommandTheme]
// container with the surface, item and dialog-size fields plus the token-
// derived `commandDefaults`.
//
// User-owned overrides live in `command_theme.dart`; CLI updates may replace
// this file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme container for the command palette.
class CommandTheme extends ComponentThemeData
    implements Mergeable<CommandTheme> {
  /// Creates a command theme.
  const CommandTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.mutedForeground,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.itemHighlight,
    this.itemHighlightForeground,
    this.itemPadding,
    this.shadows,
    this.maxWidth,
    this.maxHeight,
  });

  /// Palette surface fill.
  final ThemedColor? background;

  /// Item title colour.
  final ThemedColor? foreground;

  /// Empty/loading/footer text colour.
  final ThemedColor? mutedForeground;

  /// Surface border colour; null draws no border.
  final ThemedColor? borderColor;

  /// Surface border width.
  final double? borderWidth;

  /// Surface corner radius; null falls back to `theme.borderRadiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Padding around the search field and result list.
  final EdgeInsetsGeometry? padding;

  /// Background of the item under SubFocus.
  final ThemedColor? itemHighlight;

  /// Text/icon colour while an item is highlighted.
  final ThemedColor? itemHighlightForeground;

  /// Padding inside one result row.
  final EdgeInsetsGeometry? itemPadding;

  /// Surface shadows; empty draws none.
  final List<BoxShadow>? shadows;

  /// Dialog width used by `showCommandDialog` when no constraints are given.
  final double? maxWidth;

  /// Dialog height used by `showCommandDialog` when no constraints are given.
  final double? maxHeight;

  /// Returns a copy with the given fields replaced.
  CommandTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? foreground,
    ValueGetter<ThemedColor?>? mutedForeground,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<ThemedColor?>? itemHighlight,
    ValueGetter<ThemedColor?>? itemHighlightForeground,
    ValueGetter<EdgeInsetsGeometry?>? itemPadding,
    ValueGetter<List<BoxShadow>?>? shadows,
    ValueGetter<double?>? maxWidth,
    ValueGetter<double?>? maxHeight,
  }) {
    return CommandTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      foreground: foreground == null ? this.foreground : foreground(),
      mutedForeground: mutedForeground == null
          ? this.mutedForeground
          : mutedForeground(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
      itemHighlight: itemHighlight == null
          ? this.itemHighlight
          : itemHighlight(),
      itemHighlightForeground: itemHighlightForeground == null
          ? this.itemHighlightForeground
          : itemHighlightForeground(),
      itemPadding: itemPadding == null ? this.itemPadding : itemPadding(),
      shadows: shadows == null ? this.shadows : shadows(),
      maxWidth: maxWidth == null ? this.maxWidth : maxWidth(),
      maxHeight: maxHeight == null ? this.maxHeight : maxHeight(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  CommandTheme merge(CommandTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return CommandTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      mutedForeground: mutedForeground ?? fallback.mutedForeground,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      itemHighlight: itemHighlight ?? fallback.itemHighlight,
      itemHighlightForeground:
          itemHighlightForeground ?? fallback.itemHighlightForeground,
      itemPadding: itemPadding ?? fallback.itemPadding,
      shadows: shadows ?? fallback.shadows,
      maxWidth: maxWidth ?? fallback.maxWidth,
      maxHeight: maxHeight ?? fallback.maxHeight,
    );
  }

  /// Lerps scalar fields; token references and lists step at t < 0.5.
  static CommandTheme lerp(CommandTheme a, CommandTheme b, double t) {
    return CommandTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      foreground: t < 0.5 ? a.foreground : b.foreground,
      mutedForeground: t < 0.5 ? a.mutedForeground : b.mutedForeground,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      itemHighlight: t < 0.5 ? a.itemHighlight : b.itemHighlight,
      itemHighlightForeground: t < 0.5
          ? a.itemHighlightForeground
          : b.itemHighlightForeground,
      itemPadding: EdgeInsetsGeometry.lerp(a.itemPadding, b.itemPadding, t),
      shadows: t < 0.5 ? a.shadows : b.shadows,
      maxWidth: lerpDouble(a.maxWidth, b.maxWidth, t),
      maxHeight: lerpDouble(a.maxHeight, b.maxHeight, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is CommandTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.foreground == foreground &&
        other.mutedForeground == mutedForeground &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.itemHighlight == itemHighlight &&
        other.itemHighlightForeground == itemHighlightForeground &&
        other.itemPadding == itemPadding &&
        _sameShadows(other.shadows, shadows) &&
        other.maxWidth == maxWidth &&
        other.maxHeight == maxHeight;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    foreground,
    mutedForeground,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    itemHighlight,
    itemHighlightForeground,
    itemPadding,
    shadows == null ? null : Object.hashAll(shadows!),
    maxWidth,
    maxHeight,
  );

  static bool _sameShadows(List<BoxShadow>? a, List<BoxShadow>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null || a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i += 1) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }
}

/// Default item padding: 8/6.
const EdgeInsetsGeometry commandDefaultItemPadding = EdgeInsets.symmetric(
  horizontal: 8,
  vertical: 6,
);

/// Token-derived baseline; every unset override field falls through here.
const CommandTheme commandDefaults = CommandTheme(
  background: ThemedColor.ref(ColorRef.popover),
  foreground: ThemedColor.ref(ColorRef.foreground),
  mutedForeground: ThemedColor.ref(ColorRef.mutedForeground),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  padding: EdgeInsets.all(4),
  itemHighlight: ThemedColor.ref(ColorRef.accent),
  itemHighlightForeground: ThemedColor.ref(ColorRef.accentForeground),
  itemPadding: commandDefaultItemPadding,
  maxWidth: 510,
  maxHeight: 349,
);

/// A keyboard-shortcut label for a command row.
///
/// shadcn's `CommandShortcut`: extra-small type, wide tracking, muted colour,
/// right-aligned. Pass it as the `trailing` widget of a `SubFocusListItem`
/// (the expanded title pushes it to the trailing edge); keyboard-*key* visuals
/// beyond this text belong to the `keyboard_shortcut` component.
class CommandShortcut extends StatelessWidget {
  /// Creates a shortcut label, e.g. `'⌘K'` or `'Enter'`.
  const CommandShortcut({super.key, required this.label});

  /// The shortcut text.
  final String label;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final CommandTheme resolved =
        resolveComponentStyle<CommandTheme, CommandTheme>(
          context,
          select: (t) => t,
          defaults: commandDefaults,
        );
    final Color color =
        resolved.mutedForeground?.resolve(theme.colors) ??
        theme.colors.mutedForeground;
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Text(
        label,
        textAlign: TextAlign.end,
        style: theme.typography.xSmall.copyWith(
          color: color,
          // shadcn `tracking-widest` (0.1em); preset tracking wins when set.
          letterSpacing: theme.tracking.wide ?? 1.2,
        ),
      ),
    );
  }
}
