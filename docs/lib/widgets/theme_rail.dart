// The themes customizer rail (spec §2.7): a 192 px left column listing the
// 42 presets (id + 4 swatches + mode), a radius slider row, a mode toggle,
// and footer actions (Copy JSON / Copy Dart / Shuffle / Get Code). The rail
// drives [DocsState]; the live preview area re-themes through
// AnimatedShadcnTheme.

import 'dart:math';

import 'package:flutter/widgets.dart';

import '../generated/docs_data.dart';
import '../generated/app_theme.dart';
import '../state/docs_state.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/components/slider/slider.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/theme/color_tokens.dart';
import '../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';

/// The 192 px customizer rail (spec §2.7).
class ThemeRail extends StatelessWidget {
  /// Creates the rail.
  const ThemeRail({super.key, required this.state});

  /// The docs theme state (preset, radius, mode).
  final DocsState state;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return SizedBox(
      width: 192,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.card,
          border: Border(right: BorderSide(color: theme.colors.border)),
        ),
        child: Column(
          children: <Widget>[
            // Header.
            Container(
              height: 49,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.colors.border)),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'Menu',
                    style: docsText(context, size: 14, weight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Icon(LucideIcons.chevronLeft, size: 16),
                ],
              ),
            ),
            // Scrollable preset list.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final DocsPreset preset in kPresets)
                      _PresetRow(
                        preset: preset,
                        active: preset.id == state.presetId,
                        onTap: () => state.setPreset(preset.id),
                      ),
                    const Gap(16),
                    // Radius row.
                    Text(
                      'Radius',
                      style: docsText(
                        context,
                        size: 12,
                        weight: FontWeight.w500,
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                    const Gap(8),
                    Slider(
                      value: state.effectiveRadiusPx,
                      min: 0,
                      max: 16,
                      onChanged: (double v) => state.setRadiusPx(v),
                    ),
                    const Gap(16),
                    // Mode row.
                    Row(
                      children: <Widget>[
                        Text(
                          'Mode',
                          style: docsText(
                            context,
                            size: 12,
                            weight: FontWeight.w500,
                            color: theme.colors.mutedForeground,
                          ),
                        ),
                        const Spacer(),
                        Button(
                          variant: ButtonVariant.ghost,
                          size: ButtonSize.xs,
                          onPressed: state.toggleBrightness,
                          child: Icon(
                            state.brightness == Brightness.dark
                                ? LucideIcons.sun
                                : LucideIcons.moon,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Footer actions.
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.colors.border)),
                color: theme.colors.muted.withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _ActionButton(label: 'Copy JSON', onPressed: () {}),
                  const Gap(8),
                  _ActionButton(label: 'Copy Dart', onPressed: () {}),
                  const Gap(8),
                  _ActionButton(
                    label: 'Shuffle',
                    onPressed: () {
                      final List<DocsPreset> presets = kPresets.toList();
                      presets.shuffle(Random());
                      state.setPreset(presets.first.id);
                    },
                  ),
                  const Gap(8),
                  _ActionButton(label: 'Get Code', onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({
    required this.preset,
    required this.active,
    required this.onTap,
  });

  final DocsPreset preset;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnColors colors = buildDocsTheme(
      preset.id,
      Brightness.light,
    ).colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? theme.colors.accent : const Color(0x00000000),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? theme.colors.accent : const Color(0x00000000),
            ),
          ),
          child: Row(
            children: <Widget>[
              // 4 swatches.
              SizedBox(
                width: 40,
                height: 24,
                child: Row(
                  children: <Widget>[
                    for (final Color c in <Color>[
                      colors.primary,
                      colors.secondary,
                      colors.accent,
                      colors.muted,
                    ])
                      Expanded(child: Container(color: c)),
                  ],
                ),
              ),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      preset.id,
                      style: docsText(
                        context,
                        size: 12,
                        weight: FontWeight.w500,
                        color: active
                            ? theme.colors.accentForeground
                            : theme.colors.foreground,
                      ),
                    ),
                    Text(
                      preset.modes.join(' / '),
                      style: docsText(
                        context,
                        size: 10,
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Button(
        variant: ButtonVariant.secondary,
        size: ButtonSize.sm,
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
