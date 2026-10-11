// Theme audit: stale capture detection.
//
// Asserts that swapping the ShadcnTheme data at runtime updates the
// rendered colors. A component that captures the theme in initState, stores
// resolved colors in a field, or bakes a color into a const default would
// keep the previous preset's token and fail here.
//
// Colours are compared through a whole-tree scan (`hasDecorationColor`)
// rather than a positional finder, so the check cannot pass or fail on where
// a component happens to nest its box.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart';
import 'package:flutter_shadcn_kit/registry/components/badge/badge.dart';
import 'package:flutter_shadcn_kit/registry/components/progress/progress.dart';
import 'package:flutter_shadcn_kit/registry/components/calendar/calendar.dart';
import 'package:flutter_shadcn_kit/registry/primitives/date_math.dart';

import 'theme_audit_helpers.dart';

void main() {
  group('Stale capture audit', () {
    testWidgets('Button updates color on theme change', (tester) async {
      await pumpUnderPreset(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: Button(
          variant: ButtonVariant.primary,
          onPressed: () {},
          child: const Text('Button'),
        ),
      );

      final neutralPrimary = resolvedTheme(tester).colors.primary;
      expect(
        hasDecorationColor(tester, neutralPrimary),
        isTrue,
        reason: 'Button should paint the neutral primary initially',
      );

      await pumpUnderPreset(
        tester,
        presetId: kClaudePreset,
        brightness: Brightness.dark,
        child: Button(
          variant: ButtonVariant.primary,
          onPressed: () {},
          child: const Text('Button'),
        ),
      );

      final claudePrimary = resolvedTheme(tester).colors.primary;
      expect(
        hasDecorationColor(tester, claudePrimary),
        isTrue,
        reason: 'Button should paint the claude dark primary after the swap',
      );
      if (claudePrimary != neutralPrimary) {
        expect(
          hasDecorationColor(tester, neutralPrimary),
          isFalse,
          reason: 'Button kept the previous preset primary - stale capture',
        );
      }
    });

    testWidgets('Card updates color on theme change', (tester) async {
      await pumpUnderPreset(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const Card(child: Text('Card')),
      );

      final neutralCard = resolvedTheme(tester).colors.card;
      expect(
        hasDecorationColor(tester, neutralCard),
        isTrue,
        reason: 'Card should paint the neutral card token initially',
      );

      await pumpUnderPreset(
        tester,
        presetId: kTangerinePreset,
        brightness: Brightness.dark,
        child: const Card(child: Text('Card')),
      );

      final tangerineCard = resolvedTheme(tester).colors.card;
      expect(
        hasDecorationColor(tester, tangerineCard),
        isTrue,
        reason:
            'Card should paint the tangerine dark card token after the swap',
      );
      if (tangerineCard != neutralCard) {
        expect(
          hasDecorationColor(tester, neutralCard),
          isFalse,
          reason: 'Card kept the previous preset card token - stale capture',
        );
      }
    });

    testWidgets('Badge updates color on theme change', (tester) async {
      await pumpUnderPreset(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const Badge(variant: BadgeVariant.primary, child: Text('Badge')),
      );

      final neutralPrimary = resolvedTheme(tester).colors.primary;
      expect(
        hasDecorationColor(tester, neutralPrimary),
        isTrue,
        reason: 'Badge should paint the neutral primary initially',
      );

      await pumpUnderPreset(
        tester,
        presetId: kClaudePreset,
        brightness: Brightness.dark,
        child: const Badge(variant: BadgeVariant.primary, child: Text('Badge')),
      );

      final claudePrimary = resolvedTheme(tester).colors.primary;
      expect(
        hasDecorationColor(tester, claudePrimary),
        isTrue,
        reason: 'Badge should paint the claude dark primary after the swap',
      );
      if (claudePrimary != neutralPrimary) {
        expect(
          hasDecorationColor(tester, neutralPrimary),
          isFalse,
          reason: 'Badge kept the previous preset primary - stale capture',
        );
      }
    });

    testWidgets('Progress updates color on theme change', (tester) async {
      // Progress paints inside a CustomPainter, so the check runs on the
      // theme default the painter resolves each frame.
      await pumpUnderPreset(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const Progress(value: 0.5),
      );

      final data = resolvedTheme(tester);
      final neutralPrimary = data.colors.primary;
      expect(
        progressDefaults.color!.resolve(data.colors),
        neutralPrimary,
        reason: 'Progress default should resolve to the neutral primary',
      );

      await pumpUnderPreset(
        tester,
        presetId: kTangerinePreset,
        brightness: Brightness.dark,
        child: const Progress(value: 0.5),
      );

      final tangerineData = resolvedTheme(tester);
      final tangerinePrimary = tangerineData.colors.primary;
      expect(
        progressDefaults.color!.resolve(tangerineData.colors),
        tangerinePrimary,
        reason:
            'Progress default should resolve to the tangerine primary '
            'after the swap',
      );
    });

    testWidgets('Calendar updates selected day color on theme change', (
      tester,
    ) async {
      await pumpUnderPreset(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: Calendar(
          view: CalendarView(DateTime.now().year, DateTime.now().month),
          viewType: CalendarViewType.date,
          selectionMode: CalendarSelectionMode.single,
          value: CalendarValue.single(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day == 15 ? 14 : 15,
            ),
          ),
          onChanged: (_) {},
        ),
      );

      final neutralPrimary = resolvedTheme(tester).colors.primary;
      expect(
        hasDecorationColor(tester, neutralPrimary),
        isTrue,
        reason:
            'Calendar selected day should use the neutral primary initially',
      );

      await pumpUnderPreset(
        tester,
        presetId: kClaudePreset,
        brightness: Brightness.dark,
        child: Calendar(
          view: CalendarView(DateTime.now().year, DateTime.now().month),
          viewType: CalendarViewType.date,
          selectionMode: CalendarSelectionMode.single,
          value: CalendarValue.single(
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day == 15 ? 14 : 15,
            ),
          ),
          onChanged: (_) {},
        ),
      );

      final claudePrimary = resolvedTheme(tester).colors.primary;
      expect(
        hasDecorationColor(tester, claudePrimary),
        isTrue,
        reason:
            'Calendar selected day should use the claude dark primary after '
            'the swap',
      );
    });
  });
}
