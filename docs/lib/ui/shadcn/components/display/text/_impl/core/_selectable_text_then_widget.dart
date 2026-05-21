// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// Internal helper class used by the text component implementation.
class _SelectableTextThenWidget extends StatelessWidget {
  /// Data consumed by `_SelectableTextThenWidget` to render text content.
  final SelectableText text;

  /// Input parameter used by `_SelectableTextThenWidget` during rendering and behavior handling.
  final List<InlineSpan> then;

  const _SelectableTextThenWidget({required this.text, required this.then});

  /// Builds the widget tree for text.
  @override
  Widget build(BuildContext context) {
    String? stringData = text.data;

    TextSpan? textData = text.textSpan;
    return SelectableText.rich(
      TextSpan(
        text: stringData,
        children: [if (textData != null) textData, ...then],
      ),
      style: text.style,
      useNativeContextMenu: text.useNativeContextMenu,
      contextMenuBuilder: text.contextMenuBuilder,
      minLines: text.minLines,
      semanticsLabel: text.semanticsLabel,
      textScaler: text.textScaler,
      magnifierConfiguration: text.magnifierConfiguration,
      selectionHeightStyle: text.selectionHeightStyle,
      selectionWidthStyle: text.selectionWidthStyle,
      textAlign: text.textAlign,
      textDirection: text.textDirection,
      textWidthBasis: text.textWidthBasis,
      textHeightBehavior: text.textHeightBehavior,
      maxLines: text.maxLines,
      strutStyle: text.strutStyle,
      selectionControls: text.selectionControls,
      onTap: text.onTap,
      scrollPhysics: text.scrollPhysics,
      showCursor: text.showCursor,
      cursorWidth: text.cursorWidth,
      cursorHeight: text.cursorHeight,
      cursorRadius: text.cursorRadius,
      cursorColor: text.cursorColor,
      dragStartBehavior: text.dragStartBehavior,
      enableInteractiveSelection: text.enableInteractiveSelection,
      autofocus: text.autofocus,
      focusNode: text.focusNode,
      onSelectionChanged: text.onSelectionChanged,
    );
  }
}
