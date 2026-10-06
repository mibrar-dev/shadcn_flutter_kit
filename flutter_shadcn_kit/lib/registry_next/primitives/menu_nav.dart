// Keyboard navigation helpers shared by menu, menubar, select, command,
// dropdown_menu and context_menu.
//
// `SubFocus` / `SubFocusScope` own focus ownership and geometry-based
// movement; this file adds the list-index traversal menus need (skipping
// disabled entries) and the type-to-select buffer. `MenuPopup` /
// `MenuGroupData` stay in the `menu` component.

/// Index of the next enabled entry after [current] in a list of [count]
/// entries, or null when none is enabled.
///
/// [forward] walks from low to high indices; [wrap] continues from the other
/// end when the walk passes an edge. Entries are examined in walk order
/// starting after [current]; with wrapping the walk eventually reaches
/// [current] itself again after a full loop.
int? nextEnabledIndex({
  required int count,
  required int current,
  bool forward = true,
  bool wrap = true,
  bool Function(int index)? isEnabled,
}) {
  if (count <= 0) return null;
  final step = forward ? 1 : -1;
  for (var offset = 1; offset <= count; offset++) {
    final index = current + step * offset;
    if (!wrap && (index < 0 || index >= count)) return null;
    final candidate = index % count;
    if (isEnabled == null || isEnabled(candidate)) return candidate;
  }
  return null;
}

/// First index in `0..count-1` accepted by [isEnabled], or null when none is.
int? firstEnabledIndex(int count, {bool Function(int index)? isEnabled}) {
  for (var i = 0; i < count; i++) {
    if (isEnabled == null || isEnabled(i)) return i;
  }
  return null;
}

/// Last index in `0..count-1` accepted by [isEnabled], or null when none is.
int? lastEnabledIndex(int count, {bool Function(int index)? isEnabled}) {
  for (var i = count - 1; i >= 0; i--) {
    if (isEnabled == null || isEnabled(i)) return i;
  }
  return null;
}

/// Accumulates keystrokes into a search prefix and expires it after a pause,
/// the type-to-select behaviour of desktop menus.
class MenuTypeahead {
  /// Creates a buffer; [resetDelay] is how long the prefix stays valid
  /// without a new character.
  MenuTypeahead({this.resetDelay = const Duration(milliseconds: 600)});

  /// Maximum gap between two characters before the prefix restarts.
  final Duration resetDelay;

  String _query = '';
  Duration? _lastInput;

  /// The current search prefix, possibly empty.
  String get query => _query;

  /// Appends [character] to the prefix unless it is not a single rune; a gap
  /// longer than [resetDelay] starts a new prefix.
  ///
  /// [now] is the caller's monotonic timestamp, read from the wall clock when
  /// omitted. Pass it explicitly to keep behaviour deterministic.
  void type(String character, {Duration? now}) {
    if (character.runes.length != 1) return;
    final timestamp = now ?? _wallClock();
    final gap = _lastInput == null ? null : timestamp - _lastInput!;
    if (gap == null || gap > resetDelay) {
      _query = '';
    }
    _query += character;
    _lastInput = timestamp;
  }

  /// Clears the prefix and its timestamp.
  void reset() {
    _query = '';
    _lastInput = null;
  }

  /// Index of the first label starting with [query], searching from [start]
  /// and wrapping, or null when the prefix is empty or nothing matches.
  ///
  /// Comparison is case-insensitive; entries rejected by [isEnabled] are
  /// skipped.
  int? match(
    List<String> labels, {
    int start = 0,
    bool Function(int index)? isEnabled,
  }) {
    if (_query.isEmpty || labels.isEmpty) return null;
    final prefix = _query.toLowerCase();
    for (var offset = 0; offset < labels.length; offset++) {
      final index = (start + offset) % labels.length;
      if (isEnabled != null && !isEnabled(index)) continue;
      if (labels[index].toLowerCase().startsWith(prefix)) return index;
    }
    return null;
  }
}

Duration _wallClock() =>
    Duration(milliseconds: DateTime.now().millisecondsSinceEpoch);
