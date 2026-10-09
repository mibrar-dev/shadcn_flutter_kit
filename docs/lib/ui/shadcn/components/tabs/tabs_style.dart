// Registry-owned theme data for `tabs`: [TabsTheme] (pill strip) and
// [TabPaneTheme] (sortable bar + content card). Container builders live in
// `primitives/tab_container.dart`. User overrides live in `tabs_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../primitives/tab_container.dart' show TabBuilder, TabChildBuilder;
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Default builders for [TabContainer]; null means the built-in layout.
class TabContainerTheme extends ComponentThemeData
    implements Mergeable<TabContainerTheme> {
  /// Creates a container theme.
  const TabContainerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.builder,
    this.childBuilder,
  });

  /// Default layout builder; null lays children in a column.
  final TabBuilder? builder;

  /// Default wrapper per tab child; null passes children through.
  final TabChildBuilder? childBuilder;

  /// Returns a copy with the given builders replaced.
  TabContainerTheme copyWith({
    ValueGetter<TabBuilder?>? builder,
    ValueGetter<TabChildBuilder?>? childBuilder,
  }) {
    return TabContainerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      builder: builder == null ? this.builder : builder(),
      childBuilder: childBuilder == null ? this.childBuilder : childBuilder(),
    );
  }

  /// Receiver wins per field.
  @override
  TabContainerTheme merge(TabContainerTheme? fallback) {
    if (fallback == null) return this;
    return TabContainerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      builder: builder ?? fallback.builder,
      childBuilder: childBuilder ?? fallback.childBuilder,
    );
  }

  /// Builders step at `t = 0.5`.
  static TabContainerTheme lerp(
    TabContainerTheme a,
    TabContainerTheme b,
    double t,
  ) {
    return TabContainerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      builder: t < 0.5 ? a.builder : b.builder,
      childBuilder: t < 0.5 ? a.childBuilder : b.childBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabContainerTheme &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows &&
          other.builder == builder &&
          other.childBuilder == childBuilder;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    builder,
    childBuilder,
  );
}

/// Empty container defaults; the widget supplies the built-in layout.
const TabContainerTheme tabContainerDefaults = TabContainerTheme();

/// Theme of the [Tabs] pill strip. All fields nullable; null falls through.
class TabsTheme extends ComponentThemeData implements Mergeable<TabsTheme> {
  /// Creates a tabs theme.
  const TabsTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.containerColor,
    this.containerPadding,
    this.borderRadius,
    this.tabPadding,
    this.selectedColor,
    this.labelColor,
    this.selectedLabelColor,
    this.textStyle,
  });

  /// Strip fill. Default: `muted`.
  final StateValue<ThemedColor>? containerColor;

  /// Strip padding. Default: all 3 (p-[3px]).
  final EdgeInsetsGeometry? containerPadding;

  /// Strip and selected-tab radius. Default: ambient `radiusLg`/`radiusMd`.
  final BorderRadiusGeometry? borderRadius;

  /// Tab padding, horizontal only (px-2); the label centers in the 30px
  /// trigger, so vertical padding would only stack on top of it.
  final EdgeInsetsGeometry? tabPadding;

  /// Selected tab fill. Default: `background`.
  final StateValue<ThemedColor>? selectedColor;

  /// Unselected label. Default: `mutedForeground`.
  final StateValue<ThemedColor>? labelColor;

  /// Selected label. Default: `foreground`.
  final StateValue<ThemedColor>? selectedLabelColor;

  /// Label style (colour ignored). Default: 14 w500.
  final TextStyle? textStyle;

  /// Returns a copy with the given rows replaced.
  TabsTheme copyWith({
    ValueGetter<StateValue<ThemedColor>?>? containerColor,
    ValueGetter<EdgeInsetsGeometry?>? containerPadding,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? tabPadding,
    ValueGetter<StateValue<ThemedColor>?>? selectedColor,
    ValueGetter<StateValue<ThemedColor>?>? labelColor,
    ValueGetter<StateValue<ThemedColor>?>? selectedLabelColor,
    ValueGetter<TextStyle?>? textStyle,
  }) {
    return TabsTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      containerColor: containerColor == null
          ? this.containerColor
          : containerColor(),
      containerPadding: containerPadding == null
          ? this.containerPadding
          : containerPadding(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      tabPadding: tabPadding == null ? this.tabPadding : tabPadding(),
      selectedColor: selectedColor == null
          ? this.selectedColor
          : selectedColor(),
      labelColor: labelColor == null ? this.labelColor : labelColor(),
      selectedLabelColor: selectedLabelColor == null
          ? this.selectedLabelColor
          : selectedLabelColor(),
      textStyle: textStyle == null ? this.textStyle : textStyle(),
    );
  }

  /// Receiver wins per field.
  @override
  TabsTheme merge(TabsTheme? fallback) {
    if (fallback == null) return this;
    return TabsTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      containerColor:
          containerColor?.merge(fallback.containerColor) ??
          fallback.containerColor,
      containerPadding: containerPadding ?? fallback.containerPadding,
      borderRadius: borderRadius ?? fallback.borderRadius,
      tabPadding: tabPadding ?? fallback.tabPadding,
      selectedColor:
          selectedColor?.merge(fallback.selectedColor) ??
          fallback.selectedColor,
      labelColor: labelColor?.merge(fallback.labelColor) ?? fallback.labelColor,
      selectedLabelColor:
          selectedLabelColor?.merge(fallback.selectedLabelColor) ??
          fallback.selectedLabelColor,
      textStyle: textStyle ?? fallback.textStyle,
    );
  }

  /// Scalars lerp; colours and geometry step at `t = 0.5`.
  static TabsTheme lerp(TabsTheme a, TabsTheme b, double t) {
    return TabsTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      containerColor: t < 0.5 ? a.containerColor : b.containerColor,
      containerPadding: t < 0.5 ? a.containerPadding : b.containerPadding,
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      tabPadding: t < 0.5 ? a.tabPadding : b.tabPadding,
      selectedColor: t < 0.5 ? a.selectedColor : b.selectedColor,
      labelColor: t < 0.5 ? a.labelColor : b.labelColor,
      selectedLabelColor: t < 0.5 ? a.selectedLabelColor : b.selectedLabelColor,
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabsTheme &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows &&
          other.containerColor == containerColor &&
          other.containerPadding == containerPadding &&
          other.borderRadius == borderRadius &&
          other.tabPadding == tabPadding &&
          other.selectedColor == selectedColor &&
          other.labelColor == labelColor &&
          other.selectedLabelColor == selectedLabelColor &&
          other.textStyle == textStyle;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    containerColor,
    containerPadding,
    borderRadius,
    tabPadding,
    selectedColor,
    labelColor,
    selectedLabelColor,
    textStyle,
  );
}

