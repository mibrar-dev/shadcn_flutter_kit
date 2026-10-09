// The scale pickers of the Theme Studio rail: fonts, radius, spacing/density
// and shadows, plus the read-only syntax palette preview (spec §2.7
// requirement 5).
//
// Split out of `rail_pickers.dart` for the ~400-line rule; the popup chrome
// (`showShadcnPicker`, `RailPickerPanel`, `RailPickerRow`) is shared from
// there.

import 'package:flutter/widgets.dart';

import '../../state/site_theme_model.dart';
import '../../theme/theme_document.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/slider/slider.dart';
import '../../ui/shadcn/components/tooltip/tooltip.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/syntax_colors.dart';
import '../../ui/shadcn/primitives/overlay.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_pickers.dart';

/// Shows the family list popup for [slot] and returns the picked family list.
Future<String?> showFontPicker(
  BuildContext context,
  String slot,
  String? current,
) {
  final List<String> options = <String>{
    ...kDocsFontOptions,
    if (current case final String spec) spec,
  }.toList()..sort();
  return showShadcnPicker<String>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RailPickerRow(
              label: 'Default',
              detail: 'bundled Geist stack',
              selected: current == null,
              onPick: () => closeOverlay(context, ''),
            ),
            for (final String option in options)
              RailPickerRow(
                label: railFirstFamily(option),
                detail: option,
                selected: option == current,
                onPick: () => closeOverlay(context, option),
                trailing: Text(
                  'Aa',
                  style: docsText(
                    context,
                    size: 16,
                    color: ShadcnTheme.of(context).colors.mutedForeground,
                  ).copyWith(fontFamily: railFirstFamily(option)),
                ),
              ),
          ],
        ),
      ),
    ),
    title: '$slot family',
  );
}

/// Shows the radius slider popup (0–16 px, as the reference's Radius row).
Future<double?> showRadiusPicker(BuildContext context, double radiusPx) {
  double value = radiusPx.clamp(0, 16);
  return showShadcnPicker<double>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '${value.round()} px',
                  style: docsText(context, size: 14, weight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  'radius ${(value / 16).toStringAsFixed(3)}',
                  style: docsText(
                    context,
                    size: 12,
                    color: ShadcnTheme.of(context).colors.mutedForeground,
                  ),
                ),
              ],
            ),
            const Gap(8),
            SizedBox(
              width: kDocsPickerWidth - 24,
              child: Slider(
                value: value,
                min: 0,
                max: 16,
                onChanged: (double next) => setState(() => value = next),
              ),
            ),
            const Gap(4),
            Button(
              variant: ButtonVariant.secondary,
              size: ButtonSize.sm,
              onPressed: () => closeOverlay(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    ),
  ).then((double? picked) => picked ?? value);
}

/// Shows the spacing slider popup (the density/spacing row).
Future<double?> showSpacingPicker(BuildContext context, double rem) {
  double value = rem.clamp(0.15, 0.35);
  return showShadcnPicker<double>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '${(value * 16).toStringAsFixed(1)} px base',
                  style: docsText(context, size: 14, weight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  'spacing ${value.toStringAsFixed(2)}',
                  style: docsText(
                    context,
                    size: 12,
                    color: ShadcnTheme.of(context).colors.mutedForeground,
                  ),
                ),
              ],
            ),
            const Gap(8),
            SizedBox(
              width: kDocsPickerWidth - 24,
              child: Slider(
                value: value,
                min: 0.15,
                max: 0.35,
                onChanged: (double next) => setState(() => value = next),
              ),
            ),
            const Gap(4),
            Button(
              variant: ButtonVariant.secondary,
              size: ButtonSize.sm,
              onPressed: () => closeOverlay(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    ),
  ).then((double? picked) => picked ?? value);
}

/// Shows the shadow panel: opacity and blur sliders for the live mode.
Future<DocsShadowAtoms?> showShadowPicker(
  BuildContext context,
  DocsShadowAtoms atoms, {
  required bool dark,
}) {
  DocsShadowAtoms value = atoms;
  void update(DocsShadowAtoms next) => value = next;
  return showShadcnPicker<DocsShadowAtoms>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final (String label, double value, double min, double max) row
                in <(String, double, double, double)>[
                  ('Opacity', value.opacity, 0, 0.4),
                  ('Blur', value.blur, 0, 40),
                  ('Spread', value.spread, -20, 10),
                  ('Offset Y', value.offsetY, 0, 12),
                ])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(row.$1, style: docsText(context, size: 12)),
                      const Spacer(),
                      Text(
                        row.$2.toStringAsFixed(2),
                        style: docsText(
                          context,
                          size: 12,
                          color: ShadcnTheme.of(context).colors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: kDocsPickerWidth - 24,
                    child: Slider(
                      value: row.$2.clamp(row.$3, row.$4),
                      min: row.$3,
                      max: row.$4,
                      onChanged: (double next) => setState(() {
                        update(switch (row.$1) {
                          'Opacity' => value.copyWith(opacity: next),
                          'Blur' => value.copyWith(blur: next),
                          'Spread' => value.copyWith(spread: next),
                          _ => value.copyWith(offsetY: next),
                        });
                      }),
                    ),
                  ),
                ],
              ),
            const Gap(8),
            Text(
              dark ? 'dark mode atoms' : 'light mode atoms',
              style: docsText(
                context,
                size: 12,
                color: ShadcnTheme.of(context).colors.mutedForeground,
              ),
            ),
            const Gap(4),
            Button(
              variant: ButtonVariant.secondary,
              size: ButtonSize.sm,
              onPressed: () => closeOverlay(context),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    ),
  ).then((DocsShadowAtoms? picked) => picked ?? value);
}

/// The read-only syntax palette preview (requirement 5).
///
/// `syntaxColors` is a docs-app override, not a preset token group, so the row
/// previews the palette the code blocks actually use instead of editing a
/// value the exported `app_theme.dart` could not carry.
class SyntaxPalettePreview extends StatelessWidget {
  /// Creates the preview.
  const SyntaxPalettePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final SyntaxColors syntax = theme.syntaxColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'read-only · ${theme.brightness == Brightness.dark ? 'dark' : 'light'}'
          ' shiki palette',
          style: docsText(
            context,
            size: 11,
            color: theme.colors.mutedForeground,
          ),
        ),
        const Gap(8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: <Widget>[
            for (final SyntaxTokenKind kind in SyntaxTokenKind.values)
              Tooltip(
                tooltip: (BuildContext context) => Text(kind.name),
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: syntax.colorFor(kind),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: theme.colors.border),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// The first family of a CSS family list (`"Lora", Georgia, serif`); this is
/// also the short label the font picker shows.
String railFirstFamily(String spec) => spec
    .split(',')
    .map((String part) => part.trim().replaceAll('"', ''))
    .firstWhere((String part) => part.isNotEmpty, orElse: () => spec);
