// The `phone_input` component: a searchable country selector (flag + dial
// code) next to a national-number field, wired into the form system.
//
// Widgets-only. The country table lives in `primitives/countries.dart`, the
// value types in `primitives/phone_number.dart`, flags come from the
// `country_flag` component, the dropdown from `select` and the number field
// from `input`.
//
// Old bugs fixed, not ported: `_updateCountry` did unclamped selection
// arithmetic (assert/caret corruption) — offsets are clamped now; shared dial
// codes reported the previous country; the listener fired on selection-only
// changes; the controller was never disposed and leaked on a swap;
// `searchPlaceholder` was dead; country search was case-sensitive;
// `countries` did not bound detection; the deprecated `filter*` no-ops and
// the forced `+` formatter are gone; `onChanged` and the form value could
// disagree.
//
// Typed-prefix detection: typing `+44…` selects the matching country (longest
// dial-code match; shared codes like `+1` prefer the current selection). The
// field may carry the dial-code prefix; `PhoneNumber.number` is the national
// number.

import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../primitives/countries.dart';
import '../../primitives/form_core/form_core.dart';
import '../../primitives/form_core/form_value.dart';
import '../../primitives/form_core/validation.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/phone_number.dart';
import '../../theme/theme.dart';
import '../country_flag/country_flag.dart';
import '../input/input.dart';
import '../select/select.dart';
import 'phone_input_style.dart';

export 'phone_input_style.dart';
export '../../primitives/phone_number.dart' show Country, PhoneNumber;

/// Fails when the number is missing, or has no country or no digits.
///
/// No format/length rule is invented: the old validator checked the same two
/// conditions.
class PhoneNumberValidator extends Validator<PhoneNumber> {
  /// Creates a phone number validator.
  const PhoneNumberValidator({this.invalidMessage, this.emptyMessage});

  /// Failure text for a country-less or empty number; null uses
  /// `formPhoneNumberInvalid`.
  final String? invalidMessage;

  /// Failure text for a null value; null uses `formPhoneNumberEmpty`.
  final String? emptyMessage;

