// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_input.dart';

/// _PhoneInputState stores and manages mutable widget state.
class _PhoneInputState extends State<PhoneInput>
    with FormValueSupplier<PhoneNumber, PhoneInput> {
  late Country _country;
  late TextEditingController _controller;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _country =
        widget.initialCountry ??
        widget.initialValue?.country ??
        Country.unitedStates;
    _controller =
        widget.controller ??
        TextEditingController(text: widget.initialValue?.number);
    formValue = value;
    _controller.addListener(_dispatchChanged);
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant PhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_dispatchChanged);
      _controller = widget.controller ?? TextEditingController();
      _controller.addListener(_dispatchChanged);
    }
  }

  /// Performs `_dispatchChanged` logic for this form component.
  void _dispatchChanged() {
    widget.onChanged?.call(value);
    formValue = value;
  }

  PhoneNumber get value {
    var text = _controller.text;
    if (widget.filterPlusCode && text.startsWith(_country.dialCode)) {
      text = text.substring(_country.dialCode.length);
    } else if (widget.filterPlusCode && text.startsWith('+')) {
      text = text.substring(1);
    } else if (widget.filterZeroCode && text.startsWith('0')) {
      text = text.substring(1);
    } else if (widget.filterCountryCode &&
        text.startsWith(_country.dialCode.substring(1))) {
      text = text.substring(_country.dialCode.length - 1);
    }
    return PhoneNumber(_country, text);
  }

  /// Performs `_filterCountryCode` logic for this form component.
  bool _filterCountryCode(Country country, String text) {
    return country.name.toLowerCase().contains(text) ||
        country.dialCode.contains(text) ||
        country.code.toLowerCase().contains(text);
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final componentTheme = ComponentTheme.maybeOf<PhoneInputTheme>(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Select<Country>(
            padding: styleValue(
              defaultValue: EdgeInsets.only(
                top: theme.density.baseContentPadding * theme.scaling * padXs,
                left: theme.density.baseContentPadding * theme.scaling * padXs,
                bottom:
                    theme.density.baseContentPadding * theme.scaling * padXs,
                right: theme.density.baseContentPadding * theme.scaling * 0.25,
              ),
              themeValue: componentTheme?.padding,
            ),
            value: _country,
            borderRadius: styleValue(
              defaultValue: BorderRadius.only(
                topLeft: theme.radiusMdRadius,
                bottomLeft: theme.radiusMdRadius,
              ),
              themeValue: componentTheme?.borderRadius,
            ),
            popoverAlignment: Alignment.topLeft,
            popoverAnchorAlignment: Alignment.bottomLeft,
            popupWidthConstraint: PopoverConstraint.flexible,
            onChanged: (value) {
              if (value != null) {
                /// Triggers a rebuild after mutating local state.
                setState(() {
                  _country = value;
                  _dispatchChanged();
                });
              }
            },
            itemBuilder: (context, item) {
              return Row(
                children: [
                  CountryFlag.fromCountryCode(
                    item.code,
                    theme: ImageTheme(
                      shape: styleValue(
                        defaultValue: RoundedRectangle(theme.radiusSm),
                        themeValue: componentTheme?.flagShape,
                      ),
                      height: styleValue(
                        defaultValue: theme.scaling * 18,
                        themeValue: componentTheme?.flagHeight,
                      ),
                      width: styleValue(
                        defaultValue: theme.scaling * 24,
                        themeValue: componentTheme?.flagWidth,
                      ),
                    ),
                  ),
                  Gap(
                    styleValue(
                      defaultValue:
                          theme.density.baseGap * theme.scaling * gapSm,
                      themeValue: componentTheme?.flagGap,
                    ),
                  ),
                  Text(item.dialCode),
                ],
              );
            },
            popupConstraints: styleValue(
              defaultValue: BoxConstraints(
                maxWidth: 250 * theme.scaling,
                maxHeight: 300 * theme.scaling,
              ),
              themeValue: componentTheme?.popupConstraints,
            ),
            popup: SelectPopup.builder(
              builder: (context, searchQuery) {
                return SelectItemList(
                  children: [
                    for (final country in widget.countries ?? Country.values)
                      if (searchQuery == null ||
                          _filterCountryCode(country, searchQuery))
                        SelectItemButton(
                          value: country,
                          child: Row(
                            children: [
                              CountryFlag.fromCountryCode(
                                country.code,
                                theme: ImageTheme(
                                  shape: styleValue(
                                    defaultValue: RoundedRectangle(
                                      theme.radiusSm,
                                    ),
                                    themeValue: componentTheme?.flagShape,
                                  ),
                                  height: styleValue(
                                    defaultValue: theme.scaling * 18,
                                    themeValue: componentTheme?.flagHeight,
                                  ),
                                  width: styleValue(
                                    defaultValue: theme.scaling * 24,
                                    themeValue: componentTheme?.flagWidth,
                                  ),
                                ),
                              ),
                              Gap(
                                styleValue(
                                  defaultValue:
                                      theme.density.baseGap *
                                      theme.scaling *
                                      gapSm,
                                  themeValue: componentTheme?.flagGap,
                                ),
                              ),
                              Expanded(child: Text(country.name)),
                              Gap(
                                styleValue(
                                  defaultValue:
                                      theme.density.baseGap *
                                      theme.scaling *
                                      gapLg,
                                  themeValue: componentTheme?.countryGap,
                                ),
                              ),
                              Text(country.dialCode).muted(),
                            ],
                          ),
                        ),
                  ],
                );
              },
            ).asBuilder,
          ),
          LimitedBox(
            maxWidth: styleValue(
              defaultValue: 200 * theme.scaling,
              themeValue: componentTheme?.maxWidth,
            ),
            child: TextField(
              controller: _controller,
              autofillHints: const [AutofillHints.telephoneNumber],
              keyboardType: widget.onlyNumber ? TextInputType.phone : null,
              inputFormatters: [
                if (widget.onlyNumber) FilteringTextInputFormatter.digitsOnly,
              ],
              borderRadius: styleValue(
                defaultValue: BorderRadius.only(
                  topRight: theme.radiusMdRadius,
                  bottomRight: theme.radiusMdRadius,
                ),
                themeValue: componentTheme?.borderRadius,
              ),
              initialValue: widget.initialValue?.number,
            ),
          ),
        ],
      ),
    );
  }

  /// Performs `didReplaceFormValue` logic for this form component.
  @override
  void didReplaceFormValue(PhoneNumber value) {
    _controller.text = value.toString();
  }
}