/// Token-derived baselines for [TabsTheme].
const TabsTheme tabsDefaults = TabsTheme(
  containerColor: StateValue(rest: ThemedColor.ref(ColorRef.muted)),
  containerPadding: EdgeInsets.all(3),
  tabPadding: EdgeInsets.symmetric(horizontal: 8),
  selectedColor: StateValue(rest: ThemedColor.ref(ColorRef.background)),
  labelColor: StateValue(rest: ThemedColor.ref(ColorRef.mutedForeground)),
  selectedLabelColor: StateValue(rest: ThemedColor.ref(ColorRef.foreground)),
  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
);

/// Theme of the [TabPane] bar and content card.
class TabPaneTheme extends ComponentThemeData
    implements Mergeable<TabPaneTheme> {
  /// Creates a tab pane theme.
  const TabPaneTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.barHeight,
    this.tabSpacing,
  });

  /// Content and focused-tab fill. Default: `card`.
  final ThemedColor? background;

  /// Content and tab border colour. Default: `border`.
  final ThemedColor? borderColor;

  /// Border width. Default: 1.
  final double? borderWidth;

  /// Content radius. Default: ambient `radiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Tab bar height. Default: 32.
  final double? barHeight;

  /// Gap between adjacent tabs. Default: 4.
  final double? tabSpacing;

  /// Returns a copy with the given rows replaced.
  TabPaneTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<double?>? barHeight,
    ValueGetter<double?>? tabSpacing,
  }) {
    return TabPaneTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      barHeight: barHeight == null ? this.barHeight : barHeight(),
      tabSpacing: tabSpacing == null ? this.tabSpacing : tabSpacing(),
    );
  }

  /// Receiver wins per field.
  @override
  TabPaneTheme merge(TabPaneTheme? fallback) {
    if (fallback == null) return this;
    return TabPaneTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      barHeight: barHeight ?? fallback.barHeight,
      tabSpacing: tabSpacing ?? fallback.tabSpacing,
    );
  }

  /// Scalars lerp; colours and geometry step at `t = 0.5`.
  static TabPaneTheme lerp(TabPaneTheme a, TabPaneTheme b, double t) {
    double? scale(double? x, double? y) {
      if (x == null) return y;
      if (y == null) return x;
      return x + (y - x) * t;
    }

    return TabPaneTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: scale(a.borderWidth, b.borderWidth),
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      barHeight: scale(a.barHeight, b.barHeight),
      tabSpacing: scale(a.tabSpacing, b.tabSpacing),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabPaneTheme &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows &&
          other.background == background &&
          other.borderColor == borderColor &&
          other.borderWidth == borderWidth &&
          other.borderRadius == borderRadius &&
          other.barHeight == barHeight &&
          other.tabSpacing == tabSpacing;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    borderColor,
    borderWidth,
    borderRadius,
    barHeight,
    tabSpacing,
  );
}

/// Token-derived baselines for [TabPaneTheme].
const TabPaneTheme tabPaneDefaults = TabPaneTheme(
  background: ThemedColor.ref(ColorRef.card),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  barHeight: 32,
  tabSpacing: 4,
);
