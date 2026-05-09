// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color_picker.dart';

/// _ColorPickerState stores and manages mutable widget state.
class _ColorPickerState extends State<ColorPicker> {
  /// Field storing `_mode` for this form implementation.
  late ColorPickerMode _mode;

  /// Current value stored for `_changingValue`.
  ColorDerivative? _changingValue;

  /// Field storing `_showHistory` for this form implementation.
  late bool _showHistory;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    _showHistory = widget.initialShowHistory;
  }

  ColorDerivative get _effectiveValue {
    return _changingValue ?? widget.value;
  }

  /// Performs `_onChanging` logic for this form component.
  void _onChanging(ColorDerivative value) {
    /// Triggers a rebuild after mutating local state.
    setState(() {
      _changingValue = value;
      widget.onChanging?.call(value);
    });
  }

  /// Performs `_onChanged` logic for this form component.
  void _onChanged(ColorDerivative value) {
    /// Triggers a rebuild after mutating local state.
    setState(() {
      _changingValue = null;
      widget.onChanged?.call(value);
    });
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final componentTheme = ComponentTheme.maybeOf<ColorPickerTheme>(context);
    final spacing = styleValue(
      defaultValue: 12.0,
      themeValue: componentTheme?.spacing,
      widgetValue: widget.spacing,
    );
    final controlSpacing = styleValue(
      defaultValue: 8.0,
      themeValue: componentTheme?.controlSpacing,
      widgetValue: widget.controlSpacing,
    );
    final orientation = styleValue(
      defaultValue: Axis.vertical,
      themeValue: componentTheme?.orientation,
      widgetValue: widget.orientation,
    );

    var colorControls = ColorControls(
      value: _effectiveValue,
      onChanged: _onChanged,
      onChanging: _onChanging,
      showAlpha: widget.showAlpha,
      mode: _mode,
      enableEyeDropper: widget.enableEyeDropper,
      onEyeDropperRequested: widget.onEyeDropperRequested,
      showHistory: _showHistory,
      showHistoryButton:
          widget.showHistoryButton && orientation == Axis.vertical,
      onShowHistoryChanged: (show) {
        /// Triggers a rebuild after mutating local state.
        setState(() {
          _showHistory = show;
        });
      },
      onModeChanged: (mode) {
        /// Triggers a rebuild after mutating local state.
        setState(() {
          _mode = mode;
        });
        widget.onModeChanged?.call(mode);
      },
      controlSpacing: styleValue(
        defaultValue: 8.0,
        themeValue: componentTheme?.controlSpacing,
        widgetValue: widget.controlSpacing,
      ),
    );
    var content = Flex(
      direction: orientation,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: _showHistory && orientation == Axis.vertical
          ? [
              ColorHistoryGrid(
                storage: ColorHistoryStorage.of(context),
                onColorPicked: (value) {
                  _onChanging(_effectiveValue.changeToColor(value));
                  _onChanged(_effectiveValue.changeToColor(value));
                },
                selectedColor: _effectiveValue.toColor(),
              ),
            ]
          : [
              Flexible(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 150.0 * theme.scaling,
                      minWidth: 150.0 * theme.scaling,
                    ),
                    child: buildSlider(context),
                  ),
                ),
              ),
              if (orientation == Axis.horizontal)
                ...buildSliders(context)
              else
                IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: controlSpacing,
                    children: [
                      if (orientation == Axis.vertical)
                        ...buildSliders(context),
                      colorControls,
                    ],
                  ),
                ),
            ],
    );
    if (orientation == Axis.horizontal) {
      return IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing,
          children: [
            IntrinsicHeight(child: content),
            colorControls,
          ],
        ),
      );
    }
    return IntrinsicWidth(child: content);
  }

  /// Performs `buildSliders` logic for this form component.
  List<Widget> buildSliders(BuildContext context) {
    final componentTheme = ComponentTheme.maybeOf<ColorPickerTheme>(context);
    final sliderSize = styleValue(
      defaultValue: 24.0,
      themeValue: componentTheme?.sliderSize,
      widgetValue: widget.sliderSize,
    );
    final orientation = styleValue(
      defaultValue: Axis.vertical,
      themeValue: componentTheme?.orientation,
      widgetValue: widget.orientation,
    );
    return [
      SizedBox(
        height: orientation == Axis.vertical ? sliderSize : null,
        width: orientation == Axis.horizontal ? sliderSize : null,
        child: HSVColorSlider(
          reverse: orientation == Axis.vertical,
          radius: Theme.of(context).radiusSmRadius,
          value: _effectiveValue
              .toHSVColor()
              .withSaturation(1.0)
              .withValue(1.0),
          onChanging: (hsvColor) {
            final hue = hsvColor.hue;
            _onChanging(_effectiveValue.changeToHSVHue(hue));
          },
          onChanged: (hsvColor) {
            final hue = hsvColor.hue;
            _onChanged(_effectiveValue.changeToHSVHue(hue));
          },
          sliderType: HSVColorSliderType.hue,
        ),
      ),
      if (widget.showAlpha)
        SizedBox(
          height: orientation == Axis.vertical ? sliderSize : null,
          width: orientation == Axis.horizontal ? sliderSize : null,
          child: HSVColorSlider(
            reverse: orientation == Axis.vertical,
            radius: Theme.of(context).radiusSmRadius,
            value: _effectiveValue.toHSVColor(),
            onChanging: (hsvColor) {
              final alpha = hsvColor.alpha;
              _onChanging(_effectiveValue.changeToOpacity(alpha));
            },
            onChanged: (hsvColor) {
              final alpha = hsvColor.alpha;
              _onChanged(_effectiveValue.changeToOpacity(alpha));
            },
            sliderType: HSVColorSliderType.alpha,
          ),
        ),
      if (orientation == Axis.horizontal && widget.showHistoryButton)
        ColorHistoryGrid(
          storage: ColorHistoryStorage.of(context),
          crossAxisCount: 2,
          maxTotalColors: 14,
          onColorPicked: (value) {
            _onChanging(_effectiveValue.changeToColor(value));
            _onChanged(_effectiveValue.changeToColor(value));
          },
          selectedColor: _effectiveValue.toColor(),
        ),
    ];
  }

  /// Performs `buildSlider` logic for this form component.
  Widget buildSlider(BuildContext context) {
    return switch (widget.initialMode) {
      ColorPickerMode.hsl => buildHSLSlider(context),
      _ => buildHSVSlider(context),
    };
  }

  /// Performs `buildHSVSlider` logic for this form component.
  Widget buildHSVSlider(BuildContext context) {
    return HSVColorSlider(
      value: _effectiveValue.toHSVColor(),
      sliderType: HSVColorSliderType.satVal,
      radius: Theme.of(context).radiusSmRadius,
      onChanging: (hsvColor) {
        final sat = hsvColor.saturation;
        final val = hsvColor.value;
        _onChanging(
          _effectiveValue.changeToHSVSaturation(sat).changeToHSVValue(val),
        );
      },
      onChanged: (hsvColor) {
        final sat = hsvColor.saturation;
        final val = hsvColor.value;
        _onChanged(
          _effectiveValue.changeToHSVSaturation(sat).changeToHSVValue(val),
        );
      },
    );
  }

  /// Performs `buildHSLSlider` logic for this form component.
  Widget buildHSLSlider(BuildContext context) {
    return HSLColorSlider(
      color: _effectiveValue.toHSLColor(),
      sliderType: HSLColorSliderType.satLum,
      radius: Theme.of(context).radiusSmRadius,
      onChanging: (hslColor) {
        final sat = hslColor.saturation;
        final light = hslColor.lightness;
        _onChanging(
          _effectiveValue
              .changeToHSLSaturation(sat)
              .changeToHSLLightness(light),
        );
      },
      onChanged: (hslColor) {
        final sat = hslColor.saturation;
        final light = hslColor.lightness;
        _onChanged(
          _effectiveValue
              .changeToHSLSaturation(sat)
              .changeToHSLLightness(light),
        );
      },
    );
  }
}
