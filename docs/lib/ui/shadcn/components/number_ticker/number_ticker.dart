// The `number_ticker` component: [NumberTicker] (animated number with a
// formatter or custom builder) plus the flip-clock pieces [TextFlipper],
// [FlipperCharacter] and [FlipperCharset].
//
// Ported from `components/display/number_ticker`. Fixes: the app-wide theme
// leg now applies (old code read only the widget + scoped legs); the flipper
// gradient mask no longer imports `material.dart` for its white stops.
// Number formatting itself stays user-supplied (e.g. `intl`
// `NumberFormat.compact`), so this component has no package dependency.

import 'package:flutter/widgets.dart';

import '../../primitives/animated_value_builder.dart';
import '../../theme/theme.dart';
import 'number_ticker_style.dart';

export 'number_ticker_style.dart';

/// Builds ticker content from the animated [value].
typedef NumberTickerBuilder =
    Widget Function(BuildContext context, double value, Widget? child);

/// Formats the animated ticker value as text.
typedef NumberTickerFormatted = String Function(double value);

/// Animated number: counts between values with [duration]/[curve].
///
/// Either [formatter] (text variant) or [builder] (custom variant) is given.
class NumberTicker extends StatelessWidget {
  /// Text variant: [formatter] renders the animated value.
  const NumberTicker({
    super.key,
    this.initialNumber,
    required this.number,
    required this.formatter,
    this.duration,
    this.curve,
    this.style,
    this.theme,
  }) : builder = null,
       child = null;

  /// Custom variant: [builder] renders the animated value.
  const NumberTicker.builder({
    super.key,
    this.initialNumber,
    required this.number,
    required this.builder,
    this.child,
    this.duration,
    this.curve,
    this.theme,
  }) : formatter = null,
       style = null;

  /// Value the first animation runs from; null starts at [number].
  final num? initialNumber;

  /// Target value.
  final num number;

  /// Custom content builder (custom variant).
  final NumberTickerBuilder? builder;

  /// Passed through to [builder].
  final Widget? child;

  /// Text formatter (text variant).
  final NumberTickerFormatted? formatter;

  /// Animation duration override; null falls back to the theme.
  final Duration? duration;

  /// Animation curve override; null falls back to the theme.
  final Curve? curve;

  /// Text style override; null falls back to the theme, then ambient.
  final TextStyle? style;

  /// Widget-leg theme override, merged over the other legs.
  final NumberTickerTheme? theme;

  @override
  Widget build(BuildContext context) {
    final NumberTickerTheme resolved =
        resolveComponentStyle<NumberTickerTheme, NumberTickerTheme>(
          context,
          widget: theme,
          select: (t) => t,
          defaults: numberTickerDefaults,
        );
    final Duration tick =
        duration ?? resolved.duration ?? const Duration(milliseconds: 500);
    final Curve motion = curve ?? resolved.curve ?? Curves.easeInOut;
    final double target = number.toDouble();
    if (formatter != null) {
      final TextStyle? text = style ?? resolved.style;
      return AnimatedValueBuilder<double>(
        value: target,
        duration: tick,
        curve: motion,
        initialValue: initialNumber?.toDouble(),
        builder: (context, value, _) {
          return Text(formatter!(value), style: text);
        },
      );
    }
    return AnimatedValueBuilder<double>(
      value: target,
      duration: tick,
      curve: motion,
      initialValue: initialNumber?.toDouble(),
      builder: (context, value, child) {
        return builder!(context, value, child);
      },
      child: child,
    );
  }
}

/// Character pool a [FlipperCharacter] rolls through.
class FlipperCharset {
  /// Digits 0-9.
  static const FlipperCharset numbers = FlipperCharset('0123456789');

  /// Uppercase Latin letters.
  static const FlipperCharset uppercase = FlipperCharset(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  );

  /// Lowercase Latin letters.
  static const FlipperCharset lowercase = FlipperCharset(
    'abcdefghijklmnopqrstuvwxyz',
  );

