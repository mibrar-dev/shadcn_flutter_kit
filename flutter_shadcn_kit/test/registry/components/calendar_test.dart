// Widget tests for the `calendar` component.
//
// Covers the three view types, the four selection modes, the value lookups,
// keyboard navigation and its roving focus, the shadcn cell size, light and
// dark tokens, all four precedence legs, plus a regression per bug fixed.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/calendar/calendar.dart';
import 'package:flutter_shadcn_kit/registry/components/calendar/preview.dart'
    show calendarPreviews;
import 'package:flutter_shadcn_kit/registry/primitives/date_math.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

/// 2024-03-14 is the injected "today" in every test. `DateTime` has no const
/// constructor, so every widget carrying it is non-const.
final DateTime _today = DateTime(2024, 3, 14);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  CalendarTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<CalendarTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Localizations(
          locale: const Locale('en'),
          // `Localizations` insists on a widgets delegate, so both are needed.
          delegates: const <LocalizationsDelegate<dynamic>>[
            DefaultWidgetsLocalizations.delegate,
            ShadcnLocalizations.delegate,
          ],
          child: Align(alignment: Alignment.topLeft, child: body),
        ),
      ),
    ),
  );
}

/// Every painted cell label, in row-major order.
List<String> _labels(WidgetTester tester) {
  final List<String> labels = <String>[];
  for (final Text text in tester.widgetList<Text>(
    find.descendant(of: find.byType(Calendar), matching: find.byType(Text)),
  )) {
    labels.add(text.data ?? '');
  }

  return labels;
}

/// Fill of the cell whose label is [label]; null when there is no such cell.
Color? _fillOf(WidgetTester tester, String label) {
  final Finder cell = find.ancestor(
    of: find.text(label),
    matching: find.byType(Container),
  );
  if (cell.evaluate().isEmpty) return null;
  return (tester.widget<Container>(cell.first).decoration! as BoxDecoration)
      .color;
}

/// The container wrapping the cell whose label is [label].
Finder _cellFinder(WidgetTester tester, String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(Container)).first;

