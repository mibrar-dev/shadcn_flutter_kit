// Widget tests for `primitives/text_editing.dart`.
//
// Covers the widgets-only selection handles and the default Cut / Copy /
// Paste / Select-all context menu (including the read-only subset).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/primitives/text_editing/editable_text_style.dart';
import 'package:flutter_shadcn_kit/registry/primitives/text_editing/text_editing.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _ring = Color(0xFF123456);

Widget _frame({required Widget child}) {
  return ShadcnTheme(
    data: const ShadcnThemeData(),
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  test('selection controls compare by value, not identity', () {
    // EditableText disposes and recreates its selection overlay whenever
    // selectionControls !=. Fields build a fresh ShadcnSelectionControls per
    // build, so equal configs must compare equal — otherwise every rebuild
    // churns the overlay entries and a popover rebuild can dispose them
    // mid-build (zombie OverlayEntry crash on field tap).
    expect(ShadcnSelectionControls(), ShadcnSelectionControls());
    expect(
      ShadcnSelectionControls(color: _ring, handleSize: 18),
      ShadcnSelectionControls(color: _ring, handleSize: 18),
    );
    expect(
      ShadcnSelectionControls(color: _ring),
      isNot(ShadcnSelectionControls()),
    );
    expect(
      ShadcnSelectionControls(handleSize: 18),
      isNot(ShadcnSelectionControls(handleSize: 20)),
    );
    expect(
      ShadcnSelectionControls().hashCode,
      ShadcnSelectionControls().hashCode,
    );
  });

  test('handle size and anchor stay off the text line', () {
    final controls = ShadcnSelectionControls(handleSize: 20);
    expect(controls.getHandleSize(14), const Size(20, 20));
    expect(
      controls.getHandleAnchor(TextSelectionHandleType.left, 14),
      const Offset(10, 0),
    );
    expect(
      controls.getHandleAnchor(TextSelectionHandleType.right, 14),
      const Offset(10, 0),
    );
    expect(
      controls.getHandleAnchor(TextSelectionHandleType.collapsed, 14),
      const Offset(10, 20),
    );
  });

  testWidgets('buildHandle paints a CustomPaint of the handle size', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      _frame(
        child: Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
      ),
    );
    final controls = ShadcnSelectionControls(color: _ring, handleSize: 18);
    final handle = controls.buildHandle(
      context,
      TextSelectionHandleType.right,
      14,
    );
    await tester.pumpWidget(_frame(child: handle));
    final paint = tester.widget<CustomPaint>(find.byType(CustomPaint));
    expect(paint.painter, isNotNull);
    expect(paint.size, const Size(18, 18));
  });

  testWidgets('toolbar renders the four localized labels and fires actions', (
    tester,
  ) async {
    final pressed = <String>[];
    await tester.pumpWidget(
      _frame(
        child: ShadcnTextSelectionToolbar(
          anchorAbove: const Offset(100, 100),
          anchorBelow: const Offset(100, 140),
          buttonItems: <ContextMenuButtonItem>[
            ContextMenuButtonItem(
              type: ContextMenuButtonType.cut,
              onPressed: () => pressed.add('cut'),
            ),
            ContextMenuButtonItem(
              type: ContextMenuButtonType.copy,
              onPressed: () => pressed.add('copy'),
            ),
            ContextMenuButtonItem(
              type: ContextMenuButtonType.paste,
              onPressed: () => pressed.add('paste'),
            ),
            ContextMenuButtonItem(
              type: ContextMenuButtonType.selectAll,
              onPressed: () => pressed.add('selectAll'),
            ),
          ],
        ),
      ),
    );
    expect(find.text('Cut'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Paste'), findsOneWidget);
    expect(find.text('Select all'), findsOneWidget);

    await tester.tap(find.text('Copy'));
    await tester.tap(find.text('Select all'));
    expect(pressed, <String>['copy', 'selectAll']);
  });

  testWidgets('toolbar keeps custom labels', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: ShadcnTextSelectionToolbar(
          anchorAbove: const Offset(10, 10),
          anchorBelow: const Offset(10, 30),
          buttonItems: <ContextMenuButtonItem>[
            ContextMenuButtonItem(label: 'Look up', onPressed: () {}),
          ],
        ),
      ),
    );
    expect(find.text('Look up'), findsOneWidget);
  });

  testWidgets('default builder shows Cut/Copy/Select-all for a selection', (
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

    final controller = TextEditingController(text: 'hello world');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    late BuildContext context;
    await tester.pumpWidget(
      _frame(
        child: Builder(
          builder: (c) {
            context = c;
            return EditableText(
              controller: controller,
              focusNode: focusNode,
              selectionControls: ShadcnSelectionControls(),
              style: const TextStyle(color: Color(0xFF000000)),
              cursorColor: const Color(0xFF000000),
              backgroundCursorColor: const Color(0xFF000000),
            );
          },
        ),
      ),
    );
    focusNode.requestFocus();
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 5);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump();

    final state = tester.state<EditableTextState>(find.byType(EditableText));
    final menu = defaultShadcnContextMenuBuilder(context, state);
    await tester.pumpWidget(_frame(child: menu));
    expect(find.text('Cut'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Paste'), findsOneWidget);
    expect(find.text('Select all'), findsOneWidget);
  });

  testWidgets('default builder drops Cut/Paste for a read-only field', (
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

    final controller = TextEditingController(text: 'hello world');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    late BuildContext context;
    await tester.pumpWidget(
      _frame(
        child: Builder(
          builder: (c) {
            context = c;
            return EditableText(
              controller: controller,
              focusNode: focusNode,
              readOnly: true,
              selectionControls: ShadcnSelectionControls(),
              style: const TextStyle(color: Color(0xFF000000)),
              cursorColor: const Color(0xFF000000),
              backgroundCursorColor: const Color(0xFF000000),
            );
          },
        ),
      ),
    );
    controller.selection = const TextSelection(baseOffset: 0, extentOffset: 5);
    await tester.pump();
    await tester.pump();

    final state = tester.state<EditableTextState>(find.byType(EditableText));
    final menu = defaultShadcnContextMenuBuilder(context, state);
    await tester.pumpWidget(_frame(child: menu));
    expect(find.text('Cut'), findsNothing);
    expect(find.text('Paste'), findsNothing);
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Select all'), findsOneWidget);
  });

  testWidgets('default builder returns nothing for a collapsed selection', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'hello');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    late BuildContext context;
    await tester.pumpWidget(
      _frame(
        child: Builder(
          builder: (c) {
            context = c;
            return EditableText(
              controller: controller,
              focusNode: focusNode,
              selectionControls: ShadcnSelectionControls(),
              style: const TextStyle(color: Color(0xFF000000)),
              cursorColor: const Color(0xFF000000),
              backgroundCursorColor: const Color(0xFF000000),
            );
          },
        ),
      ),
    );
    final state = tester.state<EditableTextState>(find.byType(EditableText));
    final menu = defaultShadcnContextMenuBuilder(context, state);
    await tester.pumpWidget(_frame(child: menu));
    expect(find.text('Cut'), findsNothing);
    expect(find.text('Copy'), findsNothing);
    expect(find.text('Select all'), findsOneWidget);
  });

  group('resolveEditableTextStyle', () {
    Future<TextStyle> resolve(
      WidgetTester tester, {
      TextStyle? base,
      List<TextStyle?> overrides = const <TextStyle?>[],
      required Color color,
      TextStyle ambient = const TextStyle(),
    }) async {
      late TextStyle resolved;
      await tester.pumpWidget(
        ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: DefaultTextStyle(
              style: ambient,
              child: Builder(
                builder: (context) {
                  resolved = resolveEditableTextStyle(
                    context,
                    base: base,
                    overrides: overrides,
                    color: color,
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      return resolved;
    }

    testWidgets('falls back to the theme sans family', (tester) async {
      final style = await resolve(
        tester,
        base: const TextStyle(fontSize: 14),
        color: const Color(0xFF111111),
      );
      expect(
        style.fontFamily,
        const ShadcnThemeData().typography.sans.fontFamily,
      );
      expect(style.fontSize, 14);
      expect(style.color, const Color(0xFF111111));
    });

    testWidgets('ambient family wins over theme sans, override wins all', (
      tester,
    ) async {
      final ambient = await resolve(
        tester,
        base: const TextStyle(fontSize: 14),
        ambient: const TextStyle(fontFamily: 'Ambient'),
        color: const Color(0xFF111111),
      );
      expect(ambient.fontFamily, 'Ambient');

      final explicit = await resolve(
        tester,
        base: const TextStyle(fontSize: 14),
        overrides: const <TextStyle?>[TextStyle(fontFamily: 'Custom')],
        ambient: const TextStyle(fontFamily: 'Ambient'),
        color: const Color(0xFF111111),
      );
      expect(explicit.fontFamily, 'Custom');
    });
  });
}
