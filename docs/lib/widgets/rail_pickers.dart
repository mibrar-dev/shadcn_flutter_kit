// Popup bodies of the Theme Studio rail rows (spec §2.7).
//
// Every row opens an anchored `MenuPopup` through the registry `popup`
// component (`showShadcnPopup`), which owns Escape and outside-tap dismissal.
// The bodies are the reference's: a preset list, a colour grid, a font list,
// a slider and a shadow panel.
//
// Every control applies LIVE to the site theme while it is interacted with
// (hovering or picking a preset/colour/font, dragging a slider): the popup
// reports edits through [onChanged] callbacks as they happen, `Done` only
// closes, and Escape keeps whatever value is current. A separate `Reset`
// action in the rail header restores the default preset.

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../generated/docs_data.dart';
import '../../theme/theme_document.dart';
import '../../theme/theme_palette.dart';
import '../../ui/shadcn/components/popup/popup.dart';
import '../../ui/shadcn/foundation/gap.dart';
import '../../ui/shadcn/primitives/overlay.dart';
import '../../ui/shadcn/theme/theme.dart';
import 'docs_tokens.dart';
import 'rail_picker_rows.dart';
import 'rail_picker_scroll.dart';
import 'rail_row.dart';

/// The seed swatches offered by the colour rows.
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

/// Shows the preset list popup; hovering or picking applies live.
///
/// [onChanged] runs for every highlight and pick, so the whole site follows
/// while the popup is open. Closing (pick, `Done`, Escape, outside tap)
/// keeps the current value.
Future<void> showPresetPicker(
  BuildContext context,
  String current, {
  required ValueChanged<String> onChanged,
}) {
  String live = current;
  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final DocsPreset preset in kPresets)
              revealSelectedOnMount(
                selected: preset.id == live,
                child: RailPickerRow(
                  label: preset.name,
                  detail: preset.id,
                  selected: preset.id == live,
                  onHighlight: () {
                    setState(() => live = preset.id);
                    onChanged(preset.id);
                  },
                  onPick: () {
                    setState(() => live = preset.id);
                    onChanged(preset.id);
                    closeOverlay(context);
                  },
                  trailing: RailPresetSwatch(
                    colors: _presetSwatches(preset.id, Brightness.light),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// Shows the colour seed grid for [label]; hovering or picking applies live.
///
/// [onChanged] runs for every highlight and pick, so the whole site follows
/// while the popup is open. Closing keeps the current value.
Future<void> showColorPicker(
  BuildContext context,
  Color current, {
  required ValueChanged<Color> onChanged,
}) {
  int live = current.toARGB32();
  return showShadcnPicker<void>(
    context: context,
    builder: (BuildContext context) => RailPickerPanel(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) => Column(
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
                    selected: seed.toARGB32() == live,
                    onHighlight: () {
                      setState(() => live = seed.toARGB32());
                      onChanged(seed);
                    },
                    onPick: () {
                      setState(() => live = seed.toARGB32());
                      onChanged(seed);
                      closeOverlay(context);
                    },
                  ),
              ],
            ),
            const Gap(12),
            RailHexField(
              initial: current,
              onPick: (Color color) {
                onChanged(color);
                closeOverlay(context);
              },
            ),
          ],
        ),
      ),
    ),
  );
}

/// Opens an anchored picker popup (registry `popup` → `showShadcnPopup`).
///
/// The popup is opened with a **nullable** result type on purpose. The
/// registry's `Popup` closes with a `null` result whenever it is dismissed
/// without a pick (Escape, outside tap, a "Done" button) and its
/// `onCloseWithResult` performs `value as T` (see
/// `ui/shadcn/primitives/popover_overlay_handler.dart`). A non-nullable `T`
/// therefore throws `type 'Null' is not a subtype of type 'T'` on every
/// dismissal. `T?` keeps the picker contract (`null` = "not picked") and the
/// caller-visible `Future<T?>` unchanged.
Future<T?> showShadcnPicker<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
}) {
  // The popup never leaves the screen: it caps at 360 px high and at the
  // viewport space above or below its anchor row, whichever is smaller, and
  // the registry popover flips it to the roomier side on its own.
  final Size screen = MediaQuery.sizeOf(context);
  double maxH = math.min(360.0, screen.height - 16).clamp(160.0, 360.0);
  final RenderObject? anchor = context.findRenderObject();
  if (anchor is RenderBox && anchor.hasSize) {
    final Rect rect = anchor.localToGlobal(Offset.zero) & anchor.size;
    final double room = math.max(screen.height - rect.bottom - 8, rect.top - 8);
    maxH = math.min(360.0, room).clamp(160.0, 360.0);
  }
  return showShadcnPopup<T?>(
    context: context,
    // Open below the row (like the reference's popovers) and keep the panel
    // inside the 192 px rail: the anchor is the row, so the default
    // top-centre placement would push the panel off the top of the viewport.
    alignment: Alignment.topLeft,
    anchorAlignment: Alignment.bottomLeft,
    offset: const Offset(0, 4),
    width: kDocsPickerWidth + 24,
    maxHeight: maxH,
    builder: (BuildContext context) => ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: kDocsPickerWidth + 24,
        maxHeight: maxH,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: title == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(child: RailPickerScroll(child: builder(context))),
                ],
              )
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
                  Flexible(child: RailPickerScroll(child: builder(context))),
                ],
              ),
      ),
    ),
  );
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
