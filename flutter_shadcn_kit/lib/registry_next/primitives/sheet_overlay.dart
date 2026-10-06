// Minimal sheet-overlay context helper.
//
// Ported from `shared/primitives/sheet_overlay.dart`. The old implementation
// read a `Model` key (`#shadcn_flutter_sheet_overlay`); data_widget's Model
// family was not ported to foundation, so the marker is now a dedicated type
// provided with `Data<SheetOverlayMarker>.inherit`. The future `drawer`
// component wraps its sheet content in that provider.

import 'package:flutter/widgets.dart';

import '../foundation/data.dart';

/// Marker type provided above the content of a sheet overlay.
class SheetOverlayMarker {
  /// Creates a sheet overlay marker.
  const SheetOverlayMarker();
}

/// Helpers for sheet overlays.
class SheetOverlayHandler {
  /// Creates a [SheetOverlayHandler].
  const SheetOverlayHandler();

  /// Whether [context] is inside a sheet overlay.
  static bool isSheetOverlay(BuildContext context) {
    return Data.maybeOf<SheetOverlayMarker>(context) != null;
  }
}
