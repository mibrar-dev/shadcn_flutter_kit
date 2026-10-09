// Widget tests for the `image` component.
//
// Covers the loading / loaded / error phases, sizing (explicit box, aspect
// ratio), the four theme legs and light + dark tokens. `Image` shadows
// Flutter's `Image`, so the component is imported behind a prefix.

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/image/image.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _green = Color(0xFF00FF00);
const Color _blue = Color(0xFF0000FF);

/// A provider that hands out a solid 4x4 image immediately.
class _SolidProvider extends ImageProvider<_SolidProvider> {
  const _SolidProvider();

  @override
  Future<_SolidProvider> obtainKey(ImageConfiguration configuration) =>
      Future<_SolidProvider>.value(this);

  @override
  ImageStreamCompleter loadImage(
    _SolidProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      Future<ImageInfo>.value(ImageInfo(image: _solidImage())),
    );
  }

  @override
  bool operator ==(Object other) => other is _SolidProvider;

  @override
  int get hashCode => 1;
}

/// A provider that always fails.
class _FailingProvider extends ImageProvider<_FailingProvider> {
  const _FailingProvider();

  @override
  Future<_FailingProvider> obtainKey(ImageConfiguration configuration) =>
      Future<_FailingProvider>.value(this);

  @override
  ImageStreamCompleter loadImage(
    _FailingProvider key,
    ImageDecoderCallback decode,
  ) {
    return OneFrameImageStreamCompleter(
      Future<ImageInfo>.error(StateError('decode failed')),
    );
  }

  @override
  bool operator ==(Object other) => other is _FailingProvider;

  @override
  int get hashCode => 2;
}

ui.Image _solidImage() {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  final ui.Canvas canvas = ui.Canvas(recorder);
  canvas.drawRect(
    const ui.Rect.fromLTWH(0, 0, 4, 4),
    ui.Paint()..color = const ui.Color(0xFF0000FF),
  );
  return recorder.endRecording().toImageSync(4, 4);
}

Widget _frame(
  Widget child, {
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  ImageTheme? scoped,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<ImageTheme>(data: scoped, child: body);
  }
  return ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Align(alignment: Alignment.topLeft, child: body),
      ),
    ),
  );
}

Color _backgroundOf(WidgetTester tester) => tester
    .widgetList<ColoredBox>(
      find.descendant(
        of: find.byType(ShadcnImage),
        matching: find.byType(ColoredBox),
      ),
    )
    .first
    .color;

BorderRadius _radiusOf(WidgetTester tester) =>
    tester
            .widget<ClipRRect>(
              find.descendant(
                of: find.byType(ShadcnImage),
                matching: find.byType(ClipRRect),
              ),
            )
            .borderRadius
        as BorderRadius;

Duration _fadeOf(WidgetTester tester) => tester
    .widget<AnimatedOpacity>(
      find.descendant(
        of: find.byType(ShadcnImage),
        matching: find.byType(AnimatedOpacity),
      ),
    )
    .duration;

void main() {
  group('phases', () {
    testWidgets('shows the placeholder layer while the bytes load', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(
            image: const _SolidProvider(),
            width: 40,
            aspectRatio: 1,
            placeholder: const Text('loading'),
          ),
        ),
      );
      expect(find.text('loading'), findsOneWidget);
      expect(find.byType(RawImage), findsOneWidget);
      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        0,
      );
    });

    testWidgets('the picture fades in once the bytes arrive', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 40, aspectRatio: 1),
        ),
      );
      await tester.pump();
      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        1,
      );
      final RawImage picture = tester.widget<RawImage>(find.byType(RawImage));
      expect(picture.image, isNotNull);
    });

    testWidgets('errorBuilder replaces the box when decoding fails', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(
            image: const _FailingProvider(),
            width: 40,
            aspectRatio: 1,
            errorBuilder: (context, error, stackTrace) => const Text('broken'),
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(find.text('broken'), findsOneWidget);
      expect(find.byType(RawImage), findsNothing);
    });

    testWidgets('without errorBuilder a failure keeps the background', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(
            image: const _FailingProvider(),
            width: 40,
            aspectRatio: 1,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.byType(RawImage), findsOneWidget);
      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity,
        0,
      );
    });
  });

  group('sizing', () {
    testWidgets('width and height size the box exactly', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 30, height: 50),
        ),
      );
      final Size size = tester.getSize(find.byType(ShadcnImage));
      expect(size, const Size(30, 50));
    });

    testWidgets('aspectRatio derives the missing axis from the width', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 40, aspectRatio: 2),
        ),
      );
      expect(tester.getSize(find.byType(ShadcnImage)), const Size(40, 20));
    });

    testWidgets('aspectRatio derives the width from an explicit height', (
      tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(
            image: const _SolidProvider(),
            height: 20,
            aspectRatio: 2,
          ),
        ),
      );
      expect(tester.getSize(find.byType(ShadcnImage)), const Size(40, 20));
    });
  });

  group('theme', () {
    testWidgets('defaults paint the muted token at radiusLg', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 20, aspectRatio: 1),
        ),
      );
      expect(_backgroundOf(tester), ShadcnColors.lightFallback.muted);
      expect(_radiusOf(tester).topLeft.x, ShadcnThemeData().radiusLg);
    });

    testWidgets('the widget leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(
            image: const _SolidProvider(),
            width: 20,
            aspectRatio: 1,
            background: _green,
            borderRadius: BorderRadius.zero,
            theme: const ImageTheme(duration: Duration(seconds: 1)),
          ),
        ),
      );
      expect(_backgroundOf(tester), _green);
      expect(_radiusOf(tester), BorderRadius.zero);
      expect(_fadeOf(tester), const Duration(seconds: 1));
    });

    testWidgets('the scoped leg overrides the app leg', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 20, aspectRatio: 1),
          app: const <ComponentThemeData>[
            ImageTheme(
              background: ThemedColor.value(_green),
              duration: Duration(seconds: 2),
            ),
          ],
          scoped: const ImageTheme(background: ThemedColor.value(_blue)),
        ),
      );
      expect(_backgroundOf(tester), _blue);
      // A leg that only sets `background` keeps the lower leg's duration.
      expect(_fadeOf(tester), const Duration(seconds: 2));
    });

    testWidgets('the app leg overrides the defaults', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 20, aspectRatio: 1),
          app: const <ComponentThemeData>[
            ImageTheme(background: ThemedColor.value(_green)),
          ],
        ),
      );
      expect(_backgroundOf(tester), _green);
      expect(_fadeOf(tester), const Duration(milliseconds: 150));
    });
  });

  group('tokens', () {
    testWidgets('dark tokens paint the dark muted colour', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 20, aspectRatio: 1),
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
        ),
      );
      expect(_backgroundOf(tester), ShadcnColors.darkFallback.muted);
    });

    testWidgets('light tokens paint the light muted colour', (tester) async {
      await tester.pumpWidget(
        _frame(
          ShadcnImage(image: const _SolidProvider(), width: 20, aspectRatio: 1),
        ),
      );
      expect(_backgroundOf(tester), ShadcnColors.lightFallback.muted);
    });
  });
}
