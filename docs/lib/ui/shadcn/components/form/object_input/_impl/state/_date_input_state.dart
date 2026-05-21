// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../object_input.dart';

/// _DateInputState stores and manages mutable widget state.
class _DateInputState extends State<DateInput> {
  /// Controller used to coordinate `_controller` behavior.
  late ComponentController<NullableDate> _controller;

  /// Performs `_convertToDateTime` logic for this form component.
  NullableDate _convertToDateTime(List<String?> values) {
    Map<DatePart, String?> parts = {};
    var datePartsOrder =
        widget.datePartsOrder ?? ShadcnLocalizations.of(context).datePartsOrder;
    for (int i = 0; i < values.length; i++) {
      parts[datePartsOrder[i]] = values[i];
    }
    String? yearString = parts[DatePart.year];
    String? monthString = parts[DatePart.month];
    String? dayString = parts[DatePart.day];
    int? year = yearString == null || yearString.isEmpty
        ? null
        : int.tryParse(yearString);
    int? month = monthString == null || monthString.isEmpty
        ? null
        : int.tryParse(monthString);
    int? day = dayString == null || dayString.isEmpty
        ? null
        : int.tryParse(dayString);
    return NullableDate(year: year, month: month, day: day);
  }

  /// Performs `_convertFromDateTime` logic for this form component.
  List<String?> _convertFromDateTime(NullableDate? value) {
    var datePartsOrder =
        widget.datePartsOrder ?? ShadcnLocalizations.of(context).datePartsOrder;
    if (value == null) {
      return datePartsOrder.map((part) => null).toList();
    }
    var validDateTime = value.getDateTime(
      defaultYear: datePartsOrder.contains(DatePart.year) ? null : 0,
      defaultMonth: datePartsOrder.contains(DatePart.month) ? null : 1,
      defaultDay: datePartsOrder.contains(DatePart.day) ? null : 1,
    );
    if (validDateTime == null) {
      return datePartsOrder.map((part) => null).toList();
    }
    return datePartsOrder.map((part) {
      switch (part) {
        case DatePart.year:
          return validDateTime.year.toString();
        case DatePart.month:
          return validDateTime.month.toString();
        case DatePart.day:
          return validDateTime.day.toString();
      }
    }).toList();
  }

  /// Performs `_getWidth` logic for this form component.
  double _getWidth(DatePart part) {
    switch (part) {
      case DatePart.year:
        return 60;
      case DatePart.month:
        return 40;
      case DatePart.day:
        return 40;
    }
  }

  /// Performs `_getPlaceholder` logic for this form component.
  Widget _getPlaceholder(DatePart part) {
    var localizations = ShadcnLocalizations.of(context);
    return Text(localizations.getDatePartAbbreviation(part));
  }

  /// Performs `_getLength` logic for this form component.
  int _getLength(DatePart part) {
    switch (part) {
      case DatePart.year:
        return 4;
      case DatePart.month:
        return 2;
      case DatePart.day:
        return 2;
    }
  }

  /// Performs `_convertToNullableDate` logic for this form component.
  NullableDate _convertToNullableDate(DateTime? value) {
    if (value == null) {
      return NullableDate();
    }
    return NullableDate(year: value.year, month: value.month, day: value.day);
  }

  /// Performs `_convertFromNullableDate` logic for this form component.
  DateTime? _convertFromNullableDate(NullableDate value) {
    return value.getDateTime();
  }

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller = widget.controller == null
        ? ComponentValueController<NullableDate>(
            _convertToNullableDate(widget.initialValue),
          )
        : ConvertedController<DateTime?, NullableDate>(
            widget.controller!,
            BiDirectionalConvert(
              _convertToNullableDate,
              _convertFromNullableDate,
            ),
          );
  }

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    var datePartsOrder =
        widget.datePartsOrder ?? ShadcnLocalizations.of(context).datePartsOrder;
    return FormattedObjectInput<NullableDate>(
      popupBuilder: (context, controller) {
        return SurfaceCard(
          child: DatePickerDialog(
            initialViewType: widget.initialViewType ?? CalendarViewType.date,
            selectionMode: CalendarSelectionMode.single,
            initialValue: controller.value == null
                ? null
                : CalendarValue.single(controller.value!.date),
            initialView: widget.initialView ?? CalendarView.now(),
            stateBuilder: widget.stateBuilder,
            onChanged: (value) {
              var date = value?.toSingle().date;
              controller.value = NullableDate(
                year: date?.year,
                month: date?.month,
                day: date?.day,
              );
            },
          ),
        );
      },
      popoverIcon: const Icon(LucideIcons.calendarDays),
      converter: BiDirectionalConvert(_convertFromDateTime, _convertToDateTime),
      controller: _controller,
      initialValue: _convertToNullableDate(widget.initialValue),
      onChanged: (value) {
        widget.onChanged?.call(
          value == null ? null : _convertFromNullableDate(value),
        );
      },
      parts: datePartsOrder
          .map((part) {
            return InputPart.editable(
              length: _getLength(part),
              width: _getWidth(part),
              placeholder: widget.placeholders?[part] ?? _getPlaceholder(part),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            );
          })
          .joinSeparator(const InputPart.static('/'))
          .toList(),
    );
  }
}
