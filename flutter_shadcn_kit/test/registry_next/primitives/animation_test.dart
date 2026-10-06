import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/animated_value_builder.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/animation.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/animation_queue.dart';

Widget _wrap(Widget child) {
  return Directionality(textDirection: TextDirection.ltr, child: child);
}

void main() {
  test('AnimationQueueController plays requests in order', () {
    final controller = AnimationQueueController();
    controller.push(
      AnimationRequest(10, const Duration(milliseconds: 100), Curves.linear),
      false,
    );
    controller.push(
      AnimationRequest(20, const Duration(milliseconds: 100), Curves.linear),
    );
    expect(controller.shouldTick, isTrue);

    controller.tick(const Duration(milliseconds: 100));
    expect(controller.value, 10);

    controller.tick(const Duration(milliseconds: 100));
    expect(controller.value, 20);
    expect(controller.shouldTick, isFalse);

    controller.value = 5;
    expect(controller.value, 5);
    expect(controller.shouldTick, isFalse);
  });

  test('AnimationQueueController applies the curve', () {
    final controller = AnimationQueueController();
    controller.push(
      AnimationRequest(10, const Duration(milliseconds: 100), Curves.easeIn),
      false,
    );
    controller.tick(const Duration(milliseconds: 50));
    expect(controller.value, lessThan(5));
    expect(controller.value, greaterThan(0));
    controller.tick(const Duration(milliseconds: 50));
    expect(controller.value, 10);
  });

  testWidgets('AnimatedValueBuilder lerps and reports onEnd', (tester) async {
    final seen = <double?>[];
    var ended = 0;
    Widget build(double value, {Duration duration = Duration.zero}) {
      return _wrap(
        AnimatedValueBuilder<double>(
          value: value,
          initialValue: 0,
          duration: duration,
          onEnd: (value) => ended++,
          builder: (context, value, child) {
            seen.add(value);
            return const SizedBox();
          },
        ),
      );
    }

    await tester.pumpWidget(build(0));
    expect(seen.last, 0);

    await tester.pumpWidget(
      build(10, duration: const Duration(milliseconds: 200)),
    );
    await tester.pump(const Duration(milliseconds: 100));
    expect(seen.last, greaterThan(0));
    expect(seen.last, lessThan(10));

    await tester.pump(const Duration(milliseconds: 150));
    expect(seen.last, 10);
    expect(ended, 1);
  });

  testWidgets('AnimatedValueBuilder steps unknown types at the midpoint', (
    tester,
  ) async {
    final seen = <_Pair?>[];
    await tester.pumpWidget(
      _wrap(
        AnimatedValueBuilder<_Pair>(
          value: const _Pair('b'),
          initialValue: const _Pair('a'),
          duration: const Duration(milliseconds: 100),
          builder: (context, value, child) {
            seen.add(value);
            return const SizedBox();
          },
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 50));
    expect(seen.last!.name, 'a');

    await tester.pump(const Duration(milliseconds: 100));
    expect(seen.last!.name, 'b');
  });

  testWidgets('RepeatedAnimationBuilder cycles between start and end', (
    tester,
  ) async {
    final seen = <double>[];
    await tester.pumpWidget(
      _wrap(
        RepeatedAnimationBuilder(
          start: 0,
          end: 1,
          duration: const Duration(milliseconds: 100),
          builder: (context, value, child) {
            seen.add(value);
            return const SizedBox();
          },
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 25));
    expect(seen.last, closeTo(0.25, 0.01));

    await tester.pump(const Duration(milliseconds: 25));
    expect(seen.last, closeTo(0.5, 0.01));
  });

  testWidgets('ControlledAnimation maps controller progress to a value', (
    tester,
  ) async {
    final controller = AnimationController(
      vsync: tester,
      duration: const Duration(milliseconds: 100),
    );
    addTearDown(controller.dispose);
    final animation = ControlledAnimation(controller);

    animation.value = 0;
    expect(animation.value, 0);

    animation.forward(10, Curves.linear);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(animation.value, closeTo(5, 0.01));

    await tester.pump(const Duration(milliseconds: 60));
    expect(animation.value, 10);
    expect(animation.status, AnimationStatus.completed);
  });
}

class _Pair {
  const _Pair(this.name);
  final String name;

  @override
  bool operator ==(Object other) => other is _Pair && other.name == name;

  @override
  int get hashCode => name.hashCode;
}
