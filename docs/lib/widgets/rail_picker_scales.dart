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
import '../../ui/shadcn/components/tooltip/tooltip.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/theme/syntax_colors.dart';
import '../../ui/shadcn/primitives/overlay.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_picker_rows.dart';
import 'rail_picker_scroll.dart';
import 'rail_picker_slider.dart';
import 'rail_pickers.dart';

/// Shows the family list popup for [slot]; only a pick commits.
///
/// [onChanged] runs exactly once per committed pick ('' clears the slot);
/// hovering, scrolling and arrow-key focus movement stay local. Closing
/// without picking keeps the current value.
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
  final String committed = current ?? '';
  Widget row({
    required String label,
    required String detail,
    required String spec,
    Widget? trailing,
  }) {
    final Widget line = RailPickerRow(
      label: label,
      detail: detail,
      selected: committed == spec,
      onPick: () {
        onChanged(spec);
        closeOverlay(context);
      },
      trailing: trailing,
    );
    return revealSelectedOnMount(selected: committed == spec, child: line);
  }

  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          row(label: 'Default', detail: 'bundled Geist stack', spec: ''),
          for (final String option in options)
            row(
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
/// Preset taps commit immediately (the popup stays open for fine-tuning).
/// Slider drags show locally in the popup and commit once on release
/// ([DraftSlider]); `Done` flushes a keyboard-edited draft, then closes.
/// Escape closes without committing.
Future<void> showRadiusPicker(
  BuildContext context,
  double radiusPx, {
  required ValueChanged<double> onChanged,
}) {
  double applied = radiusPx.clamp(0, 16);
  double shown = applied;
  final GlobalKey<DraftSliderState> sliderKey = GlobalKey<DraftSliderState>();
  bool near(double preset) => (applied - preset).abs() < 0.25;
  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void commit(double next) {
            if (next == applied) {
              return;
            }
            setState(() {
              applied = next;
              shown = next;
            });
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
                  onPick: () => commit(px),
                ),
              const Gap(8),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${shown.round()} px',
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
                      'radius ${(shown / 16).toStringAsFixed(3)}',
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
                child: DraftSlider(
                  key: sliderKey,
                  value: applied,
                  min: 0,
                  max: 16,
                  onCommit: commit,
                  onDraft: (double draft) => setState(() => shown = draft),
                ),
              ),
              const Gap(4),
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.sm,
                onPressed: () {
                  sliderKey.currentState?.flush();
                  closeOverlay(context);
                },
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
/// Same commit contract as the radius popup: preset taps commit, slider
/// drags stay local until release, `Done` flushes then closes.
Future<void> showSpacingPicker(
  BuildContext context,
  double rem, {
  required ValueChanged<double> onChanged,
}) {
  double applied = rem.clamp(0.15, 0.35);
  double shown = applied;
  final GlobalKey<DraftSliderState> sliderKey = GlobalKey<DraftSliderState>();
  bool near(double preset) => (applied - preset).abs() < 0.005;
  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void commit(double next) {
            if (next == applied) {
              return;
            }
            setState(() {
              applied = next;
              shown = next;
            });
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
                  onPick: () => commit(preset),
                ),
              const Gap(8),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      '${(shown * 16).toStringAsFixed(1)} px base',
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
                      'spacing ${shown.toStringAsFixed(2)}',
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
                child: DraftSlider(
                  value: applied,
                  key: sliderKey,
                  min: 0.15,
                  max: 0.35,
                  onCommit: commit,
                  onDraft: (double draft) => setState(() => shown = draft),
                ),
              ),
              const Gap(4),
              Button(
                variant: ButtonVariant.secondary,
                size: ButtonSize.sm,
                onPressed: () {
                  sliderKey.currentState?.flush();
                  closeOverlay(context);
                },
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
