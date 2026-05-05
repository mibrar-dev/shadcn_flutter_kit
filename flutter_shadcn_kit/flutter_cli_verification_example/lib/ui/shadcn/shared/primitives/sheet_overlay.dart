import 'package:data_widget/data_widget.dart';
import 'package:flutter/widgets.dart';

/// Minimal helper for checking sheet overlay context.
class SheetOverlayHandler {
  /// Returns true when the widget tree is inside a sheet overlay.
  static bool isSheetOverlay(BuildContext context) {
    return Model.maybeOf<bool>(context, #shadcn_flutter_sheet_overlay) == true;
  }
}
