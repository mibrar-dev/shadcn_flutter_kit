// Widget and unit tests for the `overflow_marquee` component.
//
// Covers: the resolved surface defaults (light + dark), the four theme legs,
// fit vs overflow behaviour, horizontal/vertical scroll, RTL, reduced motion,
// the edge-fade clamp and the hit-test regression (hits used to ignore the
// scroll offset). The ping-pong helper is covered in the animation primitive
// tests.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry_next/components/overflow_marquee/overflow_marquee.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry_next/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _frame({
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  TextDirection textDirection = TextDirection.ltr,
  bool disableAnimations = false,
  required Widget child,
}) {
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: MediaQuery(
        data: MediaQueryData(
          size: const Size(800, 600),
          disableAnimations: disableAnimations,
        ),
        child: Directionality(
          textDirection: textDirection,
          child: Center(child: child),
        ),
      ),
    ),
  );
}

MarqueeSurface _surface(WidgetTester tester) {
  final OverflowMarquee widget = tester.widget<OverflowMarquee>(
    find.byType(OverflowMarquee),
  );
  return resolveMarqueeSurface(
    tester.element(find.byType(OverflowMarquee)),
    widgetTheme: widget.theme,
    direction: widget.direction,
    duration: widget.duration,
    delayDuration: widget.delayDuration,
    step: widget.step,
    fadePortion: widget.fadePortion,
    curve: widget.curve,
  );
}

/// A `width` x `height` child carrying [key]; its middle 100px block holds
/// [target] when given.
Widget _child({
  required Key key,
  double width = 400,
  double height = 40,
  Key? target,
  VoidCallback? onTap,
}) {
  return SizedBox(
    key: key,
    width: width,
    height: height,
    child: Center(
      child: SizedBox(
        width: 100,
        height: height,
        child: target == null
            ? const ColoredBox(color: Color(0xFF00FF00))
            : GestureDetector(
                key: target,
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: const ColoredBox(color: Color(0xFF00FF00)),
              ),
      ),
    ),
  );
}

/// The child's origin relative to the marquee box, i.e. the scroll offset.
Offset _scrollOffset(WidgetTester tester, Key key) {
  final RenderBox box = tester.renderObject(find.byKey(key));
  final Offset origin = box.localToGlobal(Offset.zero);
  return origin - tester.getTopLeft(find.byType(OverflowMarquee));
}

