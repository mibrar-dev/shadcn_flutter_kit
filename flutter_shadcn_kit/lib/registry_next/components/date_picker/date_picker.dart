// The `date_picker` component: [DatePicker] (single date), [DateRangePicker]
// (start/end span) and [DatePickerDialog] (the calendar sheet the B07 tree
// deferred here), all on the accepted `calendar` grid.
//
// Ported from `components/form/date_picker/**`. Fixed: the dialog no longer
// needs a 500px-wide dual pane to pick a range (the `calendar` range mode
// selects it in one grid); the trigger resolves all four theme legs.

import 'package:flutter/widgets.dart';

import '../../foundation/gap.dart';
import '../../foundation/icons/lucide_icons.dart';
import '../../primitives/clickable.dart';
import '../../primitives/date_math.dart';
import '../../primitives/form_core/object_form_field.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/localizations/localizations_extensions.dart';
import '../../theme/theme.dart';
import '../calendar/calendar.dart';
import 'date_picker_style.dart';

export 'date_picker_style.dart';

/// An immutable start/end date span picked by [DateRangePicker].
class DateTimeRange {
  /// Creates a range; const so themes and tests stay values-only.
  const DateTimeRange(this.start, this.end);

  /// First day of the span.
  final DateTime start;

  /// Last day of the span; never before [start].
  final DateTime end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateTimeRange && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// Resolves [DatePickerTheme] through widget > tree > app > defaults.
DatePickerTheme _resolveDatePickerTheme(
  BuildContext context,
  DatePickerTheme? widget,
) => resolveComponentStyle<DatePickerTheme, DatePickerTheme>(
  context,
  widget: widget,
  select: (t) => t,
  defaults: datePickerDefaults,
);

/// A single-date field: a trigger showing the value (or the localized
/// placeholder) that opens a [DatePickerDialog] in a dialog or a popover.
class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.placeholder,
    this.mode,
    this.initialView,
    this.initialViewType,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.stateBuilder,
    this.enabled,
    this.theme,
  });
  final DateTime? value;
  final ValueChanged<DateTime?>? onChanged;
  final Widget? placeholder;
  final PromptMode? mode;
  final CalendarView? initialView;
  final CalendarViewType? initialViewType;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final Widget? dialogTitle;
  final DateStateBuilder? stateBuilder;
  final bool? enabled;
  final DatePickerTheme? theme;
  @override
  Widget build(BuildContext context) {
    final DatePickerTheme style = _resolveDatePickerTheme(context, theme);
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    return ObjectFormField<DateTime>(
      value: value,
      onChanged: onChanged,
      placeholder: placeholder ?? Text(strings.placeholderDatePicker),
      builder: (context, value) =>
          Text(strings.formatDateTime(value, showTime: false)),
      trailing: const Icon(LucideIcons.calendarDays),
      mode: mode ?? style.mode ?? PromptMode.dialog,
      popoverAlignment: popoverAlignment ?? style.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? style.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? style.popoverPadding,
      dialogTitle: dialogTitle,
      enabled: enabled,
      editorBuilder: (context, handler) => DatePickerDialog(
        initialView:
            initialView ??
            (handler.value == null
                ? null
                : CalendarView.fromDateTime(handler.value!)),
        initialViewType:
            initialViewType ?? style.initialViewType ?? CalendarViewType.date,
        selectionMode: CalendarSelectionMode.single,
        initialValue: handler.value == null
            ? null
            : CalendarValue.single(handler.value!),
        onChanged: (next) => handler.value = next is SingleCalendarValue
            ? next.date
            : handler.value,
        stateBuilder: stateBuilder,
      ),
    );
  }
}

/// A date-span field: like [DatePicker] but the calendar selects a range in
/// one grid (tap twice, or tap an endpoint to clear it).
class DateRangePicker extends StatelessWidget {
  const DateRangePicker({
    super.key,
    required this.value,
    this.onChanged,
    this.placeholder,
    this.mode,
    this.initialView,
    this.initialViewType,
    this.popoverAlignment,
    this.popoverAnchorAlignment,
    this.popoverPadding,
    this.dialogTitle,
    this.stateBuilder,
    this.enabled,
    this.theme,
  });
  final DateTimeRange? value;
  final ValueChanged<DateTimeRange?>? onChanged;
  final Widget? placeholder;
  final PromptMode? mode;
  final CalendarView? initialView;
  final CalendarViewType? initialViewType;
  final AlignmentGeometry? popoverAlignment;
  final AlignmentGeometry? popoverAnchorAlignment;
  final EdgeInsetsGeometry? popoverPadding;
  final Widget? dialogTitle;
  final DateStateBuilder? stateBuilder;
  final bool? enabled;
  final DatePickerTheme? theme;
  @override
  Widget build(BuildContext context) {
    final DatePickerTheme style = _resolveDatePickerTheme(context, theme);
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    return ObjectFormField<DateTimeRange>(
      value: value,
      onChanged: onChanged,
      placeholder: placeholder ?? Text(strings.placeholderDatePicker),
      builder: (context, value) => Text(
        '${strings.formatDateTime(value.start, showTime: false)} - '
        '${strings.formatDateTime(value.end, showTime: false)}',
      ),
      trailing: const Icon(LucideIcons.calendarRange),
      mode: mode ?? style.mode ?? PromptMode.dialog,
      popoverAlignment: popoverAlignment ?? style.popoverAlignment,
      popoverAnchorAlignment:
          popoverAnchorAlignment ?? style.popoverAnchorAlignment,
      popoverPadding: popoverPadding ?? style.popoverPadding,
      dialogTitle: dialogTitle,
      enabled: enabled,
      editorBuilder: (context, handler) => DatePickerDialog(
        initialView:
            initialView ??
            (handler.value == null
                ? null
                : CalendarView.fromDateTime(handler.value!.start)),
        initialViewType:
            initialViewType ?? style.initialViewType ?? CalendarViewType.date,
        selectionMode: CalendarSelectionMode.range,
        initialValue: handler.value == null
            ? null
            : CalendarValue.range(handler.value!.start, handler.value!.end),
        onChanged: (next) {
          if (next is RangeCalendarValue) {
            handler.value = DateTimeRange(next.start, next.end);
          } else if (next is SingleCalendarValue) {
            handler.value = DateTimeRange(next.date, next.date);
          } else {
            handler.value = null;
          }
        },
        stateBuilder: stateBuilder,
      ),
    );
  }
}

