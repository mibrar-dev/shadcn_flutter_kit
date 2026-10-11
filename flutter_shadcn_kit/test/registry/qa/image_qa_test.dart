// QA for `image` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: a width-only (or height-only) box leaving the other
// axis unbounded, which threw under `StackFit.expand` in unbounded parents.

import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/image/image.dart';
import 'package:flutter_shadcn_kit/registry/components/image/preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

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
  TextDirection direction = TextDirection.ltr,
  double? width,
}) {
  return ShadcnTheme(
    data: data,
    child: Directionality(
      textDirection: direction,
      child: Center(
        child: width == null ? child : SizedBox(width: width, child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('every preview pumps light + dark with no exception', (
    tester,
  ) async {
    for (final preview in imagePreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(
          _frame(
            Builder(builder: preview.builder),
            data: ShadcnThemeData(colors: colors),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(
          tester.takeException(),
          isNull,
          reason: '${preview.name} light/dark',
        );
      }
    }
  });

  testWidgets('width-only image defaults to square in a Column', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[ShadcnImage(image: _SolidProvider(), width: 40)],
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(ShadcnImage)), const Size(40, 40));
  });

  testWidgets('height-only image defaults to square in a Row', (tester) async {
    await tester.pumpWidget(
      _frame(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[ShadcnImage(image: _SolidProvider(), height: 40)],
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(ShadcnImage)), const Size(40, 40));
  });

  testWidgets('width-only with an aspectRatio resolves the missing axis', (
    tester,
  ) async {
    await tester.pumpWidget(
      _frame(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ShadcnImage(image: _SolidProvider(), width: 40, aspectRatio: 2),
          ],
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(ShadcnImage)), const Size(40, 20));
  });

  testWidgets('explicit axes are never overridden', (tester) async {
    await tester.pumpWidget(
      _frame(const ShadcnImage(image: _SolidProvider(), width: 30, height: 50)),
    );
    await tester.pump();
    expect(tester.getSize(find.byType(ShadcnImage)), const Size(30, 50));
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: imagePreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    for (final preview in imagePreviews) {
      await tester.pumpWidget(
        _frame(Builder(builder: preview.builder), direction: TextDirection.rtl),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
