// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _ToastPreviewState defines a reusable type for this registry module.
class _ToastPreviewState extends State<ToastPreview> {
  final ToastController _controller = ToastController();

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryButton(
          onPressed: () {
            /// Creates a `_controller.show` instance.
            _controller.show(
              context: context,
              builder: (context) => const Text('Saved successfully'),
            );
          },
          child: const Text('Show Toast'),
        ),
      ),
    );
  }
}
