// The shadow picker of the Theme Studio rail.
//
// Split out of `rail_picker_scales.dart` for the ~400-line rule: shadow
// presets plus the fine sliders. Every interaction applies live; `Done`
// only closes.

import 'package:flutter/widgets.dart';

import '../../theme/theme_document.dart';
import '../../ui/shadcn/components/button/button.dart';
import '../../ui/shadcn/components/slider/slider.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/primitives/overlay.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_picker_rows.dart';
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
/// Every interaction applies live through [onChanged]; `Done` only closes.
Future<void> showShadowPicker(
  BuildContext context,
  DocsShadowAtoms atoms, {
  required bool dark,
  required ValueChanged<DocsShadowAtoms> onChanged,
}) {
  DocsShadowAtoms value = atoms;
  bool nearPreset(String name) {
    final DocsShadowAtoms preset = _shadowPreset(atoms, name);
    return (value.opacity - preset.opacity).abs() < 0.005 &&
        (value.blur - preset.blur).abs() < 0.25 &&
        (value.spread - preset.spread).abs() < 0.25 &&
        (value.offsetY - preset.offsetY).abs() < 0.25;
  }

  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          void update(DocsShadowAtoms next) {
            setState(() => value = next);
            onChanged(next);
          }

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
                  onHighlight: () => update(_shadowPreset(atoms, name)),
                  onPick: () => update(_shadowPreset(atoms, name)),
                ),
              const Gap(8),
              for (final (String label, double value, double min, double max)
                  row
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
                            color: ShadcnTheme.of(
                              context,
                            ).colors.mutedForeground,
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
                        onChanged: (double next) => update(switch (row.$1) {
                          'Opacity' => value.copyWith(opacity: next),
                          'Blur' => value.copyWith(blur: next),
                          'Spread' => value.copyWith(spread: next),
                          _ => value.copyWith(offsetY: next),
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
          );
        },
      ),
    ),
  );
}
