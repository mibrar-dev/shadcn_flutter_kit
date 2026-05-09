// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../tabs.dart';

/// TabItem defines a reusable type for this registry module.
class TabItem extends StatelessWidget with TabChild {
  /// Content widget for this tab.
  final Widget child;

  /// Creates a [TabItem].
  ///
  /// Parameters:
  /// - [child] (`Widget`, required): content to display in this tab
  const TabItem({super.key, required this.child});

  @override
  /// Stores `indexed` state/configuration for this implementation.
  bool get indexed => true;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    TabContainerData data = TabContainerData.of(context);
    return data.childBuilder(context, data, child);
  }
}

/// A keyed tab item widget.
///
/// Similar to [TabItem] but includes a unique key for identification.
