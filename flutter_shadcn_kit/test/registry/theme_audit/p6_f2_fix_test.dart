// P6-F2 fix batch: theme-dependent colours + code selectability.
//
// Covers every literal `rearch/reports/p6_theme_audit.json` classifies as
// `fix`, plus the selectability fix, under the three audit presets (neutral,
// claude, tangerine) in light and dark, and across a runtime theme swap.
//
// Two verification paths, same as `component_theme_audit_test.dart`:
//
//  * rendered tree — the theme default must be a token *reference* and the
//    painted tree must contain the resolved token colour;
//  * resolved surface — the edge-fade colours are read off the ambient theme,
//    so the resolved value is asserted against the preset's own token (a
//    shader is opaque to the widget tree).
//
// The `number_ticker` / `overflow_marquee` / `scrollable` fades also assert
// `BlendMode.dstIn`, because that is the actual bug the audit found: a
// white-stop `BlendMode.modulate` mask multiplies colour only, never alpha,
// so nothing faded at all.

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_shadcn_kit/registry/components/code_snippet/code_snippet.dart';
import 'package:flutter_shadcn_kit/registry/components/feature_carousel/feature_carousel.dart';
import 'package:flutter_shadcn_kit/registry/components/gooey_toast/gooey_toast.dart';
import 'package:flutter_shadcn_kit/registry/components/markdown/markdown.dart';
import 'package:flutter_shadcn_kit/registry/components/number_ticker/number_ticker.dart';
import 'package:flutter_shadcn_kit/registry/components/overflow_marquee/overflow_marquee.dart';
import 'package:flutter_shadcn_kit/registry/components/scrollable/scrollable.dart';
import 'package:flutter_shadcn_kit/registry/components/tracker/tracker.dart';
import 'package:flutter_shadcn_kit/registry/primitives/gooey/gooey_surface.dart';
import 'package:flutter_shadcn_kit/registry/theme/color_tokens.dart';
import 'package:flutter_shadcn_kit/registry/theme/syntax_colors.dart';
import 'package:flutter_shadcn_kit/registry/theme/theme.dart';

import 'theme_audit_helpers.dart';

/// Builds the same preset host `pumpUnderPreset` uses, for a re-pump that
/// changes a widget without changing the theme.
Widget buildPresetHost(
  WidgetTester tester, {
  required String presetId,
  required Brightness brightness,
  required Widget child,
}) {
  final view = loadPreset(presetId).view(brightness);
  return ShadcnTheme(
    data: ShadcnThemeData(
      colors: view.colors,
      tokens: view.tokens,
      fonts: view.fonts,
    ),
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Center(child: child),
    ),
  );
}

const List<String> kPresets = [kNeutralPreset, kClaudePreset, kTangerinePreset];

/// The state-tone mapping `gooeyToastDefaults` documents.
const Map<GooeyToastState, ColorRef> gooeyToneRefs =
    <GooeyToastState, ColorRef>{
      GooeyToastState.success: ColorRef.chart1,
      GooeyToastState.loading: ColorRef.mutedForeground,
      GooeyToastState.error: ColorRef.destructive,
      GooeyToastState.warning: ColorRef.chart4,
      GooeyToastState.info: ColorRef.chart2,
      GooeyToastState.action: ColorRef.chart5,
    };

/// Captured `Clipboard.setData` payload, because `Clipboard.getData` has no
/// platform handler in `flutter_test` and never resolves.
Object? _clipboardPayload;

/// Installs the platform-channel handler that captures clipboard writes.
void mockClipboard(WidgetTester tester) {
  _clipboardPayload = null;
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (
        MethodCall call,
      ) async {
        if (call.method == 'Clipboard.setData') {
          _clipboardPayload = (call.arguments as Map<Object?, Object?>)['text'];
        }
        return null;
      });
}

/// Text the last simulated copy wrote to the clipboard.
String? get clipboardText => _clipboardPayload as String?;

