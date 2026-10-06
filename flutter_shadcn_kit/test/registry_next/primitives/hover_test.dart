import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/hover.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(data: const ShadcnThemeData(), child: child),
  );
}

void main() {
  testWidgets('HoverActivity reports enter/exit and ticks while hovered', (
    tester,
  ) async {
    var enters = 0;
    var exits = 0;
    var ticks = 0;
    await tester.pumpWidget(
      _wrap(
        Center(
          child: HoverActivity(
            debounceDuration: const Duration(milliseconds: 100),
            onEnter: () => enters++,
            onExit: () => exits++,
            onHover: () => ticks++,
            child: const SizedBox(
              width: 100,
              height: 50,
              child: Text('target'),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();

    await gesture.moveTo(tester.getCenter(find.byType(HoverActivity)));
    await tester.pump();
    expect(enters, 1);
    // repeat() notifies the status listener once immediately.
    expect(ticks, 1);

    await tester.pump(const Duration(milliseconds: 350));
    expect(ticks, greaterThan(1));

    await gesture.moveTo(const Offset(-20, -20));
    await tester.pump();
    expect(exits, 1);
  });

  testWidgets('Hover delays onHover(true) and keeps feedback on exit', (
    tester,
  ) async {
    final events = <bool>[];
    await tester.pumpWidget(
      _wrap(
        Center(
          child: Hover(
            waitDuration: const Duration(milliseconds: 100),
            minDuration: const Duration(milliseconds: 20),
            showDuration: const Duration(milliseconds: 30),
            onHover: events.add,
            child: const SizedBox(
              width: 100,
              height: 50,
              child: Text('target'),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();

    await gesture.moveTo(tester.getCenter(find.byType(Hover)));
    await tester.pump(const Duration(milliseconds: 60));
    expect(events, isEmpty);

    await tester.pump(const Duration(milliseconds: 50));
    expect(events, [true]);

    await gesture.moveTo(const Offset(-20, -20));
    await tester.pump(const Duration(milliseconds: 40));
    expect(events, [true]);

    await tester.pump(const Duration(milliseconds: 20));
    expect(events, [true, false]);
  });

  testWidgets('HoverTheme supplies the delays when the widget does not', (
    tester,
  ) async {
    final events = <bool>[];
    await tester.pumpWidget(
      _wrap(
        ComponentTheme<HoverTheme>(
          data: const HoverTheme(waitDuration: Duration(milliseconds: 10)),
          child: Center(
            child: Hover(
              minDuration: Duration.zero,
              showDuration: Duration.zero,
              onHover: events.add,
              child: const SizedBox(
                width: 100,
                height: 50,
                child: Text('target'),
              ),
            ),
          ),
        ),
      ),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();

    await gesture.moveTo(tester.getCenter(find.byType(Hover)));
    await tester.pump(const Duration(milliseconds: 20));
    expect(events, [true]);

    await gesture.moveTo(const Offset(-20, -20));
    await tester.pump(const Duration(milliseconds: 20));
    expect(events, [true, false]);
  });
}
