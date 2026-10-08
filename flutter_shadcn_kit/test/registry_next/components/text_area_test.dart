// Widget tests for the `text_area` component.
//
// Covers the multiline defaults, the forwarded `Input` surface (surface, focus
// ring, validation, form participation, features, keyboard), light and dark
// tokens, all four theme legs, plus a regression per bug the port fixed.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/input/input.dart'
    show Input, InputTheme, inputDefaults;
import 'package:flutter_shadcn_kit/registry_next/components/text_area/text_area.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/form_core/form_core.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/focus_outline.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/adornment_features.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/input_features/input_features.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

Color _alpha(Color base, double factor) =>
    base.withValues(alpha: base.a * factor);

/// Keeps one `OverlayEntry` alive, so re-pumping [_frame] updates the field
/// in place instead of tearing its state down.
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
  InputTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<InputTheme>(data: scoped, child: body);
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

EditableText _field(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

BoxDecoration _surface(WidgetTester tester) =>
    tester
            .widgetList<Container>(
              find.descendant(
                of: find.byType(TextArea),
                matching: find.byType(Container),
              ),
            )
            .first
            .decoration!
        as BoxDecoration;

class _FakeFormHandle with FormFieldHandle {
  final List<String?> reported = <String?>[];
  ReplaceResult<String>? nextReplace;

  @override
  final FormKey<String> formKey = const FormKey<String>('text-area');

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

  group('multiline defaults', () {
    testWidgets('is three lines tall by default', (tester) async {
      await tester.pumpWidget(_frame(const TextArea()));
      final EditableText field = _field(tester);
      expect(field.maxLines, isNull);
      expect(field.minLines, TextArea.textAreaMinLines);
      expect(TextArea.textAreaMaxLines, isNull);
    });

    testWidgets('uses a multiline keyboard', (tester) async {
      await tester.pumpWidget(_frame(const TextArea()));
      expect(_field(tester).keyboardType, TextInputType.multiline);
    });

    testWidgets('capitalises sentences by default', (tester) async {
      await tester.pumpWidget(_frame(const TextArea()));
      expect(
        _field(tester).textCapitalization,
        TextCapitalization.sentences,
        reason: 'Input defaults to none, which suits a code field',
      );
    });

    testWidgets('Enter inserts a newline instead of submitting', (
      tester,
    ) async {
      final List<String> submits = <String>[];
      await tester.pumpWidget(
        _frame(TextArea(initialValue: 'a', onSubmitted: submits.add)),
      );
      expect(_field(tester).textInputAction, isNull);
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.newline);
      await tester.pump();
      // A multiline field asks the platform for a return key, so the action
      // never reaches `onSubmitted` (the framework ignores `newline` here).
      expect(submits, isEmpty);
      expect(_field(tester).controller.text, 'a');
    });

    testWidgets('honours explicit minLines and maxLines', (tester) async {
      await tester.pumpWidget(
        _frame(const TextArea(minLines: 6, maxLines: 10)),
      );
      expect(_field(tester).minLines, 6);
      expect(_field(tester).maxLines, 10);
    });

    testWidgets('rejects maxLines below minLines', (tester) async {
      expect(() => TextArea(minLines: 6, maxLines: 2), throwsAssertionError);
    });

    testWidgets('expands fills the given box', (tester) async {
      await tester.pumpWidget(
        _frame(
          const SizedBox(
            height: 240,
            width: 300,
            child: TextArea(expands: true, minLines: null, maxLines: null),
          ),
        ),
      );
      expect(_field(tester).expands, isTrue);
      expect(tester.getSize(find.byType(TextArea)), const Size(300, 240));
    });

    testWidgets('three lines are taller than the single-line minimum', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const TextArea()));
      final double lines = tester.getSize(find.byType(TextArea)).height;
      expect(lines, greaterThan(inputDefaults.height!));
    });
  });

  group('text entry', () {
    testWidgets('paints the initial value', (tester) async {
      await tester.pumpWidget(
        _frame(const TextArea(initialValue: 'Hello, World!')),
      );
      expect(find.text('Hello, World!'), findsOneWidget);
    });

    testWidgets('reports edits', (tester) async {
      final List<String> changes = <String>[];
      await tester.pumpWidget(_frame(TextArea(onChanged: changes.add)));
      await tester.enterText(find.byType(TextArea), 'typed');
      await tester.pump();
      expect(changes.last, 'typed');
    });

    testWidgets('an external controller drives the field', (tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(_frame(TextArea(controller: controller)));
      controller.text = 'outside';
      await tester.pump();
      expect(find.text('outside'), findsOneWidget);
    });

    testWidgets('a newline is accepted', (tester) async {
      await tester.pumpWidget(_frame(const TextArea(initialValue: 'one\ntwo')));
      expect(_field(tester).maxLines, isNull);
      expect(find.text('one\ntwo'), findsOneWidget);
    });

    testWidgets('features are forwarded to the field', (tester) async {
      await tester.pumpWidget(
        _frame(
          const TextArea(
            features: <InputFeature>[InputLeadingFeature(Text('Lead'))],
          ),
        ),
      );
      expect(
        find.descendant(of: find.byType(TextArea), matching: find.text('Lead')),
        findsOneWidget,
      );
    });
  });

  group('surface', () {
    testWidgets('paints the input tokens', (tester) async {
      await tester.pumpWidget(_frame(const TextArea()));
      final BoxDecoration surface = _surface(tester);
      expect(surface.color, _alpha(colors.input, 0.3));
      expect(surface.border, Border.all(color: colors.input));
      expect(surface.borderRadius, const ShadcnThemeData().borderRadiusMd);
    });

    testWidgets('the focus ring follows focus', (tester) async {
      await tester.pumpWidget(_frame(const TextArea()));
      FocusOutline ring() => tester.widget<FocusOutline>(
        find.descendant(
          of: find.byType(TextArea),
          matching: find.byType(FocusOutline),
        ),
      );
      expect(ring().focused, isFalse);
      await tester.tap(find.byType(EditableText));
      await tester.pump();
      expect(ring().focused, isTrue);
    });

    testWidgets('disabled dims the field and blocks input', (tester) async {
      await tester.pumpWidget(_frame(const TextArea(enabled: false)));
      final Opacity opacity = tester.widget<Opacity>(
        find
            .descendant(
              of: find.byType(TextArea),
              matching: find.byType(Opacity),
            )
            .last,
      );
      expect(opacity.opacity, 0.5);
      expect(_field(tester).readOnly, isTrue);
    });

    testWidgets('read-only still paints the value', (tester) async {
      await tester.pumpWidget(
        _frame(const TextArea(initialValue: 'fixed', readOnly: true)),
      );
      expect(find.text('fixed'), findsOneWidget);
    });
  });

  group('validation', () {
    testWidgets('changed mode validates on every keystroke', (tester) async {
      await tester.pumpWidget(
        _frame(
          TextArea(
            validator: (String? value) =>
                (value ?? '').length < 4 ? 'Too short' : null,
          ),
        ),
      );
      await tester.enterText(find.byType(TextArea), 'ab');
      await tester.pump();
      expect(find.text('Too short'), findsOneWidget);

      await tester.enterText(find.byType(TextArea), 'abcd');
      await tester.pump();
      expect(find.text('Too short'), findsNothing);
    });

    testWidgets('the error swaps the border for the destructive token', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          TextArea(
            initialValue: 'ab',
            validator: (String? value) =>
                (value ?? '').length < 4 ? 'Too short' : null,
          ),
        ),
      );
      await tester.enterText(find.byType(TextArea), 'abc');
      await tester.pump();
      expect(_surface(tester).border, Border.all(color: colors.destructive));
    });
  });

  group('form participation', () {
    testWidgets('reports the value and accepts a replacement', (tester) async {
      final _FakeFormHandle handle = _FakeFormHandle();
      await tester.pumpWidget(
        _frame(
          Data<FormFieldHandle>.inherit(data: handle, child: const TextArea()),
        ),
      );
      await tester.enterText(find.byType(TextArea), 'abc');
      await tester.pump();
      expect(handle.reported, contains('abc'));

      handle.nextReplace = ReplaceResult<String>.attached(
        'replaced',
        key: handle.formKey,
        state: FormValidationMode.changed,
      );
      await tester.enterText(find.byType(TextArea), 'xyz');
      await tester.pump();
      await tester.pump();
      expect(find.text('replaced'), findsOneWidget);
    });
  });

  group('tokens', () {
    for (final (String name, ShadcnColors palette) in <(String, ShadcnColors)>[
      ('light', ShadcnColors.lightFallback),
      ('dark', ShadcnColors.darkFallback),
    ]) {
      testWidgets('$name tokens drive the surface', (tester) async {
        await tester.pumpWidget(
          _frame(const TextArea(), data: ShadcnThemeData(colors: palette)),
        );
        expect(_surface(tester).color, _alpha(palette.input, 0.3));
        expect(_surface(tester).border, Border.all(color: palette.input));
      });

      testWidgets('$name tokens drive the text and the hint', (tester) async {
        await tester.pumpWidget(
          _frame(
            const TextArea(hintText: 'hint'),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(find.text('hint'), findsOneWidget);
        expect(
          tester.widget<Text>(find.text('hint')).style?.color,
          palette.mutedForeground,
        );

        await tester.pumpWidget(
          _frame(
            const TextArea(initialValue: 'value'),
            data: ShadcnThemeData(colors: palette),
          ),
        );
        expect(_field(tester).style.color, palette.foreground);
      });
    }
  });

  group('theme', () {
    testWidgets('the widget leg wins over every other leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const TextArea(
            theme: InputTheme(
              background: StateValue<ThemedColor>(
                rest: ThemedColor.value(_green),
              ),
              padding: EdgeInsets.all(20),
            ),
          ),
          app: const <ComponentThemeData>[
            InputTheme(
              background: StateValue<ThemedColor>(
                rest: ThemedColor.value(_blue),
              ),
              padding: EdgeInsets.all(4),
            ),
          ],
        ),
      );
      expect(_surface(tester).color, _green);
    });

    testWidgets('the scoped leg wins over the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          const TextArea(),
          app: const <ComponentThemeData>[
            InputTheme(
              background: StateValue<ThemedColor>(
                rest: ThemedColor.value(_blue),
              ),
            ),
          ],
          scoped: const InputTheme(
            background: StateValue<ThemedColor>(
              rest: ThemedColor.value(_green),
            ),
          ),
        ),
      );
      expect(_surface(tester).color, _green);
    });

    testWidgets('the app leg wins over the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          const TextArea(),
          app: const <ComponentThemeData>[
            InputTheme(
              background: StateValue<ThemedColor>(
                rest: ThemedColor.value(_green),
              ),
            ),
          ],
        ),
      );
      expect(_surface(tester).color, _green);
    });

    testWidgets('a leg that sets only the fill keeps the default border', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          const TextArea(),
          scoped: const InputTheme(
            background: StateValue<ThemedColor>(
              rest: ThemedColor.value(_green),
            ),
          ),
        ),
      );
      final BoxDecoration surface = _surface(tester);
      expect(surface.color, _green);
      expect(surface.border, Border.all(color: colors.input));
    });

    testWidgets('rebuilds the surface when the app theme changes', (
      tester,
    ) async {
      Widget frame(Color color) => _frame(
        const TextArea(),
        app: <ComponentThemeData>[
          InputTheme(
            background: StateValue<ThemedColor>(rest: ThemedColor.value(color)),
          ),
        ],
      );
      await tester.pumpWidget(frame(_green));
      expect(_surface(tester).color, _green);
      await tester.pumpWidget(frame(_blue));
      expect(_surface(tester).color, _blue);
    });
  });

  group('regressions', () {
    testWidgets('regression: no second theme class', (tester) async {
      await tester.pumpWidget(_frame(const TextArea()));
      expect(find.byType(TextArea), findsOneWidget);
      expect(find.byType(Input), findsOneWidget);
    });

    testWidgets('regression: no drag-resize handle', (tester) async {
      await tester.pumpWidget(_frame(const TextArea(minLines: 4)));
      // No resize cursor anywhere: the handle used `resizeDownRight` /
      // `resizeUpDown` on a `MouseRegion` outside the field's box.
      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is MouseRegion &&
              widget.cursor != SystemMouseCursors.basic &&
              widget.cursor != SystemMouseCursors.text,
        ),
        findsNothing,
      );
      expect(tester.getSize(find.byType(TextArea)).height, greaterThan(60));
    });

    testWidgets('regression: the field has no unbounded size', (tester) async {
      // `initialWidth: double.infinity` plus a drag produced `infinity`
      // arithmetic; a plain text area now only depends on its lines.
      await tester.pumpWidget(_frame(const TextArea()));
      expect(tester.getSize(find.byType(TextArea)).width.isFinite, isTrue);
      expect(tester.takeException(), isNull);
    });

    testWidgets('regression: nothing is painted outside the box', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const TextArea(initialValue: 'text')));
      final Rect box = tester.getRect(find.byType(TextArea));
      final Rect editable = tester.getRect(find.byType(EditableText));
      expect(editable.right, lessThanOrEqualTo(box.right));
      expect(editable.bottom, lessThanOrEqualTo(box.bottom));
    });

    testWidgets('regression: no Material, no Scaffold, no ignore', (
      tester,
    ) async {
      await tester.pumpWidget(_frame(const TextArea()));
      expect(find.byType(EditableText), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('regression: the box grows with the content', (tester) async {
      await tester.pumpWidget(_frame(const TextArea()));
      final double short = tester.getSize(find.byType(TextArea)).height;
      await tester.pumpWidget(_frame(const TextArea(minLines: 8)));
      expect(tester.getSize(find.byType(TextArea)).height, greaterThan(short));
    });
  });
}
