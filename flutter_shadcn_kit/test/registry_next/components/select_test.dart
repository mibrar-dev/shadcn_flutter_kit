// Widget tests for the `select` component: trigger value/placeholder, the
// popup rows and search, controlled value flow, keyboard traversal, all
// four SelectTheme legs, disabled state, light/dark tokens and real sizes
// (trigger 36, popup 220 wide, row 32).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry_next/components/menu/menu.dart';
import 'package:flutter_shadcn_kit/registry_next/components/select/select.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  SelectTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<SelectTheme>(data: scoped, child: body);
  }
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
                    Align(alignment: Alignment.topLeft, child: body),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Select<String> _select({
  String? value,
  ValueChanged<String?>? onChanged,
  bool? enabled,
  bool canUnselect = false,
  bool autoClose = true,
  BoxConstraints? popupConstraints,
  SelectValueSelectionHandler<String>? valueSelectionHandler,
  SelectValueSelectionPredicate<String>? valueSelectionPredicate,
  SelectItemsBuilder? builder,
  Widget? searchPlaceholder,
  SelectTheme? theme,
  List<Widget>? items,
}) {
  return Select<String>(
    value: value,
    onChanged: onChanged,
    enabled: enabled,
    canUnselect: canUnselect,
    autoClose: autoClose,
    popupConstraints: popupConstraints,
    valueSelectionHandler: valueSelectionHandler,
    valueSelectionPredicate: valueSelectionPredicate,
    theme: theme,
    placeholder: const Text('Pick a fruit'),
    itemBuilder: (context, value) => Text(value),
    searchPlaceholder: searchPlaceholder,
    builder: builder,
    items:
        items ??
        <Widget>[
          SelectItem<String>(value: 'Apple', child: const Text('Apple')),
          SelectItem<String>(value: 'Banana', child: const Text('Banana')),
          SelectItem<String>(value: 'Cherry', child: const Text('Cherry')),
        ],
  );
}

Widget _sized(Widget child) => SizedBox(width: 220, child: child);

