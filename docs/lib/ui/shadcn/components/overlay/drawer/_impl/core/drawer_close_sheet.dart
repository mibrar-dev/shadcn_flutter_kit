// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// Executes `closeSheet` behavior for this component/composite.
Future<void> closeSheet(BuildContext context) {
  // sheet is just a drawer with no backdrop transformation
  return closeDrawer(context);
}

/// Wrapper widget for sheet overlays.
///
/// Extends [DrawerWrapper] with sheet-specific defaults (no drag, no expansion).
/// Sheets are simplified drawers without backdrop transformation.
