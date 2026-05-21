// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color_picker.dart';

/// Widget providing color input controls with multiple color space modes.
///
/// Displays inputs for editing colors in RGB, HSL, HSV, or HEX formats
/// with optional alpha channel and eye dropper tool support.
class ColorControls extends StatelessWidget {
  /// The current color value.
  final ColorDerivative value;

  /// Callback invoked when the color is changed.
  final ValueChanged<ColorDerivative>? onChanged;

  /// Callback invoked while the color is being changed (live updates).
  final ValueChanged<ColorDerivative>? onChanging;

  /// Callback invoked when the color picker mode changes.
  final ValueChanged<ColorPickerMode>? onModeChanged;

  /// Whether to show alpha channel controls.
  final bool showAlpha;

  /// The current color picker mode (RGB, HSL, HSV, or HEX).
  final ColorPickerMode mode;

  /// Spacing between control elements.
  final double? controlSpacing;

  /// Whether to enable the eye dropper tool.
  final bool? enableEyeDropper;

  /// Callback invoked when the eye dropper tool is requested.
  final VoidCallback? onEyeDropperRequested;

  /// Whether the color history panel is shown.
  final bool showHistory;

  /// Callback invoked when the color history panel visibility changes.
  final ValueChanged<bool>? onShowHistoryChanged;

  /// Whether to show the color history button.
  final bool showHistoryButton;

  /// Creates color controls.
  const ColorControls({
    super.key,
    required this.value,
    this.onChanged,
    this.onChanging,
    this.onModeChanged,
    this.showAlpha = false,
    this.mode = ColorPickerMode.rgb,
    this.enableEyeDropper,
    this.onEyeDropperRequested,
    this.controlSpacing,
    this.showHistory = false,
    this.onShowHistoryChanged,
    this.showHistoryButton = true,
  });

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = ComponentTheme.maybeOf<ColorPickerTheme>(context);
    final locale = ShadcnLocalizations.of(context);
    final enableEyeDropper = styleValue(
      defaultValue: true,
      themeValue: theme?.enableEyeDropper,
      widgetValue: this.enableEyeDropper,
    );
    final controlSpacing = styleValue(
      defaultValue: 8.0,
      themeValue: theme?.controlSpacing,
      widgetValue: this.controlSpacing,
    );

