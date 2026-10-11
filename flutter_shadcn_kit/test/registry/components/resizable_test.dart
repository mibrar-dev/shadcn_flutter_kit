// Widget tests for the `resizable` component.
//
// Covers: fixed + flexible extents, vertical layout, drag resizing, min/max
// clamping, collapse/expand, external controllers, the `ResizableHandle` grip,
// keyboard stepping (arrows + Home/End), the semantics label, token colours
// (light + dark) and all four theme-precedence legs.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/resizable/resizable.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const ShadcnColors _light = ShadcnColors.lightFallback;
const ShadcnColors _dark = ShadcnColors.darkFallback;

Future<void> _pump(
  WidgetTester tester,
  Widget group, {
  ShadcnThemeData? theme,
  ResizableTheme? app,
  ResizableTheme? scoped,
  double width = 300,
  double height = 100,
}) async {
  Widget body = Directionality(
    textDirection: TextDirection.ltr,
    child: Center(
      child: SizedBox(width: width, height: height, child: group),
    ),
  );
  if (scoped != null) {
    body = ComponentTheme<ResizableTheme>(data: scoped, child: body);
  }
  if (app != null) {
    body = ComponentThemes(themes: <ComponentThemeData>[app], child: body);
  }
  await tester.pumpWidget(
    ShadcnTheme(data: theme ?? const ShadcnThemeData(), child: body),
  );
}

ResizablePanelGroup _group({
  required ResizablePanel first,
  required ResizablePanel second,
  bool withHandle = false,
  Axis direction = Axis.horizontal,
  ResizableTheme? theme,
  ResizableHandle? handle,
}) {
  return ResizablePanelGroup(
    direction: direction,
    theme: theme,
    children: <Widget>[
      first,
      handle ?? ResizableHandle(withHandle: withHandle),
      second,
    ],
  );
}

Finder _pane(int index) => find.byType(ResizablePanel).at(index);

Finder _dragger() => find.byWidgetPredicate(
  (Widget w) => w is GestureDetector && w.onHorizontalDragStart != null,
);

Finder _grip() => find.descendant(
  of: find.byType(ResizableHandleView),
  matching: find.byType(Container),
);

Color _dividerColor(WidgetTester tester) =>
    tester.widget<ColoredBox>(find.byType(ColoredBox).first).color;

