// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of 'preview.dart';

/// _DotIndicatorPreviewState holds mutable state for the dot indicator implementation.
class _DotIndicatorPreviewState extends State<DotIndicatorPreview> {
  /// Input parameter used by `_DotIndicatorPreviewState` during rendering and behavior handling.
  int _index = 0;

  /// Builds the widget tree for dot indicator.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DotIndicator(
              index: _index,
              length: 5,
              onChanged: (value) {
                /// Implements `setState` behavior for dot indicator.
                setState(() {
                  _index = value;
                });
              },
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: _index > 0
                      ? () {
                          /// Implements `setState` behavior for dot indicator.
                          setState(() {
                            _index--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),

                Text('Index: $_index'),

                IconButton(
                  onPressed: _index < 4
                      ? () {
                          /// Implements `setState` behavior for dot indicator.
                          setState(() {
                            _index++;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
