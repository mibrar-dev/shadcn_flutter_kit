// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _ColorPickerPreviewState stores and manages mutable widget state.
class _ColorPickerPreviewState extends State<ColorPickerPreview> {
  final ValueNotifier<ColorDerivative> selectedColorNotifier = ValueNotifier(
    ColorDerivative.fromColor(Colors.blue),
  );

  /// Releases resources owned by this state object.
  @override
  void dispose() {
    selectedColorNotifier.dispose();
    super.dispose();
  }

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PrimaryButton(
              onPressed: () {
                showPopover(
                  context: context,
                  alignment: Alignment.topCenter,
                  anchorAlignment: Alignment.bottomCenter,
                  widthConstraint: PopoverConstraint.intrinsic,
                  heightConstraint: PopoverConstraint.intrinsic,
                  offset: const Offset(0, 8),
                  builder: (context) {
                    return ListenableBuilder(
                      listenable: selectedColorNotifier,
                      builder: (context, _) {
                        return SurfaceCard(
                          child: ColorPicker(
                            value: selectedColorNotifier.value,
                            orientation: Axis.horizontal,
                            showAlpha: true,
                            onChanged: (value) {
                              /// Triggers a rebuild after mutating local state.
                              setState(() {
                                selectedColorNotifier.value = value;
                              });
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: const Text('Open Color Picker Popover'),
            ),
            const DensityGap(gapLg),
            PrimaryButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Select Color'),
                      content: ListenableBuilder(
                        listenable: selectedColorNotifier,
                        builder: (context, _) {
                          return ColorPicker(
                            value: selectedColorNotifier.value,
                            orientation: Axis.horizontal,
                            showAlpha: true,
                            onChanged: (value) {
                              /// Triggers a rebuild after mutating local state.
                              setState(() {
                                selectedColorNotifier.value = value;
                              });
                            },
                          );
                        },
                      ),
                      actions: [
                        PrimaryButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Open Color Picker Dialog'),
            ),
          ],
        ),
      ),
    );
  }
}
