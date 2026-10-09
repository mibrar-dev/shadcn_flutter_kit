// The `text_animate` component: [TextAnimate] (streaming plain text) and
// [TextAnimateMarkdown] (streaming markdown, via `withTextStreaming`).
//
// New units animate while settled text stays put; the snapshot, ticker,
// reveal math and animation styles live in `primitives/streaming_text/` so
// both widgets tick identically. Under reduced motion everything renders
// settled immediately.

import 'package:flutter/widgets.dart';

import '../../primitives/markdown_parser/markdown_parser.dart';
import '../../primitives/streaming_text/streaming_text.dart';
import '../markdown/markdown.dart';
import 'text_animate_style.dart';

export 'text_animate_style.dart';

/// Stream-aware text renderer for incremental updates.
///
/// Pass each new revision of the full text as [text]: the shared prefix with
/// the previous revision stays settled and only the tail animates. A
/// non-append edit restarts the animation from scratch.
class TextAnimate extends StatefulWidget {
  const TextAnimate({
    super.key,
    required this.text,
    this.style,
    this.typewriter,
    this.animateByWord = false,
    this.effect,
    this.cursor,
    this.textAlign,
    this.smoothLayout = true,
    this.layoutAnimationDuration = const Duration(milliseconds: 180),
    this.layoutAnimationCurve = Curves.easeOutCubic,
    this.onSettled,
    this.theme,
  });

  /// Latest full text value received from the stream.
  final String text;

  /// Base style, merged over the theme style and the ambient default.
  final TextStyle? style;

  /// Reveal pacing; null falls back through the theme legs.
  final TextAnimateTypewriter? typewriter;

  /// Word units (with trailing whitespace) instead of characters.
  final bool animateByWord;

  /// Animation of newly revealed units; null falls back through the legs.
  final TextAnimateEffect? effect;

  /// Cursor; null falls back through the theme legs.
  final TextAnimateCursor? cursor;

  final TextAlign? textAlign;

  /// Smoothly animates height when wrapping changes the layout.
  final bool smoothLayout;

  /// Duration of the smooth layout height transition.
  final Duration layoutAnimationDuration;

  /// Curve of the smooth layout height transition.
  final Curve layoutAnimationCurve;

  /// Fired once per revision when it has fully settled.
  final TextAnimateSettled? onSettled;

  /// Widget-leg theme override, merged over the other legs.
  final TextAnimateTheme? theme;

  @override
  State<TextAnimate> createState() => _TextAnimateState();
}

