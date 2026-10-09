// Widget tests for the `file_picker` component.
//
// Covers every variant, the localized defaults, the pick -> validate -> upload
// flow (controlled and uncontrolled), theme precedence on all four legs, light
// and dark tokens, sizes against the shadcn scale, keyboard activation, and a
// regression test per old bug that was fixed.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/components/button/button.dart';
import 'package:flutter_shadcn_kit/registry/components/dropzone/dropzone.dart';
import 'package:flutter_shadcn_kit/registry/components/file_picker/file_picker.dart';
import 'package:flutter_shadcn_kit/registry/foundation/icons/radix_icons.dart';
import 'package:flutter_shadcn_kit/registry/components/progress/progress.dart';
import 'package:flutter_shadcn_kit/registry/primitives/clickable.dart';
import 'package:flutter_shadcn_kit/registry/primitives/file_value/file_upload_controller.dart';
import 'package:flutter_shadcn_kit/registry/primitives/file_value/file_upload_row.dart';
import 'package:flutter_shadcn_kit/registry/primitives/file_value/file_validation.dart';
import 'package:flutter_shadcn_kit/registry/primitives/file_value/file_value.dart';
import 'package:flutter_shadcn_kit/registry/primitives/localizations/localizations.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

const Color _red = Color(0xFFFF0000);
const Color _green = Color(0xFF00FF00);

Widget _frame({
  required Widget child,
  ShadcnThemeData data = const ShadcnThemeData(),
  List<ComponentThemeData> app = const <ComponentThemeData>[],
  FileUploadTheme? scoped,
  Locale? locale,
}) {
  Widget body = child;
  if (scoped != null) {
    body = ComponentTheme<FileUploadTheme>(data: scoped, child: body);
  }
  Widget root = ShadcnTheme(
    data: data,
    child: ComponentThemes(
      themes: app,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(width: 480, child: body)),
      ),
    ),
  );
  if (locale != null) {
    root = Localizations(
      locale: locale,
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
        ShadcnLocalizations.delegate,
      ],
      child: root,
    );
  }
  return root;
}

FileValue _value(String name, {int size = 100, String? mime}) {
  return FileValue(id: name, name: name, size: size, mimeType: mime);
}

Future<List<FileValue>> _pickFiles(List<FileValue> files) async => files;

Color _tileBorder(WidgetTester tester) {
  final Container tile = tester.widget<Container>(
    find.byKey(fileUploadTileKey),
  );
  return (tile.decoration! as BoxDecoration).border!.top.color;
}

