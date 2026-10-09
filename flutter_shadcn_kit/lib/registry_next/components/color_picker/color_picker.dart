// The `color_picker` component: a full colour picker with RGB/HSL/HSV/HEX
// fields, an optional alpha channel, colour history and screen sampling.
//
// Widgets-only. The pad and channel bars are the accepted `hsv`/`hsl`
// sliders; the controls row reuses `Select`, `Input`, `history` and
// `eye_dropper` and reflows on narrow widths (`color_picker_style.dart`).
// See README for the fixed old bugs.

import 'package:flutter/widgets.dart';

import '../../foundation/data.dart';
import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/localizations/localizations.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import '../eye_dropper/eye_dropper.dart';
import '../select/select.dart';
import '../color/color.dart';
import '../history/history.dart';
import '../hsl/hsl.dart';
import '../hsv/hsv.dart';
import 'color_picker_style.dart';

export 'color_picker_style.dart';

/// A full colour picker: a pad plus hue/alpha bars, a mode dropdown, live
/// numeric fields, optional colour history and an eye-dropper button.
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    required this.value,
    this.onChanged,
    this.onChanging,
    this.showAlpha = false,
    this.initialMode = ColorPickerMode.rgb,
    this.onModeChanged,
    this.enableEyeDropper,
    this.onEyeDropperRequested,
    this.showHistoryButton = true,
    this.initialShowHistory = false,
    this.theme,
  });

  final ColorDerivative value;

  final ValueChanged<ColorDerivative>? onChanged;

  final ValueChanged<ColorDerivative>? onChanging;

  final bool showAlpha;

  final ColorPickerMode initialMode;

  /// Called when the mode dropdown changes.
  final ValueChanged<ColorPickerMode>? onModeChanged;

  /// Eye-dropper button visibility; null uses the theme (true).
  final bool? enableEyeDropper;

  /// Replaces the default eye-dropper action (pick through the nearest
  /// `EyeDropperLayer`, into the colour history when one is in scope).
  final VoidCallback? onEyeDropperRequested;

  /// Whether the history toggle is shown (needs a `RecentColorsScope`).
  final bool showHistoryButton;

  /// Whether the history grid is shown on first build.
  final bool initialShowHistory;

  /// Widget-leg style override (orientation/spacing/slider size live here).
  final ColorPickerTheme? theme;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late ColorPickerMode _mode = widget.initialMode;
  ColorDerivative? _changing;
  late bool _showHistory = widget.initialShowHistory;

  ColorDerivative get _value => _changing ?? widget.value;

  ColorPickerTheme _style(BuildContext context) =>
      resolveComponentStyle<ColorPickerTheme, ColorPickerTheme>(
        context,
        widget: widget.theme,
        select: (t) => t,
        defaults: colorPickerDefaults,
      );

  void _onChanging(ColorDerivative next) {
    setState(() => _changing = next);
    widget.onChanging?.call(next);
  }

  void _onChanged(ColorDerivative next) {
    setState(() => _changing = null);
    widget.onChanged?.call(next);
  }

  void _setMode(ColorPickerMode mode) {
    if (mode == _mode) return;
    setState(() => _mode = mode);
    widget.onModeChanged?.call(mode);
  }

  void _pickHistoryColor(Color color) {
    final ColorDerivative next = _value.changeToColor(color);
    _onChanging(next);
    _onChanged(next);
  }

  ColorDerivative _applyHsl(ColorDerivative value, HSLColor color) => value
      .changeToHSLSaturation(color.saturation)
      .changeToHSLLightness(color.lightness);

  ColorDerivative _applyHsv(ColorDerivative value, HSVColor color) => value
      .changeToHSVSaturation(color.saturation)
      .changeToHSVValue(color.value);

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final ColorPickerTheme style = _style(context);
    final ColorDerivative value = _value;
    final ColorHistoryStorage? history = Data.maybeFind<ColorHistoryStorage>(
      context,
    );
    final Axis orientation = style.orientation ?? Axis.vertical;
    final double spacing = style.spacing ?? colorPickerDefaults.spacing!;
    final double gap =
        style.controlSpacing ?? colorPickerDefaults.controlSpacing!;
    final double size = style.sliderSize ?? colorPickerDefaults.sliderSize!;
    final Radius radius = Radius.circular(ambient.radiusSm);
    final bool showGrid = _showHistory && history != null;
    final Widget pad = _pad(value, 150 * ambient.scaling, radius);
    final bool eyeDropper =
        widget.enableEyeDropper ?? style.enableEyeDropper ?? true;
    final Widget strip = IntrinsicHeight(
      child: Flex(
        direction: orientation,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (showGrid)
            // Narrow pickers scroll the fixed-width grid instead of overflowing.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ColorHistoryGrid(
                storage: history,
                onColorPicked: _pickHistoryColor,
                selectedColor: value.toColor(),
                crossAxisCount: orientation == Axis.vertical ? 10 : 2,
                maxTotalColors: orientation == Axis.vertical ? null : 14,
              ),
            )
          else ...<Widget>[
            if (orientation == Axis.horizontal) Flexible(child: pad) else pad,
            Gap(spacing),
            _bar(value, HSVColorSliderType.hue, orientation, size, radius),
            if (widget.showAlpha) ...<Widget>[
              Gap(gap),
              _bar(value, HSVColorSliderType.alpha, orientation, size, radius),
            ],
          ],
        ],
      ),
    );
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          strip,
          Gap(showGrid ? spacing : gap),
          ColorPickerControls(
            value: value,
            mode: _mode,
            onChanged: _onChanged,
            onModeChanged: _setMode,
            onToggleHistory: () => setState(() => _showHistory = !_showHistory),
            showHistory: _showHistory,
            showHistoryButton: widget.showHistoryButton,
            showAlpha: widget.showAlpha,
            enableEyeDropper: eyeDropper,
            onEyeDropperRequested: widget.onEyeDropperRequested,
            history: history,
            controlSpacing: gap,
          ),
        ],
      ),
    );
  }

  Widget _pad(ColorDerivative value, double minSize, Radius radius) {
    final Widget slider;
    if (_mode == ColorPickerMode.hsl) {
      slider = HSLColorSlider(
        color: value.toHSLColor(),
        sliderType: HSLColorSliderType.satLum,
        radius: radius,
        onChanging: (color) => _onChanging(_applyHsl(value, color)),
        onChanged: (color) => _onChanged(_applyHsl(value, color)),
      );
    } else {
      slider = HSVColorSlider(
        color: value.toHSVColor(),
        sliderType: HSVColorSliderType.satVal,
        radius: radius,
        onChanging: (color) => _onChanging(_applyHsv(value, color)),
        onChanged: (color) => _onChanged(_applyHsv(value, color)),
      );
    }
    return AspectRatio(
      aspectRatio: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
        child: slider,
      ),
    );
  }

  Widget _bar(
    ColorDerivative value,
    HSVColorSliderType type,
    Axis orientation,
    double size,
    Radius radius,
  ) {
    final bool hue = type == HSVColorSliderType.hue;
    return SizedBox(
      height: orientation == Axis.vertical ? size : null,
      width: orientation == Axis.horizontal ? size : null,
      child: HSVColorSlider(
        color: hue
            ? value.toHSVColor().withSaturation(1).withValue(1)
            : value.toHSVColor(),
        sliderType: type,
        reverse: orientation == Axis.vertical,
        radius: radius,
        onChanging: (next) => _onChanging(
          hue
              ? value.changeToHSVHue(next.hue)
              : value.changeToOpacity(next.alpha),
        ),
        onChanged: (next) => _onChanged(
          hue
              ? value.changeToHSVHue(next.hue)
              : value.changeToOpacity(next.alpha),
        ),
      ),
    );
  }
}

