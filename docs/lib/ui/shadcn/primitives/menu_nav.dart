// Keyboard navigation for menu, menubar, select, command, dropdown_menu and
// context_menu: index traversal, type-to-select, and the [RovingGroup] engine.
// `MenuPopup` stays in `menu`; `MenuGroupData` lives here as the shared type.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/data.dart';

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

/// One focusable row as a [RovingGroup] sees it.
class MenuNavSlot {
  /// Creates a traversal slot.
  MenuNavSlot({
    required this.node,
    required this.enabled,
    this.label,
    this.onOpen,
    this.onClose,
    this.isOpen,
  });

  /// Node focus moves to; owned by the row.
  final FocusNode node;

  /// Whether traversal may land here.
  final bool enabled;

  /// Typeahead text; null opts out of type-to-select.
  final String? label;

  /// Opens the row's nested level (ArrowRight).
  final VoidCallback? onOpen;

  /// Closes the row's nested level, if any.
  final VoidCallback? onClose;

  /// Whether the row's nested level is open.
  final bool Function()? isOpen;
}

/// Shared state of one [RovingGroup]: hierarchy links and the close fan-out.
class MenuGroupData {
  /// Creates group data.
  MenuGroupData({
    this.parent,
    this.hasLeading = false,
    this.direction = Axis.vertical,
    this.itemPadding = EdgeInsets.zero,
    this.subMenuOffset,
    this.onDismissed,
  });

  /// Parent group; null for the root group of a menu.
  final MenuGroupData? parent;

  /// Whether any row reserves a leading gutter.
  final bool hasLeading;

  /// Layout direction of the rows.
  final Axis direction;

  /// Extra padding added to every row.
  final EdgeInsets itemPadding;

  /// Nested-level offset; null resolves the caller's default.
  final Offset? subMenuOffset;

  /// Called when the root group closes.
  final VoidCallback? onDismissed;

  /// Traversal slots, in child order.
  final List<MenuNavSlot> slots = <MenuNavSlot>[];

  /// Open child groups, for subtree closes.
  final List<MenuGroupData> subgroups = <MenuGroupData>[];

  /// Whether any tracked nested level is open.
  bool get hasOpenPopovers => slots.any((s) => s.isOpen?.call() ?? false);

  /// Closes this level and every open level below it.
  void closeOthers() {
    for (final MenuGroupData sub in subgroups.toList()) {
      sub._closeTree();
    }
    for (final MenuNavSlot slot in slots) {
      slot.onClose?.call();
    }
  }

  void _closeTree() {
    for (final MenuGroupData sub in subgroups.toList()) {
      sub._closeTree();
    }
    for (final MenuNavSlot slot in slots) {
      slot.onClose?.call();
    }
  }

  /// Closes the whole menu by bubbling to the root.
  void closeAll() {
    final MenuGroupData? p = parent;
    if (p == null) {
      onDismissed?.call();
      return;
    }
    p.closeOthers();
    p.closeAll();
  }

  /// The root group of this menu.
  MenuGroupData get root => parent?.root ?? this;
}

/// An index-ordered keyboard group: one tab stop, arrows move between enabled
/// rows (wrapping), Home/End jump, typing selects by prefix, ArrowRight opens
/// the focused row's nested level, Escape closes (one level, or all at root).
class RovingGroup extends StatefulWidget {
  /// Creates a roving group.
  const RovingGroup({
    super.key,
    required this.children,
    required this.builder,
    this.parent,
    this.hasLeading = false,
    this.direction = Axis.vertical,
    this.itemPadding = EdgeInsets.zero,
    this.subMenuOffset,
    this.onDismissed,
    this.autofocus = true,
    this.onEscape,
  });

  /// The rows of this group.
  final List<Widget> children;

  /// Lays out the rows.
  final Widget Function(BuildContext context, List<Widget> children) builder;

  /// Parent group data; null for a root group.
  final MenuGroupData? parent;

  /// Whether any row reserves a leading gutter.
  final bool hasLeading;

  /// Layout direction.
  final Axis direction;

  /// Extra row padding.
  final EdgeInsets itemPadding;

  /// Nested-level offset; null resolves the caller's default.
  final Offset? subMenuOffset;

  /// Called when the root group closes.
  final VoidCallback? onDismissed;

  /// Whether the group takes focus on mount.
  final bool autofocus;

  /// Escape handler; null closes one level (all of them at the root).
  final VoidCallback? onEscape;

  @override
  State<RovingGroup> createState() => _RovingGroupState();
}

class _RovingGroupState extends State<RovingGroup> {
  late final MenuGroupData _data = MenuGroupData(
    parent: widget.parent,
    hasLeading: widget.hasLeading,
    direction: widget.direction,
    itemPadding: widget.itemPadding,
    subMenuOffset: widget.subMenuOffset,
    onDismissed: widget.onDismissed,
  );
  final FocusNode _scope = FocusNode(debugLabel: 'RovingGroup');
  final MenuTypeahead _typeahead = MenuTypeahead();

  @override
  void initState() {
    super.initState();
    widget.parent?.subgroups.add(_data);
  }

  @override
  void dispose() {
    widget.parent?.subgroups.remove(_data);
    _scope.dispose();
    super.dispose();
  }

  bool _ok(int i) => i >= 0 && i < _data.slots.length && _data.slots[i].enabled;

  void _focus(int i) {
    if (_ok(i)) _data.slots[i].node.requestFocus();
  }

  void _move(bool forward) {
    final int? next = nextEnabledIndex(
      count: _data.slots.length,
      current: _atFocus(),
      forward: forward,
      isEnabled: _ok,
    );
    if (next != null) _focus(next);
  }

  void _end(bool last) {
    final int? next = last
        ? lastEnabledIndex(_data.slots.length, isEnabled: _ok)
        : firstEnabledIndex(_data.slots.length, isEnabled: _ok);
    if (next != null) _focus(next);
  }

  int _atFocus() {
    for (var i = 0; i < _data.slots.length; i++) {
      if (_data.slots[i].node.hasFocus) return i;
    }
    return -1;
  }

  KeyEventResult _key(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowDown) {
      _move(true);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      _move(false);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.home) {
      _end(false);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.end) {
      _end(true);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      final int i = _atFocus();
      if (i >= 0) _data.slots[i].onOpen?.call();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      // No-op at the root; nested levels close their own popover.
      _data.parent?.closeOthers();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      (widget.onEscape ?? _defaultEscape)();
      return KeyEventResult.handled;
    }
    final String? ch = event.character;
    if (ch != null && ch.trim().isNotEmpty) {
      _typeahead.type(ch);
      final int? hit = _typeahead.match(
        <String>[for (final MenuNavSlot s in _data.slots) s.label ?? ''],
        start: _atFocus() + 1,
        isEnabled: _ok,
      );
      if (hit != null) _focus(hit);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _defaultEscape() {
    final MenuGroupData? p = _data.parent;
    if (p == null) {
      _data.closeAll();
    } else {
      p.closeOthers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Data<MenuGroupData>.inherit(
      data: _data,
      child: Focus(
        focusNode: _scope,
        autofocus: widget.autofocus,
        onKeyEvent: _key,
        child: Builder(
          builder: (context) => widget.builder(context, widget.children),
        ),
      ),
    );
  }
}
