// Widget tests for the `object_input` component.
//
// Covers: locale placeholders, typing valid/invalid dates (month 13 and
// February 30 report null), controlled display, locale order overrides,
// uncontrolled focus/shape retention across parent rebuilds, time and
// duration fields (ranges, seconds), disabled dimming, validation, the
// calendar dialog, widget-leg theme forwarding and field metrics (h-9).

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/date_picker/date_picker.dart';
import 'package:flutter_shadcn_kit/registry/components/formatted_input/formatted_input.dart';
import 'package:flutter_shadcn_kit/registry/components/object_input/object_input.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry/foundation/time_of_day.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/object_form_field.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/locale_parts.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager_layer.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const ShadcnColors _dark = ShadcnColors.darkFallback;

/// Echo harness: feeds reported values back as the controlled value.
class _DateHarness extends StatefulWidget {
  const _DateHarness({this.datePartsOrder, this.validator, this.onChanged});

  final List<DatePart>? datePartsOrder;
  final String? Function(DateTime? value)? validator;
  final ValueChanged<DateTime?>? onChanged;

  @override
  State<_DateHarness> createState() => _DateHarnessState();
}

class _DateHarnessState extends State<_DateHarness> {
  DateTime? value;

  @override
  Widget build(BuildContext context) {
    return DateInput(
      value: value,
      onChanged: (DateTime? next) {
        widget.onChanged?.call(next);
        setState(() => value = next);
      },
      datePartsOrder: widget.datePartsOrder,
      validator: widget.validator,
    );
  }
}

