import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/dialog/dialog.dart';
import 'package:flutter_shadcn_kit/registry_next/components/dialog/dialog_style.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

/// Context of the page below the dialog; set by every [_pumpApp].
late BuildContext _host;

/// Focus node of the opener on the page below the dialog.
final FocusNode _openerNode = FocusNode(debugLabel: 'opener');

/// Focus node of the first control inside the dialog.
final FocusNode _insideNodeA = FocusNode(debugLabel: 'insideA');

/// Focus node of the second control inside the dialog.
final FocusNode _insideNodeB = FocusNode(debugLabel: 'insideB');

/// Ambient theme of the frame; flipped in place to prove the theme stays live.
final ValueNotifier<ShadcnThemeData> _theme = ValueNotifier<ShadcnThemeData>(
  const ShadcnThemeData(),
);

/// Stable navigator key for tests that keep a dialog open across pumps.
final GlobalKey<NavigatorState> _liveNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'liveNavigator',
);

/// Pumps a page with a `Navigator`, a directionality and a shadcn theme, plus
/// the optional app leg ([ComponentThemes]) and scoped leg ([ComponentTheme])
/// of [DialogTheme]. Pass `navigatorKey` to keep overlay state across pumps.
Future<void> _pumpApp(
  WidgetTester tester, {
  ShadcnThemeData? theme,
  DialogTheme? appTheme,
  DialogTheme? scopedTheme,
  EdgeInsets mediaPadding = EdgeInsets.zero,
  Key? navigatorKey,
}) async {
  Widget page = Builder(
    builder: (context) {
      _host = context;
      return _openerPage(context);
    },
  );
  // Scoped leg: below the navigator, around the caller, like a themed section.
  if (scopedTheme != null) {
    page = ComponentTheme<DialogTheme>(data: scopedTheme, child: page);
  }
  if (theme != null) _theme.value = theme;
  Widget app = Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(padding: mediaPadding),
      child: Navigator(
        // A fresh navigator per pump (unless a key is passed): re-pumping the
        // same widget type would keep the overlay state, including dialogs
        // already pushed.
        key: navigatorKey ?? UniqueKey(),
        onGenerateRoute: (settings) => PageRouteBuilder<void>(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) => page,
        ),
      ),
    ),
  );
  // App leg: installed once at the root, i.e. above the navigator, which is
  // what makes it visible inside the dialog route.
  if (appTheme != null) {
    app = ComponentThemes(themes: <ComponentThemeData>[appTheme], child: app);
  }
  await tester.pumpWidget(
    ValueListenableBuilder<ShadcnThemeData>(
      valueListenable: _theme,
      builder: (context, data, _) => ShadcnTheme(data: data, child: app),
    ),
  );
  _openerNode.requestFocus();
}

/// Page below the dialog: an opener that must be refocused after the close.
Widget _openerPage(BuildContext context) => Center(
  child: Focus(
    focusNode: _openerNode,
    child: const SizedBox(width: 10, height: 10),
  ),
);

/// Two focusable controls inside a dialog body.
class _Body extends StatelessWidget {
  const _Body({this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Focus(focusNode: _insideNodeA, child: const SizedBox(height: 10)),
          Focus(focusNode: _insideNodeB, child: const SizedBox(height: 10)),
        ],
      ),
    );
  }
}

/// Box decoration painted by the dialog shell.
BoxDecoration _surfaceDecoration(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(find.byKey(kDialogSurfaceKey));
  return box.decoration as BoxDecoration;
}

/// Scale of the dialog transition, 0.7 while opening and 1 when settled.
double _scale(WidgetTester tester) =>
    tester.widget<ScaleTransition>(find.byType(ScaleTransition)).scale.value;

/// Opacity of the dialog transition.
double _opacity(WidgetTester tester) =>
    tester.widget<FadeTransition>(find.byType(FadeTransition)).opacity.value;

/// Modal barrier of the topmost dialog route.
AnimatedModalBarrier _barrier(WidgetTester tester) => tester
    .widgetList<AnimatedModalBarrier>(find.byType(AnimatedModalBarrier))
    .last;

/// Color of the modal barrier behind the dialog.
Color _barrierColor(WidgetTester tester) =>
    _barrier(tester).color.value ?? kDialogFallbackBarrierColor;

/// Focus node that currently holds the primary focus.
FocusNode get _primary => FocusManager.instance.primaryFocus!;

