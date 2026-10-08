// Widget tests for the `chip_input` component, plus the unit tests for the
// `primitives/text_editing/token_*` files it is the only reader of.
//
// Covers: typing + Enter creates a chip, backspace on an empty field removes
// the last chip, the remove button (and its localized label), delimited paste,
// suggestion acceptance, keyboard navigation across chips, controlled vs
// uncontrolled value, disabled, read-only, the four theme-precedence legs,
// the shadcn h-9 (36) minimum height, light and dark, and one regression test
// per defect fixed in the port (see `components/chip_input/README.md`).

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/card/card.dart'
    as shadcn;
import 'package:flutter_shadcn_kit/registry_next/components/chip/chip.dart';
import 'package:flutter_shadcn_kit/registry_next/components/chip_input/chip_input.dart';
import 'package:flutter_shadcn_kit/registry_next/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/input_features.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/text_editing/token_editing.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const String _enDeleteLabel = 'Delete';

/// The app's clipboard during one test.
String _clipboard = '';

/// Bumped per frame so repumping rebuilds the `Overlay` (and its entry) rather
/// than reusing the state that captured the previous child.
int _frameId = 0;

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ChipInputTheme? scoped,
  // The theatre behind `Overlay` lays its entries out at a *tight* size, which
  // would stretch the field to the whole test view; the size audit opts out.
  bool overlay = true,
}) {
  Widget entry = child;
  if (scoped != null) {
    entry = ComponentTheme<ChipInputTheme>(data: scoped, child: entry);
  }
  Widget body = entry;
  if (overlay) {
    body = Overlay(
      key: ValueKey<int>(_frameId++),
      initialEntries: <OverlayEntry>[OverlayEntry(builder: (_) => entry)],
    );
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        // `DeleteCharacterIntent` (backspace) and the copy/cut/paste shortcuts
        // only exist under this widget; `EditableText` owns the *actions*.
        child: Center(
          child: SizedBox(
            width: 480,
            child: DefaultTextEditingShortcuts(child: body),
          ),
        ),
      ),
    ),
  );
}

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

TokenEditingController<String> _ctrl(WidgetTester tester) =>
    _editable(tester).controller as TokenEditingController<String>;

List<String> _chips(WidgetTester tester) => _ctrl(tester).tokens;

String _plain(WidgetTester tester) => _ctrl(tester).plainText;

/// Enters [text] and parks the caret at its end, the way a real editor would.
Future<void> _type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(EditableText), text);
  _ctrl(tester).selection = TextSelection.collapsed(offset: text.length);
  await tester.pump();
}

/// Sends a bare key and lets the resulting edit land.
Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pump();
}

/// Sends `control`+[key] (or `meta`+[key] on macOS), matching the modifier the
/// framework's own text-editing shortcuts are bound to on that platform.
Future<void> _modifiedKey(WidgetTester tester, LogicalKeyboardKey key) async {
  final LogicalKeyboardKey modifier =
      defaultTargetPlatform == TargetPlatform.macOS
      ? LogicalKeyboardKey.metaLeft
      : LogicalKeyboardKey.controlLeft;
  await tester.sendKeyDownEvent(modifier);
  await tester.sendKeyEvent(key);
  await tester.sendKeyUpEvent(modifier);
  await tester.pump();
}

/// Focuses the field and parks the caret at the end of its text.
Future<void> _focusAtEnd(WidgetTester tester) async {
  await tester.tap(find.byType(EditableText));
  final TokenEditingController<String> controller = _ctrl(tester);
  controller.selection = TextSelection.collapsed(
    offset: controller.text.length,
  );
  await tester.pump();
}

/// Appends [text] at the caret without disturbing the tokens already in the
/// field: `enterText` replaces the whole value, which is not what typing does.
Future<void> _append(WidgetTester tester, String text) async {
  final TokenEditingController<String> controller = _ctrl(tester);
  final int at = controller.selection.isValid
      ? controller.selection.baseOffset
      : controller.text.length;
  controller.value = TextEditingValue(
    text: controller.text.replaceRange(at, at, text),
    selection: TextSelection.collapsed(offset: at + text.length),
  );
  await tester.pump();
}

