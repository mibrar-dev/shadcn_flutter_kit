part of '../../file_diff_viewer.dart';

/// A single file in a diff.
class FileDiff {
  /// Display path for the file.
  final String path;

  /// Previous path when the file was renamed.
  final String? oldPath;

  /// Diff hunks in this file.
  final List<FileDiffHunk> hunks;

  /// Optional file status label.
  final String status;

  /// Creates a file diff model.
  const FileDiff({
    required this.path,
    required this.hunks,
    this.oldPath,
    this.status = 'modified',
  });

  /// Total number of added lines.
  int get additions => hunks.fold(0, (sum, hunk) => sum + hunk.additions);

  /// Total number of deleted lines.
  int get deletions => hunks.fold(0, (sum, hunk) => sum + hunk.deletions);

  /// Returns a plain-text patch representation.
  String toPatch() {
    final buffer = StringBuffer();
    if (oldPath != null && oldPath != path) {
      buffer.writeln('rename from $oldPath');
      buffer.writeln('rename to $path');
    }
    buffer.writeln('--- ${oldPath ?? path}');
    buffer.writeln('+++ $path');
    for (final hunk in hunks) {
      buffer.writeln(hunk.header);
      for (final line in hunk.lines) {
        buffer.writeln('${line.marker}${line.content}');
      }
    }
    return buffer.toString();
  }
}

/// A diff hunk with source and target line ranges.
class FileDiffHunk {
  /// Hunk header label.
  final String header;

  /// Lines in this hunk.
  final List<FileDiffLine> lines;

  /// Whether this hunk starts collapsed when [FileDiffViewer.collapseUnchanged]
  /// is enabled.
  final bool collapsed;

  /// Creates a diff hunk.
  const FileDiffHunk({
    required this.header,
    required this.lines,
    this.collapsed = false,
  });

  /// Total number of added lines.
  int get additions =>
      lines.where((line) => line.type == FileDiffLineType.addition).length;

  /// Total number of deleted lines.
  int get deletions =>
      lines.where((line) => line.type == FileDiffLineType.deletion).length;
}

/// A single visual row in a file diff.
class FileDiffLine {
  /// Semantic line type.
  final FileDiffLineType type;

  /// Old-side line number.
  final int? oldLineNumber;

  /// New-side line number.
  final int? newLineNumber;

  /// Source text content without diff marker.
  final String content;

  /// Optional inline segments for future syntax-aware renderers.
  final List<FileDiffSegment> segments;

  /// Creates a diff line.
  const FileDiffLine({
    required this.type,
    required this.content,
    this.oldLineNumber,
    this.newLineNumber,
    this.segments = const [],
  });

  /// Creates an unchanged context line.
  const FileDiffLine.context({
    required this.content,
    this.oldLineNumber,
    this.newLineNumber,
    this.segments = const [],
  }) : type = FileDiffLineType.context;

  /// Creates an added line.
  const FileDiffLine.addition({
    required this.content,
    this.newLineNumber,
    this.segments = const [],
  }) : type = FileDiffLineType.addition,
       oldLineNumber = null;

  /// Creates a deleted line.
  const FileDiffLine.deletion({
    required this.content,
    this.oldLineNumber,
    this.segments = const [],
  }) : type = FileDiffLineType.deletion,
       newLineNumber = null;

  /// Creates a hunk header line.
  const FileDiffLine.hunk({required this.content})
    : type = FileDiffLineType.hunk,
      oldLineNumber = null,
      newLineNumber = null,
      segments = const [];

  /// Prefix used in unified patch text.
  String get marker => switch (type) {
    FileDiffLineType.addition => '+',
    FileDiffLineType.deletion => '-',
    FileDiffLineType.hunk => '',
    FileDiffLineType.context => ' ',
  };
}

/// Inline segment metadata for a diff line.
class FileDiffSegment {
  /// Segment text.
  final String text;

  /// Whether this segment is highlighted as changed.
  final bool highlighted;

  /// Creates an inline diff segment.
  const FileDiffSegment(this.text, {this.highlighted = false});
}
