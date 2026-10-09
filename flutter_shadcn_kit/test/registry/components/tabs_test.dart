// Widget tests for the `tabs` component.
//
// Covers: token colours (light + dark), trigger metrics (h-9 = 36,
// horizontal padding 12, text-sm 14 w500), tap selection, the disabled
// strip, arrow-key roving navigation, controlled reselection, the TabPane
// (tap focus, drag reorder, static bar), all four theme legs, plus
// regressions for the reorder-mutates-input and index/data focus bugs.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/tabs/tabs.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const ShadcnColors _light = ShadcnColors.lightFallback;
const ShadcnColors _dark = ShadcnColors.darkFallback;

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ShadcnColors colors = _light,
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TabsTheme? scoped,
  TabPaneTheme? paneScoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<TabsTheme>(data: scoped, child: body);
  }
  if (paneScoped != null) {
    body = ComponentTheme<TabPaneTheme>(data: paneScoped, child: body);
  }
  return tester.pumpWidget(
    ShadcnTheme(
      data: ShadcnThemeData(colors: colors),
      child: ComponentThemes(
        themes: app,
        child: Directionality(
          textDirection: TextDirection.ltr,
          // Width only: the strip sizes itself vertically (h-9 triggers).
          child: Center(child: SizedBox(width: 360, child: body)),
        ),
      ),
    ),
  );
}

/// Pill fill of the trigger at [index]; null when unselected.
Color? _pillColor(WidgetTester tester, int index) =>
    (_pill(tester, index).decoration! as BoxDecoration).color;

/// The pill behind the trigger at [index]: the Container whose child is the
/// min-size box (Clickable paints its own undecorated containers around it).
Container _pill(WidgetTester tester, int index) {
  return tester
      .widgetList<Container>(
        find.descendant(
          of: find.byType(TabButton).at(index),
          matching: find.byType(Container),
        ),
      )
      .firstWhere((Container c) => c.child is ConstrainedBox);
}

TextStyle _labelStyle(WidgetTester tester, String text) =>
    DefaultTextStyle.of(tester.element(find.text(text))).style;

/// Controlled pill-strip harness.
class _Strip extends StatefulWidget {
  const _Strip({this.theme});

  final TabsTheme? theme;

  @override
  State<_Strip> createState() => _StripState();
}

class _StripState extends State<_Strip> {
  int index = 0;
  final List<int> seen = <int>[];

  @override
  Widget build(BuildContext context) {
    return Tabs(
      index: index,
      onChanged: (int i) {
        seen.add(i);
        setState(() => index = i);
      },
      theme: widget.theme,
      children: const <TabItem>[
        TabItem(child: Text('Account')),
        TabItem(child: Text('Password')),
      ],
    );
  }
}

/// Focuses the trigger at [index] (as tabbing into the strip would).
Future<void> _focusTab(WidgetTester tester, int index) async {
  final Finder detector = find.descendant(
    of: find.byType(TabButton).at(index),
    matching: find.byType(FocusableActionDetector),
  );
  tester
      .widget<FocusableActionDetector>(detector.first)
      .focusNode!
      .requestFocus();
  await tester.pump();
}

