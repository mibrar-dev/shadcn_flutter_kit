// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../alert_dialog.dart';

/// _AlertDialogState defines a reusable type for this registry module.
class _AlertDialogState extends State<AlertDialog> {
  /// Executes `_wrapIcon` behavior for this component/composite.
  Widget _wrapIcon(ThemeData theme, Widget icon) {
    return IconTheme(
      data: theme.iconTheme.xLarge.copyWith(
        color: theme.colorScheme.mutedForeground,
      ),
      child: icon,
    );
  }

  /// Executes `_wrapTitle` behavior for this component/composite.
  Widget _wrapTitle(ThemeData theme, Widget title) {
    final style = theme.typography.large.merge(theme.typography.semiBold);
    return DefaultTextStyle.merge(style: style, child: title);
  }

  /// Executes `_wrapContent` behavior for this component/composite.
  Widget _wrapContent(ThemeData theme, Widget content) {
    final style = theme.typography.small.copyWith(
      color: theme.colorScheme.mutedForeground,
    );
    return DefaultTextStyle.merge(style: style, child: content);
  }

  /// Executes `_buildHeaderRow` behavior for this component/composite.
  List<Widget> _buildHeaderRow(ThemeData theme, double spacing) {
    /// Stores `children` state/configuration for this implementation.
    final children = <Widget>[];
    if (widget.leading != null) {
      children.add(_wrapIcon(theme, widget.leading!));
    }
    if (widget.title != null || widget.content != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(width: spacing));
      }

      /// Stores `columnChildren` state/configuration for this implementation.
      final columnChildren = <Widget>[];
      if (widget.title != null) {
        columnChildren.add(_wrapTitle(theme, widget.title!));
      }
      if (widget.title != null && widget.content != null) {
        /// Creates a `columnChildren.add` instance.
        columnChildren.add(
          /// Creates a `SizedBox` instance.
          SizedBox(height: theme.density.baseGap * theme.scaling),
        );
      }
      if (widget.content != null) {
        columnChildren.add(_wrapContent(theme, widget.content!));
      }

      /// Creates a `children.add` instance.
      children.add(
        /// Creates a `Flexible` instance.
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnChildren,
          ),
        ),
      );
    }
    if (widget.trailing != null) {
      if (children.isNotEmpty) {
        children.add(SizedBox(width: spacing));
      }
      children.add(_wrapIcon(theme, widget.trailing!));
    }
    return children;
  }

  /// Executes `_buildActions` behavior for this component/composite.
  List<Widget> _buildActions(double spacing) {
    /// Stores `actions` state/configuration for this implementation.
    final actions = widget.actions ?? const [];
    if (actions.isEmpty) {
      return const [];
    }

    /// Stores `widgets` state/configuration for this implementation.
    final widgets = <Widget>[];
    for (var i = 0; i < actions.length; i++) {
      if (i > 0) {
        widgets.add(SizedBox(width: spacing));
      }
      widgets.add(actions[i]);
    }
    return widgets;
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final header = _buildHeaderRow(theme, 16 * scaling);
    final actionRow = _buildActions(8 * scaling);

    return ModalBackdrop(
      borderRadius: theme.borderRadiusXxl,
      barrierColor: widget.barrierColor ?? Colors.black.withValues(alpha: 0.8),
      surfaceClip: ModalBackdrop.shouldClipSurface(
        widget.surfaceOpacity ?? theme.surfaceOpacity,
      ),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 560 * scaling),
          child: ModalContainer(
            fillColor: theme.colorScheme.popover,
            filled: true,
            borderRadius: theme.borderRadiusXxl,
            borderWidth: 1 * scaling,
            borderColor: theme.colorScheme.muted,
            padding:
                widget.padding ??
                /// Creates a `EdgeInsets.all` instance.
                EdgeInsets.all(
                  theme.density.baseContainerPadding * scaling * 1.5,
                ),
            surfaceBlur: widget.surfaceBlur ?? theme.surfaceBlur,
            surfaceOpacity: widget.surfaceOpacity ?? theme.surfaceOpacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (header.isNotEmpty)
                  /// Creates a `Flexible` instance.
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: header,
                    ),
                  ),
                if (header.isNotEmpty && actionRow.isNotEmpty)
                  /// Creates a `SizedBox` instance.
                  SizedBox(height: theme.density.baseContentPadding * scaling),
                if (actionRow.isNotEmpty)
                  /// Creates a `Row` instance.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: actionRow,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
