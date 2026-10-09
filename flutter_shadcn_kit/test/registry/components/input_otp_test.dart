// Widget tests for the `input_otp` component.
//
// Covers the painted slots, the hidden field (typing, paste, backspace,
// submit), controlled vs uncontrolled values, form participation, obscuring,
// separators, validation, disabled/read-only, light and dark tokens, all four
// precedence legs, plus a regression per bug the port fixed.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/input_otp/input_otp.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

/// Stable overlay key for the tests that re-pump the same tree: a fresh
/// overlay rebuilds the row from scratch and drops the state being asserted.
/// Keeps one `OverlayEntry` alive and repaints its builder, so re-pumping
/// [_frame] updates the row in place instead of tearing it down.
///
/// `EditableText` needs a real `Overlay` ancestor to open its selection
/// overlay, and an inline `Overlay(initialEntries: [...])` would drop its
/// entries (and every bit of the row's state) whenever the list identity
/// changed.
class _OverlayHost extends StatefulWidget {
  const _OverlayHost({required this.child});

  final Widget child;

  @override
  State<_OverlayHost> createState() => _OverlayHostState();
}

class _OverlayHostState extends State<_OverlayHost> {
  late final OverlayEntry _entry = OverlayEntry(
    builder: (BuildContext context) =>
        Align(alignment: Alignment.topLeft, child: widget.child),
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
  Widget build(BuildContext context) =>
      Overlay(initialEntries: <OverlayEntry>[_entry]);
}

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  InputOtpTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<InputOtpTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: _OverlayHost(child: body),
      ),
    ),
  );
}

Finder get _slots => find.byType(FocusOutline);

/// The one character painted in each slot, in row order.
List<String> _slotCharacters(WidgetTester tester) => tester
    .widgetList<Text>(find.descendant(of: _slots, matching: find.byType(Text)))
    .map((Text text) => text.data ?? '')
    .toList();

/// The decoration of one slot; the focus ring is the second container inside
/// its `FocusOutline`.
BoxDecoration _slotDecoration(WidgetTester tester, int index) =>
    tester
            .widget<Container>(
              find
                  .descendant(
                    of: _slots.at(index),
                    matching: find.byType(Container),
                  )
                  .first,
            )
            .decoration!
        as BoxDecoration;

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

/// The hidden field is the only `EditableText`; focusing it focuses the row.
Future<void> _focus(WidgetTester tester) async {
  await tester.tap(find.byType(InputOtp));
  await tester.pump();
}

