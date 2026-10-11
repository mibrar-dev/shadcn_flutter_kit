// Widget tests for the `masonry_layout` primitive.
//
// Covers: shortest-column placement (and the stable left-most tie break),
// exact spacing, the responsive column math at 375/768/1024/1440, RTL mirror,
// intrinsic heights, hit testing, tall/short children without overflow, and
// the unbounded-width error.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/masonry_layout.dart';
import 'package:flutter_test/flutter_test.dart';

/// A plain card-sized box of [width] × [height], keyed so tests can locate it.
Widget _box(Key key, double width, double height) => SizedBox(
  key: key,
  width: width,
  height: height,
  child: const ColoredBox(color: Color(0xFF000000)),
);

/// Pins the masonry to the top-left, so child rects read as local coordinates.
Widget _frame({
  required Widget child,
  TextDirection direction = TextDirection.ltr,
}) {
  return Directionality(
    textDirection: direction,
    child: Align(alignment: Alignment.topLeft, child: child),
  );
}

/// Builds a three-column masonry of the given child heights inside a fixed
/// width and returns each child's painted rect, in child order.
Future<List<Rect>> _place(
  WidgetTester tester, {
  required int columns,
  required List<double> heights,
  double width = 330,
  double mainSpacing = 0,
  double crossSpacing = 0,
  TextDirection direction = TextDirection.ltr,
}) async {
  final List<Key> keys = <Key>[
    for (int i = 0; i < heights.length; i++) ValueKey<int>(i),
  ];
  await tester.pumpWidget(
    _frame(
      direction: direction,
      child: SizedBox(
        width: width,
        child: MasonryLayout.fixed(
          crossAxisCount: columns,
          mainAxisSpacing: mainSpacing,
          crossAxisSpacing: crossSpacing,
          children: <Widget>[
            for (int i = 0; i < heights.length; i++)
              _box(keys[i], double.infinity, heights[i]),
          ],
        ),
      ),
    ),
  );
  return <Rect>[for (final Key key in keys) tester.getRect(find.byKey(key))];
}

