// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizer.dart';

/// Manages the resizing of multiple [ResizableItem]s in a layout.
///
/// This class handles complex resize operations including:
/// - Dragging dividers between items
/// - Expanding and collapsing items
/// - Borrowing and redistributing space between items
/// - Respecting min/max constraints
class Resizer {
  /// The list of resizable items being managed.
  final List<ResizableItem> items;

  /// Ratio threshold for collapsing an item (0.0 to 1.0).
  /// When an item gets smaller than `min + (collapsedSize - min) * collapseRatio`,
  /// it will collapse.
  final double collapseRatio;

  /// Ratio threshold for expanding a collapsed item (0.0 to 1.0).
  /// When dragging past `(min - collapsedSize) * expandRatio`,
  /// a collapsed item will expand.
  final double expandRatio;

  /// Creates a resizer for the given [items].
  ///
  /// [collapseRatio] controls when items collapse (defaults to 0.5).
  /// [expandRatio] controls when collapsed items expand (defaults to 0.5).
  Resizer(
    this.items, {
    this.collapseRatio = 0.5, // half of min size
    this.expandRatio = 0.5, // half of max size
  });

  /// Stores `_couldNotBorrow` state/configuration for this implementation.
  double _couldNotBorrow = 0;

  /// Executes `_payOffLoanSize` behavior for this component/composite.
  double _payOffLoanSize(int index, double delta, int direction) {
    if (direction < 0) {
      for (int i = 0; i < index; i++) {
        /// Stores `borrowedSize` state/configuration for this implementation.
        double borrowedSize = items[i].newValue - items[i].value;
        if (borrowedSize < 0 && delta > 0) {
          /// Stores `newBorrowedSize` state/configuration for this implementation.
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize > 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i].setNewValue(items[i].value + newBorrowedSize);
          return delta;
        } else if (borrowedSize > 0 && delta < 0) {
          /// Stores `newBorrowedSize` state/configuration for this implementation.
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
        /// Stores `borrowedSize` state/configuration for this implementation.
        double borrowedSize = items[i].newValue - items[i].value;
        if (borrowedSize < 0 && delta > 0) {
          /// Stores `newBorrowedSize` state/configuration for this implementation.
          double newBorrowedSize = borrowedSize + delta;
          if (newBorrowedSize > 0) {
            delta = -borrowedSize;
            newBorrowedSize = 0;
          }
          items[i].setNewValue(items[i].value + newBorrowedSize);
          return delta;
        } else if (borrowedSize > 0 && delta < 0) {
          /// Stores `newBorrowedSize` state/configuration for this implementation.
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

  /// Executes `_getItem` behavior for this component/composite.
  ResizableItem? _getItem(int index) {
    if (index < 0 || index >= items.length) {
      return null;
    }
    return items[index];
  }

  /// Executes `_borrowSize` behavior for this component/composite.
  _BorrowInfo _borrowSize(int index, double delta, int until, int direction) {
    assert(direction == -1 || direction == 1, 'Direction must be -1 or 1');
    final item = _getItem(index);
    if (item == null) {
      return _BorrowInfo(0, index - direction);
    }
    if (index == until + direction) {
      return _BorrowInfo(0, index);
    }
    if (!item.resizable) {
      return _BorrowInfo(0, index - direction);
    }

    /// Stores `minSize` state/configuration for this implementation.
    double minSize = item.min;

    /// Stores `maxSize` state/configuration for this implementation.
    double maxSize = item.max;

    if (item.newCollapsed) {
      if ((direction < 0 && delta < 0) || (direction > 0 && delta > 0)) {
        return _borrowSize(index + direction, delta, until, direction);
      }
      return _BorrowInfo(0, index);
    }

    /// Stores `newSize` state/configuration for this implementation.
    double newSize = item.newValue + delta;

    if (newSize < minSize) {
      /// Stores `overflow` state/configuration for this implementation.
      double overflow = newSize - minSize;

      /// Stores `given` state/configuration for this implementation.
      double given = delta - overflow;
      var borrowSize = _borrowSize(
        index + direction,
        overflow,
        until,
        direction,
      );
      item.setNewValue(minSize);
      return _BorrowInfo(borrowSize.givenSize + given, borrowSize.from);
    }

    if (newSize > maxSize) {
      /// Stores `maxOverflow` state/configuration for this implementation.
      double maxOverflow = newSize - maxSize;

      /// Stores `given` state/configuration for this implementation.
      double given = delta - maxOverflow;

      var borrowSize = _borrowSize(
        index + direction,
        maxOverflow,
        until,
        direction,
      );
      item.setNewValue(maxSize);
      return _BorrowInfo(borrowSize.givenSize + given, borrowSize.from);
    }

    item.setNewValue(newSize);
    return _BorrowInfo(delta, index);
  }

  /// Attempts to expand an item at [index] by [delta] in the given [direction].
  ///
  /// [direction] can be -1 (borrow from left), 0 (borrow from both sides),
  /// or 1 (borrow from right).
  /// Returns true if the expansion was successful.
  bool attemptExpand(int index, int direction, double delta) {
    /// Stores `item` state/configuration for this implementation.
    final item = items[index];
    double currentSize = item.newValue; // check
    /// Stores `minSize` state/configuration for this implementation.
    double minSize = item.min;

    /// Stores `maxSize` state/configuration for this implementation.
    double maxSize = item.max;

    /// Stores `newSize` state/configuration for this implementation.
    double newSize = currentSize + delta;

    /// Stores `minOverflow` state/configuration for this implementation.
    double minOverflow = newSize - minSize;

    /// Stores `maxOverflow` state/configuration for this implementation.
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
      var borrowed = _borrowSize(index - 1, -delta, 0, -1);
      if (borrowed.givenSize != -delta) {
        reset();
        return false;
      }
      item.setNewValue((item.newValue + delta).clamp(minSize, maxSize));
      // check
      return true;
    } else if (direction > 0) {
      var borrowed = _borrowSize(index + 1, -delta, items.length - 1, 1);
      if (borrowed.givenSize != -delta) {
        reset();
        return false;
      }
      item.setNewValue((item.newValue + delta).clamp(minSize, maxSize));
      // check
      return true;
    } else if (direction == 0) {
      /// Stores `halfDelta` state/configuration for this implementation.
      double halfDelta = delta / 2;
      var borrowedLeft = _borrowSize(index - 1, -halfDelta, 0, -1);
      var borrowedRight = _borrowSize(
        index + 1,
        -halfDelta,
        items.length - 1,
        1,
      );
      if (borrowedLeft.givenSize != -halfDelta ||
          borrowedRight.givenSize != -halfDelta) {
        reset();
        return false;
      }
      item.setNewValue((item.newValue + delta).clamp(minSize, maxSize));
      // check
      return true;
    }
    return false;
  }

  /// Attempts to collapse an item at [index] in the given [direction].
  ///
  /// [direction] can be -1 (give space to left), 0 (give to both sides),
  /// or 1 (give space to right).
  /// Returns true if the collapse was successful.
  bool attemptCollapse(int index, int direction) {
    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }
    if (direction < 0) {
      /// Stores `item` state/configuration for this implementation.
      final item = items[index];

      /// Stores `collapsedSize` state/configuration for this implementation.
      final collapsedSize = item.collapsedSize ?? 0;

      /// Stores `currentSize` state/configuration for this implementation.
      final currentSize = item.newValue;

      /// Stores `delta` state/configuration for this implementation.
      final delta = currentSize - collapsedSize;
      var borrowed = _borrowSize(index - 1, delta, 0, -1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item.setNewCollapsed(true);
      return true;
    } else if (direction > 0) {
      /// Stores `item` state/configuration for this implementation.
      final item = items[index];

      /// Stores `collapsedSize` state/configuration for this implementation.
      final collapsedSize = item.collapsedSize ?? 0;

      /// Stores `delta` state/configuration for this implementation.
      final delta = item.newValue - collapsedSize;
      var borrowed = _borrowSize(index + 1, delta, items.length - 1, 1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item.setNewCollapsed(true);
      return true;
    } else if (direction == 0) {
      /// Stores `item` state/configuration for this implementation.
      final item = items[index];

      /// Stores `collapsedSize` state/configuration for this implementation.
      final collapsedSize = item.collapsedSize ?? 0;

      /// Stores `delta` state/configuration for this implementation.
      final delta = item.newValue - collapsedSize;

      /// Stores `halfDelta` state/configuration for this implementation.
      final halfDelta = delta / 2;
      var borrowedLeft = _borrowSize(index - 1, halfDelta, 0, -1);
      var borrowedRight = _borrowSize(
        index + 1,
        halfDelta,
        items.length - 1,
        1,
      );
      if (borrowedLeft.givenSize != halfDelta ||
          borrowedRight.givenSize != halfDelta) {
        reset();
        return false;
      }
      item.setNewCollapsed(true);
      return true;
    }
    return false;
  }

  /// Attempts to expand a collapsed item at [index] in the given [direction].
  ///
  /// [direction] can be -1 (borrow from left), 0 (borrow from both sides),
  /// or 1 (borrow from right).
  /// Returns true if the expansion was successful.
  bool attemptExpandCollapsed(int index, int direction) {
    if (index == 0) {
      direction = 1;
    } else if (index == items.length - 1) {
      direction = -1;
    }

    /// Stores `item` state/configuration for this implementation.
    final item = items[index];

    /// Stores `collapsedSize` state/configuration for this implementation.
    final collapsedSize = item.collapsedSize ?? 0;

    /// Stores `currentSize` state/configuration for this implementation.
    final currentSize = item.newValue;

    /// Stores `delta` state/configuration for this implementation.
    final delta = collapsedSize - currentSize;
    if (direction < 0) {
      var borrowed = _borrowSize(index - 1, delta, 0, -1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item.setNewCollapsed(false);
      return true;
    } else if (direction > 0) {
      var borrowed = _borrowSize(index + 1, delta, items.length - 1, 1);
      if (borrowed.givenSize != delta) {
        reset();
        return false;
      }
      item.setNewCollapsed(false);
      return true;
    } else if (direction == 0) {
      /// Stores `halfDelta` state/configuration for this implementation.
      final halfDelta = delta / 2;
      var borrowedLeft = _borrowSize(index - 1, halfDelta, 0, -1);
      var borrowedRight = _borrowSize(
        index + 1,
        halfDelta,
        items.length - 1,
        1,
      );
      if (borrowedLeft.givenSize != halfDelta ||
          borrowedRight.givenSize != halfDelta) {
        reset();
        return false;
      }
      item.setNewCollapsed(false);
      return true;
    }
    return false;
  }

  /// Handles dragging a divider at [index] by [delta] pixels.
  ///
  /// This is the main method for interactive resizing. It redistributes space
  /// between items, handles collapsing/expanding, and respects constraints.
  /// The divider at [index] is between item [index-1] and item [index].
  void dragDivider(int index, double delta) {
    if (delta == 0) {
      return;
    }

    var borrowedLeft = _borrowSize(index - 1, delta, 0, -1);
    var borrowedRight = _borrowSize(index, -delta, items.length - 1, 1);

    /// Stores `borrowedRightSize` state/configuration for this implementation.
    double borrowedRightSize = borrowedRight.givenSize;

    /// Stores `borrowedLeftSize` state/configuration for this implementation.
    double borrowedLeftSize = borrowedLeft.givenSize;

    /// Stores `couldNotBorrowRight` state/configuration for this implementation.
    double couldNotBorrowRight = borrowedRightSize + delta;

    /// Stores `couldNotBorrowLeft` state/configuration for this implementation.
    double couldNotBorrowLeft = borrowedLeftSize - delta;

    if (couldNotBorrowLeft != 0 || couldNotBorrowRight != 0) {
      _couldNotBorrow += delta;
    } else {
      _couldNotBorrow = 0;
    }

    /// Stores `givenBackLeft` state/configuration for this implementation.
    double givenBackLeft = 0;

    /// Stores `givenBackRight` state/configuration for this implementation.
    double givenBackRight = 0;

    if (couldNotBorrowLeft != -couldNotBorrowRight) {
      givenBackLeft =
          /// Creates a `_borrowSize` instance.
          _borrowSize(
            borrowedRight.from,
            -couldNotBorrowLeft,
            index,
            -1,
          ).givenSize;
      givenBackRight =
          /// Creates a `_borrowSize` instance.
          _borrowSize(
            borrowedLeft.from,
            -couldNotBorrowRight,
            index - 1,
            1,
          ).givenSize;
    }

    if (givenBackLeft != -couldNotBorrowLeft ||
        givenBackRight != -couldNotBorrowRight) {
      reset();
      return;
    }

    double payOffLeft = _payOffLoanSize(index - 1, delta, -1);
    double payOffRight = _payOffLoanSize(index, -delta, 1);

    double payingBackLeft = _borrowSize(
      index - 1,
      -payOffLeft,
      0,
      -1,
    ).givenSize;
    double payingBackRight = _borrowSize(
      index,
      -payOffRight,
      items.length - 1,
      1,
    ).givenSize;

    if (payingBackLeft != -payOffLeft || payingBackRight != -payOffRight) {
      reset();
      return;
    }

    if (_couldNotBorrow > 0) {
      /// Stores `start` state/configuration for this implementation.
      int start = borrowedRight.from;

      /// Stores `endNotCollapsed` state/configuration for this implementation.
      int endNotCollapsed = items.length - 1;
      for (int i = endNotCollapsed; i > start; i--) {
        if (items[i].newCollapsed) {
          endNotCollapsed = i - 1;
        } else {
          break;
        }
      }
      if (start == endNotCollapsed) {
        _checkCollapseUntil(index);
      }
      _checkExpanding(index);
    } else if (_couldNotBorrow < 0) {
      /// Stores `start` state/configuration for this implementation.
      int start = borrowedLeft.from;

      /// Stores `endNotCollapsed` state/configuration for this implementation.
      int endNotCollapsed = 0;
      for (int i = endNotCollapsed; i < start; i++) {
        if (items[i].newCollapsed) {
          endNotCollapsed = i + 1;
        } else {
          break;
        }
      }
      if (start == endNotCollapsed) {
        _checkCollapseUntil(index);
      }
      _checkExpanding(index);
    }
  }

  /// Executes `_checkCollapseUntil` behavior for this component/composite.
  void _checkCollapseUntil(int index) {
    if (_couldNotBorrow < 0) {
      for (int i = index - 1; i >= 0; i--) {
        final previousItem = _getItem(i);

        /// Stores `collapsibleSize` state/configuration for this implementation.
        double? collapsibleSize = previousItem?.collapsedSize;
        if (previousItem != null &&
            collapsibleSize != null &&
            !previousItem.newCollapsed) {
          /// Stores `minSize` state/configuration for this implementation.
          var minSize = previousItem.min;
          var threshold = (collapsibleSize - minSize) * collapseRatio;
          if (_couldNotBorrow < threshold) {
            /// Stores `toBorrow` state/configuration for this implementation.
            var toBorrow = minSize - collapsibleSize;
            var borrowed = _borrowSize(index, toBorrow, items.length - 1, 1);

            /// Stores `borrowedSize` state/configuration for this implementation.
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize < toBorrow) {
              reset();
              return;
            }
            previousItem.setNewCollapsed(true);
            previousItem.setNewValue(previousItem.collapsedSize ?? 0);
            previousItem.setValue(previousItem.newValue);
            _couldNotBorrow = 0;
          }
        }
      }
    } else {
      for (int i = index; i < items.length; i++) {
        final nextItem = _getItem(i);

        /// Stores `collapsibleSize` state/configuration for this implementation.
        double? collapsibleSize = nextItem?.collapsedSize;
        if (nextItem != null &&
            collapsibleSize != null &&
            !nextItem.newCollapsed) {
          /// Stores `minSize` state/configuration for this implementation.
          var minSize = nextItem.min;
          var threshold = (collapsibleSize - minSize) * collapseRatio;
          if (_couldNotBorrow > threshold) {
            /// Stores `toBorrow` state/configuration for this implementation.
            var toBorrow = minSize - collapsibleSize;
            var borrowed = _borrowSize(index - 1, toBorrow, 0, -1);

            /// Stores `borrowedSize` state/configuration for this implementation.
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize < toBorrow) {
              reset();
              return;
            }
            nextItem.setNewCollapsed(true);
            nextItem.setNewValue(nextItem.collapsedSize ?? 0);
            nextItem.setValue(nextItem.newValue);
            _couldNotBorrow = 0;
          }
        }
      }
    }
  }

  /// Executes `_checkExpanding` behavior for this component/composite.
  void _checkExpanding(int index) {
    if (_couldNotBorrow > 0) {
      /// Stores `toCheck` state/configuration for this implementation.
      int toCheck = index - 1;
      for (; toCheck >= 0; toCheck--) {
        final item = _getItem(toCheck);

        /// Stores `collapsibleSize` state/configuration for this implementation.
        double? collapsibleSize = item?.collapsedSize;
        if (item != null && item.newCollapsed && collapsibleSize != null) {
          /// Stores `minSize` state/configuration for this implementation.
          double minSize = item.min;
          double threshold = (minSize - collapsibleSize) * expandRatio;
          if (_couldNotBorrow >= threshold) {
            /// Stores `toBorrow` state/configuration for this implementation.
            double toBorrow = collapsibleSize - minSize;
            var borrowed = _borrowSize(toCheck + 1, toBorrow, items.length, 1);

            /// Stores `borrowedSize` state/configuration for this implementation.
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize > toBorrow) {
              reset();
              continue;
            }
            item.setNewCollapsed(false);
            item.setNewValue(minSize);
            item.setValue(minSize);
            _couldNotBorrow = 0;
          }
          break;
        }
      }
    } else if (_couldNotBorrow < 0) {
      /// Stores `toCheck` state/configuration for this implementation.
      int toCheck = index;
      for (; toCheck < items.length; toCheck++) {
        final item = _getItem(toCheck);

        /// Stores `collapsibleSize` state/configuration for this implementation.
        double? collapsibleSize = item?.collapsedSize;
        if (item != null && collapsibleSize != null && item.newCollapsed) {
          /// Stores `minSize` state/configuration for this implementation.
          double minSize = item.min;
          double threshold = (collapsibleSize - minSize) * expandRatio;
          if (_couldNotBorrow <= threshold) {
            /// Stores `toBorrow` state/configuration for this implementation.
            double toBorrow = collapsibleSize - minSize;
            var borrowed = _borrowSize(toCheck - 1, toBorrow, -1, -1);

            /// Stores `borrowedSize` state/configuration for this implementation.
            double borrowedSize = borrowed.givenSize;
            if (borrowedSize > toBorrow) {
              reset();
              continue;
            }
            item.setNewCollapsed(false);
            item.setNewValue(minSize);
            item.setValue(minSize);
            _couldNotBorrow = 0;
          }
          break;
        }
      }
    }
  }

  /// Resets all items to their original state.
  ///
  /// Clears any pending resize operations and restores items to their
  /// original values and collapsed states.
  void reset() {
    for (final item in items) {
      if (item.hasPendingValue) {
        item.resetPending();
      }
    }
  }
}