/// The controls row of a `ColorPicker`: eye-dropper and history buttons, the
/// 96 px mode `Select` and the live channel fields (the old `ColorControls`).
///
/// A [Wrap] sized to its one-line width ([colorPickerControlsWidth]) keeps the
/// popover look unchanged; narrower widths wrap onto extra runs.
class ColorPickerControls extends StatelessWidget {
  const ColorPickerControls({
    super.key,
    required this.value,
    required this.mode,
    required this.onChanged,
    required this.controlSpacing,
    this.onModeChanged,
    this.onToggleHistory,
    this.showHistory = false,
    this.showHistoryButton = true,
    this.showAlpha = false,
    this.enableEyeDropper = true,
    this.onEyeDropperRequested,
    this.history,
  });

  /// The colour being edited.
  final ColorDerivative value;

  /// Current mode of the fields.
  final ColorPickerMode mode;

  /// Called when a field, the history grid or the eye dropper commits.
  final ValueChanged<ColorDerivative> onChanged;

  /// Gap between the controls (resolved by the picker).
  final double controlSpacing;

  /// Called with the next mode.
  final ValueChanged<ColorPickerMode>? onModeChanged;

  /// Called when the history toggle is pressed.
  final VoidCallback? onToggleHistory;

  /// Whether the history grid is currently open.
  final bool showHistory;

