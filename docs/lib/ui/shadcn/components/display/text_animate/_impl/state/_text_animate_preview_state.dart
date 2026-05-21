// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _StreamingMode enumerates fixed values used by this implementation.
enum _StreamingMode { character, word, chunk, part }

/// _AnimationVariant enumerates fixed values used by this implementation.
enum _AnimationVariant { blur, fade, slide, scramble }

/// _TextAnimatePreviewState holds mutable state for the text animate implementation.
class _TextAnimatePreviewState extends m.State<TextAnimatePreview> {
  /// Input parameter used by `_TextAnimatePreviewState` during rendering and behavior handling.
  static const String _part1 = 'The assistant is thinking...';
  static const String _part2 =
      'The assistant is thinking...\nStreaming tokens into the UI in real time.';

  static const List<_StreamingMode> _modes = [
    _StreamingMode.character,
    _StreamingMode.word,
    _StreamingMode.chunk,
    _StreamingMode.part,
  ];

  static const List<_AnimationVariant> _animations = [
    _AnimationVariant.blur,
    _AnimationVariant.fade,
    _AnimationVariant.slide,
    _AnimationVariant.scramble,
  ];

  /// Input parameter used by `_TextAnimatePreviewState` during rendering and behavior handling.
  late final Map<_StreamingMode, List<String>> _chunksByMode;

  /// Input parameter used by `_TextAnimatePreviewState` during rendering and behavior handling.
  late final Map<_StreamingMode, String> _streamByMode;

  /// Input parameter used by `_TextAnimatePreviewState` during rendering and behavior handling.
  late final Map<_StreamingMode, int> _indexByMode;

  /// Input parameter used by `_TextAnimatePreviewState` during rendering and behavior handling.
  Timer? _timer;

  /// Input parameter used by `_TextAnimatePreviewState` during rendering and behavior handling.
  int _tickCount = 0;

  /// Input parameter used by `_TextAnimatePreviewState` during rendering and behavior handling.
  double _streamIntervalMs = 70;

  /// Initializes controllers and listeners required by text animate.
  @override
  void initState() {
    super.initState();
    _chunksByMode = {
      _StreamingMode.character: _part2.runes
          .map((r) => String.fromCharCode(r))
          .toList(),
      _StreamingMode.word: _buildWordChunks(_part2),
      _StreamingMode.chunk: _buildFixedChunks(_part2, 16),
      _StreamingMode.part: [_part1, _part2],
    };
    _streamByMode = {for (final mode in _modes) mode: ''};
    _indexByMode = {for (final mode in _modes) mode: 0};
    _startStream();
  }

