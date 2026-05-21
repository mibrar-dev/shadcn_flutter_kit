// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _TabContainerPreviewState defines a reusable type for this registry module.
class _TabContainerPreviewState extends State<TabContainerPreview> {
  /// Stores `_selected` state/configuration for this implementation.
  int _selected = 0;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: TabContainer(
            selected: _selected,
            onSelect: (index) => setState(() => _selected = index),
            builder: (context, children) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Creates a `Row` instance.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children,
                  ),

                  /// Creates a `SizedBox` instance.
                  const SizedBox(height: 16),

                  /// Creates a `Text` instance.
                  Text('Selected tab: ${_selected + 1}'),
                ],
              );
            },
            childBuilder: (context, data, child) {
              /// Stores `selected` state/configuration for this implementation.
              final selected = data.selected == data.index;
              return GestureDetector(
                onTap: () => data.onSelect?.call(data.index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    child: child,
                  ),
                ),
              );
            },
            children: const [
              /// Creates a `TabItem` instance.
              TabItem(child: Text('Overview')),

              /// Creates a `TabItem` instance.
              TabItem(child: Text('Details')),

              /// Creates a `TabItem` instance.
              TabItem(child: Text('Reviews')),
            ],
          ),
        ),
      ),
    );
  }
}