Future<void> _pump(WidgetTester tester, Widget child) {
  // EditableText needs an Overlay ancestor once a segment takes focus.
  return tester.pumpWidget(
    ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: <OverlayEntry>[
            OverlayEntry(
              builder: (BuildContext context) =>
                  Center(child: SizedBox(width: 360, child: child)),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _pumpNav(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: Navigator(
            onGenerateRoute: (RouteSettings settings) => PageRouteBuilder<void>(
              settings: settings,
              pageBuilder: (context, _, _) =>
                  Center(child: SizedBox(width: 360, child: child)),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Frame for prompt tests: overlay manager (popover needs it), sized media
/// (width resolves the default mode), navigator (dialog needs it).
Future<void> _pumpPrompt(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(1200, 800),
}) {
  return tester.pumpWidget(
    ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: OverlayManagerLayer(
            popoverHandler: OverlayHandler.popover,
            tooltipHandler: OverlayHandler.popover,
            menuHandler: OverlayHandler.popover,
            child: Navigator(
              onGenerateRoute: (RouteSettings settings) =>
                  PageRouteBuilder<void>(
                    settings: settings,
                    pageBuilder: (context, _, _) =>
                        Center(child: SizedBox(width: 360, child: child)),
                  ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Types [texts] into the segments in order (default locale order month,
/// day, year unless the harness overrides it).
Future<void> _typeSegments(WidgetTester tester, List<String> texts) async {
  for (int i = 0; i < texts.length; i++) {
    await tester.enterText(find.byType(EditableText).at(i), texts[i]);
  }
  await tester.pump();
}

void main() {
  testWidgets('shows locale placeholders in month/day/year order', (
    WidgetTester tester,
  ) async {
    await _pump(tester, DateInput(onChanged: (_) {}));
    expect(find.text('MM'), findsOneWidget);
    expect(find.text('DD'), findsOneWidget);
    expect(find.text('YYYY'), findsOneWidget);
    expect(find.byType(EditableText), findsNWidgets(3));
  });

  testWidgets('dark mode renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(colors: _dark),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: SizedBox(width: 360, child: DateInput(onChanged: (_) {})),
          ),
        ),
      ),
    );
    expect(find.text('MM'), findsOneWidget);
  });

  testWidgets('typing a full valid date reports it', (
    WidgetTester tester,
  ) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pump(tester, _DateHarness(onChanged: seen.add));
    await _typeSegments(tester, <String>['10', '08', '2026']);
    expect(seen.last, DateTime(2026, 10, 8));
  });

  testWidgets('month 13 reports null', (WidgetTester tester) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pump(tester, _DateHarness(onChanged: seen.add));
    await _typeSegments(tester, <String>['13', '08', '2026']);
    expect(seen, isNotEmpty);
    expect(seen.last, isNull);
  });

  testWidgets('February 30 reports null', (WidgetTester tester) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pump(tester, _DateHarness(onChanged: seen.add));
    await _typeSegments(tester, <String>['02', '30', '2026']);
    expect(seen, isNotEmpty);
    expect(seen.last, isNull);
  });

  testWidgets('controlled value shows its segment texts', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      DateInput(value: DateTime(2024, 2, 29), onChanged: (_) {}),
    );
    EditableText segment(int i) =>
        tester.widget<EditableText>(find.byType(EditableText).at(i));
    expect(segment(0).controller.text, '2');
    expect(segment(1).controller.text, '29');
    expect(segment(2).controller.text, '2024');
  });

  testWidgets('explicit part order is honored', (WidgetTester tester) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pump(
      tester,
      _DateHarness(
        datePartsOrder: const <DatePart>[
          DatePart.day,
          DatePart.month,
          DatePart.year,
        ],
        onChanged: seen.add,
      ),
    );
    await _typeSegments(tester, <String>['08', '10', '2026']);
    expect(seen.last, DateTime(2026, 10, 8));
  });

  testWidgets('uncontrolled typing survives parent rebuilds with focus', (
    WidgetTester tester,
  ) async {
    // A full pumpWidget would swap the Overlay entries (init-only) and
    // remount the field, so the parent rebuild goes through an in-place
    // setState instead.
    String title = 'a';
    late StateSetter bump;
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (BuildContext context) => Center(
                  child: SizedBox(
                    width: 360,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        bump = setState;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(title),
                            DateInput(initialValue: DateTime(2025, 1, 5)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.byType(EditableText).first);
    await tester.pump();
    // Partial entry: a full segment would auto-advance focus by design.
    await tester.enterText(find.byType(EditableText).first, '1');
    bump(() => title = 'b');
    await tester.pump();
    final EditableText first = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    expect(first.focusNode.hasFocus, isTrue);
    expect(first.controller.text, '1');
  });

  testWidgets('time field parses and clamps ranges', (
    WidgetTester tester,
  ) async {
    TimeOfDay? value;
    final List<TimeOfDay?> seen = <TimeOfDay?>[];
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => TimeInput(
          value: value,
          onChanged: (TimeOfDay? next) {
            seen.add(next);
            setState(() => value = next);
          },
        ),
      ),
    );
    expect(find.byType(EditableText), findsNWidgets(2));
    await _typeSegments(tester, <String>['23', '59']);
    expect(seen.last, const TimeOfDay(hour: 23, minute: 59));
    await _typeSegments(tester, <String>['24', '00']);
    expect(seen.last, isNull);
  });

  testWidgets('time with seconds shows three segments', (
    WidgetTester tester,
  ) async {
    await _pump(tester, TimeInput(showSeconds: true, onChanged: (_) {}));
    expect(find.byType(EditableText), findsNWidgets(3));
  });

  testWidgets('duration field reports hours and minutes', (
    WidgetTester tester,
  ) async {
    Duration? value;
    final List<Duration?> seen = <Duration?>[];
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => DurationInput(
          value: value,
          onChanged: (Duration? next) {
            seen.add(next);
            setState(() => value = next);
          },
        ),
      ),
    );
    await _typeSegments(tester, <String>['1', '30']);
    expect(seen.last, const Duration(hours: 1, minutes: 30));
  });

  testWidgets('disabled field dims and blocks the calendar', (
    WidgetTester tester,
  ) async {
    await _pumpNav(tester, DateInput(enabled: false, onChanged: (_) {}));
    final List<double> opacities = tester
        .widgetList<Opacity>(find.byType(Opacity))
        .map((Opacity o) => o.opacity)
        .toList();
    expect(opacities, contains(0.5));
    await tester.tap(find.byIcon(LucideIcons.calendarDays));
    await tester.pump();
    expect(find.byType(DatePickerDialog), findsNothing);
  });

  testWidgets('validator message shows below the field', (
    WidgetTester tester,
  ) async {
    await _pump(tester, _DateHarness(validator: (_) => 'bad date'));
    await _typeSegments(tester, <String>['10', '08', '2026']);
    expect(find.text('bad date'), findsOneWidget);
  });

  testWidgets('calendar button picks a date from the dialog', (
    WidgetTester tester,
  ) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pumpNav(
      tester,
      StatefulBuilder(
        builder: (context, setState) => DateInput(
          value: null,
          mode: PromptMode.dialog,
          onChanged: (DateTime? next) {
            seen.add(next);
            setState(() {});
          },
        ),
      ),
    );
    await tester.tap(find.byIcon(LucideIcons.calendarDays));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('15').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(DatePickerDialog), findsNothing);
    expect(seen, isNotEmpty);
    final DateTime now = DateTime.now();
    expect(seen.last, DateTime(now.year, now.month, 15));
  });

  testWidgets('calendar button reports live from the popover', (
    WidgetTester tester,
  ) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pumpPrompt(
      tester,
      StatefulBuilder(
        builder: (context, setState) => DateInput(
          value: null,
          mode: PromptMode.popover,
          onChanged: (DateTime? next) {
            seen.add(next);
            setState(() {});
          },
        ),
      ),
    );
    await tester.tap(find.byIcon(LucideIcons.calendarDays));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('15').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(seen, isNotEmpty);
    final DateTime now = DateTime.now();
    expect(seen.last, DateTime(now.year, now.month, 15));
    // Popover reports live: it stays open for the next pick.
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(DatePickerDialog), findsNothing);
  });

  testWidgets('null mode resolves popover on desktop widths', (
    WidgetTester tester,
  ) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pumpPrompt(
      tester,
      StatefulBuilder(
        builder: (context, setState) => DateInput(
          value: null,
          onChanged: (DateTime? next) {
            seen.add(next);
            setState(() {});
          },
        ),
      ),
      size: const Size(1200, 800),
    );
    await tester.tap(find.byIcon(LucideIcons.calendarDays));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('15').first);
    await tester.pump();
    expect(seen, isNotEmpty);
    // Still open: this behaved like the popover presentation.
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('null mode resolves dialog on narrow widths', (
    WidgetTester tester,
  ) async {
    final List<DateTime?> seen = <DateTime?>[];
    await _pumpPrompt(
      tester,
      StatefulBuilder(
        builder: (context, setState) => DateInput(
          value: null,
          onChanged: (DateTime? next) {
            seen.add(next);
            setState(() {});
          },
        ),
      ),
      size: const Size(400, 800),
    );
    await tester.tap(find.byIcon(LucideIcons.calendarDays));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('15').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(seen, isNotEmpty);
    // Closed: this behaved like the dialog presentation.
    expect(find.byType(DatePickerDialog), findsNothing);
  });

  testWidgets('widget-leg theme height wins and fields are h-9', (
    WidgetTester tester,
  ) async {
    // One pump per frame: Overlay entries are init-only, so a second
    // pumpWidget would keep showing the first frame.
    await _pump(tester, DateInput(onChanged: (_) {}));
    expect(tester.getSize(find.byType(FormattedInput)).height, 36);
  });

  testWidgets('widget-leg theme height overrides the default', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      DateInput(
        onChanged: (_) {},
        theme: const FormattedInputTheme(height: 60),
      ),
    );
    expect(tester.getSize(find.byType(FormattedInput)).height, 60);
  });
}
