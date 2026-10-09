// Registry-owned theme data for the `markdown` component: [MarkdownTheme]
// plus the token-derived [markdownDefaults] rows.
//
// Flat theme (dialog pattern): no variant enum. Text styles carry shape
// only; their color is ignored and resolved from tokens at build, so a
// preset switch recolors every row. Every color field is a [ThemedColor]
// token reference; alpha multiplies, never replaces. Geometry (paddings,
// radii, indents, image bounds) is fixed at shadcn values and lives in the
// renderer, not here.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../primitives/localizations/localizations.dart';
import '../../primitives/markdown_parser/api.dart';
import '../../primitives/markdown_parser/document.dart';
import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Theme of the markdown renderer.
///
/// Every field is nullable: `null` means "inherit", and the resolver fills
/// the gap from the next leg (defaults < app < scoped < widget).
class MarkdownTheme extends ComponentThemeData
    implements Mergeable<MarkdownTheme> {
  const MarkdownTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.style,
    this.linkStyle,
    this.linkColor,
    this.codeStyle,
    this.codeBackgroundColor,
    this.quoteBorderColor,
    this.tableHeaderStyle,
    this.tableBorderColor,
    this.tableHeaderBackgroundColor,
    this.heading1Style,
    this.heading2Style,
    this.heading3Style,
    this.heading4Style,
    this.heading5Style,
    this.heading6Style,
    this.horizontalRuleColor,
    this.blockSpacing,
  });

  /// Base body style. Color is ignored; the ambient `foreground` wins.
  final TextStyle? style;

  /// Link shape (underline). Color is ignored; [linkColor] wins.
  final TextStyle? linkStyle;

  /// Link color. Default: the `primary` token.
  final ThemedColor? linkColor;

  /// Code shape. Family falls back to the ambient `fontMono` at build.
  final TextStyle? codeStyle;

  /// Code-block fill. Default: `foreground` at 7%.
  final ThemedColor? codeBackgroundColor;

  /// Quote left-rule color. Default: the `border` token.
  final ThemedColor? quoteBorderColor;

  /// Table header shape.
  final TextStyle? tableHeaderStyle;

  /// Table rule color. Default: the `border` token.
  final ThemedColor? tableBorderColor;

  /// Table header-row fill. Default: `muted` at 50%.
  final ThemedColor? tableHeaderBackgroundColor;

  /// Heading shapes for levels 1-6.
  final TextStyle? heading1Style;
  final TextStyle? heading2Style;
  final TextStyle? heading3Style;
  final TextStyle? heading4Style;
  final TextStyle? heading5Style;
  final TextStyle? heading6Style;

  /// Horizontal-rule color. Default: the `border` token.
  final ThemedColor? horizontalRuleColor;

  /// Vertical gap after each block.
  final double? blockSpacing;

  MarkdownTheme copyWith({
    ValueGetter<TextStyle?>? style,
    ValueGetter<TextStyle?>? linkStyle,
    ValueGetter<ThemedColor?>? linkColor,
    ValueGetter<TextStyle?>? codeStyle,
    ValueGetter<ThemedColor?>? codeBackgroundColor,
    ValueGetter<ThemedColor?>? quoteBorderColor,
    ValueGetter<TextStyle?>? tableHeaderStyle,
    ValueGetter<ThemedColor?>? tableBorderColor,
    ValueGetter<ThemedColor?>? tableHeaderBackgroundColor,
    ValueGetter<TextStyle?>? heading1Style,
    ValueGetter<TextStyle?>? heading2Style,
    ValueGetter<TextStyle?>? heading3Style,
    ValueGetter<TextStyle?>? heading4Style,
    ValueGetter<TextStyle?>? heading5Style,
    ValueGetter<TextStyle?>? heading6Style,
    ValueGetter<ThemedColor?>? horizontalRuleColor,
    ValueGetter<double?>? blockSpacing,
  }) {
    return MarkdownTheme(
      style: style == null ? this.style : style(),
      linkStyle: linkStyle == null ? this.linkStyle : linkStyle(),
      linkColor: linkColor == null ? this.linkColor : linkColor(),
      codeStyle: codeStyle == null ? this.codeStyle : codeStyle(),
      codeBackgroundColor: codeBackgroundColor == null
          ? this.codeBackgroundColor
          : codeBackgroundColor(),
      quoteBorderColor: quoteBorderColor == null
          ? this.quoteBorderColor
          : quoteBorderColor(),
      tableHeaderStyle: tableHeaderStyle == null
          ? this.tableHeaderStyle
          : tableHeaderStyle(),
      tableBorderColor: tableBorderColor == null
          ? this.tableBorderColor
          : tableBorderColor(),
      tableHeaderBackgroundColor: tableHeaderBackgroundColor == null
          ? this.tableHeaderBackgroundColor
          : tableHeaderBackgroundColor(),
      heading1Style: heading1Style == null
          ? this.heading1Style
          : heading1Style(),
      heading2Style: heading2Style == null
          ? this.heading2Style
          : heading2Style(),
      heading3Style: heading3Style == null
          ? this.heading3Style
          : heading3Style(),
      heading4Style: heading4Style == null
          ? this.heading4Style
          : heading4Style(),
      heading5Style: heading5Style == null
          ? this.heading5Style
          : heading5Style(),
      heading6Style: heading6Style == null
          ? this.heading6Style
          : heading6Style(),
      horizontalRuleColor: horizontalRuleColor == null
          ? this.horizontalRuleColor
          : horizontalRuleColor(),
      blockSpacing: blockSpacing == null ? this.blockSpacing : blockSpacing(),
    );
  }

  /// Receiver wins per field; [fallback] only fills null cells.
  @override
  MarkdownTheme merge(MarkdownTheme? fallback) {
    if (fallback == null) return this;
    return MarkdownTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      style: style ?? fallback.style,
      linkStyle: linkStyle ?? fallback.linkStyle,
      linkColor: linkColor ?? fallback.linkColor,
      codeStyle: codeStyle ?? fallback.codeStyle,
      codeBackgroundColor: codeBackgroundColor ?? fallback.codeBackgroundColor,
      quoteBorderColor: quoteBorderColor ?? fallback.quoteBorderColor,
      tableHeaderStyle: tableHeaderStyle ?? fallback.tableHeaderStyle,
      tableBorderColor: tableBorderColor ?? fallback.tableBorderColor,
      tableHeaderBackgroundColor:
          tableHeaderBackgroundColor ?? fallback.tableHeaderBackgroundColor,
      heading1Style: heading1Style ?? fallback.heading1Style,
      heading2Style: heading2Style ?? fallback.heading2Style,
      heading3Style: heading3Style ?? fallback.heading3Style,
      heading4Style: heading4Style ?? fallback.heading4Style,
      heading5Style: heading5Style ?? fallback.heading5Style,
      heading6Style: heading6Style ?? fallback.heading6Style,
      horizontalRuleColor: horizontalRuleColor ?? fallback.horizontalRuleColor,
      blockSpacing: blockSpacing ?? fallback.blockSpacing,
    );
  }

  /// Colors and styles step at `t = 0.5`; scalars interpolate.
  static MarkdownTheme lerp(MarkdownTheme a, MarkdownTheme b, double t) {
    TextStyle? text(TextStyle? x, TextStyle? y) => TextStyle.lerp(x, y, t);
    ThemedColor? color(ThemedColor? x, ThemedColor? y) => t < 0.5 ? x : y;
    return MarkdownTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      style: text(a.style, b.style),
      linkStyle: text(a.linkStyle, b.linkStyle),
      linkColor: color(a.linkColor, b.linkColor),
      codeStyle: text(a.codeStyle, b.codeStyle),
      codeBackgroundColor: color(a.codeBackgroundColor, b.codeBackgroundColor),
      quoteBorderColor: color(a.quoteBorderColor, b.quoteBorderColor),
      tableHeaderStyle: text(a.tableHeaderStyle, b.tableHeaderStyle),
      tableBorderColor: color(a.tableBorderColor, b.tableBorderColor),
      tableHeaderBackgroundColor: color(
        a.tableHeaderBackgroundColor,
        b.tableHeaderBackgroundColor,
      ),
      heading1Style: text(a.heading1Style, b.heading1Style),
      heading2Style: text(a.heading2Style, b.heading2Style),
      heading3Style: text(a.heading3Style, b.heading3Style),
      heading4Style: text(a.heading4Style, b.heading4Style),
      heading5Style: text(a.heading5Style, b.heading5Style),
      heading6Style: text(a.heading6Style, b.heading6Style),
      horizontalRuleColor: color(a.horizontalRuleColor, b.horizontalRuleColor),
      blockSpacing: lerpDouble(a.blockSpacing, b.blockSpacing, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MarkdownTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.style == style &&
        other.linkStyle == linkStyle &&
        other.linkColor == linkColor &&
        other.codeStyle == codeStyle &&
        other.codeBackgroundColor == codeBackgroundColor &&
        other.quoteBorderColor == quoteBorderColor &&
        other.tableHeaderStyle == tableHeaderStyle &&
        other.tableBorderColor == tableBorderColor &&
        other.tableHeaderBackgroundColor == tableHeaderBackgroundColor &&
        other.heading1Style == heading1Style &&
        other.heading2Style == heading2Style &&
        other.heading3Style == heading3Style &&
        other.heading4Style == heading4Style &&
        other.heading5Style == heading5Style &&
        other.heading6Style == heading6Style &&
        other.horizontalRuleColor == horizontalRuleColor &&
        other.blockSpacing == blockSpacing;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    themeDensity,
    themeSpacing,
    themeShadows,
    style,
    linkStyle,
    linkColor,
    codeStyle,
    codeBackgroundColor,
    quoteBorderColor,
    tableHeaderStyle,
    tableBorderColor,
    tableHeaderBackgroundColor,
    heading1Style,
    heading2Style,
    heading3Style,
    heading4Style,
    heading5Style,
    heading6Style,
    horizontalRuleColor,
    blockSpacing,
  ]);
}

