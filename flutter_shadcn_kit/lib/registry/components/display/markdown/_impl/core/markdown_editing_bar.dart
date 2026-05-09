// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../markdown.dart';

typedef MarkdownEditingBarActionHandler =
    void Function(BuildContext context, MarkdownEditingController controller);
typedef MarkdownEditingBarItemBuilder =
    Widget Function(
      BuildContext context,
      MarkdownEditingBarItemDetails details,
    );

@immutable
class MarkdownEditingBarAction {
  const MarkdownEditingBarAction({
    required this.id,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isEnabled,
  });

  final String id;
  final IconData icon;
  final String tooltip;
  final MarkdownEditingBarActionHandler onPressed;
  final bool Function(MarkdownEditingController controller)? isEnabled;

  bool enabledFor(MarkdownEditingController controller) {
    return isEnabled?.call(controller) ?? true;
  }

  static List<MarkdownEditingBarAction> defaults() {
    return <MarkdownEditingBarAction>[
      undo(),
      redo(),
      divider(),
      bold(),
      italic(),
      headingCycle(),
      inlineCode(),
      strikethrough(),
      bulletList(),
      orderedList(),
      taskList(),
      quote(),
      codeFence(),
      horizontalRule(),
      table(),
      link(),
      image(),
    ];
  }

  static MarkdownEditingBarAction divider() {
    return MarkdownEditingBarAction(
      id: '__divider__',
      icon: Icons.more_vert_rounded,
      tooltip: '',
      onPressed: _noopMarkdownEditAction,
      isEnabled: _alwaysDisabledMarkdownEditAction,
    );
  }

  static MarkdownEditingBarAction undo() {
    return MarkdownEditingBarAction(
      id: 'undo',
      icon: Icons.undo_rounded,
      tooltip: 'Undo',
      onPressed: (context, controller) => controller.undo(),
    );
  }

  static MarkdownEditingBarAction redo() {
    return MarkdownEditingBarAction(
      id: 'redo',
      icon: Icons.redo_rounded,
      tooltip: 'Redo',
      onPressed: (context, controller) => controller.redo(),
    );
  }

  static MarkdownEditingBarAction bold() {
    return MarkdownEditingBarAction(
      id: 'bold',
      icon: Icons.format_bold_rounded,
      tooltip: 'Bold',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.toggleBold),
    );
  }

  static MarkdownEditingBarAction italic() {
    return MarkdownEditingBarAction(
      id: 'italic',
      icon: Icons.format_italic_rounded,
      tooltip: 'Italic',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.toggleItalic),
    );
  }

  static MarkdownEditingBarAction heading({int level = 2}) {
    return MarkdownEditingBarAction(
      id: 'heading-$level',
      icon: Icons.title_rounded,
      tooltip: 'Heading $level',
      onPressed: (context, controller) => controller.applyTransformer(
        ({required text, required selection}) =>
            MarkdownEditingHelpers.toggleHeading(
              text: text,
              selection: selection,
              level: level,
            ),
      ),
    );
  }

  static MarkdownEditingBarAction headingCycle() {
    return MarkdownEditingBarAction(
      id: 'heading-cycle',
      icon: Icons.title_rounded,
      tooltip: 'Cycle heading level',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.cycleHeading),
    );
  }

  static MarkdownEditingBarAction inlineCode() {
    return MarkdownEditingBarAction(
      id: 'inline-code',
      icon: Icons.code_off_rounded,
      tooltip: 'Inline code',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.toggleInlineCode),
    );
  }

  static MarkdownEditingBarAction strikethrough() {
    return MarkdownEditingBarAction(
      id: 'strikethrough',
      icon: Icons.format_strikethrough_rounded,
      tooltip: 'Strikethrough',
      onPressed: (context, controller) => controller.applyTransformer(
        MarkdownEditingHelpers.toggleStrikethrough,
      ),
    );
  }

  static MarkdownEditingBarAction bulletList() {
    return MarkdownEditingBarAction(
      id: 'bullet-list',
      icon: Icons.format_list_bulleted_rounded,
      tooltip: 'Bullet list',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.toggleBulletList),
    );
  }

  static MarkdownEditingBarAction orderedList() {
    return MarkdownEditingBarAction(
      id: 'ordered-list',
      icon: Icons.format_list_numbered_rounded,
      tooltip: 'Ordered list',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.toggleOrderedList),
    );
  }

  static MarkdownEditingBarAction taskList() {
    return MarkdownEditingBarAction(
      id: 'task-list',
      icon: Icons.checklist_rtl_rounded,
      tooltip: 'Task list',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.toggleTaskList),
    );
  }

  static MarkdownEditingBarAction quote() {
    return MarkdownEditingBarAction(
      id: 'quote',
      icon: Icons.format_quote_rounded,
      tooltip: 'Quote',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.toggleQuote),
    );
  }

  static MarkdownEditingBarAction codeFence({String language = 'dart'}) {
    return MarkdownEditingBarAction(
      id: 'code-fence',
      icon: Icons.code_rounded,
      tooltip: 'Code fence',
      onPressed: (context, controller) => controller.applyTransformer(
        ({required text, required selection}) =>
            MarkdownEditingHelpers.wrapCodeFence(
              text: text,
              selection: selection,
              language: language,
            ),
      ),
    );
  }

  static MarkdownEditingBarAction horizontalRule() {
    return MarkdownEditingBarAction(
      id: 'horizontal-rule',
      icon: Icons.horizontal_rule_rounded,
      tooltip: 'Horizontal rule',
      onPressed: (context, controller) => controller.applyTransformer(
        MarkdownEditingHelpers.insertHorizontalRule,
      ),
    );
  }

  static MarkdownEditingBarAction table() {
    return MarkdownEditingBarAction(
      id: 'table',
      icon: Icons.table_chart_rounded,
      tooltip: 'Insert table',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.insertTable),
    );
  }

  static MarkdownEditingBarAction link() {
    return MarkdownEditingBarAction(
      id: 'link',
      icon: Icons.link_rounded,
      tooltip: 'Insert link',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.insertLink),
    );
  }

  static MarkdownEditingBarAction image() {
    return MarkdownEditingBarAction(
      id: 'image',
      icon: Icons.image_outlined,
      tooltip: 'Insert image',
      onPressed: (context, controller) =>
          controller.applyTransformer(MarkdownEditingHelpers.insertImage),
    );
  }
}

