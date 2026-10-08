// Widget tests for the shared `SubFocusListItem` row.

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/subfocus_list_item.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/subfocus_scope.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({required Widget child, ShadcnThemeData? data}) {
  return ShadcnTheme(
    data: data ?? const ShadcnThemeData(),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: SizedBox(
          width: 200,
          child: SubFocusScope(builder: (context, scope) => child),
        ),
      ),
    ),
  );
}

BoxDecoration? _decoration(WidgetTester tester) {
  final Clickable clickable = tester.widget<Clickable>(find.byType(Clickable));
  return clickable.decoration?.resolve(<WidgetState>{}) as BoxDecoration?;
}

void main() {
  testWidgets('renders leading, title and trailing under both token sets', (
    tester,
  ) async {
    for (final ShadcnThemeData data in <ShadcnThemeData>[
      const ShadcnThemeData(),
      const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    ]) {
      await tester.pumpWidget(
        _frame(
          data: data,
          child: SubFocusListItem(
            leading: const Text('L'),
            title: const Text('Alpha'),
            trailing: const Text('T'),
            onTap: () {},
          ),
        ),
      );
      expect(find.text('L'), findsOneWidget);
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('T'), findsOneWidget);
    }
  });

  testWidgets('hover moves sub-focus and paints the highlight', (tester) async {
    // Simulated mouse hover only reaches FocusableActionDetector with the
    // traditional highlight strategy (B01 Q5).
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic;
    });

    await tester.pumpWidget(
      _frame(
        child: SubFocusListItem(title: const Text('Alpha'), onTap: () {}),
      ),
    );
    expect(_decoration(tester)?.color?.a, 0);

    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Alpha')));
    await tester.pump();
    await tester.pump();

    expect(_decoration(tester)?.color?.a, greaterThan(0));
  });

  testWidgets('a row without onTap is read-only: no clickable, dimmed', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const SubFocusListItem(title: Text('Alpha'))),
    );
    expect(find.byType(Clickable), findsNothing);
    final Opacity opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 0.5);
  });

  testWidgets('the palette-style ActivateIntent activates the row', (
    tester,
  ) async {
    final List<String> activated = <String>[];
    await tester.pumpWidget(
      _frame(
        child: SubFocusListItem(
          title: const Text('Alpha'),
          onTap: () => activated.add('Alpha'),
        ),
      ),
    );
    // The palette's enter handler invokes ActivateIntent on the focused
    // item's context; keyboard activation through the row's own focus node is
    // covered by command_test.dart.
    final BuildContext context = tester.element(find.text('Alpha'));
    Actions.invoke(context, const ActivateIntent());
    expect(activated, <String>['Alpha']);
  });
}
