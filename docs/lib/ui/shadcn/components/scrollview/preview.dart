// Named examples for the `scrollview` component (P6-F3 preview contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle. The surface carries its own bounded box because the
// autoscroll interceptor measures its child.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/theme.dart';
import 'scrollview.dart';

/// A list wrapped in the middle-button autoscroll interceptor.
Widget _default(BuildContext context) {
  final theme = ShadcnTheme.of(context);
  return SizedBox(
    width: 360,
    height: 220,
    child: ScrollViewInterceptor(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            for (int index = 1; index <= 30; index++)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Drag with the middle button · $index'),
              ),
            Gap(theme.spacing.lg),
          ],
        ),
      ),
    ),
  );
}

/// Named docs examples for `scrollview`; the first entry is the default.
const List<ComponentPreview> scrollviewPreviews = <ComponentPreview>[
  ComponentPreview('Default', _default),
];
