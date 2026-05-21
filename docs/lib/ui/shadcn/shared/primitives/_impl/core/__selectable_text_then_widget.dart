// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// _SelectableTextThenWidget defines a reusable type for this registry module.
class _SelectableTextThenWidget extends StatelessWidget {
  /// Stores `text` state/configuration for this implementation.
  final SelectableText text;

  /// Stores `then` state/configuration for this implementation.
  final List<InlineSpan> then;

  const _SelectableTextThenWidget({required this.text, required this.then});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return SelectableText.rich(
      /// Creates a `TextSpan` instance.
      TextSpan(
        text: text.data ?? '',
        style: text.style ?? DefaultTextStyle.of(context).style,
        children: then,
      ),
      textAlign: text.textAlign ?? TextAlign.start,
      textDirection: text.textDirection,
      textScaler: text.textScaler ?? MediaQuery.textScalerOf(context),
      textHeightBehavior: text.textHeightBehavior,
      maxLines: text.maxLines,
      cursorWidth: text.cursorWidth,
      cursorHeight: text.cursorHeight,
      cursorRadius: text.cursorRadius,
      cursorColor: text.cursorColor,
      showCursor: text.showCursor,
      selectionControls: text.selectionControls,
      onTap: text.onTap,
      scrollPhysics: text.scrollPhysics,
    );
  }
}