void main() {
  testWidgets('lays out a fixed and a flexible pane', (tester) async {
    await _pump(
      tester,
      _group(
        first: const ResizablePanel(defaultSize: 100, child: SizedBox.expand()),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    expect(tester.getSize(_pane(0)).width, 100);
    expect(tester.getSize(_pane(1)).width, 199);
  });

  testWidgets('lays out a vertical group', (tester) async {
    await _pump(
      tester,
      _group(
        direction: Axis.vertical,
        first: const ResizablePanel(defaultSize: 40, child: SizedBox.expand()),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    expect(tester.getSize(_pane(0)).height, 40);
    expect(tester.getSize(_pane(1)).height, 59);
  });

  testWidgets('dragging a divider resizes the adjacent panes', (tester) async {
    await _pump(
      tester,
      _group(
        first: const ResizablePanel(defaultSize: 100, child: SizedBox.expand()),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    await tester.drag(_dragger(), const Offset(40, 0));
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 140);
    expect(tester.getSize(_pane(1)).width, 159);
  });

  testWidgets('a drag respects min and max constraints', (tester) async {
    await _pump(
      tester,
      _group(
        first: const ResizablePanel(
          defaultSize: 100,
          minSize: 120,
          maxSize: 160,
          child: SizedBox.expand(),
        ),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    expect(tester.getSize(_pane(0)).width, 120);
    await tester.drag(_dragger(), const Offset(100, 0));
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 160);
  });

  testWidgets('a controller collapses and expands a pane', (tester) async {
    final ResizablePaneController controller = ResizablePaneController(
      size: 100,
    );
    addTearDown(controller.dispose);
    await _pump(
      tester,
      _group(
        first: ResizablePanel(
          controller: controller,
          collapsedSize: 20,
          child: const SizedBox.expand(),
        ),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    expect(tester.getSize(_pane(0)).width, 100);
    controller.collapse();
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 20);
    controller.expand();
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 100);
  });

  testWidgets('an external controller drives the pane size', (tester) async {
    final ResizablePaneController controller = ResizablePaneController(
      size: 100,
    );
    addTearDown(controller.dispose);
    await _pump(
      tester,
      _group(
        first: ResizablePanel(
          controller: controller,
          child: const SizedBox.expand(),
        ),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    controller.setSize(150);
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 150);
  });

  testWidgets('ResizableHandle(withHandle: true) draws the grip', (
    tester,
  ) async {
    await _pump(
      tester,
      _group(
        withHandle: true,
        first: const ResizablePanel(defaultSize: 100, child: SizedBox.expand()),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    expect(_grip(), findsOneWidget);

    await _pump(
      tester,
      _group(
        first: const ResizablePanel(defaultSize: 100, child: SizedBox.expand()),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    expect(_grip(), findsNothing);
    // Default handle: a 1px divider with a 10px hit area.
    expect(tester.getSize(find.byType(ResizableHandleView)).width, 10);
    expect(_dividerColor(tester), _light.border);
  });

  testWidgets('a focused handle steps with the arrow keys and Home/End', (
    tester,
  ) async {
    final FocusNode node = FocusNode(debugLabel: 'test-handle');
    addTearDown(node.dispose);
    await _pump(
      tester,
      _group(
        handle: ResizableHandle(focusNode: node),
        first: const ResizablePanel(
          defaultSize: 100,
          minSize: 60,
          maxSize: 180,
          child: SizedBox.expand(),
        ),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    node.requestFocus();
    await tester.pump();
    expect(node.hasFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 110);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 90);
    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 60);
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(tester.getSize(_pane(0)).width, 180);
  });

  testWidgets('the handle exposes the localized semantics label', (
    tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await _pump(
      tester,
      _group(
        first: const ResizablePanel(defaultSize: 100, child: SizedBox.expand()),
        second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
      ),
    );
    expect(find.bySemanticsLabel('Resize handle'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('uses the border token for the divider in light and dark', (
    tester,
  ) async {
    Widget group() => _group(
      first: const ResizablePanel(defaultSize: 100, child: SizedBox.expand()),
      second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
    );
    await _pump(tester, group());
    expect(_dividerColor(tester), _light.border);
    await _pump(tester, group(), theme: const ShadcnThemeData(colors: _dark));
    expect(_dividerColor(tester), _dark.border);
  });

  testWidgets('theme precedence: widget > scoped > app > defaults', (
    tester,
  ) async {
    const ResizableTheme app = ResizableTheme(
      handleColor: StateValue(rest: ThemedColor.value(Color(0xFFFF0000))),
    );
    const ResizableTheme scoped = ResizableTheme(
      handleColor: StateValue(rest: ThemedColor.value(Color(0xFF00FF00))),
    );
    const ResizableTheme widget = ResizableTheme(
      handleColor: StateValue(rest: ThemedColor.value(Color(0xFF0000FF))),
    );
    Widget group(ResizableTheme? theme) => _group(
      theme: theme,
      first: const ResizablePanel(defaultSize: 100, child: SizedBox.expand()),
      second: const ResizablePanel(flex: 1, child: SizedBox.expand()),
    );

    await _pump(tester, group(null), app: app);
    expect(_dividerColor(tester), const Color(0xFFFF0000));
    await _pump(tester, group(null), app: app, scoped: scoped);
    expect(_dividerColor(tester), const Color(0xFF00FF00));
    await _pump(tester, group(widget), app: app, scoped: scoped);
    expect(_dividerColor(tester), const Color(0xFF0000FF));
  });
}
