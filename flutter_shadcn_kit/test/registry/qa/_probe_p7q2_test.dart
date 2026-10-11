// P7-Q2 probe: edge cases that must not throw. Not a deliverable; it finds bugs.
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/pagination/pagination.dart';
import 'package:flutter_shadcn_kit/registry/components/progress/progress.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollbar/scrollbar.dart';
import 'package:flutter_shadcn_kit/registry/components/star_rating/star_rating.dart';
import 'package:flutter_shadcn_kit/registry/components/steps/steps.dart';
import 'package:flutter_shadcn_kit/registry/components/stepper/stepper.dart';
import 'package:flutter_shadcn_kit/registry/components/switcher/switcher.dart';
import 'package:flutter_shadcn_kit/registry/components/table/table.dart';
import 'package:flutter_shadcn_kit/registry/components/tabs/tabs.dart';
import 'package:flutter_shadcn_kit/registry/components/timeline/timeline.dart';
import 'package:flutter_shadcn_kit/registry/components/tracker/tracker.dart';
import 'package:flutter_shadcn_kit/registry/components/tree/tree.dart';
import 'package:flutter_shadcn_kit/registry/components/window/window.dart';
import 'package:flutter_shadcn_kit/registry/components/pinned_sheet/pinned_sheet.dart';
import 'package:flutter_shadcn_kit/registry/components/resizable/resizable.dart';
import 'package:flutter_shadcn_kit/registry/components/toast/toast.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget frame(Widget child) => ShadcnTheme(
  data: const ShadcnThemeData(),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: Center(child: child),
  ),
);

Future<void> pump(WidgetTester t, Widget w) async {
  await t.pumpWidget(frame(w));
  await t.pump();
  await t.pump(const Duration(milliseconds: 16));
  expect(t.takeException(), isNull);
}