Future<void> _open(WidgetTester tester, Finder trigger) async {
  await tester.tap(trigger);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

AnimatedContainer _triggerContainer(WidgetTester tester) {
  return tester.widget<AnimatedContainer>(
    find
        .descendant(
          of: find.byType(Clickable),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
}

Color _triggerColor(WidgetTester tester) =>
    (_triggerContainer(tester).decoration! as BoxDecoration).color!;

void main() {
  testWidgets('trigger shows the placeholder, icon and 36x220 size', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(_sized(_select(onChanged: (_) {}))));
    await tester.pump();
    expect(find.text('Pick a fruit'), findsOneWidget);
    expect(tester.getSize(find.byType(Clickable)).height, 36);
    expect(tester.getSize(find.byType(Clickable)).width, 220);
  });

  testWidgets('a null onChanged disables and dims the trigger', (tester) async {
    await tester.pumpWidget(_frame(_sized(_select())));
    await tester.pump();
    final Opacity opacity = tester.widget<Opacity>(
      find.ancestor(
        of: find.text('Pick a fruit'),
        matching: find.byType(Opacity),
      ),
    );
    expect(opacity.opacity, 0.5);
    await _open(tester, find.text('Pick a fruit'));
    expect(find.byType(MenuPopup), findsNothing);
  });

  testWidgets('enabled: false disables even with an onChanged', (tester) async {
    await tester.pumpWidget(
      _frame(_sized(_select(enabled: false, onChanged: (_) {}))),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    expect(find.byType(MenuPopup), findsNothing);
  });

  testWidgets('picking a row commits the controlled value', (tester) async {
    String? value;
    await tester.pumpWidget(
      _frame(
        _sized(
          StatefulBuilder(
            builder: (context, setState) => _select(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    expect(find.byType(MenuPopup), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(value, 'Banana');
    expect(find.text('Pick a fruit'), findsNothing);
    expect(find.text('Banana'), findsOneWidget);
    // The selected row reserves the check gutter and shows the check.
    await _open(tester, find.text('Banana'));
    expect(find.byIcon(LucideIcons.check), findsOneWidget);
  });

  testWidgets('the popup is trigger-wide and scrolls under 240px', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        _sized(
          _select(
            onChanged: (_) {},
            items: <Widget>[
              for (var i = 0; i < 20; i++)
                SelectItem<String>(value: 'Item $i', child: Text('Item $i')),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    final Size popup = tester.getSize(find.byType(MenuPopup));
    expect(popup.width, 220);
    expect(popup.height, lessThanOrEqualTo(240));
    expect(tester.getSize(find.byType(MenuGroup)).height, greaterThan(240));
  });

  testWidgets('rows are 32 high (shadcn h-8)', (tester) async {
    await tester.pumpWidget(_frame(_sized(_select(onChanged: (_) {}))));
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    expect(tester.getSize(find.byType(RovingRow).first).height, 32);
  });

  group('search', () {
    SelectItemsBuilder builder(List<String> all, List<String?> queries) {
      return (context, query) {
        queries.add(query);
        final Iterable<String> matches = query == null
            ? all
            : all.where((f) => f.contains(query));
        return <Widget>[
          for (final String fruit in matches)
            SelectItem<String>(value: fruit, child: Text(fruit)),
        ];
      };
    }

    testWidgets('builder enables the search field and filters rows', (
      tester,
    ) async {
      final List<String?> queries = <String?>[];
      await tester.pumpWidget(
        _frame(
          _sized(
            _select(
              onChanged: (_) {},
              searchPlaceholder: const Text('Search fruit'),
              items: null,
              builder: builder(<String>['Apple', 'Banana', 'Cherry'], queries),
            ),
          ),
        ),
      );
      await tester.pump();
      await _open(tester, find.text('Pick a fruit'));
      expect(find.text('Search fruit'), findsOneWidget);
      await tester.enterText(find.byType(EditableText), 'Ban');
      await tester.pump();
      expect(queries.last, 'Ban');
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Apple'), findsNothing);
      await tester.enterText(find.byType(EditableText), 'nothing');
      await tester.pump();
      expect(find.byType(SelectItem<String>), findsNothing);
    });

    testWidgets('without a builder there is no search field', (tester) async {
      await tester.pumpWidget(_frame(_sized(_select(onChanged: (_) {}))));
      await tester.pump();
      await _open(tester, find.text('Pick a fruit'));
      expect(find.byType(Input), findsNothing);
    });
  });

  testWidgets('the arrow keys walk the rows and Enter selects', (tester) async {
    String? value;
    await tester.pumpWidget(
      _frame(
        _sized(
          StatefulBuilder(
            builder: (context, setState) => _select(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    final Focus scope = tester.widget<Focus>(
      find
          .descendant(of: find.byType(MenuGroup), matching: find.byType(Focus))
          .first,
    );
    scope.focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(value, 'Apple');
  });

  testWidgets('canUnselect clears the picked value when allowed', (
    tester,
  ) async {
    String? value = 'Apple';
    await tester.pumpWidget(
      _frame(
        _sized(
          StatefulBuilder(
            builder: (context, setState) => _select(
              value: value,
              canUnselect: true,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Apple'));
    await tester.tap(find.text('Apple').last);
    await tester.pumpAndSettle();
    expect(value, isNull);
    expect(find.text('Pick a fruit'), findsOneWidget);
  });

  testWidgets('canUnselect: false keeps the picked value', (tester) async {
    String? value = 'Apple';
    await tester.pumpWidget(
      _frame(
        _sized(
          StatefulBuilder(
            builder: (context, setState) => _select(
              value: value,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Apple'));
    await tester.tap(find.text('Apple').last);
    await tester.pumpAndSettle();
    expect(value, 'Apple');
  });

  testWidgets('autoClose: false keeps the popup open after picking', (
    tester,
  ) async {
    String? value;
    await tester.pumpWidget(
      _frame(
        _sized(
          StatefulBuilder(
            builder: (context, setState) => _select(
              value: value,
              autoClose: false,
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    await tester.tap(find.text('Banana'));
    await tester.pump();
    expect(value, 'Banana');
    expect(find.byType(MenuPopup), findsOneWidget);
  });

  testWidgets('popupConstraints bound the popup height', (tester) async {
    await tester.pumpWidget(
      _frame(
        _sized(
          _select(
            onChanged: (_) {},
            popupConstraints: const BoxConstraints(maxHeight: 120),
            items: <Widget>[
              for (var i = 0; i < 20; i++)
                SelectItem<String>(value: 'Item $i', child: Text('Item $i')),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    expect(
      tester.getSize(find.byType(MenuPopup)).height,
      lessThanOrEqualTo(120),
    );
  });

  testWidgets('SelectTheme.constraints bound the popup height', (tester) async {
    await tester.pumpWidget(
      _frame(
        _sized(
          _select(
            onChanged: (_) {},
            items: <Widget>[
              for (var i = 0; i < 20; i++)
                SelectItem<String>(value: 'Item $i', child: Text('Item $i')),
            ],
          ),
        ),
        app: const <ComponentThemeData>[
          SelectTheme(constraints: BoxConstraints(maxHeight: 100)),
        ],
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    expect(
      tester.getSize(find.byType(MenuPopup)).height,
      lessThanOrEqualTo(100),
    );
  });

  testWidgets('custom selection hooks map and test the selection', (
    tester,
  ) async {
    String? value;
    await tester.pumpWidget(
      _frame(
        _sized(
          StatefulBuilder(
            builder: (context, setState) => _select(
              value: value,
              valueSelectionHandler: (oldValue, item, selected) =>
                  selected ? '${item}_picked' : oldValue,
              valueSelectionPredicate: (test, item) => test == '${item}_picked',
              onChanged: (next) => setState(() => value = next),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await _open(tester, find.text('Pick a fruit'));
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(value, 'Banana_picked');
    expect(find.text('Banana_picked'), findsOneWidget);
  });

  group('theme legs', () {
    testWidgets('defaults resolve the outline button row', (tester) async {
      await tester.pumpWidget(_frame(_sized(_select(onChanged: (_) {}))));
      await tester.pump();
      const ShadcnColors colors = ShadcnColors.lightFallback;
      expect(
        _triggerColor(tester),
        const ThemedColor.ref(ColorRef.input, alpha: 0.3).resolve(colors),
      );
    });

    testWidgets('dark tokens drive the trigger', (tester) async {
      const ShadcnThemeData theme = ShadcnThemeData(
        colors: ShadcnColors.darkFallback,
      );
      await tester.pumpWidget(
        _frame(_sized(_select(onChanged: (_) {})), data: theme),
      );
      await tester.pump();
      expect(
        _triggerColor(tester),
        const ThemedColor.ref(ColorRef.input, alpha: 0.3).resolve(theme.colors),
      );
    });

    testWidgets('app leg beats the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          _sized(_select(onChanged: (_) {})),
          app: const <ComponentThemeData>[
            SelectTheme(variant: ButtonVariant.secondary),
          ],
        ),
      );
      await tester.pump();
      expect(_triggerColor(tester), const ShadcnThemeData().colors.secondary);
    });

    testWidgets('scoped leg beats the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _sized(_select(onChanged: (_) {})),
          app: const <ComponentThemeData>[
            SelectTheme(variant: ButtonVariant.ghost),
          ],
          scoped: const SelectTheme(variant: ButtonVariant.secondary),
        ),
      );
      await tester.pump();
      expect(_triggerColor(tester), const ShadcnThemeData().colors.secondary);
    });

    testWidgets('widget leg beats every other leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          _sized(
            _select(
              onChanged: (_) {},
              theme: const SelectTheme(variant: ButtonVariant.primary),
            ),
          ),
          app: const <ComponentThemeData>[
            SelectTheme(variant: ButtonVariant.secondary),
          ],
          scoped: const SelectTheme(variant: ButtonVariant.secondary),
        ),
      );
      await tester.pump();
      expect(_triggerColor(tester), const ShadcnThemeData().colors.primary);
    });

    testWidgets('the theme itemPadding moves the row content', (tester) async {
      await tester.pumpWidget(
        _frame(
          _sized(_select(onChanged: (_) {})),
          app: const <ComponentThemeData>[
            SelectTheme(itemPadding: EdgeInsets.symmetric(horizontal: 20)),
          ],
        ),
      );
      await tester.pump();
      await _open(tester, find.text('Pick a fruit'));
      final double popupLeft = tester.getTopLeft(find.byType(MenuPopup)).dx;
      final double textLeft = tester.getTopLeft(find.text('Apple')).dx;
      // Surface p-1 (4) + its 1px border + the themed row padding (20).
      expect(textLeft - popupLeft, 25);
    });

    testWidgets('a trigger theme colour override wins', (tester) async {
      await tester.pumpWidget(
        _frame(
          _sized(
            _select(
              onChanged: (_) {},
              theme: const SelectTheme(
                trigger: ButtonVariantStyle(
                  background: StateValue<ThemedColor>(
                    rest: ThemedColor.value(_green),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(_triggerColor(tester), _green);
    });
  });
}
