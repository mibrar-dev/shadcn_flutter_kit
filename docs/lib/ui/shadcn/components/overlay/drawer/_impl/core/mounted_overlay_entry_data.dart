// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// _MountedOverlayEntryData defines a reusable type for this registry module.
class _MountedOverlayEntryData {
  /// Stores `state` state/configuration for this implementation.
  final DrawerEntryWidgetState state;

  _MountedOverlayEntryData(this.state);
}

/// Closes the currently open drawer overlay.
///
/// Dismisses the active drawer from the overlay stack. Optionally returns
/// a result value to the code that opened the drawer.
///
/// Parameters:
/// - [context] (`BuildContext`, required): Build context from within the drawer.
/// - [result] (`T?`, optional): Optional result to return.
///
/// Returns: `Future<void>` that completes when drawer is closed.
