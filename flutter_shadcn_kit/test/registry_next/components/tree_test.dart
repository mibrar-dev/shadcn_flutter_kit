// Widget and unit tests for the `tree` component.
//
// Covers: the immutable node ops, rendering and expansion, selection
// reporting (single + recursive), modifier-driven multi-select (Ctrl/Cmd-click
// toggle, Shift-click range both directions across expanded children,
// Shift+Arrow range extension, Ctrl/Cmd+A), the row context, the themed row
// (selection paint, guides, toggle, keyboard collapse/expand), theme
// precedence for all four legs, dark tokens and a regression test per fixed
// old bug.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/tree/tree.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry_next/foundation/icons/lucide_icons.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

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
        child: Center(child: child),
      ),
    ),
  );
}

List<TreeNode<String>> _nodes() => <TreeNode<String>>[
  TreeItem<String>(
    data: 'Documents',
    expanded: true,
    children: <TreeNode<String>>[
      TreeItem<String>(data: 'a.txt'),
      TreeItem<String>(
        data: 'archive',
        children: <TreeNode<String>>[TreeItem<String>(data: 'old.zip')],
      ),
    ],
  ),
  TreeItem<String>(data: 'Pictures'),
];

Widget _tree(
  List<TreeNode<String>> nodes, {
  TreeBranchLine? branchLine,
  TreeNodeSelectionChanged<String>? onSelectionChanged,
  TreeNodeExpandedChanged<String>? onExpandedChanged,
  bool recursiveSelection = true,
  bool allowMultiSelect = true,
  TreeTheme? theme,
}) {
  return Tree<String>(
    nodes: nodes,
    branchLine: branchLine,
    recursiveSelection: recursiveSelection,
    allowMultiSelect: allowMultiSelect,
    onSelectionChanged: onSelectionChanged,
    onExpandedChanged: onExpandedChanged,
    theme: theme,
    builder: (BuildContext context, TreeItem<String> item) =>
        TreeRow(child: Text(item.data)),
  );
}

/// One reported selection: the node labels plus the two report flags.
class _Report {
  const _Report(this.nodes, this.multi, this.selected);

  final List<String> nodes;
  final bool multi;
  final bool selected;

  @override
  String toString() => '$nodes multi:$multi selected:$selected';
}

/// Collects what `onSelectionChanged` reports.
class _Recorder {
  final List<_Report> reports = <_Report>[];

  void call(List<TreeNode<String>> nodes, bool multi, bool selected) {
    reports.add(
      _Report(
        <String>[
          for (final TreeNode<String> node in nodes)
            if (node is TreeItem<String>) node.data,
        ],
        multi,
        selected,
      ),
    );
  }

  /// The labels of the last reported selection.
  List<String> get last => reports.last.nodes;

  /// The flags of the last reported selection.
  _Report get report => reports.last;
}

/// A flat list of leaves so a range never crosses a collapse boundary.
List<TreeNode<String>> _flat(int count) => <TreeNode<String>>[
  for (int i = 0; i < count; i++) TreeItem<String>(data: 'row$i'),
];

/// Presses a modifier down, runs [action], and releases it.
///
/// The tree reads `HardwareKeyboard` at event time, so holding a modifier is
/// expressed purely as its key state.
Future<void> _withModifier(
  WidgetTester tester,
  LogicalKeyboardKey modifier,
  Future<void> Function() action,
) async {
  await tester.sendKeyDownEvent(modifier);
  try {
    await action();
  } finally {
    await tester.sendKeyUpEvent(modifier);
  }
}

/// Holds <kbd>Shift</kbd> for the whole test body.
Future<void> _shift(WidgetTester tester, Future<void> Function() action) =>
    _withModifier(tester, LogicalKeyboardKey.shiftLeft, action);

/// Holds <kbd>Control</kbd> for the whole test body.
Future<void> _control(WidgetTester tester, Future<void> Function() action) =>
    _withModifier(tester, LogicalKeyboardKey.controlLeft, action);

