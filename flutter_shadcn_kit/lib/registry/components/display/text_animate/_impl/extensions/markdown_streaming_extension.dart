// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../markdown/markdown.dart' as md;
import '../../text_animate.dart';

extension MarkdownStreamingExtension on md.Markdown {
  Widget withTextStreaming({
    TypewriterEffect typewriter = const TypewriterEffect(enabled: false),
    StreamingTextEffectAdapter effect = const FadeInEffect(
      duration: Duration(milliseconds: 220),
    ),
    StreamingCursor cursor = const StreamingCursor.none(),
    bool animateByWord = false,
  }) {
    if (sourceType != md.MarkdownSourceType.text) {
      throw StateError(
        'withTextStreaming currently supports Markdown(data: ...) only. '
        'Resolve asset/file content first, then stream the text value.',
      );
    }
    return _StreamingMarkdownAdapter(
      source: this,
      typewriter: typewriter,
      effect: effect,
      cursor: cursor,
      animateByWord: animateByWord,
    );
  }
}

class _StreamingMarkdownAdapter extends StatefulWidget {
  const _StreamingMarkdownAdapter({
    required this.source,
    required this.typewriter,
    required this.effect,
    required this.cursor,
    required this.animateByWord,
  });

  final md.Markdown source;
  final TypewriterEffect typewriter;
  final StreamingTextEffectAdapter effect;
  final StreamingCursor cursor;
  final bool animateByWord;

  @override
  State<_StreamingMarkdownAdapter> createState() =>
      _StreamingMarkdownAdapterState();
}

class _StreamingMarkdownAdapterState extends State<_StreamingMarkdownAdapter> {
  static const Duration _frameInterval = Duration(milliseconds: 24);

  late final Stopwatch _clock;
  Timer? _ticker;

  String _sourceSnapshot = '';
  String _committedMarkdown = '';
  String _pendingMarkdown = '';
  List<String> _stableUnits = const <String>[];
  List<String> _animatedUnits = const <String>[];
  Duration _changedAt = Duration.zero;
  Widget? _cachedCommittedWidget;
  String _cachedCommittedData = '';
  Widget? _cachedPendingWidget;
  String _cachedPendingData = '';

  @override
  void initState() {
    super.initState();
    _clock = Stopwatch()..start();
    _applyIncoming(widget.source.data, forceReset: true);
  }

  @override
  void didUpdateWidget(covariant _StreamingMarkdownAdapter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source.selectable != widget.source.selectable ||
        oldWidget.source.style != widget.source.style ||
        oldWidget.source.onTapLink != widget.source.onTapLink ||
        oldWidget.source.onTapLinkDetails != widget.source.onTapLinkDetails ||
        oldWidget.source.onTapImage != widget.source.onTapImage ||
        oldWidget.source.onTapHeading != widget.source.onTapHeading ||
        oldWidget.source.onTapElement != widget.source.onTapElement ||
        oldWidget.source.blockBuilder != widget.source.blockBuilder ||
        oldWidget.source.onDocumentReady != widget.source.onDocumentReady ||
        oldWidget.source.viewportStorageId != widget.source.viewportStorageId ||
        oldWidget.source.followLinks != widget.source.followLinks ||
        oldWidget.source.htmlSanitizationStrategy !=
            widget.source.htmlSanitizationStrategy ||
        oldWidget.source.imagePreviewBehavior !=
            widget.source.imagePreviewBehavior ||
        oldWidget.source.imagePreviewBuilder !=
            widget.source.imagePreviewBuilder ||
        oldWidget.source.imageBuilder != widget.source.imageBuilder ||
        oldWidget.source.shrinkWrap != widget.source.shrinkWrap) {
      _clearRenderCache();
    }
    if (oldWidget.source.data != widget.source.data) {
      _applyIncoming(widget.source.data, forceReset: false);
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _clock.stop();
    super.dispose();
  }

  void _applyIncoming(String next, {required bool forceReset}) {
    if (forceReset ||
        _sourceSnapshot.isEmpty ||
        !next.startsWith(_sourceSnapshot)) {
      _sourceSnapshot = next;
      _committedMarkdown = '';
      _pendingMarkdown = next;
      _clearRenderCache();
      _promoteStablePrefix();
      _resetPendingAnimation();
      return;
    }

    final appended = next.substring(_sourceSnapshot.length);
    _sourceSnapshot = next;
    if (appended.isEmpty) {
      return;
    }

    final previousPending = _pendingMarkdown;
    _pendingMarkdown = '$_pendingMarkdown$appended';
    final promoted = _promoteStablePrefix();
    if (promoted > 0) {
      _resetPendingAnimation();
    } else {
      _updatePendingAnimation(previousPending);
    }
  }

