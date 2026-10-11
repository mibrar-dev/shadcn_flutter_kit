// Snapshot diffing for streaming text: unit splitting plus the revision
// model behind `TextAnimate` and the markdown streaming partition.
//
// Pure logic: no widgets, no theme, no `BuildContext`.

/// Splits [value] into reveal units, one per Unicode scalar (emoji-safe).
List<String> splitStreamingChars(String value) {
  if (value.isEmpty) return const <String>[];
  return List<String>.unmodifiable(
    value.runes.map((rune) => String.fromCharCode(rune)),
  );
}

/// Splits [value] into word units, keeping every character: words carry
/// their trailing whitespace and whitespace-only runs are their own units,
/// so the units always join back to [value].
List<String> splitStreamingWords(String value) {
  if (value.isEmpty) return const <String>[];
  return List<String>.unmodifiable(
    RegExp(r'\S+\s*|\s+')
        .allMatches(value)
        .map((match) => match.group(0)!)
        .where((unit) => unit.isNotEmpty),
  );
}

/// Length of the common prefix of two unit lists.
int sharedStreamingPrefix(List<String> previous, List<String> next) {
  final limit = previous.length < next.length ? previous.length : next.length;
  var index = 0;
  while (index < limit && previous[index] == next[index]) {
    index += 1;
  }
  return index;
}

/// One revision of a text stream: the stable prefix (rendered as-is) plus
/// the animated tail (revealed by the typewriter), stamped with its arrival
/// time.
class StreamingSnapshot {
  const StreamingSnapshot({
    required this.fullText,
    required this.stableChars,
    required this.animatedChars,
    required this.changedAt,
    required this.revision,
  });

  /// First revision: nothing is stable, everything animates.
  factory StreamingSnapshot.initial(String text) {
    return StreamingSnapshot(
      fullText: text,
      stableChars: const <String>[],
      animatedChars: splitStreamingChars(text),
      changedAt: Duration.zero,
      revision: 0,
    );
  }

  /// Full latest text.
  final String fullText;

  /// Units shared with the previous revision (rendered settled).
  final List<String> stableChars;

  /// New tail units (revealed over time).
  final List<String> animatedChars;

  /// Clock reading when this revision arrived.
  final Duration changedAt;

  /// Bumped on every update; settled callbacks fire once per revision.
  final int revision;

  /// Next revision: the common rune prefix with the previous text stays
  /// stable, the rest animates. A non-append edit restarts from scratch
  /// because the prefix is empty.
  StreamingSnapshot update({required String nextText, required Duration now}) {
    final previous = splitStreamingChars(fullText);
    final next = splitStreamingChars(nextText);
    final prefix = sharedStreamingPrefix(previous, next);
    return StreamingSnapshot(
      fullText: nextText,
      stableChars: List<String>.unmodifiable(next.take(prefix)),
      animatedChars: List<String>.unmodifiable(next.skip(prefix)),
      changedAt: now,
      revision: revision + 1,
    );
  }
}

/// Stability function for a pending buffer: leading characters that parse
/// identically once more text arrives (the markdown parser owns one).
typedef StreamingStableLength = int Function(String pending);

/// Markdown streaming partition: the stable prefix renders as plain settled
/// markdown while the unstable tail re-renders with the reveal animation.
///
/// Stability comes from [StreamingStableLength]: only whole lines past an
/// unclosed fence, math block, details block or table count as unstable, so
/// everything before it commits verbatim.
class StreamingMarkdownSplit {
  StreamingMarkdownSplit({required this.stableLengthOf});

  /// Stability function: leading characters that parse identically once
  /// more text arrives.
  final StreamingStableLength stableLengthOf;

  /// Last full source seen.
  String source = '';

  /// Committed stable prefix (settled markdown).
  String committed = '';

  /// Unstable tail (animated).
  String pending = '';

  /// Pending units already revealed (shared prefix across appends).
  List<String> stableUnits = const <String>[];

  /// Pending units still animating.
  List<String> animatedUnits = const <String>[];

  /// Clock reading of the latest pending change.
  Duration changedAt = Duration.zero;

  /// Folds [next] in: a non-append edit resets from scratch, an append
  /// keeps the shared pending prefix stable and animates only the new tail.
  void applyIncoming(
    String next, {
    required bool forceReset,
    required bool animateByWord,
    required Duration now,
  }) {
    if (forceReset || source.isEmpty || !next.startsWith(source)) {
      source = next;
      committed = '';
      pending = next;
      promoteStable();
      _retargetPending(animateByWord: animateByWord, now: now);
      return;
    }
    final appended = next.substring(source.length);
    source = next;
    if (appended.isEmpty) return;
    final previousPending = pending;
    pending = '$pending$appended';
    if (promoteStable() > 0) {
      _retargetPending(animateByWord: animateByWord, now: now);
    } else {
      final previous = _split(previousPending, animateByWord: animateByWord);
      final current = _split(pending, animateByWord: animateByWord);
      final shared = sharedStreamingPrefix(previous, current);
      stableUnits = List<String>.unmodifiable(current.take(shared));
      animatedUnits = List<String>.unmodifiable(current.skip(shared));
      changedAt = now;
    }
  }

  /// Moves the stable leading run of [pending] into [committed].
  int promoteStable() {
    final stableLength = stableLengthOf(pending);
    if (stableLength <= 0) return 0;
    committed = '$committed${pending.substring(0, stableLength)}';
    pending = pending.substring(stableLength);
    return stableLength;
  }

  void _retargetPending({required bool animateByWord, required Duration now}) {
    stableUnits = const <String>[];
    animatedUnits = _split(pending, animateByWord: animateByWord);
    changedAt = now;
  }

  static List<String> _split(String value, {required bool animateByWord}) {
    return animateByWord
        ? splitStreamingWords(value)
        : splitStreamingChars(value);
  }
}