  /// Disposes resources allocated by this text animate state.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Implements `_startStream` behavior for text animate.
  void _startStream() {
    _timer?.cancel();

    /// Implements `setState` behavior for text animate.
    setState(() {
      _tickCount = 0;
      for (final mode in _modes) {
        _streamByMode[mode] = '';
        _indexByMode[mode] = 0;
      }
    });

    _timer = Timer.periodic(Duration(milliseconds: _streamIntervalMs.round()), (
      timer,
    ) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      /// Implements `setState` behavior for text animate.
      setState(() {
        _tickCount += 1;
        for (final mode in _modes) {
          final factor = _modeTickFactor(mode);
          if (_tickCount % factor == 0) {
            _advanceStream(mode);
          }
        }
      });

      if (_isAllStreamsComplete) {
        timer.cancel();
      }
    });
  }

  bool get _isAllStreamsComplete {
    for (final mode in _modes) {
      final index = _indexByMode[mode] ?? 0;

      final chunks = _chunksByMode[mode] ?? const <String>[];
      if (index < chunks.length) {
        return false;
      }
    }
    return true;
  }

  /// Implements `_advanceStream` behavior for text animate.
  void _advanceStream(_StreamingMode mode) {
    final chunks = _chunksByMode[mode] ?? const <String>[];

    final index = _indexByMode[mode] ?? 0;
    if (index >= chunks.length) {
      return;
    }

    if (mode == _StreamingMode.part) {
      _streamByMode[mode] = chunks[index];
    } else {
      _streamByMode[mode] = '${_streamByMode[mode]}${chunks[index]}';
    }
    _indexByMode[mode] = index + 1;
  }

  @override
  m.Widget build(m.BuildContext context) {
    return m.Scaffold(
      body: m.Center(
        child: m.Padding(
          padding: const m.EdgeInsets.all(20),
          child: m.ConstrainedBox(
            constraints: const m.BoxConstraints(maxWidth: 1620),
            child: m.SingleChildScrollView(
              child: m.Column(
                crossAxisAlignment: m.CrossAxisAlignment.start,
                children: [
                  const m.Text(
                    'Streaming Modes x Animation Variants',
                    style: m.TextStyle(
                      fontSize: 20,
                      fontWeight: m.FontWeight.w700,
                    ),
                  ),

                  const m.SizedBox(height: 8),

                  const m.Text(
                    'Responsive grid preview: each animation is shown with character, word, chunk, and part-stream updates.',
                  ),

                  const m.SizedBox(height: 14),

                  _buildGrid(),

                  const m.SizedBox(height: 16),

                  m.Text(
                    'Base stream tick: ${_streamIntervalMs.toStringAsFixed(0)} ms',
                  ),

                  m.Slider(
                    value: _streamIntervalMs,
                    min: 30,
                    max: 260,
                    divisions: 23,
                    onChanged: (value) {
                      /// Implements `setState` behavior for text animate.
                      setState(() => _streamIntervalMs = value);
                    },
                  ),

                  const m.SizedBox(height: 4),

                  m.Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      m.FilledButton(
                        onPressed: _startStream,
                        child: const m.Text('Restart stream'),
                      ),

                      m.OutlinedButton(
                        onPressed: () {
                          _timer?.cancel();

                          /// Implements `setState` behavior for text animate.
                          setState(() {
                            for (final mode in _modes) {
                              _streamByMode[mode] = _part2;
                              _indexByMode[mode] =
                                  (_chunksByMode[mode] ?? const <String>[])
                                      .length;
                            }
                          });
                        },
                        child: const m.Text('Show full text'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  m.Widget _buildGrid() {
    final cells = <m.Widget>[];

    for (final animation in _animations) {
      for (final mode in _modes) {
        cells.add(_buildCell(animation: animation, mode: mode));
      }
    }

    return m.LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final columns = maxWidth >= 1440
            ? 4
            : maxWidth >= 1040
            ? 3
            : maxWidth >= 700
            ? 2
            : 1;

        return m.GridView.builder(
          shrinkWrap: true,
          physics: const m.NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate: m.SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 276,
          ),
          itemBuilder: (context, index) => cells[index],
        );
      },
    );
  }

  m.Widget _buildCell({
    required _AnimationVariant animation,
    required _StreamingMode mode,
  }) {
    return m.Container(
      padding: const m.EdgeInsets.all(12),
      decoration: m.BoxDecoration(
        border: m.Border.all(color: const m.Color(0x22000000)),
        borderRadius: m.BorderRadius.circular(12),
      ),
      child: m.Column(
        crossAxisAlignment: m.CrossAxisAlignment.start,
        children: [
          m.Text(
            '${_animationLabel(animation)} - ${_modeLabel(mode)}',
            style: const m.TextStyle(
              fontSize: 13,
              fontWeight: m.FontWeight.w700,
            ),
          ),

          const m.SizedBox(height: 2),

          m.Text(
            _modeDescription(mode),
            style: const m.TextStyle(fontSize: 11, height: 1.35),
            maxLines: 2,
            overflow: m.TextOverflow.ellipsis,
          ),

          const m.SizedBox(height: 2),

          m.Text(
            _animationDescription(animation),
            style: const m.TextStyle(fontSize: 11, height: 1.35),
            maxLines: 2,
            overflow: m.TextOverflow.ellipsis,
          ),

          const m.SizedBox(height: 10),

          m.Container(
            width: double.infinity,
            constraints: const m.BoxConstraints(minHeight: 106),
            padding: const m.EdgeInsets.all(10),
            decoration: m.BoxDecoration(
              color: const m.Color(0x05000000),
              borderRadius: m.BorderRadius.circular(10),
            ),
            child: StreamingText(
              text: (_streamByMode[mode] ?? ''),
              style: const m.TextStyle(fontSize: 16, height: 1.45),
              typewriter: const TypewriterEffect(enabled: false),
              effect: _effectFor(animation),
              cursor: const StreamingCursor.none(),
            ),
          ),
        ],
      ),
    );
  }

  /// Implements `_effectFor` behavior for text animate.
  StreamingTextEffectAdapter _effectFor(_AnimationVariant animation) {
    switch (animation) {
      case _AnimationVariant.blur:
        return const BlurInEffect(
          duration: Duration(milliseconds: 840),
          maxBlurSigma: 20,
          fadeIn: true,
          slideUpPx: 8,
          curve: m.Curves.easeOutQuart,
        );
      case _AnimationVariant.fade:
        return const FadeInEffect(
          duration: Duration(milliseconds: 560),
          curve: m.Curves.easeOut,
        );
      case _AnimationVariant.slide:
        return const SlideInEffect(
          duration: Duration(milliseconds: 640),
          offsetY: 13,
          fadeIn: true,
          curve: m.Curves.easeOutCubic,
        );
      case _AnimationVariant.scramble:
        return const ScrambleInEffect(
          duration: Duration(milliseconds: 760),
          scrambleUntil: 0.78,
          fadeIn: true,
        );
    }
  }

  /// Implements `_modeTickFactor` behavior for text animate.
  int _modeTickFactor(_StreamingMode mode) {
    switch (mode) {
      case _StreamingMode.character:
        return 1;
      case _StreamingMode.word:
        return 2;
      case _StreamingMode.chunk:
        return 3;
      case _StreamingMode.part:
        return 6;
    }
  }

  /// Implements `_modeLabel` behavior for text animate.
  String _modeLabel(_StreamingMode mode) {
    switch (mode) {
      case _StreamingMode.character:
        return 'Character by Character';
      case _StreamingMode.word:
        return 'Word by Word';
      case _StreamingMode.chunk:
        return 'Chunk-by-Chunk';
      case _StreamingMode.part:
        return 'Part Stream';
    }
  }

  /// Implements `_modeDescription` behavior for text animate.
  String _modeDescription(_StreamingMode mode) {
    switch (mode) {
      case _StreamingMode.character:
        return 'Background: one rune is appended every tick.';
      case _StreamingMode.word:
        return 'Background: one word unit (plus trailing spacing) is appended every 2 ticks.';
      case _StreamingMode.chunk:
        return 'Background: fixed 16-character chunks are appended every 3 ticks.';
      case _StreamingMode.part:
        return 'Background: stream emits full snapshots part-1 then part-2; only new tail animates.';
    }
  }

  /// Implements `_animationLabel` behavior for text animate.
  String _animationLabel(_AnimationVariant animation) {
    switch (animation) {
      case _AnimationVariant.blur:
        return 'Blur In';
      case _AnimationVariant.fade:
        return 'Fade In';
      case _AnimationVariant.slide:
        return 'Slide In';
      case _AnimationVariant.scramble:
        return 'Scramble In';
    }
  }

  /// Implements `_animationDescription` behavior for text animate.
  String _animationDescription(_AnimationVariant animation) {
    switch (animation) {
      case _AnimationVariant.blur:
        return 'Animation: starts blurred and settles to sharp text.';
      case _AnimationVariant.fade:
        return 'Animation: newly arrived text fades from 0% to 100% opacity.';
      case _AnimationVariant.slide:
        return 'Animation: new text rises upward while fading into place.';
      case _AnimationVariant.scramble:
        return 'Animation: new glyphs scramble through symbols, then resolve to final text.';
    }
  }

  /// Implements `_buildWordChunks` behavior for text animate.
  List<String> _buildWordChunks(String text) {
    final matches = RegExp(r'\S+\s*').allMatches(text);

    final chunks = <String>[];
    for (final match in matches) {
      final value = match.group(0);
      if (value != null && value.isNotEmpty) {
        chunks.add(value);
      }
    }
    return chunks;
  }

  /// Implements `_buildFixedChunks` behavior for text animate.
  List<String> _buildFixedChunks(String text, int chunkSize) {
    if (chunkSize <= 0) {
      return [text];
    }
    final runes = text.runes.toList();

    final chunks = <String>[];
    for (var i = 0; i < runes.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, runes.length);
      chunks.add(String.fromCharCodes(runes.sublist(i, end)));
    }
    return chunks;
  }
}
