// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../formatted_input.dart';

/// Coordinates text selection across the separate editable [TextField]s
/// that make up a [FormattedInput] (select-all, combined copy, and
/// click-drag selection spanning multiple parts).
///
/// Parts are not registered/unregistered through a persistent list; instead
/// every operation walks the live element tree under [rootContext] to find
/// the currently-mounted [_EditablePartWidgetState]s. This avoids lifecycle
/// bookkeeping and always reflects the current tree.
///
/// Upstream parity: ported from `formatted_input.dart` upstream.
/// Note: cross-part drag callbacks (`onDragSelectionStart/Update/End`) are
/// not wired into [_EditablePartWidgetState.build] because the registry
/// [TextField] does not expose those hooks (unlike upstream). Focus tracking,
/// select-all and combined copy are fully wired; the drag methods below are
/// ported for API parity and activate automatically if the hooks become
/// available.
class _FormattedSelectionCoordinator {
  final BuildContext Function() rootContext;

  _FormattedSelectionCoordinator(this.rootContext);

  /// Whether more than one part currently participates in a selection
  /// (via [selectAll] or a cross-part drag). Read by the Copy override to
  /// decide whether to build a combined string or fall back to default.
  bool crossPartActive = false;

  bool _dragging = false;
  int? _dragAnchorPart;
  int _dragAnchorOffset = 0;

  List<_EditablePartWidgetState> _visitParts() {
    final result = <_EditablePartWidgetState>[];
    void visit(Element element) {
      final state = element is StatefulElement ? element.state : null;
      if (state is _EditablePartWidgetState) {
        result.add(state);
        return;
      }
      element.visitChildren(visit);
    }

    rootContext().visitChildElements(visit);
    result.sort((a, b) => a.data.partIndex.compareTo(b.data.partIndex));
    return result;
  }

  Rect? _boundsOf(_EditablePartWidgetState part) {
    final renderObject = part.context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return null;
    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  int _estimateOffset(_EditablePartWidgetState part, Offset globalPosition) {
    final length = part.controller.text.length;
    if (length == 0) return 0;
    final bounds = _boundsOf(part);
    if (bounds == null || bounds.width <= 0) return length;
    final ratio = ((globalPosition.dx - bounds.left) / bounds.width).clamp(
      0.0,
      1.0,
    );
    return (ratio * length).round().clamp(0, length);
  }

  /// Selects the full text of every editable part.
  void selectAll() {
    final parts = _visitParts();
    for (final part in parts) {
      part.controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: part.controller.text.length,
      );
    }
    crossPartActive = parts.length > 1;
  }

  /// Called whenever a part gains focus via a normal (non-drag) interaction;
  /// collapses every other part's selection so stale highlights don't linger.
  void onPartFocused(int partIndex) {
    if (_dragging) return;
    for (final part in _visitParts()) {
      if (part.data.partIndex != partIndex) {
        part.controller.selection = const TextSelection.collapsed(offset: 0);
      }
    }
    crossPartActive = false;
  }

  void onDragStart(int partIndex, Offset globalPosition) {
    final parts = _visitParts();
    _EditablePartWidgetState? anchor;
    for (final part in parts) {
      if (part.data.partIndex == partIndex) {
        anchor = part;
        break;
      }
    }
    if (anchor == null) return;
    _dragging = true;
    _dragAnchorPart = partIndex;
    _dragAnchorOffset = _estimateOffset(anchor, globalPosition);
  }

  void onDragUpdate(int partIndex, Offset globalPosition) {
    final anchorIndex = _dragAnchorPart;
    if (anchorIndex == null) return;
    final parts = _visitParts();
    if (parts.isEmpty) return;

    var currentIndex = parts.first.data.partIndex;
    for (var i = 0; i < parts.length; i++) {
      final bounds = _boundsOf(parts[i]);
      if (bounds == null) continue;
      if (globalPosition.dx < bounds.left) {
        currentIndex = parts[i > 0 ? i - 1 : i].data.partIndex;
        break;
      }
      currentIndex = parts[i].data.partIndex;
      if (globalPosition.dx <= bounds.right) break;
    }

    if (currentIndex == anchorIndex) {
      crossPartActive = false;
      return;
    }
    crossPartActive = true;
    final forward = currentIndex > anchorIndex;
    for (final part in parts) {
      final idx = part.data.partIndex;
      final length = part.controller.text.length;
      final inRange = forward
          ? idx >= anchorIndex && idx <= currentIndex
          : idx <= anchorIndex && idx >= currentIndex;
      if (!inRange) continue;
      if (idx == anchorIndex) {
        part.controller.selection = TextSelection(
          baseOffset: _dragAnchorOffset,
          extentOffset: forward ? length : 0,
        );
      } else if (idx == currentIndex) {
        final offset = _estimateOffset(part, globalPosition);
        part.controller.selection = TextSelection(
          baseOffset: forward ? 0 : length,
          extentOffset: offset,
        );
      } else {
        part.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: length,
        );
      }
    }
  }

  void onDragEnd() {
    _dragging = false;
    _dragAnchorPart = null;
  }

  /// Builds the combined logical text spanning every part that currently
  /// has a non-empty selection, including any [StaticPart] separators that
  /// fall strictly between the first and last selected editable parts.
  String buildCombinedText(FormattedValue value) {
    final parts = _visitParts();
    final byIndex = <int, _EditablePartWidgetState>{
      for (final part in parts) part.data.partIndex: part,
    };

    int? first;
    int? last;
    var valueIndex = 0;
    for (final valuePart in value.parts) {
      if (valuePart.part.canHaveValue) {
        final selection = byIndex[valueIndex]?.controller.selection;
        if (selection != null && !selection.isCollapsed) {
          first ??= valueIndex;
          last = valueIndex;
        }
        valueIndex++;
      }
    }
    if (first == null) return '';

    final buffer = StringBuffer();
    valueIndex = 0;
    for (final valuePart in value.parts) {
      if (valuePart.part.canHaveValue) {
        if (valueIndex >= first && valueIndex <= last!) {
          final part = byIndex[valueIndex];
          if (part != null) {
            final selection = part.controller.selection;
            final text = part.controller.text;
            buffer.write(
              selection.isCollapsed ? text : selection.textInside(text),
            );
          }
        }
        valueIndex++;
      } else if (valuePart.part is StaticPart &&
          valueIndex > first &&
          valueIndex <= last!) {
        buffer.write((valuePart.part as StaticPart).text);
      }
    }
    return buffer.toString();
  }
}

/// Overrides [CopySelectionTextIntent] to copy the combined text across all
/// selected parts of a [FormattedInput] when a cross-part selection is
/// active; otherwise falls back to the normal per-field copy behavior via
/// [callingAction], the mechanism Flutter's `_makeOverridable`-wrapped
/// default actions (like [EditableText]'s own copy action) use to let an
/// ancestor [Actions] entry take priority while still allowing a fallback.
///
/// Upstream parity: ported from `formatted_input.dart` upstream.
class _FormattedInputCopyAction extends ContextAction<CopySelectionTextIntent> {
  final _FormattedSelectionCoordinator coordinator;
  final FormattedValue? Function() getValue;

  _FormattedInputCopyAction(this.coordinator, this.getValue);

  @override
  Object? invoke(CopySelectionTextIntent intent, [BuildContext? context]) {
    if (coordinator.crossPartActive) {
      final value = getValue();
      if (value != null) {
        final text = coordinator.buildCombinedText(value);
        if (text.isNotEmpty) {
          Clipboard.setData(ClipboardData(text: text));
        }
      }
      return null;
    }
    return callingAction?.invoke(intent);
  }
}
