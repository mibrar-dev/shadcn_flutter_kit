// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'package:data_widget/data_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/theme/theme.dart';
import '../../control/button/button.dart';
import '../selectable/selectable.dart';

part '_impl/core/_rich_text_then_widget.dart';
part '_impl/core/_selectable_text_then_widget.dart';
part '_impl/core/_text_then_widget.dart';
part '_impl/core/unordered_list_data.dart';
part '_impl/core/wrapped_text.dart';

/// Abstract base class for text modifier widgets.
///
/// Text modifiers provide a fluent API for applying text styles and
/// transformations. They extend [Widget] and can be called as functions
/// to apply additional style properties.
///
/// Use the [TextExtension] methods to create and chain text modifiers.
abstract class TextModifier extends Widget {
  /// Creates a [TextModifier].
  const TextModifier({super.key});

  /// Applies additional text style properties to this modifier.
  ///
  /// All parameters are optional and can be used to override or extend
  /// the current text styling.
  ///
  /// Parameters:
  /// - [color] (`Color?`, optional): Text color.
  /// - [backgroundColor] (`Color?`, optional): Background color for text.
  /// - [fontSize] (`double?`, optional): Font size in logical pixels.
  /// - [fontWeight] (`FontWeight?`, optional): Font weight (e.g., bold, normal).
  /// - [fontStyle] (`FontStyle?`, optional): Font style (e.g., italic, normal).
  /// - [letterSpacing] (`double?`, optional): Space between letters.
  /// - [wordSpacing] (`double?`, optional): Space between words.
  /// - [textBaseline] (`TextBaseline?`, optional): Text baseline alignment.
  /// - [height] (`double?`, optional): Line height multiplier.
  /// - [leadingDistribution] (`TextLeadingDistribution?`, optional): How to distribute line height.
  /// - [locale] (`Locale?`, optional): Locale for font selection.
  /// - [foreground] (`Paint?`, optional): Custom foreground paint.
  /// - [background] (`Paint?`, optional): Custom background paint.
  /// - [shadows] (`List<Shadow>?`, optional): Text shadows.
  /// - [fontFeatures] (`List<FontFeature>?`, optional): OpenType font features.
  /// - [fontVariations] (`List<FontVariation>?`, optional): Font variations.
  /// - [decoration] (`TextDecoration?`, optional): Text decoration (underline, etc.).
  /// - [decorationColor] (`Color?`, optional): Decoration color.
  /// - [decorationStyle] (`TextDecorationStyle?`, optional): Decoration style.
  /// - [decorationThickness] (`double?`, optional): Decoration thickness.
  /// - [debugLabel] (`String?`, optional): Debug label for text style.
  /// - [fontFamily] (`String?`, optional): Font family name.
  /// - [fontFamilyFallback] (`List<String>?`, optional): Fallback font families.
  /// - [package] (`String?`, optional): Package containing the font.
  /// - [overflow] (`TextOverflow?`, optional): How to handle text overflow.
  ///
  /// Returns: `Widget` — the modified text widget.
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

/// Extension providing text styling modifiers for widgets.
///
/// This extension adds a fluent API for applying text styles to widgets.
/// Each property returns a [TextModifier] that can be further chained.
///
/// Example:
/// ```dart
/// Text('Hello').sans.large.bold.muted
/// ```
extension TextExtension on Widget {
  /// Applies sans-serif font family.
  TextModifier get sans => WrappedText(
    style: (context, theme) => theme.typography.sans,
    child: this,
  );

  /// Applies monospace font family.
  TextModifier get mono => WrappedText(
    style: (context, theme) => theme.typography.mono,
    child: this,
  );

  /// Applies extra-small font size.
  TextModifier get xSmall => WrappedText(
    style: (context, theme) => theme.typography.xSmall,
    child: this,
  );

  /// Applies small font size.
  TextModifier get small => WrappedText(
    style: (context, theme) => theme.typography.small,
    child: this,
  );

  /// Applies base (default) font size.
  TextModifier get base => WrappedText(
    style: (context, theme) => theme.typography.base,
    child: this,
  );

  /// Applies large font size.
  TextModifier get large => WrappedText(
    style: (context, theme) => theme.typography.large,
    child: this,
  );

  /// Applies extra-large font size.
  TextModifier get xLarge => WrappedText(
    style: (context, theme) => theme.typography.xLarge,
    child: this,
  );

  /// Applies 2x large font size.
  TextModifier get x2Large => WrappedText(
    style: (context, theme) => theme.typography.x2Large,
    child: this,
  );

  /// Applies 3x large font size.
  TextModifier get x3Large => WrappedText(
    style: (context, theme) => theme.typography.x3Large,
    child: this,
  );

