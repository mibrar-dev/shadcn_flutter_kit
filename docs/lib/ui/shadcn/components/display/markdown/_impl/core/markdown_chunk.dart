// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

@immutable
class _MarkdownChunk {
  const _MarkdownChunk({
    required this.startBlockIndex,
    required this.endBlockIndex,
    required this.blocks,
    required this.estimatedExtent,
  });

  final int startBlockIndex;
  final int endBlockIndex;
  final List<_MarkdownBlock> blocks;
  final double estimatedExtent;
}

List<_MarkdownChunk> _chunkMarkdownBlocks(List<_MarkdownBlock> blocks) {
  if (blocks.isEmpty) {
    return const <_MarkdownChunk>[];
  }

  const targetWeight = 18;
  final chunks = <_MarkdownChunk>[];
  final currentBlocks = <_MarkdownBlock>[];
  var currentWeight = 0;
  var currentExtent = 0.0;
  var chunkStartIndex = 0;

  void flush(int endIndex) {
    if (currentBlocks.isEmpty) {
      return;
    }
    chunks.add(
      _MarkdownChunk(
        startBlockIndex: chunkStartIndex,
        endBlockIndex: endIndex,
        blocks: List<_MarkdownBlock>.unmodifiable(currentBlocks),
        estimatedExtent: currentExtent,
      ),
    );
    currentBlocks.clear();
    currentWeight = 0;
    currentExtent = 0;
  }

  for (var index = 0; index < blocks.length; index++) {
    final block = blocks[index];
    final weight = _markdownChunkWeight(block);
    final extent = _markdownEstimatedExtent(block);

    if (currentBlocks.isNotEmpty && currentWeight + weight > targetWeight) {
      flush(index);
      chunkStartIndex = index;
    }

    currentBlocks.add(block);
    currentWeight += weight;
    currentExtent += extent;
  }

  flush(blocks.length);
  return List<_MarkdownChunk>.unmodifiable(chunks);
}

int _markdownChunkWeight(_MarkdownBlock block) {
  return switch (block.type) {
    _MarkdownBlockType.blank => 0,
    _MarkdownBlockType.paragraph => 3 + _markdownLineCount(block.text) ~/ 4,
    _MarkdownBlockType.heading1 => 2,
    _MarkdownBlockType.heading2 => 2,
    _MarkdownBlockType.heading3 => 2,
    _MarkdownBlockType.heading4 => 1,
    _MarkdownBlockType.heading5 => 1,
    _MarkdownBlockType.heading6 => 1,
    _MarkdownBlockType.unorderedList => 1,
    _MarkdownBlockType.orderedList => 1,
    _MarkdownBlockType.taskList => 1,
    _MarkdownBlockType.quote => 4,
    _MarkdownBlockType.codeFence => 6,
    _MarkdownBlockType.indentedCode => 6,
    _MarkdownBlockType.table => 8,
    _MarkdownBlockType.image => 6,
    _MarkdownBlockType.definitionList => 4,
    _MarkdownBlockType.details => 5,
    _MarkdownBlockType.math => 4,
    _MarkdownBlockType.footnote => 2,
    _MarkdownBlockType.rawHtml => 3,
    _MarkdownBlockType.horizontalRule => 1,
  };
}

double _markdownEstimatedExtent(_MarkdownBlock block) {
  return switch (block.type) {
    _MarkdownBlockType.blank => 16,
    _MarkdownBlockType.paragraph => 26 + (_markdownLineCount(block.text) * 22),
    _MarkdownBlockType.heading1 => 56,
    _MarkdownBlockType.heading2 => 50,
    _MarkdownBlockType.heading3 => 44,
    _MarkdownBlockType.heading4 => 38,
    _MarkdownBlockType.heading5 => 34,
    _MarkdownBlockType.heading6 => 30,
    _MarkdownBlockType.unorderedList => 28,
    _MarkdownBlockType.orderedList => 28,
    _MarkdownBlockType.taskList => 28,
    _MarkdownBlockType.quote => 40 + (_markdownLineCount(block.text) * 22),
    _MarkdownBlockType.codeFence => 72 + (_markdownLineCount(block.text) * 18),
    _MarkdownBlockType.indentedCode =>
      72 + (_markdownLineCount(block.text) * 18),
    _MarkdownBlockType.table => 120 + (block.tableRows.length * 36),
    _MarkdownBlockType.image => 220,
    _MarkdownBlockType.definitionList => 48 + (block.items.length * 28),
    _MarkdownBlockType.details => 72,
    _MarkdownBlockType.math => 64 + (_markdownLineCount(block.text) * 18),
    _MarkdownBlockType.footnote => 28 + (_markdownLineCount(block.text) * 18),
    _MarkdownBlockType.rawHtml => 36 + (_markdownLineCount(block.text) * 20),
    _MarkdownBlockType.horizontalRule => 24,
  };
}

int _markdownLineCount(String value) {
  if (value.isEmpty) {
    return 1;
  }
  return '\n'.allMatches(value).length + 1;
}
