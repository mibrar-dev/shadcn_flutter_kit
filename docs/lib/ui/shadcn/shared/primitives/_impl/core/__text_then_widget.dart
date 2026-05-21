// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text.dart';

/// _TextThenWidget defines a reusable type for this registry module.
class _TextThenWidget extends StatelessWidget {
  /// Stores `text` state/configuration for this implementation.
  final Text text;

  /// Stores `then` state/configuration for this implementation.
  final List<InlineSpan> then;

  const _TextThenWidget({required this.text, required this.then});

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text.data ?? '',
        style: text.style ?? DefaultTextStyle.of(context).style,
        children: then,
      ),
      textAlign: text.textAlign ?? TextAlign.start,
      textDirection: text.textDirection,
      softWrap: text.softWrap ?? true,
      overflow: text.overflow ?? TextOverflow.clip,
      maxLines: text.maxLines,
      textScaler: text.textScaler ?? MediaQuery.textScalerOf(context),
      textWidthBasis: text.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: text.textHeightBehavior,
    );
  }
}
