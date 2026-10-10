// The scale pickers of the Theme Studio rail: fonts, radius and
// spacing/density, plus the read-only syntax palette preview (spec §2.7
// requirement 5). The shadow picker lives in `rail_picker_shadow.dart`.
//
// Split out of `rail_pickers.dart` for the ~400-line rule; the popup chrome
// (`showShadcnPicker`), the rows (`RailPickerPanel`, `RailPickerRow`) and the
// scroll reveal (`revealSelectedOnMount`) are shared from their own files.

import 'package:flutter/widgets.dart';

import '../../state/site_theme_model.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/slider/slider.dart';
import '../../ui/shadcn/components/tooltip/tooltip.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/syntax_colors.dart';
import '../../ui/shadcn/primitives/overlay.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_picker_rows.dart';
import 'rail_picker_scroll.dart';
import 'rail_pickers.dart';

/// Shows the family list popup for [slot]; hovering or picking applies live.
///
/// [onChanged] runs for every highlight and pick ('' clears the slot), so
/// the whole site follows while the popup is open. Closing keeps the value.
Future<void> showFontPicker(
  BuildContext context,
  String slot,
  String? current, {
  required ValueChanged<String> onChanged,
}) {
  final List<String> options = <String>{
    ...kDocsFontOptions,
    if (current case final String spec) spec,
  }.toList()..sort();
  String live = current ?? '';
  Widget row(
    StateSetter setState, {
    required String label,
    required String detail,
    required String spec,
    Widget? trailing,
  }) {
    final Widget line = RailPickerRow(
      label: label,
      detail: detail,
      selected: live == spec,
      onHighlight: () {
        setState(() => live = spec);
        onChanged(spec);
      },
      onPick: () {
        setState(() => live = spec);
        onChanged(spec);
        closeOverlay(context);
      },
      trailing: trailing,
    );
    return revealSelectedOnMount(selected: live == spec, child: line);
  }

  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            row(
              setState,
              label: 'Default',
              detail: 'bundled Geist stack',
              spec: '',
            ),
            for (final String option in options)
              row(
                setState,
                label: railFirstFamily(option),
                detail: option,
                spec: option,
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

/// Radius presets (px), after the shadcn scale: 0, 0.25, 0.5, the 0.625 rem
/// neutral default, 0.75 and a full 1 rem.
const List<(String, double)> kRadiusPresets = <(String, double)>[
  ('None', 0),
  ('Small', 4),
  ('Default', 8),
  ('Medium', 10),
  ('Large', 12),
  ('Full', 16),
];

/// Spacing presets (rem): the 0.25 rem default with a step either side.
const List<(String, double)> kSpacingPresets = <(String, double)>[
  ('Compact', 0.2),
  ('Default', 0.25),
  ('Comfortable', 0.3),
];

/// Shows the radius popup: presets plus the fine slider (0–16 px).
///
/// Every interaction applies live through [onChanged]; `Done` only closes.
Future<void> showRadiusPicker(
  BuildContext context,
  double radiusPx, {
  required ValueChanged<double> onChanged,
}) {
  double value = radiusPx.clamp(0, 16);
  bool near(double preset) => (value - preset).abs() < 0.25;
  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void apply(double next) {
            setState(() => value = next);
            onChanged(next);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final (String label, double px) in kRadiusPresets)
                RailPickerRow(
                  label: label,
                  detail: '${px.round()} px',
                  selected: near(px),
                  onHighlight: () => apply(px),
                  onPick: () => apply(px),
                ),
              const Gap(8),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${value.round()} px',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      'radius ${(value / 16).toStringAsFixed(3)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 12,
                        color: ShadcnTheme.of(context).colors.mutedForeground,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(8),
              SizedBox(
                width: kDocsPickerWidth - 24,
                child: Slider(value: value, min: 0, max: 16, onChanged: apply),
              ),
              const Gap(4),
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.sm,
                onPressed: () => closeOverlay(context),
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    ),
  );
}

/// Shows the spacing popup: presets plus the fine slider.
///
/// Every interaction applies live through [onChanged]; `Done` only closes.
Future<void> showSpacingPicker(
  BuildContext context,
  double rem, {
  required ValueChanged<double> onChanged,
}) {
  double value = rem.clamp(0.15, 0.35);
  bool near(double preset) => (value - preset).abs() < 0.005;
  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void apply(double next) {
            setState(() => value = next);
            onChanged(next);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final (String label, double preset) in kSpacingPresets)
                RailPickerRow(
                  label: label,
                  detail: '${(preset * 16).toStringAsFixed(1)} px base',
                  selected: near(preset),
                  onHighlight: () => apply(preset),
                  onPick: () => apply(preset),
                ),
              const Gap(8),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${(value * 16).toStringAsFixed(1)} px base',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 14,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      'spacing ${value.toStringAsFixed(2)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 12,
                        color: ShadcnTheme.of(context).colors.mutedForeground,
                      ),
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
                  onChanged: apply,
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
          );
        },
      ),
    ),
  );
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
