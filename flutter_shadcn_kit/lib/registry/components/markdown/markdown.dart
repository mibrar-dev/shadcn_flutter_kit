// The `markdown` component: a widgets-only markdown renderer with a shadcn
// theme, tap callbacks and an image preview overlay. Model, parsing and
// block builders live in `primitives/markdown_parser` (shared with the
// streaming `text_animate` component). See README for dropped scope.

import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/widgets.dart';

import '../../primitives/markdown_parser/markdown_parser.dart';
import '../../primitives/text_editing/text_editing.dart';
import '../collapsible/collapsible.dart';
import 'markdown_style.dart';

export '../../primitives/markdown_parser/api.dart';
export '../../primitives/markdown_parser/document.dart';
export 'markdown_style.dart';

/// Text-only markdown renderer. Source is a string: read assets or files
/// yourself and pass the content (the old `asset`/`file` ctors and their
/// loading states are gone; the streaming extension only supports text
/// anyway). Link taps only fire callbacks: open URLs in [onTapLink] with
/// `url_launcher` (the old platform-channel opener cannot be widgets-only).
class Markdown extends StatefulWidget {
  const Markdown({
    super.key,
    required this.data,
    this.selectable = true,
    this.style,
    this.onTapLink,
    this.onTapLinkDetails,
    this.onTapImage,
    this.onTapHeading,
    this.onTapElement,
    this.blockBuilder,
    this.onDocumentReady,
    this.viewportStorageId,
    this.shrinkWrap = true,
    this.htmlSanitizationStrategy =
        MarkdownHtmlSanitizationStrategy.stripDangerousHtml,
    this.imagePreviewBehavior = MarkdownImagePreviewBehavior.dialog,
    this.imagePreviewBuilder,
    this.imageBuilder,
    this.theme,
  });

  final String data;
  final bool selectable;
  final TextStyle? style;
  final MarkdownTapLinkCallback? onTapLink;
  final MarkdownTapLinkDetailsCallback? onTapLinkDetails;
  final MarkdownTapImageCallback? onTapImage;
  final MarkdownTapHeadingCallback? onTapHeading;
  final MarkdownTapElementCallback? onTapElement;
  final MarkdownBlockBuilder? blockBuilder;
  final MarkdownDocumentReadyCallback? onDocumentReady;
  final Object? viewportStorageId;
  final bool shrinkWrap;
  final MarkdownHtmlSanitizationStrategy htmlSanitizationStrategy;
  final MarkdownImagePreviewBehavior imagePreviewBehavior;
  final MarkdownImagePreviewBuilder? imagePreviewBuilder;
  final MarkdownImageWidgetBuilder? imageBuilder;
  final MarkdownTheme? theme;

  Markdown copyWith({
    String? data,
    bool? selectable,
    TextStyle? style,
    MarkdownTapLinkCallback? onTapLink,
    MarkdownTapLinkDetailsCallback? onTapLinkDetails,
    MarkdownTapImageCallback? onTapImage,
    MarkdownTapHeadingCallback? onTapHeading,
    MarkdownTapElementCallback? onTapElement,
    MarkdownBlockBuilder? blockBuilder,
    MarkdownDocumentReadyCallback? onDocumentReady,
    Object? viewportStorageId,
    bool? shrinkWrap,
    MarkdownHtmlSanitizationStrategy? htmlSanitizationStrategy,
    MarkdownImagePreviewBehavior? imagePreviewBehavior,
    MarkdownImagePreviewBuilder? imagePreviewBuilder,
    MarkdownImageWidgetBuilder? imageBuilder,
    MarkdownTheme? theme,
  }) {
    return Markdown(
      key: key,
      data: data ?? this.data,
      selectable: selectable ?? this.selectable,
      style: style ?? this.style,
      onTapLink: onTapLink ?? this.onTapLink,
      onTapLinkDetails: onTapLinkDetails ?? this.onTapLinkDetails,
      onTapImage: onTapImage ?? this.onTapImage,
      onTapHeading: onTapHeading ?? this.onTapHeading,
      onTapElement: onTapElement ?? this.onTapElement,
      blockBuilder: blockBuilder ?? this.blockBuilder,
      onDocumentReady: onDocumentReady ?? this.onDocumentReady,
      viewportStorageId: viewportStorageId ?? this.viewportStorageId,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
      htmlSanitizationStrategy:
          htmlSanitizationStrategy ?? this.htmlSanitizationStrategy,
      imagePreviewBehavior: imagePreviewBehavior ?? this.imagePreviewBehavior,
      imagePreviewBuilder: imagePreviewBuilder ?? this.imagePreviewBuilder,
      imageBuilder: imageBuilder ?? this.imageBuilder,
      theme: theme ?? this.theme,
    );
  }

