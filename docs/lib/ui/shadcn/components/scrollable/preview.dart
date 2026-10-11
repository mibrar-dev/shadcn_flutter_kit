// Named examples for the `scrollable` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. Each viewport carries its own bounded box because
// the fade is drawn over a measured scrollable.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import 'scrollable.dart';

/// A horizontal strip with edge fades.
Widget _default(BuildContext context) {
  return SizedBox(
    width: 320,
    height: 72,
    child: FadedScrollableViewport(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(12),
          child: Text('Item ${index + 1}'),
        ),
      ),
    ),
  );
}

/// A vertical list with edge fades.
Widget _vertical(BuildContext context) {
  return SizedBox(
    width: 280,
    height: 160,
    child: FadedScrollableViewport(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.all(8),
          child: Text('Row ${index + 1}'),
        ),
      ),
    ),
  );
}

/// Named docs examples for `scrollable`; the first entry is the default.
const List<ComponentPreview> scrollablePreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
  ComponentPreview('Vertical', _vertical),
];
