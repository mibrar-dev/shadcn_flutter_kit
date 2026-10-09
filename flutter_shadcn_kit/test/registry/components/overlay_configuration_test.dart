// Widget tests for the `overlay_configuration` component.
//
// Covers: showOverlay + maybeOf for every configuration, adaptive conversion,
// the drawer/sheet routes, the dialog barrier, the OverlayController lifecycle
// and nonAdaptive.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/drawer/drawer.dart';
import 'package:flutter_shadcn_kit/registry/components/overlay_configuration/overlay_configuration.dart';
import 'package:flutter_shadcn_kit/registry/primitives/drawer_route/drawer_route.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager_layer.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

late BuildContext _host;

Future<void> _pump(WidgetTester tester, {ShadcnThemeData? theme}) async {
  final Widget page = Builder(
    builder: (BuildContext context) {
      _host = context;
      return const SizedBox(width: 20, height: 20);
    },
  );
  await tester.pumpWidget(
    ShadcnTheme(
      data: theme ?? const ShadcnThemeData(platform: TargetPlatform.macOS),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: const MediaQueryData(),
          child: OverlayManagerLayer(
            popoverHandler: OverlayHandler.popover,
            tooltipHandler: OverlayHandler.popover,
            menuHandler: OverlayHandler.popover,
            child: Navigator(
              onGenerateRoute: (RouteSettings settings) =>
                  PageRouteBuilder<void>(
                    settings: settings,
                    pageBuilder: (_, _, _) => page,
                  ),
            ),
          ),
        ),
      ),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

void main() {
  testWidgets('showOverlay presents a popover and publishes the config', (
    tester,
  ) async {
    await _pump(tester);
    OverlayConfiguration? seen;
    final OverlayCompleter<void> completer = showOverlay<void>(
      _host,
      const PopoverConfiguration(alignment: Alignment.center),
      builder: (BuildContext context) => Builder(
        builder: (BuildContext inner) {
          seen = OverlayConfiguration.maybeOf(inner);
          return const Text('Popover body');
        },
      ),
    );
    await _settle(tester);
    expect(find.text('Popover body'), findsOneWidget);
    expect(seen, isA<PopoverConfiguration>());

    completer.remove();
    await _settle(tester);
    expect(find.text('Popover body'), findsNothing);
  });

  testWidgets('adaptiveConversion maps a popover to a drawer on mobile', (
    tester,
  ) async {
    await _pump(
      tester,
      theme: const ShadcnThemeData(platform: TargetPlatform.iOS),
    );
    const PopoverConfiguration popover = PopoverConfiguration(
      alignment: Alignment.center,
    );
    expect(popover.adaptiveConversion(_host), isA<DrawerConfiguration>());

    await _pump(
      tester,
      theme: const ShadcnThemeData(platform: TargetPlatform.macOS),
    );
    expect(popover.adaptiveConversion(_host), isA<PopoverConfiguration>());
    expect(popover.nonAdaptive, same(popover));
  });

  testWidgets('a tooltip configuration is non-modal', (tester) async {
    await _pump(tester);
    showOverlay<void>(
      _host,
      const TooltipConfiguration(alignment: Alignment.topCenter),
      builder: (BuildContext context) => const Text('Tip'),
    );
    await _settle(tester);
    expect(find.text('Tip'), findsOneWidget);
  });

  testWidgets('a dialog configuration presents a modal barrier', (
    tester,
  ) async {
    await _pump(tester);
    showOverlay<void>(
      _host,
      const DialogConfiguration(),
      builder: (BuildContext context) => const Text('Dialog body'),
    );
    await _settle(tester);
    expect(find.text('Dialog body'), findsOneWidget);
    expect(find.byType(ModalBarrier), findsWidgets);
  });

  testWidgets('a drawer configuration opens the drawer route', (tester) async {
    await _pump(tester);
    showOverlay<void>(
      _host,
      const DrawerConfiguration(position: OverlayPosition.end),
      builder: (BuildContext context) => const Text('Drawer body'),
    );
    await _settle(tester);
    expect(find.text('Drawer body'), findsOneWidget);
    expect(find.byType(DrawerPanelScope), findsOneWidget);
  });

  testWidgets('a sheet configuration opens a sheet route', (tester) async {
    await _pump(tester);
    showOverlay<void>(
      _host,
      const SheetConfiguration(maxSize: 200),
      builder: (BuildContext context) => const Text('Sheet body'),
    );
    await _settle(tester);
    expect(find.text('Sheet body'), findsOneWidget);
    expect(find.byType(DrawerPanelScope), findsOneWidget);
  });

  testWidgets('OverlayController tracks the managed overlay', (tester) async {
    await _pump(tester);
    final OverlayController controller = OverlayController();
    addTearDown(controller.dispose);
    controller.show<void>(
      _host,
      const PopoverConfiguration(alignment: Alignment.center),
      builder: (BuildContext context) => const Text('Managed'),
    );
    await _settle(tester);
    expect(controller.hasOpenOverlay, isTrue);
    expect(controller.config, isA<PopoverConfiguration>());

    controller.close();
    await _settle(tester);
    expect(controller.hasOpenOverlay, isFalse);
    expect(find.text('Managed'), findsNothing);
  });

  testWidgets('showOverlay honours adaptive: false', (tester) async {
    await _pump(
      tester,
      theme: const ShadcnThemeData(platform: TargetPlatform.iOS),
    );
    OverlayConfiguration? seen;
    showOverlay<void>(
      _host,
      const PopoverConfiguration(alignment: Alignment.center),
      adaptive: false,
      builder: (BuildContext context) => Builder(
        builder: (BuildContext inner) {
          seen = OverlayConfiguration.maybeOf(inner);
          return const Text('Non-adaptive');
        },
      ),
    );
    await _settle(tester);
    expect(seen, isA<PopoverConfiguration>());
    expect(find.byType(DrawerPanelScope), findsNothing);
  });
}
