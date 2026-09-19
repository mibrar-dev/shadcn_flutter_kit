// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationSidebar defines a reusable type for this registry module.
class NavigationSidebar extends StatefulWidget {
  /// Background color for the navigation sidebar surface.
  ///
  /// Sets the sidebar's background color to provide visual separation
  /// from content areas. When null, uses the theme's default surface color.
  final Color? backgroundColor;

  /// List of navigation items to display in the sidebar.
  ///
  /// Each item should be a [NavigationBarItem] that defines the navigation
  /// destination with icon, label, and optional badge. Items are arranged
  /// vertically with full-width presentation.
  final List<NavigationBarItem> children;

  /// Spacing between navigation items.
  ///
  /// Controls the vertical gap between adjacent navigation items.
  /// Larger values create more breathing room in the navigation list.
  final double? spacing;

  /// Label display behavior for navigation items.
  ///
  /// Determines how labels are presented in the sidebar. Sidebars typically
  /// use expanded label types to show comprehensive navigation information.
  final NavigationLabelType labelType;

  /// Position of labels relative to icons within items.
  ///
  /// Controls label placement within each navigation item. Sidebars
  /// commonly position labels to the end (right in LTR layouts) of icons.
  final NavigationLabelPosition labelPosition;

  /// Size variant for label text and item dimensions.
  ///
  /// Affects text size and overall item scale. Larger sizes improve
  /// accessibility and visual prominence in sidebar contexts.
  final NavigationLabelSize labelSize;

  /// Internal padding applied within the navigation sidebar.
  ///
  /// Provides space around navigation items, preventing them from
  /// touching the sidebar's edges and creating visual comfort.
  final EdgeInsetsGeometry? padding;

  /// Size constraints for the navigation sidebar container.
  ///
  /// Defines width and height bounds for the sidebar. Useful for
  /// responsive layouts and consistent sidebar sizing.
  final BoxConstraints? constraints;

  /// Index of the currently selected navigation item.
  ///
  /// Legacy index-based selection. When [selectedKey] is non-null, key-based
  /// selection takes precedence (upstream parity).
  final int? index;

  /// Currently selected item key (upstream parity).
  ///
  /// When non-null, takes precedence over [index]. Matches `widget.key`
  /// of the selected child.
  final Key? selectedKey;

  /// Callback invoked when a navigation item is selected.
  ///
  /// Called with the index of the selected item. Use this to update
  /// the selection state and handle navigation actions.
  final ValueChanged<int>? onSelected;

  /// Callback invoked with the key of the selected item (upstream parity).
  final ValueChanged<Key?>? onSelectedKey;

  /// Opacity level for surface background effects.
  ///
  /// Controls transparency of background overlays and blur effects.
  /// Values range from 0.0 (transparent) to 1.0 (opaque).
  final double? surfaceOpacity;

  /// Blur intensity for surface background effects.
  ///
  /// Controls backdrop blur effects behind the sidebar surface.
  /// Higher values create more pronounced blur effects.
  final double? surfaceBlur;

  /// Whether the sidebar should expand to fill available width.
  ///
  /// When true, the sidebar uses all available horizontal space.
  /// When false, the sidebar sizes itself to its content width.
  final bool expanded;

  /// Whether to maintain intrinsic size along the cross axis.
  ///
  /// Controls width sizing behavior when the sidebar's width
  /// constraints are unconstrained.
  final bool keepCrossAxisSize;

  /// Whether to maintain intrinsic size along the main axis.
  ///
  /// Controls height sizing behavior when the sidebar's height
  /// constraints are unconstrained.
  final bool keepMainAxisSize;

  /// Optional fixed header items displayed before the scrollable content
  /// (upstream parity).
  final List<Widget>? header;

  /// Optional fixed footer items displayed after the scrollable content
  /// (upstream parity).
  final List<Widget>? footer;

  /// Creates a [NavigationSidebar] with the specified configuration and items.
  ///
  /// The [children] parameter is required and should contain [NavigationBarItem]
  /// widgets that define the navigation destinations. Default values are
  /// optimized for sidebar presentation with expanded labels and large sizing.
  ///
  /// The sidebar defaults to expanded label presentation with large sizing
  /// and end-positioned labels, creating a comprehensive navigation experience
  /// suitable for desktop and tablet interfaces.
  ///
  /// Parameters:
  /// - [children] (`List<NavigationBarItem>`, required): Navigation destinations
  /// - [labelType] (NavigationLabelType, default: expanded): Label display behavior
  /// - [labelPosition] (NavigationLabelPosition, default: end): Label positioning
  /// - [labelSize] (NavigationLabelSize, default: large): Size variant for items
  /// - [index] (int?, optional): Currently selected item index
  /// - [onSelected] (`ValueChanged<int>?`, optional): Selection change callback
  /// - [expanded] (bool, default: true): Whether to fill available width
  ///
  /// Example:
  /// ```dart
  /// NavigationSidebar(
  ///   backgroundColor: Theme.of(context).colorScheme.surface,
  ///   index: selectedIndex,
  ///   onSelected: (index) => _handleNavigation(index),
  ///   children: sidebarItems,
  /// )
  /// ```
  const NavigationSidebar({
    super.key,
    this.backgroundColor,
    this.spacing,
    this.labelType = NavigationLabelType.expanded,
    this.labelPosition = NavigationLabelPosition.end,
    this.labelSize = NavigationLabelSize.large,
    this.padding,
    this.constraints,
    this.index,
    this.selectedKey,
    this.onSelected,
    this.onSelectedKey,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.expanded = true,
    this.keepCrossAxisSize = false,
    this.keepMainAxisSize = false,
    this.header,
    this.footer,
    required this.children,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<NavigationSidebar> createState() => _NavigationSidebarState();
}
