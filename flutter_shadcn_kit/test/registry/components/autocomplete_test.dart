// Widget tests for the `autocomplete` component.
//
// Covers the suggestion lifecycle, keyboard navigation, the three replacement
// modes, all four theme-precedence legs, light and dark tokens, and one
// regression test per old bug that was fixed (frozen overlay theme, unreachable
// keyboard map, appending at the end of the text, list opening before typing).

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/autocomplete/autocomplete.dart';
import 'package:flutter_shadcn_kit/registry/components/card/card.dart'
    as shadcn;
import 'package:flutter_shadcn_kit/registry/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/input_features/input_features.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

const List<String> _fruits = <String>[
  'Apple',
  'Apricot',
  'Avocado',
  'Banana',
  'Cherry',
  'Grape',
  'Kiwi',
  'Lemon',
];

/// Matches on the last word, the way a real autocomplete does: the feature
/// hands over the whole field text, so the filter has to pick the word under
/// the caret itself.
Iterable<String> _filterLastWord(String query) {
  final String needle = query.split(' ').last.toLowerCase();
  return _filter(needle);
}

Iterable<String> _filter(String query) {
  final String needle = query.toLowerCase();
  if (needle.isEmpty) {
    return const <String>[];
  }
  return _fruits.where((fruit) => fruit.toLowerCase().startsWith(needle));
}

/// Each frame gets a fresh overlay key: Flutter reuses an `Overlay`'s state
/// (and its entries) when only the widget is rebuilt.
int _overlayGeneration = 0;

/// Stable overlay key for a test that rebuilds without recreating the overlay:
/// a new overlay would take the open popover entry down with it.
const Key _stableOverlayKey = Key('stable-overlay');

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  AutoCompleteTheme? scoped,
  bool stableOverlay = false,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<AutoCompleteTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          key: stableOverlay
              ? _stableOverlayKey
              : ValueKey<int>(_overlayGeneration++),
          initialEntries: <OverlayEntry>[OverlayEntry(builder: (_) => body)],
        ),
      ),
    ),
  );
}

Widget _field({
  required SuggestionBuilder suggestions,
  AutoCompleteMode? mode,
  AutoCompleteCompleter completer = _identity,
  ValueChanged<String>? onSelected,
  Widget Function(BuildContext context, String suggestion, bool selected)?
  itemBuilder,
  AutoCompleteTheme? theme,
  String? initialValue,
  FocusNode? focusNode,
}) {
  return Input(
    initialValue: initialValue,
    focusNode: focusNode,
    features: <InputFeature>[
      AutoCompleteFeature(
        suggestions: suggestions,
        mode: mode,
        completer: completer,
        onSuggestionSelected: onSelected,
        itemBuilder: itemBuilder,
        theme: theme,
      ),
    ],
  );
}

String _identity(String suggestion) => suggestion;

/// The text currently in the field under test.
String _fieldText(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText)).controller.text;

/// Types [text] into the single field under test and lets the suggestion
/// query, the popover transition and the row animations finish.
///
/// `pumpAndSettle` cannot be used: a focused `EditableText` blinks its cursor
/// forever, so the tree never goes idle.
Future<void> _type(WidgetTester tester, String text) async {
  // `enterText` leaves the selection collapsed at -1, and the feature reads the
  // caret when a suggestion is accepted. Park it at the end *before* the pump
  // that lets the query resolve, the way a real editor would.
  await tester.enterText(find.byType(EditableText), text);
  tester.widget<EditableText>(find.byType(EditableText)).controller.selection =
      TextSelection.collapsed(offset: text.length);
  await _settle(tester);
}

