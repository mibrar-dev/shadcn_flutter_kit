// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// A widget that wraps text with customizable styling and layout.
///
/// [WrappedText] provides a declarative way to apply text styles and
/// transformations using builder functions. It implements [TextModifier]
/// and is the foundation for the fluent text styling API.
///
/// All style properties are computed dynamically using builder functions
/// that receive the current [BuildContext] and [ThemeData], enabling
/// theme-aware and responsive text styling.
class WrappedText extends StatelessWidget implements TextModifier {
  /// The child widget to wrap with styling.
  final Widget child;

  /// Builder for the text style.
  final WrappedTextDataBuilder<TextStyle?>? style;

  /// Builder for text alignment.
  final WrappedTextDataBuilder<TextAlign?>? textAlign;

  /// Builder for soft wrap behavior.
  final WrappedTextDataBuilder<bool?>? softWrap;

  /// Builder for text overflow handling.
  final WrappedTextDataBuilder<TextOverflow?>? overflow;

  /// Builder for maximum number of lines.
  final WrappedTextDataBuilder<int?>? maxLines;

  /// Builder for text width basis.
  final WrappedTextDataBuilder<TextWidthBasis?>? textWidthBasis;

  /// Optional wrapper function to add container widgets around the child.
  final WidgetTextWrapper? wrapper;

  /// Creates a [WrappedText].
  ///
  /// All styling parameters are optional and use builder functions for
  /// dynamic, theme-aware styling.
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): Widget to apply styling to.
  /// - [style] (`WrappedTextDataBuilder<TextStyle?>?`, optional): Text style builder.
  /// - [textAlign] (`WrappedTextDataBuilder<TextAlign?>?`, optional): Text alignment builder.
  /// - [softWrap] (`WrappedTextDataBuilder<bool?>?`, optional): Soft wrap builder.
  /// - [overflow] (`WrappedTextDataBuilder<TextOverflow?>?`, optional): Overflow handling builder.
  /// - [maxLines] (`WrappedTextDataBuilder<int?>?`, optional): Max lines builder.
  /// - [textWidthBasis] (`WrappedTextDataBuilder<TextWidthBasis?>?`, optional): Text width basis builder.
  /// - [wrapper] (`WidgetTextWrapper?`, optional): Container wrapper function.
  const WrappedText({
    super.key,
    required this.child,
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.wrapper,
  });

  @override
  Widget call({
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }) {
    return copyWithStyle(
      (context, theme) => TextStyle(
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        fontVariations: fontVariations,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        overflow: overflow,
      ),
    );
  }

  /// Builds the widget tree for text.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTextStyle.merge(
      child: wrapper?.call(context, child) ?? child,
      style: style?.call(context, theme),
      textAlign: textAlign?.call(context, theme),
      softWrap: softWrap?.call(context, theme),
      overflow: overflow?.call(context, theme),
      maxLines: maxLines?.call(context, theme),
      textWidthBasis: textWidthBasis?.call(context, theme),
    );
  }

  /// Creates a copy of this [WrappedText] with modified properties.
  ///
  /// Each parameter is a builder function that, if provided, will
  /// replace the corresponding property in the new instance.
  /// If a parameter is `null`, the existing property value is retained.
  ///
  /// Parameters:
  /// - [style] (`ValueGetter<WrappedTextDataBuilder<TextStyle>?>?`, optional): New style builder.
  /// - [textAlign] (`ValueGetter<WrappedTextDataBuilder<TextAlign>?>?`, optional): New text alignment builder.
  /// - [softWrap] (`ValueGetter<WrappedTextDataBuilder<bool>?>?`, optional): New soft wrap builder.
  /// - [overflow] (`ValueGetter<WrappedTextDataBuilder<TextOverflow>?>?`, optional): New overflow handling builder.
  /// - [maxLines] (`ValueGetter<WrappedTextDataBuilder<int>?>?`, optional): New max lines builder.
  /// - [textWidthBasis] (`ValueGetter<WrappedTextDataBuilder<TextWidthBasis>?>?`, optional): New text width basis builder.
  /// - [wrapper] (`ValueGetter<WidgetTextWrapper?>?`, optional): New container wrapper function.
  /// - [child] (`ValueGetter<Widget>?`, optional): New child widget.
  WrappedText copyWith({
    ValueGetter<WrappedTextDataBuilder<TextStyle>?>? style,
    ValueGetter<WrappedTextDataBuilder<TextAlign>?>? textAlign,
    ValueGetter<WrappedTextDataBuilder<bool>?>? softWrap,
    ValueGetter<WrappedTextDataBuilder<TextOverflow>?>? overflow,
    ValueGetter<WrappedTextDataBuilder<int>?>? maxLines,
    ValueGetter<WrappedTextDataBuilder<TextWidthBasis>?>? textWidthBasis,
    ValueGetter<WidgetTextWrapper?>? wrapper,
    ValueGetter<Widget>? child,
  }) {
    return WrappedText(
      wrapper: wrapper == null ? this.wrapper : wrapper(),
      style: style == null ? this.style : style(),
      textAlign: textAlign == null ? this.textAlign : textAlign(),
      softWrap: softWrap == null ? this.softWrap : softWrap(),
      overflow: overflow == null ? this.overflow : overflow(),
      maxLines: maxLines == null ? this.maxLines : maxLines(),
      textWidthBasis: textWidthBasis == null
          ? this.textWidthBasis
          : textWidthBasis(),
      child: child == null ? this.child : child(),
    );
  }

  /// Creates a copy of this [WrappedText] with an updated style.
  ///
  /// The provided [style] builder is merged with the existing style.
  ///
  /// Parameters:
  /// - [style] (`WrappedTextDataBuilder<TextStyle>`, required): New style builder to merge.
  WrappedText copyWithStyle(WrappedTextDataBuilder<TextStyle> style) {
    return WrappedText(
      wrapper: wrapper,
      style: (context, theme) =>
          style(context, theme).merge(this.style?.call(context, theme)),
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      child: child,
    );
  }
}
