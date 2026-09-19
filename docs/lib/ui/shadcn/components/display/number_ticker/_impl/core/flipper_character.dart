// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../number_ticker.dart';

/// Animates a single character by flipping through [FlipperCharset].
class FlipperCharacter extends StatelessWidget {
  /// The character set used for flipping.
  final FlipperCharset charset;

  /// The target character to display.
  final String character;

  /// Duration of the flip animation.
  final Duration duration;

  /// Curve used for the flip animation.
  final Curve curve;

  /// Creates a [FlipperCharacter].
  const FlipperCharacter({
    super.key,
    required this.charset,
    required this.character,
    required this.duration,
    required this.curve,
  });

  /// Builds the widget tree for flipper character.
  @override
  Widget build(BuildContext context) {
    int index = charset.characters.indexOf(character);
    return AnimatedValueBuilder(
      value: index.toDouble(),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final nextChar = value.ceil();
        final prevChar = value.floor();
        if (nextChar == prevChar) {
          final charString = nextChar == -1
              ? ''
              : charset.characters[nextChar % charset.characters.length];
          return Text(charString);
        }
        final t = value - prevChar;
        final nextCharString = nextChar == -1
            ? ''
            : charset.characters[nextChar % charset.characters.length];
        final prevCharString = prevChar == -1
            ? ''
            : charset.characters[prevChar % charset.characters.length];
        final nextOffset = Offset(0, -(1 - t));
        final prevOffset = Offset(0, t);
        final nextOpacity = t;
        final prevOpacity = 1 - t;
        Widget child = Stack(
          children: [
            Visibility(
              visible: false,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Text(nextCharString),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: prevOpacity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(
                        prevOffset.dx * constraints.maxWidth,
                        prevOffset.dy * constraints.maxHeight,
                      ),
                      child: Text(prevCharString),
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: nextOpacity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Transform.translate(
                      offset: Offset(
                        nextOffset.dx * constraints.maxWidth,
                        nextOffset.dy * constraints.maxHeight,
                      ),
                      child: Text(nextCharString),
                    );
                  },
                ),
              ),
            ),
          ],
        );
        final halfT = (t - 0.5).abs().clamp(0.0, 0.5);
        final gradientHeight = 0.5 - halfT; // or (0.5 - halfT).clamp(0.0, 0.5)
        return AnimatedSize(
          duration: duration,
          curve: curve,
          child: _FlipperGradientMask(
            gradientHeight: gradientHeight,
            child: child,
          ),
        );
      },
    );
  }
}

class _FlipperGradientMask extends StatelessWidget {
  final Widget child;
  final double gradientHeight; // fraction
  const _FlipperGradientMask({
    required this.child,
    required this.gradientHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withAlpha(0),
            Colors.white,
            Colors.white,
            Colors.white.withAlpha(0),
          ],
          stops: [0.0, gradientHeight, 1 - gradientHeight, 1.0],
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
