// Widget tests for the `stage_container` component.
//
// Covers: breakpoint strategies, density-aware default padding, the four theme
// legs, unbounded width (old crash), dark tokens and the theme merge/lerp.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/stage_container/stage_container.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/density.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a [StageContainer] in a tight [width] box and returns the padding the
/// builder received.
Future<EdgeInsets> _pump(
  WidgetTester tester, {
  required double width,
  StageBreakpoint? breakpoint,
  EdgeInsetsGeometry? padding,
  StageContainerTheme? theme,
  StageContainerTheme? appTheme,
  StageContainerTheme? scopedTheme,
  ShadcnThemeData? ambient,
}) async {
  // The test surface is 800x600 by default; size it so a tight [width] box is
  // not clamped by the viewport.
  await tester.binding.setSurfaceSize(Size(width, 600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  late EdgeInsets captured;
  Widget child = Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      width: width,
      child: StageContainer(
        breakpoint: breakpoint,
        padding: padding,
        theme: theme,
        builder: (BuildContext context, EdgeInsets resolved) {
          captured = resolved;
          return const SizedBox(height: 10);
        },
      ),
    ),
  );
  if (scopedTheme != null) {
    child = ComponentTheme<StageContainerTheme>(
      data: scopedTheme,
      child: child,
    );
  }
  Widget app = Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(data: const MediaQueryData(), child: child),
  );
  if (appTheme != null) {
    app = ComponentThemes(themes: <ComponentThemeData>[appTheme], child: app);
  }
  await tester.pumpWidget(
    ShadcnTheme(data: ambient ?? const ShadcnThemeData(), child: app),
  );
  return captured;
}

