// Widget and unit tests for the `selectable` component.
//
// Covers: token rendering (light + dark), rich text, caret defaults, the
// four theme legs, per-field merge, tap/double-tap/long-press selection, the
// read-only context menu (Copy/Select-all, no Cut/Paste), disabled
// selection, content updates, semantics and RTL.

import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/selectable/selectable.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/text_editing/text_editing.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

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
          child: _OverlayHost(child: child),
        ),
      ),
    ),
  );
}

EditableText _editable(WidgetTester tester) =>
    tester.widget<EditableText>(find.byType(EditableText));

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  testWidgets('renders read-only with the foreground token', (tester) async {
    await tester.pumpWidget(_frame(child: const SelectableText('hello')));
    final editable = _editable(tester);
    expect(editable.readOnly, isTrue);
    expect(editable.style.color, colors.foreground);
    expect(editable.selectionControls, isA<ShadcnSelectionControls>());
    expect(editable.contextMenuBuilder, isNotNull);
    expect(editable.enableInteractiveSelection, isTrue);
  });

  testWidgets('dark tokens drive the text colour', (tester) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(data: dark, child: const SelectableText('hello')),
    );
    expect(_editable(tester).style.color, dark.colors.foreground);
  });

  testWidgets('rich text renders through the controller span', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: SelectableText.rich(
          const TextSpan(
            children: <TextSpan>[
              TextSpan(text: 'Bold '),
              TextSpan(text: 'and normal.'),
            ],
          ),
        ),
      ),
    );
    final editable = _editable(tester);
    final span = editable.controller.buildTextSpan(
      context: tester.element(find.byType(SelectableText)),
      style: null,
      withComposing: false,
    );
    expect(span.toPlainText(), 'Bold and normal.');
    expect(span.children, isNotEmpty);
  });

  testWidgets('caret and selection defaults come from the theme', (
    tester,
  ) async {
    await tester.pumpWidget(_frame(child: const SelectableText('hello')));
    final editable = _editable(tester);
    expect(editable.cursorColor, colors.primary);
    expect(editable.cursorWidth, 2);
    expect(editable.selectionHeightStyle, BoxHeightStyle.tight);
    expect(editable.selectionWidthStyle, BoxWidthStyle.tight);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = SelectableTextTheme(cursorWidth: 3);
    const green = SelectableTextTheme(cursorWidth: 4);
    const blue = SelectableTextTheme(cursorWidth: 5);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const SelectableText('hello'),
      ),
    );
    expect(_editable(tester).cursorWidth, 3);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<SelectableTextTheme>(
          data: green,
          child: SelectableText('hello'),
        ),
      ),
    );
    expect(_editable(tester).cursorWidth, 4);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[red],
        child: const ComponentTheme<SelectableTextTheme>(
          data: green,
          child: SelectableText('hello', theme: blue),
        ),
      ),
    );
    expect(_editable(tester).cursorWidth, 5);
  });

  testWidgets('partial legs merge per field (regression)', (tester) async {
    // The old component resolved `this.theme ?? ComponentTheme.maybeOf()`
    // wholesale, so one widget-leg field dropped every scoped/app field.
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[SelectableTextTheme(cursorWidth: 6)],
        child: const ComponentTheme<SelectableTextTheme>(
          data: SelectableTextTheme(cursorColor: ThemedColor.value(_green)),
          child: SelectableText(
            'hello',
            theme: SelectableTextTheme(cursorColor: ThemedColor.value(_blue)),
          ),
        ),
      ),
    );
    final editable = _editable(tester);
    expect(editable.cursorWidth, 6);
    expect(editable.cursorColor, _blue);
  });

  testWidgets('widget arguments beat every theme leg', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[SelectableTextTheme(cursorWidth: 9)],
        child: const SelectableText('hello', cursorWidth: 1, cursorColor: _red),
      ),
    );
    final editable = _editable(tester);
    expect(editable.cursorWidth, 1);
    expect(editable.cursorColor, _red);
  });

  testWidgets('tap places the caret', (tester) async {
    await tester.pumpWidget(_frame(child: const SelectableText('hello world')));
    final point =
        tester.getTopLeft(find.byType(EditableText)) + const Offset(10, 8);
    await tester.tapAt(point);
    await tester.pump(const Duration(milliseconds: 400));
    final controller = _editable(tester).controller;
    expect(controller.selection.isValid, isTrue);
    expect(controller.selection.isCollapsed, isTrue);
  });

  testWidgets('double tap selects a word', (tester) async {
    await tester.pumpWidget(_frame(child: const SelectableText('hello world')));
    final base = tester.getTopLeft(find.byType(EditableText));
    await tester.tapAt(base + const Offset(16, 8));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tapAt(base + const Offset(80, 8));
    await tester.pump(const Duration(milliseconds: 50));
    final controller = _editable(tester).controller;
    expect(controller.selection.isCollapsed, isFalse);
  });

  testWidgets('long press selects a word', (tester) async {
    await tester.pumpWidget(_frame(child: const SelectableText('hello world')));
    final point =
        tester.getTopLeft(find.byType(EditableText)) + const Offset(40, 8);
    await tester.longPressAt(point);
    await tester.pump(const Duration(milliseconds: 400));
    expect(_editable(tester).controller.selection.isCollapsed, isFalse);
  });

  testWidgets('read-only menu offers Copy and Select all, not Cut/Paste', (
    tester,
  ) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.getData') {
          return <String, dynamic>{'text': 'clip'};
        }
        if (call.method == 'Clipboard.hasStrings') {
          return <String, dynamic>{'value': true};
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

    late BuildContext context;
    await tester.pumpWidget(
      _frame(
        child: Builder(
          builder: (c) {
            context = c;
            return const SelectableText('hello world');
          },
        ),
      ),
    );
    final editable = _editable(tester);
    editable.controller.selection = const TextSelection(
      baseOffset: 0,
      extentOffset: 5,
    );
    await tester.pump();
    await tester.pump();

    final state = tester.state<EditableTextState>(find.byType(EditableText));
    final menu = defaultShadcnContextMenuBuilder(context, state);
    await tester.pumpWidget(_frame(child: menu));
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Select all'), findsOneWidget);
    expect(find.text('Cut'), findsNothing);
    expect(find.text('Paste'), findsNothing);
  });

  testWidgets('disabled selection drops the controls', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: const SelectableText('hello', enableInteractiveSelection: false),
      ),
    );
    final editable = _editable(tester);
    expect(editable.enableInteractiveSelection, isFalse);
    expect(editable.selectionControls, isNull);
  });

  testWidgets('content updates replace the controller text', (tester) async {
    await tester.pumpWidget(_frame(child: const SelectableText('first')));
    expect(_editable(tester).controller.text, 'first');
    await tester.pumpWidget(_frame(child: const SelectableText('second')));
    expect(_editable(tester).controller.text, 'second');
  });

  testWidgets('semantics expose the label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _frame(child: const SelectableText('hello', semanticsLabel: 'Greeting')),
    );
    expect(find.bySemanticsLabel('Greeting'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('RTL renders', (tester) async {
    await tester.pumpWidget(
      _frame(
        textDirection: TextDirection.rtl,
        child: const SelectableText('hello'),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
