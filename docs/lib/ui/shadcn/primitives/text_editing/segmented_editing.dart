// Machinery for a field made of several small editable segments (a date, a
// phone number, a card number). The component owns the widgets; this owns the
// controllers, the focus order and the value flow.
//
// Ported from the old `formatted_input` `_EditablePartController`,
// `_FormattedSelectionCoordinator` and `_focusNodes` bookkeeping, with the
// cross-part drag selection dropped (it was never wired to a gesture hook).

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// One editable segment of a segmented field.
class TextSegment {
  /// Creates a segment definition.
  const TextSegment({
    required this.length,
    this.obscureText = false,
    this.placeholder,
    this.inputFormatters = const <TextInputFormatter>[],
    this.textAlign = TextAlign.center,
  });

  /// Maximum number of characters in the segment.
  final int length;

  /// Whether the segment paints dots instead of its text.
  final bool obscureText;

  /// Widget shown while the segment is empty.
  final Widget? placeholder;

  /// Formatters applied before the length limiter.
  final List<TextInputFormatter> inputFormatters;

  /// Horizontal alignment inside the segment.
  final TextAlign textAlign;

  /// This segment's formatters including the length limiter.
  List<TextInputFormatter> formatters([
    MaxLengthEnforcement? enforcement,
  ]) => <TextInputFormatter>[
    ...inputFormatters,
    LengthLimitingTextInputFormatter(length, maxLengthEnforcement: enforcement),
  ];
}

/// Pads a segment with `_` so every segment keeps the same optical width.
class _SegmentTextController extends TextEditingController {
  _SegmentTextController({
    required this.maxLength,
    required this.hasPlaceholder,
    super.text,
  });

  final int maxLength;
  final bool hasPlaceholder;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    if (!value.isComposingRangeValid || !withComposing) {
      return _span(context, style, text);
    }
    // The composing region keeps its underline, as the platform IME expects.
    final TextStyle composing = (style ?? const TextStyle()).merge(
      const TextStyle(decoration: TextDecoration.underline),
    );
    return _span(
      context,
      style,
      value.composing.textBefore(value.text),
      inside: TextSpan(
        style: composing,
        text: value.composing.textInside(value.text),
      ),
      after: value.composing.textAfter(value.text),
    );
  }

  TextSpan _span(
    BuildContext context,
    TextStyle? style,
    String text, {
    TextSpan? inside,
    String? after,
  }) {
    // Without a placeholder an empty segment shows nothing at all.
    if (text.isEmpty && hasPlaceholder) {
      return const TextSpan();
    }
    final TextStyle? filler = style?.copyWith(
      color: ShadcnTheme.of(context).colors.mutedForeground,
    );
    final String tail = after ?? '';
    final int used = text.length + (inside?.text?.length ?? 0) + tail.length;
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: text),
        ?inside,
        if (tail.isNotEmpty) TextSpan(text: tail),
        TextSpan(
          style: filler,
          text: '_' * (maxLength - used).clamp(0, maxLength),
        ),
      ],
    );
  }
}

/// Owns the controllers, the focus nodes and the value flow of a segmented
/// field. One controller per [TextSegment]; the caller renders the widgets.
class SegmentedTextController extends ChangeNotifier {
  /// Creates a controller for [segments].
  SegmentedTextController({
    required List<TextSegment> segments,
    List<String> values = const <String>[],
  }) : _segments = List<TextSegment>.of(segments) {
    for (int i = 0; i < _segments.length; i++) {
      controllers.add(
        _SegmentTextController(
          maxLength: _segments[i].length,
          hasPlaceholder: _segments[i].placeholder != null,
          text: i < values.length ? values[i] : '',
        ),
      );
      focusNodes.add(FocusNode(debugLabel: 'TextSegment'));
    }
  }

  final List<TextSegment> _segments;

  /// One controller per segment, in segment order.
  final List<TextEditingController> controllers = <TextEditingController>[];

  /// One focus node per segment, in segment order.
  final List<FocusNode> focusNodes = <FocusNode>[];

  /// The segment definitions.
  List<TextSegment> get segments => List<TextSegment>.unmodifiable(_segments);

