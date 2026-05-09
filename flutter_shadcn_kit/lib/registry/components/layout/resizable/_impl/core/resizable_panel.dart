// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../resizable.dart';

/// ResizablePanel defines a reusable type for this registry module.
class ResizablePanel extends StatefulWidget {
  /// Default builder for dividers between resizable panes.
  ///
  /// Creates appropriate divider widgets based on the panel orientation:
  /// - Horizontal panels get vertical dividers
  /// - Vertical panels get horizontal dividers
  ///
  /// This is the default value for [dividerBuilder] when none is specified.
  static Widget? defaultDividerBuilder(BuildContext context) {
    final data = Data.of<ResizableData>(context);
    if (data.direction == Axis.horizontal) {
      return const VerticalDivider();
    } else {
      return const Divider();
    }
  }

  /// Default builder for interactive drag handles between resizable panes.
  ///
  /// Creates appropriate dragger widgets based on the panel orientation:
  /// - Horizontal panels get vertical draggers
  /// - Vertical panels get horizontal draggers
  ///
  /// This is the default value for [draggerBuilder] when none is specified.
  static Widget? defaultDraggerBuilder(BuildContext context) {
    final data = Data.of<ResizableData>(context);
    if (data.direction == Axis.horizontal) {
      return const VerticalResizableDragger();
    } else {
      return const HorizontalResizableDragger();
    }
  }

  /// The axis along which the panels are arranged and can be resized.
  ///
  /// When [Axis.horizontal], panels are arranged left-to-right with vertical
  /// dividers between them. When [Axis.vertical], panels are arranged
  /// top-to-bottom with horizontal dividers between them.
  final Axis direction;

  /// The list of resizable panes that make up this panel.
  ///
  /// Each pane can specify its own sizing constraints, default size, and
  /// collapse behavior. At least two panes are typically needed to create
  /// a meaningful resizable interface.
  final List<ResizablePane> children;

  /// Optional builder for creating divider widgets between panes.
  ///
  /// Called to create the visual separator between adjacent panes. If null,
  /// uses [defaultDividerBuilder] to create appropriate dividers based on
  /// the panel orientation.
  final OptionalWidgetBuilder? dividerBuilder;

  /// Optional builder for creating interactive drag handles between panes.
  ///
  /// Called to create draggable resize handles between adjacent panes. These
  /// handles allow users to adjust pane sizes. If null, no drag handles are
  /// displayed but dividers may still be present if [dividerBuilder] is set.
  final OptionalWidgetBuilder? draggerBuilder;

  /// The thickness of the draggable area between panes.
  ///
  /// Controls the size of the interactive region for resizing. A larger value
  /// makes it easier to grab and drag the resize handles, while a smaller
  /// value provides a more compact appearance.
  final double? draggerThickness;

  /// Hides the divider when not hovered or being dragged.
  final bool optionalDivider;

  /// Creates a horizontal resizable panel with panes arranged left-to-right.
  ///
  /// This is a convenience constructor that sets [direction] to [Axis.horizontal]
  /// and provides default builders for dividers and draggers appropriate for
  /// horizontal layouts.
  ///
  /// Parameters:
  /// - [children] (`List<ResizablePane>`, required): The panes to arrange horizontally
  /// - [dividerBuilder] (OptionalWidgetBuilder?, optional): Custom divider builder
  /// - [draggerBuilder] (OptionalWidgetBuilder?, optional): Custom dragger builder
  /// - [draggerThickness] (double?, optional): Size of the draggable resize area
  ///
  /// Example:
  /// ```dart
  /// ResizablePanel.horizontal(
  ///   children: [
  ///     ResizablePane(child: LeftSidebar(), defaultSize: 200),
  ///     ResizablePane(child: MainContent(), flex: 1),
  ///     ResizablePane(child: RightPanel(), defaultSize: 150),
  ///   ],
  /// );
  /// ```
  const ResizablePanel.horizontal({
    super.key,
    required this.children,
    this.dividerBuilder = defaultDividerBuilder,
    this.draggerBuilder,
    this.draggerThickness,
    this.optionalDivider = false,
  }) : direction = Axis.horizontal;

  /// Creates a vertical resizable panel with panes arranged top-to-bottom.
  ///
  /// This is a convenience constructor that sets [direction] to [Axis.vertical]
  /// and provides default builders for dividers and draggers appropriate for
  /// vertical layouts.
  ///
  /// Parameters:
  /// - [children] (`List<ResizablePane>`, required): The panes to arrange vertically
  /// - [dividerBuilder] (OptionalWidgetBuilder?, optional): Custom divider builder
  /// - [draggerBuilder] (OptionalWidgetBuilder?, optional): Custom dragger builder
  /// - [draggerThickness] (double?, optional): Size of the draggable resize area
  ///
  /// Example:
  /// ```dart
  /// ResizablePanel.vertical(
  ///   children: [
  ///     ResizablePane(child: Header(), defaultSize: 60),
  ///     ResizablePane(child: Content(), flex: 1),
  ///     ResizablePane(child: Footer(), defaultSize: 40),
  ///   ],
  /// );
  /// ```
  const ResizablePanel.vertical({
    super.key,
    required this.children,
    this.dividerBuilder = defaultDividerBuilder,
    this.draggerBuilder,
    this.draggerThickness,
    this.optionalDivider = false,
  }) : direction = Axis.vertical;

  /// Creates a resizable panel with the specified direction and configuration.
  ///
  /// This is the general constructor that allows full customization of the
  /// panel orientation and behavior. Use the convenience constructors
  /// [ResizablePanel.horizontal] and [ResizablePanel.vertical] for typical use cases.
  ///
  /// Parameters:
  /// - [direction] (Axis, required): The axis along which panes are arranged
  /// - [children] (`List<ResizablePane>`, required): The panes to arrange
  /// - [dividerBuilder] (OptionalWidgetBuilder?, optional): Custom divider builder
  /// - [draggerBuilder] (OptionalWidgetBuilder?, optional): Custom dragger builder
  /// - [draggerThickness] (double?, optional): Size of the draggable resize area
  ///
  /// Example:
  /// ```dart
  /// ResizablePanel(
  ///   direction: Axis.horizontal,
  ///   draggerThickness: 8.0,
  ///   children: [...],
  ///   draggerBuilder: (context) => CustomDragger(),
  /// );
  /// ```
  const ResizablePanel({
    super.key,
    required this.direction,
    required this.children,
    this.dividerBuilder = defaultDividerBuilder,
    this.draggerBuilder,
    this.draggerThickness,
    this.optionalDivider = false,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<ResizablePanel> createState() => _ResizablePanelState();
}
