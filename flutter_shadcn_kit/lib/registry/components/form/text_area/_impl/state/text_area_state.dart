// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../text_area.dart';

/// _TextAreaState stores and manages mutable widget state.
class _TextAreaState extends State<TextArea> {
  /// Field storing `_height` for this form implementation.
  late double _height;

  /// Field storing `_width` for this form implementation.
  late double _width;

  /// Initializes stateful resources for this widget.
  @override
  void initState() {
    super.initState();
    _height = widget.initialHeight;
    _width = widget.initialWidth;
  }

  /// Reacts to widget configuration updates from the parent.
  @override
  void didUpdateWidget(covariant TextArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialHeight != oldWidget.initialHeight) {
      _height = widget.initialHeight;
    }
    if (widget.initialWidth != oldWidget.initialWidth) {
      _width = widget.initialWidth;
    }
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    return SizedBox(
      height: _height,
      width: _width,
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: widget.copyWith(
              expands: () => true,
              maxLines: () => null,
              minLines: () => null,
            ),
          ),
          Positioned(
            bottom: -1 * scaling,
            right: -1 * scaling,
            width: (8 + 8) * scaling,
            height: (8 + 8) * scaling,
            child: MouseRegion(
              hitTestBehavior: HitTestBehavior.translucent,
              cursor: widget.expandableWidth
                  ? widget.expandableHeight
                        ? SystemMouseCursors.resizeDownRight
                        : SystemMouseCursors.resizeLeftRight
                  : widget.expandableHeight
                  ? SystemMouseCursors.resizeUpDown
                  : SystemMouseCursors.basic,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (details) {
                  if (widget.expandableHeight && _height.isFinite) {
                    /// Triggers a rebuild after mutating local state.
                    setState(() {
                      _height += details.delta.dy;
                      _height = _height.clamp(
                        widget.minHeight,
                        widget.maxHeight,
                      );
                      widget.onHeightChanged?.call(_height);
                    });
                  }
                  if (widget.expandableWidth && _width.isFinite) {
                    /// Triggers a rebuild after mutating local state.
                    setState(() {
                      _width += details.delta.dx;
                      _width = _width.clamp(widget.minWidth, widget.maxWidth);
                      widget.onWidthChanged?.call(_width);
                    });
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(
                    theme.density.baseGap * scaling * 0.5,
                  ),
                  child: CustomPaint(
                    painter: _TextAreaDragHandlePainter(
                      theme.colorScheme.foreground,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
