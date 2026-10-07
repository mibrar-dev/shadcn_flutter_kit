// Widget tests for the `alert_dialog` component.
//
// Covers the header/footer composition, the four theme-precedence legs, the
// barrier colour inherited from `DialogTheme` (the old alert dialog hardcoded
// its own barrier and ignored every theme leg), and the route result.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/alert_dialog/alert_dialog.dart';
import 'package:flutter_shadcn_kit/registry_next/components/dialog/dialog.dart';
import 'package:flutter_shadcn_kit/registry_next/components/dialog/dialog_style.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

/// Pumps a single navigator-hosted frame with the app and scoped theme legs.
Future<void> _pump(
  WidgetTester tester, {
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  AlertDialogTheme? scopedTheme,
  DialogTheme? scopedDialogTheme,
}) async {
  Widget body = child;
  if (scopedTheme != null) {
    body = ComponentTheme<AlertDialogTheme>(data: scopedTheme, child: body);
  }
  Widget host = Directionality(
    textDirection: TextDirection.ltr,
    child: Navigator(
      onGenerateRoute: (settings) => PageRouteBuilder<void>(
        settings: settings,
        pageBuilder: (context, _, _) => Center(child: body),
      ),
    ),
  );
  // Both scoped legs sit around the navigator, so a pushed route inherits
  // them: the dialog shell resolves `DialogTheme` inside its own subtree.
  if (scopedDialogTheme != null) {
    host = ComponentTheme<DialogTheme>(data: scopedDialogTheme, child: host);
  }
  await tester.pumpWidget(
    ShadcnTheme(
      data: data,
      child: ComponentThemes(themes: app, child: host),
    ),
  );
}

