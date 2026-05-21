// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:flutter/widgets.dart';

import '../../../markdown.dart';

// ═══════════════════════════════════════════════════════════
// COMPONENT THEME TOKENS
// User customization layer (replace this file from website output)
// Defaults intentionally mirror MarkdownThemeDefaults where values are static
// ═══════════════════════════════════════════════════════════

class MarkdownThemeTokens {
  const MarkdownThemeTokens({
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
    this.blockSpacing = 6.0,
    this.listIndent = 18.0,
    this.quoteBorderWidth = 3.0,
    this.imageMaxHeight = 280.0,
    this.tableCellMinWidth = 112.0,
    this.codePadding = const EdgeInsets.all(12.0),
    this.quotePadding = const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 8.0,
    ),
    this.tableCellPadding = const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 10.0,
    ),
    this.detailsHeaderPadding = const EdgeInsets.symmetric(
      horizontal: 12.0,
      vertical: 10.0,
    ),
    this.detailsBodyPadding = const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
    this.codeRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.tableRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.detailsRadius = const BorderRadius.all(Radius.circular(10.0)),
    this.ignoreGlobalScaling = false,
    this.ignoreGlobalRadius = false,
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
  final double blockSpacing;
  final double listIndent;
  final double quoteBorderWidth;
  final double imageMaxHeight;
  final double tableCellMinWidth;
  final EdgeInsetsGeometry codePadding;
  final EdgeInsetsGeometry quotePadding;
  final EdgeInsetsGeometry tableCellPadding;
  final EdgeInsetsGeometry detailsHeaderPadding;
  final EdgeInsetsGeometry detailsBodyPadding;
  final BorderRadiusGeometry codeRadius;
  final BorderRadiusGeometry tableRadius;
  final BorderRadiusGeometry detailsRadius;
  final bool ignoreGlobalScaling;
  final bool ignoreGlobalRadius;

  MarkdownTheme toTheme() {
    return MarkdownTheme(
      style: style,
      linkStyle: linkStyle,
      codeStyle: codeStyle,
      codeLanguageStyle: codeLanguageStyle,
      mathStyle: mathStyle,
      quoteStyle: quoteStyle,
      tableHeaderStyle: tableHeaderStyle,
      tableCellStyle: tableCellStyle,
      footnoteLabelStyle: footnoteLabelStyle,
      imageCaptionStyle: imageCaptionStyle,
      detailsSummaryStyle: detailsSummaryStyle,
      heading1Style: heading1Style,
      heading2Style: heading2Style,
      heading3Style: heading3Style,
      heading4Style: heading4Style,
      heading5Style: heading5Style,
      heading6Style: heading6Style,
      horizontalRuleColor: horizontalRuleColor,
      codeBackgroundColor: codeBackgroundColor,
      quoteBorderColor: quoteBorderColor,
      quoteBackgroundColor: quoteBackgroundColor,
      tableBorderColor: tableBorderColor,
      tableHeaderBackgroundColor: tableHeaderBackgroundColor,
      detailsBorderColor: detailsBorderColor,
      detailsBackgroundColor: detailsBackgroundColor,
      blockSpacing: blockSpacing,
      listIndent: listIndent,
      quoteBorderWidth: quoteBorderWidth,
      imageMaxHeight: imageMaxHeight,
      tableCellMinWidth: tableCellMinWidth,
      codePadding: codePadding,
      quotePadding: quotePadding,
      tableCellPadding: tableCellPadding,
      detailsHeaderPadding: detailsHeaderPadding,
      detailsBodyPadding: detailsBodyPadding,
      codeRadius: codeRadius,
      tableRadius: tableRadius,
      detailsRadius: detailsRadius,
    );
  }
}

const markdownThemeTokens = MarkdownThemeTokens();
