// QA for `file_picker` previews (P7-Q1 batch E): behaviour, robustness.
//
// Regression cover for: a removed file's error staying on screen, the owned
// controller being created in `build`, and a `pick == null` dropzone that
// rendered enabled/idle while keyboard-dead.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/dropzone/dropzone.dart';
import 'package:flutter_shadcn_kit/registry/components/file_picker/file_picker.dart';
import 'package:flutter_shadcn_kit/registry/components/file_picker/preview.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const FileValue _file = FileValue(id: 'a', name: 'a.pdf', size: 1200);

Future<List<FileValue>> _emptyPick(FileUploadPickRequest request) async =>
    <FileValue>[];

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
    for (final preview in filePickerPreviews) {
      for (final colors in <ShadcnColors>[
        ShadcnColors.lightFallback,
        ShadcnColors.darkFallback,
      ]) {
        await tester.pumpWidget(const SizedBox.shrink());
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

  testWidgets('removing a file hides that file\u2019s error', (tester) async {
    final FileUploadController controller = FileUploadController(
      initialItems: const <FileItem>[FileItem(file: _file)],
    );
    addTearDown(controller.dispose);
    controller.reportError(
      const FileError(
        code: FileErrorCode.tooLarge,
        message: 'boom',
        file: _file,
      ),
    );
    await tester.pumpWidget(
      _frame(FileUpload(controller: controller, pick: _emptyPick)),
    );
    await tester.pump();
    expect(find.text('boom'), findsOneWidget);

    await tester.tap(find.byIcon(RadixIcons.cross1));
    await tester.pump();
    expect(find.text('boom'), findsNothing);
    expect(controller.items, isEmpty);
  });

  testWidgets('owned controller survives controller swaps', (tester) async {
    final FileUploadController external = FileUploadController();
    addTearDown(external.dispose);
    // Owned (created in didChangeDependencies, not build).
    await tester.pumpWidget(_frame(FileUpload(pick: _emptyPick)));
    await tester.pump();
    expect(tester.takeException(), isNull);
    // Swap to an external controller and back: the owned one is
    // disposed and recreated without an exception.
    await tester.pumpWidget(
      _frame(FileUpload(controller: external, pick: _emptyPick)),
    );
    await tester.pump();
    await tester.pumpWidget(_frame(FileUpload(pick: _emptyPick)));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('pick == null renders the dropzone disabled', (tester) async {
    await tester.pumpWidget(_frame(const FileUpload()));
    await tester.pump();
    final Dropzone dropzone = tester.widget<Dropzone>(find.byType(Dropzone));
    expect(dropzone.enabled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('default preview fits 375px with no overflow', (tester) async {
    await tester.pumpWidget(
      _frame(Builder(builder: filePickerPreviews[0].builder), width: 375),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('RTL pumps with no exception', (tester) async {
    for (final preview in filePickerPreviews) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        _frame(Builder(builder: preview.builder), direction: TextDirection.rtl),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tester.takeException(), isNull, reason: '${preview.name} RTL');
    }
  });
}