/// Token-derived baseline; every unset override field falls through here.
const MarkdownTheme markdownDefaults = MarkdownTheme(
  style: TextStyle(fontSize: 14, height: 1.6),
  linkStyle: TextStyle(decoration: TextDecoration.underline),
  linkColor: ThemedColor.ref(ColorRef.primary),
  codeStyle: TextStyle(height: 1.45),
  codeBackgroundColor: ThemedColor.ref(ColorRef.foreground, alpha: 0.07),
  quoteBorderColor: ThemedColor.ref(ColorRef.border),
  tableHeaderStyle: TextStyle(fontWeight: FontWeight.w700),
  tableBorderColor: ThemedColor.ref(ColorRef.border),
  tableHeaderBackgroundColor: ThemedColor.ref(ColorRef.muted, alpha: 0.5),
  heading1Style: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 1.25,
  ),
  heading2Style: TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w800,
    height: 1.28,
  ),
  heading3Style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  ),
  heading4Style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.35,
  ),
  heading5Style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.4,
  ),
  heading6Style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
  ),
  horizontalRuleColor: ThemedColor.ref(ColorRef.border),
  blockSpacing: 6,
);

/// Resolves a [MarkdownTheme] into concrete renderer values once per build,
/// so the primitive renderer stays theme-free. Partial style rows inherit
/// sizes from the ambient body style; every color comes from tokens.
MarkdownRenderStyle resolveMarkdownStyle(
  BuildContext context, {
  required MarkdownTheme? widgetTheme,
  TextStyle? style,
  required bool selectable,
  required Map<String, MarkdownLinkTarget> references,
  required List<String> footnoteOrder,
}) {
  final ambient = ShadcnTheme.of(context);
  final colors = ambient.colors;
  final resolved = resolveComponentStyle<MarkdownTheme, MarkdownTheme>(
    context,
    widget: widgetTheme,
    select: (t) => t,
    defaults: markdownDefaults,
  );
  final body = (style ?? DefaultTextStyle.of(context).style)
      .merge(resolved.style)
      .copyWith(
        color: style?.color ?? resolved.style?.color ?? colors.foreground,
      );
  final link = (resolved.linkStyle ?? const TextStyle())
      .merge(body)
      .copyWith(
        color: resolved.linkColor?.resolve(colors) ?? colors.primary,
        decoration: TextDecoration.underline,
      );
  final mono = body
      .merge(resolved.codeStyle)
      .copyWith(
        fontFamily: resolved.codeStyle?.fontFamily ?? ambient.fonts.fontMono,
      );
  TextStyle headed(TextStyle? shape, double size, FontWeight weight) {
    return body
        .merge(TextStyle(fontSize: size, fontWeight: weight, height: 1.35))
        .merge(shape)
        .copyWith(color: body.color);
  }

  return MarkdownRenderStyle(
    body: body,
    link: link,
    mono: mono,
    codeBackground:
        resolved.codeBackgroundColor?.resolve(colors) ?? colors.muted,
    quote: body,
    quoteBorder: resolved.quoteBorderColor?.resolve(colors) ?? colors.border,
    tableHeader: body
        .merge(resolved.tableHeaderStyle)
        .copyWith(color: body.color),
    tableCell: body,
    tableBorder: resolved.tableBorderColor?.resolve(colors) ?? colors.border,
    tableHeaderBackground:
        resolved.tableHeaderBackgroundColor?.resolve(colors) ?? colors.muted,
    headings: <TextStyle>[
      headed(resolved.heading1Style, 28, FontWeight.w800),
      headed(resolved.heading2Style, 23, FontWeight.w800),
      headed(resolved.heading3Style, 20, FontWeight.w700),
      headed(resolved.heading4Style, 18, FontWeight.w700),
      headed(resolved.heading5Style, 16, FontWeight.w700),
      headed(resolved.heading6Style, 14, FontWeight.w700),
    ],
    rule: resolved.horizontalRuleColor?.resolve(colors) ?? colors.border,
    blockSpacing: resolved.blockSpacing ?? 6,
    selectable: selectable,
    dismissLabel: ShadcnLocalizations.of(context).dialogDismiss,
    onLink: colors.primaryForeground,
    surface: colors.card,
    onSurface: colors.cardForeground,
    muted: colors.mutedForeground,
    selection:
        DefaultSelectionStyle.of(context).selectionColor ??
        colors.primary.withValues(alpha: colors.primary.a * 0.2),
    references: references,
    footnoteOrder: footnoteOrder,
  );
}