Container _cellOf(WidgetTester tester, String label) =>
    tester.widget<Container>(_cellFinder(tester, label));

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;
  const CalendarView march = CalendarView(2024, 3);

  group('date grid', () {
    testWidgets('draws a weekday header and whole weeks', (tester) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.date)),
      );
      // March 2024 starts on a Friday, so a Monday-first grid opens on the
      // 26th of February.
      expect(_labels(tester).take(7), <String>[
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ]);
      expect(_labels(tester)[7], '26');
      expect(_labels(tester).length % 7, 0);
    });

    testWidgets('starts on Sunday when asked', (tester) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, firstDayOfWeek: DateTime.sunday)),
      );
      expect(_labels(tester).take(7).first, 'Sun');
      // February 25, 2024 is the Sunday that opens March in a Sunday-first grid.
      expect(_labels(tester)[7], '25');
    });

    testWidgets('rejects a weekday outside 1..7', (tester) async {
      expect(
        () => Calendar(view: march, firstDayOfWeek: 0),
        throwsAssertionError,
      );
      expect(
        () => Calendar(view: march, firstDayOfWeek: 8),
        throwsAssertionError,
      );
    });

    testWidgets('paints seven cells with four-pixel gaps', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      final Rect first = tester.getRect(_cellFinder(tester, '26'));
      final Rect second = tester.getRect(_cellFinder(tester, '27'));
      expect(first.width, 32);
      expect(second.left - first.right, 4);
      // The 1st sits four columns after the leading cell.
      expect(
        tester.getRect(_cellFinder(tester, '1')).left - first.left,
        4 * 36,
      );
    });

    testWidgets('a month view renders every day once', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      final List<String> labels = _labels(tester).sublist(7);
      expect(labels.where((String l) => l == '31'), hasLength(1));
      // February 26 to March 31 is exactly five whole weeks.
      expect(labels.length, 35);
    });

    testWidgets('regression: every cell of a DST month is a real date', (
      tester,
    ) async {
      // March 2024 crosses the European DST switch on the 31st. The old grid
      // stepped with `Duration(days: i)`, which can repeat or skip a day.
      final List<DateGridCell> cells = monthGrid(2024, 3);
      final Set<int> days = cells.map((DateGridCell c) => c.date.day).toSet();
      expect(days.length, 31);
      expect(cells.first.date.day, 26);
      expect(cells.last.date, DateTime(2024, 3, 31));
      expect(cells.length, 35);
    });

    testWidgets('regression: days outside the month are dimmed', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      // Jan 29 opens the grid, so it must read as outside March.
      final Opacity dimmed = tester.widget<Opacity>(
        find
            .ancestor(of: find.text('29'), matching: find.byType(Opacity))
            .first,
      );
      expect(dimmed.opacity, 0.5);
    });
  });

  group('month and year grids', () {
    testWidgets('a month view draws twelve cells four to a row', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.month)),
      );
      expect(_labels(tester), hasLength(12));
      expect(_labels(tester).first, 'Jan');
      expect(_labels(tester).last, 'Dec');
    });

    testWidgets('a month view taps back into a single date', (tester) async {
      CalendarValue? next;
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            viewType: CalendarViewType.month,
            selectionMode: CalendarSelectionMode.single,
            onChanged: (CalendarValue? value) => next = value,
          ),
        ),
      );
      await tester.tap(find.text('Jun'));
      await tester.pump();
      expect(next, CalendarValue.single(DateTime(2024, 6)));
    });

    testWidgets('a year view draws sixteen years including the view year', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.year)),
      );
      final List<String> labels = _labels(tester);
      expect(labels, hasLength(16));
      expect(labels, contains('2024'));
      expect(labels.first, '${(2024 - 5) ~/ 10 * 10}');
    });

    testWidgets('a year grid is wider than a date cell', (tester) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.year)),
      );
      final Size cell = tester.getSize(
        find
            .ancestor(of: find.text('2024'), matching: find.byType(Container))
            .first,
      );
      expect(cell.width, greaterThan(cell.height));
      expect(cell.width, 56);
      expect(cell.height, 40);
    });
  });

  group('selection', () {
    testWidgets('single mode selects, then clears', (tester) async {
      final List<CalendarValue?> log = <CalendarValue?>[];
      CalendarValue? value;
      await tester.pumpWidget(
        _frame(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter set) => Calendar(
              view: march,
              selectionMode: CalendarSelectionMode.single,
              value: value,
              onChanged: (CalendarValue? next) =>
                  set(() => log.add(value = next)),
            ),
          ),
        ),
      );
      await tester.tap(find.text('5'));
      await tester.pump();
      expect(value, CalendarValue.single(DateTime(2024, 3, 5)));

      await tester.tap(find.text('5'));
      await tester.pump();
      expect(value, isNull);
      expect(log, <CalendarValue?>[
        CalendarValue.single(DateTime(2024, 3, 5)),
        null,
      ]);
    });

    testWidgets('range mode builds a range across two taps', (tester) async {
      CalendarValue? value;
      await tester.pumpWidget(
        _frame(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter set) => Calendar(
              view: march,
              selectionMode: CalendarSelectionMode.range,
              value: value,
              onChanged: (CalendarValue? next) => set(() => value = next),
            ),
          ),
        ),
      );
      await tester.tap(find.text('5'));
      await tester.pump();
      expect(value, CalendarValue.single(DateTime(2024, 3, 5)));

      await tester.tap(find.text('9'));
      await tester.pump();
      expect(
        value,
        CalendarValue.range(DateTime(2024, 3, 5), DateTime(2024, 3, 9)),
      );
    });

    testWidgets('range mode orders a backwards pick', (tester) async {
      final Calendar calendar = Calendar(
        view: march,
        selectionMode: CalendarSelectionMode.range,
        value: CalendarValue.range(DateTime(2024, 3, 5), DateTime(2024, 3, 9)),
      );
      expect(
        calendar.select(DateTime(2024, 3, 2)),
        CalendarValue.range(DateTime(2024, 3, 2), DateTime(2024, 3, 9)),
      );
    });

    testWidgets('range mode clears from the start and narrows from the end', (
      tester,
    ) async {
      final Calendar calendar = Calendar(
        view: march,
        selectionMode: CalendarSelectionMode.range,
        value: CalendarValue.range(DateTime(2024, 3, 5), DateTime(2024, 3, 9)),
      );
      expect(calendar.select(DateTime(2024, 3, 5)), isNull);
      expect(
        calendar.select(DateTime(2024, 3, 9)),
        CalendarValue.single(DateTime(2024, 3, 9)),
      );
      expect(
        calendar.select(DateTime(2024, 3, 7)),
        CalendarValue.range(DateTime(2024, 3, 5), DateTime(2024, 3, 7)),
      );
    });

    testWidgets('multi mode adds then removes', (tester) async {
      CalendarValue? value;
      await tester.pumpWidget(
        _frame(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter set) => Calendar(
              view: march,
              selectionMode: CalendarSelectionMode.multi,
              value: value,
              onChanged: (CalendarValue? next) => set(() => value = next),
            ),
          ),
        ),
      );
      await tester.tap(find.text('4'));
      await tester.pump();
      expect(value, CalendarValue.multi(<DateTime>[DateTime(2024, 3, 4)]));

      await tester.tap(find.text('6'));
      await tester.pump();
      expect(
        value,
        CalendarValue.multi(<DateTime>[
          DateTime(2024, 3, 4),
          DateTime(2024, 3, 6),
        ]),
      );

      await tester.tap(find.text('4'));
      await tester.pump();
      expect(value, CalendarValue.multi(<DateTime>[DateTime(2024, 3, 6)]));

      await tester.tap(find.text('6'));
      await tester.pump();
      expect(value, isNull);
    });

    testWidgets('multi mode does not explode an existing range', (
      tester,
    ) async {
      // The old `toMulti()` on a range walked day by day: a ten-year range
      // allocated 3,650 DateTimes inside a tap handler.
      final Calendar calendar = Calendar(
        view: march,
        selectionMode: CalendarSelectionMode.multi,
        value: CalendarValue.range(DateTime(2024, 1, 1), DateTime(2034, 1, 1)),
      );
      final CalendarValue? next = calendar.select(DateTime(2024, 3, 5));
      expect(next, isA<MultiCalendarValue>());
      expect((next! as MultiCalendarValue).dates, <DateTime>[
        DateTime(2024, 3, 5),
      ]);
    });

    testWidgets('none mode never reports a change', (tester) async {
      final List<CalendarValue?> log = <CalendarValue?>[];
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            onChanged: (CalendarValue? value) => log.add(value),
          ),
        ),
      );
      await tester.tap(find.text('5'));
      await tester.pump();
      expect(log, isEmpty);
    });

    testWidgets('without onChanged the grid is read-only', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      await tester.tap(find.text('5'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('a disabled cell ignores its tap', (tester) async {
      final List<CalendarValue?> log = <CalendarValue?>[];
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            selectionMode: CalendarSelectionMode.single,
            stateBuilder: (DateTime date) =>
                date.day.isEven ? DateState.disabled : DateState.enabled,
            onChanged: (CalendarValue? value) => log.add(value),
          ),
        ),
      );
      await tester.tap(find.text('4'));
      await tester.pump();
      expect(log, isEmpty);

      await tester.tap(find.text('5'));
      await tester.pump();
      expect(log.single, CalendarValue.single(DateTime(2024, 3, 5)));
    });

    testWidgets('a disabled cell is dimmed to 50%', (tester) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, stateBuilder: _evenDaysDisabled)),
      );
      expect(
        tester
            .widget<Opacity>(
              find
                  .ancestor(of: find.text('4'), matching: find.byType(Opacity))
                  .first,
            )
            .opacity,
        0.5,
      );
      expect(
        tester
            .widget<Opacity>(
              find
                  .ancestor(of: find.text('5'), matching: find.byType(Opacity))
                  .first,
            )
            .opacity,
        1,
      );
    });
  });

  group('values', () {
    test('single looks itself up at every granularity', () {
      final CalendarValue value = SingleCalendarValue(DateTime(2024, 3, 5));
      expect(
        value.lookupDate(DateTime(2024, 3, 5)),
        CalendarValueLookup.selected,
      );
      expect(value.lookupDate(DateTime(2024, 3, 6)), CalendarValueLookup.none);
      expect(value.lookupMonth(2024, 3), CalendarValueLookup.selected);
      expect(value.lookupYear(2024), CalendarValueLookup.selected);
      expect(value.lookupYear(2023), CalendarValueLookup.none);
    });

    test('range reports start, in-range, end and none', () {
      final CalendarValue value = CalendarValue.range(
        DateTime(2024, 3, 5),
        DateTime(2024, 3, 9),
      );
      expect(value.lookupDate(DateTime(2024, 3, 5)), CalendarValueLookup.start);
      expect(
        value.lookupDate(DateTime(2024, 3, 7)),
        CalendarValueLookup.inRange,
      );
      expect(value.lookupDate(DateTime(2024, 3, 9)), CalendarValueLookup.end);
      expect(value.lookupDate(DateTime(2024, 3, 10)), CalendarValueLookup.none);
    });

    test('range orders its constructor arguments', () {
      final RangeCalendarValue value = RangeCalendarValue(
        DateTime(2024, 3, 9),
        DateTime(2024, 3, 5),
      );
      expect(value.start, DateTime(2024, 3, 5));
      expect(value.end, DateTime(2024, 3, 9));
    });

    test('range looks up months and years by span', () {
      final CalendarValue value = CalendarValue.range(
        DateTime(2024, 2, 20),
        DateTime(2024, 5, 2),
      );
      expect(value.lookupMonth(2024, 2), CalendarValueLookup.start);
      expect(value.lookupMonth(2024, 3), CalendarValueLookup.inRange);
      expect(value.lookupMonth(2024, 5), CalendarValueLookup.end);
      expect(value.lookupMonth(2024, 1), CalendarValueLookup.none);
      expect(value.lookupYear(2024), CalendarValueLookup.start);
      expect(value.lookupYear(2025), CalendarValueLookup.none);
    });

    test('a one-day range reports start, not a stray end', () {
      final CalendarValue value = CalendarValue.range(
        DateTime(2024, 3, 5),
        DateTime(2024, 3, 5),
      );
      expect(value.lookupDate(DateTime(2024, 3, 5)), CalendarValueLookup.start);
    });

    test('multi compares and hashes by content', () {
      final CalendarValue a = CalendarValue.multi(<DateTime>[
        DateTime(2024, 3, 1),
        DateTime(2024, 3, 2),
      ]);
      final CalendarValue b = CalendarValue.multi(<DateTime>[
        DateTime(2024, 3, 1),
        DateTime(2024, 3, 2),
      ]);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(CalendarValue.multi(<DateTime>[DateTime(2024, 3, 1)])));
    });

    test('regression: a view never walks into an invalid month', () {
      expect(() => CalendarView(2024, 0), throwsAssertionError);
      expect(() => CalendarView(2024, 13), throwsAssertionError);
      expect(const CalendarView(2024, 12).next, const CalendarView(2025, 1));
      expect(
        const CalendarView(2024, 1).previous,
        const CalendarView(2023, 12),
      );
    });

    test('regression: three lookups replace the old defaulted-argument one', () {
      // `lookup(2024)` used to mean "January 2024"; there is no such thing as a
      // bare lookup any more.
      final CalendarValue january = SingleCalendarValue(DateTime(2024, 1, 9));
      expect(january.lookupMonth(2024, 2), CalendarValueLookup.none);
      expect(january.lookupYear(2024), CalendarValueLookup.selected);
    });
  });

  group('today', () {
    testWidgets('marks the injected today', (tester) async {
      await tester.pumpWidget(_frame(Calendar(view: march, now: _today)));
      expect(_fillOf(tester, '14'), colors.secondary);
    });

    testWidgets('marks nothing without `now`', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      expect(_fillOf(tester, '14'), const Color(0x00000000));
    });

    testWidgets('the month grid marks the today month', (tester) async {
      await tester.pumpWidget(
        _frame(
          Calendar(view: march, now: _today, viewType: CalendarViewType.month),
        ),
      );
      expect(_fillOf(tester, 'Mar'), colors.secondary);
    });

    testWidgets('regression: today follows the injection, not the clock', (
      tester,
    ) async {
      // The old `CalendarGridItem.isToday` read `DateTime.now()` inside the
      // widget, so this could never have rendered "today" as the 3rd.
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            now: _today,
            selectionMode: CalendarSelectionMode.none,
          ),
        ),
      );
      expect(_fillOf(tester, '14'), isNot(const Color(0x00000000)));
      expect(_fillOf(tester, '15'), const Color(0x00000000));
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors palette) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('$name tokens drive an unselected cell', (tester) async {
        await tester.pumpWidget(
          _frame(
            const Calendar(view: march),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_fillOf(tester, '5'), const Color(0x00000000));
        expect(
          tester.widget<Text>(find.text('5')).style!.color,
          palette.foreground,
        );
      });

      testWidgets('$name tokens drive today and selection', (tester) async {
        await tester.pumpWidget(
          _frame(
            Calendar(
              view: march,
              now: _today,
              value: SingleCalendarValue(DateTime(2024, 3, 5)),
            ),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_fillOf(tester, '14'), palette.secondary);
        expect(_fillOf(tester, '5'), palette.primary);
      });

      testWidgets('$name tokens drive a range', (tester) async {
        await tester.pumpWidget(
          _frame(
            Calendar(
              view: march,
              value: CalendarValue.range(
                DateTime(2024, 3, 5),
                DateTime(2024, 3, 9),
              ),
            ),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_fillOf(tester, '5'), palette.secondary);
        expect(_fillOf(tester, '7'), palette.secondary);
        expect(_fillOf(tester, '9'), palette.secondary);
        expect(_fillOf(tester, '10'), const Color(0x00000000));
      });
    }
  });

  group('theme', () {
    testWidgets('the widget leg wins over every other leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            now: _today,
            theme: const CalendarTheme(
              todayBackground: ThemedColor.value(_green),
            ),
          ),
          app: const <ComponentThemeData>[
            CalendarTheme(todayBackground: ThemedColor.value(_blue)),
          ],
        ),
      );
      expect(_fillOf(tester, '14'), _green);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          Calendar(view: march, now: _today),
          app: const <ComponentThemeData>[
            CalendarTheme(todayBackground: ThemedColor.value(_blue)),
          ],
          scoped: const CalendarTheme(
            todayBackground: ThemedColor.value(_green),
          ),
        ),
      );
      expect(_fillOf(tester, '14'), _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          Calendar(view: march, now: _today),
          app: const <ComponentThemeData>[
            CalendarTheme(todayBackground: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_fillOf(tester, '14'), _green);
    });

    testWidgets('a leg that sets only the fill keeps the default size', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          Calendar(view: march, now: _today),
          scoped: const CalendarTheme(
            todayBackground: ThemedColor.value(_green),
          ),
        ),
      );
      expect(_fillOf(tester, '14'), _green);
      expect(_cellOf(tester, '14').constraints!.maxHeight, 32);
    });

    testWidgets('cell size and gap are theme rows', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Calendar(view: march),
          scoped: const CalendarTheme(cellHeight: 40, gap: 8),
        ),
      );
      final Rect first = tester.getRect(_cellFinder(tester, '26'));
      final Rect second = tester.getRect(_cellFinder(tester, '27'));
      expect(first.height, 40);
      expect(second.left - first.right, 8);
    });

    testWidgets('the cell radius is a theme row', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Calendar(view: march),
          scoped: const CalendarTheme(
            cellBorderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      );
      expect(
        (_cellOf(tester, '5').decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(14),
      );
    });

    testWidgets('the radius falls back to borderRadiusMd', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      expect(
        (_cellOf(tester, '5').decoration! as BoxDecoration).borderRadius,
        const ShadcnThemeData().borderRadiusMd,
      );
    });

    testWidgets('rebuilds the grid when the app theme changes', (tester) async {
      Widget frame(Color color) => _frame(
        Calendar(view: march, now: _today),
        app: <ComponentThemeData>[
          CalendarTheme(todayBackground: ThemedColor.value(color)),
        ],
      );
      await tester.pumpWidget(frame(_green));
      expect(_fillOf(tester, '14'), _green);
      await tester.pumpWidget(frame(_blue));
      expect(_fillOf(tester, '14'), _blue);
    });
  });

  group('keyboard', () {
    /// The label of the cell wearing the focus ring, or null when none does.
    String? focusedLabel(WidgetTester tester) {
      final Finder focused = find.byWidgetPredicate(
        (Widget w) => w is FocusOutline && w.focused,
      );
      if (focused.evaluate().isEmpty) return null;
      return tester
          .widget<Text>(
            find.descendant(of: focused.first, matching: find.byType(Text)),
          )
          .data;
    }

    Widget grid({
      CalendarView view = march,
      CalendarSelectionMode mode = CalendarSelectionMode.single,
      CalendarValue? value,
      DateTime? now,
      DateStateBuilder? stateBuilder,
      ValueChanged<CalendarView>? onViewChanged,
      bool autofocus = false,
      Object? nowFocus,
    }) => _frame(
      Calendar(
        view: view,
        now: now ?? _today,
        autofocus: autofocus,
        value: value,
        selectionMode: mode,
        onViewChanged: onViewChanged,
        stateBuilder: stateBuilder,
        onChanged: (CalendarValue? _) {},
      ),
    );

    /// Sends [key] (with [shift] held when set) to the grid.
    Future<void> key(
      WidgetTester tester,
      LogicalKeyboardKey key, {
      bool shift = false,
    }) async {
      if (shift) await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
      await tester.sendKeyEvent(key);
      if (shift) await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
      await tester.pump();
    }

    testWidgets('the grid is one tab stop, not one per cell', (tester) async {
      await tester.pumpWidget(grid(autofocus: true));
      expect(focusedLabel(tester), '14');
      // One ring per day cell, and only the focused one lit.
      expect(find.byType(FocusOutline), findsNWidgets(35));
      final int nodes = find.byType(Focus).evaluate().length;
      // A 16-cell year grid must not carry any more focus nodes than the
      // 35-cell date grid: the cells do not own one.
      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.year)),
      );
      expect(find.byType(Focus).evaluate().length, nodes);
    });

    testWidgets('autofocus is off by default', (tester) async {
      await tester.pumpWidget(grid());
      // The ring is drawn on the remembered day before the grid is focused, and
      // focus itself has not been requested.
      expect(focusedLabel(tester), '14');
      expect(
        find.byWidgetPredicate(
          (Widget w) => w is FocusableActionDetector && w.autofocus,
        ),
        findsNothing,
        reason: 'autofocus defaults to false',
      );
      expect(
        tester.binding.focusManager.primaryFocus?.debugLabel,
        isNot('Calendar'),
      );
      // Once the key handler has focus, the same keys move the focus.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(focusedLabel(tester), '14');
    });

    testWidgets('ArrowRight moves one day, ArrowLeft moves back', (
      tester,
    ) async {
      await tester.pumpWidget(grid(autofocus: true));
      await key(tester, LogicalKeyboardKey.arrowRight);
      expect(focusedLabel(tester), '15');
      await key(tester, LogicalKeyboardKey.arrowRight);
      expect(focusedLabel(tester), '16');
      await key(tester, LogicalKeyboardKey.arrowLeft);
      expect(focusedLabel(tester), '15');
    });

    testWidgets('ArrowRight wraps at the end of a row', (tester) async {
      // The 14th is the last cell of its row in a Monday-first March 2024.
      await tester.pumpWidget(grid(autofocus: true));
      await key(tester, LogicalKeyboardKey.arrowRight);
      expect(focusedLabel(tester), '15');
    });

    testWidgets('ArrowDown moves a week, ArrowUp comes back', (tester) async {
      await tester.pumpWidget(grid(autofocus: true));
      await key(tester, LogicalKeyboardKey.arrowDown);
      expect(focusedLabel(tester), '21');
      await key(tester, LogicalKeyboardKey.arrowUp);
      expect(focusedLabel(tester), '14');
    });

    testWidgets('ArrowDown stops at the last row', (tester) async {
      await tester.pumpWidget(grid(autofocus: true));
      for (var hop = 0; hop < 8; hop++) {
        await key(tester, LogicalKeyboardKey.arrowDown);
      }
      // March 2024 draws Feb 26 - Mar 31, so a week below the 28th is off the
      // grid: the focus stays put instead of wrapping into the wrong row.
      expect(focusedLabel(tester), '28');
    });

    testWidgets('Home and End jump to the ends of the week', (tester) async {
      await tester.pumpWidget(grid(autofocus: true));
      // The 14th is a Thursday; its week runs Monday the 11th to Sunday 17th.
      await key(tester, LogicalKeyboardKey.home);
      expect(focusedLabel(tester), '11');
      await key(tester, LogicalKeyboardKey.end);
      expect(focusedLabel(tester), '17');
    });

    testWidgets('PageDown moves a month and PageUp comes back', (tester) async {
      await tester.pumpWidget(_Following());
      expect(focusedLabel(tester), '14');
      await key(tester, LogicalKeyboardKey.pageDown);
      // The caller owns `view`, so the move reports the new month and the grid
      // follows it on the next frame, keeping the focused day.
      expect(_FollowLog.views.last, const CalendarView(2024, 4));
      // April is drawn now: it has 30 days, so the 31st is gone.
      expect(find.text('31'), findsNothing);
      expect(find.text('30'), findsWidgets);
      // The 14th wears the ring: the focus followed the month.
      expect(focusedLabel(tester), '14');
      await key(tester, LogicalKeyboardKey.pageUp);
      expect(_FollowLog.views.last, const CalendarView(2024, 3));
      expect(focusedLabel(tester), '14');
    });

    testWidgets('Shift+PageDown moves a year', (tester) async {
      await tester.pumpWidget(_Following());
      await key(tester, LogicalKeyboardKey.pageDown, shift: true);
      expect(_FollowLog.views.last, const CalendarView(2025, 3));
      expect(focusedLabel(tester), '14');
      await key(tester, LogicalKeyboardKey.pageUp, shift: true);
      expect(_FollowLog.views.last, const CalendarView(2024, 3));
      expect(focusedLabel(tester), '14');
    });

    testWidgets('a move past the month edge reports the new month', (
      tester,
    ) async {
      await tester.pumpWidget(_Following());
      // The 31st is the last cell of the last row; the next day is not drawn.
      await key(tester, LogicalKeyboardKey.end);
      for (var hop = 0; hop < 3; hop++) {
        await key(tester, LogicalKeyboardKey.arrowDown);
      }
      expect(focusedLabel(tester), '31');
      await key(tester, LogicalKeyboardKey.pageDown);
      expect(_FollowLog.views.last, const CalendarView(2024, 4));
    });

    testWidgets('Enter selects the focused day', (tester) async {
      final List<CalendarValue?> log = <CalendarValue?>[];
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            now: _today,
            autofocus: true,
            selectionMode: CalendarSelectionMode.single,
            onChanged: log.add,
          ),
        ),
      );
      await key(tester, LogicalKeyboardKey.arrowRight);
      await key(tester, LogicalKeyboardKey.enter);
      expect(log.single, CalendarValue.single(DateTime(2024, 3, 15)));
    });

    testWidgets('Space selects the focused day', (tester) async {
      final List<CalendarValue?> log = <CalendarValue?>[];
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            now: _today,
            autofocus: true,
            selectionMode: CalendarSelectionMode.single,
            onChanged: log.add,
          ),
        ),
      );
      await key(tester, LogicalKeyboardKey.space);
      expect(log.single, CalendarValue.single(DateTime(2024, 3, 14)));
    });

    testWidgets('a disabled cell is skipped by ArrowRight', (tester) async {
      await tester.pumpWidget(
        grid(autofocus: true, stateBuilder: _oddDaysDisabled),
      );
      // Every even day is disabled, so the 14th of March is not a candidate.
      expect(focusedLabel(tester), '27');
      await key(tester, LogicalKeyboardKey.arrowRight);
      expect(focusedLabel(tester), '29');
      await key(tester, LogicalKeyboardKey.arrowLeft);
      expect(focusedLabel(tester), '27');
    });

    testWidgets('a disabled cell is skipped by ArrowDown', (tester) async {
      await tester.pumpWidget(
        grid(autofocus: true, stateBuilder: _oddDaysDisabled),
      );
      // Feb 27 is a week above Mar 5, not Mar 4: the disabled 4th is skipped.
      await key(tester, LogicalKeyboardKey.arrowDown);
      expect(focusedLabel(tester), '5');
    });

    testWidgets('Home skips to the first enabled day of the week', (
      tester,
    ) async {
      await tester.pumpWidget(
        grid(autofocus: true, stateBuilder: _oddDaysDisabled),
      );
      // The row starts on Monday Feb 26, which is disabled; the 27th is not.
      await key(tester, LogicalKeyboardKey.home);
      expect(focusedLabel(tester), '27');
    });

    testWidgets('the focus starts on the first enabled day', (tester) async {
      // `now` is the 14th, which is disabled, so the focus lands on the first
      // day the grid draws that can be picked: Tuesday Feb 27.
      await tester.pumpWidget(
        grid(autofocus: true, stateBuilder: _oddDaysDisabled),
      );
      expect(focusedLabel(tester), '27');
    });

    testWidgets('the month grid traverses with the arrow keys', (tester) async {
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            viewType: CalendarViewType.month,
            now: _today,
            autofocus: true,
            selectionMode: CalendarSelectionMode.single,
            onChanged: (CalendarValue? _) {},
          ),
        ),
      );
      expect(focusedLabel(tester), 'Mar');
      await key(tester, LogicalKeyboardKey.arrowRight);
      expect(focusedLabel(tester), 'Apr');
      await key(tester, LogicalKeyboardKey.arrowLeft);
      expect(focusedLabel(tester), 'Mar');
    });

    testWidgets('a read-only grid reports nothing on Enter', (tester) async {
      final List<CalendarValue?> log = <CalendarValue?>[];
      await tester.pumpWidget(
        _frame(
          Calendar(
            view: march,
            now: _today,
            autofocus: true,
            selectionMode: CalendarSelectionMode.none,
            onChanged: log.add,
          ),
        ),
      );
      await key(tester, LogicalKeyboardKey.enter);
      expect(log, isEmpty);
    });

    testWidgets('semantics labels each day with the full date', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(grid(autofocus: true));
      expect(
        find.bySemanticsLabel('Mar 14, 2024'),
        findsOneWidget,
        reason: 'a screen reader must hear the date, not the number',
      );
      expect(find.bySemanticsLabel('Mar 15, 2024'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('semantics marks a cell a button and its state', (
      tester,
    ) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      await tester.pumpWidget(
        grid(
          autofocus: true,
          value: CalendarValue.single(DateTime(2024, 3, 14)),
          stateBuilder: _oddDaysDisabled,
        ),
      );
      expect(find.bySemanticsLabel('Mar 14, 2024'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('regression: only one ring is ever on screen', (tester) async {
      await tester.pumpWidget(grid(autofocus: true));
      int rings() => find
          .byWidgetPredicate((Widget w) => w is FocusOutline && w.focused)
          .evaluate()
          .length;
      expect(rings(), 1);
      for (final LogicalKeyboardKey k in <LogicalKeyboardKey>[
        LogicalKeyboardKey.arrowRight,
        LogicalKeyboardKey.arrowDown,
        LogicalKeyboardKey.end,
        LogicalKeyboardKey.home,
        LogicalKeyboardKey.arrowUp,
      ]) {
        await key(tester, k);
        expect(rings(), 1, reason: 'after $k');
      }
    });
  });

  group('sizes', () {
    testWidgets('a day cell is 32x32, shadcn size-8', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      expect(tester.getSize(_cellFinder(tester, '14')), const Size(32, 32));
      expect(tester.getSize(_cellFinder(tester, '1')), const Size(32, 32));
    });

    testWidgets('the weekday header matches the day cell', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      final Rect header = tester.getRect(find.text('Mon'));
      final Rect cell = tester.getRect(_cellFinder(tester, '26'));
      expect(header.size.width, cell.size.width);
      expect(header.center.dy, isNot(cell.center.dy));
    });

    testWidgets('a month cell is 56x40 and a year cell too', (tester) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.month)),
      );
      expect(tester.getSize(_cellFinder(tester, 'Jan')), const Size(56, 40));

      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.year)),
      );
      expect(tester.getSize(_cellFinder(tester, '2024')), const Size(56, 40));
    });

    testWidgets('the theme rows scale the cell', (tester) async {
      await tester.pumpWidget(
        _frame(
          const Calendar(view: march),
          scoped: const CalendarTheme(cellHeight: 40, cellWidth: 36),
        ),
      );
      expect(tester.getSize(_cellFinder(tester, '14')), const Size(36, 40));
    });

    testWidgets('the preview stepper buttons are 24x24', (tester) async {
      // `Calendar` owns no navigation: `view` is the caller's, so the month
      // stepper belongs to the caller. The default example of the preview
      // contract builds one, and its tap target is exactly 24x24.
      await tester.pumpWidget(
        _frame(Builder(builder: calendarPreviews.first.builder)),
      );
      final Finder steps = find.byWidgetPredicate(
        (Widget widget) =>
            widget is Container &&
            widget.constraints?.maxWidth == 24 &&
            widget.constraints?.maxHeight == 24,
      );
      // The header carries one previous and one next stepper.
      expect(steps, findsNWidgets(2));
      expect(tester.getSize(steps.first), const Size(24, 24));
    });
  });

  group('regressions', () {
    testWidgets('regression: no Material, no Scaffold, no part', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      expect(find.byType(Calendar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('regression: cells are square and identical', (tester) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: march, viewType: CalendarViewType.month)),
      );
      final Size first = tester.getSize(
        find
            .ancestor(of: find.text('Jan'), matching: find.byType(Container))
            .first,
      );
      final Size last = tester.getSize(
        find
            .ancestor(of: find.text('Dec'), matching: find.byType(Container))
            .first,
      );
      expect(first, last);
    });

    testWidgets('regression: an empty grid paints nothing extra', (
      tester,
    ) async {
      // February 2021 (28 days, starting Monday) is exactly four rows.
      await tester.pumpWidget(
        _frame(const Calendar(view: CalendarView(2021, 2))),
      );
      expect(_labels(tester).length, 7 + 28);
    });

    testWidgets('regression: a leap February still ends on the 29th', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(const Calendar(view: CalendarView(2024, 2))),
      );
      expect(_labels(tester), contains('29'));
    });

    testWidgets('regression: the grid has no unbounded size', (tester) async {
      await tester.pumpWidget(_frame(const Calendar(view: march)));
      expect(tester.getSize(find.byType(Calendar)).width.isFinite, isTrue);
      expect(tester.getSize(find.byType(Calendar)).height.isFinite, isTrue);
    });
  });

  group('narrow columns', () {
    Widget narrowFrame(double width, Widget child) => ShadcnTheme(
      data: const ShadcnThemeData(),
      child: ComponentThemes(
        themes: const <ComponentThemeData>[],
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Localizations(
            locale: const Locale('en'),
            delegates: const <LocalizationsDelegate<dynamic>>[
              DefaultWidgetsLocalizations.delegate,
              ShadcnLocalizations.delegate,
            ],
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: width, child: child),
            ),
          ),
        ),
      ),
    );

    for (final double width in <double>[240, 300, 375]) {
      testWidgets('a date grid fits at $width px, cells stay tappable', (
        tester,
      ) async {
        CalendarValue? value;
        await tester.pumpWidget(
          narrowFrame(
            width,
            StatefulBuilder(
              builder: (BuildContext context, StateSetter set) => Calendar(
                view: march,
                selectionMode: CalendarSelectionMode.single,
                value: value,
                onChanged: (CalendarValue? next) => set(() => value = next),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        final Size grid = tester.getSize(find.byType(Calendar));
        expect(grid.width, lessThanOrEqualTo(width));
        // 300 px and up hold the nominal 32 px cells; 240 px shrinks them.
        final double cellWidth = tester
            .getSize(_cellFinder(tester, '14'))
            .width;
        if (width >= 300) {
          expect(cellWidth, 32);
        } else {
          expect(cellWidth, lessThan(32));
          expect(cellWidth, greaterThanOrEqualTo(28));
        }
        // The weekday header keeps the shrunken pitch.
        expect(tester.getRect(find.text('Mon')).width, cellWidth);
        // A shrunken cell still selects its date.
        await tester.tap(find.text('15'));
        await tester.pump();
        expect(value, CalendarValue.single(DateTime(2024, 3, 15)));
      });

      testWidgets('month and year grids fit at $width px', (tester) async {
        await tester.pumpWidget(
          narrowFrame(
            width,
            const Calendar(view: march, viewType: CalendarViewType.month),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(Calendar)).width,
          lessThanOrEqualTo(width),
        );
        expect(find.text('Jan'), findsOneWidget);

        await tester.pumpWidget(
          narrowFrame(
            width,
            const Calendar(view: march, viewType: CalendarViewType.year),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(Calendar)).width,
          lessThanOrEqualTo(width),
        );
        expect(find.text('2024'), findsOneWidget);
      });
    }
  });
}

/// [Calendar.stateBuilder] that disables every even day.
DateState _evenDaysDisabled(DateTime date) =>
    date.day.isEven ? DateState.disabled : DateState.enabled;

/// [Calendar.stateBuilder] that disables every even day.
DateState _oddDaysDisabled(DateTime date) =>
    date.day.isOdd ? DateState.enabled : DateState.disabled;

/// Log of the views a [Calendar] reported, so a test can read them.
class _FollowLog {
  static final List<CalendarView> views = <CalendarView>[];
}

/// A [Calendar] that follows its own `onViewChanged`, which is how a caller
/// supplies the navigation the widget deliberately does not own.
class _Following extends StatefulWidget {
  const _Following();

  @override
  State<_Following> createState() => _FollowingState();
}

class _FollowingState extends State<_Following> {
  CalendarView _view = const CalendarView(2024, 3);

  @override
  Widget build(BuildContext context) => _frame(
    Calendar(
      view: _view,
      now: _today,
      autofocus: true,
      selectionMode: CalendarSelectionMode.single,
      onChanged: (CalendarValue? _) {},
      onViewChanged: (CalendarView view) {
        _FollowLog.views.add(view);
        setState(() => _view = view);
      },
    ),
  );
}
