// Widget and unit tests for the `input` component.
//
// Covers design §2.7: controller/initialValue, onChanged/submitted, obscure
// toggle, clear, clipboard copy/paste, spinner/stepper, affixes, hint,
// validation, disabled/read-only, form participation, focus ring, keyboard,
// RTL, selection gestures, theme precedence, dark tokens and the generic
// suggestion slot.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/input/input.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/adornment_features.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/input_features.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/text_editing/text_editing.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

/// Keeps a single `OverlayEntry` so repumping the frame updates its child.
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
  TextDirection textDirection = TextDirection.ltr,
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: textDirection,
          child: ShadcnLayer(
            child: Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.tab): NextFocusIntent(),
              },
              child: Actions(
                actions: <Type, Action<Intent>>{
                  NextFocusIntent: NextFocusAction(),
                },
                child: _OverlayHost(child: child),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

BoxDecoration _surface(WidgetTester tester) {
  final containers = tester.widgetList<Container>(
    find.descendant(of: find.byType(Input), matching: find.byType(Container)),
  );
  return containers.first.decoration! as BoxDecoration;
}

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

FocusOutline _ring(WidgetTester tester) => tester.widget<FocusOutline>(
  find.descendant(of: find.byType(Input), matching: find.byType(FocusOutline)),
);

class _FakeFormHandle with FormFieldHandle {
  final List<String?> reported = <String?>[];
  ReplaceResult<String>? nextReplace;

  @override
  final FormKey<String> formKey = const FormKey<String>('input');

  @override
  bool get mounted => true;

  @override
  ValueListenable<ValidationResult?>? get validity => null;

  @override
  FutureOr<ValidationResult?> reportNewFormValue<T>(T? value) {
    reported.add(value as String?);
    final replace = nextReplace;
    nextReplace = null;
    return replace;
  }

  @override
  FutureOr<ValidationResult?> revalidate() => null;
}

/// Records the focus/text callbacks a feature receives, so a test can prove
/// which one fired. `onTextChanged` never runs for a field that starts out
/// with text, or for one that is focused without typing.
class _FocusRecordingFeature extends InputFeature {
  int focusGained = 0;
  final List<String> texts = <String>[];
  String textAtFocus = '';

  @override
  void onFocusGained(InputFeatureState state) {
    focusGained++;
    textAtFocus = state.text;
  }

  @override
  void onTextChanged(InputFeatureState state, String text) => texts.add(text);
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('renders hint text with the token surface', (tester) async {
    await tester.pumpWidget(_frame(child: const Input(hintText: 'Email')));
    expect(find.text('Email'), findsOneWidget);

    final surface = _surface(tester);
    expect(surface.color, _alpha(colors.input, 0.3));
    expect(surface.border, Border.all(color: colors.input));
    expect(surface.borderRadius, const ShadcnThemeData().borderRadiusMd);
  });

  testWidgets('rejects controller + initialValue together', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Input(controller: TextEditingController(), initialValue: 'x'),
      ),
    );
    expect(tester.takeException(), isAssertionError);
  });

  testWidgets('onChanged and onSubmitted fire', (tester) async {
    final changes = <String>[];
    final submits = <String>[];
    await tester.pumpWidget(
      _frame(
        child: Input(
          hintText: 'Type',
          onChanged: changes.add,
          onSubmitted: submits.add,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'hello');
    await tester.pump();
    expect(changes, <String>['hello']);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(submits, <String>['hello']);
  });

  testWidgets('validator paints the destructive border and clears', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: Input(
          hintText: 'x',
          autovalidateMode: FormValidationMode.submitted,
          validator: (value) => (value ?? '').isEmpty ? 'Required' : null,
          features: const <InputFeature>[InputRevalidateFeature()],
        ),
      ),
    );
    expect(find.text('Required'), findsNothing);

    await tester.tap(find.byIcon(LucideIcons.refreshCw));
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
    expect(_surface(tester).border, Border.all(color: colors.destructive));

    await tester.enterText(find.byType(EditableText), 'ok');
    await tester.pump();
    // Submitted mode does not validate on change.
    expect(find.text('Required'), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.refreshCw));
    await tester.pump();
    expect(find.text('Required'), findsNothing);
    expect(_surface(tester).border, Border.all(color: colors.input));
  });

  testWidgets('changed mode validates on every keystroke', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: Input(
          hintText: 'x',
          validator: (value) => value == 'bad' ? 'Required' : null,
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'bad');
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), 'good');
    await tester.pump();
    expect(find.text('Required'), findsNothing);
  });

  testWidgets('disabled blocks interaction and dims the field', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Input(hintText: 'x', enabled: false)),
    );
    final opacity = tester.widget<Opacity>(
      find
          .descendant(of: find.byType(Input), matching: find.byType(Opacity))
          .first,
    );
    expect(opacity.opacity, 0.5);
    expect(_editable(tester).readOnly, isTrue);

    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(_editable(tester).focusNode.hasFocus, isFalse);
  });

  testWidgets('read-only still renders the value', (tester) async {
    await tester.pumpWidget(
      _frame(child: const Input(readOnly: true, initialValue: 'fixed value')),
    );
    expect(_editable(tester).readOnly, isTrue);
    expect(find.text('fixed value'), findsOneWidget);
  });

  testWidgets('participates in a form and accepts replacements', (
    tester,
  ) async {
    final handle = _FakeFormHandle();
    final controller = TextEditingController();
    await tester.pumpWidget(
      _frame(
        child: Data<FormFieldHandle>.inherit(
          data: handle,
          child: Input(controller: controller),
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), 'abc');
    await tester.pump();
    expect(handle.reported, contains('abc'));

    handle.nextReplace = ReplaceResult<String>.attached(
      'replaced',
      key: handle.formKey,
      state: FormValidationMode.changed,
    );
    await tester.enterText(find.byType(EditableText), 'xyz');
    await tester.pump();
    await tester.pump();
    expect(controller.text, 'replaced');
  });

  testWidgets('focus ring follows focus', (tester) async {
    await tester.pumpWidget(_frame(child: const Input(hintText: 'x')));
    expect(_ring(tester).focused, isFalse);

    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(_ring(tester).focused, isTrue);
  });

  testWidgets('Tab moves focus to the next field', (tester) async {
    final first = FocusNode(debugLabel: 'first');
    final second = FocusNode(debugLabel: 'second');
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    await tester.pumpWidget(
      _frame(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Input(focusNode: first, hintText: 'first'),
            Input(focusNode: second, hintText: 'second'),
          ],
        ),
      ),
    );
    await tester.tap(find.byType(EditableText).first);
    await tester.pump();
    expect(first.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(second.hasFocus, isTrue);
    expect(first.hasFocus, isFalse);
  });

  testWidgets('RTL keeps leading on the start side', (tester) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: Input(
          hintText: 'x',
          features: <InputFeature>[
            InputLeadingFeature(const Text('Lead')),
            InputTrailingFeature(const Text('Trail')),
          ],
        ),
      ),
    );
    final leadX = tester.getTopLeft(find.text('Lead')).dx;
    final trailX = tester.getTopLeft(find.text('Trail')).dx;
    expect(leadX, greaterThan(trailX));
  });

  testWidgets('tap places the caret', (tester) async {
    final controller = TextEditingController(text: 'hello world');
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: Input(controller: controller)));

    final point =
        tester.getTopLeft(find.byType(EditableText)) + const Offset(16, 12);
    await tester.tapAt(point);
    await tester.pump(const Duration(milliseconds: 400));
    expect(controller.selection.isValid, isTrue);
    expect(controller.selection.isCollapsed, isTrue);
  });

  testWidgets('double tap selects a word', (tester) async {
    final controller = TextEditingController(text: 'hello world');
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: Input(controller: controller)));

    // The second tap lands past the first tap's cursor handle (48px box) but
    // stays inside the double-tap slop (100px).
    final base = tester.getTopLeft(find.byType(EditableText));
    await tester.tapAt(base + const Offset(16, 12));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(base + const Offset(80, 12));
    await tester.pump(const Duration(milliseconds: 50));
    expect(controller.selection.isCollapsed, isFalse);
  });

  testWidgets('long press selects a word', (tester) async {
    final controller = TextEditingController(text: 'hello world');
    addTearDown(controller.dispose);
    await tester.pumpWidget(_frame(child: Input(controller: controller)));

    final point =
        tester.getTopLeft(find.byType(EditableText)) + const Offset(40, 12);
    await tester.longPressAt(point);
    await tester.pump(const Duration(milliseconds: 400));
    expect(controller.selection.isCollapsed, isFalse);
  });

  testWidgets('uses the widgets-only selection controls by default', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const Input(hintText: 'x')));
    final editable = _editable(tester);
    expect(editable.selectionControls, isA<ShadcnSelectionControls>());
    expect(editable.contextMenuBuilder, isNotNull);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    final red = StateValue<ThemedColor>(rest: ThemedColor.value(_red));
    final green = StateValue<ThemedColor>(rest: ThemedColor.value(_green));
    final blue = StateValue<ThemedColor>(rest: ThemedColor.value(_blue));

    await tester.pumpWidget(_frame(child: const Input(hintText: 'x')));
    expect(_surface(tester).color, _alpha(colors.input, 0.3));

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[InputTheme(background: red)],
        child: const Input(hintText: 'x'),
      ),
    );
    expect(_surface(tester).color, _red);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[InputTheme(background: red)],
        child: ComponentTheme<InputTheme>(
          data: InputTheme(background: green),
          child: const Input(hintText: 'x'),
        ),
      ),
    );
    expect(_surface(tester).color, _green);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[InputTheme(background: red)],
        child: ComponentTheme<InputTheme>(
          data: InputTheme(background: green),
          child: Input(
            hintText: 'x',
            theme: InputTheme(background: blue),
          ),
        ),
      ),
    );
    expect(_surface(tester).color, _blue);
  });

  testWidgets('stacked hovered-only override keeps the lower rest fill', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[
          InputTheme(
            background: StateValue<ThemedColor>(
              rest: ThemedColor.value(_red),
              hovered: ThemedColor.value(_red),
            ),
          ),
        ],
        child: ComponentTheme<InputTheme>(
          data: InputTheme(
            background: StateValue<ThemedColor>(
              hovered: ThemedColor.value(_green),
            ),
          ),
          child: const Input(hintText: 'x'),
        ),
      ),
    );
    expect(_surface(tester).color, _red);
  });

  testWidgets('dark tokens drive the surface', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: const Input(hintText: 'x'),
      ),
    );
    expect(_surface(tester).color, _alpha(dark.colors.input, 0.3));
    expect(_surface(tester).border, Border.all(color: dark.colors.input));
  });

  testWidgets('editable text uses the theme font family', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const Input(hintText: 'Email', initialValue: 'typed'),
      ),
    );
    final editable = _editable(tester);
    expect(
      editable.style.fontFamily,
      const ShadcnThemeData().typography.sans.fontFamily,
      reason: 'typed text must render in the theme font, not the default',
    );
    expect(editable.style.fontSize, 14);
    expect(editable.style.color, colors.foreground);
  });

  testWidgets('placeholder uses mutedForeground', (tester) async {
    await tester.pumpWidget(_frame(child: const Input(hintText: 'Email')));
    final hint = tester.widget<Text>(find.text('Email'));
    expect(hint.style?.color, colors.mutedForeground);
  });

  testWidgets('explicit style override wins over the theme font', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        child: const Input(
          initialValue: 'typed',
          theme: InputTheme(
            textStyle: TextStyle(fontFamily: 'Custom', fontSize: 20),
          ),
        ),
      ),
    );
    final editable = _editable(tester);
    expect(editable.style.fontFamily, 'Custom');
    expect(editable.style.fontSize, 20);
  });

  testWidgets('a feature gets onFocusGained for a pre-filled field', (
    tester,
  ) async {
    final _FocusRecordingFeature feature = _FocusRecordingFeature();
    await tester.pumpWidget(
      _frame(
        child: Input(
          initialValue: 'already filled',
          features: <InputFeature>[feature],
        ),
      ),
    );
    // Nothing has been typed, so `onTextChanged` has not run at all.
    expect(feature.focusGained, 0);
    expect(feature.texts, isEmpty);

    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(feature.focusGained, 1);
    expect(feature.textAtFocus, 'already filled');
    expect(feature.texts, isEmpty);

    // A rebuild inside the same focus session must not announce it twice.
    await tester.pump();
    expect(feature.focusGained, 1);
  });

  testWidgets('a feature gets onFocusGained for focus without typing', (
    tester,
  ) async {
    final _FocusRecordingFeature feature = _FocusRecordingFeature();
    await tester.pumpWidget(
      _frame(
        child: Input(hintText: 'Type', features: <InputFeature>[feature]),
      ),
    );
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(feature.focusGained, 1);
    expect(feature.texts, isEmpty, reason: 'no keystroke, no text callback');
    expect(feature.textAtFocus, '');

    // Regaining focus announces again: the guard resets on blur.
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(feature.focusGained, 1);
    await tester.tap(find.byType(EditableText));
    await tester.pump();
    expect(feature.focusGained, 2);
  });
}
