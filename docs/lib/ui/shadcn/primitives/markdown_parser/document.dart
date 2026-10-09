// Shared markdown document model and parser, owned here for the `markdown`
// component and the streaming `text_animate` component (which shares the
// parser and the stable-prefix helper). Pure logic: no widgets, no theme,
// no BuildContext, so a renderer can parse without pulling in UI code.

import 'dart:ui' show TextAlign;

/// Block shapes the renderer dispatches on. One item per list entry; quotes
/// carry their raw text so the renderer can re-parse nested blocks.
enum MarkdownBlockKind {
  blank,
  paragraph,
  heading,
  unorderedList,
  orderedList,
  taskList,
  quote,
  codeBlock,
  table,
  image,
  details,
  footnote,
  horizontalRule,
}

/// Link target classification reported to tap callbacks.
enum MarkdownLinkKind { anchor, email, external, relative }

/// Classifies a link URL: `#...` is an anchor, `mailto:` is mail, an absolute
/// URI with a scheme is external, everything else is relative.
MarkdownLinkKind classifyMarkdownLink(String url) {
  final trimmed = url.trim();
  if (trimmed.startsWith('#')) return MarkdownLinkKind.anchor;
  if (trimmed.toLowerCase().startsWith('mailto:')) {
    return MarkdownLinkKind.email;
  }
  final uri = Uri.tryParse(trimmed);
  if (uri != null && uri.hasScheme) return MarkdownLinkKind.external;
  return MarkdownLinkKind.relative;
}

/// Raw-HTML policy applied to the source before parsing.
enum MarkdownHtmlSanitizationStrategy {
  permissive,
  stripDangerousHtml,
  stripAllHtml,
}

/// Tags removed with their content under [stripDangerousHtml].
const List<String> _dangerousHtmlTags = <String>[
  'script',
  'style',
  'iframe',
  'object',
  'embed',
  'meta',
  'link',
  'base',
];

/// Strips raw HTML per [strategy]. Comments go under both stripping modes.
String sanitizeMarkdownHtml(
  String source,
  MarkdownHtmlSanitizationStrategy strategy,
) {
  switch (strategy) {
    case MarkdownHtmlSanitizationStrategy.permissive:
      return source;
    case MarkdownHtmlSanitizationStrategy.stripDangerousHtml:
      var out = source;
      for (final tag in _dangerousHtmlTags) {
        out = out.replaceAll(
          RegExp('<$tag\\b[^>]*>[\\s\\S]*?</$tag>', caseSensitive: false),
          '',
        );
        out = out.replaceAll(
          RegExp('<$tag\\b[^>]*/?>', caseSensitive: false),
          '',
        );
      }
      return out.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '');
    case MarkdownHtmlSanitizationStrategy.stripAllHtml:
      return source.replaceAll(RegExp(r'<[^>]+>'), '');
  }
}

/// GitHub-style anchor slug for a heading. Never throws: a malformed percent
/// escape falls back to the raw text (the old code called
/// `Uri.decodeComponent` unguarded, which throws on a bare `%`).
String markdownAnchorSlug(String value) {
  String decoded;
  try {
    decoded = Uri.decodeComponent(value);
  } on ArgumentError {
    decoded = value;
  }
  var slug = decoded.trim().toLowerCase().replaceAll(RegExp(r'<[^>]+>'), '');
  slug = slug.replaceAll(RegExp(r'[`*_~\[\](){}]'), '');
  slug = slug.replaceAll(RegExp(r'[^\w\s-]'), '');
  slug = slug.replaceAll(RegExp(r'\s+'), '-').replaceAll(RegExp(r'-+'), '-');
  return slug.replaceAll(RegExp(r'^-+|-+$'), '');
}

