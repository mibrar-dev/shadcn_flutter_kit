// The Theme Studio rail (spec §2.7).
//
// A 192 px rounded card with a `Menu` header, a scrolling column of picker
// rows (Preset, Base colour, Theme colour, Chart colours, Heading font, Body
// font, Radius, Spacing, Shadow, Syntax colours) and the footer actions. The
// rail owns no state: every row writes to the [SiteThemeModel] behind
// [DocsState], so an edit re-themes the whole site, not just this canvas.
//
// The scroll area uses the registry `fade_scroll` primitive, which fades an
// edge only while there is hidden content in that direction (the reference's
// `scroll-fade` mask, but state-driven instead of always-on).

import 'package:flutter/widgets.dart';

import '../state/docs_state.dart';
import '../theme/theme_document.dart';
import '../theme/theme_palette.dart';
import '../ui/shadcn/components/button/button.dart';
import '../ui/shadcn/foundation/gap.dart';
import '../ui/shadcn/foundation/icons/lucide_icons.dart';
import '../ui/shadcn/primitives/fade_scroll.dart';
import '../ui/shadcn/theme/theme.dart';
import 'get_code_dialog.dart';
import 'open_preset_dialog.dart';
import 'rail_footer.dart';
import 'rail_glyphs.dart';
import 'rail_picker_scales.dart';
import 'rail_pickers.dart';
import 'rail_row.dart';

/// The rail width (spec §2.7: 192 px, 24 px from the left edge).
const double kThemeRailWidth = 192;

/// The 192 px customizer rail.
class ThemeRail extends StatefulWidget {
  /// Creates the rail bound to [state].
  const ThemeRail({super.key, required this.state});

  /// The shell state; the rail reads and writes its theme model.
  final DocsState state;

  @override
  State<ThemeRail> createState() => _ThemeRailState();
}

class _ThemeRailState extends State<ThemeRail> {
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  SiteThemeModel get _model => widget.state.themeModel;

  Future<void> _pickPreset() async {
    final String? id = await showPresetPicker(context, _model.presetId);
    if (id != null) {
      _model.selectPreset(id);
    }
  }

  Future<void> _pickColor(void Function(Color seed) apply) async {
    final Color? seed = await showColorPicker(
      context,
      docsColorOf(_model.document.light['primary']!),
    );
    if (seed != null) {
      apply(seed);
    }
  }

  Future<void> _pickFont(String slot) async {
    final String? spec = await showFontPicker(
      context,
      slot,
      _model.document.fontOf(slot),
    );
    if (spec != null) {
      _model.setFont(slot, spec.isEmpty ? null : spec);
    }
  }

  Future<void> _pickRadius() async {
    final double? px = await showRadiusPicker(context, _model.radiusPx);
    if (px != null) {
      _model.setRadiusPx(px);
    }
  }

  Future<void> _pickSpacing() async {
    final double? rem = await showSpacingPicker(
      context,
      _model.document.spacing,
    );
    if (rem != null) {
      _model.setSpacingRem(rem);
    }
  }

