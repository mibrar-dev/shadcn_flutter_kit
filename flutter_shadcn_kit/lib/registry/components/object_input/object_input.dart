// The `object_input` component: date/time/duration editors — `FormattedInput`
// segments plus a calendar prompt for dates (dialog or anchored popover).
//
// Ported from `components/form/object_input` (1,223 LOC). Fixes: `TimeOfDay`
// from `foundation/time_of_day.dart`; middle layers collapse into direct
// segment conversion. Shape builders and the prompt button live in
// `primitives/object_segments.dart`, cached per state behind a content key.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../foundation/time_of_day.dart';
import '../../primitives/date_math.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../primitives/localizations/locale_parts.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/localizations/localizations_extensions.dart';
import '../../primitives/object_segments.dart';
import '../../theme/theme.dart';
import '../calendar/calendar.dart';
import '../date_picker/date_picker.dart';
import '../dialog/dialog.dart';
import '../formatted_input/formatted_input.dart';

/// Segmented field behind the date/time/duration inputs. The shape rebuilds
/// only when [shapeKey] changes; live texts follow `TextField` semantics
/// (see [SegmentedObjectController]).
class _ClockField<T> extends StatefulWidget {
  const _ClockField({
    super.key,
    required this.shapeKey,
    required this.buildRungs,
    required this.value,
    required this.initialValue,
    required this.onChanged,
    required this.textsFor,
    required this.parse,
    this.enabled = true,
    this.validator,
    this.trailing,
    this.theme,
  });

  final Object shapeKey;
  final List<SegmentRung> Function(BuildContext context) buildRungs;
  final T? value;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final List<String> Function(T? value) textsFor;
  final T? Function(List<String> texts) parse;
  final bool enabled;
  final String? Function(T? value)? validator;
  final Widget? trailing;
  final FormattedInputTheme? theme;

  @override
  State<_ClockField<T>> createState() => _ClockFieldState<T>();
}

