// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

enum _StreamMode { character, word, chunk, part }

enum _AnimationKind { blur, fade, slide, scramble }

class _MarkdownPreviewState extends m.State<MarkdownPreview> {
  static const String _showcaseFilePath =
      '/Users/ibrar/Desktop/infinora.noworkspace/shadcn_copy_paste/Markdown Feature Showcase - ChatGPT.md';
  static const String _showcaseAssetPath =
      'assets/markdown/markdown_feature_showcase.md';
  static const String _inlineMarkdown = '''# Advanced Markdown Renderer

This is **bold**, *italic*, ***bold italic***, `inline code`, and ~~strikethrough~~.

## Checklist
- [x] Parser supports task list
- [ ] Add your own `onTapLink` callback
  - Nested bullets work
  - Ordered lists also work

## Table
| Feature | Status | Notes |
| :-- | :--: | --: |
| Headings | done | 6 levels |
| Tables | done | aligned cells |
| Streaming | done | extension based |

## Code
```dart
final widget = Markdown(data: '# Hello');
print(widget.runtimeType);
```

> Block quotes are grouped and rendered with a left border.

![Network Image](https://picsum.photos/640/220)

Link example: [Flutter](https://flutter.dev)
''';

  static const String _interactionMarkdown = '''# Interaction Hooks

## Table of Contents
- [Jump to tables](#tables)
- [Jump to code](#code)
- [Open Flutter](https://flutter.dev)
- [Email support](mailto:hello@example.com)

![Preview card](https://example.com/preview.png "Preview")

## Tables
| Hook | Payload |
| :-- | :-- |
| Link | `MarkdownLinkTapDetails` |
| Image | `MarkdownImageTapDetails` |
| Heading | `MarkdownHeadingTapDetails` |

## Code
```dart
Markdown(
  data: markdown,
  onTapLinkDetails: (details) {},
  onTapImage: (details) {},
  onTapHeading: (details) {},
)
```
''';

  static const String _themeMarkdown = '''# Theme Override

## Editorial Styling
This preview uses a warmer palette and heavier heading hierarchy while keeping the same parser output.

> Quotes, tables, code fences, and details all inherit from the same theme object.

| Surface | Color |
| :-- | :-- |
| Quote | Warm amber |
| Code | Sand background |
| Table | Muted border |

```dart
const markdownTheme = MarkdownTheme(
  quoteBorderColor: Color(0xFFD97706),
);
```
''';

  static const String _customRenderMarkdown = '''# Custom Block Builder

## This heading is replaced
Use `blockBuilder` to intercept parsed markdown and HTML-origin blocks.

<button data-variant="primary" data-label="Launch action">
  Launch action
</button>

### This heading wraps the default widget
You can call `details.buildDefault()` and place it inside your own layout.

Normal paragraphs still fall back to the built-in renderer.
''';

  static const String _sanitizationMarkdown = '''# HTML Sanitization

<div class="callout" onclick="alert('clicked')">
  <strong>Inline HTML</strong> can still be rendered when the strategy allows it.
</div>

<script>alert('remove-me')</script>

Unsafe HTML link: <a href="javascript:alert('xss')">blocked link</a>

Safe HTML link: <a href="https://flutter.dev">Flutter docs</a>

Regular markdown still works:
- **bold**
- `inline code`
''';

  static const String _editingSeedMarkdown = '''# Editing Helpers

Select some text and use the helper buttons below.

- Turn lines into lists
- Wrap a code fence
- Insert links and images
''';

  static const String _chatBubbleMarkdown = '''### Table Inside A Bubble

| Capability | Behavior | Notes |
| :-- | :--: | --: |
| Parsing | stable | shared renderer |
| Width | adaptive | compact cells |
| Theme | dedicated | bubble preset |

Use [links](https://flutter.dev) and `inline code` without the table feeling oversized.
''';

  static const List<String> _partStream = [
    '# Streaming Markdown\n\n',
    'The assistant is thinking...\n\n',
    'Streaming tokens into the UI in real time.\n\n',
    '## Why it feels smooth\n- Stable committed prefix\n- Animated incoming tail only\n- Layout animation reduces jumps\n',
  ];

  late final m.TextEditingController _filePathController;
  late final MarkdownEditingController _editorController;
  late final m.FocusNode _editorFocusNode;

  Timer? _timer;
  _StreamMode _streamMode = _StreamMode.character;
  _AnimationKind _animation = _AnimationKind.fade;
  MarkdownHtmlSanitizationStrategy _sanitizationStrategy =
      MarkdownHtmlSanitizationStrategy.stripDangerousHtml;
  double _speed = 1.0;
  String _streamed = '';
  int _cursor = 0;
  String _filePath = _showcaseFilePath;
  String? _showcaseMarkdown;
  Object? _showcaseError;
  MarkdownDocumentMetrics? _showcaseMetrics;
  MarkdownDocumentMetrics? _fullPageMetrics;
  MarkdownDocumentMetrics? _interactionMetrics;
  MarkdownDocumentMetrics? _fileMetrics;
  List<String> _interactionLog = const <String>[];

