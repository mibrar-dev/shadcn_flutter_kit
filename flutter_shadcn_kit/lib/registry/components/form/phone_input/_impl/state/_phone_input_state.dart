// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../phone_input.dart';

/// _PhoneInputState stores and manages mutable widget state.
///
/// Keeps the dial-code prefix in the text field in sync with the selected
/// country ([_lastValidCountry]) and auto-detects the country when the user
/// edits the prefix manually ([_findByCode]).
class _PhoneInputState extends State<PhoneInput>
    with FormValueSupplier<PhoneNumber, PhoneInput> {
  late TextEditingController _controller;
  late bool _updatingPhone = false;
  late Country _lastValidCountry;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        TextEditingController(text: widget.initialValue?.number);
    _lastValidCountry =
        widget.initialValue?.country ??
        widget.initialCountry ??
        Country.unitedStates;
    _updateCountry(_lastValidCountry);
    formValue = value;
    _controller.addListener(_dispatchChanged);
  }

  void _updateCountry(Country country) {
    if (_updatingPhone) return;
    _updatingPhone = true;
    final textValue = _controller.value;
    var selection = textValue.selection;
    // get the plain number
    String number = textValue.text;
    String expectedDialCode = _lastValidCountry.dialCode;
    if (number.startsWith(expectedDialCode)) {
      number = number.substring(expectedDialCode.length);
      selection = selection.copyWith(
        baseOffset: selection.baseOffset - expectedDialCode.length,
        extentOffset: selection.extentOffset - expectedDialCode.length,
      );
    } else if (number.startsWith('+')) {
      // unknown code, but lets remove the + first
      number = number.substring(1);
      selection = selection.copyWith(
        baseOffset: selection.baseOffset - 1,
        extentOffset: selection.extentOffset - 1,
      );
    }
    String newDialCode = country.dialCode;
    number = '$newDialCode$number';
    selection = selection.copyWith(
      baseOffset: selection.baseOffset + newDialCode.length,
      extentOffset: selection.extentOffset + newDialCode.length,
    );
    _controller.value = TextEditingValue(text: number, selection: selection);
    _lastValidCountry = country;
    _updatingPhone = false;
  }

  Country? _findByCode(String phone) {
    if (phone.startsWith('+')) {
      phone = phone.substring(1);
    }
    List<Country> sortedCountries = Country.values.toList()
      ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));
    // Sort countries by dial code length in descending order to ensure the longest match is found first
    for (final country in sortedCountries) {
      var dialCode = country.dialCode;
      // sanitize
      if (dialCode.startsWith('+')) {
        dialCode = dialCode.substring(1);
      }
      if (phone.startsWith(dialCode)) {
        return country;
      }
    }
    return null;
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
    setState(() {
      Country? detectedCountry = _findByCode(_controller.text);
      if (detectedCountry != null) {
        final validCountry = detectedCountry;
        if (validCountry.dialCode != _lastValidCountry.dialCode) {
          // some country have same dialCode (e.g. US and Canada),
          // so we use the preferred country
          _lastValidCountry = validCountry;
        } else {
          detectedCountry = _lastValidCountry;
        }
      }
      widget.onChanged?.call(value?.withCountry(detectedCountry));
      formValue = value;
    });
  }

  PhoneNumber? get value {
    var text = _controller.text;
    String dialCode = _lastValidCountry.dialCode;
    if (text.startsWith(dialCode)) {
      text = text.substring(dialCode.length);
    }
    return PhoneNumber(_lastValidCountry, text);
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
            expandIcon: null,
            value: _lastValidCountry,
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
                  _updateCountry(value);
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
                _AlwaysPrefixedPlus(),
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
