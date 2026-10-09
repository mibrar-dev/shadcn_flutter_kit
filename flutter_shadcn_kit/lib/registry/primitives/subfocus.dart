// Public interfaces of the hierarchical focus system used by menus, command
// palettes and similar keyboard-navigable lists.
//
// Ported from `shared/primitives/subfocus.dart` + `_impl/**`. The widget and
// state implementations live in `subfocus_item.dart` / `subfocus_scope.dart`
// so each file stays readable.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';

/// Builds the child of a [SubFocus] from its focus state.
typedef SubFocusBuilder =
    Widget Function(BuildContext context, SubFocusState state);

/// Builds the child of a [SubFocusScope] from its scope state.
typedef SubFocusScopeBuilder =
    Widget Function(BuildContext context, SubFocusScopeState state);

/// Focus interface of a single item inside a [SubFocusScope].
mixin SubFocusState {
  /// Render box of this item, or null when unmounted.
  RenderBox? findRenderObject();

  /// Scrolls this item into view.
  void ensureVisible({
    ScrollPositionAlignmentPolicy alignmentPolicy =
        ScrollPositionAlignmentPolicy.explicit,
  });

  /// Whether this item currently has focus.
  bool get isFocused;

  /// Whether this item can receive focus.
  bool get isEnabled;

  /// Requests focus from the parent scope.
  bool requestFocus();

  /// Invokes [intent] on this item's actions.
  Object? invokeAction(Intent intent);

  /// Number of times this item has received focus.
  int get focusCount;

  /// Called by the parent scope to update the focus state.
  void markFocused(bool focused);

  /// Removes focus from this item.
  bool unfocus();
}

/// Scope interface managing the focus order of its [SubFocus] children.
mixin SubFocusScopeState {
  /// Invokes [intent] on the currently focused child.
  Object? invokeActionOnFocused(Intent intent);

  /// Moves focus to the nearest child in [direction].
  bool nextFocus([TraversalDirection direction = TraversalDirection.down]);

  /// Nearest ancestor scope, or null.
  static SubFocusScopeState? maybeOf(BuildContext context) {
    return Data.maybeOf<SubFocusScopeState>(context);
  }

  /// Detaches [child] from this scope.
  void detach(SubFocusState child);

  /// Attaches [child] to this scope.
  bool attach(SubFocusState child);

  /// Transfers focus to [child].
  bool requestFocus(SubFocusState child);

  /// Removes focus from [child].
  bool unfocus(SubFocusState child);
}
