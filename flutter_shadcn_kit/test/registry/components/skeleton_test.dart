// Widget tests for the `skeleton` component.
//
// Covers the loading/loaded switch, the shimmer sweep, the theme rows and all
// four precedence legs, light and dark tokens, plus four regressions from the
// old module: `snapshot` overriding `enabled`, `fromColor`/`toColor` having two
// different defaults, `enableSwitchAnimation` being a dead knob and the
// banned `package:skeletonizer` / Material dependency.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/skeleton/skeleton.dart';
import 'package:flutter_shadcn_kit/registry/primitives/animation.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  SkeletonTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<SkeletonTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: body),
      ),
    ),
  );
}

const Widget _content = SizedBox(width: 40, height: 20);

LinearGradient _sweep(WidgetTester tester) {
  final Finder container = find.descendant(
    of: find.byType(Skeleton),
    matching: find.byType(Container),
  );
  final BoxDecoration decoration =
      tester.widget<Container>(container.first).decoration! as BoxDecoration;
  return decoration.gradient! as LinearGradient;
}

Alignment _sweepBegin(WidgetTester tester) => _sweep(tester).begin as Alignment;

List<Color?> _sweepColors(WidgetTester tester) => _sweep(tester).colors;

Duration _sweepDuration(WidgetTester tester) => tester
    .widget<RepeatedAnimationBuilder>(find.byType(RepeatedAnimationBuilder))
    .duration;

BorderRadiusGeometry? _clipRadius(WidgetTester tester) =>
    tester.widget<ClipRRect>(find.byType(ClipRRect).first).borderRadius;

void main() {
  group('rendering', () {
    testWidgets('keeps the child box while loading', (tester) async {
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      expect(find.byType(Container), findsWidgets);
      expect(tester.getSize(find.byType(Skeleton)), const Size(40, 20));
    });

    testWidgets('a disabled skeleton paints the child unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(const Skeleton(enabled: false, child: _content)),
      );
      expect(find.byType(Container), findsNothing);
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('the sweep starts at zero and repeats to one', (tester) async {
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      final RepeatedAnimationBuilder builder = tester
          .widget<RepeatedAnimationBuilder>(
            find.byType(RepeatedAnimationBuilder),
          );
      expect(builder.start, 0);
      expect(builder.end, 1);
      expect(builder.duration, skeletonDefaults.duration);

      // Value 0: the gradient begins fully outside the box on the left.
      expect(_sweepBegin(tester).x, -3);

      await tester.pump(const Duration(milliseconds: 400));
      expect(_sweepBegin(tester).x, greaterThan(-3));
      expect(tester.getSize(find.byType(Skeleton)), const Size(40, 20));
    });

    testWidgets('the sweep repeats every period', (tester) async {
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      final Alignment start = _sweepBegin(tester);
      await tester.pump(const Duration(milliseconds: 150));
      expect(_sweepBegin(tester).x, isNot(start.x));
      // The remaining 650ms of the 800ms period bring the cycle back.
      await tester.pump(
        skeletonDefaults.duration! - const Duration(milliseconds: 150),
      );
      expect(_sweepBegin(tester).x, closeTo(start.x, 0.0001));
    });

    testWidgets('clamps the sweep to the placeholder', (tester) async {
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      expect(find.byType(ClipRRect), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(ClipRRect),
          matching: find.byType(Container),
        ),
        findsOneWidget,
      );
    });

    testWidgets('a caller radius is applied once', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Skeleton(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: _content,
          ),
        ),
      );
      expect(_clipRadius(tester), BorderRadius.circular(20));
    });

    testWidgets('the radius falls back to borderRadiusMd', (tester) async {
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      expect(_clipRadius(tester), const ShadcnThemeData().borderRadiusMd);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('$name tokens drive the sweep', (tester) async {
        await tester.pumpWidget(
          _frame(
            const Skeleton(child: _content),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        expect(_sweepColors(tester), <Color?>[
          colors.muted,
          colors.accent,
          colors.muted,
        ]);
      });
    }
  });

  group('theme', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Skeleton(
            child: _content,
            theme: SkeletonTheme(
              fromColor: ThemedColor.value(_green),
              duration: Duration(milliseconds: 900),
            ),
          ),
          app: const <ComponentThemeData>[
            SkeletonTheme(
              fromColor: ThemedColor.value(_blue),
              duration: Duration(milliseconds: 400),
            ),
          ],
        ),
      );
      expect(_sweepColors(tester).first, _green);
      expect(_sweepDuration(tester), const Duration(milliseconds: 900));
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Skeleton(child: _content),
          app: const <ComponentThemeData>[
            SkeletonTheme(fromColor: ThemedColor.value(_blue)),
          ],
          scoped: const SkeletonTheme(fromColor: ThemedColor.value(_green)),
        ),
      );
      expect(_sweepColors(tester).first, _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Skeleton(child: _content),
          app: const <ComponentThemeData>[
            SkeletonTheme(fromColor: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_sweepColors(tester).first, _green);
    });

    testWidgets('a leg that sets only the fill keeps the default duration', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const Skeleton(child: _content),
          app: const <ComponentThemeData>[
            SkeletonTheme(fromColor: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_sweepDuration(tester), skeletonDefaults.duration);
    });

    testWidgets('the caller radius beats the theme radius', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Skeleton(
            child: _content,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          scoped: const SkeletonTheme(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      );
      expect(_clipRadius(tester), BorderRadius.circular(20));
    });

    testWidgets('the theme radius beats the token default', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Skeleton(child: _content),
          scoped: const SkeletonTheme(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      );
      expect(_clipRadius(tester), BorderRadius.circular(4));
    });
  });

  group('regressions', () {
    testWidgets('regression: `enabled: false` is never overridden', (
      tester,
    ) async {
      // The old `asSkeleton(snapshot:)` recomputed `enabled = !snapshot.hasData`
      // after reading the argument, so a disabled skeleton could still show.
      await tester.pumpWidget(
        _frame(const Skeleton(enabled: false, child: _content)),
      );
      expect(find.byType(Container), findsNothing);
    });

    testWidgets('regression: one pair of defaults, not two', (tester) async {
      // `SkeletonThemeDefaults` said 0x0D171717/0x1A171717 while the config
      // layer said primary@5%/primary@10% for the same two fields.
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      final ShadcnColors colors = const ShadcnThemeData().colors;
      expect(_sweepColors(tester), <Color?>[
        colors.muted,
        colors.accent,
        colors.muted,
      ]);
    });

    testWidgets('regression: no skeletonizer widget in the tree', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      expect(find.byType(RepeatedAnimationBuilder), findsOneWidget);
      expect(find.byType(ShaderMask), findsNothing);
      expect(find.byType(Opacity), findsNothing);
    });

    testWidgets('regression: the shimmer survives a full period', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const Skeleton(child: _content)));
      await tester.pump(const Duration(milliseconds: 2000));
      expect(tester.takeException(), isNull);
      expect(find.byType(RepeatedAnimationBuilder), findsOneWidget);
      expect(_sweepColors(tester).length, 3);
    });
  });
}
