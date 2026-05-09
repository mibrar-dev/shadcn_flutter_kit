// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _TabListPreviewState defines a reusable type for this registry module.
class _TabListPreviewState extends State<TabListPreview> {
  /// Stores `_index` state/configuration for this implementation.
  int _index = 0;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Creates a `TabList` instance.
              TabList(
                index: _index,
                onChanged: (value) => setState(() => _index = value),
                children: const [
                  /// Creates a `TabChildWidget` instance.
                  TabChildWidget(indexed: true, child: Text('General')),

                  /// Creates a `TabChildWidget` instance.
                  TabChildWidget(indexed: true, child: Text('Billing')),

                  /// Creates a `TabChildWidget` instance.
                  TabChildWidget(indexed: true, child: Text('Security')),
                ],
              ),

              /// Creates a `SizedBox` instance.
              const SizedBox(height: 16),

              /// Creates a `Text` instance.
              Text('Active tab: ${_index + 1}'),
            ],
          ),
        ),
      ),
    );
  }
}
