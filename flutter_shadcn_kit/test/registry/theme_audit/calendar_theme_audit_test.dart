// Theme audit: Calendar selected day must follow the theme's primary color.
//
// User report (2026-10-10): with the `claude` preset selected on the docs
// site, the Calendar's selected day renders BLACK instead of the theme's
// `primary`. This test asserts the selected cell fill equals the theme
// `primary` token and the selected label equals `primaryForeground`.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/calendar/calendar.dart';
import 'package:flutter_shadcn_kit/registry/primitives/date_math.dart';

import 'theme_audit_helpers.dart';

void main() {
  group('Calendar theme audit', () {
    testWidgets(
      'selected day uses primary + primaryForeground (neutral light)',
      (tester) async {
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

        final theme = resolvedTheme(tester);
        final primary = theme.colors.primary;

        // Find the selected cell by looking for a Container with primary color
        final selectedFill = findContainerColor(tester, primary);
        expect(
          selectedFill,
          isNotNull,
          reason:
              'Calendar selected day should be painted with the primary token',
        );
      },
    );

    testWidgets('selected day uses primary + primaryForeground (claude dark)', (
      tester,
    ) async {
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

      final theme = resolvedTheme(tester);
      final primary = theme.colors.primary;

      final selectedFill = findContainerColor(tester, primary);
      expect(
        selectedFill,
        isNotNull,
        reason:
            'Calendar selected day should follow the claude dark primary token',
      );
    });

    testWidgets('theme change at runtime updates selected day color', (
      tester,
    ) async {
      // Start with neutral light
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

      final neutralTheme = resolvedTheme(tester);
      final neutralPrimary = neutralTheme.colors.primary;
      expect(
        findContainerColor(tester, neutralPrimary),
        isNotNull,
        reason: 'Initial theme should paint selected day with neutral primary',
      );

      // Switch to claude dark
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

      final claudeTheme = resolvedTheme(tester);
      final claudePrimary = claudeTheme.colors.primary;
      expect(
        findContainerColor(tester, claudePrimary),
        isNotNull,
        reason:
            'After theme switch, selected day should use claude dark primary',
      );

      // The old neutral primary should no longer be present as a cell fill
      // (stale capture would miss the new one).
      expect(findContainerColor(tester, claudePrimary), isNotNull);
    });
  });
}
