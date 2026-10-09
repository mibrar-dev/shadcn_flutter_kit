// Block dispatch: [buildMarkdownBlock] renders any block, [wrapMarkdownBlock]
// adds anchor keys plus heading/element tap targets, and
// [markdownSelectionMenu] is the shadcn selection toolbar for regions.

import 'package:flutter/widgets.dart';

import '../text_editing/text_editing.dart';
import 'api.dart';
import 'block_parser.dart';
import 'blocks.dart';
import 'document.dart';
import 'media.dart';

/// Renders [block] to its content widget (no keys, taps or padding; the
/// component adds those in [wrapMarkdownBlock]). [nested] rebuilds quote
/// bodies (quotes nest without a depth limit: each level strips one `>`
/// marker, so recursion always terminates). Details blocks render here as a
/// plain fallback; the component replaces them with a `Collapsible`.
Widget buildMarkdownBlock({
  required BuildContext context,
  required MarkdownRenderStyle style,
  required MarkdownCallbacks callbacks,
  required MarkdownBlock block,
  required int blockIndex,
  required Set<String> failedUrls,
  required Widget Function(BuildContext context, MarkdownBlock block) nested,
}) {
  return switch (block.kind) {
    MarkdownBlockKind.blank => const SizedBox(height: 8),
    MarkdownBlockKind.paragraph => markdownRichText(
      context,
      style,
      markdownSpans(style, callbacks, style.body, block.text),
    ),
    MarkdownBlockKind.heading => buildMarkdownHeading(
      context,
      style,
      callbacks,
      style.headings[(block.headingLevel ?? 6).clamp(1, 6) - 1],
      block.text,
    ),
    MarkdownBlockKind.unorderedList ||
    MarkdownBlockKind.orderedList ||
    MarkdownBlockKind.taskList => buildMarkdownListItem(
      context,
      style,
      callbacks,
      block,
    ),
    MarkdownBlockKind.quote =>
      buildMarkdownQuote(context, style, block, <Widget>[
        for (final sub in parseMarkdownDocument(block.text).blocks)
          nested(context, sub),
      ]),
    MarkdownBlockKind.details =>
      buildMarkdownQuote(context, style, block, <Widget>[
        markdownRichText(
          context,
          style,
          markdownSpans(
            style,
            callbacks,
            style.body,
            (block.summary ?? '').isEmpty ? 'Details' : block.summary!,
          ),
        ),
        for (final sub in parseMarkdownDocument(block.text).blocks)
          nested(context, sub),
      ]),
    MarkdownBlockKind.codeBlock => buildMarkdownCode(context, style, block),
    MarkdownBlockKind.table => buildMarkdownTable(
      context,
      style,
      callbacks,
      block,
      blockIndex,
    ),
    MarkdownBlockKind.image => buildMarkdownImage(
      context,
      style,
      callbacks,
      block,
      blockIndex,
      failedUrls: failedUrls,
      interactive: true,
    ),
    MarkdownBlockKind.horizontalRule => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ColoredBox(
        color: style.rule,
        child: const SizedBox(height: 1, width: double.infinity),
      ),
    ),
    MarkdownBlockKind.footnote => markdownRichText(
      context,
      style,
      TextSpan(
        style: style.body,
        children: <InlineSpan>[
          TextSpan(text: '[${block.orderedIndex}] '),
          ...?markdownSpans(style, callbacks, style.body, block.text).children,
        ],
      ),
    ),
  };
}

/// Element kind firing [MarkdownTapElementDetails] for [kind]; null blocks
/// (blank, heading handled separately, table cells wrapped in the table)
/// never report.
MarkdownTapElementKind? _tappable(MarkdownBlockKind kind) {
  return switch (kind) {
    MarkdownBlockKind.paragraph => MarkdownTapElementKind.paragraph,
    MarkdownBlockKind.unorderedList ||
    MarkdownBlockKind.orderedList ||
    MarkdownBlockKind.taskList => MarkdownTapElementKind.listItem,
    MarkdownBlockKind.quote => MarkdownTapElementKind.quote,
    MarkdownBlockKind.codeBlock => MarkdownTapElementKind.codeBlock,
    MarkdownBlockKind.image => MarkdownTapElementKind.image,
    MarkdownBlockKind.details => MarkdownTapElementKind.details,
    MarkdownBlockKind.footnote => MarkdownTapElementKind.footnote,
    MarkdownBlockKind.horizontalRule => MarkdownTapElementKind.horizontalRule,
    _ => null,
  };
}

/// Adds the anchor key plus a single tap target: headings report
/// [MarkdownHeadingTapDetails] (and an element tap), other tappable blocks
/// report an element tap. Untappable blocks pass through untouched.
Widget wrapMarkdownBlock({
  required Widget child,
  required MarkdownBlock block,
  required int blockIndex,
  required String? slug,
  required GlobalKey? anchor,
  required MarkdownCallbacks callbacks,
}) {
  if (anchor != null) child = KeyedSubtree(key: anchor, child: child);
  final headingSlug = block.kind == MarkdownBlockKind.heading ? slug : null;
  final kind = headingSlug != null
      ? MarkdownTapElementKind.heading
      : _tappable(block.kind);
  final tapsHeading = headingSlug != null && callbacks.onTapHeading != null;
  if (!tapsHeading && (callbacks.onTapElement == null || kind == null)) {
    return child;
  }
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      if (tapsHeading && headingSlug != null) {
        callbacks.onTapHeading!.call(
          MarkdownHeadingTapDetails(
            text: block.text,
            anchor: headingSlug,
            level: block.headingLevel ?? 1,
          ),
        );
      }
      if (callbacks.onTapElement != null && kind != null) {
        callbacks.onTapElement!.call(
          MarkdownTapElementDetails(
            kind: kind,
            text: block.text,
            anchor: headingSlug,
            headingLevel: block.headingLevel,
            blockIndex: blockIndex,
            orderedIndex: block.orderedIndex,
            checked: block.checked,
          ),
        );
      }
    },
    child: child,
  );
}

/// Shadcn selection toolbar for [SelectableRegion]: same filtered items and
/// anchors as the editable-text menu, adapted to region state.
Widget markdownSelectionMenu(
  BuildContext context,
  SelectableRegionState state,
) {
  final anchors = state.contextMenuAnchors;
  final items = state.contextMenuButtonItems
      .where((item) => kShadcnContextMenuTypes.contains(item.type))
      .toList(growable: false);
  if (items.isEmpty) return const SizedBox.shrink();
  return ShadcnTextSelectionToolbar(
    anchorAbove: anchors.primaryAnchor,
    anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
    buttonItems: items,
  );
}
