// Roving-focus group scope: the register/unregister bookkeeping a single-select
// or tabbed container needs so its arrow keys can walk its items.
//
// Generic on purpose — the `radio_group` component is the first user, but a
// `menu`, `select` or `tabs` row needs exactly the same thing and must not
// re-implement it. The caller owns the traversal policy (`FocusTraversalGroup`)
// and what "moving" means; this file keeps the ordered registrations and the
// focus handle.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/data.dart';

/// Moves the roving selection to the next enabled member.
class NextRovingItemIntent extends Intent {
  /// Creates a next-member intent.
  const NextRovingItemIntent();
}

/// Moves the roving selection to the previous enabled member.
class PreviousRovingItemIntent extends Intent {
  /// Creates a previous-member intent.
  const PreviousRovingItemIntent();
}

/// One registered member of a roving group.
class RovingItem<T> {
  /// Creates a registration.
  const RovingItem({
    required this.key,
    required this.value,
    required this.enabled,
    required this.selected,
    required this.requestFocus,
  });

  /// The member's own key, so the group can drop the entry again.
  final Object key;

  /// The value the member stands for.
  final T value;

  /// Whether the member can be reached.
  final bool enabled;

  /// Whether the member is the current one.
  final bool selected;

  /// Moves focus to the member.
  final VoidCallback requestFocus;
}

/// The members of one roving group.
///
/// A member registers from its own `build`, so [ordered] is tree order.
class RovingGroupRegistry<T> {
  final List<RovingItem<T>> _items = <RovingItem<T>>[];

  /// Adds or replaces a member's registration.
  void register(RovingItem<T> item) {
    final int index = _items.indexWhere(
      (RovingItem<T> entry) => entry.key == item.key,
    );
    if (index >= 0) {
      _items[index] = item;
      return;
    }
    _items.add(item);
  }

  /// Drops a member's registration.
  void unregister(Object key) =>
      _items.removeWhere((RovingItem<T> item) => item.key == key);

  /// The members in registration order.
  List<RovingItem<T>> ordered() => List<RovingItem<T>>.unmodifiable(_items);

  /// Whether the arrow keys walk top to bottom ([Axis.vertical]) or left to
  /// right ([Axis.horizontal]).
  Axis direction = Axis.vertical;

  /// Called with the value the walk landed on, before focus moves there.
  void Function(T value)? onSelect;

  /// Walks [delta] positions from the current member, skipping disabled ones and
  /// wrapping around, reports the landing value and focuses that member.
  ///
  /// When nothing is selected the walk starts before the first member for a
  /// positive [delta] and after the last for a negative one, so the first arrow
  /// press lands on an end rather than on the second item. Null when there is
  /// nothing to land on.
  RovingItem<T>? move(int delta) {
    final List<RovingItem<T>> items = ordered();
    if (items.isEmpty) {
      return null;
    }
    final int current = items.indexWhere((RovingItem<T> item) => item.selected);
    final int start = current < 0 ? (delta > 0 ? -1 : 0) : current;
    for (int step = 1; step <= items.length; step++) {
      int next = (start + delta * step) % items.length;
      if (next < 0) {
        next += items.length;
      }
      final RovingItem<T> candidate = items[next];
      if (candidate.enabled) {
        onSelect?.call(candidate.value);
        candidate.requestFocus();
        return candidate;
      }
    }
    return null;
  }

  /// The arrow-key map a member hands to its own `Clickable`.
  ///
  /// `Clickable` binds the arrow keys to directional focus traversal, and the
  /// nearest `Shortcuts` wins, so a group that wrapped its members in its own
  /// `Shortcuts` would never be reached. Handing the map to each member puts
  /// the traversal in front of that default instead.
  Map<LogicalKeySet, Intent> get shortcuts =>
      direction == Axis.vertical ? _vertical : _horizontal;

  static final Map<LogicalKeySet, Intent> _vertical = <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.arrowDown): const NextRovingItemIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowUp): const PreviousRovingItemIntent(),
  };

  static final Map<LogicalKeySet, Intent> _horizontal = <LogicalKeySet, Intent>{
    LogicalKeySet(LogicalKeyboardKey.arrowRight): const NextRovingItemIntent(),
    LogicalKeySet(LogicalKeyboardKey.arrowLeft):
        const PreviousRovingItemIntent(),
  };

  /// The action map that goes with [shortcuts].
  Map<Type, Action<Intent>> get actions => <Type, Action<Intent>>{
    NextRovingItemIntent: CallbackAction<NextRovingItemIntent>(
      onInvoke: (NextRovingItemIntent intent) {
        move(1);
        return null;
      },
    ),
    PreviousRovingItemIntent: CallbackAction<PreviousRovingItemIntent>(
      onInvoke: (PreviousRovingItemIntent intent) {
        move(-1);
        return null;
      },
    ),
  };

  /// The scope the members are wrapped in. Goes through `Data` so a member
  /// resolves it with `Data.maybeOf<RovingGroupRegistry<T>>(context)`.
  RovingGroupScope<T> scope({required Widget child}) =>
      RovingGroupScope<T>(registry: this, child: child);
}

/// Provides one [RovingGroupRegistry] to the members of a group.
class RovingGroupScope<T> extends StatelessWidget {
  /// Creates the scope.
  const RovingGroupScope({
    super.key,
    required this.registry,
    required this.child,
  });

  /// Wraps the members in the scope.
  final Widget child;

  /// The registry the members write to.
  final RovingGroupRegistry<T> registry;

  @override
  Widget build(BuildContext context) =>
      Data<RovingGroupRegistry<T>>.inherit(data: registry, child: child);
}