void main() {
  testWidgets('surface defaults: horizontal, 1s run, 500ms rest, 100px step', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(child: const OverflowMarquee(child: Text('x'))),
    );
    final MarqueeSurface surface = _surface(tester);
    expect(surface.direction, Axis.horizontal);
    expect(surface.duration, const Duration(seconds: 1));
    expect(surface.delayDuration, const Duration(milliseconds: 500));
    expect(surface.step, 100);
    expect(surface.fadePortion, 0.1);
    expect(surface.curve, Curves.linear);
  });

  testWidgets('renders with light and dark tokens', (tester) async {
    await tester.pumpWidget(_frame(child: const Text('fits')));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _frame(
        data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        child: const OverflowMarquee(child: Text('fits')),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme precedence: defaults < app < scoped < widget', (
    tester,
  ) async {
    const OverflowMarqueeTheme app = OverflowMarqueeTheme(
      duration: Duration(seconds: 2),
      step: 50,
    );
    const OverflowMarqueeTheme scoped = OverflowMarqueeTheme(
      duration: Duration(seconds: 3),
      fadePortion: 0.3,
    );
    const OverflowMarqueeTheme widgetLeg = OverflowMarqueeTheme(step: 25);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const OverflowMarquee(child: Text('fits')),
      ),
    );
    expect(_surface(tester).duration, const Duration(seconds: 2));
    expect(_surface(tester).step, 50);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const ComponentTheme<OverflowMarqueeTheme>(
          data: scoped,
          child: OverflowMarquee(child: Text('fits')),
        ),
      ),
    );
    expect(_surface(tester).duration, const Duration(seconds: 3));
    expect(_surface(tester).fadePortion, 0.3);
    // `scoped` sets no step, so the app leg survives the merge.
    expect(_surface(tester).step, 50);

    await tester.pumpWidget(
      _frame(
        app: <ComponentThemeData>[app],
        child: const ComponentTheme<OverflowMarqueeTheme>(
          data: scoped,
          child: OverflowMarquee(theme: widgetLeg, child: Text('fits')),
        ),
      ),
    );
    expect(_surface(tester).step, 25);
    expect(_surface(tester).duration, const Duration(seconds: 3));
  });

  testWidgets('widget arguments beat every theme leg and clamp', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        app: const <ComponentThemeData>[
          OverflowMarqueeTheme(
            duration: Duration(seconds: 9),
            fadePortion: 0.4,
          ),
        ],
        child: const ComponentTheme<OverflowMarqueeTheme>(
          data: OverflowMarqueeTheme(step: 10),
          child: OverflowMarquee(
            direction: Axis.vertical,
            duration: Duration(milliseconds: 250),
            fadePortion: 0.9,
            child: Text('x'),
          ),
        ),
      ),
    );
    final MarqueeSurface surface = _surface(tester);
    expect(surface.duration, const Duration(milliseconds: 250));
    expect(surface.direction, Axis.vertical);
    expect(surface.fadePortion, 0.5); // clamped from 0.9
    expect(surface.step, 10);
  });

  testWidgets('content that fits never moves', (tester) async {
    final Key key = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 300,
          height: 40,
          child: OverflowMarquee(
            duration: const Duration(milliseconds: 400),
            child: _child(key: key, width: 200),
          ),
        ),
      ),
    );
    final Offset before = _scrollOffset(tester, key);
    expect(before, Offset.zero);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
    expect(_scrollOffset(tester, key), before);
  });

  testWidgets('overflowing content lays out naturally and scrolls', (
    tester,
  ) async {
    final Key key = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 100,
          height: 40,
          child: OverflowMarquee(
            duration: const Duration(seconds: 1),
            delayDuration: Duration.zero,
            step: 100,
            child: _child(key: key),
          ),
        ),
      ),
    );
    final RenderBox child = tester.renderObject(find.byKey(key));
    // Natural width, not clipped down to the 100px container.
    expect(child.size.width, 400);

    expect(_scrollOffset(tester, key), Offset.zero);
    // 300px overflow at 100px/s -> 3s per run; a quarter run is 75px.
    await tester.pump(const Duration(milliseconds: 750));
    expect(_scrollOffset(tester, key).dx, closeTo(-75, 1));
    await tester.pump(const Duration(milliseconds: 2250));
    expect(_scrollOffset(tester, key).dx, closeTo(-300, 1));
  });

  testWidgets('regression: the vertical axis scrolls on its own extent', (
    tester,
  ) async {
    final Key key = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 100,
          height: 60,
          child: OverflowMarquee(
            direction: Axis.vertical,
            duration: const Duration(seconds: 1),
            delayDuration: Duration.zero,
            step: 100,
            child: _child(key: key, width: 100, height: 200),
          ),
        ),
      ),
    );
    final RenderBox child = tester.renderObject(find.byKey(key));
    expect(child.size.height, 200);
    expect(_scrollOffset(tester, key), Offset.zero);
    // The old copy measured `child.size.width - size.width`, which is 0 for
    // this shape: no scroll ever started.
    await tester.pump(const Duration(milliseconds: 500));
    expect(_scrollOffset(tester, key).dy, lessThan(0));
  });

  testWidgets('RTL starts at the right edge', (tester) async {
    final Key key = UniqueKey();
    Widget build(TextDirection direction) {
      return _frame(
        textDirection: direction,
        child: SizedBox(
          width: 100,
          height: 40,
          child: OverflowMarquee(
            duration: const Duration(seconds: 1),
            delayDuration: Duration.zero,
            child: _child(key: key),
          ),
        ),
      );
    }

    await tester.pumpWidget(build(TextDirection.ltr));
    final double ltrStart = _scrollOffset(tester, key).dx;

    await tester.pumpWidget(build(TextDirection.rtl));
    final double rtlStart = _scrollOffset(tester, key).dx;

    expect(ltrStart, 0);
    expect(rtlStart, -300);
  });

  testWidgets('reduced motion holds the start position', (tester) async {
    final Key key = UniqueKey();
    await tester.pumpWidget(
      _frame(
        disableAnimations: true,
        child: SizedBox(
          width: 100,
          height: 40,
          child: OverflowMarquee(
            duration: const Duration(milliseconds: 400),
            delayDuration: Duration.zero,
            child: _child(key: key),
          ),
        ),
      ),
    );
    final Offset before = _scrollOffset(tester, key);
    await tester.pump(const Duration(milliseconds: 800));
    expect(_scrollOffset(tester, key), before);
  });

  testWidgets('hit tests follow the scroll offset', (tester) async {
    bool tapped = false;
    final Key childKey = UniqueKey();
    final Key targetKey = UniqueKey();
    await tester.pumpWidget(
      _frame(
        child: SizedBox(
          width: 100,
          height: 40,
          child: OverflowMarquee(
            duration: const Duration(seconds: 1),
            delayDuration: Duration.zero,
            step: 100,
            child: _child(
              key: childKey,
              target: targetKey,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );
    // Half a run: the 300px overflow sits at -150, so the target (child
    // 150..250) covers the visible 0..100 window.
    await tester.pump(const Duration(milliseconds: 1500));
    final Offset origin = tester.getTopLeft(find.byType(OverflowMarquee));
    expect(tester.getTopLeft(find.byKey(targetKey)).dx, origin.dx);
    await tester.tapAt(origin + const Offset(50, 20));
    expect(tapped, isTrue);
  });
}
