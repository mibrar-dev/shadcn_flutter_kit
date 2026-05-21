// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

class MarkdownEditingController extends TextEditingController {
  MarkdownEditingController({super.text, this.maxHistoryEntries = 100});

  final int maxHistoryEntries;
  final List<TextEditingValue> _undoStack = <TextEditingValue>[];
  final List<TextEditingValue> _redoStack = <TextEditingValue>[];
  bool _isApplyingProgrammaticChange = false;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  @override
  set value(TextEditingValue newValue) {
    final previous = super.value;
    final hasChanged =
        previous.text != newValue.text ||
        previous.selection != newValue.selection ||
        previous.composing != newValue.composing;

    if (!_isApplyingProgrammaticChange && hasChanged) {
      _undoStack.add(previous);
      if (_undoStack.length > maxHistoryEntries) {
        _undoStack.removeAt(0);
      }
      _redoStack.clear();
    }

    super.value = newValue;
  }

  void applyEdit(MarkdownEditResult result) {
    value = value.copyWith(
      text: result.text,
      selection: result.selection,
      composing: TextRange.empty,
    );
  }

  void applyTransformer(
    MarkdownEditResult Function({
      required String text,
      required TextSelection selection,
    })
    transformer,
  ) {
    applyEdit(transformer(text: text, selection: selection));
  }

  void undo() {
    if (!canUndo) {
      return;
    }
    final target = _undoStack.removeLast();
    _redoStack.add(value);
    _setWithoutHistory(target);
  }

  void redo() {
    if (!canRedo) {
      return;
    }
    final target = _redoStack.removeLast();
    _undoStack.add(value);
    _setWithoutHistory(target);
  }

  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
  }

  void _setWithoutHistory(TextEditingValue nextValue) {
    _isApplyingProgrammaticChange = true;
    try {
      super.value = nextValue;
    } finally {
      _isApplyingProgrammaticChange = false;
    }
  }
}
