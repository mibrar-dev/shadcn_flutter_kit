import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/primitives/fade_scroll.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

/// Behavioural notes for the fixed implementation:
/// * a [ShaderMask] is always part of the tree; an opaque shader is used
///   while no edge needs a fade, so the child shape never changes;
/// * the scrollable is therefore never remounted and the scroll offset
///   survives fade transitions without a `PageStorage` bucket.
void main() {
  testWidgets('the ShaderMask is installed before and after scrolling', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Center(
            child: SizedBox(
              width: 200,
              height: 100,
              child: FadeScroll(
                controller: controller,
                child: ListView(
                  controller: controller,
                  children: [
                    for (var i = 0; i < 40; i++)
                      SizedBox(height: 20, child: Text('item $i')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(ShaderMask), findsOneWidget);

    controller.jumpTo(120);
    await tester.pump();
    expect(controller.offset, 120);
    expect(find.byType(ShaderMask), findsOneWidget);

    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();
    // The start edge keeps fading at the very end of the list.
    expect(find.byType(ShaderMask), findsOneWidget);
  });

  testWidgets('the scrollable survives the fade state without PageStorage', (
    tester,
  ) async {
    final controller = ScrollController();
    final idleController = ScrollController();
    addTearDown(controller.dispose);
    addTearDown(idleController.dispose);

    Widget frame(ScrollController fadeController) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: ShadcnTheme(
          data: const ShadcnThemeData(),
          child: Center(
            child: SizedBox(
              width: 200,
              height: 100,
              child: FadeScroll(
                controller: fadeController,
                child: _MountProbe(
                  child: ListView(
                    controller: controller,
                    children: [
                      for (var i = 0; i < 40; i++)
                        SizedBox(height: 20, child: Text('item $i')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    await tester.pumpWidget(frame(controller));
    await tester.pump();
    expect(find.byType(ShaderMask), findsOneWidget);
    final probe = tester.state<_MountProbeState>(find.byType(_MountProbe));

    controller.jumpTo(120);
    await tester.pump();
    expect(controller.offset, 120);

    // The controller seen by FadeScroll loses its clients: the fade shader is
    // swapped for the opaque one. The old implementation returned the bare
    // child here and remounted the scrollable; the offset must survive.
    await tester.pumpWidget(frame(idleController));
    await tester.pump();
    expect(find.byType(ShaderMask), findsOneWidget);

    await tester.pumpWidget(frame(controller));
    await tester.pump();
    expect(find.byType(ShaderMask), findsOneWidget);

    expect(
      tester.state<_MountProbeState>(find.byType(_MountProbe)),
      same(probe),
    );
    expect(controller.offset, 120);
  });

  testWidgets('FadeScrollTheme supplies the gradient', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: ShadcnTheme(
          data: const ShadcnThemeData(),
          child: ComponentTheme<FadeScrollTheme>(
            data: const FadeScrollTheme(
              gradient: [Color(0xFF000000), Color(0x00FFFFFF)],
            ),
            child: Center(
              child: SizedBox(
                width: 200,
                height: 100,
                child: FadeScroll(
                  controller: controller,
                  child: ListView(
                    controller: controller,
                    children: [
                      for (var i = 0; i < 40; i++)
                        SizedBox(height: 20, child: Text('row $i')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    controller.jumpTo(120);
    await tester.pump();

    final mask = tester.widget<ShaderMask>(find.byType(ShaderMask));
    final shader = mask.shaderCallback(Offset.zero & const Size(200, 100));
    expect(shader, isNotNull);
  });
}

class _MountProbe extends StatefulWidget {
  final Widget child;

  const _MountProbe({required this.child});

  @override
  State<_MountProbe> createState() => _MountProbeState();
}

class _MountProbeState extends State<_MountProbe> {
  @override
  Widget build(BuildContext context) => widget.child;
}
