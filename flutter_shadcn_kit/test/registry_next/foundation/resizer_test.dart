import 'package:flutter_shadcn_kit/registry_next/foundation/resizable_item.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/resizer.dart';
import 'package:flutter_test/flutter_test.dart';

ResizableItem item(
  double value, {
  double min = 0,
  double max = 500,
  double? collapsedSize,
}) {
  return ResizableItem(
    value: value,
    min: min,
    max: max,
    collapsedSize: collapsedSize,
  );
}

void main() {
  test('dragDivider borrows from the neighbouring item', () {
    final items = [item(100), item(100)];
    final resizer = Resizer(items);

    resizer.dragDivider(1, 20);

    expect(items[0].newValue, 120);
    expect(items[1].newValue, 80);
    expect(items[0].hasPendingValue, isTrue);

    resizer.reset();
    expect(items[0].hasPendingValue, isFalse);
    expect(items[0].newValue, 100);
  });

  test('attemptExpand borrows from the left', () {
    final items = [item(100), item(100)];
    final resizer = Resizer(items);

    expect(resizer.attemptExpand(1, -1, 10), isTrue);
    expect(items[0].newValue, 90);
    expect(items[1].newValue, 110);
  });

  test('attemptExpand clamps to the item max', () {
    final items = [item(100, max: 105), item(100)];
    final resizer = Resizer(items);

    expect(resizer.attemptExpand(0, 1, 20), isTrue);
    expect(items[0].newValue, 105);
    expect(items[1].newValue, 95);
  });

  test('attemptExpand fails and resets when the min blocks the borrow', () {
    final items = [item(100), item(100, min: 95)];
    final resizer = Resizer(items);

    expect(resizer.attemptExpand(0, 1, 20), isFalse);
    expect(items[0].hasPendingValue, isFalse);
    expect(items[1].hasPendingValue, isFalse);
  });

  test('attemptCollapse and attemptExpandCollapsed round-trip', () {
    final items = [item(100), item(100, collapsedSize: 0), item(100)];
    final resizer = Resizer(items);

    expect(resizer.attemptCollapse(1, 0), isTrue);
    expect(items[1].newCollapsed, isTrue);
    expect(items[0].newValue, 150);
    expect(items[2].newValue, 150);

    expect(resizer.attemptExpandCollapsed(1, 0), isTrue);
    expect(items[1].newCollapsed, isFalse);
    expect(items[0].newValue, 100);
    expect(items[2].newValue, 100);
  });

  test('ResizableItem tracks value, pending state and collapsed state', () {
    final entry = ResizableItem(
      value: 40,
      min: 10,
      max: 80,
      collapsed: true,
      collapsedSize: 5,
    );
    expect(entry.value, 40);
    expect(entry.newValue, 40);
    expect(entry.newCollapsed, isTrue);
    expect(entry.hasPendingValue, isFalse);

    entry.setNewValue(30);
    entry.setNewCollapsed(false);
    expect(entry.newValue, 30);
    expect(entry.newCollapsed, isFalse);
    expect(entry.hasPendingValue, isTrue);

    entry.resetPending();
    expect(entry.hasPendingValue, isFalse);
    expect(entry.newValue, 40);
    expect(entry.newCollapsed, isTrue);
  });
}
