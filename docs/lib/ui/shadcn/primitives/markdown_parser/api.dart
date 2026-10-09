// Public markdown API: callbacks, tap payloads, render style snapshot and
// callback bundle. Owned here (not in the component) because the streaming
// `text_animate` component shares this surface: it constructs and copies
// `Markdown` values and reads their fields.

import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/widgets.dart';

import 'document.dart';

/// Link callback for `[label](url)`.
typedef MarkdownTapLinkCallback = void Function(String text, String url);
typedef MarkdownTapLinkDetailsCallback =
    void Function(MarkdownLinkTapDetails details);
typedef MarkdownTapImageCallback =
    void Function(MarkdownImageTapDetails details);
typedef MarkdownTapHeadingCallback =
    void Function(MarkdownHeadingTapDetails details);
typedef MarkdownTapElementCallback =
    void Function(MarkdownTapElementDetails details);
typedef MarkdownBlockBuilder =
    Widget? Function(BuildContext context, MarkdownBlockBuildDetails details);
typedef MarkdownDocumentReadyCallback =
    void Function(MarkdownDocumentMetrics metrics);
typedef MarkdownImagePreviewBuilder =
    Widget Function(
      BuildContext context,
      MarkdownImagePreviewDetails details,
      VoidCallback close,
    );

/// Builds a link recognizer owned by the widget state, so spans never leak
/// recognizers (the old renderer created one per build and never disposed).
typedef MarkdownLinkRecognizerFactory =
    TapGestureRecognizer Function(String label, String url);

/// Custom image widget for a URL/alt pair.
typedef MarkdownImageWidgetBuilder =
    Widget Function(BuildContext context, String url, String alt);

/// Image-preview overlay behavior.
enum MarkdownImagePreviewBehavior { none, dialog }

/// Element kinds reported to [MarkdownCallbacks.onTapElement].
enum MarkdownTapElementKind {
  paragraph,
  heading,
  listItem,
  quote,
  codeBlock,
  tableHeaderCell,
  tableCell,
  image,
  details,
  footnote,
  horizontalRule,
  link,
}

/// Details of a link tap.
class MarkdownLinkTapDetails {
  const MarkdownLinkTapDetails({
    required this.text,
    required this.url,
    required this.kind,
  });

  final String text;
  final String url;
  final MarkdownLinkKind kind;
}

/// Details of an image tap.
class MarkdownImageTapDetails {
  const MarkdownImageTapDetails({required this.url, required this.alt});

  final String url;
  final String alt;
}

/// Details of an image preview request.
class MarkdownImagePreviewDetails {
  const MarkdownImagePreviewDetails({required this.url, required this.alt});

  final String url;
  final String alt;
}

/// Details of a heading tap.
class MarkdownHeadingTapDetails {
  const MarkdownHeadingTapDetails({
    required this.text,
    required this.anchor,
    required this.level,
  });

  final String text;
  final String anchor;
  final int level;
}

/// Details of a generic element tap.
class MarkdownTapElementDetails {
  const MarkdownTapElementDetails({
    required this.kind,
    required this.text,
    this.url,
    this.anchor,
    this.headingLevel,
    this.blockIndex,
    this.tableRow,
    this.tableColumn,
    this.orderedIndex,
    this.checked,
  });

  final MarkdownTapElementKind kind;
  final String text;
  final String? url;
  final String? anchor;
  final int? headingLevel;
  final int? blockIndex;
  final int? tableRow;
  final int? tableColumn;
  final int? orderedIndex;
  final bool? checked;
}

/// Per-block override hook payload.
class MarkdownBlockBuildDetails {
  const MarkdownBlockBuildDetails({
    required this.kind,
    required this.text,
    required this.blockIndex,
    required this.buildDefault,
    this.headingLevel,
    this.headingAnchor,
    this.language,
    this.orderedIndex,
    this.checked,
    this.tableRows = const <List<String>>[],
    this.tableAlignments = const <TextAlign>[],
    this.imageUrl,
    this.imageAlt,
    this.summary,
    this.footnoteId,
  });

  final MarkdownBlockKind kind;
  final String text;
  final int blockIndex;
  final Widget Function() buildDefault;
  final int? headingLevel;
  final String? headingAnchor;
  final String? language;
  final int? orderedIndex;
  final bool? checked;
  final List<List<String>> tableRows;
  final List<TextAlign> tableAlignments;
  final String? imageUrl;
  final String? imageAlt;

