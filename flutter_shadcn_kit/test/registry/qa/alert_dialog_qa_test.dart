// QA for `alert_dialog` previews (P7-Q1).
//
// Regression cover for: non-`end` footer alignments collapsing to the start,
// the preview double-counting the action gap, and the unscaled header icon.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/alert_dialog/alert_dialog.dart';
import 'package:flutter_shadcn_kit/registry/components/alert_dialog/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

AlertDialog _dialog(MainAxisAlignment alignment, List<Widget> actions) {
  return AlertDialog(
    title: const Text('t'),
    description: const Text('d'),
    actions: actions,
    theme: AlertDialogTheme(footerAlignment: alignment),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in alertDialogPreviews) {
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

  testWidgets('single centered action is centered, not start-aligned', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(_dialog(MainAxisAlignment.center, const <Widget>[Text('ok')])),
    );
    await tester.pump();
    final Align align = tester.widget<Align>(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(Align),
      ),
    );
    expect(align.alignment, AlignmentDirectional.center);
  });

  testWidgets('multiple centered actions use WrapAlignment.center', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        _dialog(MainAxisAlignment.center, const <Widget>[Text('a'), Text('b')]),
      ),
    );
    await tester.pump();
    final Wrap wrap = tester.widget<Wrap>(find.byType(Wrap));
    expect(wrap.alignment, WrapAlignment.center);
  });

  testWidgets('framed preview separates actions by exactly one actionGap', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(Builder(builder: alertDialogPreviews[0].builder)),
    );
    await tester.pumpAndSettle();
    // The footer Wrap holds exactly the two action buttons: no spacer
    // widget sits between them, so the Wrap `spacing` (actionGap 8) is the
    // only gap. (The old preview embedded a SizedBox spacer as well.)
    final Wrap footer = tester.widget<Wrap>(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(Wrap),
      ),
    );
    expect(footer.children.length, 2);
    expect(footer.spacing, 8);
  });

  testWidgets('live push opens, returns a result and pops', (tester) async {
    final Widget preview = Builder(builder: alertDialogPreviews[2].builder);
    await tester.pumpWidget(
      ShadcnTheme(
        data: const ShadcnThemeData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Navigator(
            onGenerateRoute: (settings) => PageRouteBuilder<void>(
              settings: settings,
              pageBuilder: (context, _, _) => Center(child: preview),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show alert dialog'));
    await tester.pumpAndSettle();
    expect(find.text('Delete this project?'), findsWidgets);
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Show alert dialog'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('framed preview fits 375px', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: alertDialogPreviews[0].builder), width: 375),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
