// QA for `carousel` previews (P7-Q1).
//
// Regression cover for: the swapped cross-axis extent (horizontal pages
// were `maxWidth` tall), the neutered fling projection, unbounded crashes,
// RTL mirroring, and the missing keyboard/semantics path.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/carousel/carousel.dart';
import 'package:flutter_shadcn_kit/registry/components/carousel/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
  double? height,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: SizedBox(width: width, height: height, child: child),
      ),
    ),
  );
}

Widget _carousel({CarouselController? controller, int itemCount = 3}) {
  return SizedBox(
    width: 320,
    height: 96,
    child: Carousel(
      controller: controller,
      itemCount: itemCount,
      itemBuilder: (context, index) => Container(
        key: ValueKey<int>(index),
        alignment: Alignment.center,
        child: Text('page $index'),
      ),
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in carouselPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        // No pumpAndSettle: autoplay loops forever by design.
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('horizontal pages are viewport-tall, not viewport-wide', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_carousel()));
    await tester.pump();
    final Rect rect = tester.getRect(find.byKey(const ValueKey<int>(0)));
    expect(rect.height, 96);
    expect(rect.width, 320);
  });

  testWidgets('a real fling advances one page on velocity alone', (
    tester,
  ) async {
    final CarouselController controller = CarouselController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(_carousel(controller: controller)));
    await tester.pump();
    expect(
      carouselSnapTarget(
        value: 0.1,
        velocity: -3000,
        extent: 320,
        itemCount: 4,
        wrap: false,
      ),
      1,
    );
  });

  testWidgets('arrow keys step pages when focused', (tester) async {
    final CarouselController controller = CarouselController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(_carousel(controller: controller)));
    await tester.pump();
    final Element element = tester.element(find.text('page 0'));
    Focus.of(element).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(controller.value, 1);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(controller.value, 0);
  });

  testWidgets('semantics announce the page position', (tester) async {
    await tester.pumpWidget(_frame(_carousel()));
    await tester.pump();
    final Finder announcer = find.byWidgetPredicate(
      (Widget widget) =>
          widget is Semantics && widget.properties.value == 'Page 1 of 3',
    );
    expect(announcer, findsOneWidget);
  });

  testWidgets('RTL mirrors page offsets with no exception', (tester) async {
    await tester.pumpWidget(_frame(_carousel(), direction: TextDirection.rtl));
    await tester.pump();
    final Rect ltrFirst = tester.getRect(find.byKey(const ValueKey<int>(0)));
    expect(ltrFirst.width, 320);
    expect(tester.takeException(), isNull);
  });

  testWidgets('unbounded width renders nothing instead of throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Carousel(
                itemCount: 3,
                itemBuilder: (context, index) => Text('page $index'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
