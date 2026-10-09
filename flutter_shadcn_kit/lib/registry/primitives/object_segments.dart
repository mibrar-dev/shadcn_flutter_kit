// Shared segmented-object machinery: [SegmentRung] describes one editable
// rung, [buildObjectSegments]/[withObjectTexts] build and update the
// [SegmentedValue] shape, and the date/time/duration helpers parse and format
// the segment texts. Used by `object_input` (date, time, duration); any
// segmented editor can reuse it.
//
// Component-free on purpose (foundation/theme/primitives imports only), so a
// component can depend on it without a layer cycle. Rendering stays in the
// component: `FormattedInput` owns the field UI.

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../foundation/time_of_day.dart';
import '../theme/color_tokens.dart';
import 'clickable.dart';
import 'form_core/object_form_field.dart';
import 'localizations/locale_parts.dart';
import 'popover_controller.dart';
import 'text_editing/segmented_value.dart';

/// Digits-only formatters, shared by every segment (one instance keeps
/// `SegmentedValue.hasShape` stable across rebuilds).
final List<TextInputFormatter> digitsOnlyFormatters = <TextInputFormatter>[
  FilteringTextInputFormatter.digitsOnly,
];

/// One editable rung of a structured field.
class SegmentRung {
  /// Creates a rung.
  const SegmentRung({
    required this.length,
    required this.width,
    required this.placeholder,
    this.separatorBefore = '',
  });

  /// Maximum digits accepted.
  final int length;

  /// Segment width in logical pixels.
  final double width;

  /// Shown while the segment is empty.
  final Widget placeholder;

  /// Static text before the segment ('' for the first rung).
  final String separatorBefore;
}

/// Builds the [SegmentedValue] shape for [rungs].
SegmentedValue buildObjectSegments(List<SegmentRung> rungs) {
  final List<SegmentPart> parts = <SegmentPart>[];
  for (final SegmentRung rung in rungs) {
    if (rung.separatorBefore.isNotEmpty) {
      parts.add(SegmentPart.separator(rung.separatorBefore));
    }
    parts.add(
      SegmentPart.editable(
        length: rung.length,
        width: rung.width,
        placeholder: rung.placeholder,
        inputFormatters: digitsOnlyFormatters,
      ),
    );
  }
  return SegmentedValue(parts);
}

/// Returns [shape] with its editable texts replaced by [texts].
SegmentedValue withObjectTexts(SegmentedValue shape, List<String> texts) {
  SegmentedValue next = shape;
  for (int i = 0; i < texts.length; i++) {
    next = next.withValue(i, texts[i]);
  }
  return next;
}

/// Live state behind one segmented object field: the cached [SegmentedValue]
/// shape plus the current segment texts. Plain data (not a ChangeNotifier);
/// owners repaint after mutating calls.
///
/// A parent echoing an intermediate null never wipes typing: external values
/// apply only through [resyncValue], while edits flow through [applyEdit].
class SegmentedObjectController<T> {
  /// Creates an empty controller; call [resyncShape] before first build.
  SegmentedObjectController();

  /// The cached shape; empty until [resyncShape] runs.
  SegmentedValue shape = const SegmentedValue();

  /// Current segment texts (seed, live edits, external values).
  List<String> texts = const <String>[];

  /// Rebuilds the shape from [rungs] and seeds texts (initial or new shape).
  void resyncShape(List<SegmentRung> rungs, List<String> seed) {
    shape = buildObjectSegments(rungs);
    texts = seed;
  }

  /// Applies an external value, replacing the live texts.
  void resyncValue(List<String> seed) {
    texts = seed;
  }

  /// Records an edit round-trip.
  void applyEdit(List<String> next) {
    texts = next;
  }

  /// The shape carrying the live texts, for controlled fields.
  SegmentedValue get shown => withObjectTexts(shape, texts);
}

/// Abbreviation lookup for one date part (a locale tear-off from the caller).
typedef DatePartAbbreviation = String Function(DatePart part);

