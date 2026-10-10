// The `file_diff_viewer` component: unified or split diffs with line gutters,
// coloured additions/deletions, collapsible unchanged hunks and a copy-patch
// action. Fixes over the old copy: the Material `SelectableText` is gone (a
// widgets-only `SelectableRegion` with the kit's own selection controls), the
// hardcoded `GeistMono` font is the ambient `fontMono`, and the localisable
// "Show N unchanged lines" row became a tappable hunk header with a chevron.
// The copy action confirms with an icon for 1200ms, then shows the
// localised "Copy" label again.

import 'dart:math' as math;

import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter/widgets.dart';

import '../../foundation/icons/radix_icons.dart';
import '../../primitives/localizations/localizations.dart';
import '../../primitives/text_editing/text_editing.dart';
import '../../theme/theme.dart';
import '../button/button.dart';
import 'file_diff_viewer_style.dart';

export 'file_diff_viewer_style.dart';

const Duration _copyFeedback = Duration(milliseconds: 1200);

/// A file diff viewer with unified and split layouts.
class FileDiffViewer extends StatefulWidget {
  /// Creates a file diff viewer.
  const FileDiffViewer({
    super.key,
    required this.files,
    this.layout = FileDiffLayout.unified,
    this.showFileHeaders = true,
    this.showLineNumbers = true,
    this.collapseUnchanged = true,
    this.showCopyAction = true,
    this.maxHeight,
    this.minContentWidth = 720.0,
    this.theme,
  });

  /// Files rendered by the viewer, and the layout mode.
  final List<FileDiff> files;
  final FileDiffLayout layout;

  final bool showFileHeaders;
  final bool showLineNumbers;
  final bool collapseUnchanged;
  final bool showCopyAction;
  final double? maxHeight;
  final double minContentWidth;

  /// Widget-leg theme override, merged on top of the other legs.
  final FileDiffViewerTheme? theme;

  @override
  State<FileDiffViewer> createState() => _FileDiffViewerState();
}

class _FileDiffViewerState extends State<FileDiffViewer> {
  final Set<String> _expandedHunks = <String>{};
  final Set<String> _copiedFiles = <String>{};

