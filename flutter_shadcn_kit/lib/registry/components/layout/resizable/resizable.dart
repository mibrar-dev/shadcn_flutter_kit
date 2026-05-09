// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

import 'dart:math';

import 'package:data_widget/data_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Divider, VerticalDivider;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../shared/icons/radix_icons.dart';
import '../../../shared/theme/theme.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/utils/resizable_item.dart';
import '../../../shared/utils/resizer.dart';
import '../../../shared/utils/style_value.dart';
part '_impl/core/_resizable_layout.dart';
part '_impl/core/_resizable_layout_child.dart';
part '_impl/core/_resizable_layout_parent_data.dart';
part '_impl/state/_resizer_state.dart';
part '_impl/core/_resizer.dart';
part '_impl/core/resizable_data.dart';
part '_impl/state/_resizable_panel_state.dart';
part '_impl/core/_resizable_item.dart';
part '_impl/core/resizable_panel.dart';
part '_impl/core/_resizable_panel_data.dart';
part '_impl/state/_resizable_pane_state.dart';
part '_impl/core/resizable_pane.dart';
part '_impl/utils/flexible_resizable_pane_controller.dart';
part '_impl/utils/absolute_resizable_pane_controller.dart';
part '_impl/core/vertical_resizable_dragger.dart';
part '_impl/core/horizontal_resizable_dragger.dart';
part '_impl/core/_render_resizable_layout.dart';

/// Theme for [HorizontalResizableDragger] and [VerticalResizableDragger].
class ResizableDraggerTheme extends ComponentThemeData {
  /// Background color of the dragger.
  final Color? color;

  /// Border radius of the dragger.
  final double? borderRadius;

  /// Width of the dragger.
  final double? width;

  /// Height of the dragger.
  final double? height;

  /// Icon size inside the dragger.
  final double? iconSize;

  /// Icon color inside the dragger.
  final Color? iconColor;

  /// Creates a [ResizableDraggerTheme].
  const ResizableDraggerTheme({
    super.themeDensity,
    super.themeSpacing,
    super.themeShadows,
    this.color,
    this.borderRadius,
    this.width,
    this.height,
    this.iconSize,
    this.iconColor,
  });

  /// Creates a copy of this theme with the given fields replaced.
  ResizableDraggerTheme copyWith({
    ValueGetter<Color?>? color,
    ValueGetter<double?>? borderRadius,
    ValueGetter<double?>? width,
    ValueGetter<double?>? height,
    ValueGetter<double?>? iconSize,
    ValueGetter<Color?>? iconColor,
  }) {
    return ResizableDraggerTheme(
      color: color == null ? this.color : color(),
      borderRadius: borderRadius == null ? this.borderRadius : borderRadius(),
      width: width == null ? this.width : width(),
      height: height == null ? this.height : height(),
      iconSize: iconSize == null ? this.iconSize : iconSize(),
      iconColor: iconColor == null ? this.iconColor : iconColor(),
    );
  }

  @override
  /// Executes `operator ==` behavior for this component/composite.
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResizableDraggerTheme &&
        other.color == color &&
        other.borderRadius == borderRadius &&
        other.width == width &&
        other.height == height &&
        other.iconSize == iconSize &&
        other.iconColor == iconColor;
  }

  @override
  int get hashCode =>
      Object.hash(color, borderRadius, width, height, iconSize, iconColor);
}

/// A Horizontal dragger that can be used as a divider between resizable panes.

/// A Vertical dragger that can be used as a divider between resizable panes.

/// Represents the position of a panel relative to another panel.
///
/// Used to specify which neighboring panel should be affected when
/// expanding or collapsing a resizable panel.
enum PanelSibling {
  /// The panel before (left/top) the current panel.
  before(-1),

  /// The panel after (right/bottom) the current panel.
  after(1),

  /// Both panels on either side of the current panel.
  both(0);

  /// Direction value used internally for calculations.
  final int direction;

  const PanelSibling(this.direction);
}

