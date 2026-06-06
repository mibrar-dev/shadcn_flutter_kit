part of '../../file_diff_viewer.dart';

const _fallbackCodeFontFamily = 'GeistMono';
const _fallbackCodeFontSize = 12.0;
const _copiedFeedbackDuration = Duration(milliseconds: 1200);
const _fallbackGutterWidth = 52.0;
const _fallbackMarkerWidth = 32.0;
const _fallbackMarkerSize = 18.0;
const _fallbackStatBadgeAlpha = 0.14;
const _fallbackLineBackgroundOpacity = 0.18;
const _fallbackSegmentHighlightOpacity = 0.32;
const _fallbackGutterBackgroundAlpha = 0.36;
const _statBadgePadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
const _headerStatGap = 8.0;
const _headerActionGap = 12.0;

class _FileDiffViewerState extends State<FileDiffViewer> {
  final Set<String> _expandedCollapsedHunks = <String>{};
  final Set<String> _copiedFiles = <String>{};

  @override
  Widget build(BuildContext context) {
    final resolved = _FileDiffResolvedStyle.resolve(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth < widget.minContentWidth
                  ? widget.minContentWidth
                  : constraints.maxWidth)
            : widget.minContentWidth;

        return Container(
          decoration: BoxDecoration(
            color: resolved.backgroundColor,
            border: Border.all(
              color: resolved.borderColor,
              width: resolved.borderWidth,
            ),
            borderRadius: resolved.borderRadius,
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
                    _buildFile(
                      context,
                      resolved,
                      widget.files[i],
                      i,
                      contentWidth,
                    ),
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
    _FileDiffResolvedStyle resolved,
    FileDiff file,
    int fileIndex,
    double contentWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showFileHeaders)
          _buildFileHeader(context, resolved, file, fileIndex),
        SingleChildScrollView(
          primary: false,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: contentWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < file.hunks.length; i++)
                  _buildHunk(
                    context,
                    resolved,
                    file,
                    file.hunks[i],
                    fileIndex,
                    i,
                  ),
              ],
            ),
          ),
        ),
        if (fileIndex < widget.files.length - 1)
          Container(height: resolved.borderWidth, color: resolved.borderColor),
      ],
    );
  }

  Widget _buildFileHeader(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    FileDiff file,
    int fileIndex,
  ) {
    final theme = Theme.of(context);
    final fileKey = '$fileIndex:${file.path}';
    final copied = _copiedFiles.contains(fileKey);

    return Container(
      color: resolved.headerBackgroundColor,
      padding: resolved.headerPadding,
      child: Row(
        children: [
          Icon(
            RadixIcons.fileText,
            color: resolved.headerIconColor,
            size: 16 * theme.scaling,
          ),
          SizedBox(width: theme.spacing.sm),
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
                      fontSize: resolved.codeFontSize,
                    ),
                  ),
              ],
            ),
          ),
          _buildStat(
            context,
            resolved,
            '+${file.additions}',
            resolved.additionColor,
          ),
          const SizedBox(width: _headerStatGap),
          _buildStat(
            context,
            resolved,
            '-${file.deletions}',
            resolved.deletionColor,
          ),
          const SizedBox(width: _headerActionGap),
          Text(
            file.status,
            style: TextStyle(
              color: theme.colorScheme.mutedForeground,
              fontSize: resolved.codeFontSize,
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

  Widget _buildStat(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    String label,
    Color color,
  ) {
    return Container(
      padding: _statBadgePadding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: _fallbackStatBadgeAlpha),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: resolved.codeFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHunk(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
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
        _buildHunkHeader(context, resolved, hunk, key, collapsed),
        if (collapsed)
          _buildCollapsedRow(context, resolved, hunk.lines.length, key)
        else
          for (final line in hunk.lines)
            widget.layout == FileDiffLayout.split
                ? _buildSplitLine(context, resolved, line)
                : _buildUnifiedLine(context, resolved, line),
      ],
    );
  }

  Widget _buildHunkHeader(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    FileDiffHunk hunk,
    String key,
    bool collapsed,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: hunk.collapsed ? () => _toggleCollapsedHunk(key) : null,
      child: Container(
        color: resolved.hunkBackgroundColor,
        padding: resolved.linePadding,
        child: Text(
          collapsed
              ? '${hunk.header}  (${hunk.lines.length} hidden lines)'
              : hunk.header,
          style: TextStyle(
            color: theme.colorScheme.accentForeground,
            fontFamily: resolved.codeFontFamily,
            fontSize: resolved.codeFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedRow(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    int count,
    String key,
  ) {
    return GestureDetector(
      onTap: () => setState(() => _expandedCollapsedHunks.add(key)),
      child: Container(
        padding: resolved.linePadding,
        child: Text(
          'Show $count unchanged lines',
          style: TextStyle(
            color: resolved.gutterForegroundColor,
            fontSize: resolved.codeFontSize,
            fontFamily: resolved.codeFontFamily,
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

  Widget _buildUnifiedLine(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    FileDiffLine line,
  ) {
    return Container(
      color: resolved.backgroundColor,
      child: Container(
        margin: _lineMargin(line.type),
        decoration: _lineDecoration(resolved, line.type),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showLineNumbers) ...[
              _buildGutter(context, resolved, _lineNumber(line.oldLineNumber)),
              _buildGutter(context, resolved, _lineNumber(line.newLineNumber)),
            ],
            _buildMarker(context, resolved, line.marker, line.type),
            Expanded(child: _buildContent(context, resolved, line)),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitLine(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    FileDiffLine line,
  ) {
    final leftVisible = line.type != FileDiffLineType.addition;
    final rightVisible = line.type != FileDiffLineType.deletion;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildSplitCell(
            context,
            resolved,
            leftVisible ? line.oldLineNumber : null,
            leftVisible ? line : null,
            leftVisible ? line.marker : '',
          ),
        ),
        Container(width: resolved.borderWidth, color: resolved.borderColor),
        Expanded(
          child: _buildSplitCell(
            context,
            resolved,
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
    _FileDiffResolvedStyle resolved,
    int? number,
    FileDiffLine? line,
    String marker,
  ) {
    final type = line?.type ?? FileDiffLineType.context;
    return Container(
      color: resolved.backgroundColor,
      child: Container(
        margin: _lineMargin(type),
        decoration: line == null ? null : _lineDecoration(resolved, type),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showLineNumbers)
              _buildGutter(context, resolved, _lineNumber(number)),
            _buildMarker(context, resolved, marker, type),
            Expanded(
              child: line == null
                  ? Padding(
                      padding: resolved.linePadding,
                      child: const Text(''),
                    )
                  : _buildContent(context, resolved, line),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsetsGeometry _lineMargin(FileDiffLineType type) {
    return switch (type) {
      FileDiffLineType.addition || FileDiffLineType.deletion =>
        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      FileDiffLineType.context || FileDiffLineType.hunk => EdgeInsets.zero,
    };
  }

  Decoration? _lineDecoration(
    _FileDiffResolvedStyle resolved,
    FileDiffLineType type,
  ) {
    final color = _lineColor(resolved, type);
    if (type == FileDiffLineType.context || type == FileDiffLineType.hunk) {
      return null;
    }
    return BoxDecoration(color: color, borderRadius: resolved.lineBorderRadius);
  }

  Widget _buildGutter(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    String text,
  ) {
    return Container(
      width: resolved.gutterWidth,
      decoration: BoxDecoration(
        color: resolved.gutterBackgroundColor,
        border: Border(
          right: BorderSide(
            color: resolved.borderColor,
            width: resolved.borderWidth,
          ),
        ),
      ),
      padding: resolved.linePadding,
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          color: resolved.gutterForegroundColor,
          fontSize: resolved.codeFontSize,
          fontFamily: resolved.codeFontFamily,
        ),
      ),
    );
  }

  Widget _buildMarker(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    String marker,
    FileDiffLineType type,
  ) {
    final markerColor = switch (type) {
      FileDiffLineType.addition => resolved.additionMarkerColor,
      FileDiffLineType.deletion => resolved.deletionMarkerColor,
      FileDiffLineType.context || FileDiffLineType.hunk => null,
    };

    return Container(
      width: resolved.markerWidth,
      padding: resolved.linePadding,
      child: Center(
        child: markerColor == null || marker.trim().isEmpty
            ? Text(
                marker,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: resolved.gutterForegroundColor,
                  fontSize: resolved.codeFontSize,
                  fontFamily: resolved.codeFontFamily,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Container(
                width: resolved.markerSize,
                height: resolved.markerSize,
                decoration: BoxDecoration(
                  color: markerColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    marker,
                    style: TextStyle(
                      color: resolved.markerForegroundColor,
                      fontSize: resolved.codeFontSize,
                      fontFamily: resolved.codeFontFamily,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    _FileDiffResolvedStyle resolved,
    FileDiffLine line,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: resolved.linePadding,
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
                              backgroundColor: _segmentHighlightColor(
                                theme,
                                resolved,
                                line.type,
                              ),
                            )
                          : null,
                    ),
                ],
        ),
        style: TextStyle(
          color: theme.colorScheme.foreground,
          fontSize: resolved.codeFontSize,
          fontFamily: resolved.codeFontFamily,
          height: 1.45,
        ),
      ),
    );
  }

  Color _segmentHighlightColor(
    ThemeData theme,
    _FileDiffResolvedStyle resolved,
    FileDiffLineType type,
  ) {
    return switch (type) {
      FileDiffLineType.addition => resolved.additionColor.withValues(
        alpha: resolved.segmentHighlightOpacity,
      ),
      FileDiffLineType.deletion => resolved.deletionColor.withValues(
        alpha: resolved.segmentHighlightOpacity,
      ),
      FileDiffLineType.context ||
      FileDiffLineType.hunk => theme.colorScheme.primary.withValues(
        alpha: resolved.segmentHighlightOpacity,
      ),
    };
  }

  String _lineNumber(int? number) => number == null ? '' : '$number';

  Color _lineColor(_FileDiffResolvedStyle resolved, FileDiffLineType type) {
    return switch (type) {
      FileDiffLineType.addition => resolved.additionColor.withValues(
        alpha: resolved.lineBackgroundOpacity,
      ),
      FileDiffLineType.deletion => resolved.deletionColor.withValues(
        alpha: resolved.lineBackgroundOpacity,
      ),
      FileDiffLineType.hunk => resolved.hunkBackgroundColor,
      FileDiffLineType.context => resolved.backgroundColor,
    };
  }
}

class _FileDiffResolvedStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color headerBackgroundColor;
  final Color headerIconColor;
  final Color hunkBackgroundColor;
  final Color gutterBackgroundColor;
  final Color gutterForegroundColor;
  final Color additionColor;
  final Color deletionColor;
  final Color additionMarkerColor;
  final Color deletionMarkerColor;
  final Color markerForegroundColor;
  final BorderRadiusGeometry borderRadius;
  final BorderRadiusGeometry lineBorderRadius;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry linePadding;
  final String codeFontFamily;
  final double codeFontSize;
  final double gutterWidth;
  final double markerWidth;
  final double markerSize;
  final double borderWidth;
  final double lineBackgroundOpacity;
  final double segmentHighlightOpacity;

  const _FileDiffResolvedStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.headerBackgroundColor,
    required this.headerIconColor,
    required this.hunkBackgroundColor,
    required this.gutterBackgroundColor,
    required this.gutterForegroundColor,
    required this.additionColor,
    required this.deletionColor,
    required this.additionMarkerColor,
    required this.deletionMarkerColor,
    required this.markerForegroundColor,
    required this.borderRadius,
    required this.lineBorderRadius,
    required this.headerPadding,
    required this.linePadding,
    required this.codeFontFamily,
    required this.codeFontSize,
    required this.gutterWidth,
    required this.markerWidth,
    required this.markerSize,
    required this.borderWidth,
    required this.lineBackgroundOpacity,
    required this.segmentHighlightOpacity,
  });

  factory _FileDiffResolvedStyle.resolve(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<FileDiffViewerTheme>(context);
    final additionColor = styleValue(
      themeValue: compTheme?.additionBackgroundColor,
      defaultValue: theme.colorScheme.chart2,
    );
    final deletionColor = styleValue(
      themeValue: compTheme?.deletionBackgroundColor,
      defaultValue: theme.colorScheme.destructive,
    );
    final codeFontFamily = styleValue(
      themeValue: compTheme?.codeFontFamily,
      defaultValue: theme.typography.mono.fontFamily ?? _fallbackCodeFontFamily,
    );
    final codeFontSize = styleValue(
      themeValue: compTheme?.codeFontSize,
      defaultValue: theme.typography.xSmall.fontSize ?? _fallbackCodeFontSize,
    );

    return _FileDiffResolvedStyle(
      backgroundColor: styleValue(
        themeValue: compTheme?.backgroundColor,
        defaultValue: theme.colorScheme.card,
      ),
      borderColor: styleValue(
        themeValue: compTheme?.borderColor,
        defaultValue: theme.colorScheme.border,
      ),
      headerBackgroundColor: styleValue(
        themeValue: compTheme?.headerBackgroundColor,
        defaultValue: theme.colorScheme.muted,
      ),
      headerIconColor: styleValue(
        themeValue: compTheme?.headerIconColor,
        defaultValue: theme.colorScheme.mutedForeground,
      ),
      hunkBackgroundColor: styleValue(
        themeValue: compTheme?.hunkBackgroundColor,
        defaultValue: theme.colorScheme.accent,
      ),
      gutterBackgroundColor: styleValue(
        themeValue: compTheme?.gutterBackgroundColor,
        defaultValue: theme.colorScheme.muted.withValues(
          alpha: _fallbackGutterBackgroundAlpha,
        ),
      ),
      gutterForegroundColor: styleValue(
        themeValue: compTheme?.gutterForegroundColor,
        defaultValue: theme.colorScheme.mutedForeground,
      ),
      additionColor: additionColor,
      deletionColor: deletionColor,
      additionMarkerColor: styleValue(
        themeValue: compTheme?.additionMarkerColor,
        defaultValue: additionColor,
      ),
      deletionMarkerColor: styleValue(
        themeValue: compTheme?.deletionMarkerColor,
        defaultValue: deletionColor,
      ),
      markerForegroundColor: styleValue(
        themeValue: compTheme?.markerForegroundColor,
        defaultValue: theme.colorScheme.background,
      ),
      borderRadius: styleValue(
        themeValue: compTheme?.borderRadius,
        defaultValue: BorderRadius.circular(theme.radiusLg),
      ),
      lineBorderRadius: styleValue(
        themeValue: compTheme?.lineBorderRadius,
        defaultValue: BorderRadius.circular(theme.radiusSm),
      ),
      headerPadding: styleValue(
        themeValue: compTheme?.headerPadding,
        defaultValue: EdgeInsets.symmetric(
          horizontal:
              theme.density.baseContainerPadding * theme.scaling * padMd,
          vertical: theme.density.baseContainerPadding * theme.scaling * padSm,
        ),
      ),
      linePadding: styleValue(
        themeValue: compTheme?.linePadding,
        defaultValue: EdgeInsets.symmetric(
          horizontal:
              theme.density.baseContainerPadding * theme.scaling * padXs,
          vertical: theme.density.baseContainerPadding * theme.scaling * 0.35,
        ),
      ),
      codeFontFamily: codeFontFamily,
      codeFontSize: codeFontSize,
      gutterWidth: styleValue(
        themeValue: compTheme?.gutterWidth,
        defaultValue: _fallbackGutterWidth * theme.scaling,
      ),
      markerWidth: styleValue(
        themeValue: compTheme?.markerWidth,
        defaultValue: _fallbackMarkerWidth * theme.scaling,
      ),
      markerSize: styleValue(
        themeValue: compTheme?.markerSize,
        defaultValue: _fallbackMarkerSize * theme.scaling,
      ),
      borderWidth: theme.scaling,
      lineBackgroundOpacity: styleValue(
        themeValue: compTheme?.lineBackgroundOpacity,
        defaultValue: _fallbackLineBackgroundOpacity,
      ),
      segmentHighlightOpacity: styleValue(
        themeValue: compTheme?.segmentHighlightOpacity,
        defaultValue: _fallbackSegmentHighlightOpacity,
      ),
    );
  }
}