  /// Applies 4x large font size.
  TextModifier get x4Large => WrappedText(
    style: (context, theme) => theme.typography.x4Large,
    child: this,
  );

  /// Applies 5x large font size.
  TextModifier get x5Large => WrappedText(
    style: (context, theme) => theme.typography.x5Large,
    child: this,
  );

  /// Applies 6x large font size.
  TextModifier get x6Large => WrappedText(
    style: (context, theme) => theme.typography.x6Large,
    child: this,
  );

  /// Applies 7x large font size.
  TextModifier get x7Large => WrappedText(
    style: (context, theme) => theme.typography.x7Large,
    child: this,
  );

  /// Applies 8x large font size.
  TextModifier get x8Large => WrappedText(
    style: (context, theme) => theme.typography.x8Large,
    child: this,
  );

  /// Applies 9x large font size.
  TextModifier get x9Large => WrappedText(
    style: (context, theme) => theme.typography.x9Large,
    child: this,
  );

  /// Applies thin font weight (100).
  TextModifier get thin => WrappedText(
    style: (context, theme) => theme.typography.thin,
    child: this,
  );

  /// Applies extra-light font weight (200).
  TextModifier get extraLight => WrappedText(
    style: (context, theme) => theme.typography.extraLight,
    child: this,
  );

  /// Applies light font weight (300).
  TextModifier get light => WrappedText(
    style: (context, theme) => theme.typography.light,
    child: this,
  );

  /// Applies normal font weight (400).
  TextModifier get normal => WrappedText(
    style: (context, theme) => theme.typography.normal,
    child: this,
  );

  /// Applies medium font weight (500).
  TextModifier get medium => WrappedText(
    style: (context, theme) => theme.typography.medium,
    child: this,
  );

  /// Applies semi-bold font weight (600).
  TextModifier get semiBold => WrappedText(
    style: (context, theme) => theme.typography.semiBold,
    child: this,
  );

  /// Applies bold font weight (700).
  TextModifier get bold => WrappedText(
    style: (context, theme) => theme.typography.bold,
    child: this,
  );

  /// Applies extra-bold font weight (800).
  TextModifier get extraBold => WrappedText(
    style: (context, theme) => theme.typography.extraBold,
    child: this,
  );

  /// Applies black font weight (900).
  TextModifier get black => WrappedText(
    style: (context, theme) => theme.typography.black,
    child: this,
  );

  /// Applies italic font style.
  TextModifier get italic => WrappedText(
    style: (context, theme) => theme.typography.italic,
    child: this,
  );

  /// Applies underline text decoration.
  TextModifier get underline => WrappedText(
    style: (context, theme) =>
        const TextStyle(decoration: TextDecoration.underline),
    child: this,
  );

  /// Applies muted foreground color.
  TextModifier get muted => WrappedText(
    style: (context, theme) =>
        TextStyle(color: theme.colorScheme.mutedForeground),
    child: this,
  );

  /// Applies primary foreground color.
  TextModifier get primaryForeground => WrappedText(
    style: (context, theme) =>
        TextStyle(color: theme.colorScheme.primaryForeground),
    child: this,
  );

  /// Applies secondary foreground color.
  TextModifier get secondaryForeground => WrappedText(
    style: (context, theme) =>
        TextStyle(color: theme.colorScheme.secondaryForeground),
    child: this,
  );

  /// Applies heading 1 style.
  TextModifier get h1 =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(style: (context, theme) => theme.typography.h1, child: this);

