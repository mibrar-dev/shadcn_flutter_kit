import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../theme/theme.dart';
import 'list.dart';
import 'text.dart';

/// The fluent text-styling API.
///
/// Every getter returns a [TextModifier], so calls chain and read left to
/// right. Modifiers resolve against the ambient [ShadcnTheme], so the same
/// chain restyles itself when the theme changes.
///
/// ```dart
/// Text('Heading').h2.bold;
/// Text('Body').p.muted;
/// ```
extension TextExtension on Widget {
  // Family, size and weight are pure lookups into `Typography`; the remaining
  // modifiers wrap the child in extra widgets or set layout text properties.

  /// Sans-serif family.
  TextModifier get sans => WrappedText(
    style: (context, theme) => theme.typography.sans,
    child: this,
  );

  /// Monospace family.
  TextModifier get mono => WrappedText(
    style: (context, theme) => theme.typography.mono,
    child: this,
  );

  /// 12px.
  TextModifier get xSmall => WrappedText(
    style: (context, theme) => theme.typography.xSmall,
    child: this,
  );

  /// 14px.
  TextModifier get small => WrappedText(
    style: (context, theme) => theme.typography.small,
    child: this,
  );

  /// 16px.
  TextModifier get base => WrappedText(
    style: (context, theme) => theme.typography.base,
    child: this,
  );

  /// 18px.
  TextModifier get large => WrappedText(
    style: (context, theme) => theme.typography.large,
    child: this,
  );

  /// 20px.
  TextModifier get xLarge => WrappedText(
    style: (context, theme) => theme.typography.xLarge,
    child: this,
  );

  /// 24px.
  TextModifier get x2Large => WrappedText(
    style: (context, theme) => theme.typography.x2Large,
    child: this,
  );

  /// 30px.
  TextModifier get x3Large => WrappedText(
    style: (context, theme) => theme.typography.x3Large,
    child: this,
  );

  /// 36px.
  TextModifier get x4Large => WrappedText(
    style: (context, theme) => theme.typography.x4Large,
    child: this,
  );

  /// 48px.
  TextModifier get x5Large => WrappedText(
    style: (context, theme) => theme.typography.x5Large,
    child: this,
  );

  /// 60px.
  TextModifier get x6Large => WrappedText(
    style: (context, theme) => theme.typography.x6Large,
    child: this,
  );

  /// 72px.
  TextModifier get x7Large => WrappedText(
    style: (context, theme) => theme.typography.x7Large,
    child: this,
  );

  /// 96px.
  TextModifier get x8Large => WrappedText(
    style: (context, theme) => theme.typography.x8Large,
    child: this,
  );

  /// 144px.
  TextModifier get x9Large => WrappedText(
    style: (context, theme) => theme.typography.x9Large,
    child: this,
  );

  /// Weight 100.
  TextModifier get thin => WrappedText(
    style: (context, theme) => theme.typography.thin,
    child: this,
  );

  /// Weight 200.
  TextModifier get extraLight => WrappedText(
    style: (context, theme) => theme.typography.extraLight,
    child: this,
  );

  /// Weight 300.
  TextModifier get light => WrappedText(
    style: (context, theme) => theme.typography.light,
    child: this,
  );

  /// Weight 400.
  TextModifier get normal => WrappedText(
    style: (context, theme) => theme.typography.normal,
    child: this,
  );

  /// Weight 500.
  TextModifier get medium => WrappedText(
    style: (context, theme) => theme.typography.medium,
    child: this,
  );

  /// Weight 600.
  TextModifier get semiBold => WrappedText(
    style: (context, theme) => theme.typography.semiBold,
    child: this,
  );

  /// Weight 700.
  TextModifier get bold => WrappedText(
    style: (context, theme) => theme.typography.bold,
    child: this,
  );

  /// Weight 800.
  TextModifier get extraBold => WrappedText(
    style: (context, theme) => theme.typography.extraBold,
    child: this,
  );

  /// Weight 900.
  TextModifier get black => WrappedText(
    style: (context, theme) => theme.typography.black,
    child: this,
  );

  /// Italic.
  TextModifier get italic => WrappedText(
    style: (context, theme) => theme.typography.italic,
    child: this,
  );

  /// Underlined.
  TextModifier get underline => WrappedText(
    style: (context, theme) =>
        const TextStyle(decoration: TextDecoration.underline),
    child: this,
  );

  /// Muted foreground colour.
  TextModifier get muted => WrappedText(
    style: (context, theme) => TextStyle(color: theme.colors.mutedForeground),
    child: this,
  );

  /// Primary foreground colour.
  TextModifier get primaryForeground => WrappedText(
    style: (context, theme) => TextStyle(color: theme.colors.primaryForeground),
    child: this,
  );

  /// Secondary foreground colour.
  TextModifier get secondaryForeground => WrappedText(
    style: (context, theme) =>
        TextStyle(color: theme.colors.secondaryForeground),
    child: this,
  );

