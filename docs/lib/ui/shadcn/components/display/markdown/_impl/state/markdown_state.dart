// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

class _MarkdownState extends State<Markdown> {
  static final Set<String> _failedNetworkImageUrls = <String>{};
  static const int _largeDocumentBlockThreshold = 48;
  static const int _initialProgressiveChunkCount = 4;
  static const int _progressiveChunkBatchSize = 2;
  static const Duration _progressiveChunkInterval = Duration(milliseconds: 24);

  Object? _error;
  bool _loading = false;
  bool _preparingDocument = false;
  int _parseGeneration = 0;
  _MarkdownDocument? _cachedDocument;
  List<_MarkdownChunk> _chunks = const <_MarkdownChunk>[];
  int _visibleChunkCount = 0;
  List<GlobalKey?> _cachedBlockHeadingKeys = const <GlobalKey?>[];
  List<String?> _cachedBlockHeadingAnchors = const <String?>[];
  Map<String, GlobalKey> _cachedHeadingAnchorMap = const <String, GlobalKey>{};
  Map<String, int> _cachedHeadingChunkIndices = const <String, int>{};
  final ScrollController _chunkScrollController = ScrollController();
  Timer? _progressiveChunkTimer;

  @override
  void initState() {
    super.initState();
    _loadSource();
  }