  @override
  State<Markdown> createState() => _MarkdownState();
}

class _MarkdownState extends State<Markdown> {
  late MarkdownDocument _document;
  final Map<String, GlobalKey> _anchors = {};
  final List<String?> _slugs = [];
  final Map<String, TapGestureRecognizer> _linkRecognizers = {};
  final Set<String> _failedImages = {};
  late FocusNode _selectionFocus;
  int _headings = 0;
  int _images = 0;
  int _tables = 0;

  @override
  void initState() {
    super.initState();
    _selectionFocus = FocusNode(debugLabel: 'MarkdownSelection');
    _parse();
  }

  @override
  void didUpdateWidget(covariant Markdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.htmlSanitizationStrategy != widget.htmlSanitizationStrategy) {
      _parse();
    }
  }

  @override
  void dispose() {
    for (final recognizer in _linkRecognizers.values) {
      recognizer.dispose();
    }
    _selectionFocus.dispose();
    super.dispose();
  }

  void _parse() {
    _document = parseMarkdownDocument(
      sanitizeMarkdownHtml(widget.data, widget.htmlSanitizationStrategy),
    );
    _anchors.clear();
    _slugs.clear();
    _headings = 0;
    _images = 0;
    _tables = 0;
    final counts = <String, int>{};
    for (final block in _document.blocks) {
      switch (block.kind) {
        case MarkdownBlockKind.heading:
          _headings++;
        case MarkdownBlockKind.image:
          _images++;
        case MarkdownBlockKind.table:
          _tables++;
        default:
          break;
      }
      String? slug;
      if (block.kind == MarkdownBlockKind.heading) {
        final base = markdownAnchorSlug(block.text);
        if (base.isNotEmpty) {
          final seen = counts[base] ?? 0;
          counts[base] = seen + 1;
          slug = seen == 0 ? base : '$base-$seen';
          _anchors[slug] = GlobalKey(debugLabel: 'md-$slug');
        }
      } else if (block.kind == MarkdownBlockKind.footnote &&
          block.footnoteId != null) {
        slug = 'fn-${block.footnoteId}';
        _anchors[slug] = GlobalKey(debugLabel: 'md-$slug');
      }
      _slugs.add(slug);
    }
    final ready = widget.onDocumentReady;
    if (ready != null) {
      final metrics = MarkdownDocumentMetrics(
        blockCount: _document.blocks.length,
        chunkCount: _document.blocks.length,
        headingCount: _headings,
        imageCount: _images,
        tableCount: _tables,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ready(metrics);
      });
    }
  }

  TapGestureRecognizer _recognizer(String label, String url) =>
      _linkRecognizers.putIfAbsent(url, TapGestureRecognizer.new)
        ..onTap = () => _handleLink(label, url);

  void _handleLink(String label, String url) {
    final target = url.trim();
    final kind = classifyMarkdownLink(target);
    if (kind == MarkdownLinkKind.anchor) {
      final anchor = _anchors[markdownAnchorSlug(target.substring(1))];
      final anchorContext = anchor?.currentContext;
      if (anchorContext != null) {
        Scrollable.ensureVisible(
          anchorContext,
          alignment: 0.08,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
        );
      }
    }
    widget.onTapLinkDetails?.call(
      MarkdownLinkTapDetails(text: label, url: target, kind: kind),
    );
    widget.onTapLink?.call(label, target);
    widget.onTapElement?.call(
      MarkdownTapElementDetails(
        kind: MarkdownTapElementKind.link,
        text: label,
        url: target,
        anchor: kind == MarkdownLinkKind.anchor ? target.substring(1) : null,
      ),
    );
  }

  MarkdownCallbacks _callbacks() {
    return MarkdownCallbacks(
      onTapLink: widget.onTapLink,
      onTapLinkDetails: widget.onTapLinkDetails,
      onTapImage: widget.onTapImage,
      onTapHeading: widget.onTapHeading,
      onTapElement: widget.onTapElement,
      blockBuilder: widget.blockBuilder,
      onDocumentReady: widget.onDocumentReady,
      imagePreviewBehavior: widget.imagePreviewBehavior,
      imagePreviewBuilder: widget.imagePreviewBuilder,
      imageBuilder: widget.imageBuilder,
      linkRecognizer: _recognizer,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_document.blocks.isEmpty) return const SizedBox.shrink();
    final style = resolveMarkdownStyle(
      context,
      widgetTheme: widget.theme,
      style: widget.style,
      selectable: widget.selectable,
      references: _document.references,
      footnoteOrder: markdownFootnoteOrder(_document.blocks),
    );
    final callbacks = _callbacks();
    Widget content = widget.shrinkWrap
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (var i = 0; i < _document.blocks.length; i++)
                _block(context, style, callbacks, _document.blocks[i], i),
            ],
          )
        : ListView.builder(
            key: widget.viewportStorageId == null
                ? null
                : PageStorageKey<String>(
                    'markdown:${widget.viewportStorageId}',
                  ),
            padding: EdgeInsets.zero,
            itemCount: _document.blocks.length,
            itemBuilder: (context, i) =>
                _block(context, style, callbacks, _document.blocks[i], i),
          );
    if (widget.selectable && SelectionContainer.maybeOf(context) == null) {
      content = SelectableRegion(
        focusNode: _selectionFocus,
        selectionControls: ShadcnSelectionControls(),
        contextMenuBuilder: markdownSelectionMenu,
        child: content,
      );
    }
    return content;
  }

  Widget _block(
    BuildContext context,
    MarkdownRenderStyle style,
    MarkdownCallbacks callbacks,
    MarkdownBlock block,
    int index,
  ) {
    final slug = index >= 0 && index < _slugs.length ? _slugs[index] : null;
    final content = block.kind == MarkdownBlockKind.details
        ? _details(context, style, callbacks, block)
        : buildMarkdownBlock(
            context: context,
            style: style,
            callbacks: callbacks,
            block: block,
            blockIndex: index,
            failedUrls: _failedImages,
            nested: (c, b) => _block(c, style, callbacks, b, -1),
          );
    final details = MarkdownBlockBuildDetails.fromBlock(
      block,
      index,
      slug,
      () => content,
    );
    Widget child =
        callbacks.blockBuilder?.call(context, details) ??
        details.buildDefault();
    child = wrapMarkdownBlock(
      child: child,
      block: block,
      blockIndex: index,
      slug: slug,
      anchor: slug == null ? null : _anchors[slug],
      callbacks: callbacks,
    );
    if (block.kind == MarkdownBlockKind.blank) return child;
    return Padding(
      padding: EdgeInsets.only(bottom: style.blockSpacing),
      child: child,
    );
  }

  /// Disclosure block: summary trigger plus the parsed body, collapsed by
  /// default. Reuses the component [_block] path so nested blocks keep
  /// overrides, taps and spacing.
  Widget _details(
    BuildContext context,
    MarkdownRenderStyle style,
    MarkdownCallbacks callbacks,
    MarkdownBlock block,
  ) {
    return Collapsible(
      children: <Widget>[
        CollapsibleTrigger(
          child: Text(
            (block.summary ?? '').isEmpty ? 'Details' : block.summary!,
          ),
        ),
        CollapsibleContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final sub in parseMarkdownDocument(block.text).blocks)
                _block(context, style, callbacks, sub, -1),
            ],
          ),
        ),
      ],
    );
  }
}
