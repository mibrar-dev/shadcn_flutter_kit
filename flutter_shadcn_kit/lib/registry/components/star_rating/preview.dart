// Named examples for the `star_rating` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'star_rating.dart';

void _ignore(double value) {}

/// Interactive rating with half-star steps; owns its value.
class _InteractiveRating extends StatefulWidget {
  const _InteractiveRating();

  @override
  State<_InteractiveRating> createState() => _InteractiveRatingState();
}

class _InteractiveRatingState extends State<_InteractiveRating> {
  double _value = 3.5;

  @override
  Widget build(BuildContext context) {
    return StarRating(
      value: _value,
      onChanged: (double value) => setState(() => _value = value),
    );
  }
}

Widget _default(BuildContext context) => const _InteractiveRating();

/// A non-interactive rating.
Widget _readOnly(BuildContext context) {
  return const StarRating(value: 4);
}

/// A vertical rating.
Widget _vertical(BuildContext context) {
  return const StarRating(
    value: 3,
    direction: Axis.vertical,
    onChanged: _ignore,
  );
}

/// A disabled rating.
Widget _disabled(BuildContext context) {
  return const StarRating(value: 3, enabled: false);
}

/// Named docs examples for `star_rating`; the first entry is the default.
const List<ComponentPreview> starRatingPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Read-only', _readOnly),
  ComponentPreview('Vertical', _vertical),
  ComponentPreview('Disabled', _disabled),
];
