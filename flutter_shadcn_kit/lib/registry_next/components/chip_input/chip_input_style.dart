// Registry-owned theme data for the `chip_input` component: the
// [ChipInputTheme] container and its token-derived `chipInputDefaults`.
//
// The field surface itself is the `input` component's (`InputTheme`), and the
// token colours are the `chip` component's (`ChipTheme`), so this theme only
// holds what the token field adds on top: the gap between tokens, whether a
// token shows its remove button, the icon size of that button and how a token
// sits on the text baseline. User-owned overrides live in `chip_input_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../chip/chip_style.dart';

/// Theme container for the token field.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ChipInputTheme extends ComponentThemeData
    implements Mergeable<ChipInputTheme> {
  /// Creates a chip-input theme.
  const ChipInputTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.spacing,
    this.removable,
    this.chipTheme,
    this.chipIconSize,
    this.alignment,
  });

  /// Logical pixels reserved between two adjacent tokens. Default: 4.
  ///
  /// Half of it lands on each side of the inner edges, so the rendered gap
  /// between two neighbouring chips is exactly this.
  final double? spacing;

  /// Whether each token gets a remove button. Default: true.
  final bool? removable;

  /// Extra `ChipTheme` leg for the tokens of *this* field.
  ///
  /// Merged over the app's `ChipTheme`, so one field can restyle its chips
  /// without touching every other chip in the app.
  final ChipTheme? chipTheme;

  /// Icon size of the remove button. Default: 12.
  final double? chipIconSize;

  /// How the painted token sits on the text baseline. Default:
  /// [PlaceholderAlignment.middle].
  final PlaceholderAlignment? alignment;

  /// Returns a copy with the given fields replaced.
  ChipInputTheme copyWith({
    ValueGetter<double?>? spacing,
    ValueGetter<bool?>? removable,
    ValueGetter<ChipTheme?>? chipTheme,
    ValueGetter<double?>? chipIconSize,
    ValueGetter<PlaceholderAlignment?>? alignment,
  }) {
    return ChipInputTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      spacing: spacing == null ? this.spacing : spacing(),
      removable: removable == null ? this.removable : removable(),
      chipTheme: chipTheme == null ? this.chipTheme : chipTheme(),
      chipIconSize: chipIconSize == null ? this.chipIconSize : chipIconSize(),
      alignment: alignment == null ? this.alignment : alignment(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ChipInputTheme merge(ChipInputTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ChipInputTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      spacing: spacing ?? fallback.spacing,
      removable: removable ?? fallback.removable,
      // `ChipTheme.merge` is receiver-wins per field, so the higher-priority
      // leg's rows survive and the lower leg fills the rest.
      chipTheme: chipTheme?.merge(fallback.chipTheme) ?? fallback.chipTheme,
      chipIconSize: chipIconSize ?? fallback.chipIconSize,
      alignment: alignment ?? fallback.alignment,
    );
  }

  /// Scalars interpolate; flags and the alignment step at `t = 0.5`.
  static ChipInputTheme lerp(ChipInputTheme a, ChipInputTheme b, double t) {
    return ChipInputTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      spacing: lerpDouble(a.spacing, b.spacing, t),
      removable: t < 0.5 ? a.removable : b.removable,
      chipTheme: t < 0.5 ? a.chipTheme : b.chipTheme,
      chipIconSize: lerpDouble(a.chipIconSize, b.chipIconSize, t),
      alignment: t < 0.5 ? a.alignment : b.alignment,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ChipInputTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.spacing == spacing &&
        other.removable == removable &&
        other.chipTheme == chipTheme &&
        other.chipIconSize == chipIconSize &&
        other.alignment == alignment;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    spacing,
    removable,
    chipTheme,
    chipIconSize,
    alignment,
  );
}

/// Default gap between two adjacent tokens, in logical pixels.
const double chipInputDefaultSpacing = 4;

/// Default icon size of a token's remove button.
const double chipInputDefaultChipIconSize = 12;

/// Token-derived baseline; every unset override field falls through here.
const ChipInputTheme chipInputDefaults = ChipInputTheme(
  spacing: chipInputDefaultSpacing,
  removable: true,
  chipIconSize: chipInputDefaultChipIconSize,
  alignment: PlaceholderAlignment.middle,
);
