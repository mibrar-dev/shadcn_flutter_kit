// Registry-owned data and theme for the `file_diff_viewer` component: the
// diff model (`FileDiff`/`FileDiffHunk`/`FileDiffLine`), the
// [FileDiffViewerTheme] container and the [FileDiffSurface] the widget paints
// with. The models live here because the folder may hold at most three Dart
// files (P4-B17 report); user overrides live in `file_diff_viewer_theme.dart`.

import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../theme/color_tokens.dart';
import '../../theme/theme.dart';

/// Layout mode used by `FileDiffViewer`.
enum FileDiffLayout {
  /// A compact single-column patch.
  unified,

  /// Old and new sides beside each other.
  split,
}

/// Semantic type of a diff line.
enum FileDiffLineType {
  /// Unchanged context line.
  context,

  /// Added line.
  addition,

  /// Deleted line.
  deletion,

  /// Hunk header such as `@@ -1,4 +1,6 @@`.
  hunk,
}

/// One file in a diff.
class FileDiff {
  const FileDiff({
    required this.path,
    required this.hunks,
    this.oldPath,
    this.status = 'modified',
  });

  /// Display path of the file.
  final String path;

  /// Previous path when the file was renamed.
  final String? oldPath;

  /// Diff hunks in this file.
  final List<FileDiffHunk> hunks;

  /// File status label (`modified`, `added`, ...).
  final String status;

  /// Total number of added lines.
  int get additions =>
      hunks.fold(0, (int sum, FileDiffHunk hunk) => sum + hunk.additions);

  /// Total number of deleted lines.
  int get deletions =>
      hunks.fold(0, (int sum, FileDiffHunk hunk) => sum + hunk.deletions);

  /// Plain-text patch representation (used by the copy action).
  String toPatch() {
    final StringBuffer buffer = StringBuffer();
    if (oldPath != null && oldPath != path) {
      buffer
        ..writeln('rename from $oldPath')
        ..writeln('rename to $path');
    }
    buffer
      ..writeln('--- ${oldPath ?? path}')
      ..writeln('+++ $path');
    for (final FileDiffHunk hunk in hunks) {
      buffer.writeln(hunk.header);
      for (final FileDiffLine line in hunk.lines) {
        buffer.writeln('${line.marker}${line.content}');
      }
    }
    return buffer.toString();
  }
}

/// A diff hunk with source and target line ranges.
class FileDiffHunk {
  const FileDiffHunk({
    required this.header,
    required this.lines,
    this.collapsed = false,
  });

  /// Hunk header label.
  final String header;

  /// Lines in this hunk.
  final List<FileDiffLine> lines;

  /// Whether this hunk starts collapsed when `collapseUnchanged` is on.
  final bool collapsed;

  /// Number of added lines.
  int get additions => lines
      .where((FileDiffLine line) => line.type == FileDiffLineType.addition)
      .length;

  /// Number of deleted lines.
  int get deletions => lines
      .where((FileDiffLine line) => line.type == FileDiffLineType.deletion)
      .length;
}

/// A single visual row in a file diff.
class FileDiffLine {
  const FileDiffLine({
    required this.type,
    required this.content,
    this.oldLineNumber,
    this.newLineNumber,
  });

  /// Semantic line type; `oldLineNumber`/`newLineNumber` are null for the
  /// side the line does not exist on (and for hunk headers).
  final FileDiffLineType type;
  final int? oldLineNumber;
  final int? newLineNumber;

  /// Source text without the diff marker.
  final String content;

  /// Prefix used in unified patch text.
  String get marker => switch (type) {
    FileDiffLineType.addition => '+',
    FileDiffLineType.deletion => '-',
    FileDiffLineType.hunk => '',
    FileDiffLineType.context => ' ',
  };
}