/// The calendar sheet behind both pickers (deferred here from the B07 tree):
/// a month/year stepper header over one [Calendar] grid.
///
/// Tapping a month drills into its days; tapping a year drills into its
/// months. The header title cycles date -> month -> year.
class DatePickerDialog extends StatefulWidget {
  /// Creates a date picker dialog.
  const DatePickerDialog({
    super.key,
    this.initialView,
    this.initialViewType = CalendarViewType.date,
    this.selectionMode = CalendarSelectionMode.single,
    this.initialValue,
    this.onChanged,
    this.stateBuilder,
  });

  final CalendarView? initialView;
  final CalendarViewType initialViewType;
  final CalendarSelectionMode selectionMode;
  final CalendarValue? initialValue;
  final ValueChanged<CalendarValue?>? onChanged;
  final DateStateBuilder? stateBuilder;
  @override
  State<DatePickerDialog> createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog> {
  late CalendarView _view;
  late CalendarViewType _viewType;
  CalendarValue? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _viewType = widget.initialViewType;
    final DateTime now = DateTime.now();
    _view =
        widget.initialView ??
        _viewOf(_value) ??
        CalendarView(now.year, now.month);
  }

  static CalendarView? _viewOf(CalendarValue? value) => switch (value) {
    SingleCalendarValue(:final date) => CalendarView.fromDateTime(date),
    RangeCalendarValue(:final start) => CalendarView.fromDateTime(start),
    MultiCalendarValue(dates: [final first, ...]) => CalendarView.fromDateTime(
      first,
    ),
    _ => null,
  };

  void _step(bool forward) => setState(() {
    _view = switch (_viewType) {
      CalendarViewType.date => forward ? _view.next : _view.previous,
      CalendarViewType.month => CalendarView(
        _view.year + (forward ? 1 : -1),
        _view.month,
      ),
      CalendarViewType.year => CalendarView(
        _view.year + (forward ? 16 : -16),
        _view.month,
      ),
    };
  });

  void _cycleViewType() => setState(() {
    _viewType = switch (_viewType) {
      CalendarViewType.date => CalendarViewType.month,
      CalendarViewType.month => CalendarViewType.year,
      CalendarViewType.year => CalendarViewType.date,
    };
  });

  String _header(ShadcnLocalizations strings) => switch (_viewType) {
    CalendarViewType.date => '${strings.getMonth(_view.month)} ${_view.year}',
    CalendarViewType.month => '${_view.year}',
    CalendarViewType.year => strings.datePickerSelectYear,
  };

  void _selected(CalendarValue? next) {
    if (next == null) {
      setState(() => _value = null);
      widget.onChanged?.call(null);
      return;
    }
    // Month/year taps drill in instead of selecting, in single mode.
    if (widget.selectionMode == CalendarSelectionMode.single) {
      final CalendarView? drill = switch ((_viewType, next)) {
        (CalendarViewType.month, SingleCalendarValue(:final date)) =>
          CalendarView.fromDateTime(date),
        (CalendarViewType.year, SingleCalendarValue(:final date)) =>
          CalendarView(date.year, _view.month),
        _ => null,
      };
      if (drill != null) {
        setState(() {
          _view = drill;
          _viewType = _viewType == CalendarViewType.year
              ? CalendarViewType.month
              : CalendarViewType.date;
        });
        return;
      }
    }
    setState(() => _value = next);
    widget.onChanged?.call(next);
  }

  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final ShadcnLocalizations strings = ShadcnLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            _HeaderButton(
              icon: LucideIcons.chevronLeft,
              onPressed: () => _step(false),
            ),
            Expanded(
              child: _HeaderButton(
                label: _header(strings),
                onPressed: _cycleViewType,
              ),
            ),
            _HeaderButton(
              icon: LucideIcons.chevronRight,
              onPressed: () => _step(true),
            ),
          ],
        ),
        Gap(theme.spacing.sm),
        Calendar(
          view: _view,
          viewType: _viewType,
          selectionMode: widget.selectionMode,
          value: _value,
          onChanged: _selected,
          onViewChanged: (view) => setState(() => _view = view),
          stateBuilder: widget.stateBuilder,
        ),
      ],
    );
  }
}

/// One header control: an icon step button or the title button cycling grids.
class _HeaderButton extends StatelessWidget {
  const _HeaderButton({this.icon, this.label, required this.onPressed})
    : assert(icon != null || label != null);

  final IconData? icon;
  final String? label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Clickable(
      onPressed: onPressed,
      decoration: WidgetStatePropertyAll<Decoration?>(
        BoxDecoration(borderRadius: theme.borderRadiusSm),
      ),
      textStyle: WidgetStatePropertyAll<TextStyle?>(
        theme.typography.small.copyWith(
          color: theme.colors.foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 8),
      ),
      child: icon == null
          ? Center(child: Text(label!))
          : IconTheme.merge(
              data: IconThemeData(color: theme.colors.foreground),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(icon, size: 16),
              ),
            ),
    );
  }
}
