import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/primitives/toast_queue/toast_placement.dart';

/// Behavioural note for the fixed placement metadata: a centred toast still gets
/// its vertical dismiss direction. The old
/// `ToastController._autoDismissDirections` derived directions from raw edge
/// insets, so a top-centre toast (left *and* right set) received none at all.
void main() {
  group('ToastPlacement', () {
    test('knows its edge of the screen', () {
      expect(ToastPlacement.topLeading.isTop, isTrue);
      expect(ToastPlacement.topCenter.isTop, isTrue);
      expect(ToastPlacement.topTrailing.isTop, isTrue);
      expect(ToastPlacement.bottomLeading.isTop, isFalse);
      expect(ToastPlacement.bottomCenter.isTop, isFalse);
      expect(ToastPlacement.bottomTrailing.isTop, isFalse);
    });

    test('knows its horizontal alignment', () {
      expect(ToastPlacement.topCenter.isCenter, isTrue);
      expect(ToastPlacement.bottomCenter.isCenter, isTrue);
      expect(ToastPlacement.topLeading.isCenter, isFalse);
      expect(ToastPlacement.topTrailing.isCenter, isFalse);
    });

    test('knows its leading edge', () {
      expect(ToastPlacement.topLeading.isLeading, isTrue);
      expect(ToastPlacement.bottomLeading.isLeading, isTrue);
      expect(ToastPlacement.topCenter.isLeading, isFalse);
      expect(ToastPlacement.topTrailing.isLeading, isFalse);
      expect(ToastPlacement.bottomTrailing.isLeading, isFalse);
    });

    test('a centred toast still swipes away vertically', () {
      // Old behaviour: directions came from raw edge insets, so a centred toast
      // (left and right both set) had no vertical direction.
      expect(ToastPlacement.topCenter.dismissDirections, <ToastSwipeDirection>{
        ToastSwipeDirection.up,
      });
      expect(
        ToastPlacement.bottomCenter.dismissDirections,
        <ToastSwipeDirection>{ToastSwipeDirection.down},
      );
    });

    test('a corner toast swipes away along both of its edges', () {
      expect(
        ToastPlacement.topTrailing.dismissDirections,
        <ToastSwipeDirection>{
          ToastSwipeDirection.up,
          ToastSwipeDirection.right,
        },
      );
      expect(
        ToastPlacement.bottomLeading.dismissDirections,
        <ToastSwipeDirection>{
          ToastSwipeDirection.down,
          ToastSwipeDirection.left,
        },
      );
    });

    test('every placement has at least one dismiss direction', () {
      for (final placement in ToastPlacement.values) {
        expect(placement.dismissDirections, isNotEmpty, reason: placement.name);
      }
    });
  });

  group('ToastSlot', () {
    test('slots compare by placement', () {
      expect(const ToastSlot(ToastPlacement.topCenter), isNotNull);
      expect(
        const ToastSlot(ToastPlacement.topCenter),
        const ToastSlot(ToastPlacement.topCenter),
      );
      expect(
        const ToastSlot(ToastPlacement.topCenter).hashCode,
        const ToastSlot(ToastPlacement.topCenter).hashCode,
      );
      expect(
        const ToastSlot(ToastPlacement.topCenter),
        isNot(const ToastSlot(ToastPlacement.bottomCenter)),
      );
      expect(
        const ToastSlot(ToastPlacement.topCenter).toString(),
        'ToastSlot(topCenter)',
      );
    });
  });
}