/// Mixin for controllers that manage resizable pane sizing.
///
/// Provides methods to resize, collapse, and expand panels programmatically.
/// Implementations include [AbsoluteResizablePaneController] for fixed sizes
/// and [FlexibleResizablePaneController] for flexible/proportional sizes.
mixin ResizablePaneController implements ValueListenable<double> {
  /// Resizes the controller to the given [newSize] within the [paneSize] bounds.
  void resize(double newSize, double paneSize);

  /// Collapses the panel to its minimum size.
  void collapse();

  /// Expands the panel to its maximum or default size.
  void expand();

  /// Computes the actual size based on [paneSize] and optional constraints.
  double computeSize(double paneSize, {double? minSize, double? maxSize});

  /// Whether the panel is currently collapsed.
  bool get collapsed;

  /// Attempts to expand by [size] pixels in the specified [direction].
  ///
  /// Returns `true` if successful, `false` if expansion was blocked.
  bool tryExpandSize(
    double size, [
    PanelSibling direction = PanelSibling.both,
  ]) {
    assert(_paneState != null, 'ResizablePaneController is not attached');
    return _paneState!.tryExpandSize(size, direction);
  }

  /// Attempts to expand the panel in the specified [direction].
  ///
  /// Returns `true` if successful, `false` if expansion was blocked.
  bool tryExpand([PanelSibling direction = PanelSibling.both]) {
    assert(_paneState != null, 'ResizablePaneController is not attached');
    return _paneState!.tryExpand(direction);
  }

  /// Attempts to collapse the panel in the specified [direction].
  ///
  /// Returns `true` if successful, `false` if collapse was blocked.
  bool tryCollapse([PanelSibling direction = PanelSibling.both]) {
    assert(_paneState != null, 'ResizablePaneController is not attached');
    return _paneState!.tryCollapse(direction);
  }

  _ResizablePaneState? _paneState;

  /// Executes `_attachPaneState` behavior for this component/composite.
  void _attachPaneState(_ResizablePaneState panelData) {
    _paneState = panelData;
  }

  /// Executes `_detachPaneState` behavior for this component/composite.
  void _detachPaneState(_ResizablePaneState panelData) {
    if (_paneState == panelData) {
      _paneState = null;
    }
  }
}

/// Controller for resizable panes with absolute (fixed) sizing.
///
/// Manages a panel with a specific pixel size that can be adjusted through
/// dragging or programmatic control. Size is maintained as an absolute value.
///
/// Example:
/// ```dart
/// final controller = AbsoluteResizablePaneController(200);
///
/// ResizablePane(
///   controller: controller,
///   child: Container(color: Colors.blue),
/// )
/// ```

/// Controller for resizable panes with flexible (proportional) sizing.
///
/// Manages a panel whose size is specified as a flex factor relative to
/// the total available space. Similar to Flutter's [Flexible] widget concept.
///
/// Example:
/// ```dart
/// final controller = FlexibleResizablePaneController(1.0);
///
/// ResizablePane(
///   controller: controller,
///   child: Container(color: Colors.red),
/// )
/// ```

/// A resizable panel that can be part of a [ResizablePanel] layout.
///
/// Represents a single pane in a resizable layout that can be resized by
/// dragging handles between panes. Supports absolute sizing, flex-based sizing,
/// and external controller management.
///
/// Three constructor variants:
/// - Default: Fixed absolute size in pixels
/// - [ResizablePane.flex]: Proportional flex-based sizing
/// - [ResizablePane.controlled]: Externally controlled via [ResizablePaneController]
///
/// Example:
/// ```dart
/// ResizablePanel(
///   children: [
///     ResizablePane(
///       initialSize: 200,
///       minSize: 100,
///       child: Container(color: Colors.blue),
///     ),
///     ResizablePane.flex(
///       initialFlex: 2,
///       child: Container(color: Colors.red),
///     ),
///   ],
/// )
/// ```

/// Builder function that optionally returns a widget.
///
/// Used for conditional widget building where a widget may or may not be created
/// based on runtime conditions.
typedef OptionalWidgetBuilder = Widget? Function(BuildContext context);

/// A container widget that creates resizable panels separated by interactive dividers.
///
/// This widget provides a flexible layout system where multiple child panes
/// can be resized by the user through draggable dividers. It supports both
/// horizontal and vertical orientations, allowing users to adjust the relative
/// sizes of the contained panels by dragging the separators between them.
///
/// Each [ResizablePane] child can have its own sizing constraints, minimum and
/// maximum sizes, and collapse behavior. The panel automatically manages the
/// distribution of available space and handles user interactions for resizing.
///
/// Example:
/// ```dart
/// ResizablePanel.horizontal(
///   children: [
///     ResizablePane(
///       child: Container(color: Colors.red),
///       minSize: 100,
///       defaultSize: 200,
///     ),
///     ResizablePane(
///       child: Container(color: Colors.blue),
///       flex: 1,
///     ),
///     ResizablePane(
///       child: Container(color: Colors.green),
///       defaultSize: 150,
///       maxSize: 300,
///     ),
///   ],
/// );
/// ```

// extends as ResizableItem, but adds nothing

/// Data class providing information about a resizable panel's orientation.
///
/// Used internally to pass layout direction information through the widget tree.

/// Type alias for `_ResizableLayoutCallback` used by public or internal APIs.
typedef _ResizableLayoutCallback =
    void Function(double panelSize, double flexCount);