class _ClockFieldState<T> extends State<_ClockField<T>> {
  final SegmentedObjectController<T> _object = SegmentedObjectController<T>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_object.shape.parts.isEmpty) {
      _object.resyncShape(
        widget.buildRungs(context),
        widget.textsFor(widget.value ?? widget.initialValue),
      );
    }
  }

  @override
  void didUpdateWidget(covariant _ClockField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shapeKey != oldWidget.shapeKey) {
      setState(
        () => _object.resyncShape(
          widget.buildRungs(context),
          widget.textsFor(widget.value ?? widget.initialValue),
        ),
      );
    } else if (widget.value != oldWidget.value) {
      setState(() => _object.resyncValue(widget.textsFor(widget.value)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final SegmentedValue shown = _object.shown;
    return FormattedInput(
      value: shown,
      initialValue: shown,
      onChanged: (SegmentedValue segments) {
        final List<String> texts = <String>[
          for (final SegmentPart part in segments.values) part.value,
        ];
        _object.applyEdit(texts);
        setState(() {});
        widget.onChanged?.call(widget.parse(texts));
      },
      trailing: widget.trailing,
      enabled: widget.enabled,
      validator: widget.validator == null
          ? null
          : (_) => widget.validator!(widget.parse(_object.texts)),
      theme: widget.theme,
    );
  }
}

/// A typed date field: locale-ordered segments with a calendar prompt
/// (dialog or popover) behind the trailing button. Incomplete or impossible
/// dates report null; controlled with [value] + [onChanged], uncontrolled
/// with [initialValue], disabled with null [onChanged].
class DateInput extends StatelessWidget {
  /// Creates a date input.
  const DateInput({
    super.key,
    this.value,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.datePartsOrder,
    this.separator = '/',
    this.placeholders,
    this.validator,
    this.mode,
    this.initialView,
    this.initialViewType,
    this.stateBuilder,
    this.dialogTitle,
    this.theme,
  });

  /// Controlled value; null with [onChanged] set means "no date".
  final DateTime? value;

  /// Uncontrolled seed; ignored once the field owns its state.
  final DateTime? initialValue;

  /// Called with the next date (null while incomplete/invalid).
  final ValueChanged<DateTime?>? onChanged;

  /// Whether the field accepts input; disabled dims to 50%.
  final bool enabled;

  /// Segment order; null uses the locale order.
  final List<DatePart>? datePartsOrder;

  /// Text between segments.
  final String separator;

  /// Per-part placeholder overrides; null uses locale abbreviations.
  final Map<DatePart, Widget>? placeholders;

  /// Validates the parsed date; a non-null result shows below the field.
  final String? Function(DateTime? value)? validator;

  /// Calendar prompt presentation; null is popover on desktop widths
  /// (≥ 768 logical pixels), dialog below (popover needs `OverlayManager`).
  final PromptMode? mode;

  /// Calendar sheet: starting month view.
  final CalendarView? initialView;

  /// Calendar sheet: starting grid.
  final CalendarViewType? initialViewType;

  /// Calendar sheet: per-date enablement.
  final DateStateBuilder? stateBuilder;

  /// Optional title above the calendar dialog.
  final Widget? dialogTitle;

  /// Widget-leg theme override, forwarded to [FormattedInput].
  final FormattedInputTheme? theme;

  PromptMode _resolveMode(BuildContext context) =>
      mode ??
      ((MediaQuery.maybeSizeOf(context)?.width ?? 0) >= 768
          ? PromptMode.popover
          : PromptMode.dialog);

  /// Calendar sheet shared by both presentations; [onPick] reports the
  /// selection (and dismisses the dialog prompt).
  DatePickerDialog _calendarSheet(ValueChanged<CalendarValue?> onPick) {
    return DatePickerDialog(
      initialView:
          initialView ??
          (value == null ? null : CalendarView.fromDateTime(value!)),
      initialViewType: initialViewType ?? CalendarViewType.date,
      selectionMode: CalendarSelectionMode.single,
      initialValue: value == null ? null : CalendarValue.single(value!),
      stateBuilder: stateBuilder,
      onChanged: onPick,
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final CalendarValue? picked = await showShadcnDialog<CalendarValue>(
      context: context,
      builder: (BuildContext context) {
        final DatePickerDialog sheet = _calendarSheet(
          (CalendarValue? next) =>
              Navigator.of(context, rootNavigator: true).pop(next),
        );
        if (dialogTitle == null) return sheet;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[dialogTitle!, const Gap(8), sheet],
        );
      },
    );
    if (picked is SingleCalendarValue) onChanged?.call(picked.date);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    final ShadcnThemeData ambient = ShadcnTheme.of(context);
    final List<DatePart> order = datePartsOrder ?? strings.datePartsOrder;
    final String orderKey = order.map((DatePart part) => part.name).join(',');
    return _ClockField<DateTime>(
      shapeKey: (orderKey, separator, placeholders),
      buildRungs: (_) => dateSegmentRungs(
        order: order,
        separator: separator,
        abbreviations: strings.getDatePartAbbreviation,
        placeholders: placeholders,
      ),
      value: value,
      initialValue: initialValue,
      onChanged: onChanged,
      textsFor: (DateTime? date) => dateTextsFor(date, order),
      parse: (List<String> texts) => parseObjectDate(texts, order),
      enabled: enabled,
      validator: validator,
      trailing: ObjectPromptButton(
        mode: _resolveMode(context),
        enabled: enabled,
        contentBuilder: (BuildContext context) =>
            _calendarSheet((CalendarValue? next) {
              if (next is SingleCalendarValue) onChanged?.call(next.date);
            }),
        openDialog: () => _openDialog(context),
        child: Icon(
          LucideIcons.calendarDays,
          size: 16,
          color: ambient.colors.mutedForeground,
        ),
      ),
      theme: theme,
    );
  }
}

/// A typed time field: hour/minute(/second) segments. Controlled with
/// [value] + [onChanged]; uncontrolled with [initialValue]. Incomplete or
/// out-of-range times report null. Null [onChanged] disables.
/// (Dialog picking already lives in `time_picker`.)
class TimeInput extends StatelessWidget {
  /// Creates a time input.
  const TimeInput({
    super.key,
    this.value,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.showSeconds = false,
    this.separator = ':',
    this.placeholders,
    this.validator,
    this.theme,
  });

  /// Controlled value.
  final TimeOfDay? value;

  /// Uncontrolled seed.
  final TimeOfDay? initialValue;

  /// Called with the next time (null while incomplete/invalid).
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Whether the field accepts input; disabled dims to 50%.
  final bool enabled;

  /// Whether a seconds segment shows.
  final bool showSeconds;

  /// Text between segments.
  final String separator;

  /// Per-part placeholder overrides; null uses locale abbreviations.
  final Map<TimePart, Widget>? placeholders;

  /// Validates the parsed time; a non-null result shows below the field.
  final String? Function(TimeOfDay? value)? validator;

  /// Widget-leg theme override, forwarded to [FormattedInput].
  final FormattedInputTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    return _ClockField<TimeOfDay>(
      shapeKey: (showSeconds, separator, placeholders),
      buildRungs: (_) => timeSegmentRungs(
        showSeconds: showSeconds,
        separator: separator,
        abbreviations: strings.getTimePartAbbreviation,
        placeholders: placeholders,
      ),
      value: value,
      initialValue: initialValue,
      onChanged: onChanged,
      textsFor: (TimeOfDay? time) => timeTextsFor(time, showSeconds),
      parse: (List<String> texts) => parseObjectTime(texts, showSeconds),
      enabled: enabled,
      validator: validator,
      theme: theme,
    );
  }
}

