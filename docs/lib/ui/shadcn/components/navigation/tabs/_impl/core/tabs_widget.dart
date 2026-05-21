// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// Tabs defines a reusable type for this registry module.
class Tabs extends StatelessWidget {
  /// The index of the currently selected tab (0-indexed).
  ///
  /// Must be between 0 and `children.length - 1` inclusive.
  final int index;

  /// Used to expand children horizontally
  final bool expand;

  /// Callback invoked when the user selects a different tab.
  ///
  /// Called with the new tab index when the user taps a tab header.
  final ValueChanged<int> onChanged;

  /// List of tab children defining tab headers and content.
  ///
  /// Each [TabChild] contains a tab header widget and the associated
  /// content panel widget. The list must not be empty.
  final List<TabChild> children;

  /// Optional padding around individual tabs.
  ///
  /// Overrides the theme's tab padding if provided. If `null`,
  /// uses the padding from [TabsTheme].
  final EdgeInsetsGeometry? padding;

  /// Creates a tabs widget.
  ///
  /// Parameters:
  /// - [index]: Currently selected tab index (required)
  /// - [onChanged]: Tab selection callback (required)
  /// - [children]: List of tab children (required, non-empty)
  /// - [padding]: Custom tab padding (optional)
  const Tabs({
    super.key,
    required this.index,
    required this.onChanged,
    required this.children,
    this.padding,
    this.expand = false,
  });

  Widget _childBuilder(
    BuildContext context,
    TabContainerData data,
    Widget child,
  ) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<TabsTheme>(context);
    final tabPadding = styleValue(
      defaultValue: EdgeInsets.symmetric(
        horizontal: theme.density.baseContentPadding * scaling,
        vertical: theme.density.baseGap * scaling * 0.5,
      ),
      themeValue: compTheme?.tabPadding,
      widgetValue: padding,
    );

    /// Stores `i` state/configuration for this implementation.
    final i = data.index;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onChanged(i);
      },
      child: MouseRegion(
        hitTestBehavior: HitTestBehavior.translucent,
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 50,
          ), // slightly faster than kDefaultDuration
          alignment: Alignment.center,
          padding: tabPadding,
          decoration: BoxDecoration(
            color: i == index ? theme.colorScheme.background : null,
            borderRadius: BorderRadius.circular(theme.radiusMd),
          ),
          child: (i == index ? child.foreground() : child.muted())
              .small()
              .medium(),
        ),
      ),
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Stores `scaling` state/configuration for this implementation.
    final scaling = theme.scaling;
    final compTheme = ComponentTheme.maybeOf<TabsTheme>(context);
    final containerPadding = styleValue(
      defaultValue: EdgeInsets.all(theme.density.baseGap * scaling * 0.5),
      themeValue: compTheme?.containerPadding,
    );
    final backgroundColor = styleValue(
      defaultValue: theme.colorScheme.muted,
      themeValue: compTheme?.backgroundColor,
    );
    final borderRadius = styleValue(
      defaultValue: BorderRadius.circular(theme.radiusLg),
      themeValue: compTheme?.borderRadius,
    );
    return TabContainer(
      selected: index,
      onSelect: onChanged,
      builder: (context, children) {
        return Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: borderRadius is BorderRadius
                ? borderRadius
                : borderRadius.resolve(Directionality.of(context)),
          ),
          padding: containerPadding,
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: expand
                  ? children.map((e) => Expanded(child: e)).toList()
                  : children,
            ).muted(),
          ),
        );
      },
      childBuilder: _childBuilder,
      children: children,
    );
  }
}
