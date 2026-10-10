// Throwaway P6-F3c harness (kept): pumps every example of the 19 converted
// components inside a 720x420 box and at 375 wide, under neutral + claude in
// light + dark, asserting nothing throws. P6-F3 owns the generated
// `previews_test.dart`; this file only covers the P6-F3c batch.
//
// Run with: flutter test test/registry/previews_f3.dart

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/foundation/component_preview.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import 'themes/generated_theme.dart';

import 'package:flutter_shadcn_kit/registry/components/spell_check_suggestions_toolbar/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/stage_container/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/star_rating/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/stepper/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/steps/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/swiper/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/switch/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/switcher/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/table/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/tabs/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/text_animate/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/text_area/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/time_picker/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/timeline/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/toast/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/tooltip/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/tracker/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/tree/preview.dart';
import 'package:flutter_shadcn_kit/registry/components/window/preview.dart';

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
      'spell_check_suggestions_toolbar': spellCheckSuggestionsToolbarPreviews,
      'stage_container': stageContainerPreviews,
      'star_rating': starRatingPreviews,
      'stepper': stepperPreviews,
      'steps': stepsPreviews,
      'swiper': swiperPreviews,
      'switch': switchPreviews,
      'switcher': switcherPreviews,
      'table': tablePreviews,
      'tabs': tabsPreviews,
      'text_animate': textAnimatePreviews,
      'text_area': textAreaPreviews,
      'time_picker': timePickerPreviews,
      'timeline': timelinePreviews,
      'toast': toastPreviews,
      'tooltip': tooltipPreviews,
      'tracker': trackerPreviews,
      'tree': treePreviews,
      'window': windowPreviews,
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
  test('no P6-F3c preview pins its own theme', () {
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