  @override
  void dispose() {
    _progressiveChunkTimer?.cancel();
    _chunkScrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant Markdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data ||
        oldWidget.sourcePath != widget.sourcePath ||
        oldWidget.sourceType != widget.sourceType ||
        oldWidget.htmlSanitizationStrategy != widget.htmlSanitizationStrategy) {
      _loadSource();
    }
  }

  Future<void> _loadSource() async {
    final sourceType = widget.sourceType;
    if (sourceType == MarkdownSourceType.text) {
      _loading = false;
      _error = null;
      await _prepareDocument(widget.data);
      return;
    }

    final path = widget.sourcePath;
    if (path == null || path.isEmpty) {
      setState(() {
        _loading = false;
        _error = StateError('Markdown source path cannot be empty.');
        _clearMarkdownCaches();
        _preparingDocument = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final loaded = switch (sourceType) {
        MarkdownSourceType.asset => await rootBundle.loadString(path),
        MarkdownSourceType.file => await loadMarkdownFile(path),
        MarkdownSourceType.text => widget.data,
      };
      if (!mounted) {
        return;
      }
      _loading = false;
      _error = null;
      await _prepareDocument(loaded);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _loading = false;
        _error = error;
        _clearMarkdownCaches();
        _preparingDocument = false;
      });
    }
  }

  Future<void> _prepareDocument(String data) async {
    final generation = ++_parseGeneration;
    _progressiveChunkTimer?.cancel();
    final sanitizedData = _sanitizeMarkdownHtml(
      data,
      widget.htmlSanitizationStrategy,
    );
    setState(() {
      _error = null;
      _preparingDocument = true;
    });

    try {
      final parsed = await _parseMarkdownDocumentAsync(sanitizedData);
      if (!mounted || generation != _parseGeneration) {
        return;
      }
      final chunks = _chunkMarkdownBlocks(parsed.blocks);
      final initialChunkCount = _initialChunkCountForDocument(parsed, chunks);
      final metrics = _collectDocumentMetrics(parsed, chunks);
      setState(() {
        _cachedDocument = parsed;
        _chunks = chunks;
        _visibleChunkCount = initialChunkCount;
        _primeHeadingAnchors(parsed.blocks, chunks);
        _preparingDocument = false;
      });
      _notifyDocumentReady(generation, metrics);
      _scheduleProgressiveChunkWarmup();
    } catch (error) {
      if (!mounted || generation != _parseGeneration) {
        return;
      }
      setState(() {
        _error = error;
        _preparingDocument = false;
        _clearMarkdownCaches();
      });
    }
  }

  Future<_MarkdownDocument> _parseMarkdownDocumentAsync(String data) async {
    if (data.trim().isEmpty) {
      return const _MarkdownDocument(blocks: <_MarkdownBlock>[]);
    }
    if (kIsWeb) {
      await Future<void>.delayed(Duration.zero);
      return _parseMarkdownDocument(data);
    }
    if (data.length < 8000) {
      await Future<void>.delayed(Duration.zero);
      return _parseMarkdownDocument(data);
    }
    return compute(_parseMarkdownDocument, data);
  }

  int _initialChunkCountForDocument(
    _MarkdownDocument document,
    List<_MarkdownChunk> chunks,
  ) {
    if (document.blocks.length < _largeDocumentBlockThreshold) {
      return chunks.length;
    }
    return chunks.length < _initialProgressiveChunkCount
        ? chunks.length
        : _initialProgressiveChunkCount;
  }

  void _scheduleProgressiveChunkWarmup() {
    _progressiveChunkTimer?.cancel();
    if (!widget.shrinkWrap ||
        _visibleChunkCount >= _chunks.length ||
        _chunks.length <= _initialProgressiveChunkCount) {
      return;
    }
    _progressiveChunkTimer = Timer.periodic(_progressiveChunkInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_visibleChunkCount >= _chunks.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _visibleChunkCount = (_visibleChunkCount + _progressiveChunkBatchSize)
            .clamp(0, _chunks.length);
      });
    });
  }

  void _clearMarkdownCaches() {
    _progressiveChunkTimer?.cancel();
    _cachedDocument = null;
    _chunks = const <_MarkdownChunk>[];
    _visibleChunkCount = 0;
    _cachedBlockHeadingKeys = const <GlobalKey?>[];
    _cachedBlockHeadingAnchors = const <String?>[];
    _cachedHeadingAnchorMap = const <String, GlobalKey>{};
    _cachedHeadingChunkIndices = const <String, int>{};
  }

  void _primeHeadingAnchors(
    List<_MarkdownBlock> blocks,
    List<_MarkdownChunk> chunks,
  ) {
    final keys = List<GlobalKey?>.filled(blocks.length, null);
    final slugs = List<String?>.filled(blocks.length, null);
    final anchors = <String, GlobalKey>{};
    final counts = <String, int>{};
    final blockIndices = <String, int>{};
    for (var index = 0; index < blocks.length; index++) {
      final block = blocks[index];
      if (!_isHeadingBlockType(block.type)) {
        continue;
      }
      final base = _normalizeAnchorSlug(block.text);
      if (base.isEmpty) {
        continue;
      }
      final seen = counts[base] ?? 0;
      final slug = seen == 0 ? base : '$base-$seen';
      counts[base] = seen + 1;
      final key = GlobalKey(debugLabel: 'md-anchor-$slug');
      keys[index] = key;
      slugs[index] = slug;
      anchors[slug] = key;
      blockIndices[slug] = index;
    }

    final chunkIndices = <String, int>{};
    for (final entry in blockIndices.entries) {
      chunkIndices[entry.key] = _chunkIndexForBlock(entry.value, chunks);
    }

    _cachedBlockHeadingKeys = List<GlobalKey?>.unmodifiable(keys);
    _cachedBlockHeadingAnchors = List<String?>.unmodifiable(slugs);
    _cachedHeadingAnchorMap = Map<String, GlobalKey>.unmodifiable(anchors);
    _cachedHeadingChunkIndices = Map<String, int>.unmodifiable(chunkIndices);
  }

  MarkdownDocumentMetrics _collectDocumentMetrics(
    _MarkdownDocument document,
    List<_MarkdownChunk> chunks,
  ) {
    var headingCount = 0;
    var imageCount = 0;
    var tableCount = 0;
    for (final block in document.blocks) {
      if (_isHeadingBlockType(block.type)) {
        headingCount += 1;
      }
      if (block.type == _MarkdownBlockType.image) {
        imageCount += 1;
      }
      if (block.type == _MarkdownBlockType.table) {
        tableCount += 1;
      }
    }
    return MarkdownDocumentMetrics(
      blockCount: document.blocks.length,
      chunkCount: chunks.length,
      headingCount: headingCount,
      imageCount: imageCount,
      tableCount: tableCount,
    );
  }

  void _notifyDocumentReady(int generation, MarkdownDocumentMetrics metrics) {
    final callback = widget.onDocumentReady;
    if (callback == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _parseGeneration) {
        return;
      }
      callback(metrics);
    });
  }

  int _chunkIndexForBlock(int blockIndex, List<_MarkdownChunk> chunks) {
    for (var index = 0; index < chunks.length; index++) {
      final chunk = chunks[index];
      if (blockIndex >= chunk.startBlockIndex &&
          blockIndex < chunk.endBlockIndex) {
        return index;
      }
    }
    return 0;
  }

  bool _isHeadingBlockType(_MarkdownBlockType type) {
    return type == _MarkdownBlockType.heading1 ||
        type == _MarkdownBlockType.heading2 ||
        type == _MarkdownBlockType.heading3 ||
        type == _MarkdownBlockType.heading4 ||
        type == _MarkdownBlockType.heading5 ||
        type == _MarkdownBlockType.heading6;
  }

  String _normalizeAnchorSlug(String value) {
    final decoded = Uri.decodeComponent(value).trim().toLowerCase();
    if (decoded.isEmpty) {
      return '';
    }
    var slug = decoded.replaceAll(RegExp(r'<[^>]+>'), '');
    slug = slug.replaceAll(RegExp(r'[`\*_\~\[\]\(\)\{\}]'), '');
    slug = slug.replaceAll(RegExp(r'[^\w\s-]'), '');
    slug = slug.replaceAll(RegExp(r'\s+'), '-');
    slug = slug.replaceAll(RegExp(r'-+'), '-');
    slug = slug.replaceAll(RegExp(r'^-+|-+$'), '');
    return slug;
  }

  bool _scrollToAnchor(String rawAnchor) {
    final anchor = _normalizeAnchorSlug(rawAnchor);
    if (anchor.isEmpty) {
      return false;
    }
    final key = _cachedHeadingAnchorMap[anchor];
    final targetContext = key?.currentContext;
    if (targetContext == null) {
      final targetChunkIndex = _cachedHeadingChunkIndices[anchor];
      if (targetChunkIndex == null) {
        return false;
      }
      if (widget.shrinkWrap) {
        if (_visibleChunkCount <= targetChunkIndex) {
          setState(() {
            _visibleChunkCount = targetChunkIndex + 1;
          });
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final contextAfterBuild =
              _cachedHeadingAnchorMap[anchor]?.currentContext;
          if (contextAfterBuild != null) {
            Scrollable.ensureVisible(
              contextAfterBuild,
              alignment: 0.08,
              curve: Curves.easeOutCubic,
              duration: const Duration(milliseconds: 180),
            );
          }
        });
        return true;
      }
      if (_chunkScrollController.hasClients) {
        final targetOffset = _estimatedScrollOffsetForChunk(targetChunkIndex);
        unawaited(
          _chunkScrollController
              .animateTo(
                targetOffset.clamp(
                  0.0,
                  _chunkScrollController.position.maxScrollExtent,
                ),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
              )
              .whenComplete(() {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final contextAfterScroll =
                      _cachedHeadingAnchorMap[anchor]?.currentContext;
                  if (contextAfterScroll != null) {
                    Scrollable.ensureVisible(
                      contextAfterScroll,
                      alignment: 0.08,
                      curve: Curves.easeOutCubic,
                      duration: const Duration(milliseconds: 140),
                    );
                  }
                });
              }),
        );
        return true;
      }
      return false;
    }
    Scrollable.ensureVisible(
      targetContext,
      alignment: 0.08,
      curve: Curves.easeOutCubic,
      duration: const Duration(milliseconds: 180),
    );
    return true;
  }

  double _estimatedScrollOffsetForChunk(int chunkIndex) {
    var offset = 0.0;
    for (var index = 0; index < chunkIndex && index < _chunks.length; index++) {
      offset += _chunks[index].estimatedExtent;
    }
    return offset;
  }

  MarkdownLinkKind _classifyLinkKind(String url) {
    final trimmed = url.trim();
    if (trimmed.startsWith('#')) {
      return MarkdownLinkKind.anchor;
    }
    if (trimmed.toLowerCase().startsWith('mailto:')) {
      return MarkdownLinkKind.email;
    }
    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasScheme) {
      return MarkdownLinkKind.external;
    }
    return MarkdownLinkKind.relative;
  }

  PageStorageKey<String> _viewportPageStorageKey() {
    final explicitId = widget.viewportStorageId;
    if (explicitId != null) {
      return PageStorageKey<String>('markdown:$explicitId');
    }
    final source = switch (widget.sourceType) {
      MarkdownSourceType.text =>
        'text:${widget.data.hashCode}:${widget.data.length}',
      MarkdownSourceType.asset => 'asset:${widget.sourcePath ?? ''}',
      MarkdownSourceType.file => 'file:${widget.sourcePath ?? ''}',
    };
    final widgetKey = widget.key?.toString() ?? 'no-key';
    return PageStorageKey<String>('markdown:$widgetKey:$source');
  }

  void _emitElementTap(MarkdownTapElementDetails details) {
    widget.onTapElement?.call(details);
  }

  Widget _wrapElementTap({
    required Widget child,
    required MarkdownTapElementDetails details,
    bool enabled = true,
  }) {
    if (!enabled || widget.onTapElement == null) {
      return child;
    }
    return _MarkdownTapReporter(
      onTap: () => _emitElementTap(details),
      child: child,
    );
  }

  Widget _buildRichTextBlock(
    BuildContext context, {
    required TextSpan text,
    TextAlign textAlign = TextAlign.start,
    bool softWrap = true,
  }) {
    final registrar = widget.selectable
        ? SelectionContainer.maybeOf(context)
        : null;
    final selectionColor = widget.selectable
        ? (DefaultSelectionStyle.of(context).selectionColor ??
              const Color(0x406694E8))
        : null;
    return RichText(
      text: text,
      textAlign: textAlign,
      softWrap: softWrap,
      selectionRegistrar: registrar,
      selectionColor: selectionColor,
    );
  }

  Widget _buildTaskCheckbox(
    BuildContext context, {
    required bool checked,
    required TextStyle baseStyle,
    MarkdownTheme? markdownTheme,
  }) {
    final referenceColor =
        markdownTheme?.linkStyle?.color ?? const Color(0xFF6F8A99);
    const surfaceColor = Color(0xFFF8FAFC);
    final fillColor = Color.lerp(referenceColor, surfaceColor, 0.35)!;
    final uncheckedBorderColor =
        baseStyle.color?.withValues(alpha: 0.34) ?? const Color(0xFF9CA3AF);

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: checked ? fillColor : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: checked ? fillColor : uncheckedBorderColor,
          width: 1.4,
        ),
        boxShadow: checked
            ? [
                BoxShadow(
                  color: fillColor.withValues(alpha: 0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: checked
          ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
          : null,
    );
  }

  MarkdownImagePreviewDetails _imagePreviewDetailsForBlock(
    _MarkdownBlock block,
  ) {
    return MarkdownImagePreviewDetails(
      url: (block.imageUrl ?? '').trim(),
      alt: block.imageAlt ?? '',
      title: block.imageTitle,
    );
  }

  Widget _buildResolvedImageWidget(
    BuildContext context,
    MarkdownImagePreviewDetails details, {
    BoxFit fit = BoxFit.contain,
  }) {
    if (widget.imageBuilder != null) {
      return widget.imageBuilder!(context, details.url, details.alt);
    }

    final normalized = details.url.trim();
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      if (_failedNetworkImageUrls.contains(normalized)) {
        return _buildImageFallback(
          DefaultTextStyle.of(context).style,
          details.alt.isNotEmpty ? details.alt : 'Image failed to load',
        );
      }
      return Image.network(
        normalized,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          _failedNetworkImageUrls.add(normalized);
          return _buildImageFallback(
            DefaultTextStyle.of(context).style,
            details.alt.isNotEmpty ? details.alt : 'Image failed to load',
          );
        },
      );
    }

    final assetPath = normalized.startsWith('asset:')
        ? normalized.substring(6)
        : normalized;
    return Image.asset(
      assetPath,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildImageFallback(
        DefaultTextStyle.of(context).style,
        details.alt.isNotEmpty ? details.alt : assetPath,
      ),
    );
  }

  Future<void> _showImagePreview(
    BuildContext context,
    MarkdownImagePreviewDetails details,
  ) async {
    if (widget.imagePreviewBehavior == MarkdownImagePreviewBehavior.none) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.76),
      builder: (dialogContext) {
        void close() {
          Navigator.of(dialogContext).maybePop();
        }

        if (widget.imagePreviewBuilder != null) {
          return widget.imagePreviewBuilder!(dialogContext, details, close);
        }

        return Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.all(24),
          backgroundColor: Colors.transparent,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 860,
              maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.88,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x22000000)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 12, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details.alt.isNotEmpty
                                    ? details.alt
                                    : 'Image preview',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if ((details.title ?? '').isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    details.title!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: close,
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: const Color(0xFFF1F5F9),
                      padding: const EdgeInsets.all(16),
                      child: InteractiveViewer(
                        minScale: 1,
                        maxScale: 4,
                        child: Center(
                          child: _buildResolvedImageWidget(
                            dialogContext,
                            details,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            details.url,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton.icon(
                          onPressed: () =>
                              unawaited(openMarkdownLink(details.url)),
                          icon: const Icon(Icons.open_in_new_rounded, size: 16),
                          label: const Text('Open source'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  MarkdownBlockKind _blockKind(_MarkdownBlock block) {
    return switch (block.type) {
      _MarkdownBlockType.blank => MarkdownBlockKind.blank,
      _MarkdownBlockType.paragraph => MarkdownBlockKind.paragraph,
      _MarkdownBlockType.heading1 ||
      _MarkdownBlockType.heading2 ||
      _MarkdownBlockType.heading3 ||
      _MarkdownBlockType.heading4 ||
      _MarkdownBlockType.heading5 ||
      _MarkdownBlockType.heading6 => MarkdownBlockKind.heading,
      _MarkdownBlockType.unorderedList => MarkdownBlockKind.unorderedList,
      _MarkdownBlockType.orderedList => MarkdownBlockKind.orderedList,
      _MarkdownBlockType.taskList => MarkdownBlockKind.taskList,
      _MarkdownBlockType.quote => MarkdownBlockKind.quote,
      _MarkdownBlockType.codeFence ||
      _MarkdownBlockType.indentedCode => MarkdownBlockKind.codeBlock,
      _MarkdownBlockType.table => MarkdownBlockKind.table,
      _MarkdownBlockType.image => MarkdownBlockKind.image,
      _MarkdownBlockType.definitionList => MarkdownBlockKind.definitionList,
      _MarkdownBlockType.details => MarkdownBlockKind.details,
      _MarkdownBlockType.math => MarkdownBlockKind.math,
      _MarkdownBlockType.footnote => MarkdownBlockKind.footnote,
      _MarkdownBlockType.rawHtml => MarkdownBlockKind.rawHtml,
      _MarkdownBlockType.horizontalRule => MarkdownBlockKind.horizontalRule,
    };
  }

  int? _headingLevelForBlock(_MarkdownBlock block) {
    return switch (block.type) {
      _MarkdownBlockType.heading1 => 1,
      _MarkdownBlockType.heading2 => 2,
      _MarkdownBlockType.heading3 => 3,
      _MarkdownBlockType.heading4 => 4,
      _MarkdownBlockType.heading5 => 5,
      _MarkdownBlockType.heading6 => 6,
      _ => null,
    };
  }

  MarkdownTapElementKind? _blockTapKind(_MarkdownBlock block) {
    return switch (block.type) {
      _MarkdownBlockType.paragraph => MarkdownTapElementKind.paragraph,
      _MarkdownBlockType.heading1 ||
      _MarkdownBlockType.heading2 ||
      _MarkdownBlockType.heading3 ||
      _MarkdownBlockType.heading4 ||
      _MarkdownBlockType.heading5 ||
      _MarkdownBlockType.heading6 => MarkdownTapElementKind.heading,
      _MarkdownBlockType.unorderedList ||
      _MarkdownBlockType.orderedList ||
      _MarkdownBlockType.taskList => MarkdownTapElementKind.listItem,
      _MarkdownBlockType.codeFence ||
      _MarkdownBlockType.indentedCode => MarkdownTapElementKind.codeBlock,
      _MarkdownBlockType.math => MarkdownTapElementKind.math,
      _MarkdownBlockType.footnote => MarkdownTapElementKind.footnote,
      _MarkdownBlockType.rawHtml => MarkdownTapElementKind.rawHtml,
      _MarkdownBlockType.horizontalRule =>
        MarkdownTapElementKind.horizontalRule,
      _ => null,
    };
  }

  MarkdownTapElementDetails? _buildBlockTapDetails(
    _MarkdownBlock block, {
    required int blockIndex,
    String? headingAnchorSlug,
  }) {
    final kind = _blockTapKind(block);
    if (kind == null) {
      return null;
    }
    final headingLevel = switch (block.type) {
      _MarkdownBlockType.heading1 => 1,
      _MarkdownBlockType.heading2 => 2,
      _MarkdownBlockType.heading3 => 3,
      _MarkdownBlockType.heading4 => 4,
      _MarkdownBlockType.heading5 => 5,
      _MarkdownBlockType.heading6 => 6,
      _ => null,
    };
    return MarkdownTapElementDetails(
      kind: kind,
      text: block.text,
      anchor: headingAnchorSlug,
      headingLevel: headingLevel,
      blockIndex: blockIndex,
      orderedIndex: block.type == _MarkdownBlockType.orderedList
          ? block.orderedIndex
          : null,
      checked: block.type == _MarkdownBlockType.taskList ? block.checked : null,
    );
  }

  MarkdownBlockBuildDetails _buildBlockRenderDetails(
    _MarkdownBlock block, {
    required int blockIndex,
    required Widget Function() buildDefault,
    String? headingAnchorSlug,
  }) {
    return MarkdownBlockBuildDetails(
      kind: _blockKind(block),
      text: block.text,
      blockIndex: blockIndex,
      buildDefault: buildDefault,
      headingLevel: _headingLevelForBlock(block),
      headingAnchor: headingAnchorSlug,
      language: block.language,
      orderedIndex: block.type == _MarkdownBlockType.orderedList
          ? block.orderedIndex
          : null,
      checked: block.type == _MarkdownBlockType.taskList ? block.checked : null,
      tableRows: List<List<String>>.unmodifiable(
        block.tableRows
            .map((row) => List<String>.unmodifiable(row))
            .toList(growable: false),
      ),
      tableAlignments: List<TextAlign>.unmodifiable(block.tableAlignments),
      imageUrl: block.imageUrl,
      imageAlt: block.imageAlt,
      imageTitle: block.imageTitle,
      label: block.label,
      items: List<String>.unmodifiable(block.items),
      htmlTag: block.htmlTag,
      htmlAttributes: Map<String, String>.unmodifiable(
        _extractHtmlAttributesMapFromBlock(block),
      ),
      rawHtml: block.rawHtml,
    );
  }

  Map<String, String> _extractHtmlAttributesMapFromBlock(_MarkdownBlock block) {
    final tag = block.htmlTag;
    if (tag == null || tag.isEmpty) {
      return const <String, String>{};
    }
    if (block.rawHtml == null || block.rawHtml!.isEmpty) {
      return const <String, String>{};
    }
    return _extractHtmlAttributesMap(
      _extractOpeningHtmlAttributes(block.rawHtml!, tag),
    );
  }

  void _handleTapLink(String text, String url) {
    final normalizedUrl = url.trim();
    final details = MarkdownLinkTapDetails(
      text: text,
      url: normalizedUrl,
      kind: _classifyLinkKind(normalizedUrl),
    );
    _emitElementTap(
      MarkdownTapElementDetails(
        kind: MarkdownTapElementKind.link,
        text: text,
        url: normalizedUrl,
        anchor: details.isAnchor ? normalizedUrl.substring(1) : null,
      ),
    );
    if (details.isAnchor && _scrollToAnchor(normalizedUrl.substring(1))) {
      widget.onTapLinkDetails?.call(details);
      widget.onTapLink?.call(text, normalizedUrl);
      return;
    }
    widget.onTapLinkDetails?.call(details);
    widget.onTapLink?.call(text, normalizedUrl);
    if (widget.followLinks) {
      unawaited(openMarkdownLink(normalizedUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || (_preparingDocument && _cachedDocument == null)) {
      return widget.loading ??
          const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    final error = _error;
    if (error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, error);
      }
      return Text(
        'Failed to load markdown: $error',
        style: DefaultTextStyle.of(
          context,
        ).style.copyWith(color: Colors.red.shade400),
      );
    }

    final markdownThemeOverride = ComponentTheme.maybeOf<MarkdownTheme>(
      context,
    );
    final baseStyle = styleValue<TextStyle>(
      widgetValue: widget.style,
      themeValue: markdownThemeOverride?.style,
      defaultValue: DefaultTextStyle.of(context).style,
    );
    final markdownTheme = (markdownThemeOverride ?? const MarkdownTheme())
        .withFallback(MarkdownTheme.htmlDefaults(baseStyle));
    final document = _cachedDocument;
    if (document == null) {
      return const SizedBox.shrink();
    }
    final blocks = document.blocks;
    final blockAnchors = _cachedBlockHeadingKeys;
    final blockHeadingSlugs = _cachedBlockHeadingAnchors;

    if (blocks.isEmpty) {
      return const SizedBox.shrink();
    }

    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        final useViewportList =
            !widget.shrinkWrap && constraints.hasBoundedHeight;
        final visibleChunkCount = useViewportList
            ? _chunks.length
            : _visibleChunkCount.clamp(0, _chunks.length);

        if (_chunks.isEmpty) {
          return const SizedBox.shrink();
        }

        return ListView.builder(
          key: _viewportPageStorageKey(),
          controller: useViewportList ? _chunkScrollController : null,
          padding: EdgeInsets.zero,
          shrinkWrap: !useViewportList,
          physics: useViewportList
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          cacheExtent: useViewportList ? (kIsWeb ? 240.0 : 640.0) : null,
          addAutomaticKeepAlives: false,
          itemCount: visibleChunkCount,
          itemBuilder: (context, chunkIndex) {
            final chunk = _chunks[chunkIndex];
            final chunkChild = _buildChunk(
              context,
              chunk,
              baseStyle,
              document,
              markdownTheme,
              blockAnchors,
              blockHeadingSlugs,
            );
            if (kIsWeb) {
              return chunkChild;
            }
            return RepaintBoundary(child: chunkChild);
          },
        );
      },
    );
    if (widget.selectable && SelectionContainer.maybeOf(context) == null) {
      content = SelectionArea(child: content);
    }
    return content;
  }

  Widget _buildChunk(
    BuildContext context,
    _MarkdownChunk chunk,
    TextStyle baseStyle,
    _MarkdownDocument document,
    MarkdownTheme markdownTheme,
    List<GlobalKey?> blockAnchors,
    List<String?> blockHeadingSlugs,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (
          var blockIndex = chunk.startBlockIndex;
          blockIndex < chunk.endBlockIndex;
          blockIndex++
        )
          _buildBlock(
            context,
            chunk.blocks[blockIndex - chunk.startBlockIndex],
            blockIndex,
            baseStyle,
            document,
            markdownTheme,
            headingAnchorKey: blockIndex < blockAnchors.length
                ? blockAnchors[blockIndex]
                : null,
            headingAnchorSlug: blockIndex < blockHeadingSlugs.length
                ? blockHeadingSlugs[blockIndex]
                : null,
          ),
      ],
    );
  }

  Widget _buildBlock(
    BuildContext context,
    _MarkdownBlock block,
    int blockIndex,
    TextStyle baseStyle,
    _MarkdownDocument document,
    MarkdownTheme? markdownTheme, {
    GlobalKey? headingAnchorKey,
    String? headingAnchorSlug,
  }) {
    final linkStyle = markdownTheme?.linkStyle;
    final rich = TextSpan(
      style: baseStyle,
      children: _buildInlineSpans(
        context,
        block.text,
        baseStyle,
        document,
        onTapLink: _handleTapLink,
        followLinks: widget.followLinks,
        linkStyle: linkStyle,
      ),
    );

    final mono = styleValue<TextStyle>(
      widgetValue: null,
      themeValue: markdownTheme?.codeStyle,
      defaultValue: baseStyle.copyWith(fontFamily: 'GeistMono', height: 1.45),
    );

    final headingScale = switch (block.type) {
      _MarkdownBlockType.heading1 => 1.75,
      _MarkdownBlockType.heading2 => 1.45,
      _MarkdownBlockType.heading3 => 1.25,
      _MarkdownBlockType.heading4 => 1.15,
      _MarkdownBlockType.heading5 => 1.05,
      _MarkdownBlockType.heading6 => 1.0,
      _ => 1.0,
    };

    final headingStyle = switch (block.type) {
      _MarkdownBlockType.heading1 => markdownTheme?.heading1Style,
      _MarkdownBlockType.heading2 => markdownTheme?.heading2Style,
      _MarkdownBlockType.heading3 => markdownTheme?.heading3Style,
      _MarkdownBlockType.heading4 => markdownTheme?.heading4Style,
      _MarkdownBlockType.heading5 => markdownTheme?.heading5Style,
      _MarkdownBlockType.heading6 => markdownTheme?.heading6Style,
      _ => null,
    };

    Widget buildDefaultChild() {
      switch (block.type) {
        case _MarkdownBlockType.codeFence:
        case _MarkdownBlockType.indentedCode:
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: markdownTheme?.codePadding ?? const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  markdownTheme?.codeBackgroundColor ?? const Color(0x11000000),
              borderRadius:
                  markdownTheme?.codeRadius ?? BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((block.language ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      block.language!,
                      style: styleValue<TextStyle>(
                        widgetValue: null,
                        themeValue: markdownTheme?.codeLanguageStyle,
                        defaultValue: mono.copyWith(
                          fontSize: (mono.fontSize ?? 14) * 0.85,
                          color: baseStyle.color?.withValues(alpha: 0.65),
                        ),
                      ),
                    ),
                  ),
                _buildRichTextBlock(
                  context,
                  text: TextSpan(style: mono, text: block.text),
                ),
              ],
            ),
          );
        case _MarkdownBlockType.unorderedList:
        case _MarkdownBlockType.orderedList:
        case _MarkdownBlockType.taskList:
          final isTaskList = block.type == _MarkdownBlockType.taskList;
          final listContent = _buildListItemContent(
            context,
            block,
            baseStyle,
            document,
            markdownTheme,
          );
          return Padding(
            padding: EdgeInsets.only(
              left: 8 + (block.indentLevel * (markdownTheme?.listIndent ?? 18)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: isTaskList
                      ? _buildTaskCheckbox(
                          context,
                          checked: block.checked == true,
                          baseStyle: baseStyle,
                          markdownTheme: markdownTheme,
                        )
                      : Text(switch (block.type) {
                          _MarkdownBlockType.unorderedList => '• ',
                          _MarkdownBlockType.orderedList =>
                            '${block.orderedIndex}. ',
                          _ => '',
                        }, style: baseStyle),
                ),
                SizedBox(width: isTaskList ? 8 : 0),
                Expanded(child: listContent),
              ],
            ),
          );
        case _MarkdownBlockType.quote:
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding:
                markdownTheme?.quotePadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: markdownTheme?.quoteBackgroundColor,
              border: Border(
                left: BorderSide(
                  color:
                      markdownTheme?.quoteBorderColor ??
                      baseStyle.color?.withValues(alpha: 0.45) ??
                      const Color(0x66000000),
                  width: markdownTheme?.quoteBorderWidth ?? 3,
                ),
              ),
            ),
            child: Markdown(
              data: block.text,
              selectable: widget.selectable,
              style: markdownTheme?.quoteStyle ?? baseStyle,
              onTapLink: _handleTapLink,
              onTapLinkDetails: widget.onTapLinkDetails,
              onTapImage: widget.onTapImage,
              onTapHeading: widget.onTapHeading,
              onTapElement: widget.onTapElement,
              blockBuilder: widget.blockBuilder,
              shrinkWrap: true,
              followLinks: widget.followLinks,
              htmlSanitizationStrategy: widget.htmlSanitizationStrategy,
              imagePreviewBehavior: widget.imagePreviewBehavior,
              imagePreviewBuilder: widget.imagePreviewBuilder,
              imageBuilder: widget.imageBuilder,
            ),
          );
        case _MarkdownBlockType.horizontalRule:
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Divider(
              height: 1,
              color: markdownTheme?.horizontalRuleColor,
            ),
          );
        case _MarkdownBlockType.table:
          return _buildTable(
            context,
            block,
            blockIndex,
            baseStyle,
            document,
            markdownTheme,
          );
        case _MarkdownBlockType.image:
          return _buildImage(
            context,
            block,
            blockIndex,
            baseStyle,
            markdownTheme,
          );
        case _MarkdownBlockType.definitionList:
          return _buildDefinitionList(
            context,
            block,
            blockIndex,
            baseStyle,
            document,
            markdownTheme,
          );
        case _MarkdownBlockType.details:
          return _MarkdownDisclosure(
            summary: block.text,
            onSummaryTap: (widget.onTapElement == null)
                ? null
                : () {
                    _emitElementTap(
                      MarkdownTapElementDetails(
                        kind: MarkdownTapElementKind.detailsSummary,
                        text: block.text,
                        blockIndex: blockIndex,
                      ),
                    );
                  },
            summaryStyle:
                markdownTheme?.detailsSummaryStyle ??
                baseStyle.copyWith(fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    markdownTheme?.detailsBorderColor ??
                    const Color(0x22000000),
              ),
              color: markdownTheme?.detailsBackgroundColor,
              borderRadius:
                  markdownTheme?.detailsRadius ?? BorderRadius.circular(10),
            ),
            headerPadding:
                markdownTheme?.detailsHeaderPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            bodyPadding:
                markdownTheme?.detailsBodyPadding ??
                const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Markdown(
              data: block.items.isEmpty ? '' : block.items.first,
              selectable: widget.selectable,
              style: baseStyle,
              onTapLink: _handleTapLink,
              onTapLinkDetails: widget.onTapLinkDetails,
              onTapImage: widget.onTapImage,
              onTapHeading: widget.onTapHeading,
              onTapElement: widget.onTapElement,
              blockBuilder: widget.blockBuilder,
              shrinkWrap: true,
              followLinks: widget.followLinks,
              htmlSanitizationStrategy: widget.htmlSanitizationStrategy,
              imagePreviewBehavior: widget.imagePreviewBehavior,
              imagePreviewBuilder: widget.imagePreviewBuilder,
              imageBuilder: widget.imageBuilder,
            ),
          );
        case _MarkdownBlockType.math:
          return _buildMathBlock(block, mono, markdownTheme);
        case _MarkdownBlockType.footnote:
          return _buildFootnote(
            context,
            block,
            baseStyle,
            document,
            markdownTheme,
          );
        case _MarkdownBlockType.rawHtml:
          return _buildRichTextBlock(
            context,
            text: TextSpan(
              style: baseStyle,
              children: _buildInlineSpans(
                context,
                _htmlToInlineText(block.text),
                baseStyle,
                document,
                onTapLink: _handleTapLink,
                followLinks: widget.followLinks,
                linkStyle: linkStyle,
              ),
            ),
          );
        default:
          final resolvedHeadingStyle = styleValue<TextStyle>(
            widgetValue: null,
            themeValue: headingStyle,
            defaultValue: baseStyle.copyWith(
              fontWeight: block.type.index <= _MarkdownBlockType.heading6.index
                  ? FontWeight.w700
                  : FontWeight.w400,
              fontSize: (baseStyle.fontSize ?? 14) * headingScale,
              height: 1.35,
            ),
          );
          return widget.selectable
              ? _buildRichTextBlock(
                  context,
                  text: TextSpan(
                    style: resolvedHeadingStyle,
                    children: rich.children,
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: resolvedHeadingStyle,
                    children: rich.children,
                  ),
                );
      }
    }

    Widget child =
        widget.blockBuilder?.call(
          context,
          _buildBlockRenderDetails(
            block,
            blockIndex: blockIndex,
            buildDefault: buildDefaultChild,
            headingAnchorSlug: headingAnchorSlug,
          ),
        ) ??
        buildDefaultChild();

    if (headingAnchorKey != null) {
      child = KeyedSubtree(key: headingAnchorKey, child: child);
    }

    final headingLevel = switch (block.type) {
      _MarkdownBlockType.heading1 => 1,
      _MarkdownBlockType.heading2 => 2,
      _MarkdownBlockType.heading3 => 3,
      _MarkdownBlockType.heading4 => 4,
      _MarkdownBlockType.heading5 => 5,
      _MarkdownBlockType.heading6 => 6,
      _ => null,
    };
    if (headingAnchorSlug != null &&
        headingLevel != null &&
        (widget.onTapHeading != null || widget.onTapElement != null)) {
      child = _MarkdownTapReporter(
        onTap: () {
          widget.onTapHeading?.call(
            MarkdownHeadingTapDetails(
              text: block.text,
              anchor: headingAnchorSlug,
              level: headingLevel,
            ),
          );
          _emitElementTap(
            MarkdownTapElementDetails(
              kind: MarkdownTapElementKind.heading,
              text: block.text,
              anchor: headingAnchorSlug,
              headingLevel: headingLevel,
              blockIndex: blockIndex,
            ),
          );
        },
        child: child,
      );
    } else {
      final blockTapDetails = _buildBlockTapDetails(
        block,
        blockIndex: blockIndex,
        headingAnchorSlug: headingAnchorSlug,
      );
      if (blockTapDetails != null) {
        child = _wrapElementTap(child: child, details: blockTapDetails);
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: block.type == _MarkdownBlockType.blank
            ? 8
            : (markdownTheme?.blockSpacing ?? 6),
      ),
      child: child,
    );
  }

  Widget _buildTable(
    BuildContext context,
    _MarkdownBlock block,
    int blockIndex,
    TextStyle baseStyle,
    _MarkdownDocument document,
    MarkdownTheme? markdownTheme,
  ) {
    final rows = block.tableRows;
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }
    final maxColumns = rows.fold<int>(
      0,
      (max, row) => row.length > max ? row.length : max,
    );
    final minCellWidth = markdownTheme?.tableCellMinWidth ?? 112.0;

    final headerStyle = styleValue<TextStyle>(
      widgetValue: null,
      themeValue: markdownTheme?.tableHeaderStyle,
      defaultValue: baseStyle.copyWith(fontWeight: FontWeight.w700),
    );
    final cellStyle = styleValue<TextStyle>(
      widgetValue: null,
      themeValue: markdownTheme?.tableCellStyle,
      defaultValue: baseStyle,
    );
    final borderColor =
        markdownTheme?.tableBorderColor ?? const Color(0x22000000);
    return LayoutBuilder(
      builder: (context, constraints) {
        final compactMode =
            constraints.maxWidth.isFinite && constraints.maxWidth < 420;
        final compactHeaderStyle = compactMode
            ? headerStyle.copyWith(
                fontSize:
                    (headerStyle.fontSize ?? baseStyle.fontSize ?? 14) * 0.92,
              )
            : headerStyle;
        final compactCellStyle = compactMode
            ? cellStyle.copyWith(
                fontSize:
                    (cellStyle.fontSize ?? baseStyle.fontSize ?? 14) * 0.94,
              )
            : cellStyle;
        final cellPadding = compactMode
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8)
            : (markdownTheme?.tableCellPadding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10));
        final resolvedMinCellWidth = compactMode
            ? (minCellWidth.clamp(72.0, 88.0) as num).toDouble()
            : minCellWidth;

        return Container(
          margin: EdgeInsets.symmetric(vertical: compactMode ? 4 : 6),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius:
                markdownTheme?.tableRadius ?? BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              defaultColumnWidth: const IntrinsicColumnWidth(),
              columnWidths: <int, TableColumnWidth>{
                for (var col = 0; col < maxColumns; col++)
                  col: const IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder(
                horizontalInside: BorderSide(color: borderColor),
                verticalInside: BorderSide(color: borderColor),
              ),
              children: [
                for (var rowIndex = 0; rowIndex < rows.length; rowIndex++)
                  TableRow(
                    decoration: BoxDecoration(
                      color: rowIndex == 0
                          ? (markdownTheme?.tableHeaderBackgroundColor ??
                                const Color(0x11000000))
                          : Colors.transparent,
                    ),
                    children: [
                      for (
                        var colIndex = 0;
                        colIndex < rows[rowIndex].length;
                        colIndex++
                      )
                        () {
                          final cellText = rows[rowIndex][colIndex];
                          final cellTextAlign =
                              colIndex < block.tableAlignments.length
                              ? block.tableAlignments[colIndex]
                              : TextAlign.left;
                          final effectiveCellStyle = rowIndex == 0
                              ? compactHeaderStyle
                              : compactCellStyle;
                          return Padding(
                            padding: cellPadding,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: resolvedMinCellWidth,
                              ),
                              child: _wrapElementTap(
                                details: MarkdownTapElementDetails(
                                  kind: rowIndex == 0
                                      ? MarkdownTapElementKind.tableHeaderCell
                                      : MarkdownTapElementKind.tableCell,
                                  text: cellText,
                                  blockIndex: blockIndex,
                                  tableRow: rowIndex,
                                  tableColumn: colIndex,
                                ),
                                child: _buildTableCellContent(
                                  context,
                                  cellText: cellText,
                                  textStyle: effectiveCellStyle,
                                  textAlign: cellTextAlign,
                                  document: document,
                                  markdownTheme: markdownTheme,
                                ),
                              ),
                            ),
                          );
                        }(),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableCellContent(
    BuildContext context, {
    required String cellText,
    required TextStyle textStyle,
    required TextAlign textAlign,
    required _MarkdownDocument document,
    required MarkdownTheme? markdownTheme,
  }) {
    if (_looksLikeTableCellBlockContent(cellText)) {
      return Align(
        alignment: _alignmentForTextAlign(textAlign),
        child: Markdown(
          data: cellText,
          selectable: widget.selectable,
          style: textStyle,
          onTapLink: _handleTapLink,
          onTapLinkDetails: widget.onTapLinkDetails,
          onTapImage: widget.onTapImage,
          onTapHeading: widget.onTapHeading,
          onTapElement: widget.onTapElement,
          blockBuilder: widget.blockBuilder,
          shrinkWrap: true,
          followLinks: widget.followLinks,
          htmlSanitizationStrategy: widget.htmlSanitizationStrategy,
          imagePreviewBehavior: widget.imagePreviewBehavior,
          imagePreviewBuilder: widget.imagePreviewBuilder,
          imageBuilder: widget.imageBuilder,
        ),
      );
    }

    return _buildRichTextBlock(
      context,
      textAlign: textAlign,
      text: TextSpan(
        style: textStyle,
        children: _buildInlineSpans(
          context,
          cellText,
          textStyle,
          document,
          onTapLink: _handleTapLink,
          followLinks: widget.followLinks,
          linkStyle: markdownTheme?.linkStyle,
        ),
      ),
    );
  }

  bool _looksLikeTableCellBlockContent(String value) {
    final normalized = value.replaceAll('\r\n', '\n').trim();
    if (normalized.isEmpty) {
      return false;
    }
    if (_looksLikeNestedMixedBlock(normalized)) {
      return true;
    }
    if (!normalized.contains('\n')) {
      return false;
    }
    for (final line in normalized.split('\n')) {
      final trimmed = line.trimLeft();
      if (trimmed.isEmpty) {
        continue;
      }
      if (_looksLikeNestedMixedBlock(trimmed) ||
          RegExp(r'^```').hasMatch(trimmed) ||
          RegExp(r'^~~~').hasMatch(trimmed)) {
        return true;
      }
    }
    return false;
  }

  Alignment _alignmentForTextAlign(TextAlign textAlign) {
    return switch (textAlign) {
      TextAlign.right => Alignment.centerRight,
      TextAlign.center => Alignment.center,
      TextAlign.end => Alignment.centerRight,
      _ => Alignment.centerLeft,
    };
  }

  Widget _buildImage(
    BuildContext context,
    _MarkdownBlock block,
    int blockIndex,
    TextStyle baseStyle,
    MarkdownTheme? markdownTheme,
  ) {
    final imageUrl = block.imageUrl ?? '';
    if (imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    final alt = block.imageAlt ?? '';
    final previewDetails = _imagePreviewDetailsForBlock(block);
    final image = _buildResolvedImageWidget(context, previewDetails);

    Widget child = Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      constraints: BoxConstraints(
        maxHeight: markdownTheme?.imageMaxHeight ?? 280,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(10), child: image),
          if (alt.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                block.imageTitle?.isNotEmpty == true
                    ? '$alt • ${block.imageTitle}'
                    : alt,
                style: styleValue<TextStyle>(
                  widgetValue: null,
                  themeValue: markdownTheme?.imageCaptionStyle,
                  defaultValue: baseStyle.copyWith(
                    fontSize: (baseStyle.fontSize ?? 14) * 0.9,
                    color: baseStyle.color?.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (widget.onTapImage != null ||
        widget.onTapElement != null ||
        widget.imagePreviewBehavior != MarkdownImagePreviewBehavior.none) {
      child = _MarkdownTapReporter(
        onTap: () {
          final tapDetails = MarkdownImageTapDetails(
            url: imageUrl.trim(),
            alt: alt,
            title: block.imageTitle,
          );
          widget.onTapImage?.call(tapDetails);
          _emitElementTap(
            MarkdownTapElementDetails(
              kind: MarkdownTapElementKind.image,
              text: alt,
              url: imageUrl.trim(),
              title: block.imageTitle,
              blockIndex: blockIndex,
            ),
          );
          if (widget.imagePreviewBehavior !=
              MarkdownImagePreviewBehavior.none) {
            unawaited(_showImagePreview(context, previewDetails));
          }
        },
        child: child,
      );
    }

    return child;
  }

  Widget _buildImageFallback(TextStyle baseStyle, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x22000000)),
        color: const Color(0x08000000),
      ),
      child: Text(
        message,
        style: baseStyle.copyWith(
          fontSize: (baseStyle.fontSize ?? 14) * 0.9,
          color: baseStyle.color?.withValues(alpha: 0.72),
        ),
      ),
    );
  }

  Widget _buildDefinitionList(
    BuildContext context,
    _MarkdownBlock block,
    int blockIndex,
    TextStyle baseStyle,
    _MarkdownDocument document,
    MarkdownTheme? markdownTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _wrapElementTap(
            details: MarkdownTapElementDetails(
              kind: MarkdownTapElementKind.definitionTerm,
              text: block.text,
              blockIndex: blockIndex,
            ),
            child: Text(
              block.text,
              style: baseStyle.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          for (var itemIndex = 0; itemIndex < block.items.length; itemIndex++)
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 4),
              child: _wrapElementTap(
                details: MarkdownTapElementDetails(
                  kind: MarkdownTapElementKind.definitionDescription,
                  text: block.items[itemIndex],
                  blockIndex: blockIndex,
                ),
                child: _buildRichTextBlock(
                  context,
                  text: TextSpan(
                    style: baseStyle,
                    children: _buildInlineSpans(
                      context,
                      block.items[itemIndex],
                      baseStyle,
                      document,
                      onTapLink: _handleTapLink,
                      followLinks: widget.followLinks,
                      linkStyle: markdownTheme?.linkStyle,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListItemContent(
    BuildContext context,
    _MarkdownBlock block,
    TextStyle baseStyle,
    _MarkdownDocument document,
    MarkdownTheme? markdownTheme,
  ) {
    if (_looksLikeNestedMixedBlock(block.text)) {
      return Markdown(
        data: block.text,
        selectable: widget.selectable,
        style: baseStyle,
        onTapLink: _handleTapLink,
        onTapLinkDetails: widget.onTapLinkDetails,
        onTapImage: widget.onTapImage,
        onTapHeading: widget.onTapHeading,
        onTapElement: widget.onTapElement,
        blockBuilder: widget.blockBuilder,
        shrinkWrap: true,
        followLinks: widget.followLinks,
        htmlSanitizationStrategy: widget.htmlSanitizationStrategy,
        imagePreviewBehavior: widget.imagePreviewBehavior,
        imagePreviewBuilder: widget.imagePreviewBuilder,
        imageBuilder: widget.imageBuilder,
      );
    }

    final rich = TextSpan(
      style: baseStyle,
      children: _buildInlineSpans(
        context,
        block.text,
        baseStyle,
        document,
        onTapLink: _handleTapLink,
        followLinks: widget.followLinks,
        linkStyle: markdownTheme?.linkStyle,
      ),
    );
    return _buildRichTextBlock(context, text: rich);
  }

  bool _looksLikeNestedMixedBlock(String value) {
    final trimmed = value.trimLeft();
    if (trimmed.isEmpty) {
      return false;
    }
    return RegExp(r'^(#{1,6})\s+').hasMatch(trimmed) ||
        RegExp(r'^\s*>\s?').hasMatch(trimmed) ||
        RegExp(r'^\s*[-*+]\s+\[( |x|X)\]\s+').hasMatch(trimmed) ||
        RegExp(r'^\s*[-*+]\s+').hasMatch(trimmed) ||
        RegExp(r'^\s*\d+\.\s+').hasMatch(trimmed) ||
        RegExp(r'^\s*(`{3,}|~{3,})').hasMatch(trimmed) ||
        RegExp(r'^\s*([-_*])\s*\1\s*\1').hasMatch(trimmed) ||
        _looksLikeWrappedHeadingLine(trimmed);
  }

  Widget _buildMathBlock(
    _MarkdownBlock block,
    TextStyle mono,
    MarkdownTheme? markdownTheme,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: markdownTheme?.codePadding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: markdownTheme?.codeBackgroundColor ?? const Color(0x11000000),
        borderRadius: markdownTheme?.codeRadius ?? BorderRadius.circular(10),
      ),
      child: Text(
        block.text,
        style: styleValue<TextStyle>(
          widgetValue: null,
          themeValue: markdownTheme?.mathStyle,
          defaultValue: mono.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget _buildFootnote(
    BuildContext context,
    _MarkdownBlock block,
    TextStyle baseStyle,
    _MarkdownDocument document,
    MarkdownTheme? markdownTheme,
  ) {
    final labelStyle = styleValue<TextStyle>(
      widgetValue: null,
      themeValue: markdownTheme?.footnoteLabelStyle,
      defaultValue: baseStyle.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: (baseStyle.fontSize ?? 14) * 0.9,
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('[${block.label}] ', style: labelStyle),
          Expanded(
            child: _buildRichTextBlock(
              context,
              text: TextSpan(
                style: baseStyle,
                children: _buildInlineSpans(
                  context,
                  block.text,
                  baseStyle,
                  document,
                  onTapLink: _handleTapLink,
                  followLinks: widget.followLinks,
                  linkStyle: markdownTheme?.linkStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _htmlToInlineText(String value) {
    return value
        .replaceAll(
          RegExp(r'</?(div|p|details|summary)>', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .trim();
  }
}
