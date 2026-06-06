// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../file_diff_viewer.dart';

class _FileDiffViewerState extends State<FileDiffViewer> {
  final Set<String> _expandedCollapsedHunks = <String>{};

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
            ? (constraints.maxWidth < 720.0 ? 720.0 : constraints.maxWidth)
            : 720.0;

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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: contentWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < widget.files.length; i++)
                        _buildFile(context, widget.files[i], i),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFile(BuildContext context, FileDiff file, int fileIndex) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showFileHeaders) _buildFileHeader(context, file),
        for (var i = 0; i < file.hunks.length; i++)
          _buildHunk(context, file, file.hunks[i], fileIndex, i),
        if (fileIndex < widget.files.length - 1)
          Container(height: theme.scaling, color: theme.colorScheme.border),
      ],
    );
  }

  Widget _buildFileHeader(BuildContext context, FileDiff file) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    final headerColor = styleValue(
      themeValue: compTheme?.headerBackgroundColor,
      defaultValue: theme.colorScheme.muted,
    );

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
          const SizedBox(width: 8),
          _buildStat(context, '-${file.deletions}', _deletionColor(context)),
          const SizedBox(width: 12),
          Text(
            file.status,
            style: TextStyle(
              color: theme.colorScheme.mutedForeground,
              fontSize: 12,
            ),
          ),
          if (widget.showCopyAction) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () =>
                  Clipboard.setData(ClipboardData(text: file.toPatch())),
              child: Text(
                'Copy',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
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
      onTap: hunk.collapsed
          ? () => setState(() {
              if (_expandedCollapsedHunks.contains(key)) {
                _expandedCollapsedHunks.remove(key);
              } else {
                _expandedCollapsedHunks.add(key);
              }
            })
          : null,
      child: Container(
        color: hunkColor,
        padding: _linePadding(context),
        child: Text(
          collapsed
              ? '${hunk.header}  (${hunk.lines.length} hidden lines)'
              : hunk.header,
          style: TextStyle(
            color: theme.colorScheme.accentForeground,
            fontFamily: 'Geist Mono',
            fontSize: 12,
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
            fontSize: 12,
            fontFamily: 'Geist Mono',
          ),
        ),
      ),
    );
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
    return Container(
      color: _lineColor(context, line.type),
      child: Row(
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
      ),
    );
  }

  Widget _buildSplitCell(
    BuildContext context,
    int? number,
    FileDiffLine? line,
    String marker,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLineNumbers) _buildGutter(context, _lineNumber(number)),
        _buildMarker(context, marker),
        Expanded(
          child: line == null
              ? Padding(padding: _linePadding(context), child: const Text(''))
              : _buildContent(context, line),
        ),
      ],
    );
  }

  Widget _buildGutter(BuildContext context, String text) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    final gutterColor = styleValue(
      themeValue: compTheme?.gutterBackgroundColor,
      defaultValue: theme.colorScheme.muted.withValues(alpha: 0.45),
    );

    return Container(
      width: 52,
      color: gutterColor,
      padding: _linePadding(context),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: theme.colorScheme.mutedForeground,
          fontSize: 12,
          fontFamily: 'Geist Mono',
        ),
      ),
    );
  }

  Widget _buildMarker(BuildContext context, String marker) {
    final theme = Theme.of(context);
    return Container(
      width: 28,
      padding: _linePadding(context),
      child: Text(
        marker,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: theme.colorScheme.mutedForeground,
          fontSize: 12,
          fontFamily: 'Geist Mono',
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
                                  .withValues(alpha: 0.16),
                            )
                          : null,
                    ),
                ],
        ),
        style: TextStyle(
          color: theme.colorScheme.foreground,
          fontSize: 12,
          fontFamily: 'Geist Mono',
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
        return _additionColor(context).withValues(alpha: 0.12);
      case FileDiffLineType.deletion:
        return _deletionColor(context).withValues(alpha: 0.12);
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