  @override
  Widget build(BuildContext context) {
    final FileDiffSurface surface = resolveFileDiffSurface(
      context,
      widgetTheme: widget.theme,
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double contentWidth = constraints.maxWidth.isFinite
            ? math.max(constraints.maxWidth, widget.minContentWidth)
            : widget.minContentWidth;
        return Container(
          decoration: BoxDecoration(
            color: surface.background,
            border: Border.all(color: surface.border),
            borderRadius: surface.radius,
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: widget.maxHeight,
            child: SingleChildScrollView(
              primary: false,
              child: SelectableRegion(
                selectionControls: ShadcnSelectionControls(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    for (int i = 0; i < widget.files.length; i++)
                      _buildFile(surface, widget.files[i], i, contentWidth),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFile(
    FileDiffSurface surface,
    FileDiff file,
    int fileIndex,
    double contentWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.showFileHeaders) _buildHeader(surface, file, fileIndex),
        SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: contentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < file.hunks.length; i++)
                  _buildHunk(surface, file, file.hunks[i], fileIndex, i),
              ],
            ),
          ),
        ),
        if (fileIndex < widget.files.length - 1)
          Container(height: 1, color: surface.border),
      ],
    );
  }

  Widget _buildHeader(FileDiffSurface surface, FileDiff file, int fileIndex) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final String key = '$fileIndex:${file.path}';
    return Container(
      color: surface.headerBackground,
      padding: surface.linePadding,
      child: Row(
        children: <Widget>[
          Icon(
            RadixIcons.fileText,
            size: 16 * theme.scaling,
            color: theme.colors.mutedForeground,
          ),
          SizedBox(width: theme.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  file.path,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colors.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (file.oldPath != null && file.oldPath != file.path)
                  Text(
                    file.oldPath!,
                    overflow: TextOverflow.ellipsis,
                    style: surface.codeStyle.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
              ],
            ),
          ),
          _buildStat(surface, '+${file.additions}', surface.addition),
          // Spacers between the inline header items, not fixed content boxes:
          // they follow the spacing scale like every other gap in the registry.
          SizedBox(width: theme.spacing.sm),
          _buildStat(surface, '-${file.deletions}', surface.deletion),
          Text(
            file.status,
            style: surface.codeStyle.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
          if (widget.showCopyAction) ...<Widget>[
            SizedBox(width: theme.spacing.md),
            Button(
              variant: ButtonVariant.ghost,
              size: ButtonSize.sm,
              onPressed: () => _copyPatch(key, file),
              child: _copiedFiles.contains(key)
                  ? Icon(RadixIcons.check, size: 14)
                  : Text(ShadcnLocalizations.of(context).menuCopy),
            ),
          ],
        ],
      ),
    );
  }

  void _toggleHunk(String key) {
    setState(() {
      if (!_expandedHunks.remove(key)) _expandedHunks.add(key);
    });
  }

  Future<void> _copyPatch(String key, FileDiff file) async {
    await Clipboard.setData(ClipboardData(text: file.toPatch()));
    if (!mounted) return;
    setState(() => _copiedFiles.add(key));
    await Future<void>.delayed(_copyFeedback);
    if (!mounted) return;
    setState(() => _copiedFiles.remove(key));
  }

  Widget _buildStat(FileDiffSurface surface, String label, Color color) {
    final TextStyle style = surface.codeStyle.copyWith(
      color: color,
      fontWeight: FontWeight.w600,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: color.a * 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: style),
    );
  }

  Widget _buildHunk(
    FileDiffSurface surface,
    FileDiff file,
    FileDiffHunk hunk,
    int fileIndex,
    int hunkIndex,
  ) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final TextStyle headerStyle = surface.codeStyle.copyWith(
      color: theme.colors.accentForeground,
      fontWeight: FontWeight.w600,
    );
    final String key = '${file.path}:$fileIndex:$hunkIndex';
    final bool collapsed =
        widget.collapseUnchanged &&
        hunk.collapsed &&
        !_expandedHunks.contains(key);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GestureDetector(
          onTap: hunk.collapsed ? () => _toggleHunk(key) : null,
          child: Container(
            color: surface.hunkBackground,
            padding: surface.linePadding,
            child: Row(
              children: <Widget>[
                if (hunk.collapsed)
                  Icon(
                    collapsed
                        ? RadixIcons.chevronRight
                        : RadixIcons.chevronDown,
                    size: 14,
                    color: theme.colors.accentForeground,
                  ),
                Expanded(
                  child: Text(
                    hunk.header,
                    overflow: TextOverflow.ellipsis,
                    style: headerStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!collapsed)
          for (final FileDiffLine line in hunk.lines)
            widget.layout == FileDiffLayout.split
                ? _buildSplitLine(surface, line)
                : _buildUnifiedLine(surface, line),
      ],
    );
  }

  Widget _buildUnifiedLine(FileDiffSurface surface, FileDiffLine line) =>
      _buildRow(surface, line, <int?>[line.oldLineNumber, line.newLineNumber]);

  Widget _buildSplitLine(FileDiffSurface surface, FileDiffLine line) {
    final bool left = line.type != FileDiffLineType.addition;
    final bool right = line.type != FileDiffLineType.deletion;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _buildRow(surface, left ? line : null, <int?>[
            left ? line.oldLineNumber : null,
          ]),
        ),
        Container(width: 1, color: surface.border),
        Expanded(
          child: _buildRow(surface, right ? line : null, <int?>[
            right ? line.newLineNumber : null,
          ]),
        ),
      ],
    );
  }

  /// One padded row: a gutter per entry in [numbers], marker and content.
  Widget _buildRow(
    FileDiffSurface surface,
    FileDiffLine? line,
    List<int?> numbers,
  ) {
    final FileDiffLineType type = line?.type ?? FileDiffLineType.context;
    return _lineBox(
      surface,
      type,
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.showLineNumbers)
            for (final int? number in numbers) _buildGutter(surface, number),
          _buildMarker(surface, line?.marker ?? '', type),
          Expanded(
            child: line == null
                ? Padding(padding: surface.linePadding, child: const Text(''))
                : _buildContent(surface, line),
          ),
        ],
      ),
    );
  }

  /// Padded, optionally filled box around one row.
  Widget _lineBox(
    FileDiffSurface surface,
    FileDiffLineType type,
    Widget child,
  ) {
    final Color? fill = surface.lineFill(type);
    final bool changed =
        type == FileDiffLineType.addition || type == FileDiffLineType.deletion;
    return Container(
      margin: changed
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 1)
          : EdgeInsets.zero,
      decoration: fill == null
          ? null
          : BoxDecoration(color: fill, borderRadius: surface.lineRadius),
      child: child,
    );
  }

  Widget _buildGutter(FileDiffSurface surface, int? number) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    return Container(
      width: surface.gutterWidth,
      decoration: BoxDecoration(
        color: surface.gutterFill,
        border: Border(right: BorderSide(color: surface.border)),
      ),
      padding: surface.linePadding,
      child: Text(
        number?.toString() ?? '',
        textAlign: TextAlign.right,
        style: surface.codeStyle.copyWith(color: theme.colors.mutedForeground),
      ),
    );
  }

  Widget _buildMarker(
    FileDiffSurface surface,
    String marker,
    FileDiffLineType? type,
  ) {
    final ShadcnThemeData theme = ShadcnTheme.of(context);
    final Color? accent = type == null ? null : surface.lineAccent(type);
    return SizedBox(
      width: 32 * theme.scaling,
      child: Center(
        child: Text(
          marker,
          style: surface.codeStyle.copyWith(
            color: accent ?? theme.colors.mutedForeground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(FileDiffSurface surface, FileDiffLine line) {
    return Padding(
      padding: surface.linePadding,
      child: Text.rich(
        TextSpan(text: line.content),
        style: surface.codeStyle.copyWith(
          color: ShadcnTheme.of(context).colors.foreground,
        ),
      ),
    );
  }
}
