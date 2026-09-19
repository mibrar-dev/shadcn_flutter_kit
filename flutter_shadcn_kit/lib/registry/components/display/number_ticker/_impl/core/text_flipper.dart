// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../number_ticker.dart';

/// Animates a string by flipping each character.
class TextFlipper extends StatelessWidget {
  /// The character set used for each character flip.
  final FlipperCharset charset;

  /// The text to animate.
  final String text;

  /// Duration of the flip animation for each character.
  final Duration duration;

  /// Curve used for the flip animation.
  final Curve curve;

  /// Creates a [TextFlipper].
  const TextFlipper({
    super.key,
    this.charset = FlipperCharset.all,
    required this.text,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  /// Builds the widget tree for text flipper.
  @override
  Widget build(BuildContext context) {
    // We need to force-clip because Row does not clip its children
    // if the children overflowed by using Transform.
    return ClipRect(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: text.characters
            .map(
              (char) => FlipperCharacter(
                charset: charset,
                character: char,
                duration: duration,
                curve: curve,
              ),
            )
            .toList(),
      ),
    );
  }
}