  /// Applies heading 2 style with bottom border.
  TextModifier get h2 => WrappedText(
    style: (context, theme) => theme.typography.h2,
    wrapper: (context, child) => Container(
      margin: EdgeInsets.only(
        top: Theme.of(context).density.baseContainerPadding * 2.5,
      ),
      padding: EdgeInsets.only(bottom: Theme.of(context).density.baseGap),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.border,
            width: 1,
          ),
        ),
      ),
      child: child,
    ),
    child: this,
  );

  /// Applies heading 3 style.
  TextModifier get h3 =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(style: (context, theme) => theme.typography.h3, child: this);

  /// Applies heading 4 style.
  TextModifier get h4 =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(style: (context, theme) => theme.typography.h4, child: this);

  /// Applies paragraph style with top spacing.
  TextModifier get p => WrappedText(
    style: (context, theme) => theme.typography.p,
    child: this,
    wrapper: (context, child) {
      return Padding(
        padding: EdgeInsets.only(
          top: Theme.of(context).density.baseContainerPadding * 1.5,
        ),
        child: child,
      );
    },
  );

  /// Applies paragraph style for the first paragraph (no top spacing).
  TextModifier get firstP =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(style: (context, theme) => theme.typography.p, child: this);

  /// Applies block quote style with left border.
  TextModifier get blockQuote => WrappedText(
    style: (context, theme) => theme.typography.blockQuote,
    wrapper: (context, child) => Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.border,
            width: 2,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: Theme.of(context).density.baseContentPadding,
      ),
      child: child,
    ),
    child: this,
  );

  /// Applies list item style with bullet point.
  ///
  /// Automatically adds a bullet point and indents nested list items.
  TextModifier get li => WrappedText(
    wrapper: (context, child) {
      UnorderedListData? data = Data.maybeOf(context);

      int depth = data?.depth ?? 0;
      TextStyle style = DefaultTextStyle.of(context).style;
      double size = (style.fontSize ?? 12) / 16 * 6;
      return IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ((style.fontSize ?? 12) * (style.height ?? 1)) * 1.2,
              child: getBullet(context, depth, size),
            ),

            SizedBox(width: Theme.of(context).density.baseGap),

            Expanded(
              child: Data.inherit(
                data: UnorderedListData(depth: depth + 1),
                child: child,
              ),
            ),
          ],
        ),
      );
    },
    child: this,
  );

  /// Applies inline code style with background and padding.
  TextModifier get inlineCode => WrappedText(
    style: (context, theme) => theme.typography.inlineCode,
    wrapper: (context, child) {
      final style = DefaultTextStyle.of(context).style;

      final double paddingVertical = style.fontSize! * 0.2;

      final double paddingHorizontal = style.fontSize! * 0.3;
      final ThemeData themeData = Theme.of(context);
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.muted,
          borderRadius: BorderRadius.circular(themeData.radiusSm),
        ),
        child: child,
      );
    },
    child: this,
  );

  /// Applies lead paragraph style with muted color.
  TextModifier get lead => WrappedText(
    style: (context, theme) => theme.typography.lead,
    child: this,
  ).muted;

  /// Applies large text style.
  TextModifier get textLarge => WrappedText(
    style: (context, theme) => theme.typography.textLarge,
    child: this,
  );

  /// Applies small text style.
  TextModifier get textSmall => WrappedText(
    style: (context, theme) => theme.typography.textSmall,
    child: this,
  );

  /// Applies muted text style with muted color.
  TextModifier get textMuted => WrappedText(
    style: (context, theme) => theme.typography.textMuted,
    child: this,
  ).muted;

  /// Constrains text to a single line without wrapping.
  TextModifier get singleLine => WrappedText(
    softWrap: (context, theme) => false,
    maxLines: (context, theme) => 1,
    child: this,
  );

  /// Applies ellipsis overflow to text.
  TextModifier get ellipsis => WrappedText(
    overflow: (context, theme) => TextOverflow.ellipsis,
    child: this,
  );

  /// Centers text horizontally.
  TextModifier get textCenter =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(textAlign: (context, theme) => TextAlign.center, child: this);

  /// Right-aligns text.
  TextModifier get textRight =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(textAlign: (context, theme) => TextAlign.right, child: this);

  /// Left-aligns text.
  TextModifier get textLeft =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(textAlign: (context, theme) => TextAlign.left, child: this);

  /// Justifies text alignment.
  TextModifier get textJustify => WrappedText(
    textAlign: (context, theme) => TextAlign.justify,
    child: this,
  );

  /// Aligns text to the start (left in LTR, right in RTL).
  TextModifier get textStart =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(textAlign: (context, theme) => TextAlign.start, child: this);

  /// Aligns text to the end (right in LTR, left in RTL).
  TextModifier get textEnd =>
      /// Implements `WrappedText` behavior for text.
      WrappedText(textAlign: (context, theme) => TextAlign.end, child: this);

  /// Applies primary foreground color modifier.
  TextModifier get modify => WrappedText(
    style: (context, theme) =>
        TextStyle(color: theme.colorScheme.primaryForeground),
    child: this,
  );

  /// Applies standard foreground color.
  TextModifier get foreground => WrappedText(
    style: (context, theme) => TextStyle(color: theme.colorScheme.foreground),
    child: this,
  );

  /// Appends an inline span to the current text widget.
  ///
  /// Allows chaining multiple text spans together. Works with [Text],
  /// [SelectableText], and [RichText] widgets.
  ///
  /// Parameters:
  /// - [span] (`InlineSpan`, required): The span to append.
  ///
  /// Returns: `Widget` — a rich text widget with the appended span.
  ///
  /// Example:
  /// ```dart
  /// Text('Hello ').then(TextSpan(text: 'World'))
  /// ```
  Widget then(InlineSpan span) {
    if (this is RichText) {
      final text = this as RichText;
      return _RichTextThenWidget(text: text, then: [span]);
    }
    if (this is SelectableText) {
      final text = this as SelectableText;
      return _SelectableTextThenWidget(text: text, then: [span]);
    }
    if (this is Text) {
      final text = this as Text;
      return _TextThenWidget(text: text, then: [span]);
    }
    if (this is _RichTextThenWidget) {
      final text = this as _RichTextThenWidget;
      return _RichTextThenWidget(text: text.text, then: [...text.then, span]);
    }
    if (this is _TextThenWidget) {
      final text = this as _TextThenWidget;
      return _TextThenWidget(text: text.text, then: [...text.then, span]);
    }
    if (this is _SelectableTextThenWidget) {
      final text = this as _SelectableTextThenWidget;
      return _SelectableTextThenWidget(
        text: text.text,
        then: [...text.then, span],
      );
    }
    InlineSpan currentSpan = WidgetSpan(child: this);
    return RichText(text: TextSpan(children: [currentSpan, span]));
  }

  /// Appends a text span to the current text widget.
  ///
  /// Convenience method for appending plain text.
  ///
  /// Parameters:
  /// - [text] (`String`, required): Text to append.
  ///
  /// Returns: `Widget` — a rich text widget with the appended text.
  ///
  /// Example:
  /// ```dart
  /// Text('Hello ').thenText('World')
  /// ```
  Widget thenText(String text) {
    return then(TextSpan(text: text));
  }

  /// Appends inline code to the current text widget.
  ///
  /// The appended text is styled as inline code with background.
  ///
  /// Parameters:
  /// - [text] (`String`, required): Code text to append.
  ///
  /// Returns: `Widget` — a rich text widget with the appended code.
  ///
  /// Example:
  /// ```dart
  /// Text('Use ').thenInlineCode('myFunction()')
  /// ```
  Widget thenInlineCode(String text) {
    return then(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Text(text).inlineCode(),
      ),
    );
  }

  /// Appends a button widget to the current text widget.
  ///
  /// Creates an inline button within the text flow.
  ///
  /// Parameters:
  /// - [onPressed] (`VoidCallback`, required): Button press handler.
  /// - [child] (`Widget`, required): Button content.
  ///
  /// Returns: `Widget` — a rich text widget with the appended button.
  ///
  /// Example:
  /// ```dart
  /// Text('Click ').thenButton(
  ///   onPressed: () => print('clicked'),
  ///   child: Text('here'),
  /// )
  /// ```
  Widget thenButton({required VoidCallback onPressed, required Widget child}) {
    return then(
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Builder(
          builder: (context) {
            final defaultTextStyle = DefaultTextStyle.of(context);
            return Button(
              style: const ButtonStyle.link(density: ButtonDensity.compact),
              onPressed: onPressed,
              child: Builder(
                builder: (context) {
                  final buttonTextStyle = DefaultTextStyle.of(context);
                  return DefaultTextStyle(
                    style: defaultTextStyle.style.copyWith(
                      decoration: buttonTextStyle.style.decoration,
                    ),
                    overflow: defaultTextStyle.overflow,
                    maxLines: defaultTextStyle.maxLines,
                    softWrap: defaultTextStyle.softWrap,
                    textAlign: defaultTextStyle.textAlign,
                    textHeightBehavior: defaultTextStyle.textHeightBehavior,
                    textWidthBasis: defaultTextStyle.textWidthBasis,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Creates a bullet widget for list items based on depth.
///
/// Returns different bullet styles for different nesting levels:
/// - Depth 0: Filled circle
/// - Depth 1: Hollow circle (stroke only)
/// - Depth 2+: Filled square
///
/// Parameters:
/// - [context] (`BuildContext`, required): Build context for theme access.
/// - [depth] (`int`, required): Nesting depth (0 = top level).
/// - [size] (`double`, required): Size of the bullet in logical pixels.
///
/// Returns: `Widget` — a centered bullet widget.
///
/// Example:
/// ```dart
/// getBullet(context, 0, 6.0) // Filled circle bullet
/// ```
Widget getBullet(BuildContext context, int depth, double size) {
  final themeData = Theme.of(context);
  if (depth == 0) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: themeData.colorScheme.foreground,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
  if (depth == 1) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: themeData.colorScheme.foreground, width: 1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
  return Center(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: themeData.colorScheme.foreground),
    ),
  );
}

/// Function signature for building data from context and theme.
///
/// Used by [WrappedText] to compute style properties dynamically.
///
/// Type parameter `T` is the return type of the builder function.
typedef WrappedTextDataBuilder<T> =
    T Function(BuildContext context, ThemeData theme);

/// Function signature for wrapping widgets with additional structure.
///
/// Used by [WrappedText] to add container widgets around text content.
typedef WidgetTextWrapper = Widget Function(BuildContext context, Widget child);
