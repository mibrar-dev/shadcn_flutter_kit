// Widget tests for the `tracker` component.
//
// Covers the segment row, all four levels, the tooltip lifecycle, the sizes,
// light and dark tokens, the four precedence legs, and regressions for the old
// bugs: the Material `Colors` import, the unreadable per-level literals that no
// preset could restyle, the dead `TrackerThemeDefaults`, and the double
// `TooltipContainer` wrap.

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/tooltip/tooltip.dart';
import 'package:flutter_shadcn_kit/registry/components/tracker/tracker.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

int _overlayGeneration = 0;

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TrackerTheme? scoped,
  double width = 320,
}) {
  Widget body = SizedBox(width: width, child: child);
  if (scoped != null) {
    body = ComponentTheme<TrackerTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          key: ValueKey<int>(_overlayGeneration++),
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (context) =>
                  Align(alignment: Alignment.topLeft, child: body),
            ),
          ],
        ),
      ),
    ),
  );
}

List<ColoredBox> _segments(WidgetTester tester) => tester
    .widgetList<ColoredBox>(
      find.descendant(
        of: find.byType(Tracker),
        matching: find.byType(ColoredBox),
      ),
    )
    .toList();

const List<TrackerData> _data = <TrackerData>[
  TrackerData(tooltip: Text('a'), level: TrackerLevel.fine),
  TrackerData(tooltip: Text('b'), level: TrackerLevel.warning),
  TrackerData(tooltip: Text('c'), level: TrackerLevel.critical),
  TrackerData(tooltip: Text('d'), level: TrackerLevel.unknown),
];

Future<TestGesture> _hover(WidgetTester tester, Finder finder) async {
  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(finder));
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return gesture;
}