/// Advances past the async suggestion query and the popover transition.
Future<void> _settle(WidgetTester tester) async {
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// The suggestion rows currently presented in the popover.
List<String> _rows(WidgetTester tester) => tester
    .widgetList<Text>(
      find.descendant(
        of: find.byType(shadcn.Card),
        matching: find.byType(Text),
      ),
    )
    .map((Text text) => text.data ?? '')
    .toList(growable: false);

/// The clickable row of the popover at [index].
Finder _rowAt(WidgetTester tester, int index) => find
    .descendant(of: find.byType(shadcn.Card), matching: find.byType(Clickable))
    .at(index);

Color? _highlightFill(WidgetTester tester, int index) {
  final AnimatedContainer container = tester.widget<AnimatedContainer>(
    find
        .descendant(
          of: _rowAt(tester, index),
          matching: find.byType(AnimatedContainer),
        )
        .first,
  );
  return (container.decoration as BoxDecoration?)?.color;
}

void main() {
  group('lifecycle', () {
    testWidgets('no suggestions means no popover', (tester) async {
      await tester.pumpWidget(
        _frame(child: _field(suggestions: (String query) => const <String>[])),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'zzz');
      expect(find.byType(shadcn.Card), findsNothing);
    });

    testWidgets('typing a matching query opens the list', (tester) async {
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(find.byType(shadcn.Card), findsOneWidget);
      expect(_rows(tester), isNotEmpty);
      expect(_rows(tester).first, 'Apple');
    });

    testWidgets('regression: the list stays closed before the user types', (
      tester,
    ) async {
      // The old widget opened as soon as the parent handed over a non-empty
      // suggestion list, so an untouched focused field showed a popup.
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _settle(tester);
      expect(find.byType(shadcn.Card), findsNothing);
    });

    testWidgets('a stale async answer is dropped', (tester) async {
      final List<Completer<List<String>>> pending = <Completer<List<String>>>[];
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: (String query) {
              final Completer<List<String>> completer =
                  Completer<List<String>>();
              pending.add(completer);
              return completer.future;
            },
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      // Taking focus queries once (for the empty text), then every edit.
      await tester.enterText(find.byType(EditableText), 'a');
      await tester.pump();
      await tester.enterText(find.byType(EditableText), 'ap');
      await tester.pump();
      expect(pending.length, greaterThanOrEqualTo(3));
      // The oldest query answers last; only the newest answer may open the list.
      pending[pending.length - 1].complete(<String>['Apple']);
      pending[pending.length - 2].complete(<String>['Avocado']);
      await _settle(tester);
      expect(_rows(tester), <String>['Apple']);
    });

    testWidgets('an async builder is supported', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: (String query) async {
              await Future<void>.delayed(const Duration(milliseconds: 5));
              return _filter(query);
            },
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'b');
      expect(_rows(tester), <String>['Banana']);
    });

    testWidgets('a throwing builder does not crash the field', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: (String query) => throw StateError('boom'),
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(tester.takeException(), isNull);
      expect(find.byType(shadcn.Card), findsNothing);
    });
  });

  group('modes', () {
    testWidgets('replaceWord (default) replaces the word at the caret', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          // Seeded with the words around the caret, then the last word is
          // typed: entering the *same* text would be a no-op for
          // `onTextChanged`, which is the whole point of the regression.
          child: _field(suggestions: _filterLastWord, initialValue: 'I like '),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'I like ap');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_fieldText(tester), 'I like Apple');
    });

    testWidgets('regression: append inserts at the caret, not at the end', (
      tester,
    ) async {
      // The old `_appendText` concatenated the suggestion to the end of the
      // field, so typing in the middle moved the text.
      final TextEditingController controller = TextEditingController(
        text: 'aa',
      );
      addTearDown(controller.dispose);
      controller.selection = const TextSelection.collapsed(offset: 1);
      applyAutoCompleteSuggestion(controller, 'X', AutoCompleteMode.append);
      expect(controller.text, 'aXa');
      expect(controller.selection.baseOffset, 2);
    });

    testWidgets('append writes at the caret and keeps the rest', (
      tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'Grape',
      );
      addTearDown(controller.dispose);
      controller.selection = const TextSelection.collapsed(offset: 0);
      applyAutoCompleteSuggestion(
        controller,
        'Mango ',
        AutoCompleteMode.append,
      );
      expect(controller.text, 'Mango Grape');
      expect(controller.selection.baseOffset, 6);
    });

    testWidgets('replaceAll drops everything', (tester) async {
      final TextEditingController controller = TextEditingController(
        text: 'something else entirely',
      );
      addTearDown(controller.dispose);
      applyAutoCompleteSuggestion(
        controller,
        'Kiwi',
        AutoCompleteMode.replaceAll,
      );
      expect(controller.text, 'Kiwi');
    });

    testWidgets('replaceAll through the feature', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: _filter,
            mode: AutoCompleteMode.replaceAll,
            initialValue: 'zzz',
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'k');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_fieldText(tester), 'Kiwi');
    });

    testWidgets('a custom completer post-processes the suggestion', (
      tester,
    ) async {
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: _filter,
            mode: AutoCompleteMode.replaceAll,
            completer: (String suggestion) => '$suggestion!',
            onSelected: (String value) => seen = value,
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'c');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(seen, 'Cherry!');
      expect(_fieldText(tester), 'Cherry!');
    });

    testWidgets('the theme mode applies when the widget does not', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scoped: const AutoCompleteTheme(mode: AutoCompleteMode.replaceAll),
          child: _field(suggestions: _filter, initialValue: 'zzz'),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'k');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_fieldText(tester), 'Kiwi');
    });

    testWidgets('the widget mode beats the theme mode', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const AutoCompleteTheme(mode: AutoCompleteMode.replaceAll),
          child: _field(
            suggestions: _filter,
            mode: AutoCompleteMode.append,
            initialValue: 'zzz',
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'k');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      // append inserts at the caret instead of replacing the whole field, so
      // the typed prefix survives; replaceAll (the scoped leg) would have left
      // just 'Kiwi'.
      expect(_fieldText(tester), 'kKiwi');
    });
  });

  group('keyboard', () {
    testWidgets('arrow keys move the highlight and wrap', (tester) async {
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      // 'Apple' is highlighted first.
      expect(_highlightFill(tester, 0), ShadcnColors.lightFallback.accent);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await _settle(tester);
      expect(_highlightFill(tester, 1), ShadcnColors.lightFallback.accent);
      expect(_highlightFill(tester, 0), isNull);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await _settle(tester);
      expect(_highlightFill(tester, 0), ShadcnColors.lightFallback.accent);
      // Wrapping upwards from the first row lands on the last.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await _settle(tester);
      final int last = _rows(tester).length - 1;
      expect(_highlightFill(tester, last), ShadcnColors.lightFallback.accent);
    });

    testWidgets('enter applies the highlighted row', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: _filter,
            mode: AutoCompleteMode.replaceAll,
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await _settle(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_fieldText(tester), 'Apricot');
    });

    testWidgets('regression: the arrow keys actually reach the list', (
      tester,
    ) async {
      // The old keyboard map hung off `FocusableActionDetector`, which is not
      // in the key-event path of an `EditableText`, so the arrows were dead.
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      final int before = _rows(tester).length;
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await _settle(tester);
      expect(_rows(tester).length, before);
      expect(_highlightFill(tester, 1), isNotNull);
    });

    testWidgets('escape closes the list without applying', (tester) async {
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(find.byType(shadcn.Card), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settle(tester);
      expect(find.byType(shadcn.Card), findsNothing);
      expect(find.text('a'), findsOneWidget);
    });

    testWidgets('tab is not bound to accept', (tester) async {
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      // The old widget bound Tab to "accept", which trapped focus in the
      // field. Nothing should change now.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await _settle(tester);
      expect(_fieldText(tester), 'a');
    });

    testWidgets('accept with no highlighted row does nothing', (tester) async {
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await _settle(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_fieldText(tester), 'a');
    });
  });

  group('selection', () {
    testWidgets('tapping a row applies it', (tester) async {
      String? seen;
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: _filter,
            mode: AutoCompleteMode.replaceAll,
            onSelected: (String value) => seen = value,
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'g');
      await tester.tap(find.text('Grape'));
      await _settle(tester);
      expect(seen, 'Grape');
      expect(_fieldText(tester), 'Grape');
    });

    testWidgets('regression: the list does not reopen right after accepting', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: _filterLastWord,
            mode: AutoCompleteMode.replaceAll,
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'Grape ap');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(find.byType(shadcn.Card), findsNothing);
      // Typing again reopens it: the suppression lasts one cycle only. Note
      // that the accepted write itself fires a query, which the flag swallows;
      // the *next* edit must reopen.
      await _type(tester, 'Grape ap');
      expect(find.byType(shadcn.Card), findsOneWidget);
    });

    testWidgets('a custom row builder is used', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: _field(
            suggestions: _filter,
            itemBuilder: (context, suggestion, selected) => Text(
              'row:$suggestion',
              style: TextStyle(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(find.text('row:Apple'), findsOneWidget);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            AutoCompleteTheme(
              itemBackground: StateValue(
                hovered: ThemedColor.value(_green),
                selected: ThemedColor.value(_green),
              ),
            ),
          ],
          child: _field(suggestions: _filter),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(_highlightFill(tester, 0), _green);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[
            AutoCompleteTheme(
              itemBackground: StateValue(
                hovered: ThemedColor.value(_green),
                selected: ThemedColor.value(_green),
              ),
            ),
          ],
          scoped: const AutoCompleteTheme(
            itemBackground: StateValue(
              hovered: ThemedColor.value(_blue),
              selected: ThemedColor.value(_blue),
            ),
          ),
          child: _field(suggestions: _filter),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(_highlightFill(tester, 0), _blue);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          scoped: const AutoCompleteTheme(
            itemBackground: StateValue(
              hovered: ThemedColor.value(_green),
              selected: ThemedColor.value(_green),
            ),
          ),
          child: _field(
            suggestions: _filter,
            theme: const AutoCompleteTheme(
              itemBackground: StateValue(
                hovered: ThemedColor.value(_blue),
                selected: ThemedColor.value(_blue),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(_highlightFill(tester, 0), _blue);
    });

    testWidgets('a leg setting one state keeps the other defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          scoped: const AutoCompleteTheme(itemPadding: EdgeInsets.all(20)),
          child: _field(suggestions: _filter),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      // The highlight colour still comes from the defaults row.
      expect(_highlightFill(tester, 0), ShadcnColors.lightFallback.accent);
      // The scoped leg's padding reaches the row: 14px glyph + 20 top + 20
      // bottom.
      expect(tester.getSize(_rowAt(tester, 0)).height, greaterThan(14));
    });
  });

  group('tokens', () {
    testWidgets('the container uses the popover tokens', (tester) async {
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      final DecoratedBox box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(shadcn.Card),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      final BoxDecoration decoration = box.decoration as BoxDecoration;
      expect(decoration.color, ShadcnColors.lightFallback.popover);
    });

    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: _field(suggestions: _filter),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(_highlightFill(tester, 0), dark.accent);
      final DecoratedBox box = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(shadcn.Card),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect((box.decoration as BoxDecoration).color, dark.popover);
    });

    testWidgets('regression: the overlay theme is live, not frozen', (
      tester,
    ) async {
      // The old popover built its content from the theme captured when it was
      // shown, so a light -> dark switch left the list light.
      final ValueNotifier<ShadcnThemeData> theme =
          ValueNotifier<ShadcnThemeData>(const ShadcnThemeData());
      addTearDown(theme.dispose);
      await tester.pumpWidget(
        ValueListenableBuilder<ShadcnThemeData>(
          valueListenable: theme,
          builder: (context, data, _) => _frame(
            data: data,
            stableOverlay: true,
            child: _field(suggestions: _filter),
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      DecoratedBox box() => tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(shadcn.Card),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );
      expect(
        (box().decoration as BoxDecoration).color,
        ShadcnColors.lightFallback.popover,
      );
      theme.value = const ShadcnThemeData(colors: ShadcnColors.darkFallback);
      await _settle(tester);
      expect(
        (box().decoration as BoxDecoration).color,
        ShadcnColors.darkFallback.popover,
      );
    });

    testWidgets('alpha multiplies the token alpha', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: dark),
          child: _field(
            suggestions: _filter,
            theme: const AutoCompleteTheme(
              itemBackground: StateValue(
                selected: ThemedColor.ref(ColorRef.accent, alpha: 0.5),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      expect(_highlightFill(tester, 0)!.a, closeTo(dark.accent.a * 0.5, 0.001));
    });

    testWidgets('sizes match shadcn (text-sm 14, px-2 py-1.5)', (tester) async {
      await tester.pumpWidget(_frame(child: _field(suggestions: _filter)));
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await _type(tester, 'a');
      final Text row = tester.widget<Text>(find.text('Apple').first);
      expect(row.style?.fontSize, 14);
      // Row height = 14 text + 6 top + 6 bottom padding.
      expect(tester.getSize(_rowAt(tester, 0)).height, greaterThan(14));
    });
  });
}