  /// Uppercase and lowercase Latin letters.
  static const FlipperCharset letters = FlipperCharset(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz',
  );

  /// Alphanumeric characters.
  static const FlipperCharset alphanumeric = FlipperCharset(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789',
  );

  /// Common symbol characters.
  static const FlipperCharset symbols = FlipperCharset(
    '!@#\$%^&*()-_=+[]{}|;:\'",.<>?/`~',
  );

  /// Letters, numbers and symbols.
  static const FlipperCharset all = FlipperCharset(
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*()-_=+[]{}|;:\'",.<>?/`~',
  );

  /// Creates a charset from a string of characters.
  const FlipperCharset(this.characters);

  /// The characters available to roll through.
  final String characters;

  /// Concatenates two charsets.
  FlipperCharset operator +(FlipperCharset other) {
    return FlipperCharset(characters + other.characters);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlipperCharset && other.characters == characters;
  }

  @override
  int get hashCode => characters.hashCode;

  @override
  String toString() => 'FlipperCharset($characters)';
}

/// One rolling character: slides from the previous match to the next match
/// in [charset], fading through a vertical gradient mask.
class FlipperCharacter extends StatelessWidget {
  const FlipperCharacter({
    super.key,
    required this.charset,
    required this.character,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  /// Pool rolled through.
  final FlipperCharset charset;

  /// Target character.
  final String character;

  /// Roll duration.
  final Duration duration;

  /// Roll curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final int index = charset.characters.indexOf(character);
    return AnimatedValueBuilder<double>(
      value: index.toDouble(),
      duration: duration,
      curve: curve,
      builder: (context, value, _) {
        final int length = charset.characters.length;
        final int next = value.ceil();
        final int prev = value.floor();
        String at(int i) => i == -1 ? '' : charset.characters[i % length];
        if (next == prev) return Text(at(next));
        final double t = value - prev;
        final Widget hidden = Visibility(
          visible: false,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: Text(at(next)),
        );
        Widget slide(String text, double opacity, double dy) {
          return Positioned.fill(
            child: Opacity(
              opacity: opacity,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Transform.translate(
                    offset: Offset(0, dy * constraints.maxHeight),
                    child: Text(text),
                  );
                },
              ),
            ),
          );
        }

        final double halfT = (t - 0.5).abs().clamp(0.0, 0.5);
        return AnimatedSize(
          duration: duration,
          curve: curve,
          child: _FlipperGradientMask(
            gradientHeight: 0.5 - halfT,
            child: Stack(
              children: <Widget>[
                hidden,
                slide(at(prev), 1 - t, t),
                slide(at(next), t, -(1 - t)),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animates [text] by rolling each character through [charset].
class TextFlipper extends StatelessWidget {
  const TextFlipper({
    super.key,
    this.charset = FlipperCharset.all,
    required this.text,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  /// Pool each character rolls through.
  final FlipperCharset charset;

  /// Target text.
  final String text;

  /// Roll duration per character.
  final Duration duration;

  /// Roll curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final String char in text.split(''))
            FlipperCharacter(
              charset: charset,
              character: char,
              duration: duration,
              curve: curve,
            ),
        ],
      ),
    );
  }
}

/// Vertical fade mask over rolling characters (white shader stops are mask
/// values, not theme colors).
class _FlipperGradientMask extends StatelessWidget {
  const _FlipperGradientMask({
    required this.child,
    required this.gradientHeight,
  });

  final Widget child;

  /// Fade fraction at each edge.
  final double gradientHeight;

  @override
  Widget build(BuildContext context) {
    final double edge = gradientHeight.clamp(0.0, 0.5);
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const <Color>[
            Color(0x00FFFFFF),
            Color(0xFFFFFFFF),
            Color(0xFFFFFFFF),
            Color(0x00FFFFFF),
          ],
          stops: <double>[0, edge, 1 - edge, 1],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