/// A typed duration field: hour/minute(/second) segments. Controlled with
/// [value] + [onChanged]; uncontrolled with [initialValue]. Incomplete or
/// out-of-range durations report null. Null [onChanged] disables.
/// (Dialog picking already lives in `time_picker`.)
class DurationInput extends StatelessWidget {
  /// Creates a duration input.
  const DurationInput({
    super.key,
    this.value,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.showSeconds = false,
    this.separator = ':',
    this.placeholders,
    this.validator,
    this.theme,
  });

  /// Controlled value.
  final Duration? value;

  /// Uncontrolled seed.
  final Duration? initialValue;

  /// Called with the next duration (null while incomplete/invalid).
  final ValueChanged<Duration?>? onChanged;

  /// Whether the field accepts input; disabled dims to 50%.
  final bool enabled;

  /// Whether a seconds segment shows.
  final bool showSeconds;

  /// Text between segments.
  final String separator;

  /// Per-part placeholder overrides; null uses locale abbreviations.
  final Map<DurationPart, Widget>? placeholders;

  /// Validates the parsed duration; a non-null result shows below the field.
  final String? Function(Duration? value)? validator;

  /// Widget-leg theme override, forwarded to [FormattedInput].
  final FormattedInputTheme? theme;

  @override
  Widget build(BuildContext context) {
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    return _ClockField<Duration>(
      shapeKey: (showSeconds, separator, placeholders),
      buildRungs: (_) => durationSegmentRungs(
        showSeconds: showSeconds,
        separator: separator,
        abbreviations: strings.getDurationPartAbbreviation,
        placeholders: placeholders,
      ),
      value: value,
      initialValue: initialValue,
      onChanged: onChanged,
      textsFor: (Duration? duration) => durationTextsFor(duration, showSeconds),
      parse: (List<String> texts) => parseObjectDuration(texts, showSeconds),
      enabled: enabled,
      validator: validator,
      theme: theme,
    );
  }
}
