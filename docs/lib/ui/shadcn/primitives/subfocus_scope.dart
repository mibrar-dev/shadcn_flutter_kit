// The focus scope that orders its [SubFocus] children.
//
// Ported from `shared/primitives/subfocus.dart` + `_impl/core/sub_focus_scope.dart`
// and `_impl/state/__sub_focus_scope_state.dart`.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';
import 'subfocus.dart';

/// Manages keyboard focus across its [SubFocus] children.
///
/// The scope owns the ordered list of attached items, routes intents to the
/// focused item and moves focus to the nearest item in a direction.
class SubFocusScope extends StatefulWidget {
  /// Builds the subtree from this scope's state. When null the scope is an
  /// invisible provider.
  final SubFocusScopeBuilder? builder;

  /// Whether the first attached item is focused automatically.
  final bool autofocus;

  /// Creates a sub-focus scope.
  const SubFocusScope({super.key, this.builder, this.autofocus = false});

  @override
  State<SubFocusScope> createState() => _SubFocusScopeState();
}

class _SubFocusScopeState extends State<SubFocusScope> with SubFocusScopeState {
  final List<SubFocusState> _attachedStates = [];
  SubFocusState? _currentState;
  bool _active = true;

  @override
  bool unfocus(SubFocusState child) {
    if (_currentState == child) {
      _currentState?.markFocused(false);
      _currentState = null;
      return true;
    }
    return false;
  }

  @override
  void activate() {
    super.activate();
    _active = true;
  }

  @override
  void deactivate() {
    _active = false;
    super.deactivate();
  }

  @override
  Object? invokeActionOnFocused(Intent intent) {
    return _currentState?.invokeAction(intent);
  }

  @override
  bool attach(SubFocusState state) {
    assert(
      !_attachedStates.contains(state),
      'SubFocusState is already attached to this SubFocusScope.',
    );
    _attachedStates.add(state);
    if (widget.autofocus) {
      _currentState ??= state;
    }
    return _currentState == state;
  }

  @override
  void detach(SubFocusState state) {
    _attachedStates.remove(state);
    if (_currentState == state) {
      _currentState = null;
      if (widget.autofocus) findFirstFocus();
    }
  }

  void _setCurrentItem(SubFocusState item, bool? forward) {
    if (!mounted || !_active) {
      return;
    }
    final currentItem = _currentState;
    if (!mounted || !_active) {
      return;
    }
    currentItem?.markFocused(false);
    item.markFocused(true);
    item.ensureVisible(
      alignmentPolicy: forward == null
          ? ScrollPositionAlignmentPolicy.explicit
          : forward
          ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
          : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );
    _currentState = item;
  }

  RenderBox? _findRenderObject() {
    if (!mounted || !_active) {
      return null;
    }
    return context.findRenderObject() as RenderBox?;
  }

  @override
  bool nextFocus([TraversalDirection direction = TraversalDirection.down]) {
    if (!mounted || !_active) return false;
    if (_currentState != null) {
      final RenderBox? currentBox = _currentState!.findRenderObject();
      final RenderBox? parentBox = _findRenderObject();
      if (currentBox == null || parentBox == null) {
        return false;
      }
      final Offset currentOffset = currentBox.localToGlobal(
        Offset.zero,
        ancestor: parentBox,
      );
      final (horizontal, forward) = switch (direction) {
        TraversalDirection.down => (false, true),
        TraversalDirection.up => (false, false),
        TraversalDirection.right => (true, true),
        TraversalDirection.left => (true, false),
      };

      (SubFocusState, double)? nearestNextItem;
      for (final attached in _attachedStates) {
        if (attached == _currentState) continue;
        final RenderBox? box = attached.findRenderObject();
        if (box == null) continue;
        final Offset offset = box.localToGlobal(
          Offset.zero,
          ancestor: parentBox,
        );
        final double delta = horizontal
            ? (forward
                  ? (offset.dx - currentOffset.dx)
                  : (currentOffset.dx - offset.dx))
            : (forward
                  ? (offset.dy - currentOffset.dy)
                  : (currentOffset.dy - offset.dy));
        if (delta <= 0) continue;
        if (nearestNextItem == null || delta < nearestNextItem.$2) {
          nearestNextItem = (attached, delta);
        }
      }
      if (nearestNextItem != null) {
        _setCurrentItem(nearestNextItem.$1, forward);
        return true;
      }
    } else if (!widget.autofocus) {
      findFirstFocus();
      return true;
    }
    return false;
  }

  /// Focuses the most recently focused item, else the item nearest to the
  /// leading corner for the ambient text direction.
  void findFirstFocus() {
    if (!mounted || !_active) return;
    (SubFocusState, int)? mostItem;
    for (final attached in _attachedStates) {
      if (attached.focusCount > 0 &&
          attached.focusCount > (mostItem?.$2 ?? 0)) {
        mostItem = (attached, attached.focusCount);
      }
    }
    if (mostItem != null) {
      _setCurrentItem(mostItem.$1, null);
    } else {
      (SubFocusState, double)? nearestItem;
      final direction = Directionality.of(context);
      final RenderBox? parentBox = _findRenderObject();
      if (parentBox == null) return;
      final Offset anchor = direction == TextDirection.ltr
          ? Offset.zero
          : Offset(parentBox.size.width, 0);
      for (final attached in _attachedStates) {
        if (attached == mostItem?.$1) continue;
        final box = attached.findRenderObject();
        if (box == null) continue;
        final offset = box.localToGlobal(Offset.zero);
        final distance = (offset - anchor).distance;
        if (nearestItem == null || distance < nearestItem.$2) {
          nearestItem = (attached, distance);
        }
      }
      if (nearestItem != null) {
        _setCurrentItem(nearestItem.$1, null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Data<SubFocusScopeState>.inherit(
      data: this,
      child: widget.builder?.call(context, this),
    );
  }

  @override
  bool requestFocus(SubFocusState child) {
    if (!mounted || !_active || !child.isEnabled) return false;
    _currentState?.markFocused(false);
    _currentState = child;
    _currentState!.markFocused(true);
    return true;
  }
}