void main() {
  group('breakpoint strategies', () {
    test('default breakpoints are 576/768/992/1200/1400', () {
      const StagedBreakpoint staged = StagedBreakpoint.defaultBreakpoints();
      expect(staged.breakpoints, <double>[576, 768, 992, 1200, 1400]);
      expect(staged.minSize, 576);
      expect(staged.maxSize, 1400);
    });

    test('staged snaps down to the lower and up to the upper breakpoint', () {
      const StagedBreakpoint staged = StagedBreakpoint(<double>[600, 1000]);
      expect(staged.getMinWidth(700), 600);
      expect(staged.getMaxWidth(700), 1000);
      expect(staged.getMinWidth(1000), 1000);
      expect(staged.getMaxWidth(1000), 1000);
    });

    test('constant steps snap to multiples of the step', () {
      const ConstantBreakpoint constant = ConstantBreakpoint(100);
      expect(constant.getMinWidth(250), 200);
      expect(constant.getMaxWidth(250), 300);
      expect(constant.getMinWidth(300), 300);
    });

    test('a single-value staged breakpoint is allowed', () {
      const StagedBreakpoint staged = StagedBreakpoint(<double>[600]);
      expect(staged.minSize, 600);
      expect(staged.maxSize, 600);
      expect(staged.getMinWidth(600), 600);
      expect(staged.getMaxWidth(600), 600);
    });
  });

  group('resolved padding', () {
    testWidgets('default density gives 72 px and snaps to the breakpoint', (
      tester,
    ) async {
      final EdgeInsets at800 = await _pump(tester, width: 800);
      expect(at800.top, 0);
      expect(at800.bottom, 0);
      expect(at800.left, 88); // 72 + (800 - 768) / 2
      expect(at800.right, 88);

      final EdgeInsets at1200 = await _pump(tester, width: 1200);
      expect(at1200.left, 72); // exactly on a breakpoint, no centring

      final EdgeInsets at1500 = await _pump(tester, width: 1500);
      expect(at1500.left, 122); // 72 + (1500 - 1400) / 2
    });

    testWidgets('below the first breakpoint the horizontal padding is zero', (
      tester,
    ) async {
      final EdgeInsets at500 = await _pump(tester, width: 500);
      expect(at500.left, 0);
      expect(at500.right, 0);
    });

    testWidgets('a constant breakpoint snaps to its step', (tester) async {
      final EdgeInsets at250 = await _pump(
        tester,
        width: 250,
        breakpoint: const ConstantBreakpoint(100),
      );
      expect(at250.left, 97); // 72 + (250 - 200) / 2
    });

    testWidgets('a custom staged breakpoint snaps down and centres', (
      tester,
    ) async {
      final EdgeInsets at700 = await _pump(
        tester,
        width: 700,
        breakpoint: const StagedBreakpoint(<double>[600, 1000]),
      );
      expect(at700.left, 122); // 72 + (700 - 600) / 2
    });

    testWidgets('the default padding scales with the container density', (
      tester,
    ) async {
      final EdgeInsets reduced = await _pump(
        tester,
        width: 1200,
        ambient: const ShadcnThemeData(density: Density.reducedDensity),
      );
      expect(reduced.left, 54); // 12 * 4.5
    });

    testWidgets('a plain EdgeInsets override is used as-is', (tester) async {
      final EdgeInsets at1200 = await _pump(
        tester,
        width: 1200,
        padding: const EdgeInsets.symmetric(horizontal: 30),
      );
      expect(at1200.left, 30);
    });
  });

  group('theme resolution', () {
    testWidgets('defaults < app < scoped < widget', (tester) async {
      Future<EdgeInsets> pumpWith(StageContainerTheme? widgetTheme) {
        return _pump(
          tester,
          width: 992,
          appTheme: const StageContainerTheme(
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          scopedTheme: const StageContainerTheme(
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          theme: widgetTheme,
        );
      }

      expect((await pumpWith(null)).left, 20);
      expect(
        (await pumpWith(
          const StageContainerTheme(
            padding: EdgeInsets.symmetric(horizontal: 30),
          ),
        )).left,
        30,
      );
    });

    testWidgets('the app leg overrides the default padding', (tester) async {
      final EdgeInsets at1200 = await _pump(
        tester,
        width: 1200,
        appTheme: const StageContainerTheme(
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
      );
      expect(at1200.left, 12);
    });

    testWidgets('a themed breakpoint replaces the default strategy', (
      tester,
    ) async {
      final EdgeInsets at250 = await _pump(
        tester,
        width: 250,
        scopedTheme: const StageContainerTheme(
          breakpoint: ConstantBreakpoint(100),
        ),
      );
      expect(at250.left, 97);
    });

    test('merge keeps the receiver and fills the rest', () {
      const StageContainerTheme receiver = StageContainerTheme(
        padding: EdgeInsets.symmetric(horizontal: 20),
      );
      const StageContainerTheme fallback = StageContainerTheme(
        breakpoint: ConstantBreakpoint(100),
        padding: EdgeInsets.symmetric(horizontal: 10),
      );
      final StageContainerTheme merged = receiver.merge(fallback);
      expect(merged.padding, const EdgeInsets.symmetric(horizontal: 20));
      expect(merged.breakpoint, const ConstantBreakpoint(100));
    });

    test('lerp steps the strategy and interpolates the padding', () {
      final StageContainerTheme lerped = StageContainerTheme.lerp(
        const StageContainerTheme(padding: EdgeInsets.all(0)),
        const StageContainerTheme(padding: EdgeInsets.all(20)),
        0.5,
      );
      expect(lerped.padding, const EdgeInsets.all(10));
    });
  });

  group('regressions', () {
    testWidgets('an unbounded width does not crash (old infinite inset)', (
      tester,
    ) async {
      late EdgeInsets captured;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: ShadcnTheme(
              data: const ShadcnThemeData(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StageContainer(
                  builder: (BuildContext context, EdgeInsets resolved) {
                    captured = resolved;
                    return const SizedBox(height: 10);
                  },
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(captured.left, 72);
    });

    testWidgets('a single-value staged breakpoint does not assert', (
      tester,
    ) async {
      final EdgeInsets at700 = await _pump(
        tester,
        width: 700,
        breakpoint: const StagedBreakpoint(<double>[600]),
      );
      expect(at700.left, 122); // 72 + (700 - 600) / 2
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('renders with dark tokens', (tester) async {
    final EdgeInsets dark = await _pump(
      tester,
      width: 1200,
      ambient: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    );
    expect(dark.left, 72);
    expect(tester.takeException(), isNull);
  });
}