  /// Number of segments.
  int get length => controllers.length;

  /// The text of every segment.
  List<String> get values =>
      controllers.map((TextEditingController c) => c.text).toList();

  /// Whether every segment is full.
  bool get isComplete {
    final List<String> current = values;
    for (int i = 0; i < current.length; i++) {
      if (current[i].length < _segments[i].length) {
        return false;
      }
    }
    return true;
  }

  /// Writes [text] into the segment at [index], clamped to its length.
  void setText(int index, String text, {bool notify = true}) {
    if (index < 0 || index >= controllers.length) {
      return;
    }
    final String next = text.length > _segments[index].length
        ? text.substring(0, _segments[index].length)
        : text;
    if (controllers[index].text == next) {
      return;
    }
    controllers[index].text = next;
    if (notify) {
      notifyListeners();
    }
  }

  /// Replaces every segment value, clamping each to its length.
  void setValues(List<String> values, {bool notify = true}) {
    for (int i = 0; i < controllers.length && i < values.length; i++) {
      controllers[i].text = values[i].length > _segments[i].length
          ? values[i].substring(0, _segments[i].length)
          : values[i];
    }
    if (notify) {
      notifyListeners();
    }
  }

  /// Grows or shrinks the segment list, keeping the values that survive.
  ///
  /// Returns true when the segment list changed.
  bool resize(List<TextSegment> segments) {
    if (segments.length == _segments.length) {
      return false;
    }
    final List<String> previous = values;
    for (int i = controllers.length; i > segments.length; i--) {
      controllers.removeLast().dispose();
      focusNodes.removeLast().dispose();
    }
    for (int i = controllers.length; i < segments.length; i++) {
      controllers.add(
        _SegmentTextController(
          maxLength: segments[i].length,
          hasPlaceholder: segments[i].placeholder != null,
          text: i < previous.length ? previous[i] : '',
        ),
      );
      focusNodes.add(FocusNode(debugLabel: 'TextSegment'));
    }
    _segments
      ..clear()
      ..addAll(segments);
    return true;
  }

  /// Focuses [index] when it exists; false otherwise.
  bool focus(int index) {
    if (index < 0 || index >= focusNodes.length) {
      return false;
    }
    focusNodes[index].requestFocus();
    return true;
  }

  /// Moves the focus to the next ([delta] 1) or previous ([delta] -1) segment.
  bool moveFocus(int from, int delta) => focus(from + delta);

  /// Whether the caret of segment [index] sits at the start, so a backspace or
  /// <kbd>←</kbd> should move to the previous segment.
  bool atStart(int index) {
    if (index < 0 || index >= controllers.length) {
      return false;
    }
    final TextSelection selection = controllers[index].selection;
    return selection.isValid &&
        selection.isCollapsed &&
        selection.baseOffset <= 0;
  }

  /// Whether the caret of segment [index] sits at the end, so <kbd>→</kbd>
  /// should move to the next segment.
  bool atEnd(int index) {
    if (index < 0 || index >= controllers.length) {
      return false;
    }
    final TextSelection selection = controllers[index].selection;
    return selection.isValid &&
        selection.isCollapsed &&
        selection.baseOffset >= controllers[index].text.length;
  }

  /// Whether segment [index] is full and the next one should take over.
  bool isFull(int index) =>
      index >= 0 &&
      index < controllers.length &&
      controllers[index].text.length >= _segments[index].length;

  /// Selects the whole text of every segment.
  void selectAll() {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].selection = TextSelection(
        baseOffset: 0,
        extentOffset: controllers[i].text.length,
      );
    }
  }

  /// The selected text of every segment, in order (empty when nothing is
  /// selected in a segment).
  String get selectedText => <String>[
    for (int i = 0; i < controllers.length; i++)
      controllers[i].selection.isValid && !controllers[i].selection.isCollapsed
          ? controllers[i].selection.textInside(controllers[i].text)
          : '',
  ].join();

  /// The whole field's text.
  String get text => values.join();

  @override
  void dispose() {
    for (final TextEditingController controller in controllers) {
      controller.dispose();
    }
    for (final FocusNode node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