/// Routes `Clipboard` through [_clipboard] so copy and paste are observable.
void _mockClipboard(WidgetTester tester) {
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (MethodCall call) async {
      if (call.method == 'Clipboard.setData') {
        _clipboard = (call.arguments as Map)['text'] as String? ?? '';
      }
      if (call.method == 'Clipboard.getData') {
        return <String, dynamic>{'text': _clipboard};
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
}

/// Background of the first chip's own decoration.
Color? _chipBackground(WidgetTester tester) {
  final Finder finder = find.descendant(
    of: find.byType(Chip),
    matching: find.byType(DecoratedBox),
  );
  if (finder.evaluate().isEmpty) {
    return null;
  }
  return (tester.widget<DecoratedBox>(finder.first).decoration as BoxDecoration)
      .color;
}

/// Background of a chip painted by [body], for light/dark parity.
Future<Color?> _backgroundOf(
  WidgetTester tester,
  Widget body, {
  ShadcnThemeData data = const ShadcnThemeData(),
}) async {
  await tester.pumpWidget(_frame(data: data, child: body));
  return _chipBackground(tester);
}

const List<String> _fruits = <String>['apple', 'apricot', 'avocado', 'banana'];

/// The query with token placeholders removed: a field that already holds chips
/// hands the whole text to the suggestion builder.
String _needle(String query) => String.fromCharCodes(
  query.codeUnits.where((int unit) => !isTokenCodeUnit(unit)),
).toLowerCase();

Iterable<String> _filter(String query) =>
    _fruits.where((String fruit) => fruit.startsWith(_needle(query)));

/// Advances past the async suggestion query and the popover transition.
Future<void> _settle(WidgetTester tester) async {
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// A converter that rejects everything: the field keeps the word as text.
String? _reject(String text) => null;

/// A text-to-chip parser that accepts everything (used by the clipboard tests).
String? _parse(String text) => text;

/// A parser that accepts everything except `drop`.
String? _parseNullish(String text) => text == 'drop' ? null : text;

void main() {
  group('word submission', () {
    testWidgets('typing a word and pressing Enter creates a chip', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            onChipSubmit: (String text) => text.toLowerCase(),
          ),
        ),
      );
      await _type(tester, 'Flutter');
      await _key(tester, LogicalKeyboardKey.enter);
      expect(_chips(tester), <String>['flutter']);
      expect(_plain(tester), isEmpty, reason: 'the word was consumed');
    });

    testWidgets('a converter that returns null leaves the word in place', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: ChipInput<String>(onChipSubmit: (String t) => null)),
      );
      await _type(tester, 'nope');
      await _key(tester, LogicalKeyboardKey.enter);
      expect(_chips(tester), isEmpty);
      expect(_plain(tester), 'nope');
    });

    testWidgets('the converter sees each word once per submission', (
      tester,
    ) async {
      final List<String> seen = <String>[];
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            onChipSubmit: (String text) {
              seen.add(text);
              return text;
            },
          ),
        ),
      );
      await _type(tester, 'a');
      await _key(tester, LogicalKeyboardKey.enter);
      expect(seen, <String>['a']);
    });

    testWidgets('an empty field submits nothing', (tester) async {
      await tester.pumpWidget(
        _frame(child: ChipInput<String>(onChipSubmit: (String t) => t)),
      );
      await _type(tester, '');
      await _key(tester, LogicalKeyboardKey.enter);
      expect(_chips(tester), isEmpty);
      expect(_plain(tester), isEmpty);
    });
  });

  group('editing chips', () {
    testWidgets('backspace on an empty field removes the last chip', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['flutter', 'dart'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      expect(_chips(tester), <String>['flutter', 'dart']);
      await _focusAtEnd(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(_chips(tester), <String>['flutter']);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(_chips(tester), isEmpty);
      expect(_plain(tester), isEmpty);
    });

    testWidgets('the remove button deletes exactly its own chip', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['a', 'a', 'b'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      expect(find.byType(ChipButton), findsNWidgets(3));
      await tester.tap(find.byType(ChipButton).at(1));
      await tester.pump();
      // Regression: the old `ChipSpan` carried no index, so the second of two
      // equal values could not be addressed; the first one was removed instead.
      expect(_chips(tester), <String>['a', 'b']);
    });

    testWidgets('the remove button carries the localized label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['a', 'b'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      final Icon icon = tester.widget<Icon>(
        find
            .descendant(
              of: find.byType(ChipButton),
              matching: find.byType(Icon),
            )
            .first,
      );
      expect(icon.semanticLabel, isNotNull);
      expect(
        icon.semanticLabel,
        const ShadcnLocalizations(Locale('en')).chipInputRemoveChip,
      );
      expect(icon.semanticLabel, _enDeleteLabel);
    });

    testWidgets('a read-only field keeps its chips unremovable', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            readOnly: true,
            initialChips: const <String>['a'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      expect(find.byType(ChipButton), findsNothing);
      expect(_chips(tester), <String>['a']);
    });
  });

  group('clipboard', () {
    testWidgets('pasting a delimited string splits into chips', (tester) async {
      _mockClipboard(tester);
      _clipboard = 'flutter, shadcn';
      await tester.pumpWidget(
        _frame(child: ChipInput<String>(onChipSubmit: (String text) => text)),
      );
      await _focusAtEnd(tester);
      await _modifiedKey(tester, LogicalKeyboardKey.keyV);
      await tester.pump();
      expect(_chips(tester), <String>['flutter', 'shadcn']);
      expect(_plain(tester), isEmpty);
    });

    testWidgets('copy writes readable values, never code units', (
      tester,
    ) async {
      _mockClipboard(tester);
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['flutter', 'shadcn'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      await _focusAtEnd(tester);
      final TokenEditingController<String> controller = _ctrl(tester);
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
      await tester.pump();
      await _modifiedKey(tester, LogicalKeyboardKey.keyC);
      expect(
        _clipboard,
        'flutter, shadcn',
        reason: 'the old default glued chips into one unreadable string',
      );
      expect(
        _clipboard.codeUnits.where((int unit) => isTokenCodeUnit(unit)),
        isEmpty,
      );
    });

    testWidgets('a paste with no parser still inserts plain text', (
      tester,
    ) async {
      _mockClipboard(tester);
      _clipboard = 'plain text';
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            onChipSubmit: (String text) => text,
            clipboardHandler: const PlainTokenClipboardHandler<String>(),
          ),
        ),
      );
      await _focusAtEnd(tester);
      await _modifiedKey(tester, LogicalKeyboardKey.keyV);
      expect(_chips(tester), isEmpty);
      expect(_plain(tester), 'plain text');
    });

    testWidgets('paste is inert on a read-only field', (tester) async {
      _mockClipboard(tester);
      _clipboard = 'flutter, shadcn';
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            readOnly: true,
            onChipSubmit: (String text) => text,
          ),
        ),
      );
      await _focusAtEnd(tester);
      await _modifiedKey(tester, LogicalKeyboardKey.keyV);
      expect(_chips(tester), isEmpty);
      expect(_plain(tester), isEmpty);
    });
  });

  group('suggestions', () {
    testWidgets('accepting a suggestion adds a chip', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            onChipSubmit: (String text) => text,
            suggestions: _filter,
          ),
        ),
      );
      await _type(tester, 'ap');
      await _settle(tester);
      await _key(tester, LogicalKeyboardKey.enter);
      await _settle(tester);
      expect(_chips(tester), <String>['apple'], reason: 'the first row');
      expect(_plain(tester), isEmpty);
    });

    testWidgets('focus-without-typing queries the suggestion list', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['x'],
            onChipSubmit: (String text) => text,
            suggestions: _filter,
          ),
        ),
      );
      await tester.tap(find.byType(EditableText));
      await _settle(tester);
      // The empty query has to be offered: `AutoCompleteFeature` reads the
      // field on focus, which is what `input`'s `onFocusGained` wiring enables.
      expect(_plain(tester), '');
      expect(find.byType(shadcn.Card), findsOneWidget);
    });
  });

  group('keyboard navigation', () {
    testWidgets('arrow keys step over each chip as one character', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['a', 'b'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      await _focusAtEnd(tester);
      expect(_ctrl(tester).selection.baseOffset, 2);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(_ctrl(tester).selection.baseOffset, 1);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(_ctrl(tester).selection.baseOffset, 0);
      await _key(tester, LogicalKeyboardKey.arrowLeft);
      expect(_ctrl(tester).selection.baseOffset, 0);

      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(_ctrl(tester).selection.baseOffset, 1);
      await _key(tester, LogicalKeyboardKey.arrowRight);
      expect(_ctrl(tester).selection.baseOffset, 2);
    });
  });

  group('value flow', () {
    testWidgets('uncontrolled: the field owns its chips and reports changes', (
      tester,
    ) async {
      final List<List<String>> reported = <List<String>>[];
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['start'],
            onChipSubmit: (String text) => text,
            onChipsChanged: reported.add,
          ),
        ),
      );
      expect(_chips(tester), <String>['start']);
      await _focusAtEnd(tester);
      await _append(tester, 'next');
      await _key(tester, LogicalKeyboardKey.enter);
      expect(_chips(tester), <String>['start', 'next']);
      expect(reported.last, <String>['start', 'next']);

      await _focusAtEnd(tester);
      await _key(tester, LogicalKeyboardKey.backspace);
      expect(_chips(tester), <String>['start']);
      expect(reported.last, <String>['start']);
    });

    testWidgets('controlled: the parent list wins and removal propagates', (
      tester,
    ) async {
      List<String> value = <String>['one', 'two'];
      late StateSetter set;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              set = setState;
              return ChipInput<String>(
                chips: value,
                onChipsChanged: (List<String> next) => set(() {
                  value = next;
                }),
                onChipSubmit: (String text) => text,
              );
            },
          ),
        ),
      );
      expect(_chips(tester), <String>['one', 'two']);
      await tester.tap(find.byType(ChipButton).first);
      await tester.pump();
      expect(_chips(tester), <String>['two']);
      expect(value, <String>['two']);
    });

    testWidgets('a controlled list from the parent replaces what was there', (
      tester,
    ) async {
      List<String> value = <String>['first'];
      late StateSetter set;
      await tester.pumpWidget(
        _frame(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              set = setState;
              return ChipInput<String>(
                chips: value,
                onChipSubmit: (String text) => text,
              );
            },
          ),
        ),
      );
      expect(_chips(tester), <String>['first']);
      set(() => value = <String>['second']);
      await tester.pump();
      expect(_chips(tester), <String>['second']);
    });
  });

  group('disabled and read-only', () {
    testWidgets('a disabled field drops the remove button', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            enabled: false,
            initialChips: const <String>['a'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      expect(_chips(tester), <String>['a']);
      expect(find.byType(ChipButton), findsNothing);
    });

    testWidgets('a disabled field ignores Enter', (tester) async {
      final FocusNode focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            enabled: false,
            focusNode: focus,
            onChipSubmit: (String text) => text,
          ),
        ),
      );
      // A disabled shell ignores taps (`IgnorePointer`), so focus it directly.
      final TokenEditingController<String> controller = _ctrl(tester);
      controller.value = const TextEditingValue(
        text: 'word',
        selection: TextSelection.collapsed(offset: 4),
      );
      focus.requestFocus();
      await tester.pump();
      await _key(tester, LogicalKeyboardKey.enter);
      expect(_chips(tester), isEmpty);
      expect(_plain(tester), 'word');
    });
  });

  group('theme precedence', () {
    Future<double> spacingOf(
      WidgetTester tester, {
      List<ComponentThemeData> app = const <ComponentThemeData>[],
      ChipInputTheme? scoped,
      ChipInputTheme? widget,
    }) async {
      await tester.pumpWidget(
        _frame(
          app: app,
          scoped: scoped,
          child: ChipInput<String>(
            initialChips: const <String>['seed'],
            theme: widget,
            onChipSubmit: _reject,
          ),
        ),
      );
      return _ctrl(tester).spacing;
    }

    testWidgets('the defaults leg fills an untouched field', (tester) async {
      expect(await spacingOf(tester), chipInputDefaultSpacing);
      expect(
        tester.widget<ChipButton>(find.byType(ChipButton).first).iconSize,
        chipInputDefaultChipIconSize,
      );
    });

    testWidgets('the app leg overrides the defaults', (tester) async {
      expect(
        await spacingOf(
          tester,
          app: const <ComponentThemeData>[ChipInputTheme(spacing: 9)],
        ),
        9,
      );
    });

    testWidgets('the scoped leg overrides the app leg', (tester) async {
      expect(
        await spacingOf(
          tester,
          app: const <ComponentThemeData>[ChipInputTheme(spacing: 9)],
          scoped: const ChipInputTheme(spacing: 12),
        ),
        12,
      );
    });

    testWidgets('the widget leg wins over every other leg', (tester) async {
      expect(
        await spacingOf(
          tester,
          app: const <ComponentThemeData>[ChipInputTheme(spacing: 9)],
          scoped: const ChipInputTheme(spacing: 12),
          widget: const ChipInputTheme(spacing: 15),
        ),
        15,
      );
    });

    testWidgets('the widget leg reaches the remove button too', (tester) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['a'],
            onChipSubmit: (String t) => t,
            theme: const ChipInputTheme(chipIconSize: 20, removable: false),
          ),
        ),
      );
      expect(find.byType(ChipButton), findsNothing);
    });

    testWidgets('the widget leg overrides the field surface too', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            onChipSubmit: _reject,
            inputTheme: const InputTheme(height: 64),
          ),
        ),
      );
      final Iterable<double> mins = tester
          .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
          .map((ConstrainedBox b) => b.constraints.minHeight);
      expect(mins, contains(64));
    });
  });

  group('sizes vs shadcn', () {
    testWidgets('an empty field is 36 high (h-9)', (tester) async {
      await tester.pumpWidget(
        _frame(overlay: false, child: ChipInput<String>(onChipSubmit: _reject)),
      );
      expect(tester.getSize(find.byType(Input)).height, 36);
    });

    testWidgets('the minimum height comes from the surface, not the content', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: ChipInput<String>(
            initialChips: const <String>['tiny'],
            onChipSubmit: (String t) => t,
          ),
        ),
      );
      final Iterable<ConstrainedBox> boxes = tester.widgetList<ConstrainedBox>(
        find.byType(ConstrainedBox),
      );
      expect(
        boxes.map((ConstrainedBox b) => b.constraints.minHeight),
        contains(36),
      );
    });
  });

  group('light and dark', () {
    const ChipInputTheme noRemove = ChipInputTheme(removable: false);

    testWidgets('a chip input paints the chip a plain Chip paints', (
      tester,
    ) async {
      final Color? light = await _backgroundOf(
        tester,
        const ChipInput<String>(
          initialChips: <String>['a'],
          theme: noRemove,
          onChipSubmit: _reject,
        ),
      );
      final Color? reference = await _backgroundOf(
        tester,
        const Chip(child: Text('a')),
      );
      expect(light, isNotNull);
      expect(light, reference);
    });

    testWidgets('the dark theme changes the chip background', (tester) async {
      const ShadcnThemeData dark = ShadcnThemeData(
        colors: ShadcnColors.darkFallback,
      );
      final Color? light = await _backgroundOf(
        tester,
        const Chip(child: Text('a')),
      );
      final Color? darkChip = await _backgroundOf(
        tester,
        const ChipInput<String>(
          initialChips: <String>['a'],
          theme: noRemove,
          onChipSubmit: _reject,
        ),
        data: dark,
      );
      final Color? darkReference = await _backgroundOf(
        tester,
        const Chip(child: Text('a')),
        data: dark,
      );
      expect(darkChip, isNotNull);
      expect(darkChip, darkReference, reason: 'dark reads the dark tokens');
      expect(darkChip, isNot(light));
    });
  });

  group('primitive: TokenEditingController', () {
    TokenEditingController<String> make({List<String>? tokens}) =>
        TokenEditingController<String>(
          initialTokens: tokens,
          tokenBuilder: (BuildContext context, String token, int index) =>
              Text(token),
        );

    test('tokens are stored as private-use code units', () {
      final TokenEditingController<String> c = make(tokens: <String>['a', 'b']);
      addTearDown(c.dispose);
      expect(c.text.codeUnits.every(isTokenCodeUnit), isTrue);
      expect(c.text.length, 2);
      expect(c.tokenCount, 2);
      expect(c.plainText, isEmpty);
    });

    test('the word at the caret is trimmed and bounded by tokens', () {
      final TokenEditingController<String> c = make(tokens: <String>['a', 'b']);
      addTearDown(c.dispose);
      c.value = TextEditingValue(
        text: '${c.text}  word  ',
        selection: const TextSelection.collapsed(offset: 8),
      );
      expect(c.textAtCursor, 'word');
      // Park the caret right after the first token: no plain run, no word.
      c.value = TextEditingValue(
        text: c.text.substring(0, 1),
        selection: const TextSelection.collapsed(offset: 1),
      );
      expect(c.textAtCursor, '');
    });

    test('submitting the word trims it and rejects a null conversion', () {
      final TokenEditingController<String> c = make();
      addTearDown(c.dispose);
      c.value = const TextEditingValue(
        text: '  flutter  ',
        selection: TextSelection.collapsed(offset: 11),
      );
      expect(c.submitTokenAtCursor((String t) => null), isNull);
      expect(c.text, '  flutter  ');
      expect(c.submitTokenAtCursor((String t) => t.toUpperCase()), 'FLUTTER');
      expect(c.tokens, <String>['FLUTTER']);
      expect(c.plainText, '    ');
    });

    test('regression: an unregistered code unit is stripped, not stored', () {
      final TokenEditingController<String> c = make();
      addTearDown(c.dispose);
      // The old controller assigned a private-use unit without registering a
      // token, so the value grew an invisible character nobody could remove.
      c.value = const TextEditingValue(
        text: '\uE000x',
        selection: TextSelection.collapsed(offset: 2),
      );
      expect(c.text, 'x');
      expect(c.selection.baseOffset, 1);
      expect(c.tokens, isEmpty);
    });

    test('setting tokens reorders the run and keeps the surrounding text', () {
      final TokenEditingController<String> c = make(tokens: <String>['a', 'b']);
      addTearDown(c.dispose);
      c.value = const TextEditingValue(
        text: 'before',
        selection: TextSelection.collapsed(offset: 6),
      );
      // No token yet: the run is inserted at the caret.
      c.tokens = <String>['x'];
      expect(c.plainText, 'before');
      expect(c.tokens, <String>['x']);
      // Reordering has to reorder what is painted, too.
      c.tokens = <String>['y', 'x'];
      expect(c.tokens, <String>['y', 'x']);
      expect(c.plainText, 'before');
      c.tokens = <String>[];
      expect(c.plainText, 'before');
      expect(c.tokens, isEmpty);
    });

    test('removeTokenAt addresses duplicates by position', () {
      final TokenEditingController<String> c = make(
        tokens: <String>['a', 'a', 'b'],
      );
      addTearDown(c.dispose);
      // The old `ChipSpan` carried no index, so a repeated value was ambiguous.
      expect(c.removeTokenAt(1), isTrue);
      expect(c.tokens, <String>['a', 'b']);
      expect(c.removeTokenAt(99), isFalse);
      expect(c.removeLastToken(), isTrue);
      expect(c.tokens, <String>['a']);
      expect(c.removeLastToken(), isTrue);
      expect(c.removeLastToken(), isFalse);
    });

    test('fragmentsIn and replaceSelectionWith round-trip', () {
      final TokenEditingController<String> c = make(tokens: <String>['a', 'b']);
      addTearDown(c.dispose);
      final List<TokenFragment<String>> fragments = c.fragmentsIn(
        const TextSelection(baseOffset: 0, extentOffset: 2),
      );
      expect(fragments, hasLength(2));
      expect(fragments[0], isA<TokenValueFragment<String>>());
      expect((fragments[0] as TokenValueFragment<String>).value, 'a');

      final TokenEditingController<String> target = make();
      addTearDown(target.dispose);
      target.replaceSelectionWith(fragments);
      expect(target.tokens, <String>['a', 'b']);

      // A mixed selection keeps the plain runs in place.
      c.value = TextEditingValue(
        text: 'x${c.text}y',
        selection: const TextSelection(baseOffset: 0, extentOffset: 2),
      );
      final List<TokenFragment<String>> mixed = c.fragmentsIn(c.selection);
      expect(mixed, hasLength(2));
      expect((mixed.first as TokenTextFragment<String>).text, 'x');
      expect((mixed.last as TokenValueFragment<String>).value, 'a');
    });
  });

  group('primitive: token spans', () {
    testWidgets('one span per token, carrying its index', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(
        _frame(
          child: Builder(
            builder: (BuildContext c) {
              context = c;
              return const SizedBox();
            },
          ),
        ),
      );
      final TokenEditingController<String> c = TokenEditingController<String>(
        initialTokens: <String>['a', 'a', 'b'],
        tokenBuilder: (BuildContext ctx, String token, int index) =>
            Text(token),
        spacing: 4,
      );
      addTearDown(c.dispose);
      final TextSpan span = c.buildTextSpan(
        context: context,
        style: const TextStyle(),
        withComposing: false,
      );
      final List<TokenSpan<String>> spans = span.children!
          .whereType<TokenSpan<String>>()
          .toList(growable: false);
      expect(spans.map((TokenSpan<String> s) => s.index), <int>[0, 1, 2]);
      expect(spans.map((TokenSpan<String> s) => s.value), <String>[
        'a',
        'a',
        'b',
      ]);
      // Neighbours share the gap: half on each side, so two adjacent chips
      // render exactly `spacing` apart; the last chip keeps a full trailing
      // `spacing`.
      expect(
        (spans[0].child as Padding).padding,
        const EdgeInsets.only(left: 0, right: 2),
      );
      expect(
        (spans[1].child as Padding).padding,
        const EdgeInsets.only(left: 2, right: 2),
      );
      expect(
        (spans[2].child as Padding).padding,
        const EdgeInsets.only(left: 2, right: 4),
      );
    });
  });

  group('primitive: token clipboard', () {
    const PlainTokenClipboardHandler<String> plain =
        PlainTokenClipboardHandler<String>();

    test('adjacent chips serialize with the separator', () {
      expect(
        plain.serializeClipboard(<TokenFragment<String>>[
          const TokenValueFragment<String>('ab'),
          const TokenValueFragment<String>('cd'),
        ]),
        'ab, cd',
        reason: 'the old default produced the unreadable `abcd`',
      );
    });

    test('a text run beside a chip keeps its position', () {
      expect(
        plain.serializeClipboard(<TokenFragment<String>>[
          const TokenTextFragment<String>('pre '),
          const TokenValueFragment<String>('chip'),
          const TokenTextFragment<String>(' post'),
        ]),
        'pre chip post',
      );
      expect(plain.serializeClipboard(const <TokenFragment<String>>[]), '');
    });

    test('without a parser, pasted text stays one plain run', () {
      final List<TokenFragment<String>> out = plain.deserializeClipboard(
        'a, b',
      );
      expect(out, hasLength(1));
      expect((out.single as TokenTextFragment<String>).text, 'a, b');
      expect(plain.deserializeClipboard(''), isEmpty);
    });

    test('with a parser, pasted text splits into chips', () {
      const PlainTokenClipboardHandler<String> split =
          PlainTokenClipboardHandler<String>(chipDeserializer: _parse);
      final List<TokenFragment<String>> out = split.deserializeClipboard(
        ' flutter , shadcn ',
      );
      expect(out, hasLength(2));
      expect((out[0] as TokenValueFragment<String>).value, 'flutter');
      expect((out[1] as TokenValueFragment<String>).value, 'shadcn');

      // A piece the parser rejects stays text instead of vanishing.
      const PlainTokenClipboardHandler<String> guarded =
          PlainTokenClipboardHandler<String>(chipDeserializer: _parseNullish);
      final List<TokenFragment<String>> mixed = guarded.deserializeClipboard(
        'keep, drop',
      );
      expect(mixed, hasLength(2));
      expect((mixed[0] as TokenValueFragment<String>).value, 'keep');
      expect((mixed[1] as TokenTextFragment<String>).text, 'drop');
    });
  });
}