void main() {
  setUp(() {
    _theme.value = const ShadcnThemeData();
  });

  tearDown(() {
    FocusManager.instance.primaryFocus?.unfocus();
  });

  testWidgets('opens with a scale and fade, closes again', (tester) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pump();
    expect(find.byKey(kDialogSurfaceKey), findsOneWidget);
    expect(_scale(tester), lessThan(1.0));

    await tester.pumpAndSettle();
    expect(_scale(tester), 1.0);
    expect(_opacity(tester), 1.0);

    Navigator.of(_host).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(kDialogSurfaceKey), findsNothing);
    expect(find.byType(ScaleTransition), findsNothing);
  });

  testWidgets('shell paints the themed card', (tester) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(width: 1000),
      ),
    );
    await tester.pumpAndSettle();

    final colors = ShadcnColors.lightFallback;
    final decoration = _surfaceDecoration(tester);
    expect(decoration.color, colors.card);
    expect(decoration.borderRadius, const BorderRadius.all(Radius.circular(8)));
    expect((decoration.border! as Border).top.color, colors.border);
    expect((decoration.border! as Border).top.width, 1.0);
    expect(decoration.boxShadow, isNotNull);
    expect(decoration.boxShadow, isNotEmpty);
    // maxWidth default of 480 wins over the 1000 wide content.
    expect(tester.getSize(find.byKey(kDialogSurfaceKey)).width, 480.0);
  });

  testWidgets('default barrier is black at 50% and honours overrides', (
    tester,
  ) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    final barrier = _barrierColor(tester);
    expect(barrier.a, closeTo(0.5, 0.01));
    expect(barrier.r, 0.0);
    expect(barrier.g, 0.0);
    expect(barrier.b, 0.0);
    expect(
      _barrier(tester).semanticsLabel,
      ShadcnLocalizations(Locale('en')).dialogDismiss,
    );

    unawaited(
      showShadcnDialog<void>(
        context: _host,
        barrierColor: const ThemedColor.value(Color(0xFFFF0000)),
        barrierLabel: 'Close it',
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    expect(_barrierColor(tester), const Color(0xFFFF0000));
    expect(_barrier(tester).semanticsLabel, 'Close it');
  });

  testWidgets('barrier tap dismisses only when barrierDismissible', (
    tester,
  ) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.byKey(kDialogSurfaceKey), findsNothing);

    unawaited(
      showShadcnDialog<void>(
        context: _host,
        barrierDismissible: false,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(find.byKey(kDialogSurfaceKey), findsOneWidget);
  });

  testWidgets('escape dismisses only when barrierDismissible', (tester) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(kDialogSurfaceKey), findsNothing);

    unawaited(
      showShadcnDialog<void>(
        context: _host,
        barrierDismissible: false,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byKey(kDialogSurfaceKey), findsOneWidget);
  });

  testWidgets('focus moves into the dialog, cycles, and comes back', (
    tester,
  ) async {
    await _pumpApp(tester);
    expect(_primary, _openerNode);

    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    expect(_primary, isNot(_openerNode));

    // closedLoop: Tab walks the dialog controls and wraps around.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_primary, _insideNodeA);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_primary, _insideNodeB);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_primary, _insideNodeA);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(_primary, _insideNodeB);

    Navigator.of(_host).pop();
    await tester.pumpAndSettle();
    expect(find.byKey(kDialogSurfaceKey), findsNothing);
    expect(_primary, _openerNode);
  });

  testWidgets('full screen drops radius, border, shadow and inset', (
    tester,
  ) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        fullScreen: true,
        builder: (context) => const _Body(width: 1000),
      ),
    );
    await tester.pumpAndSettle();

    final decoration = _surfaceDecoration(tester);
    expect(decoration.borderRadius, isNull);
    expect(decoration.border, isNull);
    expect(decoration.boxShadow, isNull);
    expect(tester.getSize(find.byKey(kDialogSurfaceKey)), const Size(800, 600));
    // Full screen drops the outer inset but keeps the card padding.
    expect(tester.getTopLeft(find.byType(_Body)), const Offset(24, 24));
  });

  testWidgets('card pads its content and keeps an outer inset', (tester) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        alignment: Alignment.topLeft,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    // insetPadding: padSm x density content padding = 16.
    final card = tester.getTopLeft(find.byKey(kDialogSurfaceKey));
    expect(card, const Offset(16, 16));
    // padding: shadcn p-6 = padMd x density content padding = 24.
    expect(tester.getTopLeft(find.byType(_Body)), card + const Offset(24, 24));
  });

  testWidgets('theme stays live: card and barrier follow a dark switch', (
    tester,
  ) async {
    await _pumpApp(
      tester,
      navigatorKey: _liveNavigatorKey,
      // Scoped leg around the caller, i.e. below the navigator.
      scopedTheme: const DialogTheme(
        barrierColor: ThemedColor.ref(ColorRef.muted),
      ),
    );
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    expect(_surfaceDecoration(tester).color, ShadcnColors.lightFallback.card);
    // The scoped leg beats the black a0.5 default.
    expect(_barrierColor(tester), ShadcnColors.lightFallback.muted);

    _theme.value = const ShadcnThemeData(colors: ShadcnColors.darkFallback);
    await tester.pumpAndSettle();
    expect(find.byKey(kDialogSurfaceKey), findsOneWidget);
    expect(_surfaceDecoration(tester).color, ShadcnColors.darkFallback.card);
    expect(_barrierColor(tester), ShadcnColors.darkFallback.muted);
  });

  testWidgets('useSafeArea insets the card', (tester) async {
    const padding = EdgeInsets.only(top: 40, bottom: 20);
    await _pumpApp(tester, mediaPadding: padding);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SafeArea), findsOneWidget);
    final inset = tester.getTopLeft(find.byKey(kDialogSurfaceKey)).dy;
    expect(inset, greaterThan(0));

    Navigator.of(_host).pop();
    await tester.pumpAndSettle();
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        useSafeArea: false,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SafeArea), findsNothing);
    expect(
      tester.getTopLeft(find.byKey(kDialogSurfaceKey)).dy,
      lessThan(inset),
    );
  });

  testWidgets('widget leg beats scoped leg beats app leg beats defaults', (
    tester,
  ) async {
    Future<void> pumpWithLegs(DialogTheme? widgetTheme) async {
      await _pumpApp(
        tester,
        appTheme: const DialogTheme(maxWidth: 300, borderWidth: 3),
        scopedTheme: const DialogTheme(maxWidth: 320),
      );
      unawaited(
        showShadcnDialog<void>(
          context: _host,
          theme: widgetTheme,
          builder: (context) => const _Body(width: 1000),
        ),
      );
      await tester.pumpAndSettle();
    }

    // defaults (480) < app (300) < scoped (320)
    await pumpWithLegs(null);
    expect(tester.getSize(find.byKey(kDialogSurfaceKey)).width, 320.0);

    // widget leg wins
    await pumpWithLegs(const DialogTheme(maxWidth: 340));
    expect(tester.getSize(find.byKey(kDialogSurfaceKey)).width, 340.0);

    // A widget leg that sets only maxWidth keeps the app leg's borderWidth
    // (3) and the default radius.
    await pumpWithLegs(const DialogTheme(maxWidth: 360));
    final decoration = _surfaceDecoration(tester);
    expect(tester.getSize(find.byKey(kDialogSurfaceKey)).width, 360.0);
    expect((decoration.border! as Border).top.width, 3.0);
    expect(decoration.borderRadius, const BorderRadius.all(Radius.circular(8)));
  });

  testWidgets('returns the value passed to Navigator.pop', (tester) async {
    await _pumpApp(tester);
    final result = showShadcnDialog<String>(
      context: _host,
      builder: (context) => const _Body(),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    Navigator.of(_host).pop('ok');
    await tester.pumpAndSettle();
    expect(await result, 'ok');
  });

  testWidgets('barrier dismissal resolves to null', (tester) async {
    await _pumpApp(tester);
    final result = showShadcnDialog<String>(
      context: _host,
      builder: (context) => const _Body(),
    );
    await tester.pump();
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(4, 4));
    await tester.pumpAndSettle();
    expect(await result, isNull);
  });

  testWidgets('dark tokens drive the card', (tester) async {
    await _pumpApp(
      tester,
      theme: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
    );
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        builder: (context) => const _Body(),
      ),
    );
    await tester.pumpAndSettle();
    final colors = ShadcnColors.darkFallback;
    final decoration = _surfaceDecoration(tester);
    expect(decoration.color, colors.card);
    expect((decoration.border! as Border).top.color, colors.border);
  });

  testWidgets('transitionDuration from the theme is honoured', (tester) async {
    await _pumpApp(tester);
    unawaited(
      showShadcnDialog<void>(
        context: _host,
        theme: const DialogTheme(transitionDuration: Duration.zero),
        builder: (context) => const _Body(),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(_scale(tester), 1.0);
  });
}
