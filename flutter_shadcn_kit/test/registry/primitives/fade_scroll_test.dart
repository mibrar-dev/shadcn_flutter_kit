import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/primitives/fade_scroll.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

/// Behavioural notes for the fixed implementation:
/// * the mask is alpha-only (`BlendMode.dstIn`, opaque white to transparent
///   white), so the fade dissolves into whatever surface sits behind the
///   scrollable and is identical in light and dark mode;
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

  testWidgets('the mask is dstIn, so no colour can leak into the fade', (
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
                endOffset: 20,
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
    );
    await tester.pump();
    await tester.pump();
    final mask = tester.widget<ShaderMask>(find.byType(ShaderMask));
    expect(mask.blendMode, BlendMode.dstIn);
  });

  for (final (String name, ShadcnThemeData data) in <(String, ShadcnThemeData)>[
    ('light', const ShadcnThemeData()),
    ('dark', const ShadcnThemeData(colors: ShadcnColors.darkFallback)),
  ]) {
    testWidgets('faded pixels blend to the surface in $name mode', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      const Color background = Color(0xFF808080);
      const Color content = Color(0xFFFF0000);
      final GlobalKey boundaryKey = GlobalKey();
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: ShadcnTheme(
            data: data,
            child: Align(
              child: RepaintBoundary(
                key: boundaryKey,
                child: ColoredBox(
                  color: background,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: FadeScroll(
                      controller: controller,
                      endOffset: 40,
                      child: ListView(
                        controller: controller,
                        children: const <Widget>[
                          SizedBox(
                            height: 400,
                            child: ColoredBox(color: content),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      final RenderObject? object = boundaryKey.currentContext
          ?.findRenderObject();
      expect(object, isA<RenderRepaintBoundary>());
      final ui.Image? image = await tester.runAsync<ui.Image?>(() {
        return (object! as RenderRepaintBoundary).toImage(pixelRatio: 1);
      });
      expect(image, isNotNull);
      final ByteData? bytes = await tester.runAsync<ByteData?>(() {
        return image!.toByteData(format: ui.ImageByteFormat.rawRgba);
      });
      expect(bytes, isNotNull);
      expect(bytes!.lengthInBytes, 100 * 100 * 4);

      Color at(int x, int y) {
        final int o = (y * 100 + x) * 4;
        return Color.fromARGB(
          bytes.getUint8(o + 3),
          bytes.getUint8(o),
          bytes.getUint8(o + 1),
          bytes.getUint8(o + 2),
        );
      }

      // Mid-list: fully opaque content.
      final Color solid = at(50, 30);
      expect(solid.a, 1.0);
      expect(solid.r, 1.0);
      expect(solid.g, 0.0);

      // In the 40 px end fade (alpha 0.25 at y = 90): red dissolved into
      // the grey surface, never a black or white block and never untouched.
      final Color faded = at(50, 90);
      expect(faded.a, 1.0);
      expect(faded.r, inInclusiveRange(0.55, 0.75));
      expect(faded.g, inInclusiveRange(0.3, 0.48));
      expect(faded.b, inInclusiveRange(0.3, 0.48));
    });
  }

  test('FadeScrollTheme merges legs and compares by offsets', () {
    const base = FadeScrollTheme(startOffset: 4);
    const fallback = FadeScrollTheme(startOffset: 8, endOffset: 12);
    expect(base.merge(fallback).startOffset, 4);
    expect(base.merge(fallback).endOffset, 12);
    expect(
      base.copyWith(endOffset: () => 6),
      const FadeScrollTheme(startOffset: 4, endOffset: 6),
    );
    expect(base, const FadeScrollTheme(startOffset: 4));
    expect(base.hashCode, const FadeScrollTheme(startOffset: 4).hashCode);
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
