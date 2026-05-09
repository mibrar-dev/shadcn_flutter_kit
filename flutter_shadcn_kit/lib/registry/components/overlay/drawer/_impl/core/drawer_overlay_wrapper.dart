// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// _DrawerOverlayWrapper defines a reusable type for this registry module.
class _DrawerOverlayWrapper extends StatefulWidget {
  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Stores `completer` state/configuration for this implementation.
  final Completer completer;
  const _DrawerOverlayWrapper({required this.child, required this.completer});

  @override
  /// Executes `createState` behavior for this component/composite.
  State<_DrawerOverlayWrapper> createState() => _DrawerOverlayWrapperState();
}