void main() {
  testWidgets('uses tokens in light mode', (WidgetTester tester) async {
    await _pump(tester, _Strip());
    expect(_pillColor(tester, 0), _light.background);
    expect(_pillColor(tester, 1), isNull);
    expect(_labelStyle(tester, 'Account').color, _light.foreground);
    expect(_labelStyle(tester, 'Password').color, _light.mutedForeground);
  });

  testWidgets('uses tokens in dark mode', (WidgetTester tester) async {
    await _pump(tester, _Strip(), colors: _dark);
    expect(_pillColor(tester, 0), _dark.background);
    expect(_labelStyle(tester, 'Account').color, _dark.foreground);
    expect(_labelStyle(tester, 'Password').color, _dark.mutedForeground);
  });

  testWidgets('strip is h-9, triggers h-30 with px-2 and text-sm labels', (
    WidgetTester tester,
  ) async {
    await _pump(tester, _Strip());
    // Strip content: 30px triggers + 3px padding top and bottom = 36.
    final Container strip = tester
        .widgetList<Container>(
          find.descendant(
            of: find.byType(Tabs),
            matching: find.byType(Container),
          ),
        )
        .firstWhere((Container c) => c.child is IntrinsicHeight);
    expect(tester.getSize(find.byWidget(strip)).height, 36);
    final EdgeInsets stripPadding = strip.padding! as EdgeInsets;
    expect(stripPadding.top, 3);
    expect(tester.getSize(find.byType(TabButton).first).height, 30);
    final EdgeInsets padding = _pill(tester, 0).padding! as EdgeInsets;
    expect(padding.left, 8);
    expect(padding.top, 0);
    final TextStyle label = _labelStyle(tester, 'Account');
    expect(label.fontSize, 14);
    expect(label.fontWeight, FontWeight.w500);
  });

  testWidgets('tap selects and the parent drives reselection', (
    WidgetTester tester,
  ) async {
    await _pump(tester, _Strip());
    await tester.tap(find.text('Password'));
    await tester.pump();
    expect(_pillColor(tester, 1), _light.background);
    expect(_pillColor(tester, 0), isNull);
  });

  testWidgets('null onChanged disables the whole strip', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const Tabs(
        index: 0,
        children: <TabItem>[
          TabItem(child: Text('Account')),
          TabItem(child: Text('Password')),
        ],
      ),
    );
    for (final Element e in find.byType(TabButton).evaluate()) {
      final List<double> found = tester
          .widgetList<Opacity>(
            find.descendant(
              of: find.byWidget(e.widget),
              matching: find.byType(Opacity),
            ),
          )
          .map((Opacity o) => o.opacity)
          .toList();
      expect(found, contains(0.5));
    }
    await tester.tap(find.text('Password'));
    await tester.pump();
    expect(_pillColor(tester, 0), _light.background);
  });

  testWidgets('arrow keys walk, activate and wrap', (
    WidgetTester tester,
  ) async {
    await _pump(tester, _Strip());
    // Focus the first trigger (as tabbing into the strip would), then walk.
    await _focusTab(tester, 0);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(_pillColor(tester, 1), _light.background);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(_pillColor(tester, 0), _light.background);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(_pillColor(tester, 1), _light.background);
  });

  testWidgets('arrow keys do nothing on a disabled strip', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      const Tabs(
        index: 0,
        children: <TabItem>[
          TabItem(child: Text('Account')),
          TabItem(child: Text('Password')),
        ],
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(_pillColor(tester, 0), _light.background);
  });

  testWidgets('theme legs resolve widget over tree over app over defaults', (
    WidgetTester tester,
  ) async {
    const TabsTheme app = TabsTheme(
      selectedColor: StateValue(rest: ThemedColor.ref(ColorRef.primary)),
    );
    const TabsTheme tree = TabsTheme(
      selectedColor: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
    );
    const TabsTheme widget = TabsTheme(
      selectedColor: StateValue(rest: ThemedColor.ref(ColorRef.destructive)),
    );
    await _pump(tester, _Strip(), app: const [app]);
    expect(_pillColor(tester, 0), _light.primary);
    await _pump(tester, _Strip(), app: const [app], scoped: tree);
    expect(_pillColor(tester, 0), _light.secondary);
    await _pump(
      tester,
      _Strip(theme: widget),
      app: const [app],
      scoped: tree,
    );
    expect(_pillColor(tester, 0), _light.destructive);
  });

  testWidgets('per-field merge keeps lower legs for unset fields', (
    WidgetTester tester,
  ) async {
    const TabsTheme tree = TabsTheme(
      selectedColor: StateValue(rest: ThemedColor.ref(ColorRef.secondary)),
    );
    const TabsTheme widget = TabsTheme(
      selectedLabelColor: StateValue(
        rest: ThemedColor.ref(ColorRef.destructive),
      ),
    );
    await _pump(tester, _Strip(theme: widget), scoped: tree);
    expect(_pillColor(tester, 0), _light.secondary);
    expect(_labelStyle(tester, 'Account').color, _light.destructive);
  });

  testWidgets('tab pane taps focus by index', (WidgetTester tester) async {
    final List<int> focused = <int>[];
    await _pump(
      tester,
      SizedBox(
        height: 200,
        child: TabPane<String>(
          items: const <TabPaneData<String>>[
            TabPaneData<String>('a.dart'),
            TabPaneData<String>('b.dart'),
          ],
          focused: 0,
          onFocused: focused.add,
          itemBuilder: (context, item, i) => Text(item.data),
          child: const Text('doc'),
        ),
      ),
    );
    await tester.tap(find.text('b.dart'));
    await tester.pump();
    expect(focused, <int>[1]);
  });

  testWidgets('tab pane drag reorders a copy, focused follows the tab', (
    WidgetTester tester,
  ) async {
    final List<int> focused = <int>[];
    final List<List<String>> sorts = <List<String>>[];
    final List<TabPaneData<String>> items = <TabPaneData<String>>[
      const TabPaneData<String>('a.dart'),
      const TabPaneData<String>('b.dart'),
      const TabPaneData<String>('c.dart'),
    ];
    await _pump(
      tester,
      SizedBox(
        height: 200,
        child: TabPane<String>(
          items: items,
          focused: 0,
          onFocused: focused.add,
          onSort: (List<TabPaneData<String>> next) =>
              sorts.add(<String>[for (final d in next) d.data]),
          itemBuilder: (context, item, i) => Text(item.data),
          child: const Text('doc'),
        ),
      ),
    );
    final Offset a = tester.getCenter(find.text('a.dart'));
    final Offset c = tester.getCenter(find.text('c.dart'));
    // Two moves: the slop-exceeding move starts the session (its delta is
    // consumed by the arena sweep when a tap recognizer competes), the
    // second move carries the translation the drop probe reads.
    final TestGesture gesture = await tester.startGesture(a);
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    await gesture.moveBy(Offset(c.dx - a.dx - 30, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump();
    expect(sorts, isNotEmpty);
    // Left-to-right drop lands before the tab under the pointer.
    expect(sorts.last, <String>['b.dart', 'a.dart', 'c.dart']);
    // The caller's list is never mutated in place.
    expect(
      <String>[for (final d in items) d.data],
      <String>['a.dart', 'b.dart', 'c.dart'],
    );
    // Focus follows the dragged tab to its new slot.
    expect(focused.last, 1);
  });

  testWidgets('tab pane without onSort renders a static bar', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      SizedBox(
        height: 200,
        child: TabPane<String>(
          items: const <TabPaneData<String>>[
            TabPaneData<String>('a.dart'),
            TabPaneData<String>('b.dart'),
          ],
          focused: 0,
          onFocused: (_) {},
          itemBuilder: (context, item, i) => Text(item.data),
          child: const Text('doc'),
        ),
      ),
    );
    final Offset a = tester.getCenter(find.text('a.dart'));
    final TestGesture gesture = await tester.startGesture(a);
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(80, 0));
    await tester.pump();
    await gesture.up();
    await tester.pump();
    expect(find.text('a.dart'), findsOneWidget);
    expect(find.text('b.dart'), findsOneWidget);
  });

  testWidgets('unmounting mid-drag ends the session without crashing', (
    WidgetTester tester,
  ) async {
    // Sortable dispose regression: disposing with an active drag session
    // used to call Data.maybeFind on the unmounted context (assert). The
    // session must end through the stored layer reference instead.
    await _pump(
      tester,
      SizedBox(
        height: 200,
        child: TabPane<String>(
          items: const <TabPaneData<String>>[
            TabPaneData<String>('a.dart'),
            TabPaneData<String>('b.dart'),
          ],
          focused: 0,
          onFocused: (_) {},
          onSort: (_) {},
          itemBuilder: (context, item, i) => Text(item.data),
          child: const Text('doc'),
        ),
      ),
    );
    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('a.dart')),
    );
    await tester.pump(const Duration(milliseconds: 20));
    await gesture.moveBy(const Offset(30, 0));
    await tester.pump();
    await _pump(tester, const SizedBox());
    await tester.pumpAndSettle();
    await gesture.up();
    await tester.pump();
    expect(find.byType(TabPane<String>), findsNothing);
  });

  testWidgets('tab pane unmounts without leaking its scroll controller', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      SizedBox(
        height: 200,
        child: TabPane<String>(
          items: const <TabPaneData<String>>[TabPaneData<String>('a.dart')],
          focused: 0,
          onFocused: (_) {},
          itemBuilder: (context, item, i) => Text(item.data),
          child: const Text('doc'),
        ),
      ),
    );
    await _pump(tester, const SizedBox());
    expect(find.byType(TabPane<String>), findsNothing);
  });
}