void main() {
  group('variants', () {
    testWidgets('dragDrop renders the dropzone with its localized status', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: FileUpload(pick: (r) => _pickFiles(const []))),
      );
      expect(find.byType(Dropzone), findsOneWidget);
      expect(find.text('Browse to upload files'), findsOneWidget);
    });

    testWidgets('tile renders the choose label and the empty selection', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            variant: FileUploadVariant.tile,
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(find.text('Choose file'), findsOneWidget);
      expect(find.text('No file chosen'), findsOneWidget);
    });

    testWidgets('mobile renders a 36-high outline button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            variant: FileUploadVariant.mobile,
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(find.byType(Button), findsOneWidget);
      expect(tester.getSize(find.byType(Button)).height, 36);
    });

    testWidgets('disabled tile ignores taps', (WidgetTester tester) async {
      int picks = 0;
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            variant: FileUploadVariant.tile,
            enabled: false,
            pick: (r) {
              picks += 1;
              return _pickFiles(const []);
            },
          ),
        ),
      );
      await tester.tap(find.text('Choose file'));
      await tester.pump();
      expect(picks, 0);
    });
  });

  group('pick flow', () {
    testWidgets('a pick adds rows and reports the full list', (
      WidgetTester tester,
    ) async {
      List<FileValue>? changed;
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            pick: (r) => _pickFiles([_value('a.pdf'), _value('b.png')]),
            onFilesChanged: (files) => changed = files,
          ),
        ),
      );
      await tester.tap(find.text('Browse files'));
      await tester.pumpAndSettle();
      expect(find.byType(FileUploadRow), findsNWidgets(2));
      expect(find.text('a.pdf'), findsOneWidget);
      expect(changed!.length, 2);
    });

    testWidgets('validation rejects and reports the localized error', (
      WidgetTester tester,
    ) async {
      FileError? error;
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            constraints: const FileConstraints(
              allowMultiple: true,
              maxFiles: 1,
            ),
            pick: (r) => _pickFiles([_value('a.pdf'), _value('b.png')]),
            onError: (FileError value) => error = value,
          ),
        ),
      );
      await tester.tap(find.text('Browse files'));
      await tester.pumpAndSettle();
      expect(find.byType(FileUploadRow), findsOneWidget);
      expect(error!.code, FileErrorCode.tooMany);
      expect(find.text('Too many files selected.'), findsOneWidget);
    });

    testWidgets('a throwing picker reports a localized failure', (
      WidgetTester tester,
    ) async {
      FileError? error;
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            pick: (r) => Future<List<FileValue>>.error(StateError('boom')),
            onError: (FileError value) => error = value,
          ),
        ),
      );
      await tester.tap(find.text('Browse files'));
      await tester.pumpAndSettle();
      expect(error!.message, 'File picking failed.');
      expect(find.text('File picking failed.'), findsOneWidget);
    });

    testWidgets('remove drops the row and reports the new list', (
      WidgetTester tester,
    ) async {
      List<FileValue>? changed;
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            pick: (r) => _pickFiles([_value('a.pdf')]),
            onFilesChanged: (files) => changed = files,
          ),
        ),
      );
      await tester.tap(find.text('Browse files'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(RadixIcons.cross1));
      await tester.pumpAndSettle();
      expect(find.byType(FileUploadRow), findsNothing);
      expect(changed, isEmpty);
    });
  });

  group('upload flow', () {
    testWidgets('progress reaches the row and completion fires once', (
      WidgetTester tester,
    ) async {
      final StreamController<double> stream = StreamController<double>();
      List<FileValue>? completed;
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            pick: (r) => _pickFiles([_value('a.pdf')]),
            upload: (FileValue file) => stream.stream,
            onComplete: (files) => completed = files,
          ),
        ),
      );
      await tester.tap(find.text('Browse files'));
      await tester.pump();
      stream.add(0.5);
      await tester.pump();
      expect(find.byType(Progress), findsOneWidget);
      expect(tester.widget<Progress>(find.byType(Progress)).value, 0.5);
      stream.add(1);
      await stream.close();
      await tester.pumpAndSettle();
      expect(find.textContaining('Completed'), findsOneWidget);
      expect(completed!.single.name, 'a.pdf');
    });

    testWidgets('a failed upload shows Retry and re-queues the file', (
      WidgetTester tester,
    ) async {
      int calls = 0;
      final List<StreamController<double>> streams =
          <StreamController<double>>[];
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            pick: (r) => _pickFiles([_value('a.pdf')]),
            upload: (FileValue file) {
              calls += 1;
              final StreamController<double> controller =
                  StreamController<double>();
              streams.add(controller);
              return controller.stream;
            },
          ),
        ),
      );
      await tester.tap(find.text('Browse files'));
      await tester.pump();
      streams.first.addError(StateError('network'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Failed'), findsOneWidget);
      await tester.tap(find.byIcon(RadixIcons.update));
      await tester.pump();
      expect(calls, 2);
    });
  });

  group('controller mode', () {
    testWidgets('an external controller drives the list', (
      WidgetTester tester,
    ) async {
      final FileUploadController controller = FileUploadController(
        initialItems: <FileItem>[
          FileItem(file: _value('external.txt'), status: FileStatus.success),
        ],
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(child: FileUpload(controller: controller)),
      );
      expect(find.text('external.txt'), findsOneWidget);
      controller.addFiles(<FileValue>[_value('later.txt')]);
      await tester.pump();
      expect(find.text('later.txt'), findsOneWidget);
    });

    testWidgets('the internal controller is uncontrolled', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: FileUpload(pick: (r) => _pickFiles([_value('a.pdf')]))),
      );
      expect(find.byType(FileUploadRow), findsNothing);
      await tester.tap(find.text('Browse files'));
      await tester.pumpAndSettle();
      expect(find.byType(FileUploadRow), findsOneWidget);
    });
  });

  group('theme', () {
    testWidgets('defaults use the input token in light and dark', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            variant: FileUploadVariant.tile,
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(_tileBorder(tester), ShadcnColors.lightFallback.input);
      await tester.pumpWidget(
        _frame(
          data: const ShadcnThemeData(colors: ShadcnColors.darkFallback),
          child: FileUpload(
            variant: FileUploadVariant.tile,
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(_tileBorder(tester), ShadcnColors.darkFallback.input);
    });

    testWidgets('all four precedence legs resolve in order', (
      WidgetTester tester,
    ) async {
      const FileUploadTheme app = FileUploadTheme(
        borderColor: ThemedColor.value(_red),
      );
      const FileUploadTheme scoped = FileUploadTheme(
        borderColor: ThemedColor.value(_green),
      );
      // Defaults.
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            variant: FileUploadVariant.tile,
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(_tileBorder(tester), ShadcnColors.lightFallback.input);
      // App leg.
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[app],
          child: FileUpload(
            variant: FileUploadVariant.tile,
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(_tileBorder(tester), _red);
      // Tree leg beats the app leg.
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[app],
          scoped: scoped,
          child: FileUpload(
            variant: FileUploadVariant.tile,
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(_tileBorder(tester), _green);
      // Widget leg beats the tree leg.
      await tester.pumpWidget(
        _frame(
          app: const <ComponentThemeData>[app],
          scoped: scoped,
          child: FileUpload(
            variant: FileUploadVariant.tile,
            theme: const FileUploadTheme(borderColor: ThemedColor.value(_red)),
            pick: (r) => _pickFiles(const []),
          ),
        ),
      );
      expect(_tileBorder(tester), _red);
    });
  });

  group('sizes', () {
    testWidgets('the tile is 48 high and a row is 64 high', (
      WidgetTester tester,
    ) async {
      final FileUploadController controller = FileUploadController(
        initialItems: <FileItem>[FileItem(file: _value('a.pdf'))],
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            variant: FileUploadVariant.tile,
            controller: controller,
          ),
        ),
      );
      expect(tester.getSize(find.byKey(fileUploadTileKey)).height, 48);
      expect(tester.getSize(find.byType(FileUploadRow)).height, 64);
    });

    testWidgets('the mobile trigger is 36 high (shadcn h-9)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _frame(child: FileUpload(variant: FileUploadVariant.mobile)),
      );
      expect(tester.getSize(find.byType(Button)).height, 36);
    });
  });

  group('keyboard', () {
    testWidgets('Enter on the focused dropzone picks files', (
      WidgetTester tester,
    ) async {
      int picks = 0;
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            pick: (r) {
              picks += 1;
              return _pickFiles(const []);
            },
          ),
        ),
      );
      final FocusableActionDetector detector = tester
          .widget<FocusableActionDetector>(
            find.byType(FocusableActionDetector).first,
          );
      expect(
        detector.shortcuts!.keys.any(
          (ShortcutActivator activator) =>
              activator is SingleActivator &&
              activator.trigger == LogicalKeyboardKey.enter,
        ),
        isTrue,
      );
      expect(detector.actions![ActivateIntent], isNotNull);
      Actions.invoke(
        tester.element(find.byType(Dropzone)),
        const ActivateIntent(),
      );
      await tester.pumpAndSettle();
      expect(picks, 1);
    });
  });

  group('regressions', () {
    test('a status change keeps a running progress value', () {
      const FileItem item = FileItem(
        file: FileValue(id: 'a', name: 'a.pdf', size: 1),
        status: FileStatus.uploading,
        progress: 0.4,
      );
      final FileItem next = item.copyWith(status: FileStatus.uploading);
      expect(next.progress, 0.4);
      expect(
        next.copyWith(status: FileStatus.error, resetProgress: true).progress,
        isNull,
      );
    });

    test('validation still checks files after the count is exceeded', () {
      final FileValidationResult result = validateFiles(
        incoming: <FileValue>[
          _value('a.pdf', size: 10),
          _value('b.pdf', size: 999999),
          _value('c.pdf', size: 10),
        ],
        existing: const <FileValue>[],
        constraints: const FileConstraints(maxFiles: 1, maxFileSizeBytes: 100),
        onError: (FileErrorCode code, FileValue? file) => code.name,
      );
      expect(result.accepted.single.name, 'a.pdf');
      expect(
        result.errors.map((FileError error) => error.code),
        containsAll(<FileErrorCode>[
          FileErrorCode.tooMany,
          FileErrorCode.tooLarge,
        ]),
      );
    });
  });

  group('items view (F2 restores)', () {
    FileUploadController three() => FileUploadController(
      initialItems: <FileItem>[
        FileItem(file: _value('a.pdf'), status: FileStatus.success),
        FileItem(file: _value('b.png'), status: FileStatus.error),
        FileItem(file: _value('c.pdf'), status: FileStatus.success),
      ],
    );

    testWidgets('grid lays rows out in columns', (WidgetTester tester) async {
      final FileUploadController controller = three();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            controller: controller,
            layout: FileUploadItemsLayout.grid,
            gridColumns: 2,
          ),
        ),
      );
      expect(find.byType(FileUploadItemsView), findsOneWidget);
      final Size first = tester.getSize(find.byType(FileUploadRow).at(0));
      expect(first.width, closeTo((480 - 12) / 2, 0.01));
      expect(
        tester.getTopLeft(find.byType(FileUploadRow).at(1)).dy,
        tester.getTopLeft(find.byType(FileUploadRow).at(0)).dy,
      );
      expect(
        tester.getTopLeft(find.byType(FileUploadRow).at(2)).dy,
        greaterThan(tester.getTopLeft(find.byType(FileUploadRow).at(0)).dy),
      );
    });

    testWidgets('groupKey renders sections with counts', (
      WidgetTester tester,
    ) async {
      final FileUploadController controller = three();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            controller: controller,
            groupKey: (FileItem item) => item.status.name,
          ),
        ),
      );
      expect(find.text('success (2)'), findsOneWidget);
      expect(find.text('error (1)'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('success (2)')).dy,
        lessThan(tester.getTopLeft(find.text('error (1)')).dy),
      );
    });

    testWidgets('a custom group header builder is used', (
      WidgetTester tester,
    ) async {
      final FileUploadController controller = three();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            controller: controller,
            groupKey: (FileItem item) => item.file.resolvedExtension,
            groupHeaderBuilder: (BuildContext context, String key) =>
                Text('GROUP:$key'),
          ),
        ),
      );
      expect(find.text('GROUP:pdf'), findsOneWidget);
      expect(find.text('GROUP:png'), findsOneWidget);
    });

    testWidgets('iconBuilder replaces the default row icon', (
      WidgetTester tester,
    ) async {
      final FileUploadController controller = FileUploadController(
        initialItems: <FileItem>[FileItem(file: _value('a.pdf'))],
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        _frame(
          child: FileUpload(
            controller: controller,
            iconBuilder: (String extension) => Text('icon:$extension'),
          ),
        ),
      );
      expect(find.text('icon:pdf'), findsOneWidget);
    });
  });
}
