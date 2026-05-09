// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../menu.dart';

/// MenubarState defines a reusable type for this registry module.
class MenubarState extends State<Menubar> {
  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compTheme = ComponentTheme.maybeOf<MenubarTheme>(context);

    /// Stores `border` state/configuration for this implementation.
    final bool border = compTheme?.border ?? widget.border;

    /// Stores `borderColor` state/configuration for this implementation.
    final borderColor = compTheme?.borderColor ?? theme.colorScheme.border;
    final backgroundColor =
        compTheme?.backgroundColor ?? theme.colorScheme.background;

    /// Stores `borderRadius` state/configuration for this implementation.
    final borderRadius = compTheme?.borderRadius ?? theme.borderRadiusMd;
    final padding =
        compTheme?.padding ??
        EdgeInsets.all(theme.density.baseGap * theme.scaling * 0.5);

    if (border) {
      return OutlinedContainer(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        child: AnimatedPadding(
          duration: kDefaultDuration,
          padding: padding,
          child: buildContainer(
            context,
            theme,
            compTheme?.subMenuOffset ?? widget.popoverOffset,
            border,
          ),
        ),
      );
    }
    return buildContainer(
      context,
      theme,
      compTheme?.subMenuOffset ?? widget.popoverOffset,
      border,
    );
  }

  /// Builds the container widget for the menubar.
  ///
  /// Parameters:
  /// - [context] (`BuildContext`, required): build context
  /// - [theme] (`ThemeData`, required): theme data
  /// - [subMenuOffset] (`Offset?`, optional): offset for submenu positioning
  /// - [border] (`bool`, required): whether to show border
  ///
  /// Returns: `Widget` — container with menu items
  Widget buildContainer(
    BuildContext context,
    ThemeData theme,
    Offset? subMenuOffset,
    bool border,
  ) {
    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final offset =
        subMenuOffset ??
        ((border ? const Offset(-4, 8) : const Offset(0, 4)) * scaling);
    return Data.inherit(
      data: this,
      child: MenuGroup(
        regionGroupId: this,
        direction: Axis.vertical,
        itemPadding: EdgeInsets.zero,
        subMenuOffset: offset,
        autofocus: false,
        builder: (context, children) {
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
          ).medium();
        },
        children: widget.children,
      ),
    );
  }
}
