import 'resizable_item.dart';
import 'resizer_engine.dart';

/// Manages the resizing of multiple [ResizableItem]s in a layout.
///
/// Handles dragging dividers, expanding/collapsing items, borrowing and
/// redistributing space between items and respecting min/max constraints.
class Resizer {
  /// The list of resizable items being managed.
  final List<ResizableItem> items;

  /// Ratio threshold for collapsing an item (0.0 to 1.0).
  ///
  /// When an item gets smaller than `min + (collapsedSize - min) *
  /// collapseRatio`, it collapses.
  final double collapseRatio;

  /// Ratio threshold for expanding a collapsed item (0.0 to 1.0).
  final double expandRatio;

  late final ResizerEngine _engine = ResizerEngine(
    items,
    collapseRatio: collapseRatio,
    expandRatio: expandRatio,
  );

  Resizer(this.items, {this.collapseRatio = 0.5, this.expandRatio = 0.5});

  /// Attempts to expand the item at [index] by [delta] in [direction].
  ///
  /// [direction] can be -1 (borrow from left), 0 (borrow from both sides) or
  /// 1 (borrow from right). Returns true when the expansion succeeded.
  bool attemptExpand(int index, int direction, double delta) {
    final item = items[index];
    double currentSize = item.newValue;
    double minSize = item.min;
    double maxSize = item.max;
    double newSize = currentSize + delta;
    double minOverflow = newSize - minSize;
    double maxOverflow = newSize - maxSize;

    if (minOverflow < 0 && delta < 0) {
      delta = delta - minOverflow;
    }

    if (maxOverflow > 0 && delta > 0) {
      delta = delta - maxOverflow;
    }

    if (delta == 0) {
      return false;
    }

    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }
    if (direction < 0) {
      var borrowed = _engine.borrowSize(index - 1, -delta, 0, -1);
      if (borrowed.givenSize != -delta) {
        _engine.reset();
        return false;
      }
      item.setNewValue((item.newValue + delta).clamp(minSize, maxSize));
      return true;
    } else if (direction > 0) {
      var borrowed = _engine.borrowSize(index + 1, -delta, items.length - 1, 1);
      if (borrowed.givenSize != -delta) {
        _engine.reset();
        return false;
      }
      item.setNewValue((item.newValue + delta).clamp(minSize, maxSize));
      return true;
    } else if (direction == 0) {
      double halfDelta = delta / 2;
      var borrowedLeft = _engine.borrowSize(index - 1, -halfDelta, 0, -1);
      var borrowedRight = _engine.borrowSize(
        index + 1,
        -halfDelta,
        items.length - 1,
        1,
      );
      if (borrowedLeft.givenSize != -halfDelta ||
          borrowedRight.givenSize != -halfDelta) {
        _engine.reset();
        return false;
      }
      item.setNewValue((item.newValue + delta).clamp(minSize, maxSize));
      return true;
    }
    return false;
  }

  /// Attempts to collapse the item at [index] in [direction].
  ///
  /// [direction] can be -1 (give space to left), 0 (give to both sides) or
  /// 1 (give space to right). Returns true when the collapse succeeded.
  bool attemptCollapse(int index, int direction) {
    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }
    if (direction < 0) {
      final item = items[index];
      final collapsedSize = item.collapsedSize ?? 0;
      final currentSize = item.newValue;
      final delta = currentSize - collapsedSize;
      var borrowed = _engine.borrowSize(index - 1, delta, 0, -1);
      if (borrowed.givenSize != delta) {
        _engine.reset();
        return false;
      }
      item.setNewCollapsed(true);
      return true;
    } else if (direction > 0) {
      final item = items[index];
      final collapsedSize = item.collapsedSize ?? 0;
      final delta = item.newValue - collapsedSize;
      var borrowed = _engine.borrowSize(index + 1, delta, items.length - 1, 1);
      if (borrowed.givenSize != delta) {
        _engine.reset();
        return false;
      }
      item.setNewCollapsed(true);
      return true;
    } else if (direction == 0) {
      final item = items[index];
      final collapsedSize = item.collapsedSize ?? 0;
      final delta = item.newValue - collapsedSize;
      final halfDelta = delta / 2;
      var borrowedLeft = _engine.borrowSize(index - 1, halfDelta, 0, -1);
      var borrowedRight = _engine.borrowSize(
        index + 1,
        halfDelta,
        items.length - 1,
        1,
      );
      if (borrowedLeft.givenSize != halfDelta ||
          borrowedRight.givenSize != halfDelta) {
        _engine.reset();
        return false;
      }
      item.setNewCollapsed(true);
      return true;
    }
    return false;
  }

  /// Attempts to expand a collapsed item at [index] in [direction].
  ///
  /// [direction] can be -1 (borrow from left), 0 (borrow from both sides) or
  /// 1 (borrow from right). Returns true when the expansion succeeded.
  bool attemptExpandCollapsed(int index, int direction) {
    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }

    final item = items[index];
    final collapsedSize = item.collapsedSize ?? 0;
    final currentSize = item.newValue;
    final delta = collapsedSize - currentSize;
    if (direction < 0) {
      var borrowed = _engine.borrowSize(index - 1, delta, 0, -1);
      if (borrowed.givenSize != delta) {
        _engine.reset();
        return false;
      }
      item.setNewCollapsed(false);
      return true;
    } else if (direction > 0) {
      var borrowed = _engine.borrowSize(index + 1, delta, items.length - 1, 1);
      if (borrowed.givenSize != delta) {
        _engine.reset();
        return false;
      }
      item.setNewCollapsed(false);
      return true;
    } else if (direction == 0) {
      final halfDelta = delta / 2;
      var borrowedLeft = _engine.borrowSize(index - 1, halfDelta, 0, -1);
      var borrowedRight = _engine.borrowSize(
        index + 1,
        halfDelta,
        items.length - 1,
        1,
      );
      if (borrowedLeft.givenSize != halfDelta ||
          borrowedRight.givenSize != halfDelta) {
        _engine.reset();
        return false;
      }
      item.setNewCollapsed(false);
      return true;
    }
    return false;
  }

  /// Handles dragging the divider at [index] by [delta] pixels.
  ///
  /// The divider at [index] is between item [index - 1] and item [index].
  void dragDivider(int index, double delta) {
    if (delta == 0) {
      return;
    }

    var borrowedLeft = _engine.borrowSize(index - 1, delta, 0, -1);
    var borrowedRight = _engine.borrowSize(index, -delta, items.length - 1, 1);

    double borrowedRightSize = borrowedRight.givenSize;
    double borrowedLeftSize = borrowedLeft.givenSize;
    double couldNotBorrowRight = borrowedRightSize + delta;
    double couldNotBorrowLeft = borrowedLeftSize - delta;

    if (couldNotBorrowLeft != 0 || couldNotBorrowRight != 0) {
      _engine.couldNotBorrow += delta;
    } else {
      _engine.couldNotBorrow = 0;
    }

    double givenBackLeft = 0;
    double givenBackRight = 0;

    if (couldNotBorrowLeft != -couldNotBorrowRight) {
      givenBackLeft = _engine
          .borrowSize(borrowedRight.from, -couldNotBorrowLeft, index, -1)
          .givenSize;
      givenBackRight = _engine
          .borrowSize(borrowedLeft.from, -couldNotBorrowRight, index - 1, 1)
          .givenSize;
    }

    if (givenBackLeft != -couldNotBorrowLeft ||
        givenBackRight != -couldNotBorrowRight) {
      _engine.reset();
      return;
    }

    double payOffLeft = _engine.payOffLoanSize(index - 1, delta, -1);
    double payOffRight = _engine.payOffLoanSize(index, -delta, 1);

    double payingBackLeft = _engine
        .borrowSize(index - 1, -payOffLeft, 0, -1)
        .givenSize;
    double payingBackRight = _engine
        .borrowSize(index, -payOffRight, items.length - 1, 1)
        .givenSize;

    if (payingBackLeft != -payOffLeft || payingBackRight != -payOffRight) {
      _engine.reset();
      return;
    }

    if (_engine.couldNotBorrow > 0) {
      int start = borrowedRight.from;
      int endNotCollapsed = items.length - 1;
      for (int i = endNotCollapsed; i > start; i--) {
        if (items[i].newCollapsed) {
          endNotCollapsed = i - 1;
        } else {
          break;
        }
      }
      if (start == endNotCollapsed) {
        _engine.checkCollapseUntil(index);
      }
      _engine.checkExpanding(index);
    } else if (_engine.couldNotBorrow < 0) {
      int start = borrowedLeft.from;
      int endNotCollapsed = 0;
      for (int i = endNotCollapsed; i < start; i++) {
        if (items[i].newCollapsed) {
          endNotCollapsed = i + 1;
        } else {
          break;
        }
      }
      if (start == endNotCollapsed) {
        _engine.checkCollapseUntil(index);
      }
      _engine.checkExpanding(index);
    }
  }

  /// Resets all items to their committed sizes and collapsed states.
  void reset() {
    _engine.reset();
  }
}
