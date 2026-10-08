// Widget tests for the `time_picker` component.
//
// Covers both triggers (placeholder/value/disabled), the clock sheet
// (digit clamping, AM/PM, seconds), the duration sheet, dialog and popover
// presentation, all four theme legs, real sizes, plus regressions for the
// Material TimeOfDay and the re-declared _TimeFormatter.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/formatter/formatter.dart';
import 'package:flutter_shadcn_kit/registry_next/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry_next/components/time_picker/time_picker.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/time_of_day.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/object_form_field.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay_manager_layer.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/popover_controller.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TimePickerTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<TimePickerTheme>(data: scoped, child: body);
  }
  return OverlayManagerLayer(
    popoverHandler: OverlayHandler.popover,
    tooltipHandler: OverlayHandler.popover,
    menuHandler: OverlayHandler.popover,
    child: ShadcnTheme(
      data: data,
      child: ComponentThemes(
        themes: app,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Navigator(
              onGenerateRoute: (settings) => PageRouteBuilder<void>(
                settings: settings,
                pageBuilder: (context, _, _) => body,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Opens the picker and settles the prompt transition.
Future<void> _open(WidgetTester tester, Finder trigger) async {
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

/// Re-pumps the page with the committed value, like a real app rebuild.
Future<void> _repump(WidgetTester tester, Widget picker) async {
  await tester.pumpWidget(_frame(picker));
  await tester.pump();
}

void main() {
  group('time trigger', () {
    testWidgets('shows the localized placeholder when null', (tester) async {
      await tester.pumpWidget(
        _frame(TimePicker(value: null, onChanged: (_) {})),
      );
      expect(find.text('Select a time'), findsOneWidget);
    });

    testWidgets('shows the formatted value in 24h mode', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 14, minute: 30),
            onChanged: (_) {},
            use24HourFormat: true,
          ),
        ),
      );
      expect(find.text('14:30'), findsOneWidget);
    });

    testWidgets('shows AM/PM in 12h mode', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 14, minute: 30),
            onChanged: (_) {},
            use24HourFormat: false,
          ),
        ),
      );
      expect(find.text('2:30 PM'), findsOneWidget);
    });

    testWidgets('null onChanged disables the trigger', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: null,
            use24HourFormat: true,
          ),
        ),
      );
      final Opacity opacity = tester.widget<Opacity>(
        find
            .ancestor(of: find.text('09:00'), matching: find.byType(Opacity))
            .first,
      );
      expect(opacity.opacity, 0.5);
    });

    testWidgets('trigger is at least 36 high (shadcn h-9)', (tester) async {
      await tester.pumpWidget(
        _frame(TimePicker(value: null, onChanged: (_) {})),
      );
      final Finder trigger = find.ancestor(
        of: find.text('Select a time'),
        matching: find.byType(ConstrainedBox),
      );
      expect(tester.getSize(trigger).height, greaterThanOrEqualTo(36));
    });

    testWidgets('controlled flow round-trips through Save', (tester) async {
      TimeOfDay? value = const TimeOfDay(hour: 9, minute: 0);
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _frame(
            TimePicker(
              value: value,
              onChanged: (next) => setState(() => value = next),
              use24HourFormat: true,
            ),
          ),
        ),
      );
      await _open(tester, find.text('09:00'));
      await tester.enterText(find.byType(EditableText).first, '10');
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(value, const TimeOfDay(hour: 10, minute: 0));
      await _repump(
        tester,
        TimePicker(value: value, onChanged: (_) {}, use24HourFormat: true),
      );
      expect(find.text('10:00'), findsOneWidget);
    });
  });

  group('clock sheet', () {
    testWidgets('hour clamps to 0-23 on edit', (tester) async {
      TimeOfDay? value = const TimeOfDay(hour: 9, minute: 0);
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _frame(
            TimePicker(
              value: value,
              onChanged: (next) => setState(() => value = next),
              use24HourFormat: true,
            ),
          ),
        ),
      );
      await _open(tester, find.text('09:00'));
      await tester.enterText(find.byType(EditableText).first, '25');
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(value, const TimeOfDay(hour: 23, minute: 0));
    });

    testWidgets('digit fields are 72 wide', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
          ),
        ),
      );
      await _open(tester, find.text('09:00'));
      final Finder fields = find.byType(SizedBox);
      expect(fields.evaluate().isNotEmpty, isTrue);
      final Size size = tester.getSize(
        find
            .ancestor(of: find.text('Hour'), matching: find.byType(SizedBox))
            .first,
      );
      expect(size.width, 72);
    });

    testWidgets('AM/PM buttons flip the half day', (tester) async {
      TimeOfDay? value = const TimeOfDay(hour: 10, minute: 30);
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _frame(
            TimePicker(
              value: value,
              onChanged: (next) => setState(() => value = next),
              use24HourFormat: false,
            ),
          ),
        ),
      );
      expect(find.text('10:30 AM'), findsOneWidget);
      await _open(tester, find.text('10:30 AM'));
      expect(find.text('PM'), findsOneWidget);
      await tester.tap(find.text('PM'));
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(value, const TimeOfDay(hour: 22, minute: 30));
    });

    testWidgets('no seconds field without showSeconds', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
          ),
        ),
      );
      await _open(tester, find.text('09:00'));
      expect(find.text('Second'), findsNothing);
    });

    testWidgets('seconds field appears with showSeconds', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
            showSeconds: true,
          ),
        ),
      );
      await _open(tester, find.text('09:00:00'));
      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('popover mode opens the sheet inline', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
            mode: PromptMode.popover,
          ),
        ),
      );
      await _open(tester, find.text('09:00'));
      // Sheet content renders in the overlay without a dialog route.
      expect(find.text('Hour'), findsOneWidget);
      expect(find.text('Minute'), findsOneWidget);
    });
  });

  group('duration', () {
    testWidgets('duration trigger shows the placeholder when null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(DurationPicker(value: null, onChanged: (_) {})),
      );
      expect(find.text('Select a duration'), findsOneWidget);
    });

    testWidgets('duration trigger shows the formatted value', (tester) async {
      await tester.pumpWidget(
        _frame(
          DurationPicker(
            value: const Duration(hours: 1, minutes: 30),
            onChanged: (_) {},
          ),
        ),
      );
      expect(find.text('1h 30m'), findsOneWidget);
    });

    testWidgets('sheet edits report a clamped duration', (tester) async {
      Duration? value;
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) => _frame(
            DurationPicker(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      );
      await _open(tester, find.text('Select a duration'));
      expect(find.text('Day'), findsOneWidget);
      // Hour is the second digit field: 99 clamps to 23.
      await tester.enterText(find.byType(EditableText).at(1), '99');
      await tester.pump();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(value, const Duration(hours: 23));
    });
  });

  group('theme legs', () {
    testWidgets('widget mode wins over every other leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
            mode: PromptMode.popover,
          ),
          app: const <ComponentThemeData>[
            TimePickerTheme(mode: PromptMode.dialog),
          ],
        ),
      );
      await _open(tester, find.text('09:00'));
      expect(find.text('Hour'), findsOneWidget);
    });

    testWidgets('scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
          ),
          app: const <ComponentThemeData>[
            TimePickerTheme(mode: PromptMode.dialog),
          ],
          scoped: const TimePickerTheme(mode: PromptMode.popover),
        ),
      );
      await _open(tester, find.text('09:00'));
      expect(find.text('Hour'), findsOneWidget);
    });

    testWidgets('app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
          ),
          app: const <ComponentThemeData>[
            TimePickerTheme(mode: PromptMode.popover),
          ],
        ),
      );
      await _open(tester, find.text('09:00'));
      expect(find.text('Hour'), findsOneWidget);
    });

    testWidgets('24h convention resolves from the widget leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 14, minute: 30),
            onChanged: (_) {},
            use24HourFormat: false,
          ),
          app: const <ComponentThemeData>[
            TimePickerTheme(use24HourFormat: true),
          ],
        ),
      );
      expect(find.text('2:30 PM'), findsOneWidget);
    });
  });

  group('regressions', () {
    test('foundation TimeOfDay mirrors the Material surface', () {
      expect(
        const TimeOfDay(hour: 14, minute: 30, second: 45),
        TimeOfDay.fromDateTime(DateTime(2024, 3, 14, 14, 30, 45)),
      );
      expect(
        const TimeOfDay(hour: 22, minute: 0),
        const TimeOfDay.pm(hour: 10, minute: 0),
      );
    });

    testWidgets('popover clock sheet digit tap keeps the overlay alive', (
      tester,
    ) async {
      // The clock sheet holds TimeFormatter digit fields. Tapping one used
      // to kill the overlay: every popover rebuild re-invokes the builder
      // (fresh widgets, by Flutter convention), and a fresh
      // ShadcnSelectionControls per Input build made EditableText dispose
      // and recreate its selection overlay mid-build (zombie OverlayEntry,
      // _TypeError in _OverlayEntryWidgetState.initState).
      await tester.pumpWidget(
        _frame(
          TimePicker(
            value: const TimeOfDay(hour: 9, minute: 0),
            onChanged: (_) {},
            use24HourFormat: true,
            mode: PromptMode.popover,
          ),
        ),
      );
      await _open(tester, find.text('09:00'));
      expect(find.text('Hour'), findsOneWidget);
      await tester.tap(find.byType(EditableText).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Hour'), findsOneWidget);
    });

    testWidgets('two TimeFormatter fields in a popover survive a tap', (
      tester,
    ) async {
      // Minimal shape of the original report: a popover builder creating
      // fresh Input instances per build (the standard pattern) plus a field
      // tap. Single/plain variants crash identically without the
      // ShadcnSelectionControls value-equality fix.
      final controller = PopoverController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                controller.show<void>(
                  context: context,
                  alignment: Alignment.topLeft,
                  anchorAlignment: Alignment.bottomLeft,
                  builder: (context) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Input(
                        inputFormatters: const <TextInputFormatter>[
                          TimeFormatter(length: 2),
                        ],
                      ),
                      Input(
                        inputFormatters: const <TextInputFormatter>[
                          TimeFormatter(length: 2),
                        ],
                      ),
                    ],
                  ),
                );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(Input), findsNWidgets(2));
      await tester.tap(find.byType(Input).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(controller.hasOpenPopover, isTrue);
      expect(find.byType(Input), findsNWidgets(2));
    });
  });
}