void main() {
  group('rendering', () {
    testWidgets('draws one segment per entry', (tester) async {
      await tester.pumpWidget(_frame(const Tracker(data: _data)));
      expect(_segments(tester), hasLength(4));
    });

    testWidgets('an empty data list renders a zero-size box', (tester) async {
      await tester.pumpWidget(_frame(const Tracker(data: <TrackerData>[])));
      expect(find.byType(ColoredBox), findsNothing);
      expect(tester.getSize(find.byType(Tracker)).height, 0);
    });

    testWidgets('the default height is 32', (tester) async {
      await tester.pumpWidget(_frame(const Tracker(data: _data)));
      expect(tester.getSize(find.byType(ColoredBox).first).height, 32);
    });

    testWidgets('the default radius resolves the ambient radiusMd', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const Tracker(data: _data)));
      final ClipRRect clip = tester.widget<ClipRRect>(
        find.descendant(
          of: find.byType(Tracker),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(
        clip.borderRadius,
        BorderRadius.circular(const ShadcnThemeData().radiusMd),
      );
    });

    testWidgets('the gaps separate the segments', (tester) async {
      await tester.pumpWidget(_frame(const Tracker(data: _data)));
      final Rect first = tester.getRect(find.byType(ColoredBox).at(0));
      final Rect second = tester.getRect(find.byType(ColoredBox).at(1));
      expect(second.left - first.right, trackerDefaultGap);
    });
  });

  group('levels', () {
    testWidgets('each level paints its default fill', (tester) async {
      await tester.pumpWidget(_frame(const Tracker(data: _data)));
      final List<ColoredBox> segments = _segments(tester);
      // `fine` / `warning` have no shadcn token of their own, so they borrow
      // the green and amber slots of the categorical scale (chart2 / chart4);
      // `critical` / `unknown` keep shadcn's own tokens.
      final ShadcnColors colors = ShadcnColors.lightFallback;
      expect(segments[0].color, trackerDefaults.fine!.resolve(colors));
      expect(segments[1].color, trackerDefaults.warning!.resolve(colors));
      expect(segments[2].color, colors.destructive);
      expect(segments[3].color, colors.mutedForeground);
    });

    testWidgets('regression: a level follows the dark tokens', (tester) async {
      // The old levels were `Colors.red`/`Colors.grey` literals, so a dark
      // preset could not restyle the critical/unknown segments.
      await tester.pumpWidget(
        _frame(
          const Tracker(data: _data),
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        ),
      );
      final List<ColoredBox> segments = _segments(tester);
      expect(segments[2].color, ShadcnColors.darkFallback.destructive);
      expect(segments[3].color, ShadcnColors.darkFallback.mutedForeground);
    });
  });

  group('tooltip', () {
    testWidgets('a zero-delay tooltip presents on hover', (tester) async {
      await tester.pumpWidget(_frame(const Tracker(data: _data)));
      await _hover(tester, find.byType(Tooltip).first);
      expect(find.byType(TooltipContainer), findsOneWidget);
      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('regression: the tooltip is wrapped exactly once', (
      tester,
    ) async {
      // The old segment passed a `TooltipContainer` into `InstantTooltip`,
      // which wrapped it again.
      await tester.pumpWidget(_frame(const Tracker(data: _data)));
      await _hover(tester, find.byType(Tooltip).first);
      expect(find.byType(TooltipContainer), findsOneWidget);
    });
  });

  group('theme precedence', () {
    testWidgets('the widget leg wins over everything', (tester) async {
      await tester.pumpWidget(
        _frame(
          Tracker(
            theme: const TrackerTheme(fine: ThemedColor.value(_green)),
            data: _data,
          ),
          app: const <ComponentThemeData>[
            TrackerTheme(fine: ThemedColor.value(_blue)),
          ],
          scoped: const TrackerTheme(
            fine: ThemedColor.value(Color(0xFF123456)),
          ),
        ),
      );
      expect(_segments(tester).first.color, _green);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Tracker(data: _data),
          app: const <ComponentThemeData>[
            TrackerTheme(fine: ThemedColor.value(_blue)),
          ],
          scoped: const TrackerTheme(fine: ThemedColor.value(_green)),
        ),
      );
      expect(_segments(tester).first.color, _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Tracker(data: _data),
          app: const <ComponentThemeData>[
            TrackerTheme(fine: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_segments(tester).first.color, _green);
    });

    testWidgets('a leg that sets only the fill keeps the default height', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const Tracker(data: _data),
          app: const <ComponentThemeData>[
            TrackerTheme(fine: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(tester.getSize(find.byType(ColoredBox).first).height, 32);
    });

    testWidgets('regression: a scoped height and gap reach the row', (
      tester,
    ) async {
      // The old `TrackerThemeDefaults` were never read; only `ComponentTheme`
      // fields applied.
      await tester.pumpWidget(
        _frame(
          const Tracker(data: _data),
          scoped: const TrackerTheme(itemHeight: 12, gap: 6, radius: 3),
        ),
      );
      expect(tester.getSize(find.byType(ColoredBox).first).height, 12);
      final Rect first = tester.getRect(find.byType(ColoredBox).at(0));
      final Rect second = tester.getRect(find.byType(ColoredBox).at(1));
      expect(second.left - first.right, 6);
      final ClipRRect clip = tester.widget<ClipRRect>(
        find.descendant(
          of: find.byType(Tracker),
          matching: find.byType(ClipRRect),
        ),
      );
      expect(clip.borderRadius, BorderRadius.circular(3));
    });
  });

  group('defaults table', () {
    test('the token rows match the tracker levels', () {
      const ShadcnColors colors = ShadcnColors.lightFallback;
      expect(
        trackerDefaults.forLevel(TrackerLevel.critical)?.resolve(colors),
        colors.destructive,
      );
      expect(
        trackerDefaults.forLevel(TrackerLevel.unknown)?.resolve(colors),
        colors.mutedForeground,
      );
      expect(trackerDefaults.gap, trackerDefaultGap);
      expect(trackerDefaults.itemHeight, trackerDefaultItemHeight);
      expect(trackerDefaults.radius, isNull);
    });
  });
}
