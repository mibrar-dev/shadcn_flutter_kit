import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/extensions.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/menu_group.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/slider_value.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(data: const ShadcnThemeData(), child: child),
  );
}

void main() {
  testWidgets('WidgetExtension wraps widgets in layout containers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        Center(
          child: SizedBox(
            width: 100,
            child: Row(
              children: [
                const Text('x')
                    .withPadding(all: 8)
                    .withOpacity(0.5)
                    .withAlign(Alignment.center)
                    .expanded(),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.byType(Padding), findsOneWidget);
    expect(find.byType(Opacity), findsOneWidget);
    expect(find.byType(Align), findsWidgets);
    expect(find.byType(Expanded), findsOneWidget);

    final padding = tester.widget<Padding>(find.byType(Padding));
    expect(padding.padding, const EdgeInsets.all(8));
  });

  testWidgets('WidgetExtension.sized and .constrained keep existing sizes', (
    tester,
  ) async {
    final sized =
        const SizedBox(width: 10, height: 20).sized(width: 30) as SizedBox;
    expect(sized.width, 30);
    expect(sized.height, 20);

    final constrained =
        const SizedBox().constrained(width: 40, height: 50) as ConstrainedBox;
    expect(
      constrained.constraints,
      const BoxConstraints.tightFor(width: 40, height: 50),
    );
    await tester.pumpWidget(_wrap(const SizedBox()));
  });

  testWidgets('ColumnExtension.gap inserts separators between children', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        Center(
          child: Column(
            children: const [
              SizedBox(width: 10, height: 10),
              SizedBox(width: 10, height: 10),
              SizedBox(width: 10, height: 10),
            ],
          ).gap(4),
        ),
      ),
    );

    final gaps = tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .where((box) => box.height == 4);
    expect(gaps.length, 2);
  });

  testWidgets('IconExtensions merge the theme under the ambient icon theme', (
    tester,
  ) async {
    // `IconThemeData.merge(inherited)` lets the ambient value win for every
    // non-null field; the extension supplies `theme.iconTheme.small` as the
    // base. `IconTheme.of` resolves the ambient fallback (size 24, black).
    late IconThemeData applied;
    final probe = Builder(
      builder: (context) {
        applied = IconTheme.of(context);
        return const SizedBox();
      },
    );

    await tester.pumpWidget(
      _wrap(
        IconTheme(
          data: const IconThemeData(size: 20, color: Color(0xFF112233)),
          child: probe.iconSmall(),
        ),
      ),
    );
    expect(applied.size, 20);
    expect(applied.color, const Color(0xFF112233));

    await tester.pumpWidget(_wrap(probe.iconSmall()));
    expect(applied.size, 24);
  });

  test('DoubleExtension and IntExtension provide min/max', () {
    expect(2.0.min(3.0), 2.0);
    expect(2.0.max(3.0), 3.0);
    expect(2.min(3), 2);
    expect(2.max(3), 3);
  });

  test('SliderValue rounds and lerps single and ranged values', () {
    const single = SliderValue.single(1.234);
    expect(single.isRanged, isFalse);
    expect(single.roundToDivisions(10).value, 1.2);

    const ranged = SliderValue.ranged(1.0, 2.0);
    expect(ranged.isRanged, isTrue);
    final rounded = ranged.roundToDivisions(4);
    expect(rounded.start, 1.0);
    expect(rounded.end, 2.0);

    final lerped = SliderValue.lerp(
      const SliderValue.single(0),
      const SliderValue.single(10),
      0.5,
    );
    expect(lerped!.value, 5);
    expect(
      SliderValue.lerp(
        const SliderValue.single(0),
        const SliderValue.ranged(0, 1),
        0.5,
      ),
      isNull,
    );
  });

  test('MenuGroupData carries the axis', () {
    const data = MenuGroupData(direction: Axis.horizontal);
    expect(data.direction, Axis.horizontal);
  });
}
