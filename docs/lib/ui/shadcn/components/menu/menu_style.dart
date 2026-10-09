// Registry-owned theme data for the `menu` component: [MenuTheme] (item
// rows), [MenuPopupTheme] (the popup surface B20 re-exports) and
// [MenubarTheme] (owned here per OWNERSHIP; the `menubar` component imports
// it and owns only `MenubarState`).
//
// User-owned overrides live in `menu_theme.dart`; CLI updates may replace
// this file.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Item-row contract: shadcn `px-2 py-1.5 text-sm rounded-sm`, hover fill
/// `accent` with `accentForeground` text. Disabled rows are never themed:
/// the row dims to 50% opacity instead.
class MenuTheme extends ComponentThemeData implements Mergeable<MenuTheme> {
  /// Creates a menu item theme.
  const MenuTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.itemPadding,
    this.textStyle,
    this.borderRadius,
    this.subMenuOffset,
  });

  /// Per-state row fill; null draws none.
  final StateValue<ThemedColor>? background;

  /// Per-state label/icon colour.
  final StateValue<ThemedColor>? foreground;

  /// Inner padding of one row; null resolves px-2 py-1.5.
  final EdgeInsetsGeometry? itemPadding;

  /// Label style; its colour is ignored (taken from [foreground]).
  final TextStyle? textStyle;

  /// Row corner radius; null resolves `borderRadiusSm`.
  final BorderRadiusGeometry? borderRadius;

  /// Submenu offset; null resolves Offset(8, -4).
  final Offset? subMenuOffset;

  /// Returns a copy with the given fields replaced.
  MenuTheme copyWith({
    ValueGetter<StateValue<ThemedColor>?>? background,
    ValueGetter<StateValue<ThemedColor>?>? foreground,
    ValueGetter<EdgeInsetsGeometry?>? itemPadding,
    ValueGetter<TextStyle?>? textStyle,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<Offset?>? subMenuOffset,
  }) => MenuTheme(
    themeDensity: themeDensity,
    themeSpacing: themeSpacing,
    themeShadows: themeShadows,
    background: background == null ? this.background : background(),
    foreground: foreground == null ? this.foreground : foreground(),
    itemPadding: itemPadding == null ? this.itemPadding : itemPadding(),
    textStyle: textStyle == null ? this.textStyle : textStyle(),
    borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    subMenuOffset: subMenuOffset == null ? this.subMenuOffset : subMenuOffset(),
  );

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  MenuTheme merge(MenuTheme? fallback) {
    if (fallback == null) return this;
    return MenuTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background?.merge(fallback.background) ?? fallback.background,
      foreground: foreground?.merge(fallback.foreground) ?? fallback.foreground,
      itemPadding: itemPadding ?? fallback.itemPadding,
      textStyle: textStyle == null
          ? fallback.textStyle
          : (fallback.textStyle?.merge(textStyle) ?? textStyle),
      borderRadius: borderRadius ?? fallback.borderRadius,
      subMenuOffset: subMenuOffset ?? fallback.subMenuOffset,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuTheme &&
          other.background == background &&
          other.foreground == foreground &&
          other.itemPadding == itemPadding &&
          other.textStyle == textStyle &&
          other.borderRadius == borderRadius &&
          other.subMenuOffset == subMenuOffset &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    foreground,
    itemPadding,
    textStyle,
    borderRadius,
    subMenuOffset,
  );
}

/// Popup-surface contract (shadcn popover: `bg-popover`, 1px `border`,
/// `rounded-md`, `shadow-md`, `p-1`, min-width 8rem/12rem).
class MenuPopupTheme extends ComponentThemeData
    implements Mergeable<MenuPopupTheme> {
  /// Creates a menu popup theme.
  const MenuPopupTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.foreground,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.minWidth,
    this.surfaceBlur,
  });

  /// Surface fill; null resolves the `popover` token.
  final ThemedColor? background;

  /// Content colour; null resolves `popoverForeground`.
  final ThemedColor? foreground;

  /// Border colour; null resolves the `border` token.
  final ThemedColor? borderColor;

  /// Border width; null resolves 1.0.
  final double? borderWidth;

  /// Corner radius; null resolves `borderRadiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves 4 on all sides.
  final EdgeInsetsGeometry? padding;

  /// Minimum popup width; null resolves 192 (12rem).
  final double? minWidth;

  /// Backdrop blur radius; null resolves the app theme's `surfaceBlur`.
  final double? surfaceBlur;

  /// Returns a copy with the given fields replaced.
  MenuPopupTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? foreground,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<double?>? minWidth,
    ValueGetter<double?>? surfaceBlur,
  }) => MenuPopupTheme(
    themeDensity: themeDensity,
    themeSpacing: themeSpacing,
    themeShadows: themeShadows,
    background: background == null ? this.background : background(),
    foreground: foreground == null ? this.foreground : foreground(),
    borderColor: borderColor == null ? this.borderColor : borderColor(),
    borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
    borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    padding: padding == null ? this.padding : padding(),
    minWidth: minWidth == null ? this.minWidth : minWidth(),
    surfaceBlur: surfaceBlur == null ? this.surfaceBlur : surfaceBlur(),
  );

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  MenuPopupTheme merge(MenuPopupTheme? fallback) {
    if (fallback == null) return this;
    return MenuPopupTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      foreground: foreground ?? fallback.foreground,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      minWidth: minWidth ?? fallback.minWidth,
      surfaceBlur: surfaceBlur ?? fallback.surfaceBlur,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuPopupTheme &&
          other.background == background &&
          other.foreground == foreground &&
          other.borderColor == borderColor &&
          other.borderWidth == borderWidth &&
          other.borderRadius == borderRadius &&
          other.padding == padding &&
          other.minWidth == minWidth &&
          other.surfaceBlur == surfaceBlur &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    foreground,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    minWidth,
    surfaceBlur,
  );
}

