import 'package:docs/motion/ease.dart';
import 'package:docs/motion/motion_scope.dart';
import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/heading_anchor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  test('durations match the amended motion spec (shadcn-site)', () {
    expect(kDurationFast, const Duration(milliseconds: 150));
    expect(kDurationPopper, const Duration(milliseconds: 100));
    expect(kDurationPalette, const Duration(milliseconds: 200));
    expect(kDurationHeadingAnchor, const Duration(milliseconds: 200));
    expect(kDurationTheme, const Duration(milliseconds: 300));
    expect(kDurationCopyFeedback, const Duration(milliseconds: 2000));
    // Removed motions have no constants: no route/reveal/hero/marquee/float.
    expect(kEaseOutExpo, isA<Cubic>());
    expect(kEaseStandard, Curves.fastOutSlowIn);
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

  test('palette route caps its transition under reduced motion', () {
    Widget build(BuildContext context) => const SizedBox.shrink();
    final DocsPaletteRoute normal = DocsPaletteRoute(builder: build);
    final DocsPaletteRoute reduced = DocsPaletteRoute(
      builder: build,
      reduceMotion: true,
    );
    expect(normal.transitionDuration, kDurationPalette);
    expect(normal.reverseTransitionDuration, kDurationFast);
    expect(reduced.transitionDuration, kDurationFast);
    expect(reduced.reverseTransitionDuration, kDurationFast);
  });

  testWidgets('reduced motion caps the app theme tween to 150 ms', (
    WidgetTester tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpDocsApp(tester);
    final AnimatedShadcnTheme theme = tester.widget<AnimatedShadcnTheme>(
      find.byType(AnimatedShadcnTheme).first,
    );
    expect(theme.duration, kDurationFast);
  });

  testWidgets('reduced motion caps the heading anchor reveal to 150 ms', (
    WidgetTester tester,
  ) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    final DocsRouterDelegate delegate = await pumpDocsApp(tester);
    await goTo(tester, delegate, '/docs');
    final AnimatedOpacity opacity = tester.widget<AnimatedOpacity>(
      find
          .descendant(
            of: find.byType(HeadingAnchor),
            matching: find.byType(AnimatedOpacity),
          )
          .first,
    );
    expect(opacity.duration, kDurationFast);
  });

  testWidgets('the mobile popper animates over 100 ms', (
    WidgetTester tester,
  ) async {
    await pumpDocsApp(tester, width: 800, height: 900);
    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    final AnimatedSwitcher switcher = tester.widget<AnimatedSwitcher>(
      find.byType(AnimatedSwitcher),
    );
    expect(switcher.duration, kDurationPopper);
    expect(switcher.switchInCurve, kEaseStandard);
    expect(switcher.switchOutCurve, kEaseIn);
  });
}