  /// Disclosure summary for details blocks; body stays in [text].
  final String? summary;

  /// Footnote id for footnote blocks; ordinal is [orderedIndex].
  final String? footnoteId;

  /// Builds details for [block] with [buildDefault] as the default branch.
  factory MarkdownBlockBuildDetails.fromBlock(
    MarkdownBlock block,
    int blockIndex,
    String? slug,
    Widget Function() buildDefault,
  ) {
    return MarkdownBlockBuildDetails(
      kind: block.kind,
      text: block.text,
      blockIndex: blockIndex,
      buildDefault: buildDefault,
      headingLevel: block.headingLevel,
      headingAnchor: slug,
      language: block.language,
      orderedIndex: block.orderedIndex,
      checked: block.checked,
      tableRows: block.tableRows,
      tableAlignments: block.tableAlignments,
      imageUrl: block.imageUrl,
      imageAlt: block.imageAlt,
      summary: block.summary,
      footnoteId: block.footnoteId,
    );
  }
}

/// Block counts reported once a document parses.
class MarkdownDocumentMetrics {
  const MarkdownDocumentMetrics({
    required this.blockCount,
    required this.chunkCount,
    required this.headingCount,
    required this.imageCount,
    required this.tableCount,
  });

  final int blockCount;
  final int chunkCount;
  final int headingCount;
  final int imageCount;
  final int tableCount;
}

/// Callback bundle threaded through the block renderer.
class MarkdownCallbacks {
  const MarkdownCallbacks({
    this.onTapLink,
    this.onTapLinkDetails,
    this.onTapImage,
    this.onTapHeading,
    this.onTapElement,
    this.blockBuilder,
    this.onDocumentReady,
    this.imagePreviewBehavior = MarkdownImagePreviewBehavior.dialog,
    this.imagePreviewBuilder,
    this.imageBuilder,
    required this.linkRecognizer,
  });

  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownTapLinkDetailsCallback? onTapLinkDetails;
  final MarkdownTapImageCallback? onTapImage;
  final MarkdownTapHeadingCallback? onTapHeading;
  final MarkdownTapElementCallback? onTapElement;
  final MarkdownBlockBuilder? blockBuilder;
  final MarkdownDocumentReadyCallback? onDocumentReady;
  final MarkdownImagePreviewBehavior imagePreviewBehavior;
  final MarkdownImagePreviewBuilder? imagePreviewBuilder;
  final MarkdownImageWidgetBuilder? imageBuilder;
  final MarkdownLinkRecognizerFactory linkRecognizer;
}

/// Resolved per-build style: concrete values, no tokens. The component
/// resolves its [MarkdownTheme] once per build into this snapshot so the
/// primitive renderer stays theme-free.
class MarkdownRenderStyle {
  const MarkdownRenderStyle({
    required this.body,
    required this.link,
    required this.mono,
    required this.codeBackground,
    required this.quote,
    required this.quoteBorder,
    required this.tableHeader,
    required this.tableCell,
    required this.tableBorder,
    required this.tableHeaderBackground,
    required this.headings,
    required this.rule,
    required this.blockSpacing,
    required this.selectable,
    required this.dismissLabel,
    required this.onLink,
    required this.surface,
    required this.onSurface,
    required this.muted,
    required this.selection,
    this.references = const <String, MarkdownLinkTarget>{},
    this.footnoteOrder = const <String>[],
  });

  final TextStyle body;
  final TextStyle link;
  final TextStyle mono;
  final Color codeBackground;
  final TextStyle quote;
  final Color quoteBorder;
  final TextStyle tableHeader;
  final TextStyle tableCell;
  final Color tableBorder;
  final Color tableHeaderBackground;
  final List<TextStyle> headings;
  final Color rule;
  final double blockSpacing;
  final bool selectable;
  final String dismissLabel;

  /// Glyph color drawn on link-colored fills (task-checkbox check).
  final Color onLink;

  /// Card surface and its foreground for the image preview chrome.
  final Color surface;
  final Color onSurface;

  /// Muted foreground for captions and language labels.
  final Color muted;

  /// Selection highlight for spans with an explicit registrar. Defaults to
  /// the ambient selection color, then `primary` at 20%.
  final Color selection;

  /// Normalized `[ref]` destinations for reference-style links.
  final Map<String, MarkdownLinkTarget> references;

  /// Referenced footnote ids in first-ref order (ordinals are 1-based).
  final List<String> footnoteOrder;
}