  @override
  void initState() {
    super.initState();
    _filePathController = m.TextEditingController(text: _filePath);
    _editorController = MarkdownEditingController(text: _editingSeedMarkdown)
      ..addListener(_handleEditorChanged);
    _editorFocusNode = m.FocusNode();
    _loadShowcaseAsset();
    _restartStreaming();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _editorController.removeListener(_handleEditorChanged);
    _editorController.dispose();
    _editorFocusNode.dispose();
    _filePathController.dispose();
    super.dispose();
  }

  void _handleEditorChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _restartStreaming() {
    _timer?.cancel();
    setState(() {
      _streamed = '';
      _cursor = 0;
    });

    final units = _streamUnits(_streamMode, _inlineMarkdown);
    final ms = (220 / _speed).clamp(50, 600).round();
    _timer = Timer.periodic(Duration(milliseconds: ms), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_cursor >= units.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _streamed = '$_streamed${units[_cursor]}';
        _cursor += 1;
      });
    });
  }

  Future<void> _loadShowcaseAsset() async {
    const candidates = <String>[
      _showcaseAssetPath,
      'packages/flutter_shadcn_kit/assets/markdown/markdown_feature_showcase.md',
    ];
    Object? lastError;
    for (final key in candidates) {
      try {
        final data = await rootBundle.loadString(key);
        if (!mounted) {
          return;
        }
        setState(() {
          _showcaseMarkdown = data;
          _showcaseError = null;
        });
        return;
      } catch (error) {
        lastError = error;
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _showcaseMarkdown = null;
      _showcaseError = lastError;
    });
  }

  List<String> _streamUnits(_StreamMode mode, String input) {
    switch (mode) {
      case _StreamMode.character:
        return input.split('');
      case _StreamMode.word:
        return RegExp(r'\S+\s*|\n')
            .allMatches(input)
            .map((match) => match.group(0)!)
            .toList(growable: false);
      case _StreamMode.chunk:
        const size = 18;
        final chunks = <String>[];
        for (var i = 0; i < input.length; i += size) {
          chunks.add(input.substring(i, (i + size).clamp(0, input.length)));
        }
        return chunks;
      case _StreamMode.part:
        return _partStream;
    }
  }

  ta.StreamingTextEffectAdapter _effectForSelection() {
    final durationMs = (300 / _speed).clamp(120, 480).round();
    return switch (_animation) {
      _AnimationKind.blur => ta.BlurInEffect(
        duration: Duration(milliseconds: durationMs),
        maxBlurSigma: 12,
        fadeIn: true,
        slideUpPx: 2,
      ),
      _AnimationKind.fade => ta.FadeInEffect(
        duration: Duration(milliseconds: durationMs),
      ),
      _AnimationKind.slide => ta.SlideInEffect(
        duration: Duration(milliseconds: durationMs),
        offsetY: 8,
      ),
      _AnimationKind.scramble => ta.ScrambleInEffect(
        duration: Duration(milliseconds: durationMs),
      ),
    };
  }

  double _viewportHeight(
    m.BuildContext context, {
    double factor = 0.56,
    double min = 300,
    double max = 620,
  }) {
    final height = m.MediaQuery.sizeOf(context).height * factor;
    return height.clamp(min, max).toDouble();
  }

  void _recordInteraction(String message) {
    final now = DateTime.now();
    final stamp =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    setState(() {
      _interactionLog = <String>[
        '[$stamp] $message',
        ..._interactionLog,
      ].take(10).toList(growable: false);
    });
  }

  bool _sameMetrics(
    MarkdownDocumentMetrics? current,
    MarkdownDocumentMetrics next,
  ) {
    return current?.blockCount == next.blockCount &&
        current?.chunkCount == next.chunkCount &&
        current?.headingCount == next.headingCount &&
        current?.imageCount == next.imageCount &&
        current?.tableCount == next.tableCount;
  }

  void _setShowcaseMetrics(MarkdownDocumentMetrics metrics) {
    if (_sameMetrics(_showcaseMetrics, metrics)) {
      return;
    }
    setState(() => _showcaseMetrics = metrics);
  }

  void _setInteractionMetrics(MarkdownDocumentMetrics metrics) {
    if (_sameMetrics(_interactionMetrics, metrics)) {
      return;
    }
    setState(() => _interactionMetrics = metrics);
  }

  void _setFullPageMetrics(MarkdownDocumentMetrics metrics) {
    if (_sameMetrics(_fullPageMetrics, metrics)) {
      return;
    }
    setState(() => _fullPageMetrics = metrics);
  }

  void _setFileMetrics(MarkdownDocumentMetrics metrics) {
    if (_sameMetrics(_fileMetrics, metrics)) {
      return;
    }
    setState(() => _fileMetrics = metrics);
  }

  Future<void> _openFullPageShowcase() async {
    final data = _showcaseMarkdown ?? _inlineMarkdown;
    await m.Navigator.of(context).push<void>(
      m.MaterialPageRoute<void>(
        builder: (routeContext) {
          return _MarkdownFullPageDemo(
            data: data,
            imageBuilder: _previewImageBuilder,
            onTapLinkDetails: _handleLinkTap,
            onTapImage: _handleImageTap,
            onTapHeading: _handleHeadingTap,
            onTapElement: _handleElementTap,
            onDocumentReady: _setFullPageMetrics,
          );
        },
      ),
    );
  }

  void _handleLinkTap(MarkdownLinkTapDetails details) {
    final kind = switch (details.kind) {
      MarkdownLinkKind.anchor => 'anchor',
      MarkdownLinkKind.email => 'email',
      MarkdownLinkKind.external => 'external',
      MarkdownLinkKind.relative => 'relative',
    };
    _recordInteraction('link[$kind] ${details.url}');
  }

  void _handleImageTap(MarkdownImageTapDetails details) {
    final label = details.alt.isNotEmpty ? details.alt : details.url;
    _recordInteraction('image $label');
  }

  void _handleHeadingTap(MarkdownHeadingTapDetails details) {
    _recordInteraction('heading h${details.level} #${details.anchor}');
  }

  void _handleElementTap(MarkdownTapElementDetails details) {
    final location = details.isTableCell
        ? ' r${details.tableRow}c${details.tableColumn}'
        : '';
    final label = details.url ?? details.anchor ?? details.text;
    _recordInteraction('element[${details.kind.name}]$location $label');
  }

  m.Widget _buildEditingPreviewStatus(
    m.BuildContext context,
    MarkdownLivePreviewStateDetails details,
  ) {
    final label = details.error != null
        ? 'Preview held on last valid parse'
        : details.isValidating
        ? 'Validating markdown...'
        : details.hasPendingChanges
        ? 'Pending update'
        : 'Preview synced';
    final color = details.error != null
        ? const m.Color(0xFF7F1D1D)
        : details.hasPendingChanges || details.isValidating
        ? const m.Color(0xFF1D4ED8)
        : const m.Color(0xFF166534);

    return m.Align(
      alignment: m.Alignment.topRight,
      child: m.Padding(
        padding: const m.EdgeInsets.all(10),
        child: m.Container(
          padding: const m.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: m.BoxDecoration(
            color: color.withValues(alpha: 0.92),
            borderRadius: m.BorderRadius.circular(999),
          ),
          child: m.Text(
            label,
            style: const m.TextStyle(
              color: m.Color(0xFFF8FAFC),
              fontSize: 11,
              fontWeight: m.FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  m.Widget _buildCustomEditingBarButton(
    m.BuildContext context,
    MarkdownEditingBarItemDetails details,
  ) {
    if (details.action.id == '__divider__') {
      return const m.SizedBox(width: 2);
    }
    return m.IconButton.filledTonal(
      onPressed: details.enabled
          ? () {
              details.action.onPressed(context, details.controller);
              _editorFocusNode.requestFocus();
            }
          : null,
      tooltip: details.action.tooltip,
      style: m.IconButton.styleFrom(
        backgroundColor: const m.Color(0xFFF1F5F9),
        foregroundColor: const m.Color(0xFF0F172A),
        disabledBackgroundColor: const m.Color(0xFFF8FAFC),
        disabledForegroundColor: const m.Color(0xFF94A3B8),
      ),
      icon: m.Icon(details.action.icon, size: 18),
    );
  }

  m.Widget _buildEditingHelpersDemo() {
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: [
        const m.Text(
          'The editing bar is a reusable widget, not just a preview helper. It works with a history-aware `MarkdownEditingController`, supports custom action lists, and the live preview only swaps to newly validated markdown so broken intermediate edits do not churn the renderer.',
        ),
        const m.SizedBox(height: 10),
        MarkdownEditingBar(
          controller: _editorController,
          focusNode: _editorFocusNode,
        ),
        const m.SizedBox(height: 12),
        m.Row(
          children: [
            const m.Text(
              'Custom bar skin',
              style: m.TextStyle(fontWeight: m.FontWeight.w700),
            ),
            const m.SizedBox(width: 10),
            m.Expanded(
              child: MarkdownEditingBar(
                controller: _editorController,
                focusNode: _editorFocusNode,
                backgroundColor: const m.Color(0xFFFFFFFF),
                borderColor: const m.Color(0x220F172A),
                actions: <MarkdownEditingBarAction>[
                  MarkdownEditingBarAction.undo(),
                  MarkdownEditingBarAction.redo(),
                  MarkdownEditingBarAction.divider(),
                  MarkdownEditingBarAction.bold(),
                  MarkdownEditingBarAction.italic(),
                  MarkdownEditingBarAction.link(),
                  MarkdownEditingBarAction.image(),
                ],
                itemBuilder: _buildCustomEditingBarButton,
              ),
            ),
          ],
        ),
        const m.SizedBox(height: 12),
        m.TextField(
          controller: _editorController,
          focusNode: _editorFocusNode,
          maxLines: 10,
          minLines: 10,
          decoration: const m.InputDecoration(
            labelText: 'Markdown source',
            alignLabelWithHint: true,
            border: m.OutlineInputBorder(),
          ),
          style: const m.TextStyle(fontFamily: 'GeistMono', fontSize: 13),
        ),
        const m.SizedBox(height: 12),
        _surface(
          _markdownViewport(
            context: context,
            factor: 0.38,
            min: 220,
            max: 340,
            child: MarkdownLivePreview(
              controller: _editorController,
              selectable: true,
              shrinkWrap: false,
              followLinks: true,
              viewportStorageId: 'preview-editing-helpers',
              imageBuilder: _previewImageBuilder,
              statusBuilder: _buildEditingPreviewStatus,
            ),
          ),
        ),
      ],
    );
  }

  m.Widget _buildSanitizationDemo() {
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: [
        const m.Text(
          'Switch between sanitization modes to see how raw HTML is handled before parsing. Dangerous tags and unsafe URLs are stripped by default.',
        ),
        const m.SizedBox(height: 10),
        _choiceRow<MarkdownHtmlSanitizationStrategy>(
          label: 'Sanitization strategy',
          values: MarkdownHtmlSanitizationStrategy.values,
          current: _sanitizationStrategy,
          text: (value) => switch (value) {
            MarkdownHtmlSanitizationStrategy.permissive => 'Permissive',
            MarkdownHtmlSanitizationStrategy.stripDangerousHtml =>
              'Strip dangerous',
            MarkdownHtmlSanitizationStrategy.stripAllHtml => 'Strip all HTML',
          },
          onSelect: (value) => setState(() => _sanitizationStrategy = value),
        ),
        const m.SizedBox(height: 12),
        m.LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 760;
            final sourceCard = _surface(
              m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  const m.Text(
                    'Source markdown',
                    style: m.TextStyle(fontWeight: m.FontWeight.w700),
                  ),
                  const m.SizedBox(height: 8),
                  m.SelectableText(
                    _sanitizationMarkdown,
                    style: const m.TextStyle(
                      fontFamily: 'GeistMono',
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            );
            final renderedCard = _surface(
              _markdownViewport(
                context: context,
                factor: 0.34,
                min: 220,
                max: 320,
                child: Markdown(
                  data: _sanitizationMarkdown,
                  selectable: true,
                  shrinkWrap: false,
                  followLinks: true,
                  viewportStorageId:
                      'preview-sanitization-${_sanitizationStrategy.name}',
                  imageBuilder: _previewImageBuilder,
                  htmlSanitizationStrategy: _sanitizationStrategy,
                  onTapLinkDetails: _handleLinkTap,
                  onTapElement: _handleElementTap,
                ),
              ),
            );
            if (stacked) {
              return m.Column(
                children: [
                  sourceCard,
                  const m.SizedBox(height: 12),
                  renderedCard,
                ],
              );
            }
            return m.Row(
              crossAxisAlignment: m.CrossAxisAlignment.start,
              children: [
                m.Expanded(child: sourceCard),
                const m.SizedBox(width: 12),
                m.Expanded(child: renderedCard),
              ],
            );
          },
        ),
      ],
    );
  }

  m.Widget _buildChatBubbleDemo() {
    m.Widget bubble({
      required bool outgoing,
      required m.Color color,
      required String storageId,
    }) {
      return ChatBubble(
        widthFactor: 0.88,
        color: color,
        alignment: outgoing
            ? AxisAlignmentDirectional.end
            : AxisAlignmentDirectional.start,
        child: shadcn.ComponentTheme(
          data: MarkdownTheme.chatBubbleDefaults(
            m.TextStyle(
              fontSize: 14,
              color: outgoing
                  ? const m.Color(0xFFF8FAFC)
                  : const m.Color(0xFF0F172A),
            ),
            isOutgoing: outgoing,
          ),
          child: Markdown(
            data: _chatBubbleMarkdown,
            selectable: true,
            followLinks: true,
            viewportStorageId: storageId,
            imageBuilder: _previewImageBuilder,
          ),
        ),
      );
    }

    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: [
        const m.Text(
          'Use `MarkdownTheme.chatBubbleDefaults(...)` when markdown is rendered inside constrained message surfaces. It tightens table spacing and adjusts contrast for incoming and outgoing bubbles.',
        ),
        const m.SizedBox(height: 12),
        _surface(
          m.Column(
            children: [
              bubble(
                outgoing: false,
                color: const m.Color(0xFFF8FAFC),
                storageId: 'preview-chat-bubble-incoming',
              ),
              const m.SizedBox(height: 12),
              bubble(
                outgoing: true,
                color: const m.Color(0xFF0F172A),
                storageId: 'preview-chat-bubble-outgoing',
              ),
            ],
          ),
        ),
      ],
    );
  }

  m.Widget _previewImageBuilder(
    m.BuildContext context,
    String url,
    String alt,
  ) {
    return m.Container(
      width: double.infinity,
      constraints: const m.BoxConstraints(minHeight: 160),
      decoration: m.BoxDecoration(
        borderRadius: m.BorderRadius.circular(12),
        gradient: const m.LinearGradient(
          colors: <m.Color>[m.Color(0xFFF6F4EF), m.Color(0xFFE9E0D0)],
          begin: m.Alignment.topLeft,
          end: m.Alignment.bottomRight,
        ),
        border: m.Border.all(color: const m.Color(0x22000000)),
      ),
      padding: const m.EdgeInsets.all(16),
      child: m.Column(
        mainAxisAlignment: m.MainAxisAlignment.center,
        crossAxisAlignment: m.CrossAxisAlignment.center,
        children: [
          const m.Icon(m.Icons.image_outlined, size: 28),
          const m.SizedBox(height: 8),
          m.Text(
            alt.isNotEmpty ? alt : 'Preview image',
            textAlign: m.TextAlign.center,
            style: const m.TextStyle(fontWeight: m.FontWeight.w700),
          ),
          const m.SizedBox(height: 4),
          m.Text(
            url,
            maxLines: 2,
            overflow: m.TextOverflow.ellipsis,
            textAlign: m.TextAlign.center,
            style: const m.TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  m.Widget _buildCustomRendererDemo() {
    return Markdown(
      data: _customRenderMarkdown,
      selectable: true,
      shrinkWrap: false,
      followLinks: true,
      viewportStorageId: 'preview-custom-builder',
      onTapLinkDetails: _handleLinkTap,
      onTapImage: _handleImageTap,
      onTapHeading: _handleHeadingTap,
      onTapElement: _handleElementTap,
      blockBuilder: (context, details) {
        if (details.kind == MarkdownBlockKind.heading &&
            details.headingLevel == 2) {
          return m.Container(
            width: double.infinity,
            margin: const m.EdgeInsets.symmetric(vertical: 4),
            padding: const m.EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: m.BoxDecoration(
              borderRadius: m.BorderRadius.circular(12),
              color: const m.Color(0xFF101828),
            ),
            child: m.Text(
              'Custom heading widget: ${details.text}',
              style: const m.TextStyle(
                color: m.Color(0xFFF8FAFC),
                fontWeight: m.FontWeight.w800,
                fontSize: 18,
              ),
            ),
          );
        }

        if (details.kind == MarkdownBlockKind.heading &&
            details.headingLevel == 3) {
          return m.Container(
            margin: const m.EdgeInsets.symmetric(vertical: 4),
            padding: const m.EdgeInsets.all(10),
            decoration: m.BoxDecoration(
              border: m.Border.all(color: const m.Color(0x22000000)),
              borderRadius: m.BorderRadius.circular(12),
            ),
            child: details.buildDefault(),
          );
        }

        if (details.htmlTag == 'button') {
          return m.Padding(
            padding: const m.EdgeInsets.symmetric(vertical: 8),
            child: m.FilledButton.icon(
              onPressed: () {
                _recordInteraction(
                  'custom-button ${details.htmlAttributes['data-label'] ?? details.text}',
                );
              },
              icon: const m.Icon(m.Icons.smart_button_outlined),
              label: m.Text(
                details.htmlAttributes['data-label'] ?? details.text.trim(),
              ),
            ),
          );
        }

        return null;
      },
    );
  }

  m.Widget _metricChip(String label, String value) {
    return m.Container(
      padding: const m.EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: m.BoxDecoration(
        color: const m.Color(0x11000000),
        borderRadius: m.BorderRadius.circular(999),
        border: m.Border.all(color: const m.Color(0x22000000)),
      ),
      child: m.Text(
        '$label: $value',
        style: const m.TextStyle(fontSize: 12, fontWeight: m.FontWeight.w600),
      ),
    );
  }

  m.Widget _metricsBar(MarkdownDocumentMetrics? metrics) {
    if (metrics == null) {
      return const m.Text(
        'Waiting for document metrics...',
        style: m.TextStyle(fontSize: 12),
      );
    }
    return m.Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _metricChip('Blocks', '${metrics.blockCount}'),
        _metricChip('Chunks', '${metrics.chunkCount}'),
        _metricChip('Headings', '${metrics.headingCount}'),
        _metricChip('Tables', '${metrics.tableCount}'),
        _metricChip('Images', '${metrics.imageCount}'),
      ],
    );
  }

  m.Widget _interactionLogCard() {
    return m.Container(
      width: double.infinity,
      padding: const m.EdgeInsets.all(14),
      decoration: m.BoxDecoration(
        border: m.Border.all(color: const m.Color(0x22000000)),
        borderRadius: m.BorderRadius.circular(12),
        color: const m.Color(0x08000000),
      ),
      child: m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children: [
          const m.Text(
            'Interaction log',
            style: m.TextStyle(fontWeight: m.FontWeight.w700),
          ),
          const m.SizedBox(height: 8),
          if (_interactionLog.isEmpty)
            const m.Text(
              'Tap links, headings, images, table cells, or plain markdown blocks below to inspect callback payloads.',
              style: m.TextStyle(fontSize: 12),
            )
          else
            for (final entry in _interactionLog)
              m.Padding(
                padding: const m.EdgeInsets.only(bottom: 6),
                child: m.Text(
                  entry,
                  style: const m.TextStyle(
                    fontSize: 12,
                    fontFamily: 'GeistMono',
                  ),
                ),
              ),
        ],
      ),
    );
  }

  m.Widget _markdownViewport({
    required m.BuildContext context,
    required m.Widget child,
    double factor = 0.56,
    double min = 300,
    double max = 620,
  }) {
    return m.Container(
      decoration: m.BoxDecoration(
        borderRadius: m.BorderRadius.circular(12),
        color: const m.Color(0x05000000),
      ),
      clipBehavior: m.Clip.antiAlias,
      child: m.SizedBox(
        height: _viewportHeight(context, factor: factor, min: min, max: max),
        child: child,
      ),
    );
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Align(
        alignment: m.Alignment.topCenter,
        child: m.ConstrainedBox(
          constraints: const m.BoxConstraints(maxWidth: 980),
          child: m.ListView(
            padding: const m.EdgeInsets.all(20),
            children: [
              const m.Text(
                'Markdown (Advanced + Streaming)',
                style: m.TextStyle(fontSize: 20, fontWeight: m.FontWeight.w700),
              ),
              const m.SizedBox(height: 10),
              const m.Text(
                'Large previews still run in bounded viewports so the markdown widget can virtualize chunks, but the content is selectable again and links now follow their default navigation behavior while the hooks observe those taps.',
              ),
              const m.SizedBox(height: 20),
              _sectionCard(
                title: 'Streaming Example (Comprehensive)',
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    _choiceRow<_StreamMode>(
                      label: 'Stream mode',
                      values: _StreamMode.values,
                      current: _streamMode,
                      text: (value) => switch (value) {
                        _StreamMode.character => 'Character by Character',
                        _StreamMode.word => 'Word by Word',
                        _StreamMode.chunk => 'Chunk-by-Chunk',
                        _StreamMode.part => 'Part stream',
                      },
                      onSelect: (value) {
                        setState(() => _streamMode = value);
                        _restartStreaming();
                      },
                    ),
                    const m.SizedBox(height: 10),
                    _choiceRow<_AnimationKind>(
                      label: 'Animation',
                      values: _AnimationKind.values,
                      current: _animation,
                      text: (value) => switch (value) {
                        _AnimationKind.blur => 'Blur',
                        _AnimationKind.fade => 'Fade',
                        _AnimationKind.slide => 'Slide',
                        _AnimationKind.scramble => 'Scramble',
                      },
                      onSelect: (value) => setState(() => _animation = value),
                    ),
                    const m.SizedBox(height: 10),
                    const m.Text('Universal speed'),
                    m.Slider(
                      min: 0.4,
                      max: 2.0,
                      divisions: 16,
                      value: _speed,
                      label: _speed.toStringAsFixed(2),
                      onChanged: (value) => setState(() => _speed = value),
                      onChangeEnd: (_) => _restartStreaming(),
                    ),
                    const m.SizedBox(height: 10),
                    m.Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        m.FilledButton(
                          onPressed: _restartStreaming,
                          child: const m.Text('Restart stream'),
                        ),
                        m.OutlinedButton(
                          onPressed: () =>
                              setState(() => _streamed = _inlineMarkdown),
                          child: const m.Text('Show final markdown'),
                        ),
                      ],
                    ),
                    const m.SizedBox(height: 12),
                    _surface(
                      Markdown(
                        data: _streamed,
                        selectable: true,
                        followLinks: true,
                        viewportStorageId: 'preview-streaming',
                        imageBuilder: _previewImageBuilder,
                        onTapLinkDetails: _handleLinkTap,
                        onTapImage: _handleImageTap,
                        onTapHeading: _handleHeadingTap,
                        onTapElement: _handleElementTap,
                      ).withTextStreaming(
                        typewriter: const ta.TypewriterEffect(enabled: false),
                        effect: _effectForSelection(),
                        animateByWord: _streamMode == _StreamMode.word,
                      ),
                    ),
                  ],
                ),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Comprehensive Feature Showcase (Bundled Asset)',
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    const m.Text(
                      'This is the heavy document. It stays bounded so scrolling uses lazy chunks, but the text remains selectable.',
                    ),
                    const m.SizedBox(height: 10),
                    _metricsBar(_showcaseMetrics),
                    const m.SizedBox(height: 10),
                    _surface(
                      _markdownViewport(
                        context: context,
                        child: _buildShowcaseContent(),
                      ),
                    ),
                  ],
                ),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Full-Page Website Layout (No Fixed Height)',
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    const m.Text(
                      'This demo opens markdown in a full page route with no fixed viewport height. It uses virtualized chunk rendering (`shrinkWrap: false`) so large pages stay smoother while scrolling.',
                    ),
                    const m.SizedBox(height: 10),
                    _metricsBar(_fullPageMetrics),
                    const m.SizedBox(height: 10),
                    m.Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        m.FilledButton.icon(
                          onPressed: _openFullPageShowcase,
                          icon: const m.Icon(m.Icons.open_in_new_rounded),
                          label: const m.Text('Open full-page markdown demo'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Theme Override Example',
                child: _surface(
                  _markdownViewport(
                    context: context,
                    factor: 0.4,
                    min: 220,
                    max: 360,
                    child: shadcn.ComponentTheme(
                      data: const MarkdownTheme(
                        style: m.TextStyle(
                          fontFamily: 'GeistSans',
                          height: 1.55,
                          color: m.Color(0xFF2B1B10),
                        ),
                        linkStyle: m.TextStyle(
                          color: m.Color(0xFF0E7490),
                          decoration: m.TextDecoration.underline,
                          fontWeight: m.FontWeight.w600,
                        ),
                        codeBackgroundColor: m.Color(0xFFF5EEE2),
                        quoteBorderColor: m.Color(0xFFD97706),
                        quoteBackgroundColor: m.Color(0xFFFFFBEB),
                        tableBorderColor: m.Color(0xFFD6C5AB),
                        tableHeaderBackgroundColor: m.Color(0xFFF5EEE2),
                        detailsBorderColor: m.Color(0xFFD6C5AB),
                        detailsBackgroundColor: m.Color(0xFFFFFBEB),
                        horizontalRuleColor: m.Color(0xFFD6C5AB),
                        codeRadius: m.BorderRadius.all(m.Radius.circular(14)),
                        tableRadius: m.BorderRadius.all(m.Radius.circular(14)),
                        detailsRadius: m.BorderRadius.all(
                          m.Radius.circular(14),
                        ),
                        imageMaxHeight: 220,
                        listIndent: 20,
                        heading1Style: m.TextStyle(
                          fontSize: 31,
                          fontWeight: m.FontWeight.w800,
                          color: m.Color(0xFF7C2D12),
                        ),
                        heading2Style: m.TextStyle(
                          fontSize: 26,
                          fontWeight: m.FontWeight.w800,
                          color: m.Color(0xFF9A3412),
                        ),
                      ),
                      child: Markdown(
                        data: _themeMarkdown,
                        selectable: true,
                        shrinkWrap: false,
                        followLinks: true,
                        viewportStorageId: 'preview-theme',
                        imageBuilder: _previewImageBuilder,
                        onTapLinkDetails: _handleLinkTap,
                        onTapImage: _handleImageTap,
                        onTapHeading: _handleHeadingTap,
                        onTapElement: _handleElementTap,
                      ),
                    ),
                  ),
                ),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Sanitization Modes',
                child: _buildSanitizationDemo(),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Editing Helpers',
                child: _buildEditingHelpersDemo(),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Interaction Hooks',
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    const m.Text(
                      'Links open normally, anchors still jump inside the same markdown view, and both the specific hooks and the generic element hook are logged.',
                    ),
                    const m.SizedBox(height: 10),
                    _metricsBar(_interactionMetrics),
                    const m.SizedBox(height: 10),
                    _surface(
                      _markdownViewport(
                        context: context,
                        factor: 0.44,
                        min: 260,
                        max: 420,
                        child: Markdown(
                          data: _interactionMarkdown,
                          selectable: true,
                          shrinkWrap: false,
                          followLinks: true,
                          viewportStorageId: 'preview-interaction',
                          imageBuilder: _previewImageBuilder,
                          onTapLinkDetails: _handleLinkTap,
                          onTapImage: _handleImageTap,
                          onTapHeading: _handleHeadingTap,
                          onTapElement: _handleElementTap,
                          onDocumentReady: _setInteractionMetrics,
                        ),
                      ),
                    ),
                    const m.SizedBox(height: 10),
                    _interactionLogCard(),
                  ],
                ),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Custom Widget Builder',
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    const m.Text(
                      'Use `blockBuilder` to replace or wrap specific parsed blocks. The demo below swaps an H2 with a custom banner, wraps an H3 around the default renderer, and turns a raw HTML `<button>` block into a real Flutter button.',
                    ),
                    const m.SizedBox(height: 10),
                    _surface(
                      _markdownViewport(
                        context: context,
                        factor: 0.42,
                        min: 260,
                        max: 380,
                        child: _buildCustomRendererDemo(),
                      ),
                    ),
                  ],
                ),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Chat Bubble Theme Preset',
                child: _buildChatBubbleDemo(),
              ),
              const m.SizedBox(height: 14),
              _sectionCard(
                title: 'Filesystem Markdown Source',
                child: m.Column(
                  crossAxisAlignment: m.CrossAxisAlignment.start,
                  children: [
                    if (f.kIsWeb)
                      const m.Padding(
                        padding: m.EdgeInsets.only(bottom: 8),
                        child: m.Text(
                          'Filesystem source is unsupported on web builds, so this panel stays disabled there.',
                        ),
                      ),
                    m.TextField(
                      controller: _filePathController,
                      decoration: const m.InputDecoration(
                        labelText: 'Absolute markdown file path',
                        border: m.OutlineInputBorder(),
                      ),
                    ),
                    const m.SizedBox(height: 10),
                    m.OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _filePath = _filePathController.text.trim();
                          _fileMetrics = null;
                        });
                      },
                      child: const m.Text('Load file markdown'),
                    ),
                    const m.SizedBox(height: 10),
                    _metricsBar(_fileMetrics),
                    const m.SizedBox(height: 10),
                    if (!f.kIsWeb)
                      _surface(
                        _markdownViewport(
                          context: context,
                          factor: 0.5,
                          min: 260,
                          max: 460,
                          child: Markdown.file(
                            key: m.ValueKey(_filePath),
                            path: _filePath,
                            selectable: true,
                            shrinkWrap: false,
                            followLinks: true,
                            viewportStorageId: 'preview-file:$_filePath',
                            imageBuilder: _previewImageBuilder,
                            onTapLinkDetails: _handleLinkTap,
                            onTapImage: _handleImageTap,
                            onTapHeading: _handleHeadingTap,
                            onTapElement: _handleElementTap,
                            onDocumentReady: _setFileMetrics,
                            errorBuilder: (context, error) =>
                                m.Text('File load error: $error'),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  m.Widget _surface(m.Widget child) {
    return m.Container(
      width: double.infinity,
      padding: const m.EdgeInsets.all(14),
      decoration: m.BoxDecoration(
        border: m.Border.all(color: const m.Color(0x22000000)),
        borderRadius: m.BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  m.Widget _sectionCard({required String title, required m.Widget child}) {
    return m.Container(
      width: double.infinity,
      padding: const m.EdgeInsets.all(14),
      decoration: m.BoxDecoration(
        border: m.Border.all(color: const m.Color(0x22000000)),
        borderRadius: m.BorderRadius.circular(12),
      ),
      child: m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children: [
          m.Text(
            title,
            style: const m.TextStyle(fontWeight: m.FontWeight.w700),
          ),
          const m.SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  m.Widget _buildShowcaseContent() {
    final data = _showcaseMarkdown;
    if (data != null) {
      return Markdown(
        data: data,
        selectable: true,
        shrinkWrap: false,
        followLinks: true,
        viewportStorageId: 'preview-showcase',
        imageBuilder: _previewImageBuilder,
        onTapLinkDetails: _handleLinkTap,
        onTapImage: _handleImageTap,
        onTapHeading: _handleHeadingTap,
        onTapElement: _handleElementTap,
        onDocumentReady: _setShowcaseMetrics,
      );
    }
    final error = _showcaseError;
    if (error != null) {
      return m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children: [
          m.Text('Showcase asset load error: $error'),
          const m.SizedBox(height: 8),
          m.OutlinedButton(
            onPressed: _loadShowcaseAsset,
            child: const m.Text('Retry loading showcase'),
          ),
        ],
      );
    }
    return const m.Padding(
      padding: m.EdgeInsets.symmetric(vertical: 16),
      child: m.Center(child: m.CircularProgressIndicator()),
    );
  }

  m.Widget _choiceRow<T>({
    required String label,
    required List<T> values,
    required T current,
    required String Function(T value) text,
    required void Function(T value) onSelect,
  }) {
    return m.Column(
      crossAxisAlignment: m.CrossAxisAlignment.start,
      children: [
        m.Text(label),
        const m.SizedBox(height: 6),
        m.Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              m.GestureDetector(
                onTap: () => onSelect(value),
                child: m.AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: m.Curves.easeOutCubic,
                  padding: const m.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: m.BoxDecoration(
                    borderRadius: m.BorderRadius.circular(999),
                    color: value == current
                        ? const m.Color(0x22000000)
                        : const m.Color(0x11000000),
                    border: m.Border.all(
                      color: value == current
                          ? const m.Color(0x66000000)
                          : const m.Color(0x33000000),
                    ),
                  ),
                  child: m.Text(
                    text(value),
                    style: const m.TextStyle(fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _MarkdownFullPageDemo extends m.StatelessWidget {
  const _MarkdownFullPageDemo({
    required this.data,
    required this.imageBuilder,
    required this.onTapLinkDetails,
    required this.onTapImage,
    required this.onTapHeading,
    required this.onTapElement,
    required this.onDocumentReady,
  });

  final String data;
  final m.Widget Function(m.BuildContext context, String url, String alt)
  imageBuilder;
  final MarkdownTapLinkDetailsCallback onTapLinkDetails;
  final MarkdownTapImageCallback onTapImage;
  final MarkdownTapHeadingCallback onTapHeading;
  final MarkdownTapElementCallback onTapElement;
  final MarkdownDocumentReadyCallback onDocumentReady;

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      appBar: m.AppBar(title: const m.Text('Markdown Full-Page Demo')),
      body: Markdown(
        data: data,
        selectable: true,
        shrinkWrap: false,
        followLinks: true,
        viewportStorageId: 'preview-full-page',
        imageBuilder: imageBuilder,
        onTapLinkDetails: onTapLinkDetails,
        onTapImage: onTapImage,
        onTapHeading: onTapHeading,
        onTapElement: onTapElement,
        onDocumentReady: onDocumentReady,
      ),
    );
  }
}