  @override
  FutureOr<ValidationResult?> validate(
    BuildContext context,
    PhoneNumber? value,
    FormValidationMode lifecycle,
  ) {
    final ShadcnLocalizations l10n = ShadcnLocalizations.of(context);
    if (value == null) {
      return InvalidResult(
        emptyMessage ?? l10n.formPhoneNumberEmpty,
        state: lifecycle,
      );
    }
    if (value.country == null || value.number.isEmpty) {
      return InvalidResult(
        invalidMessage ?? l10n.formPhoneNumberInvalid,
        state: lifecycle,
      );
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is PhoneNumberValidator &&
      other.invalidMessage == invalidMessage &&
      other.emptyMessage == emptyMessage;

  @override
  int get hashCode => Object.hash(emptyMessage, invalidMessage);
}

/// A country selector plus a number field (an optional dial-code prefix plus
/// the national number). `onChanged` reports a [PhoneNumber] whenever either
/// side changes, and null while the number is empty.
class PhoneInput extends StatefulWidget {
  const PhoneInput({
    super.key,
    this.initialCountry,
    this.initialValue,
    this.onChanged,
    this.controller,
    this.onlyNumber = true,
    this.countries,
    this.searchPlaceholder,
    this.theme,
  });

  /// Country selected when [initialValue] carries none.
  final Country? initialCountry;

  /// Initial country + national number.
  final PhoneNumber? initialValue;

  /// Called with the next value; null while the number is empty.
  final ValueChanged<PhoneNumber?>? onChanged;

  /// External text controller for the national number. When null the widget
  /// owns one seeded from [initialValue].
  final TextEditingController? controller;

  /// Whether the number field accepts digits only.
  final bool onlyNumber;

  /// Rows offered by the selector; null uses the full ISO table.
  final List<CountryInfo>? countries;

  /// Placeholder of the selector's search field.
  final Widget? searchPlaceholder;

  /// Widget-leg style override, merged on top of the component/app/defaults.
  final PhoneInputTheme? theme;

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput>
    with FormValueSupplier<PhoneNumber, PhoneInput> {
  static const Country _defaultCountry = Country(dialCode: '+1', code: 'US');

  late TextEditingController _controller;
  late bool _ownsController;
  late Country _country;
  String _lastText = '';
  bool _syncing = false;

  String get _nationalNumber {
    final String text = _controller.text;
    final String code = _country.dialCode;
    return text.startsWith(code) ? text.substring(code.length) : text;
  }

  PhoneNumber? get _value {
    final String national = _nationalNumber;
    return national.isEmpty ? null : PhoneNumber(_country, national);
  }

  /// The country a typed `+` prefix names, or null. Longest dial-code match
  /// wins; among equal-length matches the current selection wins, then the
  /// row marked [CountryInfo.primary] (`+1` → US, `+44` → GB, ...), otherwise
  /// the first row in [source].
  Country? _detectCountry(String text, List<CountryInfo> source) {
    if (!text.startsWith('+')) return null;
    int rank(CountryInfo info) =>
        info.code == _country.code ? 2 : (info.primary ? 1 : 0);
    Country? best;
    var bestLength = 0;
    var bestRank = -1;
    for (final CountryInfo info in source) {
      final String code = info.dialCode;
      if (!text.startsWith(code) || code.length < bestLength) continue;
      final int candidateRank = rank(info);
      if (code.length > bestLength || candidateRank > bestRank) {
        best = info.country;
        bestLength = code.length;
        bestRank = candidateRank;
      }
    }
    return best;
  }

  @override
  void initState() {
    super.initState();
    _country =
        widget.initialValue?.country ??
        widget.initialCountry ??
        _defaultCountry;
    _attachController(widget.controller, seed: true);
    formValue = _value;
  }

  void _attachController(
    TextEditingController? controller, {
    bool seed = false,
  }) {
    _ownsController = controller == null;
    _controller = controller ?? TextEditingController();
    if (seed && _ownsController) {
      _controller.text = widget.initialValue?.fullNumber ?? '';
    }
    _lastText = _controller.text;
    _controller.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(covariant PhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleTextChanged);
      if (_ownsController) _controller.dispose();
      _attachController(widget.controller, seed: true);
    } else if (_ownsController &&
        widget.initialValue != oldWidget.initialValue) {
      _syncing = true;
      _controller.text = widget.initialValue?.fullNumber ?? '';
      _lastText = _controller.text;
      _syncing = false;
    }
    if (widget.initialValue != oldWidget.initialValue ||
        widget.initialCountry != oldWidget.initialCountry) {
      final Country? next =
          widget.initialValue?.country ?? widget.initialCountry;
      if (next != null) _country = next;
      formValue = _value;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  /// Reports a text change once per edit (the controller also notifies for
  /// selection-only changes, which must not fire `onChanged`).
  void _handleTextChanged() {
    if (_syncing || _controller.text == _lastText) return;
    _lastText = _controller.text;
    final Country? detected = _detectCountry(
      _lastText,
      widget.countries ?? countryTable,
    );
    if (detected != null && detected != _country) _country = detected;
    final PhoneNumber? value = _value;
    setState(() {});
    formValue = value;
    widget.onChanged?.call(value);
  }

  /// Switches the country and rewrites the dial-code prefix in place.
  ///
  /// Offsets are clamped (the old `_updateCountry` subtracted the code length
  /// unchecked and could assert or corrupt the caret).
  void _onCountryChanged(Country? next) {
    if (next == null || next == _country) return;
    final String text = _controller.text;
    final String oldCode = _country.dialCode;
    final String rest = text.startsWith(oldCode)
        ? text.substring(oldCode.length)
        : text;
    final String nextText = rest.isEmpty
        ? next.dialCode
        : '${next.dialCode}$rest';
    final TextSelection selection = _controller.selection;
    final int delta = nextText.length - text.length;
    _syncing = true;
    _country = next;
    _controller.value = TextEditingValue(
      text: nextText,
      selection: TextSelection(
        baseOffset: (selection.baseOffset + delta).clamp(0, nextText.length),
        extentOffset: (selection.extentOffset + delta).clamp(
          0,
          nextText.length,
        ),
      ),
    );
    _lastText = nextText;
    _syncing = false;
    final PhoneNumber? value = _value;
    setState(() {});
    formValue = value;
    widget.onChanged?.call(value);
  }

  @override
  void didReplaceFormValue(PhoneNumber value) {
    _syncing = true;
    _country = value.country ?? _country;
    _controller.text = value.fullNumber;
    _lastText = _controller.text;
    _syncing = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final PhoneInputTheme style =
        resolveComponentStyle<PhoneInputTheme, PhoneInputTheme>(
          context,
          widget: widget.theme,
          select: (t) => t,
          defaults: phoneInputDefaults,
        );
    final double flagWidth = (style.flagWidth ?? 24) * ambient.scaling;
    final double flagHeight = (style.flagHeight ?? 18) * ambient.scaling;
    final double flagGap = style.flagGap ?? 8;
    final List<CountryInfo> source = widget.countries ?? countryTable;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: style.selectWidth ?? 180,
          child: Select<Country>(
            value: _country,
            onChanged: _onCountryChanged,
            searchPlaceholder: widget.searchPlaceholder,
            popupConstraints:
                style.popupConstraints ??
                const BoxConstraints(maxWidth: 250, maxHeight: 300),
            builder: (context, query) => _countryRows(
              source,
              query,
              flagWidth: flagWidth,
              flagHeight: flagHeight,
              flagGap: flagGap,
              countryGap: style.countryGap ?? 16,
            ),
            itemBuilder: (context, country) => Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CountryFlag(country, width: flagWidth, height: flagHeight),
                Gap(flagGap),
                Text(country.dialCode),
              ],
            ),
          ),
        ),
        Gap(style.fieldGap ?? 8),
        SizedBox(
          width: style.maxWidth ?? 200,
          child: Input(
            controller: _controller,
            keyboardType: TextInputType.phone,
            autofillHints: const <String>[AutofillHints.telephoneNumber],
            inputFormatters: widget.onlyNumber
                ? phoneInputNumberFormatters()
                : null,
            padding: style.inputPadding,
          ),
        ),
      ],
    );
  }

  List<Widget> _countryRows(
    List<CountryInfo> source,
    String? query, {
    required double flagWidth,
    required double flagHeight,
    required double flagGap,
    required double countryGap,
  }) {
    final String needle = query?.trim().toLowerCase() ?? '';
    return <Widget>[
      for (final CountryInfo info in source)
        if (needle.isEmpty ||
            info.name.toLowerCase().contains(needle) ||
            info.code.toLowerCase().contains(needle) ||
            info.dialCode.contains(needle))
          SelectItem<Country>(
            value: info.country,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CountryFlag(info.country, width: flagWidth, height: flagHeight),
                Gap(flagGap),
                Expanded(
                  child: Text(info.name, overflow: TextOverflow.ellipsis),
                ),
                Gap(countryGap),
                Text(info.dialCode),
              ],
            ),
          ),
    ];
  }
}
