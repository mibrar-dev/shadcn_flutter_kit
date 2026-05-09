// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

typedef MarkdownLivePreviewStatusBuilder =
    Widget? Function(
      BuildContext context,
      MarkdownLivePreviewStateDetails details,
    );

@immutable
class MarkdownLivePreviewStateDetails {
  const MarkdownLivePreviewStateDetails({
    required this.renderedText,
    required this.pendingText,
    required this.hasPendingChanges,
    required this.isValidating,
    this.error,
  });

  final String renderedText;
  final String pendingText;
  final bool hasPendingChanges;
  final bool isValidating;
  final Object? error;
}

class MarkdownLivePreview extends StatefulWidget {
  const MarkdownLivePreview({
    super.key,
    required this.controller,
    this.debounce = const Duration(milliseconds: 90),
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
    this.followLinks = true,
    this.htmlSanitizationStrategy =
        MarkdownHtmlSanitizationStrategy.stripDangerousHtml,
    this.imagePreviewBehavior = MarkdownImagePreviewBehavior.dialog,
    this.imagePreviewBuilder,
    this.imageBuilder,
    this.loading,
    this.errorBuilder,
    this.statusBuilder,
  });

  final MarkdownEditingController controller;
  final Duration debounce;
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
  final bool followLinks;
  final MarkdownHtmlSanitizationStrategy htmlSanitizationStrategy;
  final MarkdownImagePreviewBehavior imagePreviewBehavior;
  final MarkdownImagePreviewBuilder? imagePreviewBuilder;
  final Widget Function(BuildContext context, String url, String alt)?
  imageBuilder;
  final Widget? loading;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final MarkdownLivePreviewStatusBuilder? statusBuilder;

  @override
  State<MarkdownLivePreview> createState() => _MarkdownLivePreviewState();
}

class _MarkdownLivePreviewState extends State<MarkdownLivePreview> {
  Timer? _debounceTimer;
  int _validationGeneration = 0;
  late String _renderedText;
  bool _isValidating = false;
  Object? _lastError;

  @override
  void initState() {
    super.initState();
    _renderedText = widget.controller.text;
    widget.controller.addListener(_scheduleValidation);
    _scheduleValidation();
  }

  @override
  void didUpdateWidget(covariant MarkdownLivePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_scheduleValidation);
      _renderedText = widget.controller.text;
      widget.controller.addListener(_scheduleValidation);
    }
    if (oldWidget.htmlSanitizationStrategy != widget.htmlSanitizationStrategy ||
        oldWidget.debounce != widget.debounce ||
        oldWidget.controller != widget.controller) {
      _scheduleValidation();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.controller.removeListener(_scheduleValidation);
    super.dispose();
  }

  void _scheduleValidation() {
    _debounceTimer?.cancel();
    setState(() {
      _isValidating = true;
    });
    _debounceTimer = Timer(widget.debounce, _validateLatestText);
  }

  Future<void> _validateLatestText() async {
    final candidate = widget.controller.text;
    final generation = ++_validationGeneration;
    try {
      final sanitized = _sanitizeMarkdownHtml(
        candidate,
        widget.htmlSanitizationStrategy,
      );
      await _validateMarkdownPreviewDocument(sanitized);
      if (!mounted || generation != _validationGeneration) {
        return;
      }
      setState(() {
        _renderedText = candidate;
        _lastError = null;
        _isValidating = false;
      });
    } catch (error) {
      if (!mounted || generation != _validationGeneration) {
        return;
      }
      setState(() {
        _lastError = error;
        _isValidating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = MarkdownLivePreviewStateDetails(
      renderedText: _renderedText,
      pendingText: widget.controller.text,
      hasPendingChanges: widget.controller.text != _renderedText,
      isValidating: _isValidating,
      error: _lastError,
    );
    final status = widget.statusBuilder?.call(context, details);

    return Stack(
      children: <Widget>[
        Markdown(
          data: _renderedText,
          selectable: widget.selectable,
          style: widget.style,
          onTapLink: widget.onTapLink,
          onTapLinkDetails: widget.onTapLinkDetails,
          onTapImage: widget.onTapImage,
          onTapHeading: widget.onTapHeading,
          onTapElement: widget.onTapElement,
          blockBuilder: widget.blockBuilder,
          onDocumentReady: widget.onDocumentReady,
          viewportStorageId: widget.viewportStorageId,
          shrinkWrap: widget.shrinkWrap,
          followLinks: widget.followLinks,
          htmlSanitizationStrategy: widget.htmlSanitizationStrategy,
          imagePreviewBehavior: widget.imagePreviewBehavior,
          imagePreviewBuilder: widget.imagePreviewBuilder,
          imageBuilder: widget.imageBuilder,
          loading: widget.loading,
          errorBuilder: widget.errorBuilder,
        ),
        if (status != null)
          Positioned.fill(child: IgnorePointer(child: status)),
      ],
    );
  }
}

Future<void> _validateMarkdownPreviewDocument(String data) async {
  if (data.trim().isEmpty) {
    return;
  }
  if (kIsWeb || data.length < 8000) {
    await Future<void>.delayed(Duration.zero);
    _parseMarkdownDocument(data);
    return;
  }
  await compute(_parseMarkdownDocument, data);
}
