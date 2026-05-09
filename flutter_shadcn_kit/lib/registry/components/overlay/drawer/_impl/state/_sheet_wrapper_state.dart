// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// _SheetWrapperState defines a reusable type for this registry module.
class _SheetWrapperState extends _DrawerWrapperState {
  @override
  /// Executes `getBorder` behavior for this component/composite.
  Border getBorder(ThemeData theme) {
    switch (resolvedPosition) {
      case OverlayPosition.left:
        return Border(right: BorderSide(color: theme.colorScheme.border));
      case OverlayPosition.right:
        return Border(left: BorderSide(color: theme.colorScheme.border));
      case OverlayPosition.top:
        return Border(bottom: BorderSide(color: theme.colorScheme.border));
      case OverlayPosition.bottom:
        return Border(top: BorderSide(color: theme.colorScheme.border));
      default:
        throw UnimplementedError('Unknown position');
    }
  }

  @override
  /// Executes `buildMargin` behavior for this component/composite.
  EdgeInsets buildMargin(BuildContext context) {
    var mediaPadding = MediaQuery.paddingOf(context);

    /// Stores `marginTop` state/configuration for this implementation.
    double marginTop = 0;

    /// Stores `marginBottom` state/configuration for this implementation.
    double marginBottom = 0;

    /// Stores `marginLeft` state/configuration for this implementation.
    double marginLeft = 0;

    /// Stores `marginRight` state/configuration for this implementation.
    double marginRight = 0;
    switch (resolvedPosition) {
      case OverlayPosition.left:
        marginRight = mediaPadding.right;
        break;
      case OverlayPosition.right:
        marginLeft = mediaPadding.left;
        break;
      case OverlayPosition.top:
        marginBottom = mediaPadding.bottom;
        break;
      case OverlayPosition.bottom:
        marginTop = mediaPadding.top;
        break;
      default:
        throw UnimplementedError('Unknown position');
    }
    return super.buildMargin(context) +
        /// Creates a `EdgeInsets.only` instance.
        EdgeInsets.only(
          top: marginTop,
          bottom: marginBottom,
          left: marginLeft,
          right: marginRight,
        );
  }

  @override
  /// Executes `buildChild` behavior for this component/composite.
  Widget buildChild(BuildContext context) {
    var mediaPadding = MediaQuery.paddingOf(context);

    /// Stores `paddingTop` state/configuration for this implementation.
    double paddingTop = 0;

    /// Stores `paddingBottom` state/configuration for this implementation.
    double paddingBottom = 0;

    /// Stores `paddingLeft` state/configuration for this implementation.
    double paddingLeft = 0;

    /// Stores `paddingRight` state/configuration for this implementation.
    double paddingRight = 0;
    switch (resolvedPosition) {
      case OverlayPosition.left:
        paddingTop = mediaPadding.top;
        paddingBottom = mediaPadding.bottom;
        paddingLeft = mediaPadding.left;
        break;
      case OverlayPosition.right:
        paddingTop = mediaPadding.top;
        paddingBottom = mediaPadding.bottom;
        paddingRight = mediaPadding.right;
        break;
      case OverlayPosition.top:
        paddingLeft = mediaPadding.left;
        paddingRight = mediaPadding.right;
        paddingTop = mediaPadding.top;
        break;
      case OverlayPosition.bottom:
        paddingLeft = mediaPadding.left;
        paddingRight = mediaPadding.right;
        paddingBottom = mediaPadding.bottom;
        break;
      default:
        throw UnimplementedError('Unknown position');
    }
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        bottom: paddingBottom,
        left: paddingLeft,
        right: paddingRight,
      ),
      child: super.buildChild(context),
    );
  }

  @override
  /// Executes `getBorderRadius` behavior for this component/composite.
  BorderRadiusGeometry getBorderRadius(double radius) {
    return BorderRadius.zero;
  }

  @override
  /// Executes `getDecoration` behavior for this component/composite.
  BoxDecoration getDecoration(ThemeData theme) {
    /// Stores `backgroundColor` state/configuration for this implementation.
    var backgroundColor = theme.colorScheme.background;

    /// Stores `surfaceOpacity` state/configuration for this implementation.
    var surfaceOpacity = widget.surfaceOpacity ?? theme.surfaceOpacity;
    if (surfaceOpacity != null && surfaceOpacity < 1) {
      if (widget.stackIndex == 0) {
        // the top sheet should have a higher opacity to prevent
        // visual bleeding from the main content
        surfaceOpacity = surfaceOpacity * 1.25;
      }
      backgroundColor = backgroundColor.scaleAlpha(surfaceOpacity);
    }
    return BoxDecoration(color: backgroundColor, border: getBorder(theme));
  }
}

/// Position for overlay components like drawers and sheets.