  /// Whether the history toggle button is shown (needs a history scope).
  final bool showHistoryButton;

  /// Whether the alpha field is shown.
  final bool showAlpha;

  /// Eye-dropper button visibility (already resolved by the picker).
  final bool enableEyeDropper;

  /// Replaces the default eye-dropper action.
  final VoidCallback? onEyeDropperRequested;

  /// Colour history to write an eye-dropper pick into; null skips history.
  final ColorHistoryStorage? history;

  Future<void> _pickColor(BuildContext context) async {
    final Color? picked = await pickColorFromScreen(context, history);
    if (picked != null) onChanged(value.changeToColor(picked));
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    final bool historyToggle = showHistoryButton && history != null;
    final List<Widget> fields = colorPickerFields(
      context,
      value: value,
      mode: mode,
      showAlpha: showAlpha,
      onChanged: onChanged,
    );
    final int leadingButtons =
        (enableEyeDropper ? 1 : 0) + (historyToggle ? 1 : 0);
    return SizedBox(
      width: colorPickerControlsWidth(
        mode: mode,
        showAlpha: showAlpha,
        leadingButtons: leadingButtons,
        controlSpacing: controlSpacing,
      ),
      child: Wrap(
        spacing: controlSpacing,
        runSpacing: controlSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          if (leadingButtons > 0)
            ButtonGroup.horizontal(
              children: <Widget>[
                if (enableEyeDropper)
                  Button(
                    variant: ButtonVariant.outline,
                    size: ButtonSize.icon,
                    onPressed:
                        onEyeDropperRequested ?? () => _pickColor(context),
                    child: const Icon(LucideIcons.pipette),
                  ),
                if (historyToggle)
                  Button(
                    variant: showHistory
                        ? ButtonVariant.primary
                        : ButtonVariant.outline,
                    size: ButtonSize.icon,
                    onPressed: onToggleHistory,
                    child: const Icon(LucideIcons.history),
                  ),
              ],
            ),
          SizedBox(
            width: 96,
            child: Select<ColorPickerMode>(
              value: mode,
              onChanged: (next) {
                if (next != null) onModeChanged?.call(next);
              },
              itemBuilder: (context, value) => Text(_modeLabel(l10n, value)),
              items: <Widget>[
                for (final ColorPickerMode item in ColorPickerMode.values)
                  SelectItem<ColorPickerMode>(
                    value: item,
                    child: Text(_modeLabel(l10n, item)),
                  ),
              ],
            ),
          ),
          ...fields,
        ],
      ),
    );
  }
}

/// Localized tab label of [mode] (`RGB` / `HSL` / `HSV` / `HEX`).
String _modeLabel(ShadcnLocalizations l10n, ColorPickerMode mode) =>
    switch (mode) {
      ColorPickerMode.rgb => l10n.colorPickerTabRGB,
      ColorPickerMode.hsl => l10n.colorPickerTabHSL,
      ColorPickerMode.hsv => l10n.colorPickerTabHSV,
      ColorPickerMode.hex => l10n.colorPickerTabHEX,
    };