/// Geometry and colour of one diff viewer.
///
/// Every field is nullable: an override leg sets only what it changes and
/// [merge] keeps the lower leg's remaining fields.
class FileDiffViewerTheme extends ComponentThemeData
    implements Mergeable<FileDiffViewerTheme> {
  /// Creates a diff viewer theme.
  const FileDiffViewerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.background,
    this.borderColor,
    this.hunkBackground,
    this.additionColor,
    this.deletionColor,
    this.borderRadius,
    this.linePadding,
  });

  /// Surface fill; null resolves the `card` token.
  final ThemedColor? background;

  /// Frame, gutter and split-line colour; null resolves `border`.
  final ThemedColor? borderColor;

  /// Hunk header fill; null resolves `accent`.
  final ThemedColor? hunkBackground;

  /// Addition accent; null resolves `chart2`.
  final ThemedColor? additionColor;

  /// Deletion accent; null resolves `destructive`.
  final ThemedColor? deletionColor;

  /// Outer corner radius; null resolves `radiusLg`.
  final BorderRadiusGeometry? borderRadius;

  /// Row padding for lines, hunk headers and the file header; null resolves
  /// a density-based inset.
  final EdgeInsetsGeometry? linePadding;

  FileDiffViewerTheme copyWith({
    ValueGetter<ThemedColor?>? background,
    ValueGetter<ThemedColor?>? borderColor,
    ValueGetter<ThemedColor?>? hunkBackground,
    ValueGetter<ThemedColor?>? additionColor,
    ValueGetter<ThemedColor?>? deletionColor,
    ValueGetter<BorderRadiusGeometry?>? borderRadius,
    ValueGetter<EdgeInsetsGeometry?>? linePadding,
  }) {
    return FileDiffViewerTheme(
      themeDensity: themeDensity,
      themeSpacing: themeSpacing,
      themeShadows: themeShadows,
      background: background == null ? this.background : background(),
      borderColor: borderColor == null ? this.borderColor : borderColor(),
      hunkBackground: hunkBackground == null
          ? this.hunkBackground
          : hunkBackground(),
      additionColor: additionColor == null
          ? this.additionColor
          : additionColor(),
      deletionColor: deletionColor == null
          ? this.deletionColor
          : deletionColor(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      linePadding: linePadding == null ? this.linePadding : linePadding(),
    );
  }

  /// Receiver wins per field.
  @override
  FileDiffViewerTheme merge(FileDiffViewerTheme? fallback) {
    if (fallback == null) {
      return this;
    }
    return FileDiffViewerTheme(
      themeDensity: themeDensity ?? fallback.themeDensity,
      themeSpacing: themeSpacing ?? fallback.themeSpacing,
      themeShadows: themeShadows ?? fallback.themeShadows,
      background: background ?? fallback.background,
      borderColor: borderColor ?? fallback.borderColor,
      hunkBackground: hunkBackground ?? fallback.hunkBackground,
      additionColor: additionColor ?? fallback.additionColor,
      deletionColor: deletionColor ?? fallback.deletionColor,
      borderRadius: borderRadius ?? fallback.borderRadius,
      linePadding: linePadding ?? fallback.linePadding,
    );
  }

  static FileDiffViewerTheme lerp(
    FileDiffViewerTheme a,
    FileDiffViewerTheme b,
    double t,
  ) {
    return FileDiffViewerTheme(
      themeDensity: t < 0.5 ? a.themeDensity : b.themeDensity,
      themeSpacing: t < 0.5 ? a.themeSpacing : b.themeSpacing,
      themeShadows: t < 0.5 ? a.themeShadows : b.themeShadows,
      background: t < 0.5 ? a.background : b.background,
      borderColor: t < 0.5 ? a.borderColor : b.borderColor,
      hunkBackground: t < 0.5 ? a.hunkBackground : b.hunkBackground,
      additionColor: t < 0.5 ? a.additionColor : b.additionColor,
      deletionColor: t < 0.5 ? a.deletionColor : b.deletionColor,
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      linePadding: EdgeInsetsGeometry.lerp(a.linePadding, b.linePadding, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is FileDiffViewerTheme &&
        other.themeDensity == themeDensity &&
        other.themeSpacing == themeSpacing &&
        other.themeShadows == themeShadows &&
        other.background == background &&
        other.borderColor == borderColor &&
        other.hunkBackground == hunkBackground &&
        other.additionColor == additionColor &&
        other.deletionColor == deletionColor &&
        other.borderRadius == borderRadius &&
        other.linePadding == linePadding;
  }

  @override
  int get hashCode => Object.hash(
    themeDensity,
    themeSpacing,
    themeShadows,
    background,
    borderColor,
    hunkBackground,
    additionColor,
    deletionColor,
    borderRadius,
    linePadding,
  );
}

const FileDiffViewerTheme fileDiffViewerDefaults = FileDiffViewerTheme();

/// Resolved colours, geometry and text style for one diff viewer build.
class FileDiffSurface {
  const FileDiffSurface({
    required this.background,
    required this.border,
    required this.headerBackground,
    required this.hunkBackground,
    required this.addition,
    required this.deletion,
    required this.radius,
    required this.lineRadius,
    required this.linePadding,
    required this.gutterWidth,
    required this.gutterFill,
    required this.codeStyle,
  });

  /// Surface, frame, header and hunk fills.
  final Color background;
  final Color border;
  final Color headerBackground;
  final Color hunkBackground;

  /// Addition and deletion accents (also drive the stat badges at a
  /// multiplied alpha).
  final Color addition;
  final Color deletion;

  /// Outer radius and per-line radius.
  final BorderRadius radius;
  final BorderRadius lineRadius;

  /// Padding of every row; the file header uses the horizontal value with
  /// a little more breathing room.
  final EdgeInsetsGeometry linePadding;

  final double gutterWidth;
  final Color gutterFill;
  final TextStyle codeStyle;

  /// Fill for a line of [type]; null for context/hunk rows.
  Color? lineFill(FileDiffLineType type) => switch (type) {
    FileDiffLineType.addition => addition.withValues(alpha: addition.a * 0.18),
    FileDiffLineType.deletion => deletion.withValues(alpha: deletion.a * 0.18),
    FileDiffLineType.context || FileDiffLineType.hunk => null,
  };

  /// Accent for a line of [type]; null when the row is not coloured.
  Color? lineAccent(FileDiffLineType type) => switch (type) {
    FileDiffLineType.addition => addition,
    FileDiffLineType.deletion => deletion,
    FileDiffLineType.context || FileDiffLineType.hunk => null,
  };
}

/// Resolves the four theme legs plus widget args into build values.
FileDiffSurface resolveFileDiffSurface(
  BuildContext context, {
  FileDiffViewerTheme? widgetTheme,
  BorderRadiusGeometry? borderRadius,
  EdgeInsetsGeometry? linePadding,
}) {
  final ShadcnThemeData theme = ShadcnTheme.of(context);
  final ShadcnColors colors = theme.colors;
  final FileDiffViewerTheme resolved =
      resolveComponentStyle<FileDiffViewerTheme, FileDiffViewerTheme>(
        context,
        widget: widgetTheme,
        select: (t) => t,
        defaults: fileDiffViewerDefaults,
      );
  final double base = theme.density.baseContainerPadding * theme.scaling;
  final BorderRadiusGeometry? radius = borderRadius ?? resolved.borderRadius;
  return FileDiffSurface(
    background: resolved.background?.resolve(colors) ?? colors.card,
    border: resolved.borderColor?.resolve(colors) ?? colors.border,
    headerBackground: colors.muted,
    hunkBackground: resolved.hunkBackground?.resolve(colors) ?? colors.accent,
    addition: resolved.additionColor?.resolve(colors) ?? colors.chart2,
    deletion: resolved.deletionColor?.resolve(colors) ?? colors.destructive,
    radius: radius is BorderRadius
        ? radius
        : radius?.resolve(Directionality.of(context)) ?? theme.borderRadiusLg,
    lineRadius: BorderRadius.circular(theme.radiusSm),
    linePadding:
        linePadding ??
        resolved.linePadding ??
        EdgeInsets.symmetric(horizontal: base * 0.5, vertical: base * 0.35),
    gutterWidth: 52 * theme.scaling,
    gutterFill: colors.muted.withValues(alpha: colors.muted.a * 0.36),
    codeStyle: TextStyle(
      fontFamily: theme.typography.mono.fontFamily,
      fontSize: theme.typography.xSmall.fontSize,
      height: 1.45,
    ),
  );
}