  /// Body foreground colour.
  TextModifier get foreground => WrappedText(
    style: (context, theme) => TextStyle(color: theme.colors.foreground),
    child: this,
  );

  /// Primary foreground colour; retained name of [foreground]'s sibling.
  TextModifier get modify => WrappedText(
    style: (context, theme) => TextStyle(color: theme.colors.primaryForeground),
    child: this,
  );

  /// Heading level 1.
  TextModifier get h1 =>
      WrappedText(style: (context, theme) => theme.typography.h1, child: this);

  /// Heading level 2, with a rule underneath and top margin.
  TextModifier get h2 => WrappedText(
    style: (context, theme) => theme.typography.h2,
    wrapper: (context, child) => Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ShadcnTheme.of(context).colors.border),
        ),
      ),
      child: child,
    ),
    child: this,
  );

  /// Heading level 3.
  TextModifier get h3 =>
      WrappedText(style: (context, theme) => theme.typography.h3, child: this);

  /// Heading level 4.
  TextModifier get h4 =>
      WrappedText(style: (context, theme) => theme.typography.h4, child: this);

  /// Paragraph, with top margin. See [firstP] for the first one on a page.
  TextModifier get p => WrappedText(
    style: (context, theme) => theme.typography.p,
    wrapper: (context, child) =>
        Padding(padding: const EdgeInsets.only(top: 24), child: child),
    child: this,
  );

  /// Paragraph without the top margin.
  TextModifier get firstP =>
      WrappedText(style: (context, theme) => theme.typography.p, child: this);

  /// Block quote, with a left rule.
  TextModifier get blockQuote => WrappedText(
    style: (context, theme) => theme.typography.blockQuote,
    wrapper: (context, child) => Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: ShadcnTheme.of(context).colors.border,
            width: 2,
          ),
        ),
      ),
      child: child,
    ),
    child: this,
  );

  /// List item: draws a bullet and increases the nesting depth for children.
  TextModifier get li => WrappedText(
    wrapper: (context, child) {
      final depth = Data.maybeOf<UnorderedListData>(context)?.depth ?? 0;
      final style = DefaultTextStyle.of(context).style;
      final size = (style.fontSize ?? 12) / 16 * 6;
      return IntrinsicWidth(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: (style.fontSize ?? 12) * (style.height ?? 1) * 1.2,
              child: getBullet(context, depth, size),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Data<UnorderedListData>.inherit(
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

  /// Inline code: monospace style in a rounded, muted chip.
  TextModifier get inlineCode => WrappedText(
    style: (context, theme) => theme.typography.inlineCode,
    wrapper: (context, child) {
      final fontSize = DefaultTextStyle.of(context).style.fontSize ?? 14;
      final theme = ShadcnTheme.of(context);
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: fontSize * 0.2,
          horizontal: fontSize * 0.3,
        ),
        decoration: BoxDecoration(
          color: theme.colors.muted,
          borderRadius: BorderRadius.circular(theme.radiusSm),
        ),
        child: child,
      );
    },
    child: this,
  );

  /// Lead paragraph, in the muted colour.
  TextModifier get lead => WrappedText(
    style: (context, theme) => theme.typography.lead,
    child: this,
  ).muted;

  /// Large body text.
  TextModifier get textLarge => WrappedText(
    style: (context, theme) => theme.typography.textLarge,
    child: this,
  );

  /// Small body text.
  TextModifier get textSmall => WrappedText(
    style: (context, theme) => theme.typography.textSmall,
    child: this,
  );

  /// Small body text in the muted colour.
  TextModifier get textMuted => WrappedText(
    style: (context, theme) => theme.typography.textMuted,
    child: this,
  ).muted;

  /// One line, no wrapping.
  TextModifier get singleLine => WrappedText(
    softWrap: (context, theme) => false,
    maxLines: (context, theme) => 1,
    child: this,
  );

  /// Truncates with an ellipsis.
  TextModifier get ellipsis => WrappedText(
    overflow: (context, theme) => TextOverflow.ellipsis,
    child: this,
  );

  /// Centres the text.
  TextModifier get textCenter =>
      WrappedText(textAlign: (context, theme) => TextAlign.center, child: this);

  /// Right-aligns the text.
  TextModifier get textRight =>
      WrappedText(textAlign: (context, theme) => TextAlign.right, child: this);

  /// Left-aligns the text.
  TextModifier get textLeft =>
      WrappedText(textAlign: (context, theme) => TextAlign.left, child: this);

  /// Justifies the text.
  TextModifier get textJustify => WrappedText(
    textAlign: (context, theme) => TextAlign.justify,
    child: this,
  );

  /// Aligns to the leading edge (left in LTR).
  TextModifier get textStart =>
      WrappedText(textAlign: (context, theme) => TextAlign.start, child: this);

  /// Aligns to the trailing edge (right in LTR).
  TextModifier get textEnd =>
      WrappedText(textAlign: (context, theme) => TextAlign.end, child: this);
}
