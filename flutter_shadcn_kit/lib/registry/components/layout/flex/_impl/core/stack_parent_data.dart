// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../flex.dart';

/// Parent data used by patched [RenderStack].
class StackParentData extends rendering.StackParentData
    with PaintOrderParentDataMixin {
  @override
  /// Executes `toString` behavior for this component/composite.
  String toString() => '${super.toString()}; paintOrder=$paintOrder';
}
