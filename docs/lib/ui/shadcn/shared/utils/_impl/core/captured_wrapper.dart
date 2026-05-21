// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../util.dart';

/// CapturedWrapper defines a reusable type for this registry module.
class CapturedWrapper extends StatefulWidget {
  /// Stores `themes` state/configuration for this implementation.
  final CapturedThemes? themes;

  /// Stores `data` state/configuration for this implementation.
  final CapturedData? data;

  /// Stores `child` state/configuration for this implementation.
  final Widget child;

  /// Creates a `CapturedWrapper` instance.
  const CapturedWrapper({
    super.key,
    this.themes,
    this.data,
    required this.child,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<CapturedWrapper> createState() => _CapturedWrapperState();
}