/// Abbreviation lookup for one time part (a locale tear-off from the caller).
typedef TimePartAbbreviation = String Function(TimePart part);

/// Abbreviation lookup for one duration part (a locale tear-off).
typedef DurationPartAbbreviation = String Function(DurationPart part);

/// Rungs for a locale-ordered date field: 4-digit year, 2-digit month/day.
List<SegmentRung> dateSegmentRungs({
  required List<DatePart> order,
  required String separator,
  required DatePartAbbreviation abbreviations,
  Map<DatePart, Widget>? placeholders,
}) {
  return <SegmentRung>[
    for (int i = 0; i < order.length; i++)
      SegmentRung(
        length: order[i] == DatePart.year ? 4 : 2,
        width: order[i] == DatePart.year ? 60 : 40,
        placeholder: placeholders?[order[i]] ?? Text(abbreviations(order[i])),
        separatorBefore: i == 0 ? '' : separator,
      ),
  ];
}

/// Segment texts for [value] in [order]; blanks when null.
List<String> dateTextsFor(DateTime? value, List<DatePart> order) {
  if (value == null) return List<String>.filled(order.length, '');
  return <String>[
    for (final DatePart part in order)
      switch (part) {
        DatePart.year => value.year.toString(),
        DatePart.month => value.month.toString(),
        DatePart.day => value.day.toString(),
      },
  ];
}

/// Parses locale-ordered segment texts; null when incomplete or impossible
/// (month 13, February 30); the time part of a parsed date is dropped.
DateTime? parseObjectDate(List<String> texts, List<DatePart> order) {
  final Map<DatePart, String> map = <DatePart, String>{};
  for (int i = 0; i < texts.length && i < order.length; i++) {
    map[order[i]] = texts[i];
  }
  final int? year = int.tryParse(map[DatePart.year] ?? '');
  final int? month = int.tryParse(map[DatePart.month] ?? '');
  final int? day = int.tryParse(map[DatePart.day] ?? '');
  if (year == null || month == null || day == null) return null;
  if (year < 0 || year > 9999 || month < 1 || month > 12 || day < 1) {
    return null;
  }
  final DateTime date = DateTime(year, month, day);
  if (date.year != year || date.month != month || date.day != day) {
    return null;
  }
  return date;
}

/// Rungs for an hour/minute(/second) field.
List<SegmentRung> timeSegmentRungs({
  required bool showSeconds,
  required String separator,
  required TimePartAbbreviation abbreviations,
  Map<TimePart, Widget>? placeholders,
}) {
  const List<TimePart> order = <TimePart>[
    TimePart.hour,
    TimePart.minute,
    TimePart.second,
  ];
  final int count = showSeconds ? 3 : 2;
  return <SegmentRung>[
    for (int i = 0; i < count; i++)
      SegmentRung(
        length: 2,
        width: 40,
        placeholder: placeholders?[order[i]] ?? Text(abbreviations(order[i])),
        separatorBefore: i == 0 ? '' : separator,
      ),
  ];
}

/// Segment texts for [value]; blanks when null.
List<String> timeTextsFor(TimeOfDay? value, bool showSeconds) {
  if (value == null) return List<String>.filled(showSeconds ? 3 : 2, '');
  return <String>[
    value.hour.toString(),
    value.minute.toString(),
    if (showSeconds) value.second.toString(),
  ];
}

