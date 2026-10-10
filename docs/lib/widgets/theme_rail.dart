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
import 'rail_picker_shadow.dart';
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

  /// Opens a picker anchored to the row that was tapped.
  ///
  /// [anchor] is the row's context; the registry `popup` positions the panel
  /// against it, so every picker opens beside its row instead of at the rail's
  /// corner.
  ///
  /// Every picker applies live to [_model] while it is open (hover, pick or
  /// drag); closing keeps the current value, so the callers ignore results.
  void _pickPreset(BuildContext anchor) {
    showPresetPicker(anchor, _model.presetId, onChanged: _model.selectPreset);
  }

  void _pickRadius(BuildContext anchor) {
    showRadiusPicker(anchor, _model.radiusPx, onChanged: _model.setRadiusPx);
  }

  void _pickSpacing(BuildContext anchor) {
    showSpacingPicker(
      anchor,
      _model.document.spacing,
      onChanged: _model.setSpacingRem,
    );
  }

  void _pickShadow(BuildContext anchor) {
    final bool dark = widget.state.brightness == Brightness.dark;
    showShadowPicker(
      anchor,
      _model.document.shadowOf(widget.state.brightness),
      dark: dark,
      onChanged: (DocsShadowAtoms atoms) =>
          _model.setShadow(widget.state.brightness, atoms),
    );
  }

  void _pickColorBase(BuildContext row) {
    showColorPicker(
      row,
      docsColorOf(_model.document.light['background']!),
      onChanged: _model.setBaseColor,
    );
  }

  void _pickColorAccent(BuildContext row) {
    showColorPicker(
      row,
      docsColorOf(_model.document.light['primary']!),
      onChanged: _model.setAccentColor,
    );
  }

  void _pickColorChart(BuildContext row) {
    showColorPicker(
      row,
      docsColorOf(_model.document.light['chart1']!),
      onChanged: _model.setChartColors,
    );
  }

  void _pickHeadingFont(BuildContext row) {
    showFontPicker(
      row,
      'sans',
      _model.document.fontOf('sans'),
      onChanged: (String spec) =>
          _model.setFont('sans', spec.isEmpty ? null : spec),
    );
  }

  void _pickBodyFont(BuildContext row) {
    showFontPicker(
      row,
      'mono',
      _model.document.fontOf('mono'),
      onChanged: (String spec) =>
          _model.setFont('mono', spec.isEmpty ? null : spec),
    );
  }

  Future<void> _showSyntax(BuildContext row) => showShadcnPicker<void>(
    context: row,
    builder: (BuildContext context) => const SyntaxPalettePreview(),
    title: 'Syntax colours',
  );

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
                            onPressed: _pickColorBase,
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
                            onPressed: _pickColorAccent,
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
                            onPressed: _pickColorChart,
                            trailing: SizedBox.expand(
                              child: Row(
                                // `stretch`, so the childless `ColoredBox`
                                // strips fill the 20 px row height.
                                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            onPressed: _pickHeadingFont,
                            trailing: RailAaGlyph(
                              family: document.fontOf('sans'),
                            ),
                          ),
                          RailRow(
                            key: const ValueKey<String>('rail-row-body'),
                            label: 'Body font',
                            value: railFamilyLabel(document.fontOf('mono')),
                            onPressed: _pickBodyFont,
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
                            onPressed: _showSyntax,
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
