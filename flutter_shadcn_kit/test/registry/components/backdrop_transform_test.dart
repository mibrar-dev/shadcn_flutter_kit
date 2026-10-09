// Widget tests for the `backdrop_transform` component.
//
// Covers the identity transform, the scale curve, the root clip, the freed
// layout space and the three regressions from the old module: the root
// `resolveExtraSize` formula was algebraically zero, `minScale` was unchecked
// and `scaleAt` extrapolated outside 0..1.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/backdrop_transform/backdrop_transform.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Size _size = Size(300, 200);

Widget _frame(Widget child, {ShadcnThemeData data = const ShadcnThemeData()}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  );
}

/// Wraps a `backdrop` label with [transform] at progress [t].
Widget _wrapped(
  BackdropTransform transform, {
  double t = 1,
  bool isRoot = true,
  ShadcnThemeData data = const ShadcnThemeData(),
}) {
  return _frame(
    Builder(
      builder: (context) => transform.wrapBackdrop(
        context,
        const Text('backdrop'),
        t,
        isRoot: isRoot,
      ),
    ),
    data: data,
  );
}

BorderRadius _clipRadius(WidgetTester tester) =>
    tester.widget<ClipRRect>(find.byType(ClipRRect)).borderRadius
        as BorderRadius;

void main() {
  group('scale curve', () {
    testWidgets('scaleAt is 1 when closed and minScale when open', (
      tester,
    ) async {
      const ScaleBackdropTransform transform = ScaleBackdropTransform();
      expect(transform.scaleAt(0), 1);
      expect(transform.scaleAt(1), transform.minScale);
      expect(transform.scaleAt(0.5), closeTo(0.975, 1e-6));
    });

    testWidgets('regression: scaleAt clamps outside 0..1', (tester) async {
      const ScaleBackdropTransform transform = ScaleBackdropTransform();
      expect(transform.scaleAt(-2), 1);
      expect(transform.scaleAt(4), transform.minScale);
    });

    testWidgets('a custom minScale is honoured', (tester) async {
      const ScaleBackdropTransform transform = ScaleBackdropTransform(
        minScale: 0.5,
      );
      expect(transform.scaleAt(1), 0.5);
    });

    testWidgets('regression: minScale is asserted to be in (0, 1]', (
      tester,
    ) async {
      expect(() => ScaleBackdropTransform(minScale: 0), throwsAssertionError);
      expect(() => ScaleBackdropTransform(minScale: 1.5), throwsAssertionError);
    });
  });

  group('freed size', () {
    testWidgets('regression: the root layer frees space now', (tester) async {
      // The old formula was `size - size * scale / minScale`, which is 0 at
      // t = 1 and negative (then clamped to 0) everywhere else.
      const ScaleBackdropTransform transform = ScaleBackdropTransform();
      final Size open = transform.resolveExtraSize(_size, 1, isRoot: true);
      expect(open.width, closeTo(15, 1e-9));
      expect(open.height, closeTo(10, 1e-9));
      final Size half = transform.resolveExtraSize(_size, 0.5, isRoot: true);
      expect(half.width, closeTo(7.5, 1e-9));
      expect(half.height, closeTo(5, 1e-9));
      expect(transform.resolveExtraSize(_size, 0, isRoot: true), Size.zero);
    });

    testWidgets('a non-root layer frees the same space', (tester) async {
      const ScaleBackdropTransform transform = ScaleBackdropTransform();
      final Size root = transform.resolveExtraSize(_size, 1, isRoot: true);
      final Size nested = transform.resolveExtraSize(_size, 1, isRoot: false);
      expect(nested.width, closeTo(root.width, 1e-9));
      expect(nested.height, closeTo(root.height, 1e-9));
    });

    testWidgets('the identity transform frees nothing', (tester) async {
      expect(BackdropTransform.none.resolveExtraSize(_size, 0.5), Size.zero);
      expect(const NoBackdropTransform().resolveExtraSize(_size, 1), Size.zero);
    });
  });

  group('wrapping', () {
    testWidgets('the identity transform returns the child unchanged', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          Builder(
            builder: (context) => BackdropTransform.none.wrapBackdrop(
              context,
              const Text('x'),
              0.5,
            ),
          ),
        ),
      );
      expect(find.byType(Transform), findsNothing);
      expect(find.text('x'), findsOneWidget);
    });

    testWidgets('a root backdrop is clipped and scaled', (tester) async {
      await tester.pumpWidget(_wrapped(const ScaleBackdropTransform()));
      expect(find.byType(Transform), findsOneWidget);
      expect(find.byType(ClipRRect), findsOneWidget);
      // `getMaxScaleOnAxis` would report the untouched z axis (1.0), so read
      // the x component of the diagonal directly.
      expect(
        tester.widget<Transform>(find.byType(Transform)).transform.storage[0],
        0.95,
      );
    });

    testWidgets('a non-root backdrop is scaled but not clipped', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapped(const ScaleBackdropTransform(), isRoot: false),
      );
      expect(find.byType(ClipRRect), findsNothing);
      expect(find.byType(Transform), findsOneWidget);
    });

    testWidgets('the root radius follows the theme radius token', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapped(const ScaleBackdropTransform(), data: const ShadcnThemeData()),
      );
      expect(_clipRadius(tester).topLeft.x, const ShadcnThemeData().radiusXxl);
    });

    testWidgets('an explicit cornerRadius wins', (tester) async {
      await tester.pumpWidget(
        _wrapped(const ScaleBackdropTransform(cornerRadius: 8)),
      );
      expect(_clipRadius(tester).topLeft.x, 8);
    });

    testWidgets('the clip radius is zero while closed', (tester) async {
      await tester.pumpWidget(_wrapped(const ScaleBackdropTransform(), t: 0));
      expect(_clipRadius(tester).topLeft.x, 0);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors colors) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('wraps under $name tokens', (tester) async {
        await tester.pumpWidget(
          _wrapped(
            const ScaleBackdropTransform(),
            t: 0.5,
            data: ShadcnThemeData(colors: colors),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.text('backdrop'), findsOneWidget);
      });
    }
  });
}
