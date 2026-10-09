// Popup bodies of the Theme Studio rail rows (spec §2.7).
//
// Every row opens an anchored `MenuPopup` through the registry `popup`
// component (`showShadcnPopup`), which owns Escape and outside-tap dismissal.
// The bodies are the reference's: a preset list, a colour grid, a font list,
// a slider and a shadow panel.

import 'package:flutter/widgets.dart';

import '../../generated/docs_data.dart';
import '../../theme/theme_document.dart';
import '../../theme/theme_palette.dart';
import '../../ui/shadcn/components/input/input.dart';
import '../../ui/shadcn/components/popup/popup.dart';
import '../../ui/shadcn/components/tooltip/tooltip.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/primitives/clickable.dart';
import '../../ui/shadcn/primitives/overlay.dart';
import '../../ui/shadcn/theme/color_tokens.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_row.dart';

/// The seed swatches offered by the colour rows.
///
/// A fixed palette of named seeds (the reference offers the same kind of grid);
/// `Base Color` and `Theme` derive their whole family from one of them, and
/// `Chart Color` derives five hues from the seed it is given.
const List<Color> kDocsSeedSwatches = <Color>[
  Color(0xFF171717),
  Color(0xFF737373),
  Color(0xFFE7000B),
  Color(0xFFFF6B00),
  Color(0xFFF59E0B),
  Color(0xFFBEF264),
  Color(0xFF16A34A),
  Color(0xFF14B8A6),
  Color(0xFF0EA5E9),
  Color(0xFF2563EB),
  Color(0xFF4F46E5),
  Color(0xFF8B5CF6),
  Color(0xFFD946EF),
  Color(0xFFEC4899),
];

/// The picker's panel width (the reference's colour popovers are ~200 px).
const double kDocsPickerWidth = 224;

/// Shows the preset list popup and returns the picked id.
Future<String?> showPresetPicker(BuildContext context, String current) {
  return showShadcnPicker<String>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final DocsPreset preset in kPresets)
            RailPickerRow(
              label: preset.name,
              detail: preset.id,
              selected: preset.id == current,
              onPick: () => closeOverlay(context, preset.id),
              trailing: RailPresetSwatch(
                colors: _presetSwatches(preset.id, Brightness.light),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Shows the colour seed grid for [label] and returns the picked colour.
Future<Color?> showColorPicker(BuildContext context, Color current) {
  return showShadcnPicker<Color>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final Color seed in kDocsSeedSwatches)
                RailSeedSwatch(
                  color: seed,
                  name: docsColorName(seed),
                  selected: seed.toARGB32() == current.toARGB32(),
                  onPick: () => closeOverlay(context, seed),
                ),
            ],
          ),
          const Gap(12),
          RailHexField(initial: current),
        ],
      ),
    ),
  );
}

/// Opens an anchored picker popup (registry `popup` → `showShadcnPopup`).
Future<T?> showShadcnPicker<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
}) {
  return showShadcnPopup<T>(
    context: context,
    builder: (BuildContext context) => ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: kDocsPickerWidth + 24,
        maxHeight: 360,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: title == null
            ? builder(context)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: docsText(
                      context,
                      size: 12,
                      weight: FontWeight.w500,
                      color: ShadcnTheme.of(context).colors.mutedForeground,
                    ),
                  ),
                  const Gap(8),
                  Flexible(child: builder(context)),
                ],
              ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Panel internals
// ---------------------------------------------------------------------------

/// The fixed-width panel body every picker renders in.
class RailPickerPanel extends StatelessWidget {
  /// Creates a panel.
  const RailPickerPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SizedBox(width: kDocsPickerWidth, child: child);
}

/// One selectable row of a picker (hover + selected accent fill).
class RailPickerRow extends StatelessWidget {
  /// Creates a row.
  const RailPickerRow({
    super.key,
    required this.label,
    required this.detail,
    required this.selected,
    required this.onPick,
    this.trailing,
  });

  final String label;
  final String detail;
  final bool selected;
  final VoidCallback onPick;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Clickable(
        onPressed: onPick,
        behavior: HitTestBehavior.opaque,
        decoration: WidgetStateProperty.resolveWith<Decoration?>((
          Set<WidgetState> states,
        ) {
          return BoxDecoration(
            color: states.contains(WidgetState.hovered) || selected
                ? theme.colors.accent
                : const Color(0x00000000),
            borderRadius: BorderRadius.circular(6),
          );
        }),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(context, size: 13),
                    ),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: docsText(
                        context,
                        size: 11,
                        color: theme.colors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing case final Widget widget)
                SizedBox(width: 24, height: 24, child: widget),
            ],
          ),
        ),
      ),
    );
  }
}

/// One seed colour of the colour grid.
class RailSeedSwatch extends StatelessWidget {
  /// Creates a swatch.
  const RailSeedSwatch({
    super.key,
    required this.color,
    required this.name,
    required this.selected,
    required this.onPick,
  });

  final Color color;
  final String name;
  final bool selected;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final ShadcnColors colors = ShadcnTheme.of(context).colors;
    return Tooltip(
      tooltip: (BuildContext context) => Text(name),
      child: Clickable(
        onPressed: onPick,
        decoration: const WidgetStatePropertyAll<Decoration?>(null),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: selected ? colors.foreground : colors.border,
              width: selected ? 2 : 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// A `#RRGGBB` field for a colour the grid does not offer.
/// A `#RRGGBB` field for a colour the grid does not offer.
class RailHexField extends StatefulWidget {
  /// Creates the field.
  const RailHexField({super.key, required this.initial});

  final Color initial;

  @override
  State<RailHexField> createState() => RailHexFieldState();
}

/// The field state.
class RailHexFieldState extends State<RailHexField> {
  late final TextEditingController _controller = TextEditingController(
    text: formatDocsHexColor(widget.initial.toARGB32()),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Input(
      controller: _controller,
      hintText: '#RRGGBB',
      maxLength: 9,
      onSubmitted: (String value) {
        if (kDocsHexColorPattern.hasMatch(value.trim())) {
          closeOverlay<Color>(context, docsColorOf(value.trim()));
        }
      },
      onChanged: (String value) {
        final String trimmed = value.trim();
        if (kDocsHexColorPattern.hasMatch(trimmed)) {
          closeOverlay<Color>(context, docsColorOf(trimmed));
        }
      },
    );
  }
}

/// The four swatches of a preset's accent family.
List<Color> _presetSwatches(String presetId, Brightness brightness) {
  final ShadcnThemeData theme = ThemeDocument.fromPreset(
    presetId,
  ).theme(brightness);
  return <Color>[
    theme.colors.primary,
    theme.colors.secondary,
    theme.colors.accent,
    theme.colors.muted,
  ];
}
