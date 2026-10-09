import 'package:docs/motion/ease.dart';
import 'package:docs/motion/motion_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('durations match the motion spec', () {
    expect(kDurationFast, const Duration(milliseconds: 150));
    expect(kDurationPage, const Duration(milliseconds: 200));
    expect(kDurationTheme, const Duration(milliseconds: 300));
    expect(kDurationReveal, const Duration(milliseconds: 300));
    expect(kRevealStagger, const Duration(milliseconds: 40));
    expect(kDurationHero, const Duration(milliseconds: 500));
    expect(kDurationCopyFeedback, const Duration(milliseconds: 1500));
    expect(kDurationMarquee, const Duration(seconds: 40));
    expect(kDurationFloat, const Duration(seconds: 6));
  });

  testWidgets('an explicit reduced-motion override wins', (
    WidgetTester tester,
  ) async {
    late bool reduced;
    late Duration duration;
    late double offset;
    await tester.pumpWidget(
      MotionScope(
        prefersReducedMotion: true,
        child: Builder(
          builder: (BuildContext context) {
            reduced = MotionScope.of(context);
            duration = context.motionDuration(kDurationTheme);
            offset = context.motionOffset(12);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(reduced, isTrue);
    expect(duration, kDurationFast);
    expect(offset, 0);
  });

  testWidgets('MediaQuery.disableAnimations reduces motion', (
    WidgetTester tester,
  ) async {
    late bool reduced;
    late Duration duration;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MotionScope(
          child: Builder(
            builder: (BuildContext context) {
              reduced = MotionScope.of(context);
              duration = context.motionDuration(kDurationTheme);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    expect(reduced, isTrue);
    expect(duration, kDurationFast);
  });

  testWidgets('motion passes through when nothing asks to reduce', (
    WidgetTester tester,
  ) async {
    late bool reduced;
    late Duration duration;
    late double offset;
    await tester.pumpWidget(
      MotionScope(
        prefersReducedMotion: false,
        child: Builder(
          builder: (BuildContext context) {
            reduced = MotionScope.of(context);
            duration = context.motionDuration(kDurationTheme);
            offset = context.motionOffset(12);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(reduced, isFalse);
    expect(duration, kDurationTheme);
    expect(offset, 12);
  });
}
