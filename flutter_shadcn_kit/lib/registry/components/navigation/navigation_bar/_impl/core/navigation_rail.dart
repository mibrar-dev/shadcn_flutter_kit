// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../navigation_bar.dart';

/// NavigationRail defines a reusable type for this registry module.
class NavigationRail extends StatefulWidget {
  /// Background color for the navigation rail surface.
  ///
  /// When null, uses the theme's default surface color. The background
  /// provides visual separation from surrounding content and establishes
  /// the rail as a distinct navigation area.
  final Color? backgroundColor;

  /// List of navigation items to display in the rail.
  ///
  /// Each item should be a [NavigationBarItem] that defines the icon,
  /// label, and optional badge for a navigation destination. Items are
  /// arranged according to the specified direction and alignment.
  final List<NavigationBarItem> children;

  /// Alignment of items within the rail's main axis.
  ///
  /// Controls how navigation items are distributed along the rail's
  /// primary direction (vertical or horizontal). Options include
  /// start, center, and end alignment.
  final NavigationRailAlignment alignment;

  /// Primary layout direction for the navigation rail.
  ///
  /// Determines whether items are arranged vertically (sidebar style)
  /// or horizontally (toolbar style). Affects item spacing and label positioning.
  final Axis direction;

  /// Spacing between navigation items.
  ///
  /// Controls the gap between adjacent navigation items. When null,
  /// uses theme-appropriate default spacing based on direction and size.
  final double? spacing;

  /// Label display behavior for navigation items.
  ///
  /// Controls when and how labels are shown: always visible, only for
  /// selected items, or never displayed. Affects the rail's width and
  /// visual density.
  final NavigationLabelType labelType;

  /// Position of labels relative to icons.
  ///
  /// Determines whether labels appear below, above, or beside icons.
  /// The positioning adapts based on the rail's direction and available space.
  final NavigationLabelPosition labelPosition;

  /// Size variant for label text and overall item dimensions.
  ///
  /// Controls the scale of text and spacing within navigation items.
  /// Smaller sizes create more compact navigation, while larger sizes
  /// improve accessibility and visual prominence.
  final NavigationLabelSize labelSize;

  /// Internal padding applied within the navigation rail.
  ///
  /// Provides space around the navigation items, creating visual breathing
  /// room and preventing items from touching the rail's edges.
  final EdgeInsetsGeometry? padding;

  /// Size constraints for the navigation rail container.
  ///
  /// Defines minimum and maximum width/height bounds for the rail.
  /// Useful for responsive layouts and ensuring consistent sizing.
  final BoxConstraints? constraints;

  /// Index of the currently selected navigation item.
  ///
  /// Highlights the corresponding item and affects label display based
  /// on the [labelType] setting. When null, no item is selected.
  final int? index;

  /// Callback invoked when a navigation item is selected.
  ///
  /// Called with the index of the tapped item. Use this to update
  /// the selected index and navigate to the corresponding destination.
  final ValueChanged<int>? onSelected;

  /// Opacity level for surface background effects.
  ///
  /// Controls transparency of background blur and overlay effects.
  /// Values range from 0.0 (transparent) to 1.0 (opaque).
  final double? surfaceOpacity;

  /// Blur intensity for surface background effects.
  ///
  /// Controls the backdrop blur effect behind the navigation rail.
  /// Higher values create more pronounced blur effects.
  final double? surfaceBlur;

  /// Whether the rail should expand to fill available space.
  ///
  /// When true, the rail attempts to use all available space in its
  /// cross-axis direction. When false, the rail sizes itself to content.
  final bool expanded;

  /// Whether to maintain intrinsic size along the main axis.
  ///
  /// Controls how the rail handles sizing when its main axis dimension
  /// is unconstrained. Affects layout behavior in flexible containers.
  final bool keepMainAxisSize;

  /// Whether to maintain intrinsic size along the cross axis.
  ///
  /// Controls how the rail handles sizing when its cross axis dimension
  /// is unconstrained. Useful for preventing unwanted expansion.
  final bool keepCrossAxisSize;

  /// Creates a [NavigationRail] with the specified configuration and items.
  ///
  /// The [children] parameter is required and should contain [NavigationBarItem]
  /// widgets that define the navigation destinations. Other parameters control
  /// the rail's appearance, behavior, and layout characteristics.
  ///
  /// Default values provide a sensible vertical rail configuration suitable
  /// for most sidebar navigation scenarios. Customization allows adaptation
  /// to specific layout requirements and design systems.
  ///
  /// Parameters:
  /// - [children] (`List<NavigationBarItem>`, required): Navigation destinations
  /// - [alignment] (NavigationRailAlignment, default: center): Item alignment along main axis
  /// - [direction] (Axis, default: vertical): Layout orientation of the rail
  /// - [labelType] (NavigationLabelType, default: selected): When to show labels
  /// - [labelPosition] (NavigationLabelPosition, default: bottom): Label positioning
  /// - [index] (int?, optional): Currently selected item index
  /// - [onSelected] (`ValueChanged<int>?`, optional): Selection change callback
  ///
  /// Example:
  /// ```dart
  /// NavigationRail(
  ///   alignment: NavigationRailAlignment.start,
  ///   labelType: NavigationLabelType.all,
  ///   index: currentIndex,
  ///   onSelected: (index) => _navigate(index),
  ///   children: navigationItems,
  /// )
  /// ```
  const NavigationRail({
    super.key,
    this.backgroundColor,
    this.alignment = NavigationRailAlignment.center,
    this.direction = Axis.vertical,
    this.spacing,
    this.labelType = NavigationLabelType.selected,
    this.labelPosition = NavigationLabelPosition.bottom,
    this.labelSize = NavigationLabelSize.small,
    this.padding,
    this.constraints,
    this.index,
    this.onSelected,
    this.surfaceOpacity,
    this.surfaceBlur,
    this.expanded = true,
    this.keepMainAxisSize = false,
    this.keepCrossAxisSize = false,
    required this.children,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<NavigationRail> createState() => _NavigationRailState();
}
