// Registry-owned theme data for the `code_snippet` component.
//
// User-owned overrides live in `code_snippet_theme.dart`; CLI updates may
// replace this file.

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';

/// Theme of the code snippet container.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget).
class CodeSnippetTheme extends ComponentThemeData
    implements Mergeable<CodeSnippetTheme> {
  /// Creates a code snippet theme.
  const CodeSnippetTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
  });

  /// Container fill. Default: the `card` token.
  final ThemedColor? background;

  /// Border color. Default: the `border` token.
  final ThemedColor? borderColor;

  /// Border width, scaled. Default: 1.
  final double? borderWidth;

  /// Corner radius. Default: ambient `radiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Inner padding. Default: one density step on three sides, 3.5 on the
  /// right (room for the actions row).
  final EdgeInsetsGeometry? padding;

  /// Returns a copy with the given fields replaced.
  CodeSnippetTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<double?>? borderWidth,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? padding,
  }) {
    return CodeSnippetTheme(
      background: background == null ? this.background : background(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      borderWidth: borderWidth == null ? this.borderWidth : borderWidth(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      padding: padding == null ? this.padding : padding(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  CodeSnippetTheme merge(CodeSnippetTheme? fallback) {
    if (fallback == null) return this;
    return CodeSnippetTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      borderWidth: borderWidth ?? fallback.borderWidth,
      borderRadius: borderRadius ?? fallback.borderRadius,
      padding: padding ?? fallback.padding,
    );
  }

  /// Scalars interpolate; the rest steps at `t = 0.5`.
  static CodeSnippetTheme lerp(
    CodeSnippetTheme a,
    CodeSnippetTheme b,
    double t,
  ) {
    double? scale(double? x, double? y) {
      if (x == null) return y;
      if (y == null) return x;
      return x + (y - x) * t;
    }

    return CodeSnippetTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      borderWidth: scale(a.borderWidth, b.borderWidth),
      borderRadius: t < 0.5 ? a.borderRadius : b.borderRadius,
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CodeSnippetTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.borderRadius == borderRadius &&
        other.padding == padding;
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
  );
}

/// Built-in code snippet defaults.
const CodeSnippetTheme codeSnippetDefaults = CodeSnippetTheme(
  background: ThemedColor.ref(ColorRef.card),
  borderColor: ThemedColor.ref(ColorRef.border),
  borderWidth: 1,
  padding: EdgeInsetsDensity.only(left: 1, top: 1, right: 3.5, bottom: 1),
);
