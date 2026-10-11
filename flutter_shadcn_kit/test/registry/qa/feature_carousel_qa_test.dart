// QA for `feature_carousel` (P7-Q1): behaviour, spacing, robustness.
//
// Regression cover for: the title using `mutedForeground` instead of
// `foreground`, the hard-coded arrow radius vs the theme radius, the
// double-rebuild in `_go`, the autoplay restart on any parent rebuild, the
// fixed 420 viewport overflowing 375px stages, the undisposed inline
// controller in the `Cards only` preview, and the unscaled title/CTA fonts.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/feature_carousel/feature_carousel.dart';
import 'package:flutter_shadcn_kit/registry/components/feature_carousel/preview.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const List<FeatureCarouselItem> _items = <FeatureCarouselItem>[
  FeatureCarouselItem(
    title: 'Fast',
    description: 'Ship in seconds.',
    icon: IconData(0x1, fontFamily: 't'),
  ),
  FeatureCarouselItem(
    title: 'Safe',
    description: 'Every deploy is immutable.',
    icon: IconData(0x2, fontFamily: 't'),
  ),
];

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  final Widget body = SizedBox(width: width == null ? 480 : null, child: child);
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null ? body : SizedBox(width: width, child: child),
      ),
    ),
  );
}

Color? _textColor(WidgetTester tester, String text) {
  return tester.widget<Text>(find.text(text)).style?.color;
}

double? _textSize(WidgetTester tester, String text) {
  return tester.widget<Text>(find.text(text)).style?.fontSize;
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in featureCarouselPreviews) {
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
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
        // Never settle: autoplay owns a periodic timer. Unmount so the next
        // preview starts from a clean timer.
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }
  });

  testWidgets('the title uses foreground, the description mutedForeground', (
    tester,
  ) async {
    final FeatureCarouselController controller = FeatureCarouselController(
      autoPlay: false,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(FeatureCarousel(items: _items, controller: controller)),
    );
    await tester.pump();
    expect(_textColor(tester, 'Fast'), ShadcnColors.lightFallback.foreground);
    expect(
      _textColor(tester, 'Ship in seconds.'),
      ShadcnColors.lightFallback.mutedForeground,
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the arrow radius follows the theme radius', (tester) async {
    final FeatureCarouselController controller = FeatureCarouselController(
      autoPlay: false,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        FeatureCarousel(
          items: _items,
          controller: controller,
          theme: const FeatureCarouselTheme(radius: 20),
        ),
      ),
    );
    await tester.pump();
    final Clickable arrow = tester.widget<Clickable>(
      find.byType(Clickable).at(0),
    );
    final BoxDecoration decoration =
        arrow.decoration!.resolve(<WidgetState>{})! as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(20));
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the next arrow advances exactly once per tap', (tester) async {
    final FeatureCarouselController controller = FeatureCarouselController(
      autoPlay: false,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(FeatureCarousel(items: _items, controller: controller)),
    );
    await tester.pump();
    await tester.tap(find.byType(Clickable).at(1));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Safe'), findsOneWidget);
    expect(controller.index, 1);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a parent rebuild does not restart the autoplay clock', (
    tester,
  ) async {
    final FeatureCarouselController controller = FeatureCarouselController(
      autoPlay: true,
      autoPlayInterval: const Duration(milliseconds: 80),
    );
    addTearDown(controller.dispose);
    Widget buildCarousel() =>
        FeatureCarousel(items: _items, controller: controller);
    await tester.pumpWidget(_frame(buildCarousel()));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Fast'), findsOneWidget);
    // An unrelated parent rebuild must not reset the 80ms clock.
    await tester.pumpWidget(_frame(buildCarousel()));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Safe'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('title and CTA fonts scale with the theme', (tester) async {
    final FeatureCarouselController controller = FeatureCarouselController(
      autoPlay: false,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        SingleChildScrollView(
          child: FeatureCarousel(items: _items, controller: controller),
        ),
        data: const ShadcnThemeData(scaling: 2),
      ),
    );
    await tester.pump();
    expect(_textSize(tester, 'Fast'), 36);
    expect(_textSize(tester, controller.primaryActionLabel), 32);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('the carousel fits 375px with no overflow', (tester) async {
    final FeatureCarouselController controller = FeatureCarouselController(
      autoPlay: false,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        FeatureCarousel(items: _items, controller: controller),
        width: 375,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Fast'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    final FeatureCarouselController controller = FeatureCarouselController(
      autoPlay: false,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        FeatureCarousel(items: _items, controller: controller),
        direction: TextDirection.rtl,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Fast'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
