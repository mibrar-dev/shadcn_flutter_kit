// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../eye_dropper.dart';

/// EyeDropperLayerScope defines a reusable type for this registry module.
abstract class EyeDropperLayerScope {
  /// Prompts the user to pick a color from the screen.
  ///
  /// Parameters:
  /// - [historyStorage]: Optional storage for color picking history.
  ///
  /// Returns: A [Future] that completes with the picked color, or null if cancelled.
  Future<Color?> promptPickColor([ColorHistoryStorage? historyStorage]);

  /// Finds the root [EyeDropperLayerScope] in the widget tree.
  ///
  /// Searches up the tree to find the topmost eye dropper scope.
  static EyeDropperLayerScope findRoot(BuildContext context) {
    return Data.maybeFindRoot<EyeDropperLayerScope>(context) ??
        Data.maybeFindMessenger<EyeDropperLayerScope>(context) ??
        (throw FlutterError(
          'No EyeDropperLayerScope found in context. Make sure to wrap your widget tree with an EyeDropperLayer.',
        ));
  }

  /// Finds the nearest [EyeDropperLayerScope] in the widget tree.
  ///
  /// Searches up the tree to find the closest eye dropper scope.
  static EyeDropperLayerScope find(BuildContext context) {
    return Data.maybeFind<EyeDropperLayerScope>(context) ??
        Data.maybeFindMessenger<EyeDropperLayerScope>(context) ??
        (throw FlutterError(
          'No EyeDropperLayerScope found in context. Make sure to wrap your widget tree with an EyeDropperLayer.',
        ));
  }
}

/// Represents the result of an eye dropper color picking operation.
///
/// [EyeDropperResult] contains the picked color along with all colors
/// captured in the sampling area. This allows for accessing individual
/// pixels from the captured region.
