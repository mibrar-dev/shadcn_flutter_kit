// Registry-owned theme data for the `resizable` component: the
// [ResizableTheme] container and the token-derived `resizableDefaults`.
//
// User-owned overrides live in `resizable_theme.dart`; CLI updates may replace
// this file. The group resolves it through
// `resolveComponentStyle<ResizableTheme, ResizableTheme>`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Handle styling for the resizable component.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class ResizableTheme extends ComponentThemeData
    implements Mergeable<ResizableTheme> {
  /// Creates a resizable theme.
  const ResizableTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.handleColor,
    this.handleThickness,
    this.hitThickness,
    this.gripColor,
    this.gripSize,
  });

  /// Per-state divider colour. Default: `border`, `ring` on hover/press.
  final StateValue<ThemedColor>? handleColor;

  /// Divider line thickness. Default: `1`.
  final double? handleThickness;

  /// Gesture hit-area thickness. Default: `10`.
  final double? hitThickness;

  /// Grip colour. Default: `border`.
  final ThemedColor? gripColor;

  /// Grip size for a horizontal group. Default: `Size(4, 16)`.
  final Size? gripSize;

  /// Returns a copy with the given fields replaced.
  ResizableTheme copyWith({
    ValueGetter<StateValue<ThemedColor>?>? handleColor,
    ValueGetter<double?>? handleThickness,
    ValueGetter<double?>? hitThickness,
    ValueGetter<ThemedColor?>? gripColor,
    ValueGetter<Size?>? gripSize,
  }) {
    return ResizableTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      handleColor: handleColor == null ? this.handleColor : handleColor(),
      handleThickness: handleThickness == null
          ? this.handleThickness
          : handleThickness(),
      hitThickness: hitThickness == null ? this.hitThickness : hitThickness(),
      gripColor: gripColor == null ? this.gripColor : gripColor(),
      gripSize: gripSize == null ? this.gripSize : gripSize(),
    );
  }

  /// First-non-null-wins merge; the receiver (higher-priority leg) wins.
  @override
  ResizableTheme merge(ResizableTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return ResizableTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      handleColor:
          handleColor?.merge(fallback.handleColor) ?? fallback.handleColor,
      handleThickness: handleThickness ?? fallback.handleThickness,
      hitThickness: hitThickness ?? fallback.hitThickness,
      gripColor: gripColor ?? fallback.gripColor,
      gripSize: gripSize ?? fallback.gripSize,
    );
  }

  /// State scales step at `t < 0.5`; dimensions are lerped.
  static ResizableTheme lerp(ResizableTheme a, ResizableTheme b, double t) {
    return ResizableTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      handleColor: t < 0.5 ? a.handleColor : b.handleColor,
      handleThickness: lerpDouble(a.handleThickness, b.handleThickness, t),
      hitThickness: lerpDouble(a.hitThickness, b.hitThickness, t),
      gripColor: t < 0.5 ? a.gripColor : b.gripColor,
      gripSize: Size.lerp(a.gripSize, b.gripSize, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is ResizableTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.handleColor == handleColor &&
        other.handleThickness == handleThickness &&
        other.hitThickness == hitThickness &&
        other.gripColor == gripColor &&
        other.gripSize == gripSize;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    handleColor,
    handleThickness,
    hitThickness,
    gripColor,
    gripSize,
  );
}

/// Token-derived baseline; every unset override field falls through here.
const ResizableTheme resizableDefaults = ResizableTheme(
  handleColor: StateValue(
    rest: ThemedColor.ref(ColorRef.border),
    hovered: ThemedColor.ref(ColorRef.ring),
    pressed: ThemedColor.ref(ColorRef.ring),
  ),
  handleThickness: 1,
  hitThickness: 10,
  gripColor: ThemedColor.ref(ColorRef.border),
  gripSize: Size(4, 16),
);
