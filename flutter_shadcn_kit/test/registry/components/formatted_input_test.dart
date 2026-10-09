// Widget and unit tests for the `formatted_input` component and the segmented
// editing primitives it builds on.
//
// Covers: parts and value helpers, the segment controller (length clamp,
// focus order, auto-advance), rendering + separators, controlled and
// controller flows, keyboard navigation between segments, validation, the
// disabled state, focus ring, form participation, theme precedence for all
// four legs, dark tokens and a regression test per fixed old bug.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/formatted_input/formatted_input.dart';
import 'package:flutter_shadcn_kit/registry/components/form/form.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/primitives/text_editing/segmented_editing.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Keeps one [OverlayEntry] so the selection controls have somewhere to live.
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.child});

  final Widget child;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (_) => Center(child: widget.child),
  );

  @override
  void didUpdateWidget(covariant _OverlayHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _entry.markNeedsBuild();
  }

  @override
  void dispose() {
    _entry
      ..remove()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_entry]);
}

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _OverlayHost(child: child),
      ),
    ),
  );
}

const SegmentedValue _phone = SegmentedValue(<SegmentPart>[
  SegmentPart.editable(length: 3, width: 32, placeholder: Text('555')),
  SegmentPart.separator(' ('),
  SegmentPart.editable(length: 3, width: 32, placeholder: Text('123')),
  SegmentPart.separator(') '),
  SegmentPart.editable(length: 4, width: 36, placeholder: Text('4567')),
]);

/// Types [text] into the segment at [index].
Future<void> _type(WidgetTester tester, int index, String text) async {
  await tester.enterText(find.byType(EditableText).at(index), text);
  await tester.pump();
}

