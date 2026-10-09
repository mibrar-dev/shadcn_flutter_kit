import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/primitives/drag_sort.dart';

/// Behavioural notes for the fixed implementation:
/// * [resolveDragDropEdge] scores every accepted edge by its normalised
///   distance, so a target that accepts `top` and `bottom` no longer answers
///   `top` for the whole upper half of a wide box (old `_getPosition`);
/// * [DragBounds.clampTranslation] pins an axis to zero when the item is larger
///   than the layer, instead of inverting the drag direction (old
///   `_handleDrag`);
/// * every [ReorderChange] is bounds checked and reports the skip instead of
///   throwing a [RangeError] (old `ListChange` hierarchy);
/// * [reorderIndex] returns the index the moved item will occupy once it is out
///   of the list.
void main() {
  group('resolveDragDropEdge', () {
    test('returns null when nothing is accepted', () {
      expect(resolveDragDropEdge(Offset.zero, const Size(10, 10)), isNull);
    });

    test('a one-sided axis answers with its single edge', () {
      const size = Size(100, 200);
      expect(
        resolveDragDropEdge(const Offset(99, 199), size, acceptTop: true),
        DragDropEdge.top,
      );
      expect(
        resolveDragDropEdge(const Offset(0, 0), size, acceptBottom: true),
        DragDropEdge.bottom,
      );
      expect(
        resolveDragDropEdge(const Offset(99, 0), size, acceptLeft: true),
        DragDropEdge.left,
      );
      expect(
        resolveDragDropEdge(const Offset(0, 199), size, acceptRight: true),
        DragDropEdge.right,
      );
    });

    test('a two-sided axis splits at the midpoint', () {
      const size = Size(100, 200);
      expect(
        resolveDragDropEdge(
          const Offset(50, 10),
          size,
          acceptTop: true,
          acceptBottom: true,
        ),
        DragDropEdge.top,
      );
      expect(
        resolveDragDropEdge(
          const Offset(50, 190),
          size,
          acceptTop: true,
          acceptBottom: true,
        ),
        DragDropEdge.bottom,
      );
      expect(
        resolveDragDropEdge(
          const Offset(10, 100),
          size,
          acceptLeft: true,
          acceptRight: true,
        ),
        DragDropEdge.left,
      );
      expect(
        resolveDragDropEdge(
          const Offset(90, 100),
          size,
          acceptLeft: true,
          acceptRight: true,
        ),
        DragDropEdge.right,
      );
    });

    test('the nearest accepted edge wins on both axes', () {
      // Old behaviour: `top` won for the whole upper half even though the
      // pointer sat right on the left edge of a wide box.
      const size = Size(400, 100);
      expect(
        resolveDragDropEdge(
          const Offset(2, 20),
          size,
          acceptTop: true,
          acceptBottom: true,
          acceptLeft: true,
          acceptRight: true,
        ),
        DragDropEdge.left,
      );
      expect(
        resolveDragDropEdge(
          const Offset(398, 20),
          size,
          acceptTop: true,
          acceptBottom: true,
          acceptLeft: true,
          acceptRight: true,
        ),
        DragDropEdge.right,
      );
      expect(
        resolveDragDropEdge(
          const Offset(200, 98),
          size,
          acceptTop: true,
          acceptBottom: true,
          acceptLeft: true,
          acceptRight: true,
        ),
        DragDropEdge.bottom,
      );
    });

    test('a zero-sized box does not divide by zero', () {
      expect(
        resolveDragDropEdge(
          Offset.zero,
          Size.zero,
          acceptTop: true,
          acceptBottom: true,
        ),
        DragDropEdge.top,
      );
    });

    test('edges know their opposite and their axis', () {
      expect(DragDropEdge.top.opposite, DragDropEdge.bottom);
      expect(DragDropEdge.left.opposite, DragDropEdge.right);
      expect(DragDropEdge.top.isVertical, isTrue);
      expect(DragDropEdge.left.isHorizontal, isTrue);
    });
  });

  group('DragBounds', () {
    test('reads the item corners from a layer transform', () {
      final bounds = DragBounds.fromTransform(
        Matrix4.identity()..translateByDouble(20.0, 30.0, 0, 1),
        const Size(40, 60),
        const Size(200, 200),
      );
      expect(bounds.minOffset, const Offset(20, 30));
      expect(bounds.itemSize, const Size(40, 60));
      expect(bounds.overflowsHorizontally, isFalse);
      expect(bounds.overflowsVertically, isFalse);
    });

    test('clamps the translation to the layer', () {
      const bounds = DragBounds(
        layerSize: Size(200, 200),
        minOffset: Offset.zero,
        maxOffset: Offset(50, 50),
      );
      expect(
        bounds.clampTranslation(Offset.zero, const Offset(10, 10)),
        const Offset(10, 10),
      );
      expect(
        bounds.clampTranslation(const Offset(10, 10), const Offset(500, 500)),
        const Offset(150, 150),
      );
      expect(
        bounds.clampTranslation(const Offset(10, 10), const Offset(-500, -500)),
        Offset.zero,
      );
    });

    test(
      'an item larger than the layer pins the axis instead of inverting',
      () {
        // Old `_handleDrag` clamped with min(low, high) / max(low, high), which
        // turned an inverted range into a drag that moved the ghost backwards.
        const bounds = DragBounds(
          layerSize: Size(100, 100),
          minOffset: Offset.zero,
          maxOffset: Offset(300, 40),
        );
        expect(bounds.overflowsHorizontally, isTrue);
        expect(
          bounds.clampTranslation(const Offset(40, 0), const Offset(10, 5)),
          const Offset(0, 5),
        );
        expect(
          bounds.clampTranslation(const Offset(0, 0), const Offset(-10, 5)),
          const Offset(0, 5),
        );
        // The vertical axis still moves normally.
        expect(bounds.maxTranslationOn(Axis.vertical), 60);
      },
    );

    test('non-finite deltas reset to the origin', () {
      const bounds = DragBounds(
        layerSize: Size(100, 100),
        minOffset: Offset.zero,
        maxOffset: Offset(20, 20),
      );
      expect(
        bounds.clampTranslation(
          const Offset(5, 5),
          const Offset(double.nan, 1),
        ),
        const Offset(0, 6),
      );
      expect(
        bounds.clampTranslation(
          const Offset(5, 5),
          const Offset(1, double.infinity),
        ),
        const Offset(6, 0),
      );
    });

    test('the probe position is the translated item centre', () {
      const bounds = DragBounds(
        layerSize: Size(200, 200),
        minOffset: Offset(10, 20),
        maxOffset: Offset(50, 70),
      );
      expect(
        bounds.probePosition(const Offset(4, 6)),
        const Offset(10 + 4 + 20, 20 + 6 + 25),
      );
    });

    test('toString names the layer and the item', () {
      const bounds = DragBounds(
        layerSize: Size(10, 20),
        minOffset: Offset.zero,
        maxOffset: Offset(4, 8),
      );
      expect(bounds.toString(), contains('DragBounds'));
    });
  });

  group('ReorderChange', () {
    test('a swap exchanges two entries', () {
      final list = <String>['a', 'b', 'c'];
      expect(const ReorderSwap<String>(0, 2).apply(list), isTrue);
      expect(list, <String>['c', 'b', 'a']);
    });

    test('a removal deletes one entry', () {
      final list = <String>['a', 'b', 'c'];
      expect(const ReorderRemove<String>(1).apply(list), isTrue);
      expect(list, <String>['a', 'c']);
    });

    test('an insertion clamps its index', () {
      final list = <String>['a', 'b'];
      expect(const ReorderInsert<String>(99, 'z').apply(list), isTrue);
      expect(list, <String>['a', 'b', 'z']);
      expect(const ReorderInsert<String>(-5, 'y').apply(list), isTrue);
      expect(list, <String>['y', 'a', 'b', 'z']);
    });

    test('out-of-range swap, remove and insert are skipped, not thrown', () {
      // Old `ListSwapChange` / `ListRemoveChange` threw a RangeError here.
      final list = <String>['a'];
      expect(const ReorderSwap<String>(0, 5).apply(list), isFalse);
      expect(const ReorderSwap<String>(-1, 0).apply(list), isFalse);
      expect(const ReorderRemove<String>(7).apply(list), isFalse);
      expect(const ReorderRemove<String>(-2).apply(list), isFalse);
      expect(list, <String>['a']);
    });

    test('changes compare by value', () {
      expect(const ReorderSwap<int>(1, 2), const ReorderSwap<int>(1, 2));
      expect(const ReorderSwap<int>(1, 2), isNot(const ReorderSwap<int>(2, 1)));
      expect(
        const ReorderSwap<int>(1, 2).hashCode,
        const ReorderSwap<int>(1, 2).hashCode,
      );
      expect(const ReorderRemove<int>(1), const ReorderRemove<int>(1));
      expect(const ReorderInsert<int>(1, 9), const ReorderInsert<int>(1, 9));
      expect(
        const ReorderInsert<int>(1, 9),
        isNot(const ReorderInsert<int>(1, 8)),
      );
      expect(const ReorderSwap<int>(1, 2).toString(), 'ReorderSwap(1 -> 2)');
      expect(const ReorderRemove<int>(1).toString(), 'ReorderRemove(1)');
      expect(const ReorderInsert<int>(1, 2).toString(), 'ReorderInsert(1, 2)');
    });
  });

  group('ReorderChanges', () {
    test('applies every change in order', () {
      const changes = ReorderChanges<String>(<ReorderChange<String>>[
        ReorderSwap<String>(0, 1),
        ReorderRemove<String>(0),
        ReorderInsert<String>(0, 'z'),
      ]);
      expect(changes.isNotEmpty, isTrue);
      final list = <String>['a', 'b'];
      expect(changes.apply(list), 3);
      // swap -> [b, a]; remove(0) -> [a]; insert(0, 'z') -> [z, a]
      expect(list, <String>['z', 'a']);
    });

    test('reports how many changes were applied', () {
      const changes = ReorderChanges<String>(<ReorderChange<String>>[
        ReorderSwap<String>(0, 9),
        ReorderRemove<String>(0),
      ]);
      final list = <String>['a', 'b'];
      expect(changes.apply(list), 1);
      expect(list, <String>['b']);
    });

    test('an empty batch changes nothing', () {
      const changes = ReorderChanges<String>(<Never>[]);
      expect(changes.isEmpty, isTrue);
      final list = <String>['a'];
      expect(changes.apply(list), 0);
      expect(changes.appliedTo(list), <String>['a']);
    });

    test('appliedTo works on a copy', () {
      const changes = ReorderChanges<String>(<ReorderChange<String>>[
        ReorderRemove<String>(0),
      ]);
      final list = <String>['a', 'b'];
      expect(changes.appliedTo(list), <String>['b']);
      expect(list, <String>['a', 'b']);
    });
  });

  group('reorderIndex', () {
    test('an empty list always yields zero', () {
      expect(reorderIndex(targetIndex: 3, length: 0), 0);
    });

    test('the index addresses the list without the moved item', () {
      // 'a' pulled out of [a, b, c] leaves [b, c]; index 2 appends it.
      expect(reorderIndex(targetIndex: 2, length: 3), 2);
      expect(reorderIndex(targetIndex: 0, length: 3), 0);
      expect(reorderIndex(targetIndex: 1, length: 3), 1);
    });

    test('indices are clamped into range', () {
      expect(reorderIndex(targetIndex: 99, length: 3), 2);
      expect(reorderIndex(targetIndex: -4, length: 3), 0);
      expect(reorderIndex(targetIndex: 7, length: 1), 0);
    });

    test('the resulting index round-trips a move', () {
      const items = <String>['a', 'b', 'c', 'd'];
      final index = reorderIndex(targetIndex: 3, length: items.length);
      final moved = List<String>.of(items);
      final value = moved.removeAt(0);
      moved.insert(index, value);
      expect(moved, <String>['b', 'c', 'd', 'a']);
    });
  });
}
