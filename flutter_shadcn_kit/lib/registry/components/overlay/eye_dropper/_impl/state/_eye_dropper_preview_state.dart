// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _EyeDropperPreviewState defines a reusable type for this registry module.
class _EyeDropperPreviewState extends State<EyeDropperPreview> {
  /// Stores `_picked` state/configuration for this implementation.
  Color? _picked;

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return EyeDropperLayer(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Creates a `Container` instance.
              Container(
                width: 140,
                height: 60,
                decoration: BoxDecoration(
                  color: _picked ?? Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
              ),

              /// Creates a `SizedBox` instance.
              const SizedBox(height: 12),

              /// Creates a `Builder` instance.
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      final scope = EyeDropperLayerScope.find(context);
                      final color = await scope.promptPickColor();
                      if (!mounted) return;

                      /// Creates a `setState` instance.
                      setState(() {
                        _picked = color;
                      });
                    },
                    child: const Text('Pick color'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
