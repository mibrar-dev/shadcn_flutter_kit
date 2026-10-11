// Throwaway P6-F3d harness (kept): pumps every example of the 12 converted
// components inside a 720x420 box and at 375 wide, under neutral + claude in
// light + dark, asserting nothing throws. P6-F3 owns the generated
// `previews_test.dart`; this file only covers the P6-F3d batch.
//
// NOTE: named `previews_f3d_test.dart` rather than the brief's literal
// `previews_f3.dart` because `flutter test` ignores files without the
// `_test.dart` suffix (same deviation as P6-F3b).
//
// Run with: flutter test test/registry/previews_f3d_test.dart

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import 'themes/generated_theme.dart';

import 'package:flutter_shadcn_kit/registry/components/file_diff_viewer/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/file_picker/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/filter_bar/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/form/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/formatted_input/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/gooey_toast/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/hover_card/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/item_picker/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/markdown/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/menu/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/menubar/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/multi_select/preview.dart';

/// Stage size the docs page hands an example.
const Size _stageSize = Size(720, 420);

/// Width the docs stage collapses to on a phone.
const double _phoneWidth = 375;

/// Preset directory of the registry theme layer.
String get _themesDir => '${Directory.current.path}/lib/registry/themes';

/// Presets every example is pumped under.
const List<String> _presets = <String>['neutral', 'claude'];

/// Brightnesses every example is pumped under.
const List<Brightness> _brightnesses = <Brightness>[
  Brightness.light,
  Brightness.dark,
];

/// component id -> its named examples; the first one is the default.
final Map<String, List<ComponentPreview>> _previews =
    <String, List<ComponentPreview>>{
      'file_diff_viewer': fileDiffViewerPreviews,
      'file_picker': filePickerPreviews,
      'filter_bar': filterBarPreviews,
      'form': formPreviews,
      'formatted_input': formattedInputPreviews,
      'gooey_toast': gooeyToastPreviews,
      'hover_card': hoverCardPreviews,
      'item_picker': itemPickerPreviews,
      'markdown': markdownPreviews,
      'menu': menuPreviews,
      'menubar': menubarPreviews,
      'multi_select': multiSelectPreviews,
    };

/// The example inside the bounded 720x420 stage box.
Widget _stageHost(WidgetBuilder builder) {
  return SizedBox.fromSize(
    size: _stageSize,
    child: Builder(builder: builder),
  );
}

/// The same example inside a 375 wide box.
Widget _phoneHost(WidgetBuilder builder) {
  return SizedBox(
    width: _phoneWidth,
    child: Builder(builder: builder),
  );
}

/// Pumps [example] under [theme] inside [host] and asserts nothing threw.
Future<void> _pump(
  WidgetTester tester,
  ComponentPreview example,
  ShadcnThemeDataView theme,
  Widget host,
) async {
  await tester.pumpWidget(
    ShadcnTheme(
      data: ShadcnThemeData(
        colors: theme.colors,
        tokens: theme.tokens,
        fonts: theme.fonts,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay.wrap(child: Center(child: host)),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 16));
  final Object? exception = tester.takeException();
  expect(
    exception,
    isNull,
    reason: 'example "${example.name}" threw: $exception',
  );
}

void main() {
  test('no P6-F3d preview pins its own theme', () {
    for (final String id in _previews.keys) {
      final String path =
          '${Directory.current.path}/lib/registry/components/$id/preview.dart';
      expect(
        File(path).readAsStringSync().contains('ShadcnThemeData('),
        isFalse,
        reason: '$id/preview.dart hard-codes a theme',
      );
    }
  });

  for (final MapEntry<String, List<ComponentPreview>> entry
      in _previews.entries) {
    group(entry.key, () {
      test('exports at least one named example', () {
        expect(entry.value, isNotEmpty);
      });

      test('example names are unique', () {
        final List<String> names = entry.value
            .map((ComponentPreview example) => example.name)
            .toList();
        expect(names.toSet().length, names.length);
      });

      for (final String preset in _presets) {
        for (final Brightness brightness in _brightnesses) {
          final ShadcnThemeDataView theme = loadGeneratedTheme(
            '$_themesDir/$preset.json',
          ).view(brightness);
          final String brightnessName = brightness.name;
          testWidgets('$preset / $brightnessName', (WidgetTester tester) async {
            for (final ComponentPreview example in entry.value) {
              await _pump(tester, example, theme, _stageHost(example.builder));
              await _pump(tester, example, theme, _phoneHost(example.builder));
            }
          });
        }
      }
    });
  }
}
