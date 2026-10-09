// Gallery preview for the `text_animate` component: every animation style
// streaming the same sample, word mode with a cursor, the markdown tail,
// and dark + themed sections. Widgets-only; the docs app embeds
// [TextAnimatePreview] directly.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';
import '../markdown/markdown.dart';
import 'text_animate.dart';

const String _streamSample =
    'The assistant is thinking...\nStreaming tokens into the UI in real time.';

/// Renders the animated-text gallery, streaming [_streamSample] on a timer.
class TextAnimatePreview extends StatefulWidget {
  /// Creates the preview.
  const TextAnimatePreview({super.key});

  @override
  State<TextAnimatePreview> createState() => _TextAnimatePreviewState();
}

class _TextAnimatePreviewState extends State<TextAnimatePreview> {
  String _text = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) return;
      final runes = _streamSample.runes.toList();
      if (_text.runes.length >= runes.length) {
        timer.cancel();
        return;
      }
      setState(() {
        _text = String.fromCharCodes(runes.take(_text.runes.length + 1));
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: DefaultTextStyle(
        style: TextStyle(color: theme.colors.foreground, fontSize: 13),
        child: ColoredBox(
          color: theme.colors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _section(
                  'Fade',
                  TextAnimate(
                    text: _text,
                    effect: const TextAnimateEffect.fade(),
                  ),
                ),
                _section(
                  'Slide',
                  TextAnimate(
                    text: _text,
                    effect: const TextAnimateEffect.slide(),
                  ),
                ),
                _section(
                  'Blur',
                  TextAnimate(
                    text: _text,
                    effect: const TextAnimateEffect.blur(),
                  ),
                ),
                _section(
                  'Scramble',
                  TextAnimate(
                    text: _text,
                    effect: const TextAnimateEffect.scramble(),
                  ),
                ),
                _section(
                  'Words + cursor',
                  TextAnimate(
                    text: _text,
                    animateByWord: true,
                    effect: const TextAnimateEffect.slide(),
                    cursor: const TextAnimateCursor.blink(),
                  ),
                ),
                _section(
                  'Markdown tail',
                  Markdown(data: _text).withTextStreaming(),
                ),
                _section(
                  'Themed override',
                  ComponentTheme<TextAnimateTheme>(
                    data: const TextAnimateTheme(
                      effect: TextAnimateEffect.slide(offsetY: 16),
                    ),
                    child: TextAnimate(text: _text),
                  ),
                ),
                _section(
                  'Dark',
                  ShadcnTheme(
                    data: const ShadcnThemeData(
                      colors: ShadcnColors.darkFallback,
                    ),
                    child: TextAnimate(
                      text: _text,
                      effect: const TextAnimateEffect.fade(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
