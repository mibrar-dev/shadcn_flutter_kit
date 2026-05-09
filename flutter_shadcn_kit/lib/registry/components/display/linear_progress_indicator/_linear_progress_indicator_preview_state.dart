// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of 'preview.dart';

/// _LinearProgressIndicatorPreviewState holds mutable state for the linear progress indicator implementation.
class _LinearProgressIndicatorPreviewState
    extends State<LinearProgressIndicatorPreview> {
  double value = 0;

  /// Builds the widget tree for linear progress indicator.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 200, child: LinearProgressIndicator()),

            const DensityGap(gap2xl),

            SizedBox(width: 200, child: LinearProgressIndicator(value: value)),

            const DensityGap(gap2xl),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  onPressed: () {
                    /// Implements `setState` behavior for linear progress indicator.
                    setState(() {
                      value = 0;
                    });
                  },
                  child: const Text('Reset'),
                ),

                const DensityGap(gap2xl),

                PrimaryButton(
                  onPressed: () {
                    /// Implements `setState` behavior for linear progress indicator.
                    setState(() {
                      value = (value + 0.1).clamp(0, 1);
                    });
                  },
                  child: const Text('Increment'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
