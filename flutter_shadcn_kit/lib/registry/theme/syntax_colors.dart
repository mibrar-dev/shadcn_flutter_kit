// The `syntax` token group: colors for syntax-highlighted code.
//
// A global token group (like `ShadcnFonts`), not a per-component theme: every
// code surface in the kit (`code_snippet`, markdown code blocks, docs code
// figures) shares one palette, so a Studio user edits one place. Light and
// dark values follow the shadcn/ui site (shiki github-light / github-dark).
//
// The group is deliberately NOT part of `ShadcnColors`: preset JSONs stay
// untouched, and the palette switches with the ambient brightness. A preset
// never needs to override it; an app can via `ShadcnThemeData.copyWith(syntax: …)`.

import 'package:flutter/widgets.dart';

/// One kind of syntax token a code tokenizer can emit.
///
/// The set is fixed: `SyntaxColors` carries a color for every kind, and the
/// tokenizer (`primitives/syntax_highlight`) maps lexemes to these kinds.
enum SyntaxTokenKind {
  /// Unstyled code (identifiers, whitespace, unclassified text).
  plain,

  /// Language keywords and CLI control words.
  keyword,

  /// Type / class names (capitalized identifiers).
  type,

  /// Function names at call sites.
  function,

  /// String literals (including the delimiters).
  string,

  /// Numeric literals.
  number,

  /// Comments.
  comment,

  /// Operators and punctuation.
  operator,

  /// Annotations / decorators (`@override`).
  annotation,

  /// Variables and object properties/members.
  variable,

  /// Constants (`true`/`false`/`null`, ALL_CAPS names).
  constant,

  /// Markup tags (`<div>` in HTML/JSX).
  tag,

  /// Markup/JSON attribute names.
  attribute,
}

/// The syntax-highlight palette for one brightness.
///
/// Const-constructible so user-owned theme files stay values-only. Colors are
/// transcribed from shiki's github-light / github-dark themes (the palette
/// the shadcn/ui site uses for code blocks).
@immutable
class SyntaxColors {
  /// Creates a palette. Every kind has a color; [plain] is the text color.
  const SyntaxColors({
    required this.plain,
    required this.keyword,
    required this.type,
    required this.function,
    required this.string,
    required this.number,
    required this.comment,
    required this.operator,
    required this.annotation,
    required this.variable,
    required this.constant,
    required this.tag,
    required this.attribute,
  });

  /// Unstyled code.
  final Color plain;

  /// Language keywords and CLI control words.
  final Color keyword;

  /// Type / class names.
  final Color type;

  /// Function names at call sites.
  final Color function;

  /// String literals.
  final Color string;

  /// Numeric literals.
  final Color number;

  /// Comments.
  final Color comment;

  /// Operators and punctuation.
  final Color operator;

  /// Annotations / decorators.
  final Color annotation;

  /// Variables and object properties/members.
  final Color variable;

  /// Constants (`true`/`false`/`null`, ALL_CAPS names).
  final Color constant;

  /// Markup tags.
  final Color tag;

  /// Markup/JSON attribute names.
  final Color attribute;

  /// github-light palette.
  static const SyntaxColors light = SyntaxColors(
    plain: Color(0xFF24292F),
    keyword: Color(0xFFCF222E),
    type: Color(0xFF953800),
    function: Color(0xFF8250DF),
    string: Color(0xFF0A3069),
    number: Color(0xFF0550AE),
    comment: Color(0xFF6E7781),
    operator: Color(0xFF57606A),
    annotation: Color(0xFF953800),
    variable: Color(0xFF24292F),
    constant: Color(0xFF0550AE),
    tag: Color(0xFF116329),
    attribute: Color(0xFF0550AE),
  );

  /// github-dark palette.
  static const SyntaxColors dark = SyntaxColors(
    plain: Color(0xFFE6EDF3),
    keyword: Color(0xFFFF7B72),
    type: Color(0xFFFFA657),
    function: Color(0xFFD2A8FF),
    string: Color(0xFFA5D6FF),
    number: Color(0xFF79C0FF),
    comment: Color(0xFF8B949E),
    operator: Color(0xFFC9D1D9),
    annotation: Color(0xFFFFA657),
    variable: Color(0xFFE6EDF3),
    constant: Color(0xFF79C0FF),
    tag: Color(0xFF7EE787),
    attribute: Color(0xFF79C0FF),
  );

  /// The palette for [brightness].
  factory SyntaxColors.forBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  /// Color for [kind].
  Color colorFor(SyntaxTokenKind kind) {
    return switch (kind) {
      SyntaxTokenKind.plain => plain,
      SyntaxTokenKind.keyword => keyword,
      SyntaxTokenKind.type => type,
      SyntaxTokenKind.function => function,
      SyntaxTokenKind.string => string,
      SyntaxTokenKind.number => number,
      SyntaxTokenKind.comment => comment,
      SyntaxTokenKind.operator => operator,
      SyntaxTokenKind.annotation => annotation,
      SyntaxTokenKind.variable => variable,
      SyntaxTokenKind.constant => constant,
      SyntaxTokenKind.tag => tag,
      SyntaxTokenKind.attribute => attribute,
    };
  }

  /// Steps at `t = 0.5` (colors cannot lerp mid-flight); mirrors
  /// `ShadcnFonts.lerp`.
  static SyntaxColors lerp(SyntaxColors a, SyntaxColors b, double t) =>
      t < 0.5 ? a : b;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SyntaxColors &&
        other.plain == plain &&
        other.keyword == keyword &&
        other.type == type &&
        other.function == function &&
        other.string == string &&
        other.number == number &&
        other.comment == comment &&
        other.operator == operator &&
        other.annotation == annotation &&
        other.variable == variable &&
        other.constant == constant &&
        other.tag == tag &&
        other.attribute == attribute;
  }

  @override
  int get hashCode => Object.hash(
    plain,
    keyword,
    type,
    function,
    string,
    number,
    comment,
    operator,
    annotation,
    variable,
    constant,
    tag,
    attribute,
  );
}
