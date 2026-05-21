// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _SwitcherPreviewState defines a reusable type for this registry module.
class _SwitcherPreviewState extends State<SwitcherPreview> {
  /// Stores `_index` state/configuration for this implementation.
  int _index = 0;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 320,
          height: 180,
          child: Switcher(
            index: _index,
            direction: AxisDirection.left,
            onIndexChanged: (value) => setState(() => _index = value),
            children: [
              /// Creates a `Container` instance.
              Container(
                color: Colors.blue.shade100,
                alignment: Alignment.center,
                child: const Text('Page 1'),
              ),

              /// Creates a `Container` instance.
              Container(
                color: Colors.green.shade100,
                alignment: Alignment.center,
                child: const Text('Page 2'),
              ),

              /// Creates a `Container` instance.
              Container(
                color: Colors.orange.shade100,
                alignment: Alignment.center,
                child: const Text('Page 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
