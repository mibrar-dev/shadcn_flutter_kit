// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _HsvPreviewState stores and manages mutable widget state.
class _HsvPreviewState extends State<HsvPreview> {
  HSVColor _color = HSVColor.fromColor(Colors.deepPurple);

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HSVColorSlider(
              value: _color,
              sliderType: HSVColorSliderType.hue,
              onChanged: (color) => setState(() => _color = color),
            ),
            const SizedBox(height: 12),
            Container(
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: _color.toColor(),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