void main() {
  testWidgets('progress out-of-range values', (t) async {
    await pump(t, const Progress(value: 1.4));
    await pump(t, const Progress(value: -0.4));
    await pump(t, const Progress(value: 0));
    await pump(t, const Progress(value: 1));
  });

  testWidgets('pagination degenerate totals', (t) async {
    await pump(t, Pagination(page: 0, totalPages: 0, onPageChanged: (_) {}));
    await pump(t, Pagination(page: 1, totalPages: 1, onPageChanged: (_) {}));
    await pump(t, Pagination(page: 99, totalPages: 5, onPageChanged: (_) {}));
    await pump(t, Pagination(page: 3, totalPages: 2, onPageChanged: (_) {}));
  });

  testWidgets('scrollbar with no overflow', (t) async {
    final ScrollController controller = ScrollController();
    addTearDown(controller.dispose);
    await pump(
      t,
      SizedBox(
        width: 300,
        height: 120,
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          child: ListView.builder(
            controller: controller,
            itemCount: 30,
            itemBuilder: (context, index) => Text('row $index'),
          ),
        ),
      ),
    );
  });

  testWidgets('star_rating zero and max', (t) async {
    await pump(t, const StarRating(value: 0));
    await pump(t, const StarRating(value: 5));
  });

  testWidgets('steps with no steps', (t) async {
    await pump(t, const Steps(children: <Widget>[]));
  });

  testWidgets('switcher index out of range', (t) async {
    await pump(
      t,
      Switcher(
        index: 7,
        direction: AxisDirection.right,
        children: const <Widget>[Text('a'), Text('b')],
      ),
    );
  });

  testWidgets('table column span zero', (t) async {
    await pump(
      t,
      const ShadcnTable(
        rows: <ShadcnTableRow>[
          ShadcnTableRow(
            cells: <ShadcnTableCell>[
              ShadcnTableCell(columnSpan: 0, child: Text('x')),
            ],
          ),
        ],
      ),
    );
  });

  testWidgets('tabs shrink child list (stale focus nodes)', (t) async {
    Widget box(int n, {int idx = 0}) => Tabs(
      index: idx,
      onChanged: (_) {},
      children: <TabItem>[
        for (int i = 0; i < n; i++) TabItem(child: Text('t$i')),
      ],
    );
    await pump(t, box(4));
    await t.tap(find.text('t3'));
    await t.pump();
    await pump(t, box(1));
    await t.pump();
  });

  testWidgets('timeline empty data', (t) async {
    await pump(t, const Timeline(data: <TimelineData>[]));
  });

  testWidgets('tracker empty data', (t) async {
    await pump(t, const Tracker(data: <TrackerData>[]));
  });

  testWidgets('tree empty nodes', (t) async {
    await pump(
      t,
      Tree<String>(
        nodes: const <TreeNode<String>>[],
        shrinkWrap: true,
        builder: (c, i) => TreeRow(child: Text(i.data)),
      ),
    );
  });

  testWidgets('window dispose controller while open', (t) async {
    final c = WindowController(bounds: const Rect.fromLTWH(4, 4, 200, 150));
    await pump(
      t,
      SizedBox(
        width: 300,
        height: 260,
        child: WindowNavigator(
          initialWindows: <Window>[
            Window(
              controller: c,
              title: const Text('w'),
              content: const Text('body'),
            ),
          ],
          child: const SizedBox.expand(),
        ),
      ),
    );
    c.dispose();
  });

  testWidgets('pinned sheet closed initial stage', (t) async {
    final c = SheetController();
    await pump(
      t,
      SizedBox(
        width: 300,
        height: 260,
        child: PinnedSheet(
          controller: c,
          initialStage: const SheetStage.closed(),
          stages: const <SheetStage>[
            SheetStage.closed(),
            SheetStage.expanded(),
          ],
          child: const Text('sheet'),
        ),
      ),
    );
    c.dispose();
  });

  // Over-constrained minimums (mins sum past the box) overflow, exactly
  // like CSS flex with min-widths past the container in react-resizable-panels.
  // Degenerate caller config, not a component bug: no exception is thrown, the
  // Flex only reports the overflow. Verified here so the behaviour is pinned.
  testWidgets('resizable below-minimum total reports overflow, no throw', (
    t,
  ) async {
    await t.pumpWidget(
      frame(
        const SizedBox(
          width: 100,
          height: 100,
          child: ResizablePanelGroup(
            children: <Widget>[
              ResizablePanel(defaultSize: 60, minSize: 80, child: Text('a')),
              ResizableHandle(),
              ResizablePanel(defaultSize: 60, minSize: 80, child: Text('b')),
            ],
          ),
        ),
      ),
    );
    await t.pump();
    final Object? exception = t.takeException();
    expect(
      exception.toString(),
      contains('overflowed'),
      reason: 'expected only the overflow report, got: $exception',
    );
  });

  testWidgets('stepper currentStep out of range', (t) async {
    await pump(
      t,
      Stepper(
        currentStep: 9,
        steps: const <StepperStep>[StepperStep(title: Text('a'))],
      ),
    );
  });

  testWidgets('toast controller disposed while toast visible', (t) async {
    final c = ToastController();
    await pump(
      t,
      SizedBox(
        width: 300,
        height: 200,
        child: ToastLayer(controller: c, child: const Text('body')),
      ),
    );
    c.showToast(autoDismiss: false, builder: (c) => const Text('hello'));
    await t.pump();
    c.dispose();
    await t.pump();
    await t.pump(const Duration(milliseconds: 400));
  });

  testWidgets('toast dismiss removes the entry', (t) async {
    final c = ToastController();
    await pump(
      t,
      SizedBox(
        width: 300,
        height: 200,
        child: ToastLayer(controller: c, child: const Text('body')),
      ),
    );
    c.showToast(autoDismiss: false, builder: (c) => const Text('hello'));
    await t.pump();
    expect(find.text('hello'), findsOne);
    await t.tap(find.text('hello'));
    await t.pump();
  });
}