  int _promoteStablePrefix() {
    final stableLength = md.computeStableMarkdownPrefixLength(_pendingMarkdown);
    if (stableLength <= 0) {
      return 0;
    }
    _committedMarkdown =
        '$_committedMarkdown${_pendingMarkdown.substring(0, stableLength)}';
    _pendingMarkdown = _pendingMarkdown.substring(stableLength);
    _cachedCommittedWidget = null;
    _cachedPendingWidget = null;
    return stableLength;
  }

  void _resetPendingAnimation() {
    _stableUnits = const <String>[];
    _animatedUnits = _splitUnits(_pendingMarkdown);
    _changedAt = _clock.elapsed;
    _cachedPendingWidget = null;
  }

  void _updatePendingAnimation(String previousPending) {
    final previousUnits = _splitUnits(previousPending);
    final nextUnits = _splitUnits(_pendingMarkdown);
    final shared = _sharedPrefixLength(previousUnits, nextUnits);
    _stableUnits = List<String>.unmodifiable(nextUnits.take(shared));
    _animatedUnits = List<String>.unmodifiable(nextUnits.skip(shared));
    _changedAt = _clock.elapsed;
    _cachedPendingWidget = null;
  }

  void _clearRenderCache() {
    _cachedCommittedWidget = null;
    _cachedCommittedData = '';
    _cachedPendingWidget = null;
    _cachedPendingData = '';
  }

  List<String> _splitUnits(String value) {
    if (value.isEmpty) {
      return const <String>[];
    }
    if (widget.animateByWord) {
      return List<String>.unmodifiable(
        RegExp(r'\S+\s*|\s+')
            .allMatches(value)
            .map((match) => match.group(0)!)
            .where((value) => value.isNotEmpty),
      );
    }
    return List<String>.unmodifiable(
      value.runes.map((rune) => String.fromCharCode(rune)),
    );
  }