  Future<void> _pickShadow() async {
    final bool dark = widget.state.brightness == Brightness.dark;
    final DocsShadowAtoms? atoms = await showShadowPicker(
      context,
      _model.document.shadowOf(widget.state.brightness),
      dark: dark,
    );
    if (atoms != null) {
      _model.setShadow(widget.state.brightness, atoms);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final SiteThemeModel model = _model;
    final ThemeDocument document = model.document;
    final bool dark = widget.state.brightness == Brightness.dark;
    return SizedBox(
      width: kThemeRailWidth,
      child: ClipRRect(
        borderRadius: theme.borderRadiusXl,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colors.card,
            border: Border.all(color: theme.colors.border),
            borderRadius: theme.borderRadiusXl,
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: 49,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: theme.colors.border),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Text('Menu', style: docsRailText(context, 14, w500: true)),
                    const Spacer(),
                    Button(
                      key: const ValueKey<String>('theme-rail-reset'),
                      variant: ButtonVariant.ghost,
                      size: ButtonSize.xs,
                      theme: const ButtonVariantStyle(padding: EdgeInsets.zero),
                      onPressed: model.reset,
                      child: const Text('Reset'),
                    ),
                    const Gap(4),
                    const Icon(LucideIcons.panelLeft, size: 16),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FadeScroll(
                    controller: _scroll,
                    startOffset: 12,
                    endOffset: 12,
                    gradient: <Color>[
                      theme.colors.card,
                      theme.colors.card.withValues(alpha: 0),
                    ],
                    // A scroll view + column (not a lazy ListView): the rail is
                    // short and every row must be built, focusable and
                    // reachable by Tab, exactly like the reference's
                    // `no-scrollbar` list.
                    child: SingleChildScrollView(
                      controller: _scroll,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          RailRow(
                            key: const ValueKey<String>('rail-row-preset'),
                            label: 'Preset',
                            value: model.matchedPresetId ?? document.name,
                            selected: model.matchedPresetId != null,
                            onPressed: _pickPreset,
                            trailing: RailPresetSwatch(
                              colors: <Color>[
                                document
                                    .colorsFor(
                                      dark ? Brightness.dark : Brightness.light,
                                    )
                                    .primary,
                                document
                                    .colorsFor(
                                      dark ? Brightness.dark : Brightness.light,
                                    )
                                    .secondary,
                                document
                                    .colorsFor(
                                      dark ? Brightness.dark : Brightness.light,
                                    )
                                    .accent,
                                document
                                    .colorsFor(
                                      dark ? Brightness.dark : Brightness.light,
                                    )
                                    .muted,
                              ],
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-base'),
                            label: 'Base colour',
                            value: docsColorName(
                              docsColorOf(document.light['background']!),
                            ),
                            onPressed: () => _pickColor(model.setBaseColor),
                            trailing: RailSwatch(
                              color: docsColorOf(document.light['background']!),
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-accent'),
                            label: 'Theme colour',
                            value: docsColorName(
                              docsColorOf(document.light['primary']!),
                            ),
                            onPressed: () => _pickColor(model.setAccentColor),
                            trailing: RailSwatch(
                              color: docsColorOf(document.light['primary']!),
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-chart'),
                            label: 'Chart colours',
                            value: docsColorName(
                              docsColorOf(document.light['chart1']!),
                            ),
                            onPressed: () => _pickColor(model.setChartColors),
                            trailing: SizedBox.expand(
                              child: Row(
                                children: <Widget>[
                                  for (final String token
                                      in kDocsChartTokenKeys)
                                    Expanded(
                                      child: ColoredBox(
                                        color: docsColorOf(
                                          document.light[token]!,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-heading'),
                            label: 'Heading font',
                            value: railFamilyLabel(document.fontOf('sans')),
                            onPressed: () => _pickFont('sans'),
                            trailing: RailAaGlyph(
                              family: document.fontOf('sans'),
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-body'),
                            label: 'Body font',
                            value: railFamilyLabel(document.fontOf('mono')),
                            onPressed: () => _pickFont('mono'),
                            trailing: RailAaGlyph(
                              family: document.fontOf('mono'),
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-radius'),
                            label: 'Radius',
                            value: '${model.radiusPx.round()} px',
                            onPressed: _pickRadius,
                            trailing: RailRadiusGlyph(theme: theme),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-spacing'),
                            label: 'Spacing',
                            value: '${model.spacingPx.toStringAsFixed(1)} px',
                            onPressed: _pickSpacing,
                            trailing: RailSpacingGlyph(theme: theme),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-shadow'),
                            label: 'Shadow',
                            value: railShadowLabel(
                              document.shadowOf(widget.state.brightness),
                            ),
                            onPressed: _pickShadow,
                            trailing: RailShadowGlyph(
                              atoms: document.shadowOf(widget.state.brightness),
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-syntax'),
                            label: 'Syntax colours',
                            value: 'shiki · ${dark ? 'dark' : 'light'}',
                            onPressed: () => showShadcnPicker<void>(
                              context: context,
                              builder: (BuildContext context) =>
                                  const SyntaxPalettePreview(),
                              title: 'Syntax colours',
                            ),
                            trailing: const Icon(LucideIcons.code, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              RailFooter(
                presetId: model.presetId,
                onOpenPreset: () => showOpenPresetDialog(context, model),
                onShuffle: model.shuffle,
                onGetCode: () => showGetCodeDialog(context, model),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The 14/500 text style of the rail rows.
TextStyle docsRailText(
  BuildContext context,
  double size, {
  bool w500 = false,
  Color? color,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  return theme.typography.sans.copyWith(
    fontSize: size,
    fontWeight: w500 ? FontWeight.w500 : FontWeight.w400,
    color: color ?? theme.colors.foreground,
  );
}
