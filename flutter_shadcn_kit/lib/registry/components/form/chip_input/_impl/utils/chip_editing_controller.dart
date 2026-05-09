// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../chip_input.dart';

/// A text editing controller that supports inline chip widgets.
///
/// Extends [TextEditingController] to manage text with embedded chip objects
/// represented by special Unicode codepoints from the Private Use Area (U+E000-U+F8FF).
/// Each chip is mapped to a unique codepoint allowing up to 6400 chips per controller.
///
/// Use this when you need to display removable tags or tokens within a text field,
/// such as email recipients, keywords, or selected items.
///
/// Example:
/// ```dart
/// final controller = ChipEditingController<String>(
///   initialChips: ['tag1', 'tag2'],
/// );
/// ```
class ChipEditingController<T> extends TextEditingController {
  static const int _chipStart = 0xE000; // Private Use Area start
  static const int _chipEnd = 0xF8FF; // Private Use Area end
  /// Field storing `_maxChips` for this form implementation.
  static const int _maxChips = _chipEnd - _chipStart + 1;
  // these codepoints are reserved for chips, so that they don't conflict with normal text
  // there are 6400 codepoints available for chips

  // final List<T> _chips = [];
  /// Field storing `_chipMap` for this form implementation.
  final Map<int, T> _chipMap = {};

  /// Field storing `_nextChipIndex` for this form implementation.
  int _nextChipIndex = 0;

  int get _nextAvailableChipIndex {
    if (_chipMap.length >= _maxChips) {
      throw Exception('Maximum number of chips reached');
    }
    while (_chipMap.containsKey(_nextChipIndex)) {
      int nextIndex = _nextChipIndex + 1;
      if (nextIndex >= _maxChips) {
        nextIndex = 0;
      }
      _nextChipIndex = nextIndex;
    }
    return _nextChipIndex;
  }

  /// Factory constructor creating a chip editing controller.
  ///
  /// Optionally initializes with [text] and [initialChips].
  factory ChipEditingController({String? text, List<T>? initialChips}) {
    StringBuffer buffer = StringBuffer();
    if (initialChips != null) {
      for (int i = 0; i < initialChips.length; i++) {
        buffer.writeCharCode(_chipStart + i);
      }
    }
    if (text != null) {
      buffer.write(text);
    }
    return ChipEditingController._internal(buffer.toString());
  }

  ChipEditingController._internal(String text) : super(text: text);

  /// Performs `text` logic for this form component.
  @override
  set text(String newText) {
    super.text = newText;
    _updateText(newText);
  }

  /// Performs `value` logic for this form component.
  @override
  set value(TextEditingValue newValue) {
    super.value = newValue;
    _updateText(newValue.text);
  }

  /// Performs `_updateText` logic for this form component.
  void _updateText(String newText) {
    for (final entry in _chipMap.entries.toList()) {
      int chipIndex = entry.key;
      int chipCodeUnit = _chipStart + chipIndex;
      if (!newText.contains(String.fromCharCode(chipCodeUnit))) {
        _chipMap.remove(chipIndex);
      }
    }
  }

  /// Returns an unmodifiable list of all chips in the controller.
  List<T> get chips => List.unmodifiable(_chipMap.values);

  /// Sets the chips in this controller, replacing all existing chips.
  set chips(List<T> newChips) {
    String text = value.text;
    // remove chips that are not in newChips
    // add chips that are in newChips but not present, appending them at the last chip position
    StringBuffer buffer = StringBuffer();
    int chipCount = 0;
    for (int i = 0; i < text.length; i++) {
      int codeUnit = text.codeUnitAt(i);
      if (codeUnit >= _chipStart && codeUnit <= _chipEnd) {
        T? existingChip = _chipMap[codeUnit - _chipStart];
        if (existingChip != null && newChips.contains(existingChip)) {
          buffer.writeCharCode(codeUnit);
          chipCount++;
        }
      } else {
        buffer.writeCharCode(codeUnit);
      }
    }
    for (int i = chipCount; i < newChips.length; i++) {
      T chip = newChips[i];
      int chipIndex = _nextAvailableChipIndex;
      buffer.writeCharCode(_chipStart + chipIndex);
      _chipMap[chipIndex] = chip;
    }
    super.value = value.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }

