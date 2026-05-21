// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_animate.dart';

/// Internal helper class used by the text animate component implementation.
class _StreamingTextSnapshot {
  /// Creates `_StreamingTextSnapshot` for configuring or rendering text animate.
  const _StreamingTextSnapshot({
    required this.fullText,
    required this.stablePrefixChars,
    required this.animatedChars,
    required this.changedAt,
    required this.revision,
  });

  /// Factory constructor that derives a `_StreamingTextSnapshot.initial` configuration for text animate.
  factory _StreamingTextSnapshot.initial(String text) {
    return _StreamingTextSnapshot(
      fullText: text,
      stablePrefixChars: const <String>[],
      animatedChars: _splitToCharacters(text),
      changedAt: Duration.zero,
      revision: 0,
    );
  }

  /// Data consumed by `_StreamingTextSnapshot` to render text animate content.
  final String fullText;

  /// Input parameter used by `_StreamingTextSnapshot` during rendering and behavior handling.
  final List<String> stablePrefixChars;

  /// Input parameter used by `_StreamingTextSnapshot` during rendering and behavior handling.
  final List<String> animatedChars;

  /// Input parameter used by `_StreamingTextSnapshot` during rendering and behavior handling.
  final Duration changedAt;

  /// Input parameter used by `_StreamingTextSnapshot` during rendering and behavior handling.
  final int revision;

  _StreamingTextSnapshot update({
    required String nextText,
    required Duration now,
  }) {
    final previousChars = _splitToCharacters(fullText);

    final nextChars = _splitToCharacters(nextText);

    final minLength = math.min(previousChars.length, nextChars.length);

    var prefixLength = 0;
    while (prefixLength < minLength &&
        previousChars[prefixLength] == nextChars[prefixLength]) {
      prefixLength += 1;
    }

    return _StreamingTextSnapshot(
      fullText: nextText,
      stablePrefixChars: List<String>.unmodifiable(
        nextChars.take(prefixLength),
      ),
      animatedChars: List<String>.unmodifiable(nextChars.skip(prefixLength)),
      changedAt: now,
      revision: revision + 1,
    );
  }
}

/// Implements `_splitToCharacters` behavior for text animate.
List<String> _splitToCharacters(String value) {
  if (value.isEmpty) return const <String>[];
  return List<String>.unmodifiable(
    value.runes.map((rune) => String.fromCharCode(rune)),
  );
}

/// Implements `_splitToWordUnits` behavior for text animate.
List<String> _splitToWordUnits(String value) {
  if (value.isEmpty) return const <String>[];
  final matches = RegExp(r'\S+\s*|\s+').allMatches(value);
  return List<String>.unmodifiable([
    for (final match in matches)
      if ((match.group(0) ?? '').isNotEmpty) match.group(0)!,
  ]);
}
