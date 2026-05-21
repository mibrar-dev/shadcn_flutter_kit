// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../subfocus.dart';

/// _SubFocusScopeState defines a reusable type for this registry module.
class _SubFocusScopeState extends State<SubFocusScope> with SubFocusScopeState {
  /// Stores `_attachedStates` state/configuration for this implementation.
  final List<SubFocusState> _attachedStates = [];

  /// Stores `_currentState` state/configuration for this implementation.
  SubFocusState? _currentState;

  /// Stores `_active` state/configuration for this implementation.
  bool _active = true;

  @override
  /// Executes `unfocus` behavior for this component/composite.
  bool unfocus(SubFocusState child) {
    if (_currentState == child) {
      _currentState?.markFocused(false);
      _currentState = null;
      return true;
    }
    return false;
  }

  @override
  /// Executes `activate` behavior for this component/composite.
  void activate() {
    super.activate();
    _active = true;
  }

  @override
  /// Executes `deactivate` behavior for this component/composite.
  void deactivate() {
    _active = false;
    super.deactivate();
  }

  @override
  /// Executes `invokeActionOnFocused` behavior for this component/composite.
  Object? invokeActionOnFocused(Intent intent) {
    return _currentState?.invokeAction(intent);
  }

  @override
  /// Executes `attach` behavior for this component/composite.
  bool attach(SubFocusState state) {
    /// Creates a `assert` instance.
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
  /// Executes `detach` behavior for this component/composite.
  void detach(SubFocusState state) {
    _attachedStates.remove(state);
    if (_currentState == state) {
      _currentState = null;
      if (widget.autofocus) findFirstFocus(); // Find new focus
    }
  }

  /// Executes `_setCurrentItem` behavior for this component/composite.
  void _setCurrentItem(SubFocusState item, bool? forward) {
    if (!mounted || !_active) {
      return;
    }

    /// Stores `currentItem` state/configuration for this implementation.
    final currentItem = _currentState;
    if (!mounted || !_active) {
      return;
    }
    currentItem?.markFocused(false);
    item.markFocused(true);

    /// Creates a `item.ensureVisible` instance.
    item.ensureVisible(
      alignmentPolicy: forward == null
          ? ScrollPositionAlignmentPolicy.explicit
          : forward
          ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
          : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
    );
    _currentState = item;
  }

  /// Executes `findRenderObject` behavior for this component/composite.
  RenderBox? findRenderObject() {
    if (!mounted || !_active) {
      return null;
    }
    return context.findRenderObject() as RenderBox?;
  }

  @override
  /// Executes `nextFocus` behavior for this component/composite.
  bool nextFocus([TraversalDirection direction = TraversalDirection.down]) {
    if (!mounted || !_active) return false;
    if (_currentState != null) {
      final RenderBox? currentBox = _currentState!.findRenderObject();
      final RenderBox? parentBox = findRenderObject();
      if (currentBox == null || parentBox == null) {
        return false;
      }
      final Offset currentOffset = currentBox.localToGlobal(
        Offset.zero,
        ancestor: parentBox,
      );

      /// Stores `horizontal` state/configuration for this implementation.
      late final bool horizontal;

      /// Stores `forward` state/configuration for this implementation.
      late final bool forward;
      switch (direction) {
        case TraversalDirection.down:
          horizontal = false;
          forward = true;
          break;
        case TraversalDirection.up:
          horizontal = false;
          forward = false;
          break;
        case TraversalDirection.right:
          horizontal = true;
          forward = true;
          break;
        case TraversalDirection.left:
          horizontal = true;
          forward = false;
          break;
      }

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

  /// Executes `findFirstFocus` behavior for this component/composite.
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
      // find very first focus based on top left or top right (based on directionality)
      (SubFocusState, double)? nearestItem;
      final direction = Directionality.of(context);
      RenderBox? parentBox = findRenderObject();
      if (parentBox == null) return;
      Offset anchor = direction == TextDirection.ltr
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
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Data<SubFocusScopeState>.inherit(
      data: this,
      child: widget.builder?.call(context, this),
    );
  }

  @override
  /// Executes `requestFocus` behavior for this component/composite.
  bool requestFocus(SubFocusState child) {
    if (!mounted || !_active) return false;
    _currentState?.markFocused(false);
    _currentState = child;
    _currentState!.markFocused(true);
    return true;
  }
}
