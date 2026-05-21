// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../drawer.dart';

/// SheetWrapper defines a reusable type for this registry module.
class SheetWrapper extends DrawerWrapper {
  /// Creates a [SheetWrapper].
  const SheetWrapper({
    super.key,
    required super.position,
    required super.child,
    required super.size,
    required super.stackIndex,
    super.draggable = false,
    super.expands = false,
    super.extraSize = Size.zero,
    super.padding,
    super.surfaceBlur,
    super.surfaceOpacity,
    super.barrierColor,
    super.gapBeforeDragger,
    super.gapAfterDragger,
    super.constraints,
    super.alignment,
  });

  @override
  /// Executes `createState` behavior for this component/composite.
  State<DrawerWrapper> createState() => _SheetWrapperState();
}
