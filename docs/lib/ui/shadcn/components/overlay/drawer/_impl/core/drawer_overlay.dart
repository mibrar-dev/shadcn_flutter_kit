// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// DrawerOverlay defines a reusable type for this registry module.
class DrawerOverlay extends StatefulWidget {
  /// Stores `_currentLayer` state/configuration for this implementation.
  static DrawerLayerData? _currentLayer;

  /// Executes `_registerLayer` behavior for this component/composite.
  static void _registerLayer(DrawerLayerData layer) {
    _currentLayer = layer;
  }

  /// Executes `_clearLayer` behavior for this component/composite.
  static void _clearLayer(DrawerLayerData layer) {
    if (_currentLayer == layer) {
      _currentLayer = layer.parent;
    }
  }

  /// Stores `currentLayer` state/configuration for this implementation.
  static DrawerLayerData? get currentLayer => _currentLayer;

  /// Child widget displayed under the overlay layer.
  final Widget child;

  /// Creates a drawer overlay.
  ///
  /// Parameters:
  /// - [child] (Widget, required): Content widget
  const DrawerOverlay({super.key, required this.child});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<DrawerOverlay> createState() => DrawerOverlayState();

  /// Finds the drawer layer data from the widget tree.
  ///
  /// Searches up the widget tree for the nearest [DrawerLayerData].
  /// Optionally navigates to the root layer if [root] is true.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context
  /// - [root] (bool): Whether to find root layer, defaults to false
  ///
  /// Returns [DrawerLayerData] or null if not found.
  static DrawerLayerData? maybeFind(BuildContext context, [bool root = false]) {
    var data = Data.maybeFind<DrawerLayerData>(context);
    if (root) {
      while (data?.parent != null) {
        data = data!.parent;
      }
    }
    return data;
  }

  /// Finds the drawer layer data using messenger lookup.
  ///
  /// Similar to [maybeFind] but uses the messenger mechanism for lookup.
  /// Optionally navigates to the root layer if [root] is true.
  ///
  /// Parameters:
  /// - [context] (BuildContext, required): Build context
  /// - [root] (bool): Whether to find root layer, defaults to false
  ///
  /// Returns [DrawerLayerData] or null if not found.
  static DrawerLayerData? maybeFindMessenger(
    BuildContext context, [
    bool root = false,
  ]) {
    var data = Data.maybeFindMessenger<DrawerLayerData>(context);
    if (root) {
      while (data?.parent != null) {
        data = data!.parent;
      }
    }
    return data;
  }
}

/// State class for [DrawerOverlay] managing drawer entry lifecycle.
///
/// Manages the stack of active drawer overlays, handling their addition,
/// removal, and size computation. Maintains a backdrop key for managing
/// backdrop transformations.
