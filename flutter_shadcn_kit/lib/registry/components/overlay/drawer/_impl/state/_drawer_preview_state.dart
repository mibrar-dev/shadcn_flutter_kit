// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _DrawerPreviewState defines a reusable type for this registry module.
class _DrawerPreviewState extends State<DrawerPreview> {
  // Sequence of positions to cycle through as drawers are stacked.
  List<OverlayPosition> positions = [
    OverlayPosition.end,
    OverlayPosition.bottom,
    OverlayPosition.start,
  ];

  /// Executes `open` behavior for this component/composite.
  void open(BuildContext context, int count) {
    /// Creates a `openDrawer` instance.
    openDrawer(
      context: context,
      expands: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(48),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// Creates a `Text` instance.
                Text(
                  'Drawer at ${positions[count % positions.length].name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 16),

                /// Creates a `PrimaryButton` instance.
                PrimaryButton(
                  onPressed: () {
                    open(context, count + 1);
                  },
                  child: const Text('Open Another Drawer'),
                ),

                /// Creates a `SizedBox` instance.
                const SizedBox(height: 8),

                /// Creates a `SecondaryButton` instance.
                SecondaryButton(
                  onPressed: () {
                    closeOverlay(context);
                  },
                  child: const Text('Close Drawer'),
                ),
              ],
            ),
          ),
        );
      },
      position: positions[count % positions.length],
    );
  }

  @override
  /// Executes `build` behavior for this component/composite.
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PrimaryButton(
          onPressed: () {
            open(context, 0);
          },
          child: const Text('Open Drawer'),
        ),
      ),
    );
  }
}
