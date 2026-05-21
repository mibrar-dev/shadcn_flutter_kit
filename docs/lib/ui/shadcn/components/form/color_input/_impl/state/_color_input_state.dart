// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../color_input.dart';

/// _ColorInputState stores and manages mutable widget state.
class _ColorInputState extends State<ColorInput>
    with FormValueSupplier<ColorDerivative, ColorInput> {
  ColorDerivative? _changingValue;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    formValue = widget.value;
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant ColorInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      formValue = widget.value;
    }
  }

  final ValueNotifier<bool> _showHistoryNotifier = ValueNotifier<bool>(false);

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final locale = ShadcnLocalizations.of(context);
    final theme = Theme.of(context);
    final componentTheme = ComponentTheme.maybeOf<ColorInputTheme>(context);
    final showAlpha = styleValue(
      defaultValue: true,
      themeValue: componentTheme?.showAlpha,
      widgetValue: widget.showAlpha,
    );
    final showLabel = styleValue(
      defaultValue: false,
      themeValue: componentTheme?.showLabel,
      widgetValue: widget.showLabel,
    );
    final popoverAlignment = styleValue(
      themeValue: componentTheme?.popoverAlignment,
      widgetValue: widget.popoverAlignment,
      defaultValue: Alignment.topCenter,
    );
    final popoverAnchorAlignment = styleValue(
      themeValue: componentTheme?.popoverAnchorAlignment,
      widgetValue: widget.popoverAnchorAlignment,
      defaultValue: Alignment.bottomCenter,
    );
    final popoverPadding = styleValue(
      themeValue: componentTheme?.popoverPadding,
      widgetValue: widget.popoverPadding,
      defaultValue: null,
    );
    final promptMode = styleValue(
      themeValue: componentTheme?.mode,
      widgetValue: widget.promptMode,
      defaultValue: PromptMode.popover,
    );
    final enableEyeDropper = styleValue(
      defaultValue: true,
      themeValue: componentTheme?.enableEyeDropper,
      widgetValue: widget.enableEyeDropper,
    );
    final initialMode = styleValue(
      themeValue: componentTheme?.pickerMode,
      widgetValue: widget.initialMode,
      defaultValue: ColorPickerMode.rgb,
    );
    final orientation = styleValue(
      defaultValue: null,
      themeValue: componentTheme?.orientation,
      widgetValue: widget.orientation,
    );
    final showHistory = styleValue(
      defaultValue: true,
      themeValue: componentTheme?.showHistory,
      widgetValue: widget.showHistory,
    );
    return ObjectFormField(
      value: widget.value,
      placeholder: widget.placeholder ?? Text(locale.placeholderColorPicker),
      immediateValueChange: promptMode == PromptMode.popover ? false : null,
      onChanged: (color) {
        if (color != null) {
          widget.onChanged?.call(color);
          ColorHistoryStorage.find(context).addHistory(color.toColor());

          /// Triggers a rebuild after mutating local state.
          setState(() {
            _changingValue = null;
          });
        }
      },
      dialogTitle: widget.dialogTitle,
      popoverAlignment: popoverAlignment,
      popoverAnchorAlignment: popoverAnchorAlignment,
      popoverPadding: popoverPadding,
      mode: promptMode,
      density: promptMode == PromptMode.popover
          ? ButtonDensity.iconDense
          : null,
      enabled: widget.enabled,
      builder: (context, value) {
        if (!showLabel) {
          return Container(
            key: const Key('color_input_preview'),
            constraints: promptMode == PromptMode.popover
                ? BoxConstraints(
                    minWidth: 28 * theme.scaling,
                    minHeight: 28 * theme.scaling,
                  )
                : const BoxConstraints(),
            decoration: BoxDecoration(
              color: (_changingValue ?? value).toColor(),
              borderRadius: BorderRadius.circular(theme.radiusSm),
              border: Border.all(color: theme.colorScheme.border),
            ),
          );
        }
        return IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(child: Text(colorToHex(value.toColor(), showAlpha))),
              DensityGap(gapSm),
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: value.toColor(),
                    borderRadius: BorderRadius.circular(theme.radiusSm),
                    border: Border.all(color: theme.colorScheme.border),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      dialogActions: (innerContext, handler) {
        return [
          if (enableEyeDropper)
            IconButton.outline(
              icon: Icon(LucideIcons.pipette, size: 16 * theme.scaling),
              onPressed: () async {
                await handler.close();
                if (!context.mounted) return;
                final result = await pickColorFromScreen(context);
                if (result != null && context.mounted) {
                  ColorHistoryStorage.of(context).addHistory(result);
                }
                handler.prompt(
                  result != null ? ColorDerivative.fromColor(result) : null,
                );
              },
            ),
          if (showHistory)
            ListenableBuilder(
              listenable: _showHistoryNotifier,
              builder: (context, _) {
                return IconButton(
                  variance: _showHistoryNotifier.value
                      ? ButtonVariance.primary
                      : ButtonVariance.outline,
                  icon: Icon(LucideIcons.history, size: 16 * theme.scaling),
                  onPressed: () {
                    _showHistoryNotifier.value = !_showHistoryNotifier.value;
                  },
                );
              },
            ),
        ];
      },
      editorBuilder: (context, handler) {
        return ListenableBuilder(
          listenable: _showHistoryNotifier,
          builder: (context, _) {
            return AnimatedSize(
              duration: kDefaultDuration,
              curve: Curves.easeInOut,
              child: ColorPicker(
                // force rebuild when showHistory changes
                key: ValueKey(_showHistoryNotifier.value),
                value:
                    handler.value ??
                    ColorDerivative.fromColor(Color(0x00000000)),
                initialShowHistory: _showHistoryNotifier.value,
                enableEyeDropper:
                    promptMode == PromptMode.popover && enableEyeDropper,
                showHistoryButton:
                    showHistory && promptMode == PromptMode.popover,
                onChanging: (color) {
                  widget.onChanging?.call(color);

                  /// Triggers a rebuild after mutating local state.
                  setState(() {
                    _changingValue = color;
                  });
                },
                onChanged: (color) {
                  handler.value = color;
                },
                initialMode: initialMode,
                onEyeDropperRequested: () async {
                  await handler.close();
                  if (!context.mounted) return;
                  final result = await pickColorFromScreen(context);
                  if (result != null && context.mounted) {
                    ColorHistoryStorage.of(context).addHistory(result);
                  }
                  handler.prompt(
                    result != null ? ColorDerivative.fromColor(result) : null,
                  );
                },
                orientation: orientation,
                showAlpha: showAlpha,
              ),
            );
          },
        );
      },
    );
  }

  /// Performs `didReplaceFormValue` logic for this form component.
  @override
  void didReplaceFormValue(ColorDerivative value) {
    widget.onChanged?.call(value);
  }
}