/// Parses hour/minute(/second) texts; null when incomplete or out of range.
TimeOfDay? parseObjectTime(List<String> texts, bool showSeconds) {
  final int? hour = texts.isNotEmpty ? int.tryParse(texts[0]) : null;
  final int? minute = texts.length > 1 ? int.tryParse(texts[1]) : null;
  final int? second = showSeconds && texts.length > 2
      ? int.tryParse(texts[2])
      : 0;
  if (hour == null || minute == null || second == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  if (second < 0 || second > 59) return null;
  return TimeOfDay(hour: hour, minute: minute, second: second);
}

/// Rungs for an hour/minute(/second) duration field.
List<SegmentRung> durationSegmentRungs({
  required bool showSeconds,
  required String separator,
  required DurationPartAbbreviation abbreviations,
  Map<DurationPart, Widget>? placeholders,
}) {
  const List<DurationPart> order = <DurationPart>[
    DurationPart.hour,
    DurationPart.minute,
    DurationPart.second,
  ];
  final int count = showSeconds ? 3 : 2;
  return <SegmentRung>[
    for (int i = 0; i < count; i++)
      SegmentRung(
        length: 2,
        width: 40,
        placeholder: placeholders?[order[i]] ?? Text(abbreviations(order[i])),
        separatorBefore: i == 0 ? '' : separator,
      ),
  ];
}

/// Segment texts for [value]; blanks when null.
List<String> durationTextsFor(Duration? value, bool showSeconds) {
  if (value == null) return List<String>.filled(showSeconds ? 3 : 2, '');
  return <String>[
    value.inHours.toString(),
    (value.inMinutes % 60).toString(),
    if (showSeconds) (value.inSeconds % 60).toString(),
  ];
}

/// Parses hour/minute(/second) texts; null when incomplete or out of range.
Duration? parseObjectDuration(List<String> texts, bool showSeconds) {
  final int? hours = texts.isNotEmpty ? int.tryParse(texts[0]) : null;
  final int? minutes = texts.length > 1 ? int.tryParse(texts[1]) : null;
  final int? seconds = showSeconds && texts.length > 2
      ? int.tryParse(texts[2])
      : 0;
  if (hours == null || minutes == null || seconds == null) return null;
  if (hours < 0 || minutes < 0 || minutes > 59) return null;
  if (seconds < 0 || seconds > 59) return null;
  return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

/// Trailing prompt button for segmented object fields: opens [content] in
/// an anchored popover, or runs [openDialog] for the dialog presentation.
///
/// Owns its [PopoverController] (disposed with the button), so callers stay
/// stateless. Popover presentation needs an `OverlayManager` ancestor (the
/// app root provides it); without one, use the dialog presentation.
class ObjectPromptButton extends StatefulWidget {
  /// Creates a prompt button.
  const ObjectPromptButton({
    super.key,
    required this.mode,
    required this.contentBuilder,
    required this.openDialog,
    required this.child,
    this.enabled = true,
    this.alignment,
    this.anchorAlignment,
  });

  /// Dialog or popover presentation (resolved by the caller).
  final PromptMode mode;

  /// Popover content.
  final WidgetBuilder contentBuilder;

  /// Opens the dialog presentation.
  final VoidCallback openDialog;

  /// Button content, usually a calendar icon.
  final Widget child;

  /// Whether the prompt opens; disabled dims to 50%.
  final bool enabled;

  /// Popover alignment relative to the field; null = top-left.
  final AlignmentGeometry? alignment;

  /// Popover anchor alignment; null = bottom-left.
  final AlignmentGeometry? anchorAlignment;

  @override
  State<ObjectPromptButton> createState() => _ObjectPromptButtonState();
}

class _ObjectPromptButtonState extends State<ObjectPromptButton> {
  final PopoverController _popovers = PopoverController();

  @override
  void dispose() {
    _popovers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Clickable(
      enabled: widget.enabled,
      onPressed: widget.enabled ? _open : null,
      mouseCursor: const StateValue<MouseCursor>(
        rest: SystemMouseCursors.click,
        disabled: SystemMouseCursors.basic,
      ),
      child: widget.child,
    );
  }

  Future<void> _open() async {
    if (widget.mode == PromptMode.popover) {
      await _popovers.show<void>(
        context: context,
        alignment: widget.alignment ?? Alignment.topLeft,
        anchorAlignment: widget.anchorAlignment ?? Alignment.bottomLeft,
        builder: widget.contentBuilder,
      );
      return;
    }
    widget.openDialog();
  }
}
