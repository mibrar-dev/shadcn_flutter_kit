// Modifier-driven multi-selection for a virtualised list, without stored state.
//
// The widget reads `HardwareKeyboard.instance.isShiftPressed` /
// `isControlPressed` / `isMetaPressed` at press time and asks these two pure
// helpers what that means. Nothing here can latch: there is no field that
// remembers a modifier, only an anchor *index* the caller owns.

/// What the user asked the selection to do.
enum TreeSelectionGesture {
  /// Replace the selection with this row.
  plain,

  /// Add this row to the selection, or take it out again (Ctrl/Cmd-click).
  toggle,

  /// Select everything between the anchor and this row (Shift).
  range,

  /// Select every visible row (Ctrl/Cmd+A).
  all,
}

/// What a pointer press with the given modifiers asked for.
///
/// Shift wins over Ctrl/Cmd, which matches every platform tree and file
/// browser. [multiPressed] covers Ctrl *and* Cmd, because Cmd is the macOS
/// multi-select modifier.
TreeSelectionGesture resolveTreeSelectionGesture({
  required bool shiftPressed,
  required bool multiPressed,
}) => shiftPressed
    ? TreeSelectionGesture.range
    : multiPressed
    ? TreeSelectionGesture.toggle
    : TreeSelectionGesture.plain;

/// What a key press with the given modifiers asked for.
///
/// [selectAll] is the Ctrl/Cmd+A chord and wins over [shiftPressed]; the
/// caller only passes it for the <kbd>A</kbd> key, so a bare arrow key can
/// never select everything.
TreeSelectionGesture resolveTreeSelectionIntent({
  required bool selectAll,
  required bool shiftPressed,
}) => selectAll
    ? TreeSelectionGesture.all
    : shiftPressed
    ? TreeSelectionGesture.range
    : TreeSelectionGesture.plain;

/// An inclusive span of visible-row indices.
class TreeSelectionRange {
  /// Creates a range from [start] to [end], inclusive.
  const TreeSelectionRange(this.start, this.end);

  /// A range that covers nothing.
  static const TreeSelectionRange empty = TreeSelectionRange(0, -1);

  /// First index covered.
  final int start;

  /// Last index covered, inclusive.
  final int end;

  /// Whether the range covers no index at all.
  bool get isEmpty => end < start;

  /// How many indices the range covers.
  int get length => isEmpty ? 0 : end - start + 1;

  /// Whether [index] falls inside the range.
  bool contains(int index) => !isEmpty && index >= start && index <= end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TreeSelectionRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => isEmpty
      ? 'TreeSelectionRange(empty)'
      : 'TreeSelectionRange($start..$end)';
}

/// The inclusive span from [anchor] to [target] over a list of [length] rows.
///
/// Both ends are clamped, so a stale anchor (the tree expanded or collapsed
/// under it) can neither throw nor produce an inverted range; the result is
/// always ascending. [TreeSelectionRange.empty] when there are no rows.
TreeSelectionRange selectionRange({
  required int anchor,
  required int target,
  required int length,
}) {
  if (length <= 0) {
    return TreeSelectionRange.empty;
  }
  final int last = length - 1;
  final int from = anchor.clamp(0, last);
  final int to = target.clamp(0, last);
  return from <= to
      ? TreeSelectionRange(from, to)
      : TreeSelectionRange(to, from);
}

/// Every run of selected rows in [selected], in document order.
///
/// The caller turns each run into per-row start/middle/end marks; keeping the
/// run detection here means it is one linear pass and unit-testable without a
/// tree. `<bool>[false, true, true, false, true]` yields
/// `[TreeSelectionRange(1, 2), TreeSelectionRange(4, 4)]`.
List<TreeSelectionRange> selectedRuns(List<bool> selected) {
  final List<TreeSelectionRange> runs = <TreeSelectionRange>[];
  int start = -1;
  for (int i = 0; i <= selected.length; i++) {
    final bool on = i < selected.length && selected[i];
    if (on && start < 0) {
      start = i;
    } else if (!on && start >= 0) {
      runs.add(TreeSelectionRange(start, i - 1));
      start = -1;
    }
  }
  return runs;
}
