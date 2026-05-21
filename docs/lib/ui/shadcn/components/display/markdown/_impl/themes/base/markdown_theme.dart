// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../../markdown.dart';

class MarkdownTheme extends ComponentThemeData {
  const MarkdownTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.style,
    this.linkStyle,
    this.codeStyle,
    this.codeLanguageStyle,
    this.mathStyle,
    this.quoteStyle,
    this.tableHeaderStyle,
    this.tableCellStyle,
    this.footnoteLabelStyle,
    this.imageCaptionStyle,
    this.detailsSummaryStyle,
    this.heading1Style,
    this.heading2Style,
    this.heading3Style,
    this.heading4Style,
    this.heading5Style,
    this.heading6Style,
    this.horizontalRuleColor,
    this.codeBackgroundColor,
    this.quoteBorderColor,
    this.quoteBackgroundColor,
    this.tableBorderColor,
    this.tableHeaderBackgroundColor,
    this.detailsBorderColor,
    this.detailsBackgroundColor,
    this.blockSpacing,
    this.listIndent,
    this.quoteBorderWidth,
    this.imageMaxHeight,
    this.tableCellMinWidth,
    this.codePadding,
    this.quotePadding,
    this.tableCellPadding,
    this.detailsHeaderPadding,
    this.detailsBodyPadding,
    this.codeRadius,
    this.tableRadius,
    this.detailsRadius,
  });

  final TextStyle? style;
  final TextStyle? linkStyle;
  final TextStyle? codeStyle;
  final TextStyle? codeLanguageStyle;
  final TextStyle? mathStyle;
  final TextStyle? quoteStyle;
  final TextStyle? tableHeaderStyle;
  final TextStyle? tableCellStyle;
  final TextStyle? footnoteLabelStyle;
  final TextStyle? imageCaptionStyle;
  final TextStyle? detailsSummaryStyle;
  final TextStyle? heading1Style;
  final TextStyle? heading2Style;
  final TextStyle? heading3Style;
  final TextStyle? heading4Style;
  final TextStyle? heading5Style;
  final TextStyle? heading6Style;

  final Color? horizontalRuleColor;
  final Color? codeBackgroundColor;
  final Color? quoteBorderColor;
  final Color? quoteBackgroundColor;
  final Color? tableBorderColor;
  final Color? tableHeaderBackgroundColor;
  final Color? detailsBorderColor;
  final Color? detailsBackgroundColor;

  final double? blockSpacing;
  final double? listIndent;
  final double? quoteBorderWidth;
  final double? imageMaxHeight;
  final double? tableCellMinWidth;

  final EdgeInsetsGeometry? codePadding;
  final EdgeInsetsGeometry? quotePadding;
  final EdgeInsetsGeometry? tableCellPadding;
  final EdgeInsetsGeometry? detailsHeaderPadding;
  final EdgeInsetsGeometry? detailsBodyPadding;

  final BorderRadiusGeometry? codeRadius;
  final BorderRadiusGeometry? tableRadius;
  final BorderRadiusGeometry? detailsRadius;

  static MarkdownTheme htmlDefaults(TextStyle baseStyle) {
    final textColor = baseStyle.color ?? const Color(0xFF111827);
    final mutedText = textColor.withValues(alpha: 0.72);
    final softBorder = textColor.withValues(alpha: 0.16);
    final subtleFill = textColor.withValues(alpha: 0.06);
    final fs = baseStyle.fontSize ?? 14;

    return MarkdownTheme(
      style: baseStyle.copyWith(height: 1.6),
      linkStyle: baseStyle.copyWith(
        color: const Color(0xFF0969DA),
        decoration: TextDecoration.underline,
      ),
      codeStyle: baseStyle.copyWith(fontFamily: 'GeistMono', height: 1.45),
      codeLanguageStyle: baseStyle.copyWith(
        fontFamily: 'GeistMono',
        fontSize: fs * 0.85,
        color: mutedText,
      ),
      mathStyle: baseStyle.copyWith(
        fontFamily: 'GeistMono',
        fontStyle: FontStyle.italic,
      ),
      quoteStyle: baseStyle.copyWith(height: 1.55),
      tableHeaderStyle: baseStyle.copyWith(fontWeight: FontWeight.w700),
      tableCellStyle: baseStyle,
      footnoteLabelStyle: baseStyle.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: fs * 0.9,
      ),
      imageCaptionStyle: baseStyle.copyWith(
        fontSize: fs * 0.9,
        color: mutedText,
      ),
      detailsSummaryStyle: baseStyle.copyWith(fontWeight: FontWeight.w600),
      heading1Style: baseStyle.copyWith(
        fontSize: fs * 2.0,
        fontWeight: FontWeight.w800,
        height: 1.25,
      ),
      heading2Style: baseStyle.copyWith(
        fontSize: fs * 1.65,
        fontWeight: FontWeight.w800,
        height: 1.28,
      ),
      heading3Style: baseStyle.copyWith(
        fontSize: fs * 1.4,
        fontWeight: FontWeight.w700,
        height: 1.3,
      ),
      heading4Style: baseStyle.copyWith(
        fontSize: fs * 1.25,
        fontWeight: FontWeight.w700,
        height: 1.32,
      ),
      heading5Style: baseStyle.copyWith(
        fontSize: fs * 1.1,
        fontWeight: FontWeight.w700,
      ),
      heading6Style: baseStyle.copyWith(
        fontSize: fs,
        fontWeight: FontWeight.w700,
      ),
      horizontalRuleColor: softBorder,
      codeBackgroundColor: subtleFill,
      quoteBorderColor: textColor.withValues(alpha: 0.35),
      quoteBackgroundColor: textColor.withValues(alpha: 0.04),
      tableBorderColor: softBorder,
      tableHeaderBackgroundColor: subtleFill,
      detailsBorderColor: softBorder,
      detailsBackgroundColor: textColor.withValues(alpha: 0.04),
      blockSpacing: 6,
      listIndent: 18,
      quoteBorderWidth: 3,
      imageMaxHeight: 280,
      tableCellMinWidth: 112,
      codePadding: const EdgeInsets.all(12),
      quotePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      tableCellPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      detailsHeaderPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      detailsBodyPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      codeRadius: BorderRadius.circular(10),
      tableRadius: BorderRadius.circular(10),
      detailsRadius: BorderRadius.circular(10),
    );
  }

  static MarkdownTheme chatBubbleDefaults(
    TextStyle baseStyle, {
    bool isOutgoing = false,
  }) {
    final fallback = htmlDefaults(baseStyle);
    final textColor = isOutgoing
        ? const Color(0xFFF8FAFC)
        : (baseStyle.color ?? const Color(0xFF0F172A));
    final mutedText = textColor.withValues(alpha: isOutgoing ? 0.82 : 0.7);
    final borderColor = isOutgoing
        ? const Color(0x33FFFFFF)
        : const Color(0x1F0F172A);
    final subtleFill = isOutgoing
        ? const Color(0x14FFFFFF)
        : const Color(0x080F172A);
    final headerFill = isOutgoing
        ? const Color(0x1FFFFFFF)
        : const Color(0x100F172A);

    return fallback.copyWith(
      style: () => baseStyle.copyWith(color: textColor, height: 1.5),
      linkStyle: () => baseStyle.copyWith(
        color: isOutgoing ? const Color(0xFFBFDBFE) : const Color(0xFF0F766E),
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w600,
      ),
      codeStyle: () => fallback.codeStyle?.copyWith(color: textColor),
      codeLanguageStyle: () =>
          fallback.codeLanguageStyle?.copyWith(color: mutedText),
      quoteStyle: () => baseStyle.copyWith(color: textColor, height: 1.5),
      tableHeaderStyle: () =>
          baseStyle.copyWith(color: textColor, fontWeight: FontWeight.w700),
      tableCellStyle: () => baseStyle.copyWith(color: textColor),
      footnoteLabelStyle: () =>
          fallback.footnoteLabelStyle?.copyWith(color: textColor),
      imageCaptionStyle: () => baseStyle.copyWith(
        color: mutedText,
        fontSize: (baseStyle.fontSize ?? 14) * 0.88,
      ),
      detailsSummaryStyle: () =>
          baseStyle.copyWith(color: textColor, fontWeight: FontWeight.w700),
      horizontalRuleColor: () => borderColor,
      codeBackgroundColor: () => subtleFill,
      quoteBorderColor: () =>
          isOutgoing ? const Color(0x99FFFFFF) : const Color(0xFF94A3B8),
      quoteBackgroundColor: () => subtleFill,
      tableBorderColor: () => borderColor,
      tableHeaderBackgroundColor: () => headerFill,
      detailsBorderColor: () => borderColor,
      detailsBackgroundColor: () => subtleFill,
      blockSpacing: () => 5,
      listIndent: () => 16,
      quoteBorderWidth: () => 2.5,
      imageMaxHeight: () => 220,
      tableCellMinWidth: () => 72,
      codePadding: () =>
          const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      quotePadding: () =>
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      tableCellPadding: () =>
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      detailsHeaderPadding: () =>
          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      detailsBodyPadding: () => const EdgeInsets.fromLTRB(10, 0, 10, 10),
      codeRadius: () => BorderRadius.circular(10),
      tableRadius: () => BorderRadius.circular(12),
      detailsRadius: () => BorderRadius.circular(12),
    );
  }

  MarkdownTheme withFallback(MarkdownTheme fallback) {
    return MarkdownTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      style: style ?? fallback.style,
      linkStyle: linkStyle ?? fallback.linkStyle,
      codeStyle: codeStyle ?? fallback.codeStyle,
      codeLanguageStyle: codeLanguageStyle ?? fallback.codeLanguageStyle,
      mathStyle: mathStyle ?? fallback.mathStyle,
      quoteStyle: quoteStyle ?? fallback.quoteStyle,
      tableHeaderStyle: tableHeaderStyle ?? fallback.tableHeaderStyle,
      tableCellStyle: tableCellStyle ?? fallback.tableCellStyle,
      footnoteLabelStyle: footnoteLabelStyle ?? fallback.footnoteLabelStyle,
      imageCaptionStyle: imageCaptionStyle ?? fallback.imageCaptionStyle,
      detailsSummaryStyle: detailsSummaryStyle ?? fallback.detailsSummaryStyle,
      heading1Style: heading1Style ?? fallback.heading1Style,
      heading2Style: heading2Style ?? fallback.heading2Style,
      heading3Style: heading3Style ?? fallback.heading3Style,
      heading4Style: heading4Style ?? fallback.heading4Style,
      heading5Style: heading5Style ?? fallback.heading5Style,
      heading6Style: heading6Style ?? fallback.heading6Style,
      horizontalRuleColor: horizontalRuleColor ?? fallback.horizontalRuleColor,
      codeBackgroundColor: codeBackgroundColor ?? fallback.codeBackgroundColor,
      quoteBorderColor: quoteBorderColor ?? fallback.quoteBorderColor,
      quoteBackgroundColor:
          quoteBackgroundColor ?? fallback.quoteBackgroundColor,
      tableBorderColor: tableBorderColor ?? fallback.tableBorderColor,
      tableHeaderBackgroundColor:
          tableHeaderBackgroundColor ?? fallback.tableHeaderBackgroundColor,
      detailsBorderColor: detailsBorderColor ?? fallback.detailsBorderColor,
      detailsBackgroundColor:
          detailsBackgroundColor ?? fallback.detailsBackgroundColor,
      blockSpacing: blockSpacing ?? fallback.blockSpacing,
      listIndent: listIndent ?? fallback.listIndent,
      quoteBorderWidth: quoteBorderWidth ?? fallback.quoteBorderWidth,
      imageMaxHeight: imageMaxHeight ?? fallback.imageMaxHeight,
      tableCellMinWidth: tableCellMinWidth ?? fallback.tableCellMinWidth,
      codePadding: codePadding ?? fallback.codePadding,
      quotePadding: quotePadding ?? fallback.quotePadding,
      tableCellPadding: tableCellPadding ?? fallback.tableCellPadding,
      detailsHeaderPadding:
          detailsHeaderPadding ?? fallback.detailsHeaderPadding,
      detailsBodyPadding: detailsBodyPadding ?? fallback.detailsBodyPadding,
      codeRadius: codeRadius ?? fallback.codeRadius,
      tableRadius: tableRadius ?? fallback.tableRadius,
      detailsRadius: detailsRadius ?? fallback.detailsRadius,
    );
  }

  MarkdownTheme copyWith({
    ValueGetter<TextStyle?>? style,
    ValueGetter<TextStyle?>? linkStyle,
    ValueGetter<TextStyle?>? codeStyle,
    ValueGetter<TextStyle?>? codeLanguageStyle,
    ValueGetter<TextStyle?>? mathStyle,
    ValueGetter<TextStyle?>? quoteStyle,
    ValueGetter<TextStyle?>? tableHeaderStyle,
    ValueGetter<TextStyle?>? tableCellStyle,
    ValueGetter<TextStyle?>? footnoteLabelStyle,
    ValueGetter<TextStyle?>? imageCaptionStyle,
    ValueGetter<TextStyle?>? detailsSummaryStyle,
    ValueGetter<TextStyle?>? heading1Style,
    ValueGetter<TextStyle?>? heading2Style,
    ValueGetter<TextStyle?>? heading3Style,
    ValueGetter<TextStyle?>? heading4Style,
    ValueGetter<TextStyle?>? heading5Style,
    ValueGetter<TextStyle?>? heading6Style,
    ValueGetter<Color?>? horizontalRuleColor,
    ValueGetter<Color?>? codeBackgroundColor,
    ValueGetter<Color?>? quoteBorderColor,
    ValueGetter<Color?>? quoteBackgroundColor,
    ValueGetter<Color?>? tableBorderColor,
    ValueGetter<Color?>? tableHeaderBackgroundColor,
    ValueGetter<Color?>? detailsBorderColor,
    ValueGetter<Color?>? detailsBackgroundColor,
    ValueGetter<double?>? blockSpacing,
    ValueGetter<double?>? listIndent,
    ValueGetter<double?>? quoteBorderWidth,
    ValueGetter<double?>? imageMaxHeight,
    ValueGetter<double?>? tableCellMinWidth,
    ValueGetter<EdgeInsetsGeometry?>? codePadding,
    ValueGetter<EdgeInsetsGeometry?>? quotePadding,
    ValueGetter<EdgeInsetsGeometry?>? tableCellPadding,
    ValueGetter<EdgeInsetsGeometry?>? detailsHeaderPadding,
    ValueGetter<EdgeInsetsGeometry?>? detailsBodyPadding,
    ValueGetter<BorderRadiusGeometry?>? codeRadius,
    ValueGetter<BorderRadiusGeometry?>? tableRadius,
    ValueGetter<BorderRadiusGeometry?>? detailsRadius,
  }) {
    return MarkdownTheme(
      style: style == null ? this.style : style(),
      linkStyle: linkStyle == null ? this.linkStyle : linkStyle(),
      codeStyle: codeStyle == null ? this.codeStyle : codeStyle(),
      codeLanguageStyle: codeLanguageStyle == null
          ? this.codeLanguageStyle
          : codeLanguageStyle(),
      mathStyle: mathStyle == null ? this.mathStyle : mathStyle(),
      quoteStyle: quoteStyle == null ? this.quoteStyle : quoteStyle(),
      tableHeaderStyle: tableHeaderStyle == null
          ? this.tableHeaderStyle
          : tableHeaderStyle(),
      tableCellStyle: tableCellStyle == null
          ? this.tableCellStyle
          : tableCellStyle(),
      footnoteLabelStyle: footnoteLabelStyle == null
          ? this.footnoteLabelStyle
          : footnoteLabelStyle(),
      imageCaptionStyle: imageCaptionStyle == null
          ? this.imageCaptionStyle
          : imageCaptionStyle(),
      detailsSummaryStyle: detailsSummaryStyle == null
          ? this.detailsSummaryStyle
          : detailsSummaryStyle(),
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
      codeBackgroundColor: codeBackgroundColor == null
          ? this.codeBackgroundColor
          : codeBackgroundColor(),
      quoteBorderColor: quoteBorderColor == null
          ? this.quoteBorderColor
          : quoteBorderColor(),
      quoteBackgroundColor: quoteBackgroundColor == null
          ? this.quoteBackgroundColor
          : quoteBackgroundColor(),
      tableBorderColor: tableBorderColor == null
          ? this.tableBorderColor
          : tableBorderColor(),
      tableHeaderBackgroundColor: tableHeaderBackgroundColor == null
          ? this.tableHeaderBackgroundColor
          : tableHeaderBackgroundColor(),
      detailsBorderColor: detailsBorderColor == null
          ? this.detailsBorderColor
          : detailsBorderColor(),
      detailsBackgroundColor: detailsBackgroundColor == null
          ? this.detailsBackgroundColor
          : detailsBackgroundColor(),
      blockSpacing: blockSpacing == null ? this.blockSpacing : blockSpacing(),
      listIndent: listIndent == null ? this.listIndent : listIndent(),
      quoteBorderWidth: quoteBorderWidth == null
          ? this.quoteBorderWidth
          : quoteBorderWidth(),
      imageMaxHeight: imageMaxHeight == null
          ? this.imageMaxHeight
          : imageMaxHeight(),
      tableCellMinWidth: tableCellMinWidth == null
          ? this.tableCellMinWidth
          : tableCellMinWidth(),
      codePadding: codePadding == null ? this.codePadding : codePadding(),
      quotePadding: quotePadding == null ? this.quotePadding : quotePadding(),
      tableCellPadding: tableCellPadding == null
          ? this.tableCellPadding
          : tableCellPadding(),
      detailsHeaderPadding: detailsHeaderPadding == null
          ? this.detailsHeaderPadding
          : detailsHeaderPadding(),
      detailsBodyPadding: detailsBodyPadding == null
          ? this.detailsBodyPadding
          : detailsBodyPadding(),
      codeRadius: codeRadius == null ? this.codeRadius : codeRadius(),
      tableRadius: tableRadius == null ? this.tableRadius : tableRadius(),
      detailsRadius: detailsRadius == null
          ? this.detailsRadius
          : detailsRadius(),
    );
  }
}
