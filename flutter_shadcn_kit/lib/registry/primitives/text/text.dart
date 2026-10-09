import 'package:flutter/services.dart' show SystemMouseCursors;
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';
import 'list.dart';

/// Computes a text property from the ambient theme.
///
/// Every slot a modifier offers ([style], [textAlign], [softWrap], [overflow],
/// [maxLines], [textWidthBasis]) is a builder rather than a value, so the same
/// modifier widget can be rebuilt against a different theme.
typedef WrappedTextDataBuilder<T> =
    T Function(BuildContext context, ShadcnThemeData theme);

/// Wraps the wrapped child in extra widgets (padding, borders, ...).
typedef WidgetTextWrapper = Widget Function(BuildContext context, Widget child);

/// Base of the fluent text modifiers added to every [Widget] by
/// [TextExtension].
///
/// A modifier is a widget: drop it in a tree, or call it to derive a new
/// modifier with a style override merged into the existing one.
///
/// ```dart
/// Text('Total').large.bold.muted;
/// ```
abstract class TextModifier extends StatelessWidget {
  /// Creates a [TextModifier].
  const TextModifier({super.key});

  /// Returns a modifier whose style is this one's style merged with the given
  /// properties.
  ///
  /// Where both define a property, the style already on this modifier wins and
  /// the argument only fills gaps. Passing nothing is the identity.
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
  });
}

/// The default [TextModifier]: resolves its builders against the ambient
/// [ShadcnTheme] and installs the result as a merged [DefaultTextStyle].
///
/// [wrapper] runs outside the style merge, so decorations and padding around
/// the text do not inherit the modifier's text style.
class WrappedText extends TextModifier {
  /// Creates a modifier over [child].
  const WrappedText({
    super.key,
    this.style,
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.wrapper,
    required this.child,
  });

  /// Style builder installed as the default text style.
  final WrappedTextDataBuilder<TextStyle>? style;

  /// Text alignment builder.
  final WrappedTextDataBuilder<TextAlign>? textAlign;

  /// Soft-wrap builder.
  final WrappedTextDataBuilder<bool>? softWrap;

  /// Overflow builder.
  final WrappedTextDataBuilder<TextOverflow>? overflow;

  /// Maximum line count builder.
  final WrappedTextDataBuilder<int>? maxLines;

  /// Text width basis builder.
  final WrappedTextDataBuilder<TextWidthBasis>? textWidthBasis;

  /// Extra widgets placed around the child.
  final WidgetTextWrapper? wrapper;

  /// The widget being modified.
  final Widget child;

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

  @override
  Widget build(BuildContext context) {
    final theme = ShadcnTheme.of(context);
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

  /// Copies this modifier, replacing only the arguments that are given.
  ///
  /// Each argument is a getter so a builder can be built lazily; omitting an
  /// argument keeps the current value.
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
      style: style == null ? this.style : style(),
      textAlign: textAlign == null ? this.textAlign : textAlign(),
      softWrap: softWrap == null ? this.softWrap : softWrap(),
      overflow: overflow == null ? this.overflow : overflow(),
      maxLines: maxLines == null ? this.maxLines : maxLines(),
      textWidthBasis: textWidthBasis == null
          ? this.textWidthBasis
          : textWidthBasis(),
      wrapper: wrapper == null ? this.wrapper : wrapper(),
      child: child == null ? this.child : child(),
    );
  }

  /// Copies this modifier with [style] merged underneath the current style.
  ///
  /// The style already set here wins wherever both define a property; [style]
  /// fills in the rest. That is what makes `Text('x').large.call(fontSize: 12)`
  /// keep the large size and only take the colour from the argument.
  WrappedText copyWithStyle(WrappedTextDataBuilder<TextStyle> style) {
    return WrappedText(
      style: (context, theme) =>
          style(context, theme).merge(this.style?.call(context, theme)),
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      wrapper: wrapper,
      child: child,
    );
  }
}

/// Appends an inline span to the text held by this widget.
///
/// Supports [Text] and [RichText]; anything else throws. Chaining works — each
/// call returns another appender carrying the spans collected so far.
///
/// ```dart
/// Text('Total: ').then(TextSpan(text: '\$42'));
/// ```
extension TextThenExtension on Widget {
  /// Returns a widget rendering this one's text with [span] appended.
  Widget then(InlineSpan span) {
    if (this is RichText) {
      return _RichTextThenWidget(text: this as RichText, then: [span]);
    }
    if (this is _RichTextThenWidget) {
      final appender = this as _RichTextThenWidget;
      return _RichTextThenWidget(
        text: appender.text,
        then: [...appender.then, span],
      );
    }
    if (this is Text) {
      return _TextThenWidget(text: this as Text, then: [span]);
    }
    if (this is _TextThenWidget) {
      final appender = this as _TextThenWidget;
      return _TextThenWidget(
        text: appender.text,
        then: [...appender.then, span],
      );
    }
    throw ArgumentError.value(
      this,
      'this',
      'then() can only be used on Text or RichText widgets',
    );
  }
}

/// A [Text] rendered as rich text with extra spans appended.
class _TextThenWidget extends StatelessWidget {
  const _TextThenWidget({required this.text, required this.then});

  final Text text;
  final List<InlineSpan> then;

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = DefaultTextStyle.of(context);
    var style = text.style;
    if (style == null || style.inherit) {
      style = defaultTextStyle.style.merge(style);
    }
    if (MediaQuery.boldTextOf(context)) {
      style = style.merge(const TextStyle(fontWeight: FontWeight.bold));
    }
    final registrar = SelectionContainer.maybeOf(context);
    Widget result = RichText(
      textAlign:
          text.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: text.textDirection,
      locale: text.locale,
      softWrap: text.softWrap ?? defaultTextStyle.softWrap,
      overflow: text.overflow ?? style.overflow ?? defaultTextStyle.overflow,
      textScaler: text.textScaler ?? MediaQuery.textScalerOf(context),
      maxLines: text.maxLines ?? defaultTextStyle.maxLines,
      strutStyle: text.strutStyle,
      textWidthBasis: text.textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior:
          text.textHeightBehavior ?? defaultTextStyle.textHeightBehavior,
      selectionRegistrar: registrar,
      selectionColor: text.selectionColor,
      text: TextSpan(
        style: style,
        children: [
          text.data == null ? text.textSpan! : TextSpan(text: text.data),
          ...then,
        ],
      ),
    );
    if (registrar != null) {
      result = MouseRegion(
        cursor:
            DefaultSelectionStyle.of(context).mouseCursor ??
            SystemMouseCursors.text,
        child: result,
      );
    }
    if (text.semanticsLabel != null) {
      result = Semantics(
        textDirection: text.textDirection,
        label: text.semanticsLabel,
        child: ExcludeSemantics(child: result),
      );
    }
    return result;
  }
}

/// A [RichText] with extra spans appended to its own span.
class _RichTextThenWidget extends StatelessWidget {
  const _RichTextThenWidget({required this.text, required this.then});

  final RichText text;
  final List<InlineSpan> then;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [text.text, ...then]),
      textAlign: text.textAlign,
      textDirection: text.textDirection,
      locale: text.locale,
      softWrap: text.softWrap,
      overflow: text.overflow,
      textScaler: text.textScaler,
      maxLines: text.maxLines,
      strutStyle: text.strutStyle,
      textWidthBasis: text.textWidthBasis,
      textHeightBehavior: text.textHeightBehavior,
      selectionRegistrar: text.selectionRegistrar,
      selectionColor: text.selectionColor,
    );
  }
}