BoxDecoration? _rowDecoration(WidgetTester tester, int index) {
  final decorations = tester
      .widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(TreeRow),
          matching: find.byType(DecoratedBox),
        ),
      )
      .map((box) => box.decoration)
      .whereType<BoxDecoration>()
      .toList();
  return decorations[index];
}

void main() {
  const ShadcnColors colors = ShadcnColors.lightFallback;

  group('immutable node ops', () {
    test('map only rebuilds when something changed', () {
      final List<TreeNode<String>> nodes = _nodes();
      expect(nodes.updateNodes((node) => null), same(nodes));
      expect(nodes.expandAll().length, nodes.length);
      expect(nodes.expandAll().every((node) => node.expanded), isTrue);
      expect(
        nodes.collapseAll().every((TreeNode<String> node) => !node.expanded),
        isTrue,
      );
    });

    test('expand/collapse target one node', () {
      final List<TreeNode<String>> nodes = _nodes();
      final TreeNode<String> first = nodes.first;
      final List<TreeNode<String>> collapsed = nodes.collapseNode(first);
      expect(collapsed.first.expanded, isFalse);
      expect(collapsed, isNot(same(nodes)));
      expect(collapsed.expandNode(collapsed.first).first.expanded, isTrue);
      // The original list is untouched.
      expect(nodes.first.expanded, isTrue);
    });

    test('setSelectedNodes selects exactly the given nodes', () {
      final List<TreeNode<String>> nodes = _nodes();
      final TreeNode<String> picture = nodes.last;
      final List<TreeNode<String>> selected = nodes.setSelectedNodes(
        <TreeNode<String>>[picture],
      );
      expect(
        selected.selectedNodes.map((node) => (node as TreeItem<String>).data),
        <String>['Pictures'],
      );
      expect(selected.selectedItems, <String>['Pictures']);
    });

    test('updateState and updateChildren keep the other flags', () {
      const TreeItem<String> item = TreeItem<String>(data: 'a');
      final TreeItem<String> selected = item.updateState(selected: true);
      expect(selected.data, 'a');
      expect(selected.selected, isTrue);
      expect(selected.children, isEmpty);
      final TreeItem<String> withChild = selected.updateChildren(
        <TreeNode<String>>[const TreeItem<String>(data: 'b')],
      );
      expect(withChild.selected, isTrue);
      expect(withChild.leaf, isFalse);
    });
  });

  testWidgets('renders the visible rows only', (tester) async {
    await tester.pumpWidget(_frame(child: _tree(_nodes())));
    expect(find.text('Documents'), findsOneWidget);
    expect(find.text('a.txt'), findsOneWidget);
    expect(find.text('archive'), findsOneWidget);
    // 'archive' is collapsed and 'Pictures' has no children.
    expect(find.text('old.zip'), findsNothing);
    expect(find.byType(TreeRow), findsNWidgets(4));
  });

  testWidgets('the toggle reports the new expanded state', (tester) async {
    final List<String> events = <String>[];
    void record(TreeNode<String> node, bool expanded) =>
        events.add('${node is TreeItem<String> ? node.data : ''}:$expanded');
    await tester.pumpWidget(
      _frame(child: _tree(_nodes(), onExpandedChanged: record)),
    );
    await tester.tap(
      find
          .descendant(
            of: find.byType(TreeRow).first,
            matching: find.byIcon(LucideIcons.chevronRight),
          )
          .first,
    );
    await tester.pump();
    expect(events, <String>['Documents:false']);
  });

  testWidgets('tapping a row reports selection with the subtree', (
    tester,
  ) async {
    final List<List<String>> reported = <List<String>>[];
    await tester.pumpWidget(
      _frame(
        child: _tree(
          _nodes(),
          onSelectionChanged:
              (List<TreeNode<String>> nodes, bool multi, bool selected) =>
                  reported.add(<String>[
                    for (final TreeNode<String> node in nodes)
                      if (node is TreeItem<String>) node.data,
                    ...<String>['multi:$multi', 'selected:$selected'],
                  ]),
        ),
      ),
    );
    await tester.tap(find.text('archive'));
    await tester.pump();
    expect(reported.single, <String>[
      'archive',
      'old.zip',
      'multi:true',
      'selected:true',
    ]);
  });

  testWidgets('recursiveSelection false reports the node alone', (
    tester,
  ) async {
    final List<List<String>> reported = <List<String>>[];
    await tester.pumpWidget(
      _frame(
        child: _tree(
          _nodes(),
          recursiveSelection: false,
          onSelectionChanged:
              (List<TreeNode<String>> nodes, bool multi, bool selected) =>
                  reported.add(<String>[
                    for (final TreeNode<String> node in nodes)
                      if (node is TreeItem<String>) node.data,
                  ]),
        ),
      ),
    );
    await tester.tap(find.text('archive'));
    await tester.pump();
    expect(reported.single, <String>['archive']);
  });

  testWidgets('keyboard: left and right collapse and expand', (tester) async {
    final List<String> events = <String>[];
    void record(TreeNode<String> node, bool expanded) =>
        events.add('${node is TreeItem<String> ? node.data : ''}:$expanded');
    await tester.pumpWidget(
      _frame(child: _tree(_nodes(), onExpandedChanged: record)),
    );
    Data.maybeOf<TreeRowContext>(
      tester.element(find.text('archive')),
    )!.focusNode!.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
    expect(events, <String>['archive:true']);
    events.clear();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(events, <String>['archive:false']);
  });

  testWidgets('a run of selected rows is rounded as a group', (tester) async {
    final List<TreeNode<String>> nodes = _nodes().updateNodes(
      (TreeNode<String> node) => node.updateState(selected: true),
    );
    await tester.pumpWidget(_frame(child: _tree(nodes)));
    final List<TreeSelectionPosition> positions = <TreeSelectionPosition>[
      for (final Element row in find.byType(TreeRow).evaluate())
        Data.maybeOf<TreeRowContext>(row)!.selectionPosition!,
    ];
    expect(positions, <TreeSelectionPosition>[
      TreeSelectionPosition.start,
      TreeSelectionPosition.middle,
      TreeSelectionPosition.middle,
      TreeSelectionPosition.end,
    ]);
  });

  testWidgets('a single selected row is rounded on every corner', (
    tester,
  ) async {
    final List<TreeNode<String>> nodes = <TreeNode<String>>[
      const TreeItem<String>(data: 'a', selected: true),
      const TreeItem<String>(data: 'b'),
    ];
    await tester.pumpWidget(_frame(child: _tree(nodes)));
    final TreeSelectionPosition position = Data.maybeOf<TreeRowContext>(
      tester.element(find.byType(TreeRow).first),
    )!.selectionPosition!;
    expect(position, TreeSelectionPosition.single);
  });

  testWidgets('selection uses the primary token at 5%', (tester) async {
    final List<TreeNode<String>> nodes = <TreeNode<String>>[
      const TreeItem<String>(data: 'a', selected: true),
      const TreeItem<String>(data: 'b'),
    ];
    await tester.pumpWidget(_frame(child: _tree(nodes)));
    final Color expected = colors.primary.withValues(
      alpha: colors.primary.a * 0.05,
    );
    expect(_rowDecoration(tester, 0)?.color, expected);
    // An unselected row paints nothing.
    expect(_rowDecoration(tester, 1)?.color, isNull);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const red = Color(0xFFFF0000);
    const green = Color(0xFF00FF00);
    const blue = Color(0xFF0000FF);
    final List<TreeNode<String>> nodes = <TreeNode<String>>[
      const TreeItem<String>(data: 'a', selected: true),
    ];

    BoxDecoration? fill() => _rowDecoration(tester, 0);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TreeTheme(selectedBackground: ThemedColor.value(red)),
        ],
        child: _tree(nodes),
      ),
    );
    await tester.pumpAndSettle();
    expect(fill()?.color, red);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TreeTheme(selectedBackground: ThemedColor.value(red)),
        ],
        child: ComponentTheme<TreeTheme>(
          data: const TreeTheme(selectedBackground: ThemedColor.value(green)),
          child: _tree(nodes),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(fill()?.color, green);

    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TreeTheme(selectedBackground: ThemedColor.value(red)),
        ],
        child: ComponentTheme<TreeTheme>(
          data: const TreeTheme(selectedBackground: ThemedColor.value(green)),
          child: _tree(
            nodes,
            theme: const TreeTheme(selectedBackground: ThemedColor.value(blue)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(fill()?.color, blue);
  });

  testWidgets('partial legs merge per field', (tester) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          TreeTheme(
            selectedBackground: ThemedColor.value(Color(0xFFFF0000)),
            indentWidth: 30,
          ),
        ],
        child: const ComponentTheme<TreeTheme>(
          data: TreeTheme(itemGap: 20),
          child: SizedBox.shrink(),
        ),
      ),
    );
    final TreeTheme resolved = resolveComponentStyle<TreeTheme, TreeTheme>(
      tester.element(find.byType(SizedBox)),
      widget: null,
      select: (TreeTheme t) => t,
      defaults: treeDefaults,
    );
    expect(
      resolved.selectedBackground,
      const ThemedColor.value(Color(0xFFFF0000)),
    );
    expect(resolved.itemGap, 20);
    expect(resolved.indentWidth, 30);
  });

  testWidgets('dark tokens drive the selection fill and the guides', (
    tester,
  ) async {
    const ShadcnThemeData dark = ShadcnThemeData(
      colors: ShadcnColors.darkFallback,
    );
    await tester.pumpWidget(
      _frame(
        data: dark,
        child: _tree(<TreeNode<String>>[
          TreeItem<String>(
            data: 'root',
            expanded: true,
            selected: true,
            children: <TreeNode<String>>[const TreeItem<String>(data: 'leaf')],
          ),
        ]),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      _rowDecoration(tester, 0)?.color,
      dark.colors.primary.withValues(alpha: dark.colors.primary.a * 0.05),
    );
    // The guide of the 'root' level is painted on the nested 'leaf' row.
    final ColoredBox guides = tester.widget<ColoredBox>(
      find
          .descendant(
            of: find.byType(TreeRow).last,
            matching: find.byType(ColoredBox),
          )
          .first,
    );
    expect(guides.color, dark.colors.border);
  });

  testWidgets('branch lines: none draws no guide', (tester) async {
    await tester.pumpWidget(
      _frame(child: _tree(_nodes(), branchLine: TreeBranchLine.none)),
    );
    expect(
      find.descendant(
        of: find.byType(TreeRow),
        matching: find.byType(ColoredBox),
      ),
      findsNothing,
    );
  });

  testWidgets('branch lines: path draws a guide per level', (tester) async {
    await tester.pumpWidget(
      _frame(child: _tree(_nodes(), branchLine: TreeBranchLine.path)),
    );
    // 'a.txt' sits at level 2: one guide column.
    expect(
      find
          .descendant(
            of: find.ancestor(
              of: find.text('a.txt'),
              matching: find.byType(TreeRow),
            ),
            matching: find.byType(ColoredBox),
          )
          .evaluate()
          .length,
      greaterThanOrEqualTo(1),
    );
  });

  testWidgets('a TreeRow outside a tree renders its content inertly', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const TreeRow(child: Text('standalone'))),
    );
    expect(find.text('standalone'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('indentation steps by indentWidth (regression)', (tester) async {
    await tester.pumpWidget(
      _frame(
        child: _tree(<TreeNode<String>>[
          TreeItem<String>(
            data: 'root',
            expanded: true,
            children: <TreeNode<String>>[TreeItem<String>(data: 'leaf')],
          ),
        ]),
      ),
    );
    final double root = tester.getTopLeft(find.text('root')).dx;
    final double leaf = tester.getTopLeft(find.text('leaf')).dx;
    expect(leaf - root, 16);
  });

  group('selection range maths', () {
    test('the span is ascending whichever end the anchor is', () {
      expect(
        selectionRange(anchor: 1, target: 3, length: 5),
        const TreeSelectionRange(1, 3),
      );
      expect(
        selectionRange(anchor: 3, target: 1, length: 5),
        const TreeSelectionRange(1, 3),
      );
      expect(
        selectionRange(anchor: 2, target: 2, length: 5),
        const TreeSelectionRange(2, 2),
      );
    });

    test('a stale anchor is clamped, never inverted', () {
      // The tree collapsed under the anchor: the old index is past the end.
      expect(
        selectionRange(anchor: 9, target: 1, length: 3),
        const TreeSelectionRange(1, 2),
      );
      expect(
        selectionRange(anchor: -4, target: 1, length: 3),
        const TreeSelectionRange(0, 1),
      );
      expect(selectionRange(anchor: 0, target: 0, length: 0).isEmpty, isTrue);
    });

    test('the span reports its length and membership', () {
      const TreeSelectionRange range = TreeSelectionRange(1, 3);
      expect(range.length, 3);
      expect(range.contains(2), isTrue);
      expect(range.contains(0), isFalse);
      expect(TreeSelectionRange.empty.length, 0);
      expect(TreeSelectionRange.empty.contains(0), isFalse);
    });

    test('runs of selected rows are found in one pass', () {
      expect(
        selectedRuns(<bool>[false, true, true, false, true]),
        <TreeSelectionRange>[
          const TreeSelectionRange(1, 2),
          const TreeSelectionRange(4, 4),
        ],
      );
      expect(selectedRuns(<bool>[true, true]), <TreeSelectionRange>[
        const TreeSelectionRange(0, 1),
      ]);
      expect(selectedRuns(<bool>[false, false]), isEmpty);
      expect(selectedRuns(<bool>[]), isEmpty);
    });

    test('modifiers resolve to a gesture, shift winning over ctrl', () {
      expect(
        resolveTreeSelectionGesture(shiftPressed: false, multiPressed: false),
        TreeSelectionGesture.plain,
      );
      expect(
        resolveTreeSelectionGesture(shiftPressed: false, multiPressed: true),
        TreeSelectionGesture.toggle,
      );
      expect(
        resolveTreeSelectionGesture(shiftPressed: true, multiPressed: true),
        TreeSelectionGesture.range,
      );
      expect(
        resolveTreeSelectionIntent(selectAll: true, shiftPressed: true),
        TreeSelectionGesture.all,
      );
      expect(
        resolveTreeSelectionIntent(selectAll: false, shiftPressed: true),
        TreeSelectionGesture.range,
      );
    });

    test('toggleSelectedNode flips one node and keeps the rest', () {
      final List<TreeNode<String>> nodes = _nodes();
      final TreeNode<String> a =
          (nodes.first as TreeItem<String>).children.first;
      final List<TreeNode<String>> selected = nodes.setSelectedNodes(
        <TreeNode<String>>[a],
      );
      // A TreeItem compares by value, so the target has to be the instance from
      // the list the caller just produced, not the pre-update one.
      final TreeNode<String> current =
          (selected.first as TreeItem<String>).children.first;
      expect(selected.toggleSelectedNode(current).selectedItems, isEmpty);
      // Toggling a second node leaves the first one selected.
      expect(selected.toggleSelectedNode(selected.last).selectedItems, <String>[
        'a.txt',
        'Pictures',
      ]);
    });
  });

  group('multi-select gestures', () {
    testWidgets('ctrl+click toggles one row and keeps the rest', (
      tester,
    ) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(3), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('row0'));
      await tester.pump();
      expect(recorder.last, <String>['row0']);
      await _control(tester, () async {
        await tester.tap(find.text('row2'));
        await tester.pump();
      });
      // A toggle reports only the row it toggled; the app merges it.
      expect(recorder.last, <String>['row2']);
      expect(recorder.report.multi, isTrue);
      expect(recorder.report.selected, isTrue);
    });

    testWidgets('a plain click after a ctrl+click still replaces', (
      tester,
    ) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(3), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('row0'));
      await tester.pump();
      await _control(tester, () async {
        await tester.tap(find.text('row2'));
        await tester.pump();
      });
      await tester.tap(find.text('row1'));
      await tester.pump();
      // Plain: one row, and the anchor moved to it.
      expect(recorder.last, <String>['row1']);
      await _shift(tester, () async {
        await tester.tap(find.text('row0'));
        await tester.pump();
      });
      expect(recorder.last, <String>['row0', 'row1']);
    });

    testWidgets('shift+click selects the range forwards', (tester) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(4), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('row1'));
      await tester.pump();
      await _shift(tester, () async {
        await tester.tap(find.text('row3'));
        await tester.pump();
      });
      expect(recorder.last, <String>['row1', 'row2', 'row3']);
      expect(recorder.report.multi, isTrue);
    });

    testWidgets('shift+click selects the range backwards', (tester) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(4), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('row3'));
      await tester.pump();
      await _shift(tester, () async {
        await tester.tap(find.text('row1'));
        await tester.pump();
      });
      expect(recorder.last, <String>['row1', 'row2', 'row3']);
    });

    testWidgets('the range crosses expanded children', (tester) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_nodes(), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('Documents'));
      await tester.pump();
      await _shift(tester, () async {
        await tester.tap(find.text('Pictures'));
        await tester.pump();
      });
      // Rows are Documents, a.txt, archive, Pictures.
      expect(recorder.last, <String>[
        'Documents',
        'a.txt',
        'archive',
        'Pictures',
      ]);
    });

    testWidgets('a shift+click keeps the anchor, so it grows and shrinks', (
      tester,
    ) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(5), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('row1'));
      await tester.pump();
      await _shift(tester, () async {
        await tester.tap(find.text('row3'));
        await tester.pump();
      });
      expect(recorder.last, <String>['row1', 'row2', 'row3']);
      // The anchor is still row1, so the second shift+click shrinks.
      await _shift(tester, () async {
        await tester.tap(find.text('row2'));
        await tester.pump();
      });
      expect(recorder.last, <String>['row1', 'row2']);
    });

    testWidgets('shift+arrow extends the range and moves the focus', (
      tester,
    ) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(4), onSelectionChanged: recorder.call)),
      );
      Data.maybeOf<TreeRowContext>(
        tester.element(find.text('row0')),
      )!.focusNode!.requestFocus();
      await tester.pump();
      await tester.tap(find.text('row0'));
      await tester.pump();
      await _shift(tester, () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(recorder.last, <String>['row0', 'row1']);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(recorder.last, <String>['row0', 'row1', 'row2']);
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        expect(recorder.last, <String>['row0', 'row1']);
      });
      // The focus followed the range instead of the default traversal, so it
      // ended on the row the range stopped at.
      final List<FocusNode> nodes = <FocusNode>[
        for (final Element row in find.byType(TreeRow).evaluate())
          Data.maybeOf<TreeRowContext>(row)!.focusNode!,
      ];
      expect(nodes[1].hasFocus, isTrue);
    });

    testWidgets('ctrl+A selects every visible row', (tester) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_nodes(), onSelectionChanged: recorder.call)),
      );
      Data.maybeOf<TreeRowContext>(
        tester.element(find.text('Documents')),
      )!.focusNode!.requestFocus();
      await tester.pump();
      await _control(tester, () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
        await tester.pump();
      });
      expect(recorder.last, <String>[
        'Documents',
        'a.txt',
        'archive',
        'Pictures',
      ]);
      expect(recorder.report.selected, isTrue);
    });

    testWidgets('single-select mode ignores the modifiers', (tester) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(
          child: _tree(
            _flat(4),
            allowMultiSelect: false,
            onSelectionChanged: recorder.call,
          ),
        ),
      );
      await tester.tap(find.text('row1'));
      await tester.pump();
      await _shift(tester, () async {
        await tester.tap(find.text('row3'));
        await tester.pump();
      });
      expect(recorder.last, <String>['row3']);
      expect(recorder.report.multi, isFalse);
      // The keyboard chords are inert too.
      Data.maybeOf<TreeRowContext>(
        tester.element(find.text('row3')),
      )!.focusNode!.requestFocus();
      await tester.pump();
      await _control(tester, () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
        await tester.pump();
      });
      expect(recorder.reports.length, 2);
    });

    testWidgets('shift+arrow is inert when nothing is focused', (tester) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(3), onSelectionChanged: recorder.call)),
      );
      await _shift(tester, () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
      });
      expect(recorder.reports, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('shift+arrow past the last row stops (regression)', (
      tester,
    ) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(2), onSelectionChanged: recorder.call)),
      );
      Data.maybeOf<TreeRowContext>(
        tester.element(find.text('row1')),
      )!.focusNode!.requestFocus();
      await tester.pump();
      await tester.tap(find.text('row1'));
      await tester.pump();
      await _shift(tester, () async {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
      });
      expect(recorder.reports.length, 2);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a focus change while Shift is held cannot stick (regression)', (
      tester,
    ) async {
      // The old tree stored `_rangeMultiSelect` and relied on the key-up
      // handler to clear it, so moving the focus with Shift held left range
      // mode on for the next plain click. The modifiers are read at event
      // time, so a focus move between the two clicks changes nothing.
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_flat(4), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('row0'));
      await tester.pump();
      await _shift(tester, () async {
        // Shift+click to seat a range, then move the focus while still held.
        await tester.tap(find.text('row3'));
        await tester.pump();
        Data.maybeOf<TreeRowContext>(
          tester.element(find.text('row3')),
        )!.focusNode!.requestFocus();
        await tester.pump();
        Data.maybeOf<TreeRowContext>(
          tester.element(find.text('row1')),
        )!.focusNode!.requestFocus();
        await tester.pump();
      });
      // Shift is released; the next plain click is a plain click, not a range.
      await tester.tap(find.text('row2'));
      await tester.pump();
      expect(recorder.last, <String>['row2']);
      // And nothing was reported while the focus moved with Shift held.
      expect(recorder.reports.length, 3);
    });

    testWidgets('a stale anchor is clamped into range', (tester) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_nodes(), onSelectionChanged: recorder.call)),
      );
      // Anchor on 'Pictures' (index 3 of 4 visible rows).
      await tester.tap(find.text('Pictures'));
      await tester.pump();
      // Collapse 'Documents': only 2 rows remain, so the anchor index is stale.
      await tester.pumpWidget(
        _frame(
          child: _tree(
            _nodes().collapseAll(),
            onSelectionChanged: recorder.call,
          ),
        ),
      );
      await tester.pump();
      await _shift(tester, () async {
        await tester.tap(find.text('Documents'));
        await tester.pump();
      });
      // Anchor 3 clamps to the last visible row (1), so the span is 0..1.
      expect(recorder.last, <String>['Documents', 'Pictures']);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a stale anchor past the end never inverts (regression)', (
      tester,
    ) async {
      final _Recorder recorder = _Recorder();
      await tester.pumpWidget(
        _frame(child: _tree(_nodes(), onSelectionChanged: recorder.call)),
      );
      await tester.tap(find.text('Pictures'));
      await tester.pump();
      await tester.pumpWidget(
        _frame(
          child: _tree(
            _nodes().collapseAll(),
            onSelectionChanged: recorder.call,
          ),
        ),
      );
      await tester.pump();
      await _shift(tester, () async {
        await tester.tap(find.text('Pictures'));
        await tester.pump();
      });
      // The anchor clamps onto the same row: a one-row span, not an inversion.
      expect(recorder.last, <String>['Pictures']);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('deep hierarchy keeps every level (regression)', (tester) async {
    TreeNode<String> node = const TreeItem<String>(data: 'leaf');
    for (int i = 0; i < 12; i++) {
      node = TreeItem<String>(
        data: 'level $i',
        expanded: true,
        children: <TreeNode<String>>[node],
      );
    }
    await tester.pumpWidget(_frame(child: _tree(<TreeNode<String>>[node])));
    expect(find.byType(TreeRow), findsNWidgets(13));
  });
}