    /// Performs `pickerModeToLabel` logic for this form component.
    String pickerModeToLabel(ColorPickerMode mode) {
      switch (mode) {
        case ColorPickerMode.rgb:
          return locale.colorPickerTabRGB;
        case ColorPickerMode.hsl:
          return locale.colorPickerTabHSL;
        case ColorPickerMode.hsv:
          return locale.colorPickerTabHSV;
        case ColorPickerMode.hex:
          return locale.colorPickerTabHEX;
      }
    }

    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: controlSpacing,
        children: [
          if (enableEyeDropper)
            IconButton.outline(
              icon: const Icon(Icons.colorize),
              onPressed:
                  onEyeDropperRequested ??
                  () async {
                    final result = await pickColorFromScreen(context);
                    if (result != null) {
                      onChanged?.call(ColorDerivative.fromColor(result));
                      if (context.mounted) {
                        ColorHistoryStorage.of(context).addHistory(result);
                      }
                    }
                  },
            ),
          if (showHistoryButton)
            IconButton(
              variance: showHistory
                  ? ButtonVariance.primary
                  : ButtonVariance.outline,
              icon: Icon(
                showHistory ? Icons.history_toggle_off : Icons.history,
              ),
              onPressed: () {
                onShowHistoryChanged?.call(!showHistory);
              },
            ),
          Expanded(
            child: ButtonGroup.horizontal(
              expands: true,
              children: [
                Expanded(
                  child: Select<ColorPickerMode>(
                    value: mode,
                    itemBuilder: (context, value) {
                      return Text(pickerModeToLabel(value));
                    },
                    onChanged: (mode) {
                      if (mode != null) {
                        onModeChanged?.call(mode);
                      }
                    },
                    popup: SelectPopup.noVirtualization(
                      items: SelectItemList(
                        children: [
                          for (var mode in ColorPickerMode.values)
                            SelectItemButton(
                              value: mode,
                              child: Text(pickerModeToLabel(mode)),
                            ),
                        ],
                      ),
                    ).call,
                  ),
                ),
                ...buildInputs(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the input widgets based on the current color picker mode.
  List<Widget> buildInputs(BuildContext context) {
    return switch (mode) {
      ColorPickerMode.rgb => buildRGBInputs(context),
      ColorPickerMode.hsl => buildHSLInputs(context),
      ColorPickerMode.hsv => buildHSVInputs(context),
      ColorPickerMode.hex => buildHEXInputs(context),
    };
  }

  void Function(String value) _onInputChanged(
    void Function(double val) changer,
  ) {
    return (String value) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        changer(parsed);
      }
    };
  }

  /// Builds RGB color input widgets.
  List<Widget> buildRGBInputs(BuildContext context) {
    final locale = ShadcnLocalizations.of(context);
    return [
      // _ColorValueInput ensures that when the value changes from outside,
      // the input reflects the latest value unless focused, and only emits
      // onChanged while focused to avoid feedback loops.
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorRed),
          keyboardType: TextInputType.number,
          value: value.red.toInt().toString(),
          onChanged: _onInputChanged((val) {
            final r = val.clamp(0.0, 255.0);
            onChanged?.call(value.changeToColorRed(r));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 255)],
        ),
      ),
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorGreen),
          keyboardType: TextInputType.number,
          value: value.green.toInt().toString(),
          onChanged: _onInputChanged((val) {
            final g = val.clamp(0.0, 255.0);
            onChanged?.call(value.changeToColorGreen(g));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 255)],
        ),
      ),
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorBlue),
          keyboardType: TextInputType.number,
          value: value.blue.toInt().toString(),
          onChanged: _onInputChanged((val) {
            final b = val.clamp(0.0, 255.0);
            onChanged?.call(value.changeToColorBlue(b));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 255)],
        ),
      ),
      if (showAlpha)
        SizedBox(
          width: 64,
          child: _ColorValueInput(
            placeholder: Text(locale.colorAlpha),
            keyboardType: TextInputType.number,
            value: (value.opacity * 255).toInt().toString(),
            onChanged: _onInputChanged((val) {
              final a = val.clamp(0.0, 255.0) / 255.0;
              onChanged?.call(value.changeToOpacity(a));
            }),
            inputFormatters: [
              TextInputFormatters.integerOnly(min: 0, max: 255),
            ],
          ),
        ),
    ];
  }

  /// Builds HSL color input widgets.
  List<Widget> buildHSLInputs(BuildContext context) {
    final locale = ShadcnLocalizations.of(context);
    return [
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorHue),
          keyboardType: TextInputType.number,
          value: value.hslHue.toInt().toString(),
          onChanged: _onInputChanged((val) {
            final h = val.clamp(0.0, 360.0);
            onChanged?.call(value.changeToHSLHue(h));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 360)],
        ),
      ),
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorSaturation),
          keyboardType: TextInputType.number,
          value: (value.hslSat * 100).toInt().toString(),
          onChanged: _onInputChanged((val) {
            final s = (val.clamp(0.0, 100.0)) / 100.0;
            onChanged?.call(value.changeToHSLSaturation(s));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 100)],
        ),
      ),
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorLightness),
          keyboardType: TextInputType.number,
          value: (value.hslVal * 100).toInt().toString(),
          onChanged: _onInputChanged((val) {
            final l = (val.clamp(0.0, 100.0)) / 100.0;
            onChanged?.call(value.changeToHSLLightness(l));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 100)],
        ),
      ),
      if (showAlpha)
        SizedBox(
          width: 64,
          child: _ColorValueInput(
            placeholder: Text(locale.colorAlpha),
            keyboardType: TextInputType.number,
            value: (value.opacity * 100).toInt().toString(),
            onChanged: _onInputChanged((val) {
              final a = (val.clamp(0.0, 100.0)) / 100.0;
              onChanged?.call(value.changeToOpacity(a));
            }),
            inputFormatters: [
              TextInputFormatters.integerOnly(min: 0, max: 100),
            ],
          ),
        ),
    ];
  }

  /// Builds HSV color input widgets.
  List<Widget> buildHSVInputs(BuildContext context) {
    final locale = ShadcnLocalizations.of(context);
    return [
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorHue),
          keyboardType: TextInputType.number,
          value: value.hsvHue.toInt().toString(),
          onChanged: _onInputChanged((val) {
            final h = val.clamp(0.0, 360.0);
            onChanged?.call(value.changeToHSVHue(h));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 360)],
        ),
      ),
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorSaturation),
          keyboardType: TextInputType.number,
          value: (value.hsvSat * 100).toInt().toString(),
          onChanged: _onInputChanged((val) {
            final s = (val.clamp(0.0, 100.0)) / 100.0;
            onChanged?.call(value.changeToHSVSaturation(s));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 100)],
        ),
      ),
      SizedBox(
        width: 64,
        child: _ColorValueInput(
          placeholder: Text(locale.colorValue),
          keyboardType: TextInputType.number,
          value: (value.hsvVal * 100).toInt().toString(),
          onChanged: _onInputChanged((val) {
            final v = (val.clamp(0.0, 100.0)) / 100.0;
            onChanged?.call(value.changeToHSVValue(v));
          }),
          inputFormatters: [TextInputFormatters.integerOnly(min: 0, max: 100)],
        ),
      ),
      if (showAlpha)
        SizedBox(
          width: 64,
          child: _ColorValueInput(
            placeholder: Text(locale.colorAlpha),
            keyboardType: TextInputType.number,
            value: (value.opacity * 100).toInt().toString(),
            onChanged: _onInputChanged((val) {
              final a = (val.clamp(0.0, 100.0)) / 100.0;
              onChanged?.call(value.changeToOpacity(a));
            }),
            inputFormatters: [
              TextInputFormatters.integerOnly(min: 0, max: 100),
            ],
          ),
        ),
    ];
  }

  /// Performs `_toHex` logic for this form component.
  String _toHex() {
    int r = value.red.toInt();
    int g = value.green.toInt();
    int b = value.blue.toInt();
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}';
  }

  /// Builds HEX color input widgets.
  List<Widget> buildHEXInputs(BuildContext context) {
    final locale = ShadcnLocalizations.of(context);
    return [
      SizedBox(
        width: 100,
        child: _ColorValueInput(
          placeholder: Text(locale.colorPickerTabHEX),
          keyboardType: TextInputType.text,
          value: _toHex(),
          onChanged: (val) {
            var hex = val.trim();
            if (hex.startsWith('#')) {
              hex = hex.substring(1);
            }
            if (hex.length == 6) {
              final r = int.parse(hex.substring(0, 2), radix: 16);
              final g = int.parse(hex.substring(2, 4), radix: 16);
              final b = int.parse(hex.substring(4, 6), radix: 16);
              onChanged?.call(
                value
                    .changeToColorRed(r.toDouble())
                    .changeToColorGreen(g.toDouble())
                    .changeToColorBlue(b.toDouble()),
              );
            }
          },
          inputFormatters: [TextInputFormatters.hex(hashPrefix: true)],
        ),
      ),
      if (showAlpha)
        SizedBox(
          width: 64,
          child: _ColorValueInput(
            placeholder: Text(locale.colorAlpha),
            keyboardType: TextInputType.number,
            value: (value.opacity * 100).toInt().toString(),
            onChanged: _onInputChanged((val) {
              final a = (val.clamp(0.0, 100.0)) / 100.0;
              onChanged?.call(value.changeToOpacity(a));
            }),
            inputFormatters: [
              TextInputFormatters.integerOnly(min: 0, max: 100),
            ],
          ),
        ),
    ];
  }
}
