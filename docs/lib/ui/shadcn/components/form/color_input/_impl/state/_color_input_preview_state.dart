// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _ColorInputPreviewState stores and manages mutable widget state.
class _ColorInputPreviewState extends State<ColorInputPreview> {
  ColorDerivative color = ColorDerivative.fromColor(Colors.blue);

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: ColorInput(
                  value: color,
                  orientation: Axis.horizontal,
                  promptMode: PromptMode.popover,
                  onChanged: (value) {
                    /// Triggers a rebuild after mutating local state.
                    setState(() {
                      color = value;
                    });
                  },
                ),
              ),
              const DensityGap(gapLg),
              ColorInput(
                value: color,
                promptMode: PromptMode.dialog,
                dialogTitle: const Text('Select Color'),
                onChanged: (value) {
                  /// Triggers a rebuild after mutating local state.
                  setState(() {
                    color = value;
                  });
                },
                showLabel: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
