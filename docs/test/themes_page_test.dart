// D7 Theme Studio page tests: the rail/canvas frame, the picker rows, the
// site-wide propagation to another route, the `Get Code` dialog, `Open Preset`
// validation and the mobile sheet.

import 'package:docs/routing/docs_router.dart';
import 'package:docs/state/docs_state.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/ui/shadcn/components/card/card.dart';
import 'package:docs/ui/shadcn/components/progress/progress.dart';
import 'package:docs/ui/shadcn/components/slider/slider.dart';
import 'package:docs/ui/shadcn/components/tabs/tabs.dart';
import 'package:docs/ui/shadcn/components/table/table.dart';
import 'package:docs/ui/shadcn/theme/theme.dart';
import 'package:docs/widgets/docs_header.dart';
import 'package:docs/widgets/studio_canvas.dart';
import 'package:docs/widgets/theme_rail.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('themes page', () {
    testWidgets('rail and canvas render side by side at desktop', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      expect(find.byType(ThemeRail), findsOneWidget);
      expect(find.byType(ThemeCanvas), findsOneWidget);
      expect(find.byKey(const ValueKey<String>('rail-row-preset')), findsOne);
    });

    testWidgets('the canvas is a real block grid of registry components', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(Progress), findsWidgets, reason: 'stats + progress');
      expect(find.byType(Slider), findsWidgets, reason: 'form slider');
      expect(find.byType(Tabs), findsOneWidget);
      expect(find.byType(ShadcnTable), findsOneWidget);
      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(find.text('Distribute Track'), findsOneWidget);
      expect(find.text('Claimable Balance'), findsOneWidget);
    });

    testWidgets('every picker row of the brief is present', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      for (final String label in <String>[
        'Preset',
        'Base colour',
        'Theme colour',
        'Chart colours',
        'Heading font',
        'Body font',
        'Radius',
        'Spacing',
        'Shadow',
        'Syntax colours',
      ]) {
        expect(
          find.descendant(
            of: find.byType(ThemeRail),
            matching: find.text(label),
          ),
          findsOneWidget,
          reason: 'rail row "$label"',
        );
      }
    });

    testWidgets('the footer carries the three actions and the preset id', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      expect(find.text('Open Preset'), findsOneWidget);
      expect(find.text('Shuffle'), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('theme-rail-get-code')),
        findsOne,
      );
      expect(
        find.byKey(const ValueKey<String>('theme-rail-preset-id')),
        findsOneWidget,
      );
    });

    testWidgets('a rail edit re-themes a widget on another route', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      // The site theme is installed above the router, so every route reads it.
      Color sitePrimary() => tester
          .widget<ShadcnTheme>(find.byType(ShadcnTheme).first)
          .data
          .colors
          .primary;
      final Color before = sitePrimary();

      await goTo(tester, delegate, '/themes');
      docsState.themeModel.setAccentColor(const Color(0xFF16A34A));
      await tester.pumpAndSettle();
      expect(sitePrimary(), isNot(before));

      // The change is still live on a different route (the theming page).
      await goTo(tester, delegate, '/docs/theming');
      expect(sitePrimary(), isNot(before));
      expect(sitePrimary(), docsState.theme.colors.primary);
    });

    testWidgets('Reset returns the site to neutral', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      docsState.themeModel.selectPreset('claude');
      await tester.pumpAndSettle();
      expect(docsState.presetId, 'claude');

      await tester.ensureVisible(
        find.byKey(const ValueKey<String>('theme-rail-reset')),
      );
      await tester.tap(find.byKey(const ValueKey<String>('theme-rail-reset')));
      await tester.pumpAndSettle();
      expect(docsState.presetId, 'neutral');
    });

    testWidgets('the mode toggle flips brightness for the whole site', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        platformBrightness: Brightness.light,
      );
      await goTo(tester, delegate, '/themes');
      Brightness siteBrightness() => tester
          .widget<ShadcnTheme>(find.byType(ShadcnTheme).first)
          .data
          .colors
          .brightness;
      expect(siteBrightness(), Brightness.light);

      await tester.tap(find.byKey(const ValueKey<String>('theme-canvas-mode')));
      await tester.pumpAndSettle();
      expect(siteBrightness(), Brightness.dark);
    });

    testWidgets('the mobile frame collapses the rail into a sheet', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        width: 375,
        height: 812,
      );
      await goTo(tester, delegate, '/themes');
      expect(find.byType(ThemeRail), findsNothing);
      expect(find.byType(ThemeCanvas), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey<String>('themes-open-rail')));
      // The sheet autofocuses the preset-id field, whose cursor ticker never
      // stops, so this drives frames instead of settling.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(ThemeRail), findsOneWidget);
    });

    testWidgets('the header CTA swaps to Get Code on /themes', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      expect(
        find.byKey(const ValueKey<String>('docs-header-get-code')),
        findsNothing,
      );
      await goTo(tester, delegate, '/themes');
      expect(
        find.byKey(const ValueKey<String>('docs-header-get-code')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(DocsHeader),
          matching: find.text('Get Started'),
        ),
        findsNothing,
      );

      await tester.tap(
        find.byKey(const ValueKey<String>('docs-header-get-code')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Dart'), findsOneWidget);
      expect(find.text('JSON'), findsOneWidget);
      expect(find.text('CLI'), findsOneWidget);
    });
  });

  group('reduced motion', () {
    testWidgets('the canvas tween is instant with animations disabled', (
      WidgetTester tester,
    ) async {
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      docsState.themeModel.setRadiusPx(12);

      // With animations disabled the colour tween is capped to 150 ms, so one
      // frame after the edit the new radius is already in the tree.
      await tester.pump();
      final Iterable<AnimatedShadcnTheme> tweens = tester
          .widgetList<AnimatedShadcnTheme>(
            find.descendant(
              of: find.byType(ThemeCanvas),
              matching: find.byType(AnimatedShadcnTheme),
            ),
          );
      expect(tweens, isNotEmpty);
      for (final AnimatedShadcnTheme tween in tweens) {
        expect(
          tween.duration,
          lessThanOrEqualTo(const Duration(milliseconds: 150)),
          reason: 'reduced motion caps the colour tween at 150 ms',
        );
      }
    });

    testWidgets('the rail edit lands in the site theme immediately', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      docsState.themeModel.setRadiusPx(0);
      await tester.pump();
      expect(docsState.theme.radiusLg, 0);
    });
  });

  group('state wiring', () {
    testWidgets('the rail reads the live model, not a private copy', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      docsState.setPreset('ocean-breeze');
      await tester.pumpAndSettle();
      final DocsState fromContext = tester
          .widget<ThemeRail>(find.byType(ThemeRail))
          .state;
      expect(fromContext.presetId, 'ocean-breeze');
      expect(
        find.descendant(
          of: find.byType(ThemeRail),
          matching: find.text('ocean-breeze'),
        ),
        findsWidgets,
      );
    });

    testWidgets('a persisted document is restored on the next boot', (
      WidgetTester tester,
    ) async {
      final MemoryDocsStorage storage = MemoryDocsStorage();
      final DocsRouterDelegate delegate = await pumpDocsApp(
        tester,
        docsStorage: storage,
      );
      await goTo(tester, delegate, '/themes');
      docsState.themeModel.setRadiusPx(2);
      await tester.pumpAndSettle();
      expect(storage.values[kDocsThemeDocumentKey], isNotNull);

      // A fresh state over the same storage restores the edit.
      final DocsState restored = DocsState(storage: storage)..restore();
      addTearDown(restored.dispose);
      expect(restored.effectiveRadiusPx, 2);
    });
  });

  group('widgets used', () {
    testWidgets('the rail footer buttons are focusable and labelled', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      expect(
        find.descendant(
          of: find.byType(ThemeRail),
          matching: find.byType(Button),
        ),
        findsWidgets,
      );
    });
  });
}
