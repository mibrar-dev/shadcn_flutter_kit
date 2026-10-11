// Registry-owned theme data for the `radio_group` component: the
// [RadioGroupTheme] container (the arrow-key reading order and the group-level
// fields that no single item owns) plus the token-derived defaults.
//
// The item shapes themselves — [SelectableRadioTheme], [SelectableCardTheme]
// and `radioGroupDefaults` — live in `primitives/selectable_radio/`, because
// `select`, `menu` and `tabs` need the same rows. User-owned overrides live in
// `radio_group_theme.dart`.

import 'package:flutter/widgets.dart';

import '../../primitives/selectable_radio/selectable_radio_theme.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

export '../../primitives/selectable_radio/selectable_radio_theme.dart'
    show
        RadioIndicatorStyle,
        SelectableRadioTheme,
        SelectableData,
        SelectableDataScope,
        radioDefaultIndicatorSize,
        radioDefaultDuration,
        radioDefaultTextStyle,
        selectableRadioDefaults;

/// Group-level settings for a single-select group.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class RadioGroupTheme extends ComponentThemeData
    implements Mergeable<RadioGroupTheme> {
  /// Creates a radio group theme.
  const RadioGroupTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.direction,
    this.items,
    this.itemsGap,
    this.card,
  });

  /// Arrow-key reading order; null falls back to the widget's [Axis.vertical].
  final Axis? direction;

  /// Row styling for this group's items.
  final SelectableRadioTheme? items;

  /// Space between two items; null resolves 12 (shadcn `gap-3`).
  ///
  /// A shadcn pixel value at the default density: the widget scales it with
  /// the ambient density and scaling, like every other spacing it derives.
  final double? itemsGap;

  /// Surface styling for this group's card items.
  final SelectableCardTheme? card;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  RadioGroupTheme merge(RadioGroupTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return RadioGroupTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      direction: direction ?? fallback.direction,
      items: items?.merge(fallback.items) ?? fallback.items,
      itemsGap: itemsGap ?? fallback.itemsGap,
      card: card?.merge(fallback.card) ?? fallback.card,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is RadioGroupTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.direction == direction &&
        other.items == items &&
        other.itemsGap == itemsGap &&
        other.card == card;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    direction,
    items,
    itemsGap,
    card,
  );
}

/// Token-derived baseline values; unset override fields fall through here.
const RadioGroupTheme radioGroupDefaults = RadioGroupTheme(
  direction: Axis.vertical,
  items: selectableRadioDefaults,
  card: selectableCardDefaults,
);

/// Gap between two items of a [ShadcnRadioGroup]: shadcn `gap-3` (12) at the
/// default density, scaled by the ambient density.
const double radioGroupItemsGap = 12;

/// Card-surface styling for a [RadioCard].
///
/// It lives here, not in `primitives/selectable_radio/`, because a card is a
/// component-layer surface: the primitive may not import `Card`, so the shape
/// that draws one belongs to the component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class SelectableCardTheme extends ComponentThemeData
    implements Mergeable<SelectableCardTheme> {
  /// Creates a card theme.
  const SelectableCardTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.gap,
  });

  /// Per-state fill.
  final StateValue<ThemedColor>? background;

  /// Per-state border colour.
  final StateValue<ThemedColor>? borderColor;

  /// Border width; null resolves 1. Constant per state, so selecting a card
  /// can never shift its content.
  final double? borderWidth;

  /// Corner radius; null resolves the ambient `radiusLg` at build.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding; null resolves 16, density-scaled.
  final EdgeInsetsGeometry? padding;

  /// Space between the indicator and the content; null resolves `spacing.md`.
  final double? gap;

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SelectableCardTheme merge(SelectableCardTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SelectableCardTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background?.merge(fallback.background) ?? fallback.background,
      borderColor:
          borderColor?.merge(fallback.borderColor) ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
      gap: gap ?? fallback.gap,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is SelectableCardTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding &&
        other.gap == gap;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    borderColor,
    borderWidth,
    borderRadius,
    padding,
    gap,
  );
}

/// Token-derived baseline values for a selectable card.
///
/// Selection fills `accent` and paints the border `primary`; the border width
/// never changes, so selecting cannot shift the content.
const SelectableCardTheme selectableCardDefaults = SelectableCardTheme(
  background: StateValue(
    hovered: ThemedColor.ref(ColorRef.accent),
    selected: ThemedColor.ref(ColorRef.accent),
  ),
  borderColor: StateValue(
    rest: ThemedColor.ref(ColorRef.border),
    hovered: ThemedColor.ref(ColorRef.border),
    selected: ThemedColor.ref(ColorRef.primary),
  ),
  borderWidth: 1,
  // Card inner padding 16, density-scaled (resolved at the `Card` that
  // paints it).
  padding: EdgeInsetsDensity.pxAll(16),
  gap: 12,
);