/// Stable-prefix length of a streaming document: bytes before it that parse
/// identically once more text arrives. Only whole lines past a closed fence,
/// math block, details block or table count as stable.
int computeStableMarkdownPrefixLength(String data) {
  if (data.isEmpty) return 0;
  final lines = data.replaceAll('\r\n', '\n').split('\n');
  var offset = 0;
  var lastStable = 0;
  var inFence = false;
  String? openFence;
  var inMath = false;
  var inDetails = false;
  var inTable = false;
  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final trimmed = line.trimRight();
    final lineEnd = offset + line.length + (i < lines.length - 1 ? 1 : 0);
    if (inFence) {
      if (openFence != null && markdownClosesFence(trimmed, openFence)) {
        inFence = false;
        openFence = null;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }
    if (inMath) {
      if (trimmed == r'$$') {
        inMath = false;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }
    if (inDetails) {
      if (trimmed.toLowerCase().startsWith('</details')) {
        inDetails = false;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }
    final fence = markdownFenceMarker(trimmed);
    if (fence != null) {
      inFence = true;
      openFence = fence;
      offset = lineEnd;
      continue;
    }
    if (trimmed == r'$$') {
      inMath = true;
      offset = lineEnd;
      continue;
    }
    if (trimmed.toLowerCase().startsWith('<details')) {
      inDetails = true;
      offset = lineEnd;
      continue;
    }
    if (isMarkdownTableDelimiter(trimmed)) {
      inTable = true;
      offset = lineEnd;
      continue;
    }
    if (inTable) {
      if (trimmed.isEmpty || !trimmed.contains('|')) {
        inTable = false;
        lastStable = lineEnd;
      }
      offset = lineEnd;
      continue;
    }
    lastStable = lineEnd;
    offset = lineEnd;
  }
  return lastStable;
}

/// Lowercase with collapsed inner whitespace (CommonMark reference matching).
String normalizeMarkdownReferenceKey(String label) {
  return label.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}

/// Fence marker (```` ``` ```` or `~~~`) when [line] opens a code fence.
///
/// Public so streaming renderers (like `text_animate`) can track fences
/// without re-implementing the marker rule; returns the normalized marker.
String? markdownFenceMarker(String line) {
  final match = RegExp(r'^(```+|~~~+)\s*\S*$').firstMatch(line.trim());
  if (match == null) return null;
  final marker = match.group(1)!;
  return marker[0] * 3;
}

/// Whether [line] closes a fence opened with [marker].
bool markdownClosesFence(String line, String marker) {
  final trimmed = line.trim();
  return trimmed.startsWith(marker) &&
      trimmed.replaceAll(RegExp('^${marker[0]}+'), '').trim().isEmpty;
}

/// Whether [line] is a GFM table delimiter row (`| --- | :---: |`).
bool isMarkdownTableDelimiter(String line) {
  final trimmed = line.trim();
  if (!trimmed.contains('-') || !trimmed.contains('|')) return false;
  final cells = trimmed.replaceAll(RegExp(r'^\||\|$'), '').split('|');
  if (cells.isEmpty) return false;
  for (final cell in cells) {
    if (!RegExp(r'^\s*:?-{1,}:?\s*$').hasMatch(cell)) return false;
  }
  return true;
}

/// One parsed block. Per-item blocks carry their own index/indent/checked so
/// lists need no wrapper node; tables carry header-first rows plus alignments.
class MarkdownBlock {
  const MarkdownBlock({
    required this.kind,
    required this.text,
    this.headingLevel,
    this.orderedIndex = 1,
    this.indentLevel = 0,
    this.checked,
    this.language,
    this.tableRows = const <List<String>>[],
    this.tableAlignments = const <TextAlign>[],
    this.imageUrl,
    this.imageAlt,
    this.imageTitle,
    this.summary,
    this.footnoteId,
  });

  final MarkdownBlockKind kind;
  final String text;
  final int? headingLevel;
  final int orderedIndex;
  final int indentLevel;
  final bool? checked;
  final String? language;
  final List<List<String>> tableRows;
  final List<TextAlign> tableAlignments;
  final String? imageUrl;
  final String? imageAlt;
  final String? imageTitle;

  /// Disclosure summary for [MarkdownBlockKind.details]; body stays in [text].
  final String? summary;

  /// Footnote id for [MarkdownBlockKind.footnote]; its ordinal is
  /// [orderedIndex], its anchor is `fn-<id>`.
  final String? footnoteId;
}

/// Link target of a `[ref]: url "title"` reference definition.
class MarkdownLinkTarget {
  const MarkdownLinkTarget({required this.url, this.title});

  final String url;
  final String? title;
}

/// Parsed document: blocks in order, plus reference definitions collected
/// along the way. Footnote definitions render as trailing [MarkdownBlockKind]
/// footnote blocks (referenced ids only, first-ref order); unreferenced
/// definitions and bare `[x]` shortcuts never render literally.
class MarkdownDocument {
  const MarkdownDocument({
    required this.blocks,
    this.references = const <String, MarkdownLinkTarget>{},
    this.footnotes = const <String, String>{},
  });

  final List<MarkdownBlock> blocks;

  /// Normalized `[ref]` destinations: lowercase, collapsed whitespace.
  final Map<String, MarkdownLinkTarget> references;

  /// `[^id]` definition bodies by id.
  final Map<String, String> footnotes;
}

/// One inline run: literal text plus its emphasis flags and link target.
/// Inline images are out of scope and surface as their alt text.
class MarkdownInlineRun {
  const MarkdownInlineRun({
    required this.text,
    this.bold = false,
    this.italic = false,
    this.code = false,
    this.strikethrough = false,
    this.linkUrl,
    this.linkTitle,
    this.superscript = false,
  });

  final String text;
  final bool bold;
  final bool italic;
  final bool code;
  final bool strikethrough;
  final String? linkUrl;
  final String? linkTitle;

  /// Footnote marker: rendered smaller, linked to `#fn-<id>`.
  final bool superscript;
}

/// Parses [data] into a [MarkdownDocument]. Line-oriented single pass:
/// fences, headings, rules, tables, quotes, lists, standalone images,
/// indented code, then paragraphs. Never throws on malformed input.
