import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/overlay_manager.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/popover.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/popover_controller.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/popover_layout.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';

const contentKey = ValueKey<String>('popover-content');
const anchorKey = ValueKey<String>('anchor');

Widget _layout({
  required Alignment alignment,
  required Offset position,
  bool allowInvertHorizontal = true,
  bool allowInvertVertical = true,
  Size childSize = const Size(200, 50),
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(
      data: const ShadcnThemeData(),
      child: Center(
        child: SizedBox(
          width: 800,
          height: 600,
          child: PopoverLayout(
            alignment: alignment,
            anchorAlignment: alignment,
            position: position,
            widthConstraint: PopoverConstraint.flexible,
            heightConstraint: PopoverConstraint.flexible,
            margin: EdgeInsets.zero,
            scale: 1,
            scaleAlignment: Alignment.topLeft,
            allowInvertHorizontal: allowInvertHorizontal,
            allowInvertVertical: allowInvertVertical,
            child: SizedBox(
              key: contentKey,
              width: childSize.width,
              height: childSize.height,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _overlayHost(void Function(BuildContext anchorContext) expose) {
  return Directionality(
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
                    expose(context);
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
  );
}

void main() {
  testWidgets('PopoverLayout inverts horizontally near the right edge', (
    tester,
  ) async {
    await tester.pumpWidget(
      _layout(alignment: Alignment.topLeft, position: const Offset(750, 300)),
    );
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(550, 300));

    await tester.pumpWidget(
      _layout(alignment: Alignment.topLeft, position: const Offset(300, 300)),
    );
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(300, 300));

    await tester.pumpWidget(
      _layout(
        alignment: Alignment.topLeft,
        position: const Offset(750, 300),
        allowInvertHorizontal: false,
      ),
    );
    // No inversion, but the popover is still clamped inside the viewport.
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(600, 300));
  });

  testWidgets('PopoverLayout inverts vertically near the bottom edge', (
    tester,
  ) async {
    await tester.pumpWidget(
      _layout(alignment: Alignment.topLeft, position: const Offset(400, 580)),
    );
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(400, 530));

    await tester.pumpWidget(
      _layout(alignment: Alignment.topLeft, position: const Offset(400, 100)),
    );
    expect(tester.getTopLeft(find.byKey(contentKey)), const Offset(400, 100));
  });

  testWidgets('showPopover renders, closes and completes', (tester) async {
    late BuildContext anchorContext;
    await tester.pumpWidget(_overlayHost((context) => anchorContext = context));

    final key = GlobalKey<OverlayHandlerStateMixin>();
    final completer = showPopover<void>(
      context: anchorContext,
      key: key,
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
    expect(find.byKey(contentKey), findsOneWidget);
    expect(completer.isCompleted, isFalse);

    // Do not await close(): it resolves with the dismiss animation, which
    // only runs while frames are pumped.
    key.currentState!.close();
    await tester.pump();
    expect(completer.isCompleted, isTrue);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byKey(contentKey), findsNothing);
  });

  testWidgets('PopoverController tracks open popovers', (tester) async {
    late BuildContext anchorContext;
    await tester.pumpWidget(_overlayHost((context) => anchorContext = context));

    final controller = PopoverController();
    addTearDown(controller.dispose);
    expect(controller.hasOpenPopover, isFalse);

    controller.show<void>(
      context: anchorContext,
      alignment: Alignment.bottomCenter,
      anchorAlignment: Alignment.topCenter,
      showDuration: Duration.zero,
      hideDuration: Duration.zero,
      builder: (context) =>
          const SizedBox(key: contentKey, width: 100, height: 50),
    );
    await tester.pump();
    expect(find.byKey(contentKey), findsOneWidget);
    expect(controller.hasOpenPopover, isTrue);
    expect(controller.openPopovers.length, 1);

    controller.close(true);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(controller.hasOpenPopover, isFalse);
    expect(find.byKey(contentKey), findsNothing);
  });
}
