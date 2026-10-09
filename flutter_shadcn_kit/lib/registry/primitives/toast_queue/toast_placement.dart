// Toast anchor metadata: swipe directions, placements and slots.
//
// Ported from the old `overlay/toast/toast.dart` (`ToastSwipeDirection`,
// `ToastLocation`) and `ToastController._autoDismissDirections`, plus the
// position/direction enums of
// `overlay/gooey_toast/_impl/core/gooey_toast_models.dart`.

import 'package:flutter/foundation.dart';

/// Directions a toast can be swiped away in.
enum ToastSwipeDirection {
  /// Towards the top of the screen.
  up,

  /// Towards the bottom of the screen.
  down,

  /// Towards the leading edge.
  left,

  /// Towards the trailing edge.
  right,
}

/// Where a toast is anchored on screen.
///
/// The placement is what groups the stack: toasts shown in the same placement
/// share a slot, so `singlePerPlacement` can dismiss the previous one instead of
/// stacking a second toast on top of it.
enum ToastPlacement {
  /// Top, leading edge.
  topLeading,

  /// Horizontally centred, top.
  topCenter,

  /// Top, trailing edge.
  topTrailing,

  /// Bottom, leading edge.
  bottomLeading,

  /// Horizontally centred, bottom.
  bottomCenter,

  /// Bottom, trailing edge.
  bottomTrailing;

  /// Whether the toast sits at the top of the screen.
  bool get isTop =>
      this == ToastPlacement.topLeading ||
      this == ToastPlacement.topCenter ||
      this == ToastPlacement.topTrailing;

  /// Whether the toast is horizontally centred.
  bool get isCenter =>
      this == ToastPlacement.topCenter || this == ToastPlacement.bottomCenter;

  /// Whether the toast sits at the leading edge.
  bool get isLeading =>
      this == ToastPlacement.topLeading || this == ToastPlacement.bottomLeading;

  /// The swipe directions that dismiss a toast anchored here.
  ///
  /// A top toast is swiped away upwards, a bottom toast downwards, and a centred
  /// one in both directions. The old `ToastController._autoDismissDirections`
  /// derived this from raw edge insets, so a `topCenter` toast (left *and* right
  /// set) got no vertical direction at all and could not be swiped away.
  Set<ToastSwipeDirection> get dismissDirections => switch (this) {
    ToastPlacement.topLeading => const <ToastSwipeDirection>{
      ToastSwipeDirection.up,
      ToastSwipeDirection.left,
    },
    ToastPlacement.topCenter => const <ToastSwipeDirection>{
      ToastSwipeDirection.up,
    },
    ToastPlacement.topTrailing => const <ToastSwipeDirection>{
      ToastSwipeDirection.up,
      ToastSwipeDirection.right,
    },
    ToastPlacement.bottomLeading => const <ToastSwipeDirection>{
      ToastSwipeDirection.down,
      ToastSwipeDirection.left,
    },
    ToastPlacement.bottomCenter => const <ToastSwipeDirection>{
      ToastSwipeDirection.down,
    },
    ToastPlacement.bottomTrailing => const <ToastSwipeDirection>{
      ToastSwipeDirection.down,
      ToastSwipeDirection.right,
    },
  };

  /// The direction a dismissing toast leaves towards: away from its edge.
  ToastSwipeDirection get exitDirection =>
      isTop ? ToastSwipeDirection.up : ToastSwipeDirection.down;
}

/// The identity of a toast slot.
///
/// Two toasts share a slot when their placement matches, so `singlePerSlot`
/// can replace rather than accumulate.
@immutable
class ToastSlot {
  /// Creates a slot.
  const ToastSlot(this.placement);

  /// The placement this slot is anchored at.
  final ToastPlacement placement;

  @override
  bool operator ==(Object other) =>
      other is ToastSlot && other.placement == placement;

  @override
  int get hashCode => placement.hashCode;

  @override
  String toString() => 'ToastSlot(${placement.name})';
}