/// Reads the `ShaderMaskLayer` painted somewhere below [root].
///
/// A shader is opaque to the widget tree, so the fade mask can only be
/// inspected on the render object that pushed it; `RenderObject.layer` is
/// protected, so the test walks the layer each element exposes in debug mode.
ShaderMaskLayer fadeLayerOf(Element root) {
  final List<ShaderMaskLayer> found = <ShaderMaskLayer>[];
  void visit(Element element) {
    final Object? layer = element.renderObject?.debugLayer;
    if (layer is ShaderMaskLayer) found.add(layer);
    element.visitChildren(visit);
  }

  visit(root);
  expect(found, hasLength(1), reason: 'exactly one fade mask should paint');
  return found.single;
}

void main() {
  group('Gooey toast follows the preset', () {
    testWidgets('state tones resolve to their semantic tokens', (tester) async {
      await pumpUnderPreset(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const SizedBox.shrink(),
      );
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const SizedBox.shrink(),
          );
          final ShadcnColors colors = resolvedTheme(tester).colors;
          for (final entry in gooeyToneRefs.entries) {
            final Color expected = entry.value.resolve(colors);
            final Color actual = entry.key.tone(gooeyToastDefaults, colors);
            expectColor(
              actual,
              expected,
              'gooey_toast ${entry.key.name} tone under $preset $brightness',
            );
          }
        }
      }
    });

    testWidgets('fill and description default to popover tokens', (
      tester,
    ) async {
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const SizedBox.shrink(),
          );
          final ShadcnColors colors = resolvedTheme(tester).colors;
          expectColor(
            gooeyToastDefaults.fill!.resolve(colors),
            colors.popover,
            'gooey_toast fill under $preset $brightness',
          );
          expectColor(
            gooeyToastDefaults.descriptionColor!.resolve(colors),
            colors.popoverForeground,
            'gooey_toast description under $preset $brightness',
          );
        }
      }
    });
  });

  group('Gooey surface default fill', () {
    testWidgets('is the popover token', (tester) async {
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const GooeySurface(
              title: 'Pill',
              titleStyle: gooeyTitleTextStyle,
              morphKey: 'pill',
            ),
          );
          final ShadcnColors colors = resolvedTheme(tester).colors;
          expectColor(
            const GooeySurface(
              title: 'Pill',
              titleStyle: gooeyTitleTextStyle,
              morphKey: 'pill',
            ).fill.resolve(colors),
            colors.popover,
            'gooey_surface default fill under $preset $brightness',
          );
        }
      }
    });
  });

  group('Edge fades dissolve into the surface token', () {
    testWidgets('scrollable fade surface is the background token', (
      tester,
    ) async {
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const FadedScrollableViewport(
              child: SingleChildScrollView(child: Text('scrolling')),
            ),
          );
          final ShadcnColors colors = resolvedTheme(tester).colors;
          final BuildContext context = tester.element(
            find.byType(FadedScrollableViewport),
          );
          expectColor(
            FadedScrollableViewport.resolveFadeSurface(context),
            colors.background,
            'scrollable fade surface under $preset $brightness',
          );
          final ShaderMask mask = tester.widget<ShaderMask>(
            find.byType(ShaderMask).first,
          );
          expect(
            mask.blendMode,
            BlendMode.dstIn,
            reason: 'the mask must reduce alpha, not modulate colour',
          );
        }
      }
    });

    testWidgets('marquee fade surface is the background token', (tester) async {
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const OverflowMarquee(
              child: Text('a much longer piece of marquee content'),
            ),
          );
          final ShadcnColors colors = resolvedTheme(tester).colors;
          final BuildContext context = tester.element(
            find.byType(OverflowMarquee),
          );
          expectColor(
            resolveMarqueeSurface(context).fadeColor,
            colors.background,
            'marquee fade surface under $preset $brightness',
          );
          final ShaderMaskLayer layer = fadeLayerOf(
            tester.element(find.byType(OverflowMarquee)),
          );
          expect(
            layer.blendMode,
            BlendMode.dstIn,
            reason: 'the mask must reduce alpha, not modulate colour',
          );
        }
      }
    });

    testWidgets('number ticker mask fades into the background token', (
      tester,
    ) async {
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          // The mask only exists mid-roll. `FlipperCharset.numbers` gives
          // integer indices 0..9, so rolling one digit to the next leaves a
          // fractional value (and therefore a fade mask) for half the run.
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const TextFlipper(
              charset: FlipperCharset.numbers,
              text: '00',
            ),
          );
          await tester.pumpWidget(
            buildPresetHost(
              tester,
              presetId: preset,
              brightness: brightness,
              child: const TextFlipper(
                charset: FlipperCharset.numbers,
                text: '99',
              ),
            ),
          );
          await tester.pump(const Duration(milliseconds: 250));
          final ShadcnColors colors = resolvedTheme(tester).colors;
          final ShaderMask mask = tester.widget<ShaderMask>(
            find.byType(ShaderMask).first,
          );
          expect(
            mask.blendMode,
            BlendMode.dstIn,
            reason:
                'a white-stop BlendMode.modulate mask never reduces alpha, so '
                'the flipper would not fade at all',
          );
          expectColor(
            FadedScrollableViewport.resolveFadeSurface(
              tester.element(find.byType(TextFlipper)),
            ),
            colors.background,
            'flipper fade surface under $preset $brightness',
          );
        }
      }
    });

    testWidgets('fade follows a runtime theme swap', (tester) async {
      const child = OverflowMarquee(
        child: Text('a much longer piece of marquee content'),
      );
      await pumpUnderPreset(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.dark,
        child: child,
      );
      final Color start = resolvedTheme(tester).colors.background;
      expectColor(
        resolveMarqueeSurface(
          tester.element(find.byType(OverflowMarquee)),
        ).fadeColor,
        start,
        'marquee fade surface before the swap',
      );

      final swap = loadPreset(kClaudePreset).view(Brightness.dark);
      await tester.pumpWidget(
        ShadcnTheme(
          data: ShadcnThemeData(
            colors: swap.colors,
            tokens: swap.tokens,
            fonts: swap.fonts,
          ),
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: child),
          ),
        ),
      );
      await tester.pump(kSettleDuration);

      final Color after = resolvedTheme(tester).colors.background;
      expect(after, isNot(start));
      expectColor(
        resolveMarqueeSurface(
          tester.element(find.byType(OverflowMarquee)),
        ).fadeColor,
        after,
        'marquee fade surface after the swap',
      );
    });
  });

  group('Tracker status tones', () {
    testWidgets('all four levels follow preset tokens', (tester) async {
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const Tracker(
              data: <TrackerData>[
                TrackerData(tooltip: Text('Fine'), level: TrackerLevel.fine),
                TrackerData(
                  tooltip: Text('Warning'),
                  level: TrackerLevel.warning,
                ),
                TrackerData(
                  tooltip: Text('Critical'),
                  level: TrackerLevel.critical,
                ),
                TrackerData(
                  tooltip: Text('Unknown'),
                  level: TrackerLevel.unknown,
                ),
              ],
            ),
          );
          final ShadcnColors colors = resolvedTheme(tester).colors;
          expectColor(
            trackerDefaults.fine!.resolve(colors),
            ColorRef.chart2.resolve(colors),
            'tracker fine under $preset $brightness',
          );
          expectColor(
            trackerDefaults.warning!.resolve(colors),
            ColorRef.chart4.resolve(colors),
            'tracker warning under $preset $brightness',
          );
          expectColor(
            trackerDefaults.critical!.resolve(colors),
            colors.destructive,
            'tracker critical under $preset $brightness',
          );
          expectColor(
            trackerDefaults.unknown!.resolve(colors),
            colors.mutedForeground,
            'tracker unknown under $preset $brightness',
          );
          for (final Color expected in <Color>[
            ColorRef.chart2.resolve(colors),
            ColorRef.chart4.resolve(colors),
            colors.destructive,
            colors.mutedForeground,
          ]) {
            expect(
              hasDecorationColor(tester, expected),
              isTrue,
              reason:
                  'tracker must paint a preset token in $preset $brightness',
            );
          }
        }
      }
    });
  });

  group('Feature carousel elevation', () {
    testWidgets('centre card uses the preset shadow scale', (tester) async {
      for (final preset in kPresets) {
        for (final brightness in Brightness.values) {
          await pumpUnderPreset(
            tester,
            presetId: preset,
            brightness: brightness,
            child: const FeatureCarousel(
              items: <FeatureCarouselItem>[
                FeatureCarouselItem(title: 'One', description: 'first'),
                FeatureCarouselItem(title: 'Two', description: 'second'),
              ],
            ),
          );
          await tester.pump(kSettleDuration);
          final ShadcnThemeData data = resolvedTheme(tester);
          final List<BoxShadow> expected =
              (featureCarouselDefaults.themeShadows ?? data.tokens.shadows)
                  .shadowLg;
          expect(
            expected.isNotEmpty,
            isTrue,
            reason: 'the preset must supply a shadow scale',
          );
          final Container card = tester
              .widgetList<Container>(find.byType(Container))
              .firstWhere((Container container) {
                final BoxDecoration? decoration =
                    container.decoration as BoxDecoration?;
                return decoration != null &&
                    decoration.boxShadow != null &&
                    decoration.boxShadow!.isNotEmpty;
              });
          expect(
            (card.decoration! as BoxDecoration).boxShadow,
            expected,
            reason:
                'card elevation must come from the preset in $preset '
                '$brightness',
          );
        }
      }
    });
  });

  group('Code snippet selection', () {
    testWidgets('select-all copies the source to the clipboard', (
      tester,
    ) async {
      mockClipboard(tester);
      await pumpWithOverlay(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const CodeSnippet(code: Text('const x = 1;')),
      );

      // `Actions` resolves from a context *inside* the region, so the intents
      // the region registers for select-all and copy are found.
      final BuildContext inside = tester.element(
        find.descendant(
          of: find.byType(SelectableRegion),
          matching: find.byType(RichText),
        ),
      );
      expect(
        Actions.maybeFind(inside, intent: CopySelectionTextIntent.copy),
        isNotNull,
        reason: 'the region must offer a copy action for its content',
      );
      expect(
        Actions.maybeFind(
          inside,
          intent: const SelectAllTextIntent(SelectionChangedCause.keyboard),
        ),
        isNotNull,
        reason: 'the region must offer a select-all action',
      );

      // Select-all through the intent the Ctrl/Cmd+A shortcut dispatches.
      Actions.maybeInvoke(
        inside,
        const SelectAllTextIntent(SelectionChangedCause.keyboard),
      );
      await tester.pump(kSettleDuration);
      _clipboardPayload = null;

      // Copy through the intent the Ctrl/Cmd+C shortcut dispatches.
      Actions.maybeInvoke(inside, CopySelectionTextIntent.copy);
      await tester.pump(kSettleDuration);

      expect(
        clipboardText,
        'const x = 1;',
        reason: 'copy must yield the plain source text',
      );
    });

    testWidgets('keeps the syntax colours when highlighted', (tester) async {
      await pumpWithOverlay(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const CodeSnippet(
          code: Text('const greeting = "hello";'),
          language: 'dart',
        ),
      );

      final SyntaxColors palette = resolvedTheme(tester).syntaxColors;
      final Set<int> paletteHues = <int>{
        palette.keyword.toARGB32(),
        palette.type.toARGB32(),
        palette.string.toARGB32(),
        palette.comment.toARGB32(),
        palette.number.toARGB32(),
        palette.plain.toARGB32(),
      };
      final List<Color> tagged = <Color>[];
      void collect(InlineSpan? span) {
        if (span is! TextSpan) return;
        final Color? color = span.style?.color;
        if (color != null && paletteHues.contains(color.toARGB32())) {
          tagged.add(color);
        }
        for (final InlineSpan child in span.children ?? const <InlineSpan>[]) {
          collect(child);
        }
      }

      for (final RichText rich in tester.widgetList<RichText>(
        find.byType(RichText),
      )) {
        collect(rich.text);
      }

      expect(
        tagged,
        isNotEmpty,
        reason: 'syntax colours must survive the selection wrapper',
      );
    });

    testWidgets('markdown fenced code is selectable too', (tester) async {
      await pumpWithOverlay(
        tester,
        presetId: kNeutralPreset,
        brightness: Brightness.light,
        child: const Markdown(data: '```dart\nconst x = 1;\n```'),
      );
      expect(find.byType(SelectableRegion), findsWidgets);
    });
  });
}
