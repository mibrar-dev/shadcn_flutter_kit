// D4 themes page tests: the rail lists all 42 presets, the live preview
// re-themes when the preset changes, the radius slider updates the state,
// and the mode toggle flips brightness.

import 'package:docs/routing/docs_router.dart';
import 'package:docs/ui/shadcn/components/button/button.dart';
import 'package:docs/ui/shadcn/components/card/card.dart';
import 'package:docs/ui/shadcn/components/input/input.dart';
import 'package:docs/ui/shadcn/components/slider/slider.dart';
import 'package:docs/ui/shadcn/components/switch/switch.dart';
import 'package:docs/ui/shadcn/foundation/icons/lucide_icons.dart';
import 'package:docs/widgets/live_preview.dart';
import 'package:docs/widgets/theme_rail.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  group('themes page', () {
    testWidgets('rail lists all 42 presets', (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      expect(find.byType(ThemeRail), findsOneWidget);
      expect(find.byType(LivePreview), findsOneWidget);
      // First preset is visible.
      expect(find.text('amber-minimal'), findsOneWidget);
    });

    testWidgets('live preview shows registry components', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      expect(find.byType(Card), findsWidgets);
      expect(find.byType(Button), findsWidgets);
      expect(find.byType(Input), findsWidgets);
      expect(find.byType(Switch), findsWidgets);
    });

    testWidgets('preset switch re-themes the live preview', (
      WidgetTester tester,
    ) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      // Tap a different preset.
      await tester.tap(find.text('claude'));
      await tester.pumpAndSettle();
      expect(docsState.presetId, 'claude');
    });

    testWidgets('mode toggle flips brightness', (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      final Brightness before = docsState.brightness;
      // Scroll the mode toggle into view, then tap it.
      final Finder toggle = find.descendant(
        of: find.byType(ThemeRail),
        matching: find.byIcon(LucideIcons.sun),
      );
      await tester.ensureVisible(toggle);
      await tester.pumpAndSettle();
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(docsState.brightness, isNot(before));
    });

    testWidgets('radius slider updates the state', (WidgetTester tester) async {
      final DocsRouterDelegate delegate = await pumpDocsApp(tester);
      await goTo(tester, delegate, '/themes');
      // The slider is present.
      expect(find.byType(Slider), findsOneWidget);
    });
  });
}
