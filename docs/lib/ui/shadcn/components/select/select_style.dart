// Registry-owned theme data for the `select` component: the [SelectTheme]
// container, its token-derived `selectDefaults`, and the trigger defaults
// that reuse the `button` component's variant table.
//
// User-owned overrides live in `select_theme.dart`; CLI updates may replace
// this file. The surface is styled by the `menu` component's
// [MenuPopupTheme], re-exported here so user theme files can reach it.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../menu/menu.dart';

export '../button/button.dart' show ButtonVariant, ButtonVariantStyle;
export '../menu/menu.dart' show MenuPopupTheme;

/// Trigger padding (shadcn `px-3`), density-scaled; the height comes from
/// the 36px minimum.
const EdgeInsetsGeometry selectDefaultTriggerPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 12);

/// Menu row metrics for select options (shadcn `px-2 py-1.5`), density
/// scaled: 6 + 20 + 6 = 32 high with the 14px type.
const EdgeInsetsGeometry selectDefaultItemPadding =
    EdgeInsetsDensity.pxSymmetric(horizontal: 8, vertical: 6);

/// Theme container for the select component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class SelectTheme extends ComponentThemeData implements Mergeable<SelectTheme> {
  /// Creates a select theme.
  const SelectTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.variant,
    this.trigger,
    this.popup,
    this.itemPadding,
    this.constraints,
  });

  /// Button variant of the trigger. Default: [ButtonVariant.outline]
  /// (`filled: true` on the widget selects [ButtonVariant.secondary]).
  final ButtonVariant? variant;

  /// Per-state trigger rows merged over the variant's button style, so a
  /// theme can restyle colours without losing the trigger metrics.
  final ButtonVariantStyle? trigger;

  /// Surface override passed to the popup as its widget leg.
  final MenuPopupTheme? popup;

  /// Padding of one option row. Default: [selectDefaultItemPadding].
  final EdgeInsetsGeometry? itemPadding;

  /// Popup size constraints. Default: 192-320 wide and 240 high (the popup
  /// is always trigger-wide through the popover's anchor-fixed sizing).
  final BoxConstraints? constraints;

  /// Returns a copy with the given fields replaced.
  SelectTheme copyWith({
    ValueGetter<ButtonVariant?>? variant,
    ValueGetter<ButtonVariantStyle?>? trigger,
    ValueGetter<MenuPopupTheme?>? popup,
    ValueGetter<EdgeInsetsGeometry?>? itemPadding,
    ValueGetter<BoxConstraints?>? constraints,
  }) {
    return SelectTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      variant: variant == null ? this.variant : variant(),
      trigger: trigger == null ? this.trigger : trigger(),
      popup: popup == null ? this.popup : popup(),
      itemPadding: itemPadding == null ? this.itemPadding : itemPadding(),
      constraints: constraints == null ? this.constraints : constraints(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  SelectTheme merge(SelectTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return SelectTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      variant: variant ?? fallback.variant,
      trigger: trigger?.merge(fallback.trigger) ?? fallback.trigger,
      popup: popup?.merge(fallback.popup) ?? fallback.popup,
      itemPadding: itemPadding ?? fallback.itemPadding,
      constraints: constraints ?? fallback.constraints,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectTheme &&
          other.variant == variant &&
          other.trigger == trigger &&
          other.popup == popup &&
          other.itemPadding == itemPadding &&
          other.constraints == constraints &&
          other.themeDensity == themeDensity &&
          other.themeSpacing == themeSpacing &&
          other.themeShadows == themeShadows;

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    variant,
    trigger,
    popup,
    itemPadding,
    constraints,
  );
}

/// Token-derived baseline: outline trigger and menu row metrics.
const SelectTheme selectDefaults = SelectTheme(
  itemPadding: selectDefaultItemPadding,
);
