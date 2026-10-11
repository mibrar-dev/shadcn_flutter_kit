import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/foundation/data.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry/primitives/overlay_manager_layer.dart';
import 'package:flutter_shadcn_kit/registry/primitives/popover.dart';
import 'package:flutter_shadcn_kit/registry/primitives/popover_overlay_handler.dart';
import 'package:flutter_shadcn_kit/registry/primitives/sheet_overlay.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

const contentKey = ValueKey<String>('popover-content');
const anchorKey = ValueKey<String>('anchor');

void main() {
  testWidgets('ShadcnLayer installs an OverlayManager', (tester) async {
    OverlayManager? fromTree;
    OverlayManager? fromOf;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ShadcnLayer(
            child: Builder(
              builder: (context) {
                fromTree = Data.maybeOf<OverlayManager>(context);
                fromOf = OverlayManager.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    expect(fromTree, isA<OverlayManagerLayerState>());
    expect(fromOf, same(fromTree));
  });

  testWidgets('two independent layers each route to their own manager', (
    tester,
  ) async {
    final keyA = GlobalKey<OverlayManagerLayerState>();
    final keyB = GlobalKey<OverlayManagerLayerState>();
    OverlayManager? managerA;
    OverlayManager? managerB;

    Widget layer(
      GlobalKey<OverlayManagerLayerState> key,
      void Function(OverlayManager) capture,
    ) {
      return OverlayManagerLayer(
        key: key,
        popoverHandler: OverlayHandler.popover,
        tooltipHandler: OverlayHandler.popover,
        menuHandler: OverlayHandler.popover,
        child: Builder(
          builder: (context) {
            capture(OverlayManager.of(context));
            return const SizedBox();
          },
        ),
      );
    }

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            layer(keyA, (manager) => managerA = manager),
            layer(keyB, (manager) => managerB = manager),
          ],
        ),
      ),
    );

    expect(managerA, same(keyA.currentState));
    expect(managerB, same(keyB.currentState));
    expect(managerA, isNot(same(managerB)));
  });

  testWidgets('a disposed layer leaves no manager behind', (tester) async {
    final key = GlobalKey<OverlayManagerLayerState>();
    late BuildContext outsideContext;
    OverlayManager? inside;

    Widget tree({required bool withLayer}) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            outsideContext = context;
            final child = Builder(
              builder: (context) {
                inside = OverlayManager.of(context);
                return const SizedBox();
              },
            );
            if (!withLayer) {
              return child;
            }
            return OverlayManagerLayer(
              key: key,
              popoverHandler: OverlayHandler.popover,
              tooltipHandler: OverlayHandler.popover,
              menuHandler: OverlayHandler.popover,
              child: child,
            );
          },
        ),
      );
    }

    await tester.pumpWidget(tree(withLayer: true));
    final state = key.currentState;
    expect(state, isNotNull);
    expect(inside, same(state));

    // There is no global registry: a context above the layer gets the
    // per-widget fallback, not the layer's manager.
    expect(OverlayManager.of(outsideContext), isNot(same(state)));

    await tester.pumpWidget(tree(withLayer: false));
    final afterDispose = OverlayManager.of(outsideContext);
    expect(afterDispose, isNot(same(state)));
    expect(afterDispose, isNot(isA<OverlayManagerLayerState>()));
  });

  testWidgets('OverlayHandler.popover is the default popover handler', (
    tester,
  ) async {
    expect(OverlayHandler.popover, isA<PopoverOverlayHandler>());
  });

  testWidgets('sheet overlay marker is visible only inside a sheet', (
    tester,
  ) async {
    bool? inside;
    Widget probe() => Builder(
      builder: (context) {
        inside = SheetOverlayHandler.isSheetOverlay(context);
        return const SizedBox();
      },
    );

    await tester.pumpWidget(
      Directionality(textDirection: TextDirection.ltr, child: probe()),
    );
    expect(inside, isFalse);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Data<SheetOverlayMarker>.inherit(
          data: const SheetOverlayMarker(),
          child: probe(),
        ),
      ),
    );
    expect(inside, isTrue);
  });

  testWidgets('tapping the modal barrier dismisses the overlay', (
    tester,
  ) async {
    late BuildContext anchorContext;
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ShadcnLayer(
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Center(
                    child: Builder(
                      builder: (context) {
                        anchorContext = context;
                        return const SizedBox(
                          key: anchorKey,
                          width: 60,
                          height: 30,
                          child: Text('anchor'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final completer = showPopover<void>(
      context: anchorContext,
      alignment: Alignment.bottomCenter,
      anchorAlignment: Alignment.topCenter,
      builder: (context) => const SizedBox(
        key: contentKey,
        width: 100,
        height: 50,
        child: Text('popover'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byKey(contentKey), findsOneWidget);

    await tester.tapAt(const Offset(20, 20));
    await tester.pump();
    expect(completer.isCompleted, isTrue);

    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byKey(contentKey), findsNothing);
  });
}
