// ignore_for_file: duplicate_import, unnecessary_import, unused_import, unnecessary_null_comparison, dead_code, deprecated_member_use, use_null_aware_elements, sort_child_properties_last

part of '../../preview.dart';

/// _StarRatingPreviewState stores and manages mutable widget state.
class _StarRatingPreviewState extends State<StarRatingPreview> {
  /// Current value stored for `_value`.
  double _value = 3.5;

  /// Builds the widget tree for this component state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StarRating(
          value: _value,
          step: 0.5,
          onChanged: (value) {
            /// Triggers a rebuild after mutating local state.
            setState(() {
              _value = value;
            });
          },
        ),
      ),
    );
  }
}