/// Bar contract for the `menubar` component (B20 imports this; it owns only
/// `MenubarState`). Bordered by default (shadcn `border bg-background`).
class MenubarTheme extends ComponentThemeData
    implements Mergeable<MenubarTheme> {
  /// Creates a menubar theme.
  const MenubarTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.border,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.subMenuOffset,
  });

  /// Whether the bar draws its border; null resolves true.
  final bool? border;

  /// Bar fill; null resolves the `background` token.
  final ThemedColor? background;

  /// Border colour; null resolves the `border` token.
  final ThemedColor? borderColor;

  /// Border width; null resolves 1.0.
  final double? borderWidth;

  /// Corner radius; null resolves `borderRadiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves 4 on all sides.
  final EdgeInsetsGeometry? padding;

  /// Submenu offset; null resolves Offset(-4, 8).
  final Offset? subMenuOffset;

  /// Returns a copy with the given fields replaced.
  MenubarTheme copyWith({
    ValueGetter<bool?>? border,
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
    ValueGetter<Offset?>? subMenuOffset,
  }) => MenubarTheme(
    themeDensity: themeDensity,
    themeSpacing: themeSpacing,
    themeShadows: themeShadows,
    border: border == null ? this.border : border(),
    background: background == null ? this.background : background(),
    borderColor: borderColor == null ? this.borderColor : borderColor(),
    borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
    borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
    padding: padding == null ? this.padding : padding(),
    subMenuOffset: subMenuOffset == null ? this.subMenuOffset : subMenuOffset(),
  );

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  MenubarTheme merge(MenubarTheme? fallback) {
    if (fallback == null) return this;
    return MenubarTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      border: border ?? fallback.border,
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      subMenuOffset: subMenuOffset ?? fallback.subMenuOffset,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenubarTheme &&
          other.border == border &&
          other.background == background &&
          other.borderColor == borderColor &&
          other.borderWidth == borderWidth &&
          other.borderRadius == borderRadius &&
          other.padding == padding &&
          other.subMenuOffset == subMenuOffset &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    border,
    background,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    subMenuOffset,
  );
}

/// Token-derived baseline rows; every unset override field falls through here.
const MenuTheme menuDefaults = MenuTheme(
  background: StateValue<ThemedColor>(
    rest: ThemedColor.value(Color(0x00000000)),
    hovered: ThemedColor.ref(ColorRef.accent),
    pressed: ThemedColor.ref(ColorRef.accent),
    focused: ThemedColor.ref(ColorRef.accent),
  ),
  foreground: StateValue<ThemedColor>(
    rest: ThemedColor.ref(ColorRef.foreground),
    hovered: ThemedColor.ref(ColorRef.accentForeground),
    pressed: ThemedColor.ref(ColorRef.accentForeground),
    focused: ThemedColor.ref(ColorRef.accentForeground),
  ),
  textStyle: TextStyle(fontSize: 14),
);

/// Token-derived popup baseline.
const MenuPopupTheme menuPopupDefaults = MenuPopupTheme(
  background: ThemedColor.ref(ColorRef.popover),
  foreground: ThemedColor.ref(ColorRef.popoverForeground),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  padding: EdgeInsets.all(4),
  minWidth: 192,
);

/// Token-derived menubar baseline.
const MenubarTheme menubarDefaults = MenubarTheme(
  border: true,
  background: ThemedColor.ref(ColorRef.background),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  padding: EdgeInsets.all(4),
  subMenuOffset: Offset(-4, 8),
);
