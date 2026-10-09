import 'resizable_item.dart';

/// Result of a borrow attempt: how much space was actually borrowed and from
/// which item index.
typedef BorrowResult = ({double givenSize, int from});

/// Internal helper of [Resizer]: owns the borrowed-space bookkeeping and the
/// collapse/expand thresholds. Public only so `resizer.dart` can share it;
/// not part of the layer's public API.
class ResizerEngine {
  /// The list of resizable items being managed.
  final List<ResizableItem> items;

  /// Ratio threshold for collapsing an item (0.0 to 1.0).
  final double collapseRatio;

  /// Ratio threshold for expanding a collapsed item (0.0 to 1.0).
  final double expandRatio;

  /// Pending unfulfilled borrow, signed.
  double couldNotBorrow = 0;

  ResizerEngine(this.items, {this.collapseRatio = 0.5, this.expandRatio = 0.5});

  /// Returns the item at [index], or null when out of bounds.
  ResizableItem? getItem(int index) {
    if (index < 0 || index >= items.length) {
      return null;
    }
    return items[index];
  }

  /// Pays back loans between [index] and the given [direction].
  double payOffLoanSize(int index, double delta, int direction) {
    if (direction < 0) {
      for (int i = 0; i < index; i++) {
        double borrowedSize = items[i].newValue - items[i].value;
        if (borrowedSize < 0 && delta > 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize > 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i].setNewValue(items[i].value + newBorrowedSize);
          return delta;
        } else if (borrowedSize > 0 && delta < 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize < 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i].setNewValue(items[i].value + newBorrowedSize);
          return delta;
        }
      }
    } else if (direction > 0) {
      for (int i = items.length - 1; i > index; i--) {
        double borrowedSize = items[i].newValue - items[i].value;
        if (borrowedSize < 0 && delta > 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize > 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i].setNewValue(items[i].value + newBorrowedSize);
          return delta;
        } else if (borrowedSize > 0 && delta < 0) {
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize < 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i].setNewValue(items[i].value + newBorrowedSize);
          return delta;
        }
      }
    }
    return 0;
  }

  /// Borrows [delta] for the item at [index], walking towards [until] in
  /// [direction] (-1 or 1). Returns how much was actually borrowed and from
  /// where.
  BorrowResult borrowSize(int index, double delta, int until, int direction) {
    assert(direction == -1 || direction == 1, 'Direction must be -1 or 1');
    final item = getItem(index);
    if (item == null) {
      return (givenSize: 0, from: index - direction);
    }
    if (index == until + direction) {
      return (givenSize: 0, from: index);
    }
    if (!item.resizable) {
      return (givenSize: 0, from: index - direction);
    }

    double minSize = item.min;
    double maxSize = item.max;

    if (item.newCollapsed) {
      if ((direction < 0 && delta < 0) || (direction > 0 && delta > 0)) {
        return borrowSize(index + direction, delta, until, direction);
      }
      return (givenSize: 0, from: index);
    }

    double newSize = item.newValue + delta;

    if (newSize < minSize) {
      double overflow = newSize - minSize;
      double given = delta - overflow;
      var borrowSize = this.borrowSize(
        index + direction,
        overflow,
        until,
        direction,
      );
      item.setNewValue(minSize);
      return (givenSize: borrowSize.givenSize + given, from: borrowSize.from);
    }

    if (newSize > maxSize) {
      double maxOverflow = newSize - maxSize;
      double given = delta - maxOverflow;
      var borrowSize = this.borrowSize(
        index + direction,
        maxOverflow,
        until,
        direction,
      );
      item.setNewValue(maxSize);
      return (givenSize: borrowSize.givenSize + given, from: borrowSize.from);
    }

    item.setNewValue(newSize);
    return (givenSize: delta, from: index);
  }

  /// Collapses items near [index] when more space could not be borrowed.
  void checkCollapseUntil(int index) {
    if (couldNotBorrow < 0) {
      for (int i = index - 1; i >= 0; i--) {
        final previousItem = getItem(i);
        double? collapsibleSize = previousItem?.collapsedSize;
        if (previousItem != null &&
            collapsibleSize != null &&
            !previousItem.newCollapsed) {
          var minSize = previousItem.min;
          var threshold = (collapsibleSize - minSize) * collapseRatio;
          if (couldNotBorrow < threshold) {
            var toBorrow = minSize - collapsibleSize;
            var borrowed = borrowSize(index, toBorrow, items.length - 1, 1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize < toBorrow) {
              reset();
              return;
            }
            previousItem.setNewCollapsed(true);
            previousItem.setNewValue(previousItem.collapsedSize ?? 0);
            previousItem.setValue(previousItem.newValue);
            couldNotBorrow = 0;
          }
        }
      }
    } else {
      for (int i = index; i < items.length; i++) {
        final nextItem = getItem(i);
        double? collapsibleSize = nextItem?.collapsedSize;
        if (nextItem != null &&
            collapsibleSize != null &&
            !nextItem.newCollapsed) {
          var minSize = nextItem.min;
          var threshold = (collapsibleSize - minSize) * collapseRatio;
          if (couldNotBorrow > threshold) {
            var toBorrow = minSize - collapsibleSize;
            var borrowed = borrowSize(index - 1, toBorrow, 0, -1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize < toBorrow) {
              reset();
              return;
            }
            nextItem.setNewCollapsed(true);
            nextItem.setNewValue(nextItem.collapsedSize ?? 0);
            nextItem.setValue(nextItem.newValue);
            couldNotBorrow = 0;
          }
        }
      }
    }
  }

  /// Expands collapsed items near [index] when enough space was borrowed.
  void checkExpanding(int index) {
    if (couldNotBorrow > 0) {
      int toCheck = index - 1;
      for (; toCheck >= 0; toCheck--) {
        final item = getItem(toCheck);
        double? collapsibleSize = item?.collapsedSize;
        if (item != null && item.newCollapsed && collapsibleSize != null) {
          double minSize = item.min;
          double threshold = (minSize - collapsibleSize) * expandRatio;
          if (couldNotBorrow >= threshold) {
            double toBorrow = collapsibleSize - minSize;
            var borrowed = borrowSize(toCheck + 1, toBorrow, items.length, 1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize > toBorrow) {
              reset();
              continue;
            }
            item.setNewCollapsed(false);
            item.setNewValue(minSize);
            item.setValue(minSize);
            couldNotBorrow = 0;
          }
          break;
        }
      }
    } else if (couldNotBorrow < 0) {
      int toCheck = index;
      for (; toCheck < items.length; toCheck++) {
        final item = getItem(toCheck);
        double? collapsibleSize = item?.collapsedSize;
        if (item != null && collapsibleSize != null && item.newCollapsed) {
          double minSize = item.min;
          double threshold = (collapsibleSize - minSize) * expandRatio;
          if (couldNotBorrow <= threshold) {
            double toBorrow = collapsibleSize - minSize;
            var borrowed = borrowSize(toCheck - 1, toBorrow, -1, -1);
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize > toBorrow) {
              reset();
              continue;
            }
            item.setNewCollapsed(false);
            item.setNewValue(minSize);
            item.setValue(minSize);
            couldNotBorrow = 0;
          }
          break;
        }
      }
    }
  }

  /// Clears pending resize values on every item.
  void reset() {
    for (final item in items) {
      if (item.hasPendingValue) {
        item.resetPending();
      }
    }
  }
}
