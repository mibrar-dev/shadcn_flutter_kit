// The shadow picker of the Theme Studio rail.
//
// Split out of `rail_picker_scales.dart` for the ~400-line rule: shadow
// presets plus the fine sliders. Preset taps commit; slider drags stay local
// until release; `Done` flushes keyboard-edited drafts, then closes.

import 'package:flutter/widgets.dart';

import '../../theme/theme_document.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/primitives/overlay.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_picker_rows.dart';
import 'rail_picker_slider.dart';
import 'rail_pickers.dart';

/// Shadow presets, as adjustments over the current atoms (colour and
/// horizontal offset are kept). `Default` restores the neutral atoms.
DocsShadowAtoms _shadowPreset(DocsShadowAtoms base, String name) {
  switch (name) {
    case 'None':
      return base.copyWith(opacity: 0);
    case 'Subtle':
      return base.copyWith(opacity: 0.05, blur: 4, spread: -1, offsetY: 2);
    case 'Strong':
      return base.copyWith(opacity: 0.2, blur: 16, spread: -2, offsetY: 8);
    case 'Default':
    default:
      return base.copyWith(opacity: 0.1, blur: 8, spread: -1, offsetY: 4);
  }
}

/// Shows the shadow panel: presets plus opacity/blur sliders.
///
/// Preset taps commit immediately (the popup stays open for fine-tuning).
/// Slider drags show locally and commit once on release; `Done` flushes
/// keyboard-edited drafts, then closes. Escape closes without committing.
Future<void> showShadowPicker(
  BuildContext context,
  DocsShadowAtoms atoms, {
  required bool dark,
  required ValueChanged<DocsShadowAtoms> onChanged,
}) {
  DocsShadowAtoms applied = atoms;
  DocsShadowAtoms shown = atoms;
  final List<GlobalKey<DraftSliderState>> sliderKeys =
      <GlobalKey<DraftSliderState>>[
        for (int i = 0; i < 4; i++) GlobalKey<DraftSliderState>(),
      ];
  bool nearPreset(String name) {
    final DocsShadowAtoms preset = _shadowPreset(atoms, name);
    return (applied.opacity - preset.opacity).abs() < 0.005 &&
        (applied.blur - preset.blur).abs() < 0.25 &&
        (applied.spread - preset.spread).abs() < 0.25 &&
        (applied.offsetY - preset.offsetY).abs() < 0.25;
  }

  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void commit(DocsShadowAtoms next) {
            setState(() {
              applied = next;
              shown = next;
            });
            onChanged(next);
          }

          double fieldOf(DocsShadowAtoms a, String field) => switch (field) {
            'Opacity' => a.opacity,
            'Blur' => a.blur,
            'Spread' => a.spread,
            _ => a.offsetY,
          };

          DocsShadowAtoms withField(
            DocsShadowAtoms a,
            String field,
            double next,
          ) => switch (field) {
            'Opacity' => a.copyWith(opacity: next),
            'Blur' => a.copyWith(blur: next),
            'Spread' => a.copyWith(spread: next),
            _ => a.copyWith(offsetY: next),
          };

          const List<(String, double, double)> sliderFields =
              <(String, double, double)>[
                ('Opacity', 0, 0.4),
                ('Blur', 0, 40),
                ('Spread', -20, 10),
                ('Offset Y', 0, 12),
              ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final String name in const <String>[
                'None',
                'Subtle',
                'Default',
                'Strong',
              ])
                RailPickerRow(
                  label: name,
                  detail: name == 'None'
                      ? 'no shadow'
                      : 'opacity ${_shadowPreset(atoms, name).opacity.toStringAsFixed(2)}',
                  selected: nearPreset(name),
                  onPick: () => commit(_shadowPreset(atoms, name)),
                ),
              const Gap(8),
              for (int i = 0; i < sliderFields.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          sliderFields[i].$1,
                          style: docsText(context, size: 12),
                        ),
                        const Spacer(),
                        Text(
                          fieldOf(shown, sliderFields[i].$1).toStringAsFixed(2),
                          style: docsText(
                            context,
                            size: 12,
                            color: ShadcnTheme.of(
                              context,
                            ).colors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: kDocsPickerWidth - 24,
                      child: DraftSlider(
                        key: sliderKeys[i],
                        value: fieldOf(applied, sliderFields[i].$1)
                            .clamp(sliderFields[i].$2, sliderFields[i].$3)
                            .toDouble(),
                        min: sliderFields[i].$2,
                        max: sliderFields[i].$3,
                        onCommit: (double next) => commit(
                          withField(applied, sliderFields[i].$1, next),
                        ),
                        onDraft: (double next) => setState(
                          () => shown = withField(
                            shown,
                            sliderFields[i].$1,
                            next,
                          ),
                        ),
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
                onPressed: () {
                  for (final GlobalKey<DraftSliderState> key in sliderKeys) {
                    key.currentState?.flush();
                  }
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