  int _sharedPrefixLength(List<String> previous, List<String> next) {
    final limit = previous.length < next.length ? previous.length : next.length;
    var index = 0;
    while (index < limit && previous[index] == next[index]) {
      index += 1;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _clock.elapsed - _changedAt;
    final totalAnimated = _animatedUnits.length;
    final visibleAnimated = _visibleUnitCount(
      total: totalAnimated,
      elapsed: elapsed,
      typewriter: widget.typewriter,
    );
    final visiblePending =
        '${_stableUnits.join()}${_animatedUnits.take(visibleAnimated).join()}';
    final newestUnitAge = totalAnimated == 0 || visibleAnimated == 0
        ? elapsed
        : _ageOfNewestVisibleUnit(elapsed, visibleAnimated - 1);
    final settled = _isSettled(
      elapsed: elapsed,
      totalAnimated: totalAnimated,
      visibleAnimated: visibleAnimated,
      typewriter: widget.typewriter,
      effect: widget.effect,
    );

    _syncTicker(
      settled: settled,
      totalAnimated: totalAnimated,
      visibleAnimated: visibleAnimated,
      effect: widget.effect,
    );

    final children = <Widget>[];
    if (_committedMarkdown.isNotEmpty) {
      if (_cachedCommittedWidget == null ||
          _cachedCommittedData != _committedMarkdown) {
        _cachedCommittedData = _committedMarkdown;
        _cachedCommittedWidget = widget.source.copyWith(
          data: _committedMarkdown,
        );
      }
      children.add(_cachedCommittedWidget!);
    }
    if (visiblePending.isNotEmpty) {
      if (_cachedPendingWidget == null ||
          _cachedPendingData != visiblePending) {
        _cachedPendingData = visiblePending;
        _cachedPendingWidget = md.Markdown(
          data: visiblePending,
          selectable: widget.source.selectable,
          style: widget.source.style,
          onTapLink: widget.source.onTapLink,
          onTapLinkDetails: widget.source.onTapLinkDetails,
          onTapImage: widget.source.onTapImage,
          onTapHeading: widget.source.onTapHeading,
          onTapElement: widget.source.onTapElement,
          blockBuilder: widget.source.blockBuilder,
          onDocumentReady: widget.source.onDocumentReady,
          viewportStorageId: widget.source.viewportStorageId,
          shrinkWrap: true,
          followLinks: widget.source.followLinks,
          htmlSanitizationStrategy: widget.source.htmlSanitizationStrategy,
          imagePreviewBehavior: widget.source.imagePreviewBehavior,
          imagePreviewBuilder: widget.source.imagePreviewBuilder,
          imageBuilder: widget.source.imageBuilder,
        );
      }
      children.add(
        _wrapEffect(
          context: context,
          child: _cachedPendingWidget!,
          age: newestUnitAge,
        ),
      );
    }
    if (children.isEmpty) {
      return widget.source;
    }
    return Column(
      mainAxisSize: widget.source.shrinkWrap
          ? MainAxisSize.min
          : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Duration _ageOfNewestVisibleUnit(Duration elapsed, int index) {
    final revealDelay = _revealDelayForUnitIndex(index, widget.typewriter);
    return elapsed > revealDelay ? elapsed - revealDelay : Duration.zero;
  }

  bool _isSettled({
    required Duration elapsed,
    required int totalAnimated,
    required int visibleAnimated,
    required TypewriterEffect typewriter,
    required StreamingTextEffectAdapter effect,
  }) {
    if (totalAnimated == 0) {
      return true;
    }
    if (visibleAnimated < totalAnimated) {
      return false;
    }
    if (effect.settleDuration <= Duration.zero) {
      return true;
    }
    final revealDelay = _revealDelayForUnitIndex(totalAnimated - 1, typewriter);
    final age = elapsed > revealDelay ? elapsed - revealDelay : Duration.zero;
    return age >= effect.settleDuration;
  }

  void _syncTicker({
    required bool settled,
    required int totalAnimated,
    required int visibleAnimated,
    required StreamingTextEffectAdapter effect,
  }) {
    final shouldTick =
        visibleAnimated < totalAnimated ||
        (!settled &&
            totalAnimated > 0 &&
            effect.settleDuration > Duration.zero);

    if (!shouldTick) {
      _ticker?.cancel();
      _ticker = null;
      return;
    }

    _ticker ??= Timer.periodic(_frameInterval, (_) {
      if (!mounted) {
        _ticker?.cancel();
        _ticker = null;
        return;
      }
      setState(() {});
    });
  }

  Widget _wrapEffect({
    required BuildContext context,
    required Widget child,
    required Duration age,
  }) {
    final effect = widget.effect;
    if (effect is BlurInEffect) {
      final t = _progress(age, effect.duration, effect.curve);
      Widget current = child;
      final sigma = kIsWeb ? 0.0 : effect.maxBlurSigma * (1 - t);
      if (sigma > 0.01) {
        current = ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
          child: current,
        );
      }
      if (effect.slideUpPx != 0) {
        current = Transform.translate(
          offset: Offset(0, effect.slideUpPx * (1 - t)),
          child: current,
        );
      }
      if (effect.fadeIn) {
        current = Opacity(opacity: t.clamp(0.0, 1.0), child: current);
      } else if (kIsWeb) {
        current = Opacity(
          opacity: (0.6 + (0.4 * t)).clamp(0.0, 1.0),
          child: current,
        );
      }
      return current;
    }
    if (effect is FadeInEffect) {
      final t = _progress(age, effect.duration, effect.curve);
      return Opacity(opacity: t.clamp(0.0, 1.0), child: child);
    }
    if (effect is SlideInEffect) {
      final t = _progress(age, effect.duration, effect.curve);
      Widget current = Transform.translate(
        offset: Offset(0, effect.offsetY * (1 - t)),
        child: child,
      );
      if (effect.fadeIn) {
        current = Opacity(opacity: t.clamp(0.0, 1.0), child: current);
      }
      return current;
    }
    if (effect is ScrambleInEffect) {
      final t = _progress(age, effect.duration, Curves.easeOutCubic);
      return Opacity(opacity: t.clamp(0.0, 1.0), child: child);
    }
    return child;
  }

  double _progress(Duration age, Duration duration, Curve curve) {
    if (duration <= Duration.zero) {
      return 1;
    }
    final raw = age.inMicroseconds / duration.inMicroseconds;
    final clamped = raw.clamp(0.0, 1.0).toDouble();
    return curve.transform(clamped);
  }

  Duration _revealDelayForUnitIndex(int index, TypewriterEffect typewriter) {
    if (!typewriter.enabled || typewriter.charsPerSecond <= 0 || index <= 0) {
      return Duration.zero;
    }
    final micros =
        (index / typewriter.charsPerSecond) * Duration.microsecondsPerSecond;
    return Duration(microseconds: micros.round());
  }

  int _visibleUnitCount({
    required int total,
    required Duration elapsed,
    required TypewriterEffect typewriter,
  }) {
    if (total <= 0) {
      return 0;
    }
    if (!typewriter.enabled || typewriter.charsPerSecond <= 0) {
      return total;
    }
    final micros = elapsed.inMicroseconds;
    if (micros <= 0) {
      return 1;
    }
    final revealed =
        ((micros / Duration.microsecondsPerSecond) * typewriter.charsPerSecond)
            .floor() +
        1;
    return revealed.clamp(0, total).toInt();
  }
}
