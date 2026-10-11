// Named examples for the `outlined_container` component (P6-F3 preview
// contract).
//
// One focused demo per example; the first entry is the default. Spacing comes
// from the ambient theme, so the examples follow the selected preset and the
// site light/dark toggle.

import 'package:flutter/widgets.dart';

import '../../foundation/component_preview.dart';
import '../../foundation/gap.dart';
import '../../theme/color_tokens.dart';
import '../../theme/density.dart';
import '../../theme/theme.dart';
import 'outlined_container.dart';

/// Token look: the theme border and card surface at the default radius.
Widget _outlinedContainerDefault(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return SizedBox(
    width: 320,
    child: OutlinedContainer(
      padding: EdgeInsets.all(spacing.lg),
      child: const Text('Outlined container'),
    ),
  );
}

/// A wider radius and denser padding.
Widget _outlinedContainerRounded(BuildContext context) {
  return const SizedBox(
    width: 320,
    child: OutlinedContainer(
      padding: EdgeInsetsDensity.pxAll(20),
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: Text('Rounded corners'),
    ),
  );
}

/// A translucent fill and a backdrop-blurred surface.
Widget _outlinedContainerTranslucent(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const SizedBox(
        width: 320,
        child: OutlinedContainer(
          padding: EdgeInsetsDensity.pxAll(16),
          backgroundColor: ThemedColor.ref(ColorRef.primary),
          surfaceOpacity: 0.12,
          child: Text('Translucent primary fill'),
        ),
      ),
      Gap(spacing.lg),
      const SizedBox(
        width: 320,
        child: OutlinedContainer(
          padding: EdgeInsetsDensity.pxAll(16),
          surfaceBlur: 12,
          surfaceOpacity: 0.6,
          child: Text('Backdrop blur'),
        ),
      ),
    ],
  );
}

/// The dashed outline form.
Widget _outlinedContainerDashed(BuildContext context) {
  final spacing = ShadcnTheme.of(context).spacing;
  return SizedBox(
    width: 320,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DashedContainer(
          child: Padding(
            padding: EdgeInsetsDensity.pxAll(16),
            child: const Text('Dashed container'),
          ),
        ),
        Gap(spacing.lg),
        const DashedLine(),
      ],
    ),
  );
}

/// Named docs examples for `outlined_container`; the first is the default.
const List<ComponentPreview> outlinedContainerPreviews = <ComponentPreview>[
  ComponentPreview('Default', _outlinedContainerDefault),
  ComponentPreview('Rounded', _outlinedContainerRounded),
  ComponentPreview('Translucent', _outlinedContainerTranslucent),
  ComponentPreview('Dashed', _outlinedContainerDashed),
];
