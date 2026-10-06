import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry_next/primitives/widget_states.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';

Widget _wrap(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ShadcnTheme(data: const ShadcnThemeData(), child: child),
  );
}

Widget _probe() {
  return const StatedWidget(
    child: Text('rest'),
    disabled: Text('disabled'),
    pressed: Text('pressed'),
    hovered: Text('hovered'),
    focused: Text('focused'),
    selected: Text('selected'),
  );
}

void main() {
  setUp(() {
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() {
    FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
  });

  testWidgets('shows the pressed state while the pointer is down', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(Clickable(onPressed: () {}, child: _probe())),
    );
    expect(find.text('rest'), findsOneWidget);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(Clickable)),
    );
    await tester.pump();
    expect(find.text('pressed'), findsOneWidget);

    await gesture.up();
    await tester.pump();
    expect(find.text('pressed'), findsNothing);
    expect(find.text('rest'), findsOneWidget);
  });

  testWidgets('shows the hovered state for a mouse pointer', (tester) async {
    await tester.pumpWidget(
      _wrap(Clickable(onPressed: () {}, child: _probe())),
    );

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();

    await gesture.moveTo(tester.getCenter(find.byType(Clickable)));
    await tester.pump();
    expect(find.text('hovered'), findsOneWidget);

    await gesture.moveTo(const Offset(-10, -10));
    await tester.pump();
    expect(find.text('hovered'), findsNothing);
  });

  testWidgets('shows the focused state and reports focus changes', (
    tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    bool? reportedFocus;
    await tester.pumpWidget(
      _wrap(
        Clickable(
          focusNode: focusNode,
          onPressed: () {},
          onFocus: (value) => reportedFocus = value,
          child: _probe(),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.pump();
    expect(find.text('focused'), findsOneWidget);
    expect(reportedFocus, isTrue);
  });

  testWidgets('is disabled when enabled or onPressed is false/null', (
    tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(
        Clickable(
          enabled: false,
          onPressed: () => tapped = true,
          child: _probe(),
        ),
      ),
    );
    expect(find.text('disabled'), findsOneWidget);

    await tester.tap(find.byType(Clickable), warnIfMissed: false);
    await tester.pump();
    expect(tapped, isFalse);

    await tester.pumpWidget(_wrap(Clickable(child: _probe())));
    await tester.tap(find.byType(Clickable), warnIfMissed: false);
    await tester.pump();
    expect(tapped, isFalse);
    expect(find.text('disabled'), findsNothing);
  });

  testWidgets('activates with enter and space', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    var pressed = 0;
    await tester.pumpWidget(
      _wrap(
        Clickable(
          focusNode: focusNode,
          onPressed: () => pressed++,
          child: _probe(),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(pressed, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(pressed, 2);
  });

  testWidgets('double tap is reported to onDoubleTap instead of onPressed', (
    tester,
  ) async {
    var single = 0;
    var double = 0;
    await tester.pumpWidget(
      _wrap(
        Clickable(
          enableFeedback: false,
          onPressed: () => single++,
          onDoubleTap: () => double++,
          child: _probe(),
        ),
      ),
    );

    await tester.tap(find.byType(Clickable), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byType(Clickable), warnIfMissed: false);
    await tester.pump();

    expect(double, 1);
    expect(single, 1);
  });

  testWidgets('WidgetStatesProvider.boundary blocks ancestor states', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        WidgetStatesProvider(
          states: const {WidgetState.selected},
          child: WidgetStatesProvider.boundary(child: _probe()),
        ),
      ),
    );
    expect(find.text('rest'), findsOneWidget);

    await tester.pumpWidget(
      _wrap(
        WidgetStatesProvider(
          states: const {WidgetState.selected},
          child: _probe(),
        ),
      ),
    );
    expect(find.text('selected'), findsOneWidget);
  });

  testWidgets('StatedWidget.map and .builder read the state set', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        WidgetStatesProvider(
          states: const {WidgetState.error},
          child: Column(
            children: [
              StatedWidget.map(
                states: const {WidgetState.error: Text('mapped')},
                child: const Text('fallback'),
              ),
              StatedWidget.builder(
                builder: (context, states) =>
                    Text(states.contains(WidgetState.error) ? 'rich' : 'plain'),
              ),
            ],
          ),
        ),
      ),
    );
    expect(find.text('mapped'), findsOneWidget);
    expect(find.text('rich'), findsOneWidget);
  });
}