@immutable
class MarkdownEditingBarItemDetails {
  const MarkdownEditingBarItemDetails({
    required this.action,
    required this.controller,
    required this.enabled,
  });

  final MarkdownEditingBarAction action;
  final MarkdownEditingController controller;
  final bool enabled;
}

class MarkdownEditingBar extends StatefulWidget {
  const MarkdownEditingBar({
    super.key,
    required this.controller,
    this.focusNode,
    this.actions,
    this.itemBuilder,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    this.spacing = 6,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
    this.disabledIconColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(14)),
    this.borderColor,
  });

  final MarkdownEditingController controller;
  final FocusNode? focusNode;
  final List<MarkdownEditingBarAction>? actions;
  final MarkdownEditingBarItemBuilder? itemBuilder;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? disabledIconColor;
  final BorderRadiusGeometry borderRadius;
  final Color? borderColor;

  @override
  State<MarkdownEditingBar> createState() => _MarkdownEditingBarState();
}

class _MarkdownEditingBarState extends State<MarkdownEditingBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant MarkdownEditingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedActions =
        widget.actions ?? MarkdownEditingBarAction.defaults();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor =
        widget.backgroundColor ??
        (isDark ? scheme.surfaceContainerHigh : scheme.surface);
    final borderColor =
        widget.borderColor ??
        (isDark
            ? scheme.outline.withValues(alpha: 0.4)
            : scheme.outlineVariant.withValues(alpha: 0.8));
    final iconBackground =
        widget.iconBackgroundColor ??
        (isDark
            ? scheme.surfaceContainerHighest.withValues(alpha: 0.55)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.75));
    final iconColor = widget.iconColor ?? scheme.onSurface;
    final disabledIconColor =
        widget.disabledIconColor ?? scheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: widget.borderRadius,
          border: Border.all(color: borderColor),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: scheme.shadow.withValues(alpha: isDark ? 0.32 : 0.14),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        padding: widget.padding,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              if (widget.leading != null) ...<Widget>[
                widget.leading!,
                SizedBox(width: widget.spacing),
              ],
              for (final action in resolvedActions) ...<Widget>[
                _buildAction(
                  context,
                  action,
                  iconBackgroundColor: iconBackground,
                  iconColor: iconColor,
                  disabledIconColor: disabledIconColor,
                ),
                SizedBox(width: widget.spacing),
              ],
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction(
    BuildContext context,
    MarkdownEditingBarAction action, {
    required Color iconBackgroundColor,
    required Color iconColor,
    required Color disabledIconColor,
  }) {
    if (action.id == '__divider__') {
      return Container(
        width: 1,
        height: 26,
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: 0.7),
        margin: const EdgeInsets.symmetric(horizontal: 4),
      );
    }

    final enabled = action.enabledFor(widget.controller);
    final details = MarkdownEditingBarItemDetails(
      action: action,
      controller: widget.controller,
      enabled: enabled,
    );
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(context, details);
    }

    return IconButton(
      onPressed: enabled
          ? () {
              action.onPressed(context, widget.controller);
              widget.focusNode?.requestFocus();
            }
          : null,
      tooltip: action.tooltip,
      style: IconButton.styleFrom(
        backgroundColor: enabled ? iconBackgroundColor : Colors.transparent,
        foregroundColor: enabled ? iconColor : disabledIconColor,
        minimumSize: const Size(38, 38),
        maximumSize: const Size(38, 38),
        padding: EdgeInsets.zero,
      ),
      icon: Icon(action.icon, size: 22),
    );
  }
}

void _noopMarkdownEditAction(
  BuildContext context,
  MarkdownEditingController controller,
) {}

bool _alwaysDisabledMarkdownEditAction(MarkdownEditingController controller) {
  return false;
}
