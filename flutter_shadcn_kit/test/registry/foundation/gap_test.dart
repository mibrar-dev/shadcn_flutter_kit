import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/gap.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Gap sizes along the Row main axis', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Row(children: const [Gap(10), SizedBox(width: 5, height: 20)]),
      ),
    );
    expect(tester.getSize(find.byType(Gap)), const Size(10, 0));
  });

  testWidgets('Gap sizes along the Column main axis', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          children: const [Gap(10), SizedBox(width: 20, height: 5)],
        ),
      ),
    );
    expect(tester.getSize(find.byType(Gap)), const Size(0, 10));
  });

  testWidgets('Gap honours crossAxisExtent', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Row(children: const [Gap(4, crossAxisExtent: 12)]),
      ),
    );
    expect(tester.getSize(find.byType(Gap)), const Size(4, 12));
  });

  testWidgets('Gap works inside a ListView', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ListView(children: const [Gap(6), SizedBox(height: 40), Gap(8)]),
      ),
    );
    final sizes = <Size>[
      tester.getSize(find.byType(Gap).at(0)),
      tester.getSize(find.byType(Gap).at(1)),
    ];
    expect(sizes, hasLength(2));
    expect(sizes[0].height, 6);
    expect(sizes[1].height, 8);
    expect(sizes[0].width, 800);
  });

  testWidgets('SliverGap works inside a CustomScrollView', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CustomScrollView(
          slivers: const [
            SliverGap(8),
            SliverToBoxAdapter(child: SizedBox(height: 100)),
            SliverGap(12),
          ],
        ),
      ),
    );
    final slivers = tester
        .renderObjectList<RenderSliverGap>(find.byType(SliverGap))
        .toList();
    expect(slivers, hasLength(2));
    expect(slivers[0].geometry!.scrollExtent, 8);
    expect(slivers[1].geometry!.scrollExtent, 12);
  });
}
