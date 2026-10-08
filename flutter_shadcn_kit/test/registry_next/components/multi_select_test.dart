// Widget tests for the `multi_select` component: chips in the trigger,
// checkbox rows that toggle without closing the popup, chip removal,
// canUnselect, keyboard toggling, theme pass-through and real sizes
// (trigger 36, row 32).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry_next/components/multi_select/multi_select.dart';
import 'package:flutter_shadcn_kit/registry_next/components/select/select.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TapRegionSurface(
          child: Overlay(
            initialEntries: <OverlayEntry>[
              OverlayEntry(
                builder: (context) =>
                    Align(alignment: Alignment.topLeft, child: child),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

MultiSelect<String> _multi({
  Iterable<String>? value,
  ValueChanged<Iterable<String>?>? onChanged,
  bool canUnselect = true,
  bool autoClose = false,
}) {
  return MultiSelect<String>(
    value: value,
    onChanged: onChanged,
    canUnselect: canUnselect,
    autoClose: autoClose,
    placeholder: const Text('Pick fruits'),
    itemBuilder: (context, value) =>
        MultiSelectChip<String>(value: value, child: Text(value)),
    items: <Widget>[
      for (final String fruit in const <String>['Apple', 'Banana', 'Cherry'])
        MultiSelectItem<String>(value: fruit, child: Text(fruit)),
    ],
  );
}

Widget _host({
  required Iterable<String>? value,
  required ValueChanged<Iterable<String>?> onChanged,
  bool canUnselect = true,
}) {
  return SizedBox(
    width: 260,
    child: StatefulBuilder(
      builder: (context, setState) => _multi(
        value: value,
        onChanged: (next) => setState(() => onChanged(next)),
        canUnselect: canUnselect,
      ),
    ),
  );
}

Future<void> _open(WidgetTester tester, Finder trigger) async {
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('the trigger shows removable chips for the selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(_host(value: <String>['Apple', 'Banana'], onChanged: (_) {})),
    );
    await tester.pump();
    expect(find.text('Apple'), findsWidgets);
    expect(find.text('Banana'), findsWidgets);
    expect(find.byIcon(LucideIcons.x), findsNWidgets(2));
    expect(find.text('Pick fruits'), findsNothing);
  });

  testWidgets('toggling rows adds values and keeps the popup open', (
    tester,
  ) async {
    List<String>? value = <String>[];
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 260,
          child: StatefulBuilder(
            builder: (context, setState) => _multi(
              value: value,
              onChanged: (next) =>
                  setState(() => value = next?.toList() ?? <String>[]),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick fruits'));
    expect(find.byType(MenuPopup), findsOneWidget);
    await tester.tap(find.text('Banana'));
    await tester.pump();
    expect(value, <String>['Banana']);
    expect(find.byType(MenuPopup), findsOneWidget);
    await tester.tap(find.text('Cherry'));
    await tester.pump();
    expect(value, <String>['Banana', 'Cherry']);
    expect(find.byType(MenuPopup), findsOneWidget);
    // The toggled rows show the checkbox indicator.
    expect(find.byIcon(LucideIcons.check), findsNWidgets(2));
  });

  testWidgets('tapping a selected row removes it (canUnselect)', (
    tester,
  ) async {
    List<String>? value = <String>['Apple'];
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 260,
          child: StatefulBuilder(
            builder: (context, setState) => _multi(
              value: value,
              onChanged: (next) =>
                  setState(() => value = next?.toList() ?? <String>[]),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Apple'));
    // The popup shows the checked row for Apple; tapping it removes the value.
    await tester.tap(find.text('Apple').last);
    await tester.pump();
    expect(value, isEmpty);
    expect(find.byType(MenuPopup), findsOneWidget);
  });

  testWidgets('a chip remove control clears its value', (tester) async {
    List<String>? value = <String>['Apple', 'Banana'];
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 260,
          child: StatefulBuilder(
            builder: (context, setState) => _multi(
              value: value,
              onChanged: (next) =>
                  setState(() => value = next?.toList() ?? <String>[]),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byIcon(LucideIcons.x).first);
    await tester.pump();
    expect(value, <String>['Banana']);
  });

  testWidgets('autoClose: true closes the popup after a toggle', (
    tester,
  ) async {
    List<String>? value = <String>[];
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 260,
          child: StatefulBuilder(
            builder: (context, setState) => _multi(
              value: value,
              autoClose: true,
              onChanged: (next) =>
                  setState(() => value = next?.toList() ?? <String>[]),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick fruits'));
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(value, <String>['Banana']);
    expect(find.byType(MenuPopup), findsNothing);
  });

  testWidgets('canUnselect: false keeps a picked row selected', (tester) async {
    List<String>? value = <String>['Apple'];
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 260,
          child: StatefulBuilder(
            builder: (context, setState) => _multi(
              value: value,
              canUnselect: false,
              onChanged: (next) =>
                  setState(() => value = next?.toList() ?? <String>[]),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Apple'));
    await tester.tap(find.text('Apple').last);
    await tester.pump();
    expect(value, <String>['Apple']);
  });

  testWidgets('the arrow keys toggle the focused row', (tester) async {
    List<String>? value = <String>[];
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 260,
          child: StatefulBuilder(
            builder: (context, setState) => _multi(
              value: value,
              onChanged: (next) =>
                  setState(() => value = next?.toList() ?? <String>[]),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick fruits'));
    final Focus scope = tester.widget<Focus>(
      find
          .descendant(of: find.byType(MenuGroup), matching: find.byType(Focus))
          .first,
    );
    scope.focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(value, <String>['Banana']);
    expect(find.byType(MenuPopup), findsOneWidget);
  });

  testWidgets('trigger is 36 high and checkbox rows are 32', (tester) async {
    await tester.pumpWidget(
      _frame(_host(value: <String>[], onChanged: (_) {})),
    );
    await tester.pump();
    expect(tester.getSize(find.byType(Clickable).first).height, 36);
    await _open(tester, find.text('Pick fruits'));
    expect(tester.getSize(find.byType(RovingRow).first).height, 32);
  });

  testWidgets('SelectTheme.itemPadding reaches the checkbox rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        _host(value: <String>[], onChanged: (_) {}),
        app: const <ComponentThemeData>[
          SelectTheme(itemPadding: EdgeInsets.symmetric(horizontal: 20)),
        ],
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick fruits'));
    final MenuCheckboxItem row = tester.widget<MenuCheckboxItem>(
      find.byType(MenuCheckboxItem).first,
    );
    expect(row.theme!.itemPadding, const EdgeInsets.symmetric(horizontal: 20));
  });
}