class _TextAnimateState extends State<TextAnimate>
    with SingleTickerProviderStateMixin, StreamingClock<TextAnimate> {
  late StreamingSnapshot _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = StreamingSnapshot.initial(widget.text);
  }

  @override
  void didUpdateWidget(covariant TextAnimate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _snapshot = _snapshot.update(nextText: widget.text, now: streamingNow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts = resolveTextAnimateParts(
      context,
      widgetTheme: widget.theme,
      style: widget.style,
      typewriter: widget.typewriter,
      effect: widget.effect,
      cursor: widget.cursor,
    );
    final TextStyle base = parts.base;
    final TextAnimateTypewriter typewriter = parts.typewriter;
    final TextAnimateEffect effect = parts.effect;
    final TextAnimateCursor cursor = parts.cursor;
    final bool reduced = streamingReducedMotion;
    final List<String> animatedUnits = widget.animateByWord
        ? splitStreamingWords(_snapshot.animatedChars.join())
        : _snapshot.animatedChars;
    final int total = animatedUnits.length;
    final Duration elapsed = streamingNow - _snapshot.changedAt;
    final int visible = reduced
        ? total
        : streamingVisibleCount(
            total: total,
            elapsed: elapsed,
            enabled: typewriter.enabled,
            charsPerSecond: typewriter.charsPerSecond,
          );
    final spans = <InlineSpan>[];
    if (_snapshot.stableChars.isNotEmpty) {
      spans.add(TextSpan(text: _snapshot.stableChars.join(), style: base));
    }
    for (var i = 0; i < visible; i++) {
      spans.add(
        effect.buildSpan(
          char: animatedUnits[i],
          index: i,
          age: reduced
              ? effect.settleDuration
              : streamingUnitAge(
                  elapsed: elapsed,
                  index: i,
                  enabled: typewriter.enabled,
                  charsPerSecond: typewriter.charsPerSecond,
                ),
          baseStyle: base,
        ),
      );
    }
    final bool settled =
        reduced ||
        streamingIsSettled(
          elapsed: elapsed,
          totalAnimated: total,
          visibleAnimated: visible,
          typewriterEnabled: typewriter.enabled,
          charsPerSecond: typewriter.charsPerSecond,
          settleDuration: effect.settleDuration,
        );
    if (textAnimateCursorVisible(
      cursor: cursor,
      settled: settled,
      reduced: reduced,
      now: streamingNow,
    )) {
      spans.add(
        streamingCursorSpan(
          character: cursor.character,
          baseStyle: base,
          cursorStyle: cursor.style,
        ),
      );
    }
    syncStreamingTicker(
      visible < total ||
          (!settled && total > 0 && effect.settleDuration > Duration.zero) ||
          (cursor.enabled &&
              cursor.blink &&
              !reduced &&
              (!settled || cursor.showWhenSettled)),
    );
    notifyStreamingSettled(
      settled: settled,
      revision: _snapshot.revision,
      text: _snapshot.fullText,
      onSettled: widget.onSettled,
    );
    Widget current = RichText(
      text: TextSpan(style: base, children: spans),
      textAlign: widget.textAlign ?? TextAlign.start,
    );
    if (widget.smoothLayout && !reduced) {
      current = ClipRect(
        child: AnimatedSize(
          alignment: Alignment.topLeft,
          duration: widget.layoutAnimationDuration,
          curve: widget.layoutAnimationCurve,
          child: current,
        ),
      );
    }
    // One live label: screen readers hear the settled text once instead of
    // per-character rebuilds.
    return Semantics(
      label: _snapshot.fullText,
      textDirection: Directionality.of(context),
      excludeSemantics: true,
      child: current,
    );
  }
}

/// Streaming markdown: stable lines render settled while the unstable tail
/// re-renders with the reveal animation.
///
/// Built with `Markdown(...).withTextStreaming(...)`. The source stays a
/// plain `Markdown` value (copied per section), so taps, builders and styles
/// keep working mid-stream.
class TextAnimateMarkdown extends StatefulWidget {
  const TextAnimateMarkdown({
    super.key,
    required this.source,
    this.typewriter = const TextAnimateTypewriter(enabled: false),
    this.effect = const TextAnimateEffect.fade(
      duration: Duration(milliseconds: 220),
    ),
    this.animateByWord = false,
  });

  /// Base document; every rendered section copies it with new data.
  final Markdown source;

  /// Reveal pacing of the unstable tail.
  final TextAnimateTypewriter typewriter;

  /// Whole-block animation of the unstable tail.
  final TextAnimateEffect effect;

  /// Word units instead of characters for the tail reveal.
  final bool animateByWord;

  @override
  State<TextAnimateMarkdown> createState() => _TextAnimateMarkdownState();
}