/// Pumps the frame and pushes [showAlertDialog] from its host context.
Future<void> _pumpOpen(
  WidgetTester tester, {
  Widget? title,
  Widget? description,
  Widget? icon,
  List<Widget> actions = const <Widget>[],
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  AlertDialogTheme? theme,
  DialogTheme? scopedDialogTheme,
  Color? barrierColor,
  bool barrierDismissible = true,
}) async {
  late BuildContext host;
  await _pump(
    tester,
    data: data,
    app: app,
    scopedDialogTheme: scopedDialogTheme,
    child: Builder(
      builder: (context) {
        host = context;
        return const SizedBox(width: 10, height: 10);
      },
    ),
  );
  showAlertDialog<Object?>(
    context: host,
    title: title,
    description: description,
    icon: icon,
    actions: actions,
    barrierColor: barrierColor == null ? null : ThemedColor.value(barrierColor),
    barrierDismissible: barrierDismissible,
    theme: theme,
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

/// Resolves the icon colour the alert dialog applied to its header icon.
Color? _iconColor(WidgetTester tester) {
  final IconTheme icon = tester.widget<IconTheme>(find.byType(IconTheme));
  return icon.data.color;
}

/// Reads the text style a [DefaultTextStyle] in the header applies.
TextStyle? _styleFor(WidgetTester tester, String text) {
  final Finder finder = find.ancestor(
    of: find.text(text),
    matching: find.byType(DefaultTextStyle),
  );
  final Iterable<DefaultTextStyle> nodes = tester.widgetList<DefaultTextStyle>(
    finder,
  );
  return nodes.isEmpty ? null : nodes.first.style;
}

void main() {
  group('composition', () {
    testWidgets('renders title, description and actions', (tester) async {
      await _pump(
        tester,
        child: const AlertDialog(
          title: Text('Title'),
          description: Text('Body'),
          actions: <Widget>[Text('Cancel'), Text('Ok')],
        ),
      );
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Ok'), findsOneWidget);
    });

    testWidgets('title-only omits the description and the footer', (
      tester,
    ) async {
      await _pump(
        tester,
        child: const AlertDialog(title: Text('Only a title')),
      );
      expect(find.text('Only a title'), findsOneWidget);
      expect(find.byType(Wrap), findsNothing);
    });

    testWidgets('actions only, no header', (tester) async {
      await _pump(
        tester,
        child: const AlertDialog(actions: <Widget>[Text('Close')]),
      );
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('a single action is aligned to the end of the row', (
      tester,
    ) async {
      await _pump(
        tester,
        child: const AlertDialog(
          title: Text('Title'),
          actions: <Widget>[Text('Ok')],
        ),
      );
      expect(find.byType(Align), findsOneWidget);
    });

    testWidgets('several actions wrap at the end of the row', (tester) async {
      await _pump(
        tester,
        child: const AlertDialog(
          title: Text('Title'),
          actions: <Widget>[Text('A'), Text('B'), Text('C')],
        ),
      );
      expect(find.byType(Wrap), findsOneWidget);
    });
  });

  group('tokens', () {
    testWidgets('title uses foreground, description mutedForeground', (
      tester,
    ) async {
      final ShadcnColors colors = ShadcnColors.lightFallback;
      await _pump(
        tester,
        child: const AlertDialog(
          title: Text('Title'),
          description: Text('Body'),
        ),
      );
      expect(_styleFor(tester, 'Title')?.color, colors.foreground);
      expect(_styleFor(tester, 'Body')?.color, colors.mutedForeground);
    });

    testWidgets('dark palette drives the same slots', (tester) async {
      const ShadcnColors dark = ShadcnColors.darkFallback;
      await _pump(
        tester,
        data: const ShadcnThemeData(colors: dark),
        child: const AlertDialog(
          title: Text('Title'),
          description: Text('Body'),
        ),
      );
      expect(_styleFor(tester, 'Title')?.color, dark.foreground);
      expect(_styleFor(tester, 'Body')?.color, dark.mutedForeground);
    });

    testWidgets('header icon uses the mutedForeground token by default', (
      tester,
    ) async {
      await _pump(
        tester,
        child: const AlertDialog(
          icon: Icon(IconData(0x1234)),
          title: Text('Title'),
        ),
      );
      expect(_iconColor(tester), ShadcnColors.lightFallback.mutedForeground);
    });
  });

  group('theme precedence', () {
    testWidgets('app leg overrides defaults', (tester) async {
      await _pump(
        tester,
        app: const <ComponentThemeData>[
          AlertDialogTheme(iconColor: ThemedColor.ref(ColorRef.destructive)),
        ],
        child: const AlertDialog(
          icon: Icon(IconData(0x1234)),
          title: Text('Title'),
        ),
      );
      expect(_iconColor(tester), ShadcnColors.lightFallback.destructive);
    });

    testWidgets('scoped leg overrides the app leg', (tester) async {
      await _pump(
        tester,
        app: const <ComponentThemeData>[
          AlertDialogTheme(iconColor: ThemedColor.ref(ColorRef.destructive)),
        ],
        scopedTheme: const AlertDialogTheme(
          iconColor: ThemedColor.value(_green),
        ),
        child: const AlertDialog(
          icon: Icon(IconData(0x1234)),
          title: Text('Title'),
        ),
      );
      expect(_iconColor(tester), _green);
    });

    testWidgets('widget leg overrides the scoped leg', (tester) async {
      await _pump(
        tester,
        scopedTheme: const AlertDialogTheme(
          iconColor: ThemedColor.value(_green),
        ),
        child: const AlertDialog(
          icon: Icon(IconData(0x1234)),
          title: Text('Title'),
          theme: AlertDialogTheme(iconColor: ThemedColor.value(_blue)),
        ),
      );
      expect(_iconColor(tester), _blue);
    });

    testWidgets(
      'a higher leg setting only one field keeps the other defaults',
      (tester) async {
        await _pump(
          tester,
          scopedTheme: const AlertDialogTheme(iconGap: 99),
          child: const AlertDialog(
            icon: Icon(IconData(0x1234)),
            title: Text('Title'),
          ),
        );
        // The untouched icon colour still falls through to the token default.
        expect(_iconColor(tester), ShadcnColors.lightFallback.mutedForeground);
      },
    );
  });

  group('route', () {
    testWidgets('showAlertDialog pushes the composition and returns a result', (
      tester,
    ) async {
      late BuildContext host;
      await _pump(
        tester,
        child: Builder(
          builder: (context) {
            host = context;
            return const SizedBox(width: 10, height: 10);
          },
        ),
      );
      Object? result;
      final Future<Object?> future =
          showAlertDialog<Object?>(
            context: host,
            title: const Text('Confirm'),
            description: const Text('Really?'),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(host).pop('ok'),
                child: const Text('Ok'),
              ),
            ],
          ).then((value) {
            result = value;
            return value;
          });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Confirm'), findsOneWidget);
      await tester.tap(find.text('Ok'));
      await tester.pump();
      await future;
      expect(result, 'ok');
    });

    testWidgets(
      'regression: the barrier is DialogTheme black at 50%, not a hardcoded 80%',
      (tester) async {
        await _pumpOpen(tester, title: const Text('Alert'));
        final AnimatedModalBarrier barrier = tester
            .widget<AnimatedModalBarrier>(find.byType(AnimatedModalBarrier));
        final Color? resolved = barrier.color.value;
        expect(resolved, const Color(0x80000000));
        // The old alert dialog used black at 80% and ignored the theme.
        expect(resolved?.a, lessThan(0.6));
      },
    );

    testWidgets(
      'regression: a scoped DialogTheme restyles the alert card padding',
      (tester) async {
        await _pumpOpen(
          tester,
          title: const Text('Alert'),
          scopedDialogTheme: const DialogTheme(padding: EdgeInsets.all(4)),
        );
        final Padding padding = tester.widget<Padding>(
          find
              .descendant(
                of: find.byKey(kDialogSurfaceKey),
                matching: find.byType(Padding),
              )
              .first,
        );
        expect(padding.padding, const EdgeInsets.all(4));
      },
    );

    testWidgets('barrierColor overrides the theme barrier', (tester) async {
      await _pumpOpen(tester, title: const Text('Alert'), barrierColor: _blue);
      final AnimatedModalBarrier barrier = tester.widget<AnimatedModalBarrier>(
        find.byType(AnimatedModalBarrier),
      );
      expect(barrier.color.value, _blue);
    });
  });
}
