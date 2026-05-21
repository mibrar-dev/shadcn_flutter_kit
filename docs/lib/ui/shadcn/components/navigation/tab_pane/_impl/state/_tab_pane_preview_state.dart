// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _TabPanePreviewState defines a reusable type for this registry module.
class _TabPanePreviewState extends State<TabPanePreview> {
  /// Stores `_focused` state/configuration for this implementation.
  int _focused = 0;
  late final List<TabPaneData<String>> _items = [
    /// Creates a `TabPaneData` instance.
    const TabPaneData('Overview'),

    /// Creates a `TabPaneData` instance.
    const TabPaneData('Analytics'),

    /// Creates a `TabPaneData` instance.
    const TabPaneData('Settings'),
  ];

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 420,
          child: TabPane<String>(
            items: _items,
            focused: _focused,
            onFocused: (index) => setState(() => _focused = index),
            itemBuilder: (context, item, index) {
              return TabChildWidget(indexed: true, child: Text(item.data));
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Content: ${_items[_focused].data}'),
            ),
          ),
        ),
      ),
    );
  }
}