void main() {
  testWidgets('children pack into the shortest column', (tester) async {
    // 3 columns; `expand: false` keeps the natural height.
    final List<Rect> rects = await _place(
      tester,
      columns: 3,
      heights: <double>[100, 60, 40, 30, 80, 20],
    );
    final double columnWidth = 330 / 3;
    // Column heights after each step: [100 0 0] → [100 60 0] → [100 60 40] →
    // 3 lands on c2 (40) → [100 60 70] → 4 on c1 (60) → [100 140 70] →
    // 5 on c2 (70).
    expect(rects[0].left, 0);
    expect(rects[1].left, columnWidth);
    expect(rects[2].left, columnWidth * 2);
    expect(rects[3].left, columnWidth * 2);
    expect(rects[3].top, 40);
    expect(rects[4].left, columnWidth);
    expect(rects[4].top, 60);
    expect(rects[5].left, columnWidth * 2);
    expect(rects[5].top, 70);
  });

  testWidgets('equal heights round-robin from the left-most column', (
    tester,
  ) async {
    final List<Rect> rects = await _place(
      tester,
      columns: 3,
      heights: <double>[50, 50, 50, 50],
    );
    // A stable left-most tie break means index 3 lands back in column 0.
    expect(rects[3].left, 0);
    expect(rects[3].top, 50);
  });

  testWidgets('spacing is exact and no trailing gap is counted', (
    tester,
  ) async {
    final List<Rect> rects = await _place(
      tester,
      columns: 2,
      heights: <double>[100, 60],
      width: 300,
      mainSpacing: 12,
      crossSpacing: 20,
    );
    final double columnWidth = (300 - 20) / 2;
    expect(rects[0].left, 0);
    expect(rects[0].width, columnWidth);
    expect(rects[1].left, columnWidth + 20);
    // One child per column so far: no vertical gap is applied yet.
    expect(rects[0].top, 0);
    expect(rects[1].top, 0);

    final Size size = tester.getSize(find.byType(MasonryLayout));
    expect(size.width, 300);
    expect(size.height, 100);
  });

  testWidgets('stacked children keep mainAxisSpacing between them', (
    tester,
  ) async {
    final List<Rect> rects = await _place(
      tester,
      columns: 1,
      heights: <double>[40, 30],
      mainSpacing: 10,
    );
    expect(rects[1].top, 50);
    expect(tester.getSize(find.byType(MasonryLayout)).height, 80);
  });

  testWidgets('responsive column count follows the reference rule', (
    tester,
  ) async {
    Future<int> columnsAt(double width) async {
      await tester.pumpWidget(
        _frame(
          child: SizedBox(
            width: width,
            child: MasonryLayout.responsive(
              maxCrossAxisExtent: 100,
              children: const <Widget>[
                SizedBox(width: 100, height: 100),
                SizedBox(width: 100, height: 100),
              ],
            ),
          ),
        ),
      );
      final MasonryLayoutRender render = tester.renderObject(
        find.byType(MasonryLayout),
      );
      return render.columnsFor(width);
    }

    // ceil(width / (100 + 0)); matches SliverGridDelegateWithMaxCrossAxisExtent.
    expect(await columnsAt(375), 4);
    expect(await columnsAt(768), 8);
    expect(await columnsAt(1024), 11);
    expect(await columnsAt(1440), 15);
    // A column is never narrower than the extent.
    expect(await columnsAt(50), 1);
  });

  testWidgets('the layout never uses more columns than it has children', (
    tester,
  ) async {
    const Key first = ValueKey<String>('first');
    const Key second = ValueKey<String>('second');
    await tester.pumpWidget(
      _frame(
        child: const SizedBox(
          width: 300,
          child: MasonryLayout.fixed(
            key: ValueKey<String>('masonry'),
            crossAxisCount: 6,
            children: <Widget>[
              SizedBox(key: first, width: 10, height: 10),
              SizedBox(key: second, width: 10, height: 10),
            ],
          ),
        ),
      ),
    );
    // Two children, six requested columns: each gets its own column, half the
    // width, and nothing is reported as an overflow.
    expect(tester.getRect(find.byKey(first)).width, 150);
    expect(tester.getRect(find.byKey(first)).left, 0);
    expect(tester.getRect(find.byKey(second)).width, 150);
    expect(tester.getRect(find.byKey(second)).left, 150);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rtl mirrors the column order', (tester) async {
    final List<Rect> rects = await _place(
      tester,
      columns: 2,
      heights: <double>[10, 20],
      width: 200,
      direction: TextDirection.rtl,
    );
    // Column 0 (child 0) now sits on the right.
    expect(rects[0].left, 100);
    expect(rects[1].left, 0);
  });

  testWidgets('intrinsic height replays the packing', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Center(
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: MasonryLayout.fixed(
                    crossAxisCount: 2,
                    children: const <Widget>[
                      SizedBox(width: 40, height: 80),
                      SizedBox(width: 40, height: 20),
                      SizedBox(width: 40, height: 60),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // 2 columns: column 0 gets 80, column 1 gets 20 + 60 = 80.
    expect(
      tester.getSize(find.byType(MasonryLayout)).height,
      closeTo(80, 0.01),
    );
  });

  testWidgets('a hit test lands on the child painted at that offset', (
    tester,
  ) async {
    await _place(tester, columns: 2, heights: <double>[100, 60]);
    final MasonryLayoutRender masonry = tester.renderObject(
      find.byType(MasonryLayout),
    );
    final RenderBox child = tester.renderObject(
      find.byKey(const ValueKey<int>(1)),
    );
    // Column 1's child is the short one (60 of the 100 tall box), so its
    // centre is inside the masonry and below it is empty space.
    final Offset insideChild = tester
        .getRect(find.byKey(const ValueKey<int>(1)))
        .center;
    // `HitTestResult.path` runs innermost-first, so the child (or the box it
    // paints) leads and the masonry closes it.
    final BoxHitTestResult hit = BoxHitTestResult();
    expect(masonry.hitTest(hit, position: insideChild), isTrue);
    expect(hit.path.last.target, same(masonry));
    expect(hit.path.any((HitTestEntry e) => e.target == child), isTrue);

    // 80 px down the short column: inside the masonry, past its last child.
    final BoxHitTestResult miss = BoxHitTestResult();
    expect(masonry.hitTest(miss, position: const Offset(250, 80)), isFalse);
    expect(miss.path, isEmpty);
  });

  testWidgets('very tall and very short children do not overflow', (
    tester,
  ) async {
    await _place(
      tester,
      columns: 3,
      heights: <double>[10, 400, 5, 200, 1, 320],
      width: 300,
      crossSpacing: 16,
      mainSpacing: 16,
    );
    expect(tester.takeException(), isNull);
    final RenderBox render = tester.renderObject(find.byType(MasonryLayout));
    expect(render.size.height, 400);
  });

  testWidgets('no children is an empty box', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const SizedBox(
          width: 100,
          child: MasonryLayout.fixed(crossAxisCount: 3, children: <Widget>[]),
        ),
      ),
    );
    final RenderBox render = tester.renderObject(find.byType(MasonryLayout));
    expect(render.size, const Size(100, 0));
  });

  testWidgets('works inside a scroll view', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: SingleChildScrollView(
          child: SizedBox(
            width: 200,
            child: MasonryLayout.fixed(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              children: const <Widget>[
                SizedBox(height: 300),
                SizedBox(height: 200),
                SizedBox(height: 500),
              ],
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    // 2 columns, 8 px gaps: c0 = 300, c1 = 200 + 8 + 500.
    expect(tester.getSize(find.byType(MasonryLayout)).height, 708);
  });

  test('an unbounded width throws a clear error', () {
    final MasonryLayoutRender render = MasonryLayoutRender(
      crossAxisCount: 2,
      maxCrossAxisExtent: null,
      mainAxisSpacing: 0,
      crossAxisSpacing: 0,
      textDirection: TextDirection.ltr,
    );
    // `RenderObject` reports (does not rethrow) a layout error, so capture the
    // report instead of expecting a throw.
    final List<String> errors = <String>[];
    final void Function(FlutterErrorDetails)? previous = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      errors.add(details.exceptionAsString());
      previous?.call(details);
    };
    try {
      render.layout(const BoxConstraints());
    } finally {
      FlutterError.onError = previous;
    }
    expect(
      errors,
      isNotEmpty,
      reason: 'a masonry inside an unbounded Row must report an error',
    );
    expect(
      errors.first,
      contains('MasonryLayout was laid out with an unbounded width'),
    );
    expect(errors.first, contains('SizedBox'));
  });
}