/// Ten digits, separators ignored.
String? _validateNumber(String? text) =>
    (text ?? '').replaceAll(RegExp(r'[^0-9]'), '').length == 10
    ? null
    : 'Enter a full number.';

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  group('SegmentPart / SegmentedValue', () {
    test('separators are excluded from the values', () {
      expect(_phone.values.length, 3);
      expect(_phone.parts.length, 5);
    });

    test('text joins separators and values', () {
      expect(_phone.text, ' () ');
      expect(_phone.withValue(0, '555').text, '555 () ');
    });

    test('withValue leaves the other parts alone', () {
      final SegmentedValue next = _phone.withValue(2, '123');
      expect(next.values.first.value, '');
      expect(next.values.last.value, '123');
      expect(next.parts.length, 5);
    });

    test('equality is by value', () {
      expect(_phone.withValue(0, 'a'), isNot(_phone));
      expect(_phone.withValue(0, ''), _phone);
      expect(
        const SegmentPart.separator('-'),
        const SegmentPart.separator('-'),
      );
      expect(
        const SegmentPart.separator('-').hashCode,
        const SegmentPart.separator('-').hashCode,
      );
    });
  });

  group('SegmentedTextController', () {
    test('clamps writes to the segment length', () {
      final SegmentedTextController controller = SegmentedTextController(
        segments: const <TextSegment>[TextSegment(length: 3)],
      );
      addTearDown(controller.dispose);
      controller.setText(0, '123456');
      expect(controller.values, <String>['123']);
      expect(controller.isFull(0), isTrue);
      expect(controller.isComplete, isTrue);
      // Out of range writes are ignored instead of throwing.
      controller.setText(5, 'nope');
      expect(controller.values, <String>['123']);
    });

    test('focus order stops at the ends', () {
      final SegmentedTextController controller = SegmentedTextController(
        segments: const <TextSegment>[
          TextSegment(length: 2),
          TextSegment(length: 2),
        ],
      );
      addTearDown(controller.dispose);
      expect(controller.moveFocus(0, -1), isFalse);
      expect(controller.moveFocus(1, 1), isFalse);
      expect(controller.moveFocus(0, 1), isTrue);
    });

    test('resize keeps the surviving values', () {
      final SegmentedTextController controller = SegmentedTextController(
        segments: const <TextSegment>[
          TextSegment(length: 2),
          TextSegment(length: 2),
        ],
        values: const <String>['12', '34'],
      );
      addTearDown(controller.dispose);
      expect(
        controller.resize(const <TextSegment>[TextSegment(length: 2)]),
        isTrue,
      );
      expect(controller.values, <String>['12']);
      expect(
        controller.resize(const <TextSegment>[TextSegment(length: 2)]),
        isFalse,
      );
    });

    test('selectAll and selectedText span every segment', () {
      final SegmentedTextController controller = SegmentedTextController(
        segments: const <TextSegment>[
          TextSegment(length: 2),
          TextSegment(length: 2),
        ],
        values: const <String>['12', '34'],
      );
      addTearDown(controller.dispose);
      expect(controller.selectedText, '');
      controller.selectAll();
      expect(controller.selectedText, '1234');
      expect(controller.text, '1234');
    });
  });

  testWidgets('renders the separators and the placeholders', (tester) async {
    await tester.pumpWidget(
      _frame(child: const FormattedInput(initialValue: _phone)),
    );
    expect(find.text(' ('), findsOneWidget);
    expect(find.text(') '), findsOneWidget);
    expect(find.text('555'), findsOneWidget);
    expect(find.byType(EditableText), findsNWidgets(3));
  });

  testWidgets('field height is the shadcn input height (36)', (tester) async {
    await tester.pumpWidget(
      _frame(child: const FormattedInput(initialValue: _phone)),
    );
    expect(tester.getSize(find.byType(FocusOutline)).height, 36);
  });

  testWidgets('controlled: typing reports the whole value', (tester) async {
    final List<SegmentedValue> changes = <SegmentedValue>[];
    SegmentedValue? value;
    await tester.pumpWidget(
      _frame(
        child: FormattedInput(
          value: value ?? _phone,
          onChanged: (SegmentedValue next) {
            changes.add(next);
            value = next;
          },
        ),
      ),
    );
    await _type(tester, 0, '555');
    expect(changes.single.text, '555 () ');
  });

  testWidgets('controller: typing writes through the controller', (
    tester,
  ) async {
    final FormattedInputController controller = FormattedInputController(
      _phone,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(child: FormattedInput(controller: controller)),
    );
    await _type(tester, 1, '123');
    expect(controller.value.text, ' (123) ');
  });

  testWidgets('controller: an external write updates the segments', (
    tester,
  ) async {
    final FormattedInputController controller = FormattedInputController(
      _phone,
    );
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(child: FormattedInput(controller: controller)),
    );
    controller.value = _phone.withValue(0, '123');
    await tester.pump();
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).first)
          .controller
          .text,
      '123',
    );
  });

  testWidgets('keyboard: a full segment moves to the next one', (tester) async {
    await tester.pumpWidget(
      _frame(child: const FormattedInput(initialValue: _phone)),
    );
    await tester.tap(find.byType(EditableText).first);
    await tester.pump();
    await tester.enterText(find.byType(EditableText).first, '555');
    await tester.pump();
    final List<FocusNode> nodes = tester
        .widgetList<EditableText>(find.byType(EditableText))
        .map((EditableText field) => field.focusNode)
        .toList();
    expect(nodes[1].hasFocus, isTrue);
  });

  testWidgets('keyboard: backspace at the start steps back a segment', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const FormattedInput(initialValue: _phone)),
    );
    final List<FocusNode> nodes = tester
        .widgetList<EditableText>(find.byType(EditableText))
        .map((EditableText field) => field.focusNode)
        .toList();
    nodes[1].requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.pump();
    expect(nodes[0].hasFocus, isTrue);
  });

  testWidgets('a disabled field is dimmed to 50% and ignores input', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const FormattedInput(initialValue: _phone, enabled: false)),
    );
    expect(
      tester
          .widgetList<Opacity>(
            find.descendant(
              of: find.byType(FormattedInput),
              matching: find.byType(Opacity),
            ),
          )
          .first
          .opacity,
      0.5,
    );
    final EditableText field = tester.widget<EditableText>(
      find.byType(EditableText).first,
    );
    expect(field.readOnly, isTrue);
  });

  testWidgets('a validator reports below the field', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: FormattedInput(
          initialValue: _phone,
          autovalidateMode: FormValidationMode.initial,
          validator: _validateNumber,
        ),
      ),
    );
    expect(find.text('Enter a full number.'), findsOneWidget);
    expect(find.text(' () '), findsNothing);
    await _type(tester, 0, '555');
    await _type(tester, 1, '123');
    await _type(tester, 2, '4567');
    expect(find.text('Enter a full number.'), findsNothing);
    expect(find.byType(EditableText), findsNWidgets(3));
  });

  testWidgets('participates in a form', (tester) async {
    final FormKey<SegmentedValue> key = FormKey<SegmentedValue>('phone');
    final FormController controller = FormController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _frame(
        child: ShadcnForm(
          controller: controller,
          child: FormEntry<SegmentedValue>(
            key: key,
            child: const FormattedInput(initialValue: _phone),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(controller.hasValue(key), isTrue);
    final SubmissionResult result = await controller.submit(
      tester.element(find.byType(FormattedInput)),
    );
    expect(result.errors.containsKey(key), isFalse);
  });

  testWidgets('focus ring follows the focused segment', (tester) async {
    await tester.pumpWidget(
      _frame(child: const FormattedInput(initialValue: _phone)),
    );
    expect(
      tester
          .widgetList<FocusOutline>(
            find.descendant(
              of: find.byType(FormattedInput),
              matching: find.byType(FocusOutline),
            ),
          )
          .first
          .focused,
      isFalse,
    );
    tester
        .widget<EditableText>(find.byType(EditableText).first)
        .focusNode
        .requestFocus();
    await tester.pump();
    expect(
      tester
          .widgetList<FocusOutline>(
            find.descendant(
              of: find.byType(FormattedInput),
              matching: find.byType(FocusOutline),
            ),
          )
          .first
          .focused,
      isTrue,
    );
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = Color(0xFFFF0000);
    const green = Color(0xFF00FF00);
    const blue = Color(0xFF0000FF);

    Color? fill() {
      final Iterable<Container> boxes = tester.widgetList<Container>(
        find.descendant(
          of: find.byType(FormattedInput),
          matching: find.byType(Container),
        ),
      );
      final Decoration? decoration = boxes.first.decoration;
      return decoration is BoxDecoration ? decoration.color : null;
    }

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          FormattedInputTheme(background: ThemedColor.value(red)),
        ],
        child: const FormattedInput(initialValue: _phone),
      ),
    );
    expect(fill(), red);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          FormattedInputTheme(background: ThemedColor.value(red)),
        ],
        child: const ComponentTheme<FormattedInputTheme>(
          data: FormattedInputTheme(background: ThemedColor.value(green)),
          child: FormattedInput(initialValue: _phone),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(fill(), green);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          FormattedInputTheme(background: ThemedColor.value(red)),
        ],
        child: const ComponentTheme<FormattedInputTheme>(
          data: FormattedInputTheme(background: ThemedColor.value(green)),
          child: FormattedInput(
            initialValue: _phone,
            theme: FormattedInputTheme(background: ThemedColor.value(blue)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(fill(), blue);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          FormattedInputTheme(
            background: ThemedColor.value(Color(0xFFFF0000)),
            height: 44,
          ),
        ],
        child: const ComponentTheme<FormattedInputTheme>(
          data: FormattedInputTheme(partGap: 4),
          child: FormattedInput(initialValue: _phone),
        ),
      ),
    );
    final FormattedInputTheme resolved =
        resolveComponentStyle<FormattedInputTheme, FormattedInputTheme>(
          tester.element(find.byType(FormattedInput)),
          widget: null,
          select: (FormattedInputTheme t) => t,
          defaults: formattedInputDefaults,
        );
    expect(resolved.height, 44);
    expect(resolved.partGap, 4);
    expect(resolved.background, const ThemedColor.value(Color(0xFFFF0000)));
  });

  testWidgets('dark tokens drive the field fill', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: const FormattedInput(initialValue: _phone),
      ),
    );
    final BoxDecoration decoration =
        tester
                .widgetList<Container>(
                  find.descendant(
                    of: find.byType(FormattedInput),
                    matching: find.byType(Container),
                  ),
                )
                .first
                .decoration!
            as BoxDecoration;
    expect(
      decoration.color,
      dark.colors.input.withValues(alpha: dark.colors.input.a * 0.3),
    );
    expect(decoration.color, isNot(colors.input));
  });

  testWidgets('a changed part list rebuilds the segments (regression)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const FormattedInput(initialValue: _phone)),
    );
    expect(find.byType(EditableText), findsNWidgets(3));
    await tester.pumpWidget(
      _frame(
        child: const FormattedInput(
          initialValue: SegmentedValue(<SegmentPart>[
            SegmentPart.editable(length: 2, width: 28),
            SegmentPart.separator('/'),
            SegmentPart.editable(length: 2, width: 28),
          ]),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(EditableText), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('a same-shape value swap keeps the focus and the caret', (
    tester,
  ) async {
    SegmentedValue? value;
    await tester.pumpWidget(
      _frame(
        child: FormattedInput(
          value: value ?? _phone,
          onChanged: (SegmentedValue next) => value = next,
        ),
      ),
    );
    await tester.tap(find.byType(EditableText).first);
    await tester.pump();
    // Two of three digits, so no auto-advance and no rebuild of the segments.
    await _type(tester, 0, '55');
    final TextEditingController before = tester
        .widget<EditableText>(find.byType(EditableText).first)
        .controller;
    await tester.pump();
    final TextEditingController after = tester
        .widget<EditableText>(find.byType(EditableText).first)
        .controller;
    expect(identical(before, after), isTrue);
    expect(after.text, '55');
    expect(after.selection.baseOffset, 2);
    expect(after.selection.isValid, isTrue);
  });

  testWidgets('the segment keeps its own formatters (regression)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: FormattedInput(
          initialValue: SegmentedValue(<SegmentPart>[
            SegmentPart.editable(
              length: 4,
              width: 40,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ]),
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'a1b2c3');
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).controller.text,
      '123',
    );
  });

  testWidgets('an initial-mode error clears once the value is valid', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: FormattedInput(
          initialValue: _phone,
          autovalidateMode: FormValidationMode.initial,
          validator: _validateNumber,
        ),
      ),
    );
    expect(find.text('Enter a full number.'), findsOneWidget);
    await _type(tester, 0, '555');
    await _type(tester, 1, '123');
    await _type(tester, 2, '4567');
    expect(find.text('Enter a full number.'), findsNothing);
  });
}