class _TextAnimateMarkdownState extends State<TextAnimateMarkdown>
    with SingleTickerProviderStateMixin, StreamingClock<TextAnimateMarkdown> {
  final StreamingMarkdownSplit _split = StreamingMarkdownSplit(
    stableLengthOf: computeStableMarkdownPrefixLength,
  );
  final StreamingSectionCache _committed = StreamingSectionCache();
  final StreamingSectionCache _pending = StreamingSectionCache();

  @override
  void initState() {
    super.initState();
    _split.applyIncoming(
      widget.source.data,
      forceReset: true,
      animateByWord: widget.animateByWord,
      now: streamingNow,
    );
  }

  @override
  void didUpdateWidget(covariant TextAnimateMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool wordsChanged = oldWidget.animateByWord != widget.animateByWord;
    if (!_sameConfig(oldWidget.source, widget.source) || wordsChanged) {
      _committed.invalidate();
      _pending.invalidate();
    }
    if (oldWidget.source.data != widget.source.data || wordsChanged) {
      _split.applyIncoming(
        widget.source.data,
        forceReset: wordsChanged,
        animateByWord: widget.animateByWord,
        now: streamingNow,
      );
    }
  }

  /// Config fields forwarded into every rendered section; a change here
  /// invalidates the cached sections. Dropped old fields (`sourceType`,
  /// `followLinks`, `loading`, `errorBuilder`) no longer exist on `Markdown`.
  bool _sameConfig(Markdown a, Markdown b) {
    return a.selectable == b.selectable &&
        a.style == b.style &&
        a.onTapLink == b.onTapLink &&
        a.onTapLinkDetails == b.onTapLinkDetails &&
        a.onTapImage == b.onTapImage &&
        a.onTapHeading == b.onTapHeading &&
        a.onTapElement == b.onTapElement &&
        a.blockBuilder == b.blockBuilder &&
        a.onDocumentReady == b.onDocumentReady &&
        a.viewportStorageId == b.viewportStorageId &&
        a.shrinkWrap == b.shrinkWrap &&
        a.htmlSanitizationStrategy == b.htmlSanitizationStrategy &&
        a.imagePreviewBehavior == b.imagePreviewBehavior &&
        a.imagePreviewBuilder == b.imagePreviewBuilder &&
        a.imageBuilder == b.imageBuilder &&
        a.theme == b.theme;
  }

  @override
  Widget build(BuildContext context) {
    final bool reduced = streamingReducedMotion;
    final Duration elapsed = streamingNow - _split.changedAt;
    final int total = _split.animatedUnits.length;
    final int visible = reduced
        ? total
        : streamingVisibleCount(
            total: total,
            elapsed: elapsed,
            enabled: widget.typewriter.enabled,
            charsPerSecond: widget.typewriter.charsPerSecond,
          );
    final String visiblePending =
        '${_split.stableUnits.join()}${_split.animatedUnits.take(visible).join()}';
    final bool settled =
        reduced ||
        streamingIsSettled(
          elapsed: elapsed,
          totalAnimated: total,
          visibleAnimated: visible,
          typewriterEnabled: widget.typewriter.enabled,
          charsPerSecond: widget.typewriter.charsPerSecond,
          settleDuration: widget.effect.settleDuration,
        );
    syncStreamingTicker(
      !settled &&
          total > 0 &&
          (visible < total || widget.effect.settleDuration > Duration.zero),
    );
    final children = <Widget>[];
    if (_split.committed.isNotEmpty) {
      children.add(
        _committed.render(
          _split.committed,
          (data) => widget.source.copyWith(data: data),
        ),
      );
    }
    if (visiblePending.isNotEmpty) {
      final Widget tail = _pending.render(
        visiblePending,
        (data) => widget.source.copyWith(data: data, shrinkWrap: true),
      );
      children.add(
        reduced
            ? tail
            : animateStreamingBlock(
                effect: widget.effect,
                child: tail,
                age: streamingNewestAge(
                  elapsed: elapsed,
                  visible: visible,
                  enabled: widget.typewriter.enabled,
                  charsPerSecond: widget.typewriter.charsPerSecond,
                ),
              ),
      );
    }
    if (children.isEmpty) return widget.source;
    return Column(
      mainAxisSize: widget.source.shrinkWrap
          ? MainAxisSize.min
          : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

/// Streams a text-only `Markdown` document.
///
/// The stable prefix commits verbatim; the unstable tail reveals per
/// [typewriter] under [effect]. Asset/file sources are gone (read the content
/// yourself and stream the string), as are `followLinks` (use `onTapLink`
/// with `url_launcher`), `loading` and `errorBuilder`.
extension MarkdownStreamingExtension on Markdown {
  TextAnimateMarkdown withTextStreaming({
    TextAnimateTypewriter typewriter = const TextAnimateTypewriter(
      enabled: false,
    ),
    TextAnimateEffect effect = const TextAnimateEffect.fade(
      duration: Duration(milliseconds: 220),
    ),
    bool animateByWord = false,
  }) {
    return TextAnimateMarkdown(
      source: this,
      typewriter: typewriter,
      effect: effect,
      animateByWord: animateByWord,
    );
  }
}