  /// Removes all chips from the controller, leaving only plain text.
  void removeAllChips() {
    StringBuffer buffer = StringBuffer();
    String text = value.text;
    for (int i = 0; i < text.length; i++) {
      int codeUnit = text.codeUnitAt(i);
      if (codeUnit < _chipStart || codeUnit > _chipEnd) {
        buffer.writeCharCode(codeUnit);
      }
    }
    super.value = value.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
    _chipMap.clear();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final provider = Data.maybeOf<_ChipProvider<T>>(context);
    final theme = ComponentTheme.maybeOf<ChipInputTheme>(context);
    final spacing = theme?.spacing ?? 4.0;
    if (provider != null) {
      final bool composingRegionOutOfRange =
          !value.isComposingRangeValid || !withComposing;

      if (composingRegionOutOfRange) {
        List<InlineSpan> children = [];
        String text = value.text;
        StringBuffer buffer = StringBuffer();
        for (int i = 0; i < text.length; i++) {
          int codeUnit = text.codeUnitAt(i);
          if (codeUnit >= _chipStart && codeUnit <= _chipEnd) {
            // Flush buffer
            if (buffer.isNotEmpty) {
              children.add(TextSpan(style: style, text: buffer.toString()));
              buffer.clear();
            }
            T? chip = _chipMap[codeUnit - _chipStart];
            Widget? chipWidget = chip == null
                ? null
                : provider.buildChip(context, chip);
            if (chipWidget != null) {
              bool previousIsChip =
                  i > 0 &&
                  text.codeUnitAt(i - 1) >= _chipStart &&
                  text.codeUnitAt(i - 1) <= _chipEnd;
              bool nextIsChip =
                  i < text.length - 1 &&
                  text.codeUnitAt(i + 1) >= _chipStart &&
                  text.codeUnitAt(i + 1) <= _chipEnd;
              children.add(
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: previousIsChip
                          ? spacing / 2
                          : i == 0
                          ? 0
                          : spacing,
                      right: nextIsChip ? spacing / 2 : spacing,
                    ),
                    child: chipWidget,
                  ),
                ),
              );
            }
          } else {
            buffer.writeCharCode(codeUnit);
          }
        }
        // Flush remaining buffer
        if (buffer.isNotEmpty) {
          children.add(TextSpan(style: style, text: buffer.toString()));
        }
        return TextSpan(style: style, children: children);
      }

      final TextStyle composingStyle =
          style?.merge(const TextStyle(decoration: TextDecoration.underline)) ??
          const TextStyle(decoration: TextDecoration.underline);
      List<InlineSpan> children = [];
      String text = value.text;
      StringBuffer buffer = StringBuffer();
      for (int i = 0; i < text.length; i++) {
        int codeUnit = text.codeUnitAt(i);
        if (codeUnit >= _chipStart && codeUnit <= _chipEnd) {
          // Flush buffer
          if (buffer.isNotEmpty) {
            children.add(TextSpan(style: style, text: buffer.toString()));
            buffer.clear();
          }
          T? chip = _chipMap[codeUnit - _chipStart];
          Widget? chipWidget = chip == null
              ? null
              : provider.buildChip(context, chip);
          if (chipWidget != null) {
            bool previousIsChip =
                i > 0 &&
                text.codeUnitAt(i - 1) >= _chipStart &&
                text.codeUnitAt(i - 1) <= _chipEnd;
            bool nextIsChip =
                i < text.length - 1 &&
                text.codeUnitAt(i + 1) >= _chipStart &&
                text.codeUnitAt(i + 1) <= _chipEnd;
            children.add(
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: previousIsChip
                        ? spacing / 2
                        : i == 0
                        ? 0
                        : spacing,
                    right: nextIsChip ? spacing / 2 : spacing,
                  ),
                  child: chipWidget,
                ),
              ),
            );
          }
        } else {
          // Check if current index is within composing range
          if (i >= value.composing.start && i < value.composing.end) {
            // Flush buffer
            if (buffer.isNotEmpty) {
              children.add(TextSpan(style: style, text: buffer.toString()));
              buffer.clear();
            }
            children.add(
              TextSpan(
                style: composingStyle,
                text: String.fromCharCode(codeUnit),
              ),
            );
          } else {
            buffer.writeCharCode(codeUnit);
          }
        }
      }
      // Flush remaining buffer
      if (buffer.isNotEmpty) {
        children.add(TextSpan(style: style, text: buffer.toString()));
      }
      return TextSpan(style: style, children: children);
    }
    return super.buildTextSpan(
      context: context,
      style: style,
      withComposing: withComposing,
    );
  }

  /// Returns the plain text without chip characters.
  String get plainText {
    StringBuffer buffer = StringBuffer();

    String text = value.text;
    for (int i = 0; i < text.length; i++) {
      int codeUnit = text.codeUnitAt(i);
      if (codeUnit < _chipStart || codeUnit > _chipEnd) {
        buffer.writeCharCode(codeUnit);
      }
    }
    return buffer.toString();
  }

  /// Returns the text at the current cursor position.
  String get textAtCursor {
    final boundaries = _findChipTextBoundaries(selection.baseOffset);
    return value.text.substring(boundaries.start, boundaries.end);
  }

  /// Inserts a chip at the cursor position by converting the text at cursor.
  ///
  /// Uses [chipConverter] to convert the text at cursor to a chip.
  void insertChipAtCursor(T? Function(String chipText) chipConverter) {
    final boundaries = _findChipTextBoundaries(selection.baseOffset);
    String chipText = value.text.substring(boundaries.start, boundaries.end);
    T? chip = chipConverter(chipText);
    if (chip != null) {
      int chipIndex = _nextAvailableChipIndex;
      _replaceAsChip(boundaries.start, boundaries.end, chipIndex);
      _chipMap[chipIndex] = chip;
    }
  }

  /// Clears the text at the current cursor position.
  void clearTextAtCursor() {
    final boundaries = _findChipTextBoundaries(selection.baseOffset);
    String text = value.text;
    StringBuffer buffer = StringBuffer();
    buffer.write(text.substring(0, boundaries.start));
    buffer.write(text.substring(boundaries.end));
    super.value = value.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: boundaries.start),
    );
  }

  /// Appends a chip at the end of the chip sequence.
  void appendChip(T chip) {
    // append chip at the last chip position
    // note: chip position is not always in order
    // sometimes theres chip and then text and then chip
    // so we need to find the last chip position
    String text = value.text;
    int chipIndex = _nextAvailableChipIndex;
    int lastChipIndex = -1;
    for (int i = text.length - 1; i >= 0; i--) {
      int codeUnit = text.codeUnitAt(i);
      if (codeUnit >= _chipStart && codeUnit <= _chipEnd) {
        lastChipIndex = i;
        break;
      }
    }
    String newText = text.replaceRange(
      lastChipIndex + 1,
      lastChipIndex + 1,
      String.fromCharCode(_chipStart + chipIndex),
    );
    super.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: lastChipIndex + 2),
    );
    _chipMap[chipIndex] = chip;
  }

  /// Appends a chip at the current cursor position.
  void appendChipAtCursor(T chip) {
    // append chip at the cursor position
    final boundaries = _findChipTextBoundaries(selection.baseOffset);
    String text = value.text;
    int chipIndex = _nextAvailableChipIndex;
    String newText = text.replaceRange(
      boundaries.end,
      boundaries.end,
      String.fromCharCode(_chipStart + chipIndex),
    );
    super.value = value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: boundaries.end + 1),
    );
    _chipMap[chipIndex] = chip;
  }

  /// Inserts a chip at a specific position in the text.
  void insertChip(T chip) {
    // insert chip at the start
    int chipIndex = _nextAvailableChipIndex;
    String newText = String.fromCharCode(_chipStart + chipIndex) + value.text;
    super.value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: 1),
    );
    _chipMap[chipIndex] = chip;
  }

  /// Performs `_replaceAsChip` logic for this form component.
  void _replaceAsChip(int start, int end, int index) {
    String text = value.text;
    StringBuffer buffer = StringBuffer();
    buffer.write(text.substring(0, start));
    buffer.writeCharCode(_chipStart + index);
    buffer.write(text.substring(end));
    super.value = value.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: start + 1),
    );
  }

  ({int start, int end}) _findChipTextBoundaries(int cursorPosition) {
    String text = value.text;
    int start = cursorPosition;
    int end = cursorPosition;

    // Move start backward to find the beginning of the chip text
    while (start > 0) {
      int codeUnit = text.codeUnitAt(start - 1);
      if (codeUnit >= _chipStart && codeUnit <= _chipEnd) {
        break;
      }
      start--;
    }

    // Move end forward to find the end of the chip text
    while (end < text.length) {
      int codeUnit = text.codeUnitAt(end);
      if (codeUnit >= _chipStart && codeUnit <= _chipEnd) {
        break;
      }
      end++;
    }

    return (start: start, end: end);
  }

  /// Removes the specified chip from the controller.
  void removeChip(T chip) {
    int? chipIndex;
    _chipMap.forEach((key, value) {
      if (value == chip) {
        chipIndex = key;
      }
    });
    if (chipIndex != null) {
      String text = value.text;
      StringBuffer buffer = StringBuffer();
      int currentCursorOffset = value.selection.baseOffset;
      int newCursorOffset = currentCursorOffset;

      for (int i = 0; i < text.length; i++) {
        int codeUnit = text.codeUnitAt(i);
        if (codeUnit == _chipStart + chipIndex!) {
          // Found the chip to remove
          // Adjust cursor position if it's after the removed chip
          if (currentCursorOffset > i) {
            newCursorOffset = currentCursorOffset - 1;
          }
          // skip this code unit
          continue;
        }
        buffer.writeCharCode(codeUnit);
      }
      super.value = value.copyWith(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: newCursorOffset),
      );
      _chipMap.remove(chipIndex);
    }
  }
}
