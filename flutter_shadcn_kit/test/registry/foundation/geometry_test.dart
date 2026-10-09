import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/geometry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AxisDirectional', () {
    test('resolves start/end against the text direction', () {
      expect(
        AxisDirectional.start.resolve(TextDirection.ltr),
        AxisDirection.left,
      );
      expect(
        AxisDirectional.start.resolve(TextDirection.rtl),
        AxisDirection.right,
      );
      expect(
        AxisDirectional.end.resolve(TextDirection.ltr),
        AxisDirection.right,
      );
      expect(
        AxisDirectional.end.resolve(TextDirection.rtl),
        AxisDirection.left,
      );
      expect(AxisDirectional.up.resolve(TextDirection.ltr), AxisDirection.up);
      expect(
        AxisDirectional.down.resolve(TextDirection.rtl),
        AxisDirection.down,
      );
    });

    test('reversed flips the axis', () {
      expect(AxisDirectional.up.reversed, AxisDirectional.down);
      expect(AxisDirectional.start.reversed, AxisDirectional.end);
    });
  });

  group('AxisAlignment', () {
    test('resolveValue flips horizontal values in RTL', () {
      const left = AxisAlignment.left;
      expect(left.resolveValue(Axis.horizontal), -1.0);
      expect(
        left.resolve(TextDirection.rtl).resolveValue(Axis.horizontal),
        1.0,
      );
      expect(left.resolveValue(Axis.vertical), -1.0);
    });

    test('alongValue positions within a span', () {
      expect(AxisAlignment.left.alongValue(Axis.horizontal, 100), 0);
      expect(AxisAlignment.center.alongValue(Axis.horizontal, 100), 50);
      expect(AxisAlignment.right.alongValue(Axis.horizontal, 100), 100);
    });

    test('directional alignment resolves per direction', () {
      expect(
        AxisAlignmentDirectional.start.resolve(TextDirection.rtl).value,
        -1.0,
      );
      expect(
        AxisAlignmentDirectional.end.resolve(TextDirection.rtl).direction,
        TextDirection.rtl,
      );
    });
  });

  group('AxisInsets', () {
    test('resolveValue swaps start/end for RTL horizontal axes', () {
      const insets = AxisInsetsDirectional(start: 1, end: 2);
      final ltr = insets
          .resolve(TextDirection.ltr)
          .resolveValue(Axis.horizontal);
      final rtl = insets
          .resolve(TextDirection.rtl)
          .resolveValue(Axis.horizontal);
      expect(ltr.start, 1);
      expect(ltr.end, 2);
      expect(rtl.start, 2);
      expect(rtl.end, 1);
    });

    test('vertical axes keep start/end', () {
      const insets = AxisInsets(start: 3, end: 4);
      final resolved = insets.resolveValue(Axis.vertical);
      expect(resolved.start, 3);
      expect(resolved.end, 4);
    });
  });

  group('border math', () {
    test('subtractByBorder reduces and clamps at zero', () {
      const radius = BorderRadius.all(Radius.circular(8));
      final reduced = subtractByBorder(radius, 3);
      expect(reduced.topLeft, const Radius.circular(5));
      expect(reduced.bottomRight, const Radius.circular(5));

      final clamped = subtractByBorder(radius, 12);
      expect(clamped.topLeft, Radius.zero);
    });

    testWidgets('optionallyResolve extensions resolve without Directionality', (
      tester,
    ) async {
      late BorderRadius radius;
      late BorderRadius plainRadius;
      late EdgeInsets insets;
      late Alignment alignment;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              const BorderRadiusDirectional directionalRadius =
                  BorderRadiusDirectional.only(topStart: Radius.circular(4));
              radius = directionalRadius.optionallyResolve(context);
              const BorderRadius concrete = BorderRadius.all(
                Radius.circular(1),
              );
              plainRadius = concrete.optionallyResolve(context);
              const EdgeInsetsDirectional directionalInsets =
                  EdgeInsetsDirectional.only(start: 2);
              insets = directionalInsets.optionallyResolve(context);
              const AlignmentDirectional directionalAlignment =
                  AlignmentDirectional.centerStart;
              alignment = directionalAlignment.optionallyResolve(context);
              return const SizedBox();
            },
          ),
        ),
      );
      expect(radius.topLeft, const Radius.circular(4));
      expect(plainRadius.topLeft, const Radius.circular(1));
      expect(insets.left, 2);
      expect(alignment, Alignment.centerLeft);
    });

    testWidgets('optionallyResolveBorderRadius resolves directionals', (
      tester,
    ) async {
      late BorderRadius? resolved;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Builder(
            builder: (context) {
              resolved = optionallyResolveBorderRadius(
                context,
                const BorderRadiusDirectional.only(topEnd: Radius.circular(6)),
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolved!.topRight, const Radius.circular(6));
    });
  });
}
