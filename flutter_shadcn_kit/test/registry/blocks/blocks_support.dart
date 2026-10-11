// Shared harness for the block tests (`test/registry/blocks/**`).
//
// A block is the layer-4 unit of the registry: `lib/registry/blocks/<id>/`
// with `<underscored id>.dart` (the public widget, which is also the
// preview), `meta.json` and `README.md`. Every block must pump, without a
// single exception or overflow, at 375 / 768 / 1440 wide, under the neutral
// and claude presets in light and dark.

import 'package:flutter/widgets.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

import '../themes/generated_theme.dart';

/// Widths every block is pumped at: phone, tablet, desktop.
const List<double> blockWidths = <double>[375, 768, 1440];

/// Height the stage hands a block; a block must never assume more.
const double blockStageHeight = 900;

/// Presets every block is pumped under.
const List<String> blockPresets = <String>['neutral', 'claude'];

/// Brightnesses every block is pumped under.
const List<Brightness> blockBrightnesses = <Brightness>[
  Brightness.light,
  Brightness.dark,
];

/// Theme view of [preset] at [brightness].
ShadcnThemeDataView blockTheme(String preset, Brightness brightness) =>
    loadGeneratedTheme('lib/registry/themes/$preset.json').view(brightness);

/// Pumps [child] inside a bounded `width` × [blockStageHeight] stage under
/// [theme], and asserts nothing threw and nothing overflowed.
///
/// The host mirrors what the docs page and an app give a block: a
/// `Directionality` and an `Overlay` above it, because an input field needs
/// the overlay to exist.
Future<void> pumpBlock(
  WidgetTester tester,
  Widget child,
  ShadcnThemeDataView theme,
  double width,
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
        child: Overlay.wrap(
          child: Center(
            child: SizedBox(
              width: width,
              height: blockStageHeight,
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  // A second frame: focus and overlay work lands after the mounting frame.
  await tester.pump(const Duration(milliseconds: 16));
  final Object? exception = tester.takeException();
  expect(exception, isNull, reason: 'block at ${width}px threw: $exception');
}
