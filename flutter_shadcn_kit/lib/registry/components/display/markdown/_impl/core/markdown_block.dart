// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

@immutable
class _MarkdownBlock {
  const _MarkdownBlock({
    required this.type,
    required this.text,
    this.orderedIndex = 1,
    this.indentLevel = 0,
    this.checked,
    this.language,
    this.tableRows = const <List<String>>[],
    this.tableAlignments = const <TextAlign>[],
    this.imageAlt,
    this.imageUrl,
    this.imageTitle,
    this.label,
    this.items = const <String>[],
    this.htmlTag,
    this.rawHtml,
  });

  final _MarkdownBlockType type;
  final String text;
  final int orderedIndex;
  final int indentLevel;
  final bool? checked;
  final String? language;
  final List<List<String>> tableRows;
  final List<TextAlign> tableAlignments;
  final String? imageAlt;
  final String? imageUrl;
  final String? imageTitle;
  final String? label;
  final List<String> items;
  final String? htmlTag;
  final String? rawHtml;
}
