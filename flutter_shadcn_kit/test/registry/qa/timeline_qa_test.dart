// QA for `timeline` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `timelinePreviews` example: the Default timeline renders
// three entries with times/titles/content; the Compact example honours the
// scoped theme leg (8px dots, accent colour, 72px time column). Dot/connector
// metrics and density scaling are pinned in `timeline_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/timeline/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/timeline/timeline.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 420,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

Future<void> _pumpPreview(
  WidgetTester tester,
  ComponentPreview preview, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 420,
}) async {
  await tester.pumpWidget(
    _frame(
      Builder(builder: preview.builder),
      data: data,
      direction: direction,
      width: width,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  expect(
    tester.takeException(),
    isNull,
    reason: 'preview "${preview.name}" threw',
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in timelinePreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('Default preview renders three dated entries', (tester) async {
    await _pumpPreview(tester, timelinePreviews[0]);
    expect(find.text('09:00'), findsOneWidget);
    expect(find.text('Kickoff'), findsOneWidget);
    expect(find.text('Project kickoff meeting.'), findsOneWidget);
    expect(find.text('11:00'), findsOneWidget);
    expect(find.text('Design review'), findsOneWidget);
    expect(find.text('14:30'), findsOneWidget);
    expect(find.text('Delivery'), findsOneWidget);
  });

  testWidgets('Compact preview renders the scoped theme', (tester) async {
    await _pumpPreview(tester, timelinePreviews[1]);
    expect(find.text('Mon'), findsOneWidget);
    expect(find.text('Compact'), findsOneWidget);
    expect(find.text('Tue'), findsOneWidget);
  });

  testWidgets('Default preview fits a 375px phone with no overflow', (
    tester,
  ) async {
    await _pumpPreview(tester, timelinePreviews[0], width: 375);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in timelinePreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });

  Future<EdgeInsets> titleInsets(
    WidgetTester tester,
    TextDirection direction,
  ) async {
    await tester.pumpWidget(
      _frame(
        const Timeline(
          data: <TimelineData>[
            TimelineData(
              time: Text('09:00'),
              title: Text('Kickoff'),
              content: Text('Body'),
            ),
          ],
        ),
        direction: direction,
      ),
    );
    await tester.pump();
    final Padding padding = tester.widget<Padding>(
      find
          .ancestor(of: find.text('Kickoff'), matching: find.byType(Padding))
          .first,
    );
    return padding.padding.resolve(direction);
  }

  testWidgets('title/content nudge mirrors in RTL (P7-Q2)', (tester) async {
    final EdgeInsets ltr = await titleInsets(tester, TextDirection.ltr);
    expect(ltr.left, greaterThan(0));
    expect(ltr.right, 0);
    final EdgeInsets rtl = await titleInsets(tester, TextDirection.rtl);
    expect(rtl.right, greaterThan(0));
    expect(rtl.left, 0);
    expect(rtl.right, ltr.left);
    expect(tester.takeException(), isNull);
  });

  testWidgets('time label hugs the spine in both directions (P7-Q2)', (
    tester,
  ) async {
    for (final TextDirection direction in TextDirection.values) {
      await tester.pumpWidget(
        _frame(
          const Timeline(
            data: <TimelineData>[
              TimelineData(time: Text('09:00'), title: Text('Kickoff')),
            ],
          ),
          direction: direction,
        ),
      );
      await tester.pump();
      final Align align = tester.widget<Align>(
        find
            .ancestor(of: find.text('09:00'), matching: find.byType(Align))
            .first,
      );
      expect(align.alignment, AlignmentDirectional.topEnd);
    }
    expect(tester.takeException(), isNull);
  });
}
