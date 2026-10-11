// Small typeset prose primitives (spec §2.3): measured sizes for the docs
// article body. D4 composes these with the generated API tables; D3 uses them
// on the introduction and index pages.
//
// Inline code and links are exposed both as [InlineSpan] helpers (for mixed
// paragraphs) and as standalone widgets.

import 'package:flutter/widgets.dart';

import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/primitives/clickable.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';

/// A prose paragraph: 15/26.25, 18.75 px top margin.
class TypesetParagraph extends StatelessWidget {
  /// Creates a paragraph from plain text.
  const TypesetParagraph(this.text, {super.key}) : spans = null;

  /// Creates a paragraph from [spans].
  const TypesetParagraph.rich(List<InlineSpan> this.spans, {super.key})
    : text = '';

  /// Body text (empty for [TypesetParagraph.rich]).
  final String text;

  /// Rich spans; empty for the plain constructor.
  final List<InlineSpan>? spans;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = docsText(context, size: 15, height: 26.25 / 15);
    return Padding(
      padding: const EdgeInsets.only(top: 18.75),
      child: spans == null
          ? Text(text, style: style, textAlign: TextAlign.start)
          : Text.rich(
              TextSpan(children: spans),
              style: style,
              textAlign: TextAlign.start,
            ),
    );
  }
}

/// An inline code chip: muted fill, radius 4.46, Geist Mono 12.75.
class TypesetInlineCode extends StatelessWidget {
  /// Creates an inline code chip.
  const TypesetInlineCode(this.code, {super.key});

  /// Code text.
  final String code;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.muted,
        borderRadius: BorderRadius.circular(4.46),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
        child: Text(
          code,
          style: theme.typography.mono.copyWith(
            fontSize: 12.75,
            color: theme.colors.foreground,
          ),
        ),
      ),
    );
  }
}

/// An underlined prose link (30 % colour, 100 % on hover).
class TypesetLink extends StatefulWidget {
  /// Creates a link.
  const TypesetLink({super.key, required this.label, required this.onPressed});

  /// Link text.
  final String label;

  /// Tap handler.
  final VoidCallback onPressed;

  @override
  State<TypesetLink> createState() => _TypesetLinkState();
}

/// Inline-span form of [TypesetInlineCode] for mixed paragraphs.
InlineSpan typesetInlineCodeSpan(String code) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: TypesetInlineCode(code),
  );
}

/// Inline-span form of [TypesetLink] for mixed paragraphs.
InlineSpan typesetLinkSpan(String label, VoidCallback onPressed) {
  return WidgetSpan(
    alignment: PlaceholderAlignment.middle,
    child: TypesetLink(label: label, onPressed: onPressed),
  );
}

class _TypesetLinkState extends State<TypesetLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color base = theme.colors.foreground;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Clickable(
        onPressed: widget.onPressed,
        child: Text(
          widget.label,
          style: docsText(context, size: 15, weight: FontWeight.w500).copyWith(
            decoration: TextDecoration.underline,
            decorationColor: base.withValues(alpha: _hovered ? 1 : 0.3),
          ),
        ),
      ),
    );
  }
}

/// A 1 px prose rule (`hr`), 36 px top margin.
class TypesetRule extends StatelessWidget {
  /// Creates a rule.
  const TypesetRule({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 8),
      child: SizedBox(height: 1, child: ColoredBox(color: theme.colors.border)),
    );
  }
}

/// A bullet list (`ul`): 24 px inline start, 8 px item spacing.
class TypesetBullets extends StatelessWidget {
  /// Creates a bullet list; each item is a span list.
  const TypesetBullets({super.key, required this.items});

  /// The items, in order.
  final List<List<InlineSpan>> items;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final TextStyle style = docsText(context, size: 15, height: 26.25 / 15);
    return Padding(
      padding: const EdgeInsets.only(top: 18.75, left: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (final List<InlineSpan> item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '•',
                    style: style.copyWith(color: theme.colors.mutedForeground),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Text.rich(TextSpan(children: item), style: style),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