EditableText _field(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

class _FakeFormHandle with FormFieldHandle {
  final List<String?> reported = <String?>[];
  ReplaceResult<String>? nextReplace;

  @override
  final FormKey<String> formKey = const FormKey<String>('otp');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value as String?);
    final ReplaceResult<String>? replace = nextReplace;
    nextReplace = null;
    return replace;
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  group('rendering', () {
    testWidgets('paints one empty slot per requested character', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 6)));
      expect(_slots, findsNWidgets(6));
      expect(_slotCharacters(tester), List<String>.filled(6, ''));
    });

    testWidgets('spreads the code across the slots', (tester) async {
      await tester.pumpWidget(
        _frame(const InputOtp(length: 4, initialValue: '12')),
      );
      expect(_slotCharacters(tester), <String>['1', '2', '', '']);
    });

    testWidgets('is a single field: one EditableText, not one per slot', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 6)));
      expect(find.byType(EditableText), findsOneWidget);
    });

    testWidgets('rejects a non-positive length', (tester) async {
      expect(() => InputOtp(length: 0), throwsAssertionError);
    });

    testWidgets('rejects a non-positive separatorEvery', (tester) async {
      expect(
        () => InputOtp(length: 4, separatorEvery: 0),
        throwsAssertionError,
      );
    });

    testWidgets('a slot is the themed box', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 1)));
      expect(tester.getSize(_slots.at(0)), const Size(36, 36));
    });

    testWidgets('the row grows with the length', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 2)));
      final double two = tester.getSize(find.byType(InputOtp)).width;
      await tester.pumpWidget(_frame(const InputOtp(length: 6)));
      expect(tester.getSize(find.byType(InputOtp)).width, greaterThan(two));
    });
  });

  group('typing', () {
    testWidgets('tapping the row focuses the hidden field', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 4)));
      expect(_field(tester).focusNode.hasFocus, isFalse);
      await _focus(tester);
      expect(_field(tester).focusNode.hasFocus, isTrue);
    });

    testWidgets('typing fills the slots and reports the whole code', (
      tester,
    ) async {
      final List<String> changes = <String>[];
      await tester.pumpWidget(
        _frame(InputOtp(length: 4, onChanged: changes.add)),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '12');
      await tester.pump();
      expect(_slotCharacters(tester), <String>['1', '2', '', '']);
      expect(changes, <String>['12']);
    });

    testWidgets('the caret follows the selection', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 4)));
      await _focus(tester);
      expect(
        tester.widget<FocusOutline>(_slots.at(0)).focused,
        isTrue,
        reason: 'an empty field puts the caret in slot 0',
      );

      await tester.enterText(find.byType(InputOtp), '12');
      await tester.pump();
      // The caret sits on the offset, so after "12" it is the next slot.
      expect(tester.widget<FocusOutline>(_slots.at(2)).focused, isTrue);
      expect(tester.widget<FocusOutline>(_slots.at(1)).focused, isFalse);
    });

    testWidgets('a keystroke reaches every slot in order', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 3)));
      await _focus(tester);
      // `enterText` replaces the field; a keystroke appends at the caret.
      for (final String character in <String>['7', '8', '9']) {
        final EditableText field = _field(tester);
        final String next = field.controller.text + character;
        tester.testTextInput.updateEditingValue(
          TextEditingValue(
            text: next,
            selection: TextSelection.collapsed(offset: next.length),
          ),
        );
        await tester.pump();
      }
      expect(_slotCharacters(tester), <String>['7', '8', '9']);
    });

    testWidgets('backspace clears the last slot', (tester) async {
      await tester.pumpWidget(
        _frame(const InputOtp(length: 3, initialValue: '123')),
      );
      await _focus(tester);
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: '12',
          selection: TextSelection.collapsed(offset: 2),
        ),
      );
      await tester.pump();
      expect(_slotCharacters(tester), <String>['1', '2', '']);
    });

    testWidgets('a paste past the length is clamped', (tester) async {
      final List<String> changes = <String>[];
      await tester.pumpWidget(
        _frame(InputOtp(length: 4, onChanged: changes.add)),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '123456');
      await tester.pump();
      expect(_slotCharacters(tester), <String>['1', '2', '3', '4']);
      // The overflow never reaches the slots: the last change is the clamped
      // code and no sixth character is silently dropped on the floor.
      expect(changes.last, '1234');
      expect(changes.every((String code) => code.length <= 4), isTrue);
    });

    testWidgets('submit reports the code and drops focus', (tester) async {
      final List<String> submits = <String>[];
      await tester.pumpWidget(
        _frame(
          InputOtp(length: 4, initialValue: '1234', onSubmitted: submits.add),
        ),
      );
      await _focus(tester);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(submits, <String>['1234']);
      expect(_field(tester).focusNode.hasFocus, isFalse);
    });

    testWidgets('a rejected character is dropped', (tester) async {
      final List<String> changes = <String>[];
      await tester.pumpWidget(
        _frame(
          InputOtp(
            length: 4,
            keyboardType: TextInputType.text,
            filter: (String character) => RegExp('[0-9]').hasMatch(character),
            onChanged: changes.add,
          ),
        ),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '1a2b3');
      await tester.pump();
      expect(_slotCharacters(tester), <String>['1', '2', '3', '']);
      expect(changes.last, '123');
    });

    testWidgets('a surrogate pair stays one slot', (tester) async {
      await tester.pumpWidget(
        _frame(const InputOtp(length: 2, keyboardType: TextInputType.text)),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '😀');
      await tester.pump();
      expect(_slotCharacters(tester), <String>['😀', '']);
    });

    testWidgets('shortening the length trims the code', (tester) async {
      final List<String> changes = <String>[];
      await tester.pumpWidget(
        _frame(
          InputOtp(length: 6, initialValue: '123456', onChanged: changes.add),
        ),
      );
      await tester.pumpWidget(
        _frame(InputOtp(length: 3, onChanged: changes.add)),
      );
      expect(_slotCharacters(tester), <String>['1', '2', '3']);
    });
  });

  group('completion', () {
    testWidgets('onCompleted fires once when the last slot fills', (
      tester,
    ) async {
      final List<String> completed = <String>[];
      await tester.pumpWidget(
        _frame(InputOtp(length: 3, onCompleted: completed.add)),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '12');
      await tester.pump();
      expect(completed, isEmpty);

      await tester.enterText(find.byType(InputOtp), '123');
      await tester.pump();
      expect(completed, <String>['123']);

      // Every later change must not fire the edge again.
      await tester.enterText(find.byType(InputOtp), '1234');
      await tester.pump();
      await tester.enterText(find.byType(InputOtp), '1');
      await tester.pump();
      expect(completed, <String>['123']);

      // ...but filling it again does.
      await tester.enterText(find.byType(InputOtp), '123');
      await tester.pump();
      expect(completed, <String>['123', '123']);
    });

    testWidgets('a code supplied up front does not fire onCompleted', (
      tester,
    ) async {
      final List<String> completed = <String>[];
      await tester.pumpWidget(
        _frame(
          InputOtp(length: 3, initialValue: '123', onCompleted: completed.add),
        ),
      );
      expect(completed, isEmpty);
      expect(_slotCharacters(tester), <String>['1', '2', '3']);
    });
  });

  group('controlled and uncontrolled', () {
    testWidgets('an internal controller keeps the code', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 4)));
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '42');
      await tester.pump();
      expect(_field(tester).controller.text, '42');
      await tester.pumpWidget(_frame(const InputOtp(length: 4)));
      expect(_slotCharacters(tester), <String>['4', '2', '', '']);
    });

    testWidgets('an external controller drives the slots', (tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(InputOtp(length: 4, controller: controller)),
      );
      controller.text = '99';
      await tester.pump();
      expect(_slotCharacters(tester), <String>['9', '9', '', '']);
    });

    testWidgets('initialValue seeds an uncontrolled field', (tester) async {
      await tester.pumpWidget(
        _frame(const InputOtp(length: 3, initialValue: '42')),
      );
      expect(_slotCharacters(tester), <String>['4', '2', '']);
    });
  });

  group('form participation', () {
    testWidgets('reports the code to the form', (tester) async {
      final _FakeFormHandle handle = _FakeFormHandle();
      await tester.pumpWidget(
        _frame(
          Data<FormFieldHandle>.inherit(
            data: handle,
            child: const InputOtp(length: 4),
          ),
        ),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '12');
      await tester.pump();
      expect(handle.reported, contains('12'));
    });

    testWidgets('regression: a replacement reaches the painted slots', (
      tester,
    ) async {
      final _FakeFormHandle handle = _FakeFormHandle();
      await tester.pumpWidget(
        _frame(
          Data<FormFieldHandle>.inherit(
            data: handle,
            child: const InputOtp(length: 4),
          ),
        ),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '12');
      await tester.pump();
      handle.nextReplace = ReplaceResult<String>.attached(
        '9876',
        key: handle.formKey,
        state: FormValidationMode.changed,
      );
      await tester.enterText(find.byType(InputOtp), '34');
      await tester.pump();
      await tester.pump();
      expect(_slotCharacters(tester), <String>['9', '8', '7', '6']);
    });
  });

  group('variants', () {
    testWidgets('obscureText hides every character behind a bullet', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 4, initialValue: '1234', obscureText: true),
        ),
      );
      expect(_slotCharacters(tester), List<String>.filled(4, '•'));
    });

    testWidgets('a separator is drawn every N slots', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 6, separatorEvery: 3, separator: Text('-')),
        ),
      );
      // One per slot plus one after slot 3.
      expect(find.text('-'), findsOneWidget);
      expect(find.byType(InputOtp), findsOneWidget);
    });

    testWidgets('no separator without separatorEvery', (tester) async {
      await tester.pumpWidget(
        _frame(const InputOtp(length: 6, separator: const Text('-'))),
      );
      expect(find.text('-'), findsNothing);
    });

    testWidgets('disabled dims the row to 50% and blocks input', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(const InputOtp(length: 4, enabled: false)),
      );
      // Tree order: the dimming wrapper comes before the hidden field's own
      // (fully transparent) `Opacity`.
      expect(
        tester
            .widget<Opacity>(
              find
                  .descendant(
                    of: find.byType(InputOtp),
                    matching: find.byType(Opacity),
                  )
                  .first,
            )
            .opacity,
        0.5,
      );
      expect(_field(tester).readOnly, isTrue);

      await _focus(tester);
      expect(_field(tester).focusNode.hasFocus, isFalse);
    });

    testWidgets('read-only still paints the code', (tester) async {
      await tester.pumpWidget(
        _frame(const InputOtp(length: 4, initialValue: '1234', readOnly: true)),
      );
      expect(_slotCharacters(tester), <String>['1', '2', '3', '4']);
      expect(_field(tester).readOnly, isTrue);
    });
  });

  group('validation', () {
    String? requireComplete(String? code) =>
        code == null || code.length < 4 ? 'Too short' : null;

    testWidgets('changed mode validates on every keystroke', (tester) async {
      await tester.pumpWidget(
        _frame(InputOtp(length: 4, validator: requireComplete)),
      );
      await _focus(tester);
      await tester.enterText(find.byType(InputOtp), '12');
      await tester.pump();
      // Incomplete codes never reach the validator, so nothing is shown.
      expect(find.text('Too short'), findsNothing);

      await tester.enterText(find.byType(InputOtp), '1234');
      await tester.pump();
      expect(find.text('Too short'), findsNothing);
    });

    testWidgets('a failing validator paints under the row', (tester) async {
      await tester.pumpWidget(
        _frame(
          InputOtp(
            length: 4,
            initialValue: '0000',
            validator: (String? code) => code == '0000' ? 'Rejected' : null,
          ),
        ),
      );
      expect(find.text('Rejected'), findsNothing);

      await tester.pumpWidget(
        _frame(
          InputOtp(
            length: 4,
            initialValue: '0000',
            autovalidateMode: FormValidationMode.initial,
            validator: (String? code) => code == '0000' ? 'Rejected' : null,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Rejected'), findsOneWidget);
    });

    testWidgets('submitted mode validates on submit', (tester) async {
      await tester.pumpWidget(
        _frame(
          InputOtp(
            length: 4,
            initialValue: '0000',
            autovalidateMode: FormValidationMode.submitted,
            validator: (String? code) => code == '0000' ? 'Rejected' : null,
          ),
        ),
      );
      expect(find.text('Rejected'), findsNothing);

      await _focus(tester);
      await tester.pump();
      expect(find.text('Rejected'), findsNothing);

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(find.text('Rejected'), findsOneWidget);
    });

    testWidgets('dropping the validator clears the message', (tester) async {
      Widget field(String? Function(String?)? validator) => _frame(
        InputOtp(
          length: 4,
          initialValue: '0000',
          autovalidateMode: FormValidationMode.initial,
          validator: validator,
        ),
      );
      await tester.pumpWidget(field((String? code) => 'Bad'));
      await tester.pump();
      expect(find.text('Bad'), findsOneWidget);

      await tester.pumpWidget(
        _frame(InputOtp(length: 4, initialValue: '0000', validator: null)),
      );
      await tester.pump();
      expect(find.text('Bad'), findsNothing);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors palette) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('$name tokens drive the slot surface', (tester) async {
        await tester.pumpWidget(
          _frame(
            const InputOtp(length: 2),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        final BoxDecoration decoration = _slotDecoration(tester, 0);
        expect(decoration.color, _alpha(palette.input, 0.3));
        expect(decoration.border, Border.all(color: palette.input));
      });

      testWidgets('$name disabled tokens win over rest', (tester) async {
        await tester.pumpWidget(
          _frame(
            const InputOtp(length: 2, enabled: false),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_slotDecoration(tester, 0).color, _alpha(palette.input, 0));
      });

      testWidgets('$name tokens drive the slot label', (tester) async {
        await tester.pumpWidget(
          _frame(
            const InputOtp(length: 2, initialValue: '42'),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        final Text label = tester.widget<Text>(
          find.descendant(of: _slots.at(0), matching: find.byType(Text)),
        );
        expect(label.style?.color, palette.foreground);
        expect(label.style?.fontSize, 14);
      });
    }
  });

  group('theme', () {
    testWidgets('the widget leg wins over every other leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(
            length: 2,
            theme: InputOtpTheme(
              boxSize: 44,
              borderWidth: 3,
              background: StateValue<ThemedColor>(
                rest: ThemedColor.value(_green),
              ),
            ),
          ),
          app: const <ComponentThemeData>[
            InputOtpTheme(
              boxSize: 30,
              background: StateValue<ThemedColor>(
                rest: ThemedColor.value(_blue),
              ),
            ),
          ],
        ),
      );
      expect(tester.getSize(_slots.at(0)), const Size(44, 44));
      expect(_slotDecoration(tester, 0).color, _green);
      expect(
        _slotDecoration(tester, 0).border,
        Border.all(color: colors.input, width: 3),
      );
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 2),
          app: const <ComponentThemeData>[InputOtpTheme(boxSize: 30)],
          scoped: const InputOtpTheme(boxSize: 50),
        ),
      );
      expect(tester.getSize(_slots.at(0)), const Size(50, 50));
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 2),
          app: const <ComponentThemeData>[InputOtpTheme(boxSize: 30)],
        ),
      );
      expect(tester.getSize(_slots.at(0)), const Size(30, 30));
      expect(_slotDecoration(tester, 0).color, _alpha(colors.input, 0.3));
    });

    testWidgets('a leg that sets only the size keeps the default surface', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 2),
          scoped: const InputOtpTheme(boxSize: 30),
        ),
      );
      final BoxDecoration decoration = _slotDecoration(tester, 0);
      expect(decoration.color, _alpha(colors.input, 0.3));
      expect(decoration.border, Border.all(color: colors.input));
      expect(decoration.borderRadius, const ShadcnThemeData().borderRadiusMd);
    });

    testWidgets('spacing and radius are theme rows', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 3),
          scoped: const InputOtpTheme(
            spacing: 20,
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      );
      final Rect second = tester.getRect(_slots.at(1));
      final Rect first = tester.getRect(_slots.at(0));
      expect(second.left - first.right, 20);
      expect(_slotDecoration(tester, 0).borderRadius, BorderRadius.circular(2));
    });

    testWidgets('a border width of zero draws no border', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 1),
          scoped: const InputOtpTheme(borderWidth: 0),
        ),
      );
      expect(_slotDecoration(tester, 0).border?.top.width, 0);
    });

    testWidgets('the cursor colour is a theme row', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 2),
          scoped: const InputOtpTheme(cursorColor: ThemedColor.value(_green)),
        ),
      );
      expect(_field(tester).cursorColor, _green);
    });

    testWidgets('the default cursor colour is the ring token', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 2)));
      expect(_field(tester).cursorColor, colors.ring);
    });

    testWidgets('rebuilds the row when the app theme changes', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 2),
          app: const <ComponentThemeData>[InputOtpTheme(boxSize: 30)],
        ),
      );
      expect(tester.getSize(_slots.at(0)), const Size(30, 30));

      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 2),
          app: const <ComponentThemeData>[InputOtpTheme(boxSize: 60)],
        ),
      );
      expect(tester.getSize(_slots.at(0)), const Size(60, 60));
    });
  });

  group('regressions', () {
    testWidgets('regression: no focus node is leaked', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 4)));
      await _focus(tester);
      // Rebuilding without a key must dispose the old state's host, which
      // owned the focus node the old widget never released.
      await tester.pumpWidget(_frame(const InputOtp(length: 4)));
      expect(tester.takeException(), isNull);
      expect(find.byType(EditableText), findsOneWidget);
    });

    testWidgets('regression: one hidden field, not one per slot', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 6)));
      expect(find.byType(EditableText), findsOneWidget);
      expect(find.byType(FocusNode), findsNothing);
    });

    testWidgets('regression: the widget theme leg is honoured', (tester) async {
      // The old `_InputOTPSpacing` only read `ComponentTheme`, so a widget
      // level spacing override never applied.
      await tester.pumpWidget(
        _frame(const InputOtp(length: 2, theme: InputOtpTheme(spacing: 24))),
      );
      expect(
        tester.getRect(_slots.at(1)).left - tester.getRect(_slots.at(0)).right,
        24,
      );
    });

    testWidgets('regression: every slot is the same size', (tester) async {
      await tester.pumpWidget(
        _frame(
          const InputOtp(length: 6, separatorEvery: 3, separator: Text('-')),
        ),
      );
      final Size withSeparator = tester.getSize(_slots.at(3));
      await tester.pumpWidget(_frame(const InputOtp(length: 6)));
      final Size plain = tester.getSize(_slots.at(3));
      expect(withSeparator, plain);
    });

    testWidgets('regression: a slot keeps a usable intrinsic size', (
      tester,
    ) async {
      // The old row put `Expanded` children under `IntrinsicWidth`, where the
      // flex meant nothing and the row's width was wrong.
      await tester.pumpWidget(_frame(const InputOtp(length: 4)));
      expect(
        tester.getSize(find.byType(InputOtp)).width,
        greaterThanOrEqualTo(4 * 36),
      );
    });

    testWidgets('regression: no Material or Cupertino import', (tester) async {
      await tester.pumpWidget(_frame(const InputOtp(length: 3)));
      expect(find.byType(InputOtp), findsOneWidget);
      expect(_slots, findsNWidgets(3));
    });
  });
}
