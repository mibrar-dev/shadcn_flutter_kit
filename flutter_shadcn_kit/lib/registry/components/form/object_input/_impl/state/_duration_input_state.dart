// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../object_input.dart';

/// _DurationInputState stores and manages mutable widget state.
class _DurationInputState extends State<DurationInput> {
  /// Controller used to coordinate `_controller` behavior.
  late ComponentController<NullableTimeOfDay> _controller;

  /// Performs `_convertToDuration` logic for this form component.
  NullableTimeOfDay _convertToDuration(List<String?> values) {
    int? hours = values[0] == null || values[0]!.isEmpty
        ? null
        : int.tryParse(values[0]!);
    int? minutes = values[1] == null || values[1]!.isEmpty
        ? null
        : int.tryParse(values[1]!);
    int? seconds = widget.showSeconds && values.length > 2
        ? (values[2] == null || values[2]!.isEmpty
              ? null
              : int.tryParse(values[2]!))
        : null;
    return NullableTimeOfDay(hour: hours, minute: minutes, second: seconds);
  }

  /// Performs `_convertFromDuration` logic for this form component.
  List<String?> _convertFromDuration(NullableTimeOfDay? value) {
    if (value == null) {
      return [null, null, if (widget.showSeconds) null];
    }
    final nullableTimeOfDay = value.getTimeOfDay(
      defaultHour: null,
      defaultMinute: null,
      defaultSecond: widget.showSeconds ? null : 0,
    );
    if (nullableTimeOfDay == null) {
      return [null, null, if (widget.showSeconds) null];
    }
    return [
      nullableTimeOfDay.hour.toString(),
      nullableTimeOfDay.minute.toString(),
      if (widget.showSeconds) nullableTimeOfDay.second.toString(),
    ];
  }

  /// Performs `_getWidth` logic for this form component.
  double _getWidth(TimePart part) {
    return 40;
  }

  /// Performs `_getPlaceholder` logic for this form component.
  Widget _getPlaceholder(TimePart part) {
    var localizations = ShadcnLocalizations.of(context);
    return Text(localizations.getTimePartAbbreviation(part));
  }

  /// Performs `_getLength` logic for this form component.
  int _getLength(TimePart part) {
    return 2;
  }

  /// Performs `_convertToNullableTimeOfDay` logic for this form component.
  NullableTimeOfDay _convertToNullableTimeOfDay(Duration? value) {
    if (value == null) {
      return NullableTimeOfDay();
    }
    return NullableTimeOfDay(
      hour: value.inHours,
      minute: value.inMinutes % 60,
      second: widget.showSeconds ? value.inSeconds % 60 : null,
    );
  }

  /// Performs `_convertFromNullableTimeOfDay` logic for this form component.
  Duration? _convertFromNullableTimeOfDay(NullableTimeOfDay value) {
    if (value.hour == null ||
        value.minute == null ||
        (widget.showSeconds && value.second == null)) {
      return null;
    }
    return Duration(
      hours: value.hour!,
      minutes: value.minute!,
      seconds: widget.showSeconds ? (value.second ?? 0) : 0,
    );
  }

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _controller = widget.controller == null
        ? ComponentValueController<NullableTimeOfDay>(
            _convertToNullableTimeOfDay(widget.initialValue),
          )
        : ConvertedController<Duration?, NullableTimeOfDay>(
            widget.controller!,
            BiDirectionalConvert(
              _convertToNullableTimeOfDay,
              _convertFromNullableTimeOfDay,
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
    return FormattedObjectInput<NullableTimeOfDay>(
      converter: BiDirectionalConvert(_convertFromDuration, _convertToDuration),
      controller: _controller,
      initialValue: _convertToNullableTimeOfDay(widget.initialValue),
      onChanged: (value) {
        widget.onChanged?.call(
          value == null ? null : _convertFromNullableTimeOfDay(value),
        );
      },
      parts: [
        InputPart.editable(
          length: _getLength(TimePart.hour),
          width: _getWidth(TimePart.hour),
          placeholder:
              widget.placeholders?[TimePart.hour] ??
              _getPlaceholder(TimePart.hour),
        ),
        widget.separator ?? const InputPart.static(':'),
        InputPart.editable(
          length: _getLength(TimePart.minute),
          width: _getWidth(TimePart.minute),
          placeholder:
              widget.placeholders?[TimePart.minute] ??
              _getPlaceholder(TimePart.minute),
        ),
        if (widget.showSeconds) ...[
          widget.separator ?? const InputPart.static(':'),
          InputPart.editable(
            length: _getLength(TimePart.second),
            width: _getWidth(TimePart.second),
            placeholder:
                widget.placeholders?[TimePart.second] ??
                _getPlaceholder(TimePart.second),
          ),
        ],
      ],
    );
  }
}
