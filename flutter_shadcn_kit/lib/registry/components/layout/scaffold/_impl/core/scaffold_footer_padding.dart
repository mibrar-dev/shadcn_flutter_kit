// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../scaffold.dart';

/// ScaffoldFooterPadding defines a reusable type for this registry module.
class ScaffoldFooterPadding extends SingleChildRenderObjectWidget {
  /// Creates [ScaffoldFooterPadding].
  const ScaffoldFooterPadding({super.key, super.child});

  @override
  /// Executes `createRenderObject` behavior for this component/composite.
  RenderObject createRenderObject(BuildContext context) {
    return _RenderScaffoldPadding(paddingType: _ScaffoldPaddingType.footer);
  }
}
