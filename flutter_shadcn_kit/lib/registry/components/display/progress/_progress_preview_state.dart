// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of 'preview.dart';

/// _ProgressPreviewState holds mutable state for the progress implementation.
class _ProgressPreviewState extends State<ProgressPreview> {
  /// Animation/progress setting used by progress transitions.
  double _progress = 33.0;

  /// Builds the widget tree for progress.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 400,
              child: Progress(
                progress: _progress.clamp(0, 100),
                min: 0,
                max: 100,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlineButton(
                  onPressed: () {
                    /// Implements `setState` behavior for progress.
                    setState(() {
                      _progress = (_progress - 10).clamp(0, 100);
                    });
                  },
                  child: const Text('-10%'),
                ),

                const SizedBox(width: 8),

                OutlineButton(
                  onPressed: () {
                    /// Implements `setState` behavior for progress.
                    setState(() {
                      _progress = (_progress + 10).clamp(0, 100);
                    });
                  },
                  child: const Text('+10%'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
