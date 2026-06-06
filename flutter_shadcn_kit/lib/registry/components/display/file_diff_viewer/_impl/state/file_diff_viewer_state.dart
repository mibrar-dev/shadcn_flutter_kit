part of '../../file_diff_viewer.dart';

const _codeFontFamily = 'Geist Mono';
const _codeFontSize = 12.0;
const _copiedFeedbackDuration = Duration(milliseconds: 1200);
const _gutterWidth = 52.0;
const _markerWidth = 28.0;
const _statBadgeAlpha = 0.14;
const _lineBackgroundAlpha = 0.12;
const _segmentHighlightAlpha = 0.16;
const _gutterBackgroundAlpha = 0.45;
const _statBadgePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
const _headerStatGap = 8.0;
const _headerActionGap = 12.0;

class _FileDiffViewerState extends State<FileDiffViewer> {
  final Set<String> _expandedCollapsedHunks = <String>{};
  final Set<String> _copiedFiles = <String>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    final backgroundColor = styleValue(
      themeValue: compTheme?.backgroundColor,
      defaultValue: theme.colorScheme.card,
    );
    final borderColor = styleValue(
      themeValue: compTheme?.borderColor,
      defaultValue: theme.colorScheme.border,
    );
    final borderRadius = styleValue(
      themeValue: compTheme?.borderRadius,
      defaultValue: BorderRadius.circular(theme.radiusLg),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth < widget.minContentWidth
                  ? widget.minContentWidth
                  : constraints.maxWidth)
            : widget.minContentWidth;

        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: theme.scaling),
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: widget.maxHeight,
            child: SingleChildScrollView(
              primary: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < widget.files.length; i++)
                    _buildFile(context, widget.files[i], i, contentWidth),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFile(
    BuildContext context,
    FileDiff file,
    int fileIndex,
    double contentWidth,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showFileHeaders) _buildFileHeader(context, file, fileIndex),
        SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: contentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < file.hunks.length; i++)
                  _buildHunk(context, file, file.hunks[i], fileIndex, i),
              ],
            ),
          ),
        ),
        if (fileIndex < widget.files.length - 1)
          Container(height: theme.scaling, color: theme.colorScheme.border),
      ],
    );
  }

  Widget _buildFileHeader(BuildContext context, FileDiff file, int fileIndex) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    final headerColor = styleValue(
      themeValue: compTheme?.headerBackgroundColor,
      defaultValue: theme.colorScheme.muted,
    );
    final fileKey = '$fileIndex:${file.path}';
    final copied = _copiedFiles.contains(fileKey);

    return Container(
      color: headerColor,
      padding: EdgeInsets.symmetric(
        horizontal: theme.density.baseContainerPadding * theme.scaling * padMd,
        vertical: theme.density.baseContainerPadding * theme.scaling * padSm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.path,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (file.oldPath != null && file.oldPath != file.path)
                  Text(
                    file.oldPath!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.colorScheme.mutedForeground,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          _buildStat(context, '+${file.additions}', _additionColor(context)),
          const SizedBox(width: _headerStatGap),
          _buildStat(context, '-${file.deletions}', _deletionColor(context)),
          const SizedBox(width: _headerActionGap),
          Text(
            file.status,
            style: TextStyle(
              color: theme.colorScheme.mutedForeground,
              fontSize: _codeFontSize,
            ),
          ),
          if (widget.showCopyAction) ...[
            const SizedBox(width: _headerActionGap),
            GhostButton(
              onPressed: () => _copyFilePatch(fileKey, file),
              size: ButtonSize.small,
              density: ButtonDensity.dense,
              child: Text(copied ? 'Copied' : 'Copy'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _copyFilePatch(String fileKey, FileDiff file) async {
    await Clipboard.setData(ClipboardData(text: file.toPatch()));
    if (!mounted) return;
    setState(() => _copiedFiles.add(fileKey));
    await Future<void>.delayed(_copiedFeedbackDuration);
    if (!mounted) return;
    setState(() => _copiedFiles.remove(fileKey));
  }

  Widget _buildStat(BuildContext context, String label, Color color) {
    return Container(
      padding: _statBadgePadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: _statBadgeAlpha),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: _codeFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHunk(
    BuildContext context,
    FileDiff file,
    FileDiffHunk hunk,
    int fileIndex,
    int hunkIndex,
  ) {
    final key = '${file.path}:$fileIndex:$hunkIndex';
    final collapsed =
        widget.collapseUnchanged &&
        hunk.collapsed &&
        !_expandedCollapsedHunks.contains(key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHunkHeader(context, hunk, key, collapsed),
        if (collapsed)
          _buildCollapsedRow(context, hunk.lines.length, key)
        else
          for (final line in hunk.lines)
            widget.layout == FileDiffLayout.split
                ? _buildSplitLine(context, line)
                : _buildUnifiedLine(context, line),
      ],
    );
  }

  Widget _buildHunkHeader(
    BuildContext context,
    FileDiffHunk hunk,
    String key,
    bool collapsed,
  ) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    final hunkColor = styleValue(
      themeValue: compTheme?.hunkBackgroundColor,
      defaultValue: theme.colorScheme.accent,
    );

    return GestureDetector(
      onTap: hunk.collapsed ? () => _toggleCollapsedHunk(key) : null,
      child: Container(
        color: hunkColor,
        padding: _linePadding(context),
        child: Text(
          collapsed
              ? '${hunk.header}  (${hunk.lines.length} hidden lines)'
              : hunk.header,
          style: TextStyle(
            color: theme.colorScheme.accentForeground,
            fontFamily: _codeFontFamily,
            fontSize: _codeFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedRow(BuildContext context, int count, String key) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => setState(() => _expandedCollapsedHunks.add(key)),
      child: Container(
        padding: _linePadding(context),
        child: Text(
          'Show $count unchanged lines',
          style: TextStyle(
            color: theme.colorScheme.mutedForeground,
            fontSize: _codeFontSize,
            fontFamily: _codeFontFamily,
          ),
        ),
      ),
    );
  }

  void _toggleCollapsedHunk(String key) {
    setState(() {
      if (_expandedCollapsedHunks.contains(key)) {
        _expandedCollapsedHunks.remove(key);
      } else {
        _expandedCollapsedHunks.add(key);
      }
    });
  }

  Widget _buildUnifiedLine(BuildContext context, FileDiffLine line) {
    return Container(
      color: _lineColor(context, line.type),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showLineNumbers) ...[
            _buildGutter(context, _lineNumber(line.oldLineNumber)),
            _buildGutter(context, _lineNumber(line.newLineNumber)),
          ],
          _buildMarker(context, line.marker),
          Expanded(child: _buildContent(context, line)),
        ],
      ),
    );
  }

  Widget _buildSplitLine(BuildContext context, FileDiffLine line) {
    final leftVisible = line.type != FileDiffLineType.addition;
    final rightVisible = line.type != FileDiffLineType.deletion;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildSplitCell(
            context,
            leftVisible ? line.oldLineNumber : null,
            leftVisible ? line : null,
            leftVisible ? line.marker : '',
          ),
        ),
        Container(
          width: Theme.of(context).scaling,
          color: Theme.of(context).colorScheme.border,
        ),
        Expanded(
          child: _buildSplitCell(
            context,
            rightVisible ? line.newLineNumber : null,
            rightVisible ? line : null,
            rightVisible ? line.marker : '',
          ),
        ),
      ],
    );
  }

  Widget _buildSplitCell(
    BuildContext context,
    int? number,
    FileDiffLine? line,
    String marker,
  ) {
    return Container(
      color: line == null
          ? Theme.of(context).colorScheme.card
          : _lineColor(context, line.type),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showLineNumbers)
            _buildGutter(context, _lineNumber(number)),
          _buildMarker(context, marker),
          Expanded(
            child: line == null
                ? Padding(padding: _linePadding(context), child: const Text(''))
                : _buildContent(context, line),
          ),
        ],
      ),
    );
  }

  Widget _buildGutter(BuildContext context, String text) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    final gutterColor = styleValue(
      themeValue: compTheme?.gutterBackgroundColor,
      defaultValue: theme.colorScheme.muted.withValues(
        alpha: _gutterBackgroundAlpha,
      ),
    );

    return Container(
      width: _gutterWidth,
      decoration: BoxDecoration(
        color: gutterColor,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.border,
            width: theme.scaling,
          ),
        ),
      ),
      padding: _linePadding(context),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: theme.colorScheme.mutedForeground,
          fontSize: _codeFontSize,
          fontFamily: _codeFontFamily,
        ),
      ),
    );
  }

  Widget _buildMarker(BuildContext context, String marker) {
    final theme = Theme.of(context);
    return Container(
      width: _markerWidth,
      padding: _linePadding(context),
      child: Text(
        marker,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.mutedForeground,
          fontSize: _codeFontSize,
          fontFamily: _codeFontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FileDiffLine line) {
    final theme = Theme.of(context);
    return Padding(
      padding: _linePadding(context),
      child: SelectableText.rich(
        TextSpan(
          children: line.segments.isEmpty
              ? [TextSpan(text: line.content)]
              : [
                  for (final segment in line.segments)
                    TextSpan(
                      text: segment.text,
                      style: segment.highlighted
                          ? TextStyle(
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: _segmentHighlightAlpha),
                            )
                          : null,
                    ),
                ],
        ),
        style: TextStyle(
          color: theme.colorScheme.foreground,
          fontSize: _codeFontSize,
          fontFamily: _codeFontFamily,
          height: 1.45,
        ),
      ),
    );
  }

  EdgeInsetsGeometry _linePadding(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    return styleValue(
      themeValue: compTheme?.linePadding,
      defaultValue: EdgeInsets.symmetric(
        horizontal: theme.density.baseContainerPadding * theme.scaling * padXs,
        vertical: theme.density.baseContainerPadding * theme.scaling * 0.35,
      ),
    );
  }

  String _lineNumber(int? number) => number == null ? '' : '$number';

  Color _lineColor(BuildContext context, FileDiffLineType type) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    switch (type) {
      case FileDiffLineType.addition:
        return _additionColor(context).withValues(alpha: _lineBackgroundAlpha);
      case FileDiffLineType.deletion:
        return _deletionColor(context).withValues(alpha: _lineBackgroundAlpha);
      case FileDiffLineType.hunk:
        return styleValue(
          themeValue: compTheme?.hunkBackgroundColor,
          defaultValue: theme.colorScheme.accent,
        );
      case FileDiffLineType.context:
        return theme.colorScheme.card;
    }
  }

  Color _additionColor(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    return styleValue(
      themeValue: compTheme?.additionBackgroundColor,
      defaultValue: theme.colorScheme.chart2,
    );
  }

  Color _deletionColor(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    return styleValue(
      themeValue: compTheme?.deletionBackgroundColor,
      defaultValue: theme.colorScheme.destructive,
    );
  }
}
