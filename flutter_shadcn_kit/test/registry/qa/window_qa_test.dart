// QA for `window` previews (P7-Q2): behaviour, spacing, functionality.
//
// Drives every `windowPreviews` example like a user: the Default example
// shows a draggable window with title and content, the Maximized example
// shows a maximized window plus an always-on-top inspector. Controllers are
// owned per example and disposed. Focus/raise, snap and edge-resize maths
// are pinned in `window_test.dart`.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/window/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/window/window.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 420,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: SizedBox(width: width, child: child),
      ),
    ),
  );
}

Future<void> _pumpPreview(
  WidgetTester tester,
  ComponentPreview preview, {
  ShadcnThemeData data = const ShadcnThemeData(),
  TextDirection direction = TextDirection.ltr,
  double width = 420,
}) async {
  await tester.pumpWidget(
    _frame(
      Builder(builder: preview.builder),
      data: data,
      direction: direction,
      width: width,
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  expect(
    tester.takeException(),
    isNull,
    reason: 'preview "${preview.name}" threw',
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in windowPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('Default preview: window with title and content', (tester) async {
    await _pumpPreview(tester, windowPreviews[0]);
    expect(find.text('Notes'), findsOneWidget);
    expect(
      find.text('Drag the title bar; resize from any edge.'),
      findsOneWidget,
    );
  });

  testWidgets('Default preview: dragging the title bar moves the window', (
    tester,
  ) async {
    await _pumpPreview(tester, windowPreviews[0]);
    final Offset before = tester.getTopLeft(find.text('Notes'));
    await tester.drag(find.text('Notes'), const Offset(30, 12));
    // Position eases toward the pointer (AnimatedValueBuilder), so settle.
    await tester.pumpAndSettle();
    final Offset after = tester.getTopLeft(find.text('Notes'));
    expect(after.dx, greaterThan(before.dx));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Maximized preview: editor plus inspector', (tester) async {
    await _pumpPreview(tester, windowPreviews[1]);
    expect(find.text('Editor'), findsOneWidget);
    expect(find.text('Inspector'), findsOneWidget);
    expect(find.text('Maximized; restore from the title bar.'), findsOneWidget);
    expect(find.text('Always on top.'), findsOneWidget);
  });

  testWidgets('previews mirror in RTL with no exception', (tester) async {
    for (final preview in windowPreviews) {
      await _pumpPreview(tester, preview, direction: TextDirection.rtl);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });

  List<String> windowOrder(WidgetTester tester) => tester
      .elementList(find.byType(Window))
      .map((Element e) => (e.widget.key! as ValueKey<String>).value)
      .toList();

  testWidgets('toggling alwaysOnTop re-layers and repaints (P7-Q2)', (
    tester,
  ) async {
    final WindowController alpha = WindowController(
      bounds: const Rect.fromLTWH(24, 20, 280, 190),
    );
    final WindowController beta = WindowController(
      bounds: const Rect.fromLTWH(24, 20, 280, 190),
    );
    addTearDown(alpha.dispose);
    addTearDown(beta.dispose);
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 340,
          height: 300,
          child: WindowNavigator(
            initialWindows: <Window>[
              Window(
                key: const ValueKey<String>('alpha'),
                controller: alpha,
                title: const Text('Alpha'),
                content: const Text('a'),
              ),
              Window(
                key: const ValueKey<String>('beta'),
                controller: beta,
                title: const Text('Beta'),
                content: const Text('b'),
              ),
            ],
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(windowOrder(tester), <String>['beta', 'alpha']);
    // Pinning beta on top rebuilds with beta last (top layer paints last).
    beta.alwaysOnTop = true;
    await tester.pumpAndSettle();
    expect(windowOrder(tester), <String>['alpha', 'beta']);
    // Pinning alpha too puts it in front of beta (insert at 0, like push).
    alpha.alwaysOnTop = true;
    await tester.pumpAndSettle();
    expect(windowOrder(tester), <String>['beta', 'alpha']);
    // Releasing beta moves it back; nothing throws and both stay visible.
    beta.alwaysOnTop = false;
    await tester.pumpAndSettle();
    expect(windowOrder(tester), <String>['beta', 'alpha']);
    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('chromeless window still honours its bounds (P7-Q2)', (
    tester,
  ) async {
    final WindowController bare = WindowController(
      bounds: const Rect.fromLTWH(24, 20, 280, 190),
    );
    addTearDown(bare.dispose);
    await tester.pumpWidget(
      _frame(
        SizedBox(
          width: 340,
          height: 300,
          child: WindowNavigator(
            initialWindows: <Window>[Window(controller: bare)],
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final Size size = tester.getSize(find.byType(Window));
    expect(size.width, moreOrLessEquals(280));
    expect(size.height, moreOrLessEquals(190));
  });
}
